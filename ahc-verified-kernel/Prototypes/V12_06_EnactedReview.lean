/-
  PROTOTYPE — repair for finding V12-06 (v0.12 multi-lens external review).
  NOT part of the audited kernel; NOT counted in Audit.lean.

  Finding V12-06: structural review can be discharged by a label. Any of
  the three `Layer0Output` constructors — which carry no content — exits
  Structural Review to operational. §12.3 says "produced AND enacted"; only
  "produced" is modeled, so a `thresholdRecalibration` token that merely
  raises the threshold until the terminal condition vanishes from
  measurement re-opens emergency authority. Relatedly, an `overdue` breach
  disappears into `spent` when exceedance subsides, carrying no record.

  Repair: (1) review closes only on an ENACTED output that proves both
  enactment and resolution of the terminal condition; (2) the gate retains
  an immutable, monotone breach ledger that resumption never resets.
-/
import AHCKernel.CrisisCap

namespace AHC.Proto
open AHC

/-- An ENACTED constitutional output (repair for V12-06, half one): a
    Layer 0 output that carries a proof it was enacted and that it resolved
    the terminal condition — not a bare token. A recalibration that merely
    redefines the threshold cannot discharge `resolves`, which demands the
    terminal condition be resolved rather than measured away. -/
structure EnactedOutput where
  output           : Layer0Output
  enacted          : Bool
  terminalResolved : Bool
  isEnacted        : enacted = true
  resolves         : terminalResolved = true

/-- Events for the corrected gate: closing carries an `EnactedOutput`. -/
inductive Event' where
  | dayPasses
  | emergencyRequest
  | capTrip
  | layer0 (o : EnactedOutput)

/-- Corrected mode transition: Structural Review opens on a cap trip and
    exits only on an enacted output (which is unconstructible without proof
    of enactment and resolution). -/
def modeStep' : Mode → Event' → Mode
  | .operational, .capTrip => .structuralReview
  | .operational, _        => .operational
  | .structuralReview, .layer0 _ => .operational
  | .structuralReview, _         => .structuralReview

/-- **Q1 (Review Closes Only on Enacted Remediation).** The only event that
    returns the system to operational from Structural Review carries an
    `EnactedOutput`, and every `EnactedOutput` proves both enactment and
    resolution of the terminal condition. An output token with no remedy
    cannot re-open emergency authority. -/
theorem review_closes_only_enacted (e : Event')
    (h : modeStep' .structuralReview e = .operational) :
    ∃ o : EnactedOutput, e = .layer0 o ∧
      o.enacted = true ∧ o.terminalResolved = true := by
  cases e with
  | dayPasses => simp [modeStep'] at h
  | emergencyRequest => simp [modeStep'] at h
  | capTrip => simp [modeStep'] at h
  | layer0 o => exact ⟨o, rfl, o.isEnacted, o.resolves⟩

/-! ## Immutable breach ledger (repair for V12-06, half two) -/

/-- A gate state that RETAINS an immutable breach ledger: `breaches` counts
    cap trips / review breaches and is never reset. Resumption to
    operational does not erase the record. -/
structure LedgerState where
  mode     : Mode
  breaches : Nat

def ledgerStep : LedgerState → Event' → LedgerState
  | ⟨.operational, n⟩,      .capTrip  => ⟨.structuralReview, n + 1⟩  -- record a breach
  | ⟨.structuralReview, n⟩, .layer0 _ => ⟨.operational, n⟩           -- resume; record NOT reset
  | s, _ => s

def ledgerRun : LedgerState → List Event' → LedgerState
  | s, []      => s
  | s, e :: es => ledgerRun (ledgerStep s e) es

/-- **Q2 (The Breach Ledger Is Monotone).** No single step ever lowers the
    breach count: a missed-deadline / cap-trip record can only accumulate. -/
theorem ledger_breaches_monotone (s : LedgerState) (e : Event') :
    s.breaches ≤ (ledgerStep s e).breaches := by
  obtain ⟨m, n⟩ := s
  cases m <;> cases e <;> simp [ledgerStep] <;> omega

/-- **Q3 (The Breach Record Survives Resumption).** Once a breach has been
    recorded, it persists across ANY subsequent sequence of events —
    including resumption to operational when the danger subsides. The
    unresolved-review record cannot be waited out. -/
theorem ledger_breach_persists :
    ∀ (es : List Event') (s : LedgerState), 0 < s.breaches →
      0 < (ledgerRun s es).breaches := by
  intro es
  induction es with
  | nil => intro s h; exact h
  | cons e es ih =>
      intro s h
      exact ih (ledgerStep s e)
        (Nat.lt_of_lt_of_le h (ledger_breaches_monotone s e))

end AHC.Proto
