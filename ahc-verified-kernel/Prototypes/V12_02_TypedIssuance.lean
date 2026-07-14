/-
  PROTOTYPE — repair for finding V12-02 (v0.12 multi-lens external review).
  NOT part of the audited kernel; NOT counted in Audit.lean.

  Finding V12-02: issuance and confirmation are free Boolean inputs.
  `EpInput.issue` enters `pending` with no decay-horizon predicate, no
  Tier-0 evidence object, no sensor alarm; `EpInput.confirm` reaches the
  absorbing `confirmed` with no correlational-evidence certificate. The
  exceedance bridge grounds the HAZARD bit in the measurement layer but
  passes issue/confirm/novel/layer0 through untouched.

  Repair (the X1–X4 pattern, applied to the authorization bits): replace
  the two free Booleans with PROOF-CARRYING typed evidence objects that
  DERIVE the bits, and prove non-fabrication — issuance requires an
  incident-bound, Tier-0-observed trigger whose acute decay horizon is a
  proof field; confirmation requires a Tier-1 certificate whose lineage
  matches the incident. The proven episode machine (E1–E15) is untouched;
  this is the typed provenance layer above its inputs.
-/
import AHCKernel.TieredProtocol

namespace AHC.Proto
open AHC

/-- A proof-carrying issuance trigger. Constructing one requires an
    incident identity, a threshold configuration, an OBSERVED Tier-0
    signal, and — as a PROOF FIELD — that the decay horizon is acute
    (τ_decay < 72h). A trigger for a non-acute horizon, or with no Tier-0
    observation, is unconstructible. -/
structure AcuteTrigger where
  incident      : Nat
  decayHorizon  : Nat
  threshold     : Nat
  tier0Observed : Bool
  acute         : decayHorizon < reviewDeadline
  observed      : tier0Observed = true

/-- A Tier-1 correlational-confirmation certificate. Constructing one
    requires an incident identity, a correlational evidence bit that is
    set, and a lineage field that must match the incident it confirms. -/
structure Tier1Certificate where
  incident      : Nat
  lineage       : Nat
  correlational : Bool
  evidenced     : correlational = true
  sameIncident  : lineage = incident

/-- A typed episode input: the issuance and confirmation bits are DERIVED
    from evidence objects, not supplied raw. Novelty, exceedance, and the
    Layer 0 disposition remain as in the kernel (novelty/dispositions are
    Layer 0 signals; exceedance is grounded separately by X1–X4). -/
structure EvidenceInput where
  trigger    : Option AcuteTrigger
  confirm?   : Option Tier1Certificate
  novel      : Bool
  exceedance : Bool
  layer0     : Option Layer0Disposition

/-- The episode input a typed hour derives: `issue`/`confirm` come from the
    presence of a well-formed evidence object; every other field passes
    through. -/
def EvidenceInput.toEpInput (i : EvidenceInput) : EpInput :=
  { issue      := i.trigger.isSome
    confirm    := i.confirm?.isSome
    novel      := i.novel
    exceedance := i.exceedance
    layer0     := i.layer0 }

/-- **Y1 (Issuance Is Evidence-Backed).** Whenever the derived input issues
    a full PIO, an acute trigger exists: incident-bound, Tier-0-observed,
    with a proven sub-72h decay horizon. Free issuance is unconstructible. -/
theorem issuance_evidence_backed (i : EvidenceInput)
    (h : i.toEpInput.issue = true) :
    ∃ t : AcuteTrigger, i.trigger = some t ∧
      t.tier0Observed = true ∧ t.decayHorizon < reviewDeadline := by
  cases ht : i.trigger with
  | none => simp [EvidenceInput.toEpInput, ht] at h
  | some t => exact ⟨t, ht, t.observed, t.acute⟩

/-- **Y2 (Confirmation Is Evidence-Backed).** Whenever the derived input
    confirms, a Tier-1 certificate exists whose lineage matches its
    incident. A free confirmation bit is unconstructible. -/
theorem confirmation_evidence_backed (i : EvidenceInput)
    (h : i.toEpInput.confirm = true) :
    ∃ c : Tier1Certificate, i.confirm? = some c ∧
      c.correlational = true ∧ c.lineage = c.incident := by
  cases hc : i.confirm? with
  | none => simp [EvidenceInput.toEpInput, hc] at h
  | some c => exact ⟨c, hc, c.evidenced, c.sameIncident⟩

/-- **Y3 (No Trigger, No Issuance).** Absent a proof-carrying trigger the
    derived input cannot issue — the free-issuance path is closed at the
    type level. -/
theorem no_trigger_no_issuance (i : EvidenceInput) (h : i.trigger = none) :
    i.toEpInput.issue = false := by
  simp [EvidenceInput.toEpInput, h]

/-- **Y4 (No Trigger Cannot Move the Machine off `idle`).** Connecting to
    the kernel machine: from `idle`, an evidence input with no trigger
    leaves the subgraph in `idle` — the acute-harm / Tier-0 gate is now a
    precondition of ever entering `pending`. -/
theorem idle_stays_without_trigger (i : EvidenceInput) (h : i.trigger = none) :
    estep .idle i.toEpInput = .idle := by
  have hb := no_trigger_no_issuance i h
  simp [estep, hb]

end AHC.Proto
