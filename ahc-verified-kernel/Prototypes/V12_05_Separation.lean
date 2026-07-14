/-
  PROTOTYPE — repair for finding V12-05 (v0.12 multi-lens external review).
  NOT part of the audited kernel; NOT counted in Audit.lean.

  Finding V12-05: Layer 0 is an unformalized sovereign. The kernel is strict
  AFTER Layer 0 has spoken but deferential about how it reaches its
  conclusions: the same body may propose an action, certify its
  reversibility, attest novelty, bind the threshold, mark criticality, and
  review its own failure. No separation-of-powers rule prevents this.

  Repair (the "incompatible powers" theorem the sycophancy-to-power lens
  called for): formalize the GOVERNANCE TOPOLOGY. Roles are typed; an
  `Allocation` assigns each role to an actor and can only be constructed by
  discharging incompatibility obligations. The CONTENT of judgment stays
  human; WHO may make which judgment becomes a proved constraint. This
  models allocation, not adjudication — a scaffold for standing, quorum,
  and appeal, which a fuller version would add.
-/

namespace AHC.Proto

/-- The contestable judgments the framework currently routes to a single
    Layer 0 zone, split into distinct roles. -/
inductive Role where
  | proposer                -- proposes an intervention
  | reversibilityCertifier  -- certifies the intervention reversible
  | thresholdBinder         -- binds the danger threshold θ
  | noveltyAttester         -- attests a claim materially novel
  | criticalityMarker       -- marks which claims are contestation-critical
  | reviewer                -- adjudicates challenges / structural review
deriving DecidableEq, Repr

/-- An institutional body, abstract. -/
abbrev Actor := Nat

/-- A governance allocation: which actor holds each role, together with the
    constitutional INCOMPATIBILITY obligations. An allocation that lets one
    body both act and judge its own action is unconstructible. -/
structure Allocation where
  holder : Role → Actor
  -- the body proposing an intervention cannot certify its reversibility
  propose_not_certify : holder .proposer ≠ holder .reversibilityCertifier
  -- the body binding the threshold cannot adjudicate challenges to it
  bind_not_review     : holder .thresholdBinder ≠ holder .reviewer
  -- the body attesting novelty cannot alone review the episode it opens
  attest_not_review   : holder .noveltyAttester ≠ holder .reviewer
  -- the body marking criticality cannot be the sole reviewer of omissions
  mark_not_review     : holder .criticalityMarker ≠ holder .reviewer

/-- **Sep1 (No Self-Certification).** Under any valid allocation, the body
    that proposes an intervention is not the body that certifies its
    reversibility. The legitimacy-amplification path the sycophancy-to-power
    lens identified — an authority laundering its own action into
    "certified reversible" — is unconstructible. -/
theorem no_self_certification (A : Allocation) :
    A.holder .proposer ≠ A.holder .reversibilityCertifier :=
  A.propose_not_certify

/-- **Sep2 (No Self-Review).** No body may bind a threshold, attest novelty,
    or mark criticality AND be the reviewer who adjudicates challenges to
    that same judgment. -/
theorem no_self_review (A : Allocation) :
    A.holder .thresholdBinder ≠ A.holder .reviewer ∧
    A.holder .noveltyAttester ≠ A.holder .reviewer ∧
    A.holder .criticalityMarker ≠ A.holder .reviewer :=
  ⟨A.bind_not_review, A.attest_not_review, A.mark_not_review⟩

/-- Non-vacuity: a fully separated allocation (six distinct bodies) exists,
    so the incompatibility obligations are jointly satisfiable — the repair
    does not accidentally make governance unconstructible. -/
def separatedAllocation : Allocation where
  holder r := match r with
    | .proposer               => 0
    | .reversibilityCertifier => 1
    | .thresholdBinder        => 2
    | .noveltyAttester        => 3
    | .criticalityMarker      => 4
    | .reviewer               => 5
  propose_not_certify := by decide
  bind_not_review     := by decide
  attest_not_review   := by decide
  mark_not_review     := by decide

end AHC.Proto
