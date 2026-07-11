/-
  Phase 2 DRAFT — Crisis Cap × Structural Review: Composed Semantics
  (Companion A §12.3; AHC v3.1 §10.3)
  Addresses ASSESSMENT.md finding AHC-P1-001 (F-2 / D-1, routed F-4).

  The Phase 1 kernel proves the cap arithmetic over `Valid` traces
  (C1–C3) and the review gate over a separate `Mode`/`Event` automaton
  (C4–C6), but no theorem joins them: nothing forces a cap trip when the
  window saturates, and nothing ties "grants" to trace days. This module
  supplies the join: ONE machine, stepped once per day, in which the
  emergency-day decision, the cap trip, and the Structural Review gate
  are the same transition function, and `capTrip` is DERIVED from the
  window arithmetic rather than a free input.

    G1  dayStep_valid / dayRun_valid — every reachable trace of the
        composed machine is protocol-valid (`Valid`), so all Phase 1 cap
        theorems (C1–C3) apply to it verbatim
    G2  review_day_never_emergency   — while Structural Review is open,
        the day appended to the trace is `false`, for EVERY input —
        including the day a Layer 0 output is enacted
    G3  review_exit_iff_output       — review closes exactly on a
        Layer 0 output: no other input, and not time, exits it
    G4  trip_forced                  — the trip is not discretionary: an
        operational system facing continued exceedance with a saturated
        window MUST enter Structural Review, and grants nothing that day
    G5  review_run / review_gate_composed — across any output-free span,
        review persists and the trace extension is all-`false`: §12.3's
        sentence, now about the SAME trace the cap counts
    G6  emergency_day_provenance     — inversion: every emergency day in
        the composed system was individually authorized — operational
        mode, an actual request, and the rolling window strictly below
        the cap. No path grants a day any other way
    G7  composed_cap_safety / composed_no_permanent_emergency — the
        Phase 1 bounds, restated as properties of the composed machine
        from its initial state: the cap holds in every window at every
        offset, and no run of consecutive emergency days exceeds T_cap

  Together these answer F-2: in the composed semantics there is no gaming
  path through the interaction — an emergency day during review is not
  merely ungranted, it is unconstructible (G2), and the trip that opens
  review is forced by the same arithmetic the cap theorems bound (G4).

  Modeling choices (per the framework's norm):
  · One step = one day. A `DayInput` carries: whether emergency authority
    is requested, whether terminal threshold exceedance continues, and
    the Layer 0 output enacted that day, if any.
  · "The cap binds" is read as the failure of the Phase 1 renewal
    condition: `T_cap ≤ load (W−1) trace` — i.e. no further emergency
    day is authorizable in the current window (strict reading, D-3).
  · The trip condition is `exceedance ∧ cap binds` (§12.3: "the cap
    trips while terminal threshold exceedance continues"). Exceedance is
    a free Boolean input here; its derivation from the ATG is Module 3
    territory and out of scope.
  · The enacting day of a Layer 0 output returns the system to
    operational mode but itself grants nothing (G2): resumption is
    possible only from the NEXT day, under the window condition —
    "cannot resume until one of these outputs is produced and enacted."

  Adoption path: this machine refines (does not replace) the Phase 1
  `Event` automaton: `capTrip` corresponds to the derived trip, `grants`
  to the `true`-day branch. On adoption it belongs in Module 2, with
  C4–C6 retired into corollaries of G2/G3/G5. No new mechanism is
  introduced (Principle 19.2): every transition verifies a sentence
  already in §12.3.

  Status: DRAFT for Phase 2 review. Not part of the circulated Phase 1
  packet; the packet's source digest is unchanged by this file.

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-11.
-/
import AHCKernel.CrisisCap

namespace AHC.Phase2

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

end AHC.Phase2
