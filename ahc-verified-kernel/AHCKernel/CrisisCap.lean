/-
  AHC Verified Constitutional Kernel — Module 2
  Crisis Frequency Cap & Structural Review Gate  (Companion A §12.3)
  Axiom II — Thermodynamic Limit of Iteration     (AHC v3.1 §4.2)

  Machine-checked invariants of the emergency-authority layer:

    C1  window_head_bound        — the current rolling window never carries
                                   more than T_cap emergency days
    C2  rolling_window_bound     — same bound for EVERY window in the
                                   trace's history, at every offset
    C3  no_permanent_emergency   — emergency authority cannot run for more
                                   than T_cap consecutive days, ever
    C4  no_emergency_in_review   — no event grants emergency authority
                                   while Structural Review is open
    C5  review_absorbing         — Structural Review cannot be exited by
                                   the passage of time or by renewed
                                   requests; only an explicit Layer 0
                                   constitutional output closes it
    C6  review_gate              — combined: across any span of events
                                   containing no Layer 0 output, a system
                                   in Structural Review grants no
                                   emergency authority at any point
    A2a axiomII_dichotomy        — every episode is exactly one of:
                                   reversibility-claim-valid or locally
                                   terminal; exhaustive and exclusive

  Composed semantics (adopted in v0.2 from Phase 1 review, finding
  AHC-P1-001) — ONE daily-step machine joining the Valid trace and the
  Structural Review automaton, with the cap trip DERIVED from the window
  arithmetic rather than taken as a free input:

    G1  dayStep_valid / dayRun_valid — every reachable trace of the
        composed machine is protocol-valid, so C1–C3 apply to it verbatim
    G2  review_day_never_emergency   — in review, the appended day is
        `false` for EVERY input: an emergency day during review is
        unconstructible
    G3  review_exit_iff_output       — review closes exactly on a Layer 0
        output (C5, as an iff)
    G4  trip_forced                  — operational + continued exceedance
        + saturated window MUST trip into review; the trip is arithmetic,
        not discretion
    G5  review_run / review_gate_composed — across any output-free span,
        review persists and the trace extension is all-`false`
    G6  emergency_day_provenance     — inversion: every emergency day was
        individually authorized (operational ∧ requested ∧ window
        strictly below cap); no other path exists
    G7  composed_cap_safety / composed_no_permanent_emergency — the
        Phase 1 bounds restated of the composed machine's initial state

  Modeling choices (stated, per the framework's own norm of separating
  the contestable normative layer from the formal one):

  · Time is discretized in days. A trace is a `List Bool`, most recent day
    first; `true` = emergency authority active that day.
  · The renewal condition is read strictly: a new emergency day is
    authorized only if, INCLUDING that day, the rolling window of W days
    contains at most T_cap emergency days. (The spec text "unavailable
    when active more than T_cap days" admits an off-by-one reading; the
    strict reading is taken, and is the conservative one.)
  · `Cap.cap_lt_window` carries T_cap < W as a proof obligation: a cap
    parameterization in which the cap can never bind is unconstructible.
    Spec values: W = 730 (24 months), T_cap = 180.
  · The Structural Review gate is modeled as a mode automaton whose ONLY
    exit transitions are the three Layer 0 outputs named in §12.3.
  · For G1–G7: one step = one day; a `DayInput` carries whether emergency
    authority is requested, whether terminal threshold exceedance
    continues, and the Layer 0 output enacted that day, if any. "The cap
    binds" is the failure of the renewal condition (T_cap ≤ load (W−1)
    trace); the trip condition is exceedance ∧ cap-binds (§12.3).
    Exceedance is a free Boolean input; its derivation from the ATG is
    Module 3 territory. The enacting day of a Layer 0 output returns the
    system to operational but itself grants nothing: resumption is
    possible only from the NEXT day, under the window condition.

  Scope disclaimer: these proofs verify the specification, not the world.

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-11 (v0.2).
-/

namespace AHC

/-! ## Windowed load -/

/-- `load n t` counts the emergency days among the `n` most recent days of
    trace `t`. Self-contained recursive definition (no Mathlib). -/
def load : Nat → List Bool → Nat
  | _, [] => 0
  | 0, _ :: _ => 0
  | n + 1, true :: t => 1 + load n t
  | n + 1, false :: t => load n t

/-- Counting over a longer window never decreases the count. -/
theorem load_mono (t : List Bool) : ∀ {m n : Nat}, m ≤ n → load m t ≤ load n t := by
  induction t with
  | nil =>
      intro m n _
      simp [load]
  | cons b t ih =>
      intro m n hmn
      cases m with
      | zero =>
          cases b <;> simp only [load] <;> exact Nat.zero_le _
      | succ m' =>
          cases n with
          | zero => omega
          | succ n' =>
              have hmn' : m' ≤ n' := by omega
              cases b with
              | true =>
                  simp only [load]
                  have := ih hmn'
                  omega
              | false =>
                  simp only [load]
                  exact ih hmn'

/-! ## Protocol-valid traces -/

/-- Cap parameters. `cap_lt_window` is constitutive: it is impossible to
    construct a `Cap` whose cap cannot bind within its own window. -/
structure Cap where
  W    : Nat          -- rolling window length in days (spec: 730)
  Tcap : Nat          -- maximum emergency days within the window (spec: 180)
  cap_lt_window : Tcap < W

/-- A trace is protocol-valid when every emergency day was authorized
    under the rolling-window condition at the moment it occurred. -/
inductive Valid (p : Cap) : List Bool → Prop
  | nil  : Valid p []
  | calm {t : List Bool} :
      Valid p t → Valid p (false :: t)
  | emergency {t : List Bool} :
      Valid p t → load (p.W - 1) t < p.Tcap → Valid p (true :: t)

/-- Validity is preserved by discarding the most recent day. -/
theorem Valid.tail {p : Cap} : ∀ {b : Bool} {t : List Bool},
    Valid p (b :: t) → Valid p t := by
  intro b t h
  cases h with
  | calm h => exact h
  | emergency h _ => exact h

/-- Validity is preserved by discarding any number of recent days. -/
theorem Valid.drop {p : Cap} (i : Nat) : ∀ {t : List Bool},
    Valid p t → Valid p (t.drop i) := by
  induction i with
  | zero => intro t h; simpa using h
  | succ i ih =>
      intro t h
      cases t with
      | nil => simpa using h
      | cons b t =>
          simp only [List.drop_succ_cons]
          exact ih h.tail

/-! ## The cap theorems -/

/-- **C1 (Head Window Bound).** In any protocol-valid trace, the current
    rolling window contains at most `T_cap` emergency days. -/
theorem window_head_bound (p : Cap) : ∀ {t : List Bool},
    Valid p t → load p.W t ≤ p.Tcap := by
  intro t hv
  induction hv with
  | nil => simp [load]
  | @calm t hv ih =>
      cases hW : p.W with
      | zero =>
          have := p.cap_lt_window
          omega
      | succ n =>
          rw [hW] at ih
          simp only [load]
          have hmono := load_mono t (show n ≤ n + 1 by omega)
          omega
  | @emergency t hv hload ih =>
      cases hW : p.W with
      | zero =>
          have := p.cap_lt_window
          omega
      | succ n =>
          have hn' : p.W - 1 = n := by omega
          rw [hn'] at hload
          simp only [load]
          omega

/-- **C2 (Rolling Window Bound).** The cap holds not only for the current
    window but for every window in the trace's history: at every offset
    `i`, the `W` days preceding that point contain at most `T_cap`
    emergency days. The cap cannot have been violated in the past of a
    valid present. -/
theorem rolling_window_bound (p : Cap) {t : List Bool}
    (hv : Valid p t) (i : Nat) : load p.W (t.drop i) ≤ p.Tcap :=
  window_head_bound p (hv.drop i)

/-- A block of `k` consecutive emergency days contributes at least `k` to
    any window of length `n ≥ k`, whatever follows the block. -/
theorem load_run_le (rest : List Bool) : ∀ {k n : Nat}, k ≤ n →
    k ≤ load n (List.replicate k true ++ rest) := by
  intro k
  induction k with
  | zero => intro n _; exact Nat.zero_le _
  | succ k ih =>
      intro n hkn
      cases n with
      | zero => omega
      | succ n' =>
          simp only [List.replicate_succ, List.cons_append, load]
          have := ih (n := n') (by omega)
          show k + 1 ≤ 1 + load n' (List.replicate k true ++ rest)
          omega

/-- Splitting a block of repeated days (self-contained; no Mathlib). -/
theorem replicate_add' {α : Type} (a : α) : ∀ (m n : Nat),
    List.replicate (m + n) a = List.replicate m a ++ List.replicate n a := by
  intro m n
  induction m with
  | zero => simp
  | succ m ih =>
      rw [show m + 1 + n = (m + n) + 1 by omega]
      simp only [List.replicate_succ, List.cons_append]
      rw [ih]

/-- **C3 (No Permanent Emergency).** In any protocol-valid trace, emergency
    authority cannot have been active for more than `T_cap` consecutive
    days. This holds for ANY continuation `rest` and ANY history: there is
    no path through the protocol on which the exception becomes the rule.
    With spec values, no emergency may exceed 180 consecutive days. -/
theorem no_permanent_emergency (p : Cap) {k : Nat} {rest : List Bool}
    (hv : Valid p (List.replicate k true ++ rest)) : k ≤ p.Tcap := by
  cases Nat.lt_or_ge p.Tcap k with
  | inr h => exact h
  | inl h =>
      exfalso
      have hsplit : List.replicate k true
          = List.replicate (p.Tcap + 1) true
            ++ List.replicate (k - (p.Tcap + 1)) true := by
        rw [← replicate_add']
        congr 1
        omega
      rw [hsplit, List.append_assoc] at hv
      have hb := window_head_bound p hv
      have hr := load_run_le
        (List.replicate (k - (p.Tcap + 1)) true ++ rest)
        (k := p.Tcap + 1) (n := p.W)
        (by have := p.cap_lt_window; omega)
      omega

/-! ## Structural Review gate (§12.3)

When the cap trips while terminal threshold exceedance continues, the
system escalates to the Structural Review Protocol. §12.3: "Emergency
authority cannot resume until one of these outputs is produced and
enacted." We model the mode automaton and prove that sentence. -/

/-- The three Layer 0 constitutional outputs that can close a Structural
    Review — the ONLY three (§12.3). -/
inductive Layer0Output where
  | remediationPlan
  | amendmentProcess
  | thresholdRecalibration
deriving DecidableEq, Repr

/-- System modes. -/
inductive Mode where
  | operational
  | structuralReview
deriving DecidableEq, Repr

/-- Events visible to the gate. -/
inductive Event where
  | dayPasses                    -- time passes; no constitutional output
  | emergencyRequest             -- a request to (re)activate emergency authority
  | capTrip                      -- rolling-window cap exceeded under exceedance
  | layer0 (o : Layer0Output)    -- a Layer 0 constitutional output is enacted
deriving DecidableEq, Repr

/-- Mode transition. Review opens on a cap trip; the only transitions out
    of review are the three Layer 0 outputs. -/
def modeStep : Mode → Event → Mode
  | .operational, .capTrip => .structuralReview
  | .operational, _ => .operational
  | .structuralReview, .layer0 _ => .operational
  | .structuralReview, _ => .structuralReview

/-- Whether an event grants emergency authority in a given mode. In
    operational mode, requests are grantable subject to the rolling-window
    condition (`Valid` above); in review, nothing grants. -/
def grants : Mode → Event → Bool
  | .operational, .emergencyRequest => true
  | _, _ => false

/-- Run the gate over a sequence of events. -/
def modeRun : Mode → List Event → Mode
  | m, [] => m
  | m, e :: es => modeRun (modeStep m e) es

/-- **C4 (No Emergency in Review).** No event of any kind grants emergency
    authority while Structural Review is open — not a fresh cap trip, not
    a renewed request, not the passage of time. -/
theorem no_emergency_in_review :
    ∀ e : Event, grants .structuralReview e = false := by
  intro e
  cases e <;> rfl

/-- **C5 (Review Is Absorbing Without Output).** A Structural Review
    survives any sequence of events that contains no Layer 0 output. Time
    does not close it; repetition does not wear it down; only the
    constitutional process ends it. -/
theorem review_absorbing :
    ∀ (es : List Event), (∀ e ∈ es, ∀ o, e ≠ .layer0 o) →
      modeRun .structuralReview es = .structuralReview := by
  intro es
  induction es with
  | nil => intro _; rfl
  | cons e es ih =>
      intro hno
      have hstep : modeStep .structuralReview e = .structuralReview := by
        cases e with
        | layer0 o => exact absurd rfl (hno _ (List.mem_cons_self ..) o)
        | dayPasses => rfl
        | emergencyRequest => rfl
        | capTrip => rfl
      simp only [modeRun, hstep]
      exact ih (fun e' he' o => hno e' (List.mem_cons_of_mem e he') o)

/-- Membership in a prefix implies membership in the list
    (self-contained; no Mathlib). -/
theorem mem_of_mem_take' {α : Type} {a : α} :
    ∀ {n : Nat} {l : List α}, a ∈ l.take n → a ∈ l := by
  intro n
  induction n with
  | zero =>
      intro l h
      simp at h
  | succ n ih =>
      intro l h
      cases l with
      | nil => simp at h
      | cons b t =>
          simp only [List.take_succ_cons] at h
          cases h with
          | head => exact List.mem_cons_self ..
          | tail _ h => exact List.mem_cons_of_mem _ (ih h)

/-- **C6 (Review Gate).** §12.3's sentence as a theorem: starting from an
    open Structural Review, across ANY span of events containing no
    Layer 0 output, emergency authority is never granted — not at the
    start, not at any intermediate point, not at the end. -/
theorem review_gate :
    ∀ (es : List Event), (∀ e ∈ es, ∀ o, e ≠ .layer0 o) →
      ∀ (i : Nat) (e : Event),
        grants (modeRun .structuralReview (es.take i)) e = false := by
  intro es hno i e
  have htake : ∀ e' ∈ es.take i, ∀ o, e' ≠ .layer0 o :=
    fun e' he' o => hno e' (mem_of_mem_take' he') o
  rw [review_absorbing (es.take i) htake]
  exact no_emergency_in_review e

/-! ## Axiom II — Thermodynamic Limit of Iteration (§4.2)

"Democratic iteration is only a legitimate corrective when it can complete
before the harm becomes irreversible." Formally: if τ_response > τ_decay,
the reversibility claim is nullified and the system is locally terminal
for the affected subgraph. -/

/-- A harm episode: the system's response latency and the harm's
    irreversibility horizon, in common time units. -/
structure Episode where
  response : Nat   -- τ_response
  decay    : Nat   -- τ_decay

/-- The reversibility claim holds: correction completes within the
    irreversibility horizon. -/
def reversibilityClaimHolds (e : Episode) : Prop := e.response ≤ e.decay

/-- The system is locally terminal for the affected subgraph: the harm
    outruns the correction. -/
def locallyTerminal (e : Episode) : Prop := e.decay < e.response

/-- **A2a (Axiom II Dichotomy).** Every episode is exactly one of the two:
    the classification is exhaustive (no episode escapes evaluation) and
    exclusive (no episode can be spun as both corrected-in-time and
    terminal). "The system corrected itself eventually" and "the harm was
    irreversible" cannot both be true of the same episode — which is the
    formal content of §4.2's rejection of that sentence as a defense. -/
theorem axiomII_dichotomy (e : Episode) :
    (reversibilityClaimHolds e ∨ locallyTerminal e)
    ∧ ¬(reversibilityClaimHolds e ∧ locallyTerminal e) := by
  constructor
  · cases Nat.lt_or_ge e.decay e.response with
    | inl h => exact Or.inr h
    | inr h => exact Or.inl h
  · intro h
    have h1 : e.response ≤ e.decay := h.1
    have h2 : e.decay < e.response := h.2
    omega

/-! ## Composed semantics: cap × review, one machine (§12.3) — adopted v0.2

The theorems above prove the cap arithmetic over `Valid` traces (C1–C3)
and the review gate over a separate automaton (C4–C6). The machine below
joins them: the emergency-day decision, the cap trip, and the Structural
Review gate are one transition function, and the trip is derived from the
same window arithmetic the cap theorems bound. -/

/-- One day's inputs to the composed machine. -/
structure DayInput where
  requested  : Bool                 -- emergency authority requested today
  exceedance : Bool                 -- terminal threshold exceedance continues
  output     : Option Layer0Output  -- Layer 0 output enacted today, if any
deriving DecidableEq, Repr

/-- Composed system state: the review mode AND the day trace the cap
    counts — the two halves Phase 1 kept separate. -/
structure SysState where
  mode  : Mode
  trace : List Bool
deriving DecidableEq, Repr

/-- One day of the composed system.

    In review: only a Layer 0 output exits, and the day is `false`
    regardless. Operationally: a request is granted iff the rolling
    window strictly admits it (the Phase 1 renewal condition); a
    saturated window under continued exceedance forces the trip;
    otherwise a calm day passes. -/
def dayStep (p : Cap) (s : SysState) (i : DayInput) : SysState :=
  match s.mode with
  | .structuralReview =>
      match i.output with
      | some _ => ⟨.operational, false :: s.trace⟩
      | none   => ⟨.structuralReview, false :: s.trace⟩
  | .operational =>
      if i.requested ∧ load (p.W - 1) s.trace < p.Tcap then
        ⟨.operational, true :: s.trace⟩
      else if i.exceedance ∧ p.Tcap ≤ load (p.W - 1) s.trace then
        ⟨.structuralReview, false :: s.trace⟩
      else
        ⟨.operational, false :: s.trace⟩

/-- Run the composed machine over a sequence of daily inputs. -/
def dayRun (p : Cap) : SysState → List DayInput → SysState
  | s, [] => s
  | s, i :: is => dayRun p (dayStep p s i) is

/-! ## G1 — the composed machine only builds protocol-valid traces -/

/-- **G1a (Step Soundness).** One composed step preserves protocol
    validity of the trace: the machine's `true` branch carries exactly
    the evidence `Valid.emergency` demands. -/
theorem dayStep_valid (p : Cap) (s : SysState) (i : DayInput)
    (hv : Valid p s.trace) : Valid p (dayStep p s i).trace := by
  cases hm : s.mode with
  | structuralReview =>
      cases ho : i.output with
      | some o => simp only [dayStep, hm, ho]; exact hv.calm
      | none => simp only [dayStep, hm, ho]; exact hv.calm
  | operational =>
      by_cases h1 : i.requested ∧ load (p.W - 1) s.trace < p.Tcap
      · simp only [dayStep, hm, if_pos h1]
        exact hv.emergency h1.2
      · by_cases h2 : i.exceedance ∧ p.Tcap ≤ load (p.W - 1) s.trace
        · simp only [dayStep, hm, if_neg h1, if_pos h2]
          exact hv.calm
        · simp only [dayStep, hm, if_neg h1, if_neg h2]
          exact hv.calm

/-- **G1 (Run Soundness).** Every trace the composed machine can reach
    from a valid trace is valid — so C1 (`window_head_bound`),
    C2 (`rolling_window_bound`) and C3 (`no_permanent_emergency`) hold
    of the composed system with no further proof. -/
theorem dayRun_valid (p : Cap) :
    ∀ (is : List DayInput) (s : SysState), Valid p s.trace →
      Valid p (dayRun p s is).trace := by
  intro is
  induction is with
  | nil => intro s hv; exact hv
  | cons i is ih =>
      intro s hv
      exact ih (dayStep p s i) (dayStep_valid p s i hv)

/-! ## G2–G3 — review, joined to the trace -/

/-- **G2 (No Emergency Day in Review).** While Structural Review is
    open, the day appended to the trace is `false` for every possible
    input — including the day an exiting Layer 0 output is enacted. In
    the composed semantics an emergency day during review is not merely
    ungranted; it is unconstructible. -/
theorem review_day_never_emergency (p : Cap) (s : SysState) (i : DayInput)
    (hm : s.mode = .structuralReview) :
    (dayStep p s i).trace = false :: s.trace := by
  cases ho : i.output with
  | some o => simp [dayStep, hm, ho]
  | none => simp [dayStep, hm, ho]

/-- **G3 (Review Exits Exactly on Output).** From open review, the next
    mode is operational iff the day carried a Layer 0 output. Time,
    requests, and further trips neither close review nor keep a produced
    output from closing it. (C5, as an iff, on the composed machine.) -/
theorem review_exit_iff_output (p : Cap) (s : SysState) (i : DayInput)
    (hm : s.mode = .structuralReview) :
    (dayStep p s i).mode = .operational ↔ i.output ≠ none := by
  cases ho : i.output with
  | some o => simp [dayStep, hm, ho]
  | none => simp [dayStep, hm, ho]

/-! ## G4 — the trip is forced, by the cap's own arithmetic -/

/-- **G4 (Trip Forced).** An operational system facing continued
    exceedance with a saturated window — `T_cap ≤ load (W−1) trace`,
    the exact failure of the renewal condition — enters Structural
    Review on that day and grants nothing. The trip is a consequence of
    the window arithmetic, not a discretionary event: the `capTrip` the
    Phase 1 automaton took as a free input is here derived. -/
theorem trip_forced (p : Cap) (s : SysState) (i : DayInput)
    (hm : s.mode = .operational) (hx : i.exceedance = true)
    (hsat : p.Tcap ≤ load (p.W - 1) s.trace) :
    dayStep p s i = ⟨.structuralReview, false :: s.trace⟩ := by
  have h1 : ¬(i.requested ∧ load (p.W - 1) s.trace < p.Tcap) := by
    intro h
    have := h.2
    omega
  have h2 : i.exceedance ∧ p.Tcap ≤ load (p.W - 1) s.trace := ⟨hx, hsat⟩
  simp only [dayStep, hm, if_neg h1, if_pos h2]

/-! ## G5 — §12.3's sentence, about the trace the cap counts -/

/-- **G5a (Review Run).** Across any span of days containing no Layer 0
    output, an open review stays open and the trace extension is
    all-`false`: the mode claim (C5) and the day-by-day claim are one
    statement about one machine. -/
theorem review_run (p : Cap) :
    ∀ (is : List DayInput) (t : List Bool),
      (∀ i ∈ is, i.output = none) →
      dayRun p ⟨.structuralReview, t⟩ is
        = ⟨.structuralReview, List.replicate is.length false ++ t⟩ := by
  intro is
  induction is with
  | nil => intro t _; simp [dayRun]
  | cons i is ih =>
      intro t hno
      have hout : i.output = none := hno i (List.mem_cons_self ..)
      have hstep : dayStep p ⟨.structuralReview, t⟩ i
          = ⟨.structuralReview, false :: t⟩ := by
        simp [dayStep, hout]
      simp only [dayRun, hstep]
      rw [ih (false :: t) (fun j hj => hno j (List.mem_cons_of_mem i hj))]
      simp only [List.length_cons]
      rw [replicate_add' false is.length 1]
      simp [List.append_assoc]

/-- **G5 (Composed Review Gate).** C6, upgraded from "`grants` is false"
    to "the trace itself records no emergency day": at every prefix of
    an output-free span from open review, the trace extension is
    entirely `false`. -/
theorem review_gate_composed (p : Cap) (t : List Bool) (is : List DayInput)
    (hno : ∀ i ∈ is, i.output = none) (j : Nat) :
    (dayRun p ⟨.structuralReview, t⟩ (is.take j)).trace
      = List.replicate (is.take j).length false ++ t := by
  rw [review_run p (is.take j) t (fun i hi => hno i (mem_of_mem_take' hi))]

/-! ## G6 — provenance: every emergency day is individually authorized -/

/-- **G6 (Emergency Day Provenance).** Inversion of the machine: if a
    composed step appended an emergency day, then the system was
    operational, authority was actually requested, and the rolling
    window sat strictly below the cap. There is no other path to a
    `true` day — which is the composed answer to F-2's gaming question. -/
theorem emergency_day_provenance (p : Cap) (s : SysState) (i : DayInput)
    (h : (dayStep p s i).trace = true :: s.trace) :
    s.mode = .operational ∧ i.requested = true
      ∧ load (p.W - 1) s.trace < p.Tcap := by
  cases hm : s.mode with
  | structuralReview =>
      cases ho : i.output with
      | some o => simp [dayStep, hm, ho] at h
      | none => simp [dayStep, hm, ho] at h
  | operational =>
      by_cases h1 : i.requested ∧ load (p.W - 1) s.trace < p.Tcap
      · exact ⟨rfl, h1.1, h1.2⟩
      · by_cases h2 : i.exceedance ∧ p.Tcap ≤ load (p.W - 1) s.trace
        · simp [dayStep, hm, if_neg h1, if_pos h2] at h
        · simp [dayStep, hm, if_neg h1, if_neg h2] at h

/-! ## G7 — the Phase 1 bounds, inherited by the composed machine -/

/-- **G7a (Composed Cap Safety).** From the initial state, every window
    at every offset of every reachable trace carries at most `T_cap`
    emergency days: C1 and C2, now as one theorem about the machine that
    also enforces the review gate. -/
theorem composed_cap_safety (p : Cap) (is : List DayInput) (j : Nat) :
    load p.W ((dayRun p ⟨.operational, []⟩ is).trace.drop j) ≤ p.Tcap :=
  rolling_window_bound p (dayRun_valid p is ⟨.operational, []⟩ Valid.nil) j

/-- **G7b (Composed No Permanent Emergency).** No reachable trace of the
    composed machine begins with more than `T_cap` consecutive emergency
    days: C3, inherited through G1. -/
theorem composed_no_permanent_emergency (p : Cap) (is : List DayInput)
    {k : Nat} {rest : List Bool}
    (h : (dayRun p ⟨.operational, []⟩ is).trace
          = List.replicate k true ++ rest) :
    k ≤ p.Tcap := by
  have hv := dayRun_valid p is ⟨.operational, []⟩ Valid.nil
  rw [h] at hv
  exact no_permanent_emergency p hv

end AHC
