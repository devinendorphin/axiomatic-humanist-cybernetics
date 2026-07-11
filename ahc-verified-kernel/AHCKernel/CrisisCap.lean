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

  Scope disclaimer: these proofs verify the specification, not the world.

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-11.
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

end AHC
