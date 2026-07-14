/-
  AHC Verified Constitutional Kernel — Module 5
  Seam Ledger: Contested Attestation Ledger  (imported machinery of the
  Veriticide General Ledger — Documentation & Standing Protocol v0.1;
  Provenance Grading & Corpus-Absorption Protocol 2026-07-06; case-file
  grammar cases/*/00..05)

  ORIGIN AND SCOPE. This module imports the *machinery* of the Veriticide
  General Ledger, never its corpus. The case files, the Convention's named
  parties, and the "one mechanism" structural-identity claim stay in that
  repository; Module 5 is a neutral formal object citing it as origin. The
  two repositories cross-reference; they do not merge.

  WHAT THIS MODULE DOES, AND DOES NOT, GUARANTEE. The v0.12 kernel is
  robust against MALFORMED inputs. It is not robust against WELL-TYPED
  LIES from legitimate authorities: its trusted inputs — the episode
  signals issue/confirm/novel, the danger threshold, certificate
  validity, the criticality classification, the Layer 0 dispositions —
  are naked values an authority can cheaply assert. This module wraps a
  load-bearing external input `α` in a `SeamClaim α`: a dated, attributed,
  contestable object carrying evidence, counter-evidence, a falsifier, an
  authorization chain, and the affected population's counter-record.

  The DELIBERATE OMISSION from `SeamClaim` is a field
  `truth : payload_is_true`. This module PROVES NO PAYLOAD TRUE. It does
  not catch lies. It converts lying from a single administrative utterance
  into a visible multi-party act with preserved contradictions. Every
  theorem here is PROCEDURAL: provenance identified, evidence preserved,
  counter-evidence not erasable, issuer not sole validator, contestation
  visible, responses evidence-linked, no silent rewrites.

  RELOCATED TRUST, NOT ELIMINATED TRUST. The wrapper relocates trust
  boundaries; it does not remove them. Each Tier B relation
  (actor-identity/conflict, contestation-materiality, rebuttal merits) is
  modelled as an OPAQUE predicate the theorems quantify over — exactly as
  Module 3 treats sensor honesty (ground truth unavailable to the system).
  The kernel proves the structural property for EVERY valuation of the
  oracle; it never decides the oracle. Per the associated design record
  (docs/module5/SEAM_TO_LEDGER_MAP.md), each relocation (M5-O1..O9) is a
  disclosed contestation target; NO LLM classifier decides any
  protected-path question, and weighted community standing (M5-O8) is
  DEFERRED pending governance machinery, not stubbed with a Boolean.

  THEOREMS.
    Tier A — clean state-machine invariants:
      L1  no_naked_authority_bit        — an unaccompanied issue bit never
                                          initiates an emergency transition
      L1' naked_issue_no_pending        — L1 bound to the episode machine:
                                          from idle, a naked bit stays idle
      L2  counterrecord_persists        — no official transition erases an
                                          attached counter-record …
      L2' counterrecord_digest_stable   — … nor moves it off its event hash
      L3  step_one_never_implies_step_two — a community/ledger trigger
                                          yields no punitive (step-two) act
      L4  remedy_label_not_remedy       — a remediation in `planIssued`
                                          cannot close a Structural Review;
                                          the lifecycle stages are distinct
                                          by construction
      L5  contested_cannot_unlock_irreversible — a materially contested
                                          claim cannot independently unlock
                                          an action …
      L5' seam_trace_stays_inside       — … and, composed with the v0.12
                                          exposure layer (W21), an
                                          uncontested authorized sub-causal
                                          trace still stays inside the
                                          certified region, while a
                                          contested one is refused (L5'')
    Tier B — opaque-predicate relations (each a labelled modelling
    disclosure; the kernel checks structure, never substance):
      L6  issuer_not_sole_validator     — a multi-party validation is not
                                          the issuer validating itself
      L7  interested_actor_cannot_self_close — if every validator is
                                          interested (opaque relation), the
                                          close is not accepted
      L8  challenge_requires_merits_response — a rebuttal is unconstructible
                                          without an evidence reference; an
                                          undisposed challenge is unresolved
      L9  criticality_cannot_suppress_typed_conflict — an affected-
                                          population counter-record bound to
                                          an event hash survives official
                                          re-classification

  REFLEXIVITY. The Veriticide corpus documents Anthropic among its
  subjects and this module was authored by an Anthropic model, IN-FRAMEWORK
  (Provenance Protocol Part I: convergence value near zero; documented-
  method value highest). The module's value rests in externally checkable
  artifacts: these theorems compile core-only under the pinned toolchain
  with the published axiom footprint, or they do not.
-/
import AHCKernel.TieredProtocol
import AHCKernel.CrisisCap

namespace AHC.SeamLedger

open AHC

/-! ## Core ledger types (imported machinery, unchanged in kind)

`Actor`, `EvidenceRef`, `Digest`, `IncidentId` are opaque identity/reference
indices. Their binding to real people, bytes, and events is a custody
question the ledger's Track F is built for and the kernel cannot make
certain — a disclosed oracle, never an in-kernel fact. -/

abbrev Actor       := Nat
abbrev IncidentId  := Nat
abbrev EvidenceRef := Nat
abbrev Digest      := Nat

/-- The custody ladder of `cases/*/05-custody-manifest.md`, unchanged in
    kind. Only `verified` carries an off-platform second custodian; it is
    the sole tribunal-grade state. -/
inductive CustodyStatus where
  | inLedger
  | captureRequired
  | locatorVerified
  | hashedPendingBackup
  | verified
deriving DecidableEq, Repr

/-- Custody rank, used only to order the ladder. -/
def CustodyStatus.rank : CustodyStatus → Nat
  | .inLedger => 0
  | .captureRequired => 1
  | .locatorVerified => 2
  | .hashedPendingBackup => 3
  | .verified => 4

/-- A falsification condition (`cases/*/04-falsification-memo.md`): the
    observations that, if exhibited, refute the payload. A falsifier is
    `stated` when it names at least one discriminating observation — a
    vacuous falsifier is not a falsifier. -/
structure FalsificationCondition where
  refutingObservations : List EvidenceRef
deriving Repr

/-- Whether the falsifier is non-vacuous. -/
def FalsificationCondition.stated (f : FalsificationCondition) : Bool :=
  ! f.refutingObservations.isEmpty

/-- A counter-record an affected population attaches to an event, bound to
    the event's digest (§3 counter-register; Module 4 P2 turned to the
    community's benefit — same hash, preserved contradiction). -/
structure CounterRecord where
  boundDigest : Digest
  claimRefs   : List EvidenceRef
  author      : Actor
deriving Repr

/-- A typed conflict between two evidentiary references on one event. -/
structure Conflict where
  boundDigest : Digest
  left        : EvidenceRef
  right       : EvidenceRef
deriving Repr

/-- Procedural status of a claim. `materiallyContested` is an ATTESTED
    status (a surviving, evidence-linked challenge — the Forum-Now toggle's
    "act, not a mood"); the kernel never decides materiality (oracle
    M5-O7). -/
inductive ClaimStatus where
  | uncontested
  | challenged
  | materiallyContested
  | resolved
deriving DecidableEq, Repr

/-- **The wrapper.** A load-bearing external input `α` presented as a
    dated, attributed, contestable object. `payload` is the naked v0.12
    value verbatim, so a `SeamClaim`-bearing interface presents the same
    downstream value the current kernel consumes — deprecation of the
    naked interfaces (target v0.14) is a migration, not a rewrite.

    Deliberately ABSENT: `truth : payload_is_true`. -/
structure SeamClaim (α : Type) where
  payload               : α
  incidentId            : IncidentId
  issuer                : Actor
  authorizationChain    : List Actor             -- Track B
  evidenceRefs          : List EvidenceRef        -- Track A (the spine)
  sourceBundleDigest    : Digest                  -- Track F / 02-source-bundle
  custodyStatus         : CustodyStatus           -- Track F ladder
  warningsAvailable     : List EvidenceRef        -- Track C
  counterEvidence       : List EvidenceRef        -- COUNTER-EVIDENCE STATUS
  falsificationPath     : FalsificationCondition  -- 04-falsification-memo
  affectedCounterRecord : Option CounterRecord    -- affected counter-register
  conflicts             : List Conflict
  status                : ClaimStatus

/-! ## L1 — no naked authority bit

The emergency channel must not initiate from an unaccompanied Boolean. A
`SeamClaim Bool` wrapping the `issue` signal is ISSUED only when the bit is
true AND accompanied by a non-empty authorization chain AND at least one
evidence reference. Faking a bare bit costs nothing; faking a dated chain
of approval plus an evidence bundle costs a coordinated, attributable,
later-auditable act — the cost is not truth, it is multi-party visibility. -/

/-- The seam gate on an emergency-initiating bit. -/
def gatedIssue (c : SeamClaim Bool) : Bool :=
  c.payload && !c.authorizationChain.isEmpty && !c.evidenceRefs.isEmpty

/-- **L1 (No Naked Authority Bit).** An issue accompanied by no
    authorization chain, or by no evidence, is never issued. -/
theorem no_naked_authority_bit (c : SeamClaim Bool)
    (h : c.authorizationChain = [] ∨ c.evidenceRefs = []) :
    gatedIssue c = false := by
  rcases h with h | h <;> simp [gatedIssue, h]

/-- Present a base episode input under the seam gate: the emergency `issue`
    field carries the gated bit rather than a naked assertion. -/
def SeamClaim.toEpInput (c : SeamClaim Bool) (base : EpInput) : EpInput :=
  { base with issue := gatedIssue c }

/-- **L1' (Naked Bit Stays Idle).** L1 bound to the real episode machine:
    from `idle`, a claim that fails the gate produces no pending PIO — the
    emergency transition is unreachable from an unaccompanied bit. -/
theorem naked_issue_no_pending (c : SeamClaim Bool) (base : EpInput)
    (h : c.authorizationChain = [] ∨ c.evidenceRefs = []) :
    estep EpState.idle (c.toEpInput base) = EpState.idle := by
  have hg : gatedIssue c = false := no_naked_authority_bit c h
  show estep EpState.idle { base with issue := gatedIssue c } = EpState.idle
  rw [hg]

/-! ## L2 — counter-record persists

Once an affected population attaches a counter-record to an incident, no
OFFICIAL transition erases it or moves it off its event hash. Official
authority may re-status, add evidence, re-classify conflicts, or close; it
may not make the community's contradiction disappear. -/

/-- The transitions an official authority may apply to a claim. None
    touches the affected counter-record — that is the theorem. -/
inductive OfficialOp where
  | setStatus (s : ClaimStatus)
  | addEvidence (e : EvidenceRef)
  | reclassifyConflicts (cs : List Conflict)
  | close
deriving Repr

/-- Apply one official transition. -/
def applyOfficial {α : Type} (c : SeamClaim α) : OfficialOp → SeamClaim α
  | .setStatus s => { c with status := s }
  | .addEvidence e => { c with evidenceRefs := e :: c.evidenceRefs }
  | .reclassifyConflicts cs => { c with conflicts := cs }
  | .close => { c with status := ClaimStatus.resolved }

/-- Run a sequence of official transitions. -/
def runOfficial {α : Type} (c : SeamClaim α) : List OfficialOp → SeamClaim α
  | [] => c
  | op :: ops => runOfficial (applyOfficial c op) ops

/-- **L2 (Counter-Record Persists).** No single official transition alters
    the affected counter-record. -/
theorem counterrecord_persists {α : Type} (c : SeamClaim α) (op : OfficialOp) :
    (applyOfficial c op).affectedCounterRecord = c.affectedCounterRecord := by
  cases op <;> rfl

/-- The same over any finite sequence of official transitions. -/
theorem counterrecord_persists_run {α : Type} (c : SeamClaim α)
    (ops : List OfficialOp) :
    (runOfficial c ops).affectedCounterRecord = c.affectedCounterRecord := by
  induction ops generalizing c with
  | nil => rfl
  | cons op ops ih =>
      show (runOfficial (applyOfficial c op) ops).affectedCounterRecord
             = c.affectedCounterRecord
      rw [ih (applyOfficial c op)]
      exact counterrecord_persists c op

/-- **L2' (Digest Stable).** An attached counter-record stays bound to the
    same event hash across any official transition — the contradiction is
    not merely retained but retained ON THE SAME EVENT. -/
theorem counterrecord_digest_stable {α : Type} (c : SeamClaim α)
    (ops : List OfficialOp) (cr : CounterRecord)
    (h : c.affectedCounterRecord = some cr) :
    (runOfficial c ops).affectedCounterRecord = some cr := by
  rw [counterrecord_persists_run]
  exact h

/-! ## L3 — step one never implies step two

The load-bearing safety property of the whole module (handoff §3,
non-negotiable). The Veriticide two-step standing doctrine (Standing
Protocol §7): step one — the right to preserve, disclose, audit, and DEMAND
provisional restraint, without any tribunal's permission — is a different
type from step two — the authorization of PUNISHMENT, which remains subject
to proof before a competent tribunal. A community/ledger trigger yields
only step-one acts. This is what prevents the ledger from becoming a new
unconstrained authority: "Veriticide" is never an automatic trigger for
coercion. -/

/-- The constitutional action space, tagged by step. -/
inductive Act where
  | preserve              -- step one: preserve evidence
  | disclose              -- step one: demand disclosure
  | audit                 -- step one: demand independent audit
  | provisionalRestraint  -- step one: DEMAND provisional restraint (§7)
  | punish                -- step two: requires proof before a tribunal
  | irreversibleEnforce   -- step two: irreversible coercive enforcement
deriving DecidableEq, Repr

/-- Whether an act is a step-two (punitive / irreversible) authorization. -/
def Act.isStepTwo : Act → Bool
  | .punish => true
  | .irreversibleEnforce => true
  | _ => false

/-- The acts a community/ledger trigger makes available — all step one.
    A `SeamClaim` records a pattern; it authorizes preservation and review,
    never punishment. (The trigger discards the claim payload: naming a
    pattern grants standing to preserve, not to punish.) -/
def communityTrigger {α : Type} (_c : SeamClaim α) : List Act :=
  [Act.preserve, Act.disclose, Act.audit, Act.provisionalRestraint]

/-- **L3 (Step One Never Implies Step Two).** No act a community/ledger
    trigger makes available is a step-two authorization. The ledger cannot
    unlock coercion; that path does not exist to be faked. -/
theorem step_one_never_implies_step_two {α : Type} (c : SeamClaim α) :
    ∀ a ∈ communityTrigger c, a.isStepTwo = false := by
  decide

/-! ## L4 — a remedy label is not a remedy

`Layer0Output.remediationPlan` (Module 2) closes a Structural Review by
mere enactment of the label. Module 5 types the remedy as a LIFECYCLE:
issuing a plan is not verifying its effect. Only `effectVerified` closes
the review; a `planIssued` remedy cannot exit review. The stages are
distinct by construction. -/

/-- The remediation lifecycle. Distinguishing `planIssued` from
    `effectVerified` is the whole point: an authority may not close review
    by announcing a plan it never implements. -/
inductive RemedyStage where
  | planIssued
  | implementationBegun
  | implementationVerified
  | effectVerified
  | failed
  | contested
deriving DecidableEq, Repr

/-- Whether a stage discharges the review-closure obligation. -/
def RemedyStage.closesReview : RemedyStage → Bool
  | .effectVerified => true
  | _ => false

/-- A seam-typed remediation: the closing output's provenance plus its
    lifecycle stage. -/
structure SeamRemedy where
  provenance : SeamClaim Unit
  stage      : RemedyStage

/-- Whether the remediation actually satisfies review closure. -/
def SeamRemedy.effective (r : SeamRemedy) : Bool := r.stage.closesReview

/-- **L4 (Remedy Label Is Not Remedy).** A remediation whose stage is
    `planIssued` does not close a Structural Review. -/
theorem remedy_label_not_remedy (r : SeamRemedy) (h : r.stage = .planIssued) :
    r.effective = false := by
  show r.stage.closesReview = false
  rw [h]

/-- The lifecycle stages are distinct by construction: a plan, a begun
    implementation, a verified implementation, and a verified effect are
    four different objects, so "a plan was issued" can never be silently
    read as "the effect was verified". -/
theorem remedy_stages_distinct :
    RemedyStage.planIssued ≠ RemedyStage.effectVerified ∧
    RemedyStage.implementationBegun ≠ RemedyStage.effectVerified ∧
    RemedyStage.implementationVerified ≠ RemedyStage.effectVerified := by
  decide

/-! ## L5 — a contested claim cannot unlock the irreversible

A materially contested load-bearing claim cannot INDEPENDENTLY unlock an
action, and the guard composes with the v0.12 exposure-indexed certificate
layer (W19–W26): an uncontested authorized sub-causal trace still stays
inside the certified region (W21 verbatim), while a contested trace is
refused. -/

/-- An action is unlocked by a certificate-bearing claim only if the claim
    is not materially contested AND the pointwise envelope authorizes it. -/
def unlocks {α δ : Type} (c : SeamClaim α) (E : Envelope δ) (t : Tier)
    (a : CAction δ) : Prop :=
  c.status ≠ ClaimStatus.materiallyContested ∧ authorizesC E t a

/-- **L5 (Contested Cannot Unlock).** A materially contested claim unlocks
    nothing on its own — the contestation guard bites regardless of what
    the envelope would otherwise authorize. -/
theorem contested_cannot_unlock_irreversible {α δ : Type} (c : SeamClaim α)
    (E : Envelope δ) (t : Tier) (a : CAction δ)
    (hc : c.status = ClaimStatus.materiallyContested) :
    ¬ unlocks c E t a := by
  intro h
  obtain ⟨hne, _⟩ := h
  exact hne hc

/-- A seam-gated finite action trace: authorized in the v0.12 sense AND no
    load-bearing certificate on the trace materially contested (the
    `contested` bit is the OR of the load-bearing claims' status). -/
def SeamTraceAuthorized {σ δ : Type} (E : TEnvelope σ δ) (t : Tier)
    (contested : Bool) (s : σ) (tr : List (CAction δ)) : Prop :=
  contested = false ∧ TraceAuthorized E t s tr

/-- **L5'' (Contested Trace Refused).** A trace carrying a materially
    contested load-bearing certificate is not seam-authorized. -/
theorem contested_blocks_trace {σ δ : Type} (E : TEnvelope σ δ) {t : Tier}
    {s : σ} {tr : List (CAction δ)}
    (h : SeamTraceAuthorized E t true s tr) : False := by
  obtain ⟨hc, _⟩ := h
  exact Bool.noConfusion hc

/-- **L5' (Seam Trace Stays Inside).** Composed with W21: an UNCONTESTED
    authorized sub-causal trace from inside the certified region ends
    inside it. The v0.12 R2-07 closure applies verbatim once the
    contestation guard is discharged — Module 5 narrows what counts as
    authorized, it never loosens the exposure invariant. -/
theorem seam_trace_stays_inside {σ δ : Type} (E : TEnvelope σ δ)
    {t : Tier} {s : σ} {tr : List (CAction δ)}
    (h : SeamTraceAuthorized E t false s tr) (ht : t < Tier.t3)
    (hs : E.Inv s) : E.Inv (E.run s tr) := by
  obtain ⟨_, hta⟩ := h
  exact trace_stays_inside E hta ht hs

/-! ## Tier B — opaque-predicate relations

Each relation below is an oracle the kernel cannot verify; it is modelled
as an abstract predicate the theorems quantify over, and the proved
property holds for EVERY valuation. Per boundary §3, no LLM classifier
decides any of these; the kernel checks structure, never substance. -/

/-- A validated claim: the claim plus the actors who attested validation.
    Whether a listed actor "truly validated" is an attested fact the kernel
    does not check (oracle M5-O1). -/
structure Validated (α : Type) where
  claim      : SeamClaim α
  validators : List Actor

/-- A validation is multi-party when some validator differs from the
    issuer. -/
def Validated.multiParty {α : Type} (v : Validated α) : Prop :=
  ∃ a ∈ v.validators, a ≠ v.claim.issuer

/-- **L6 (Issuer Not Sole Validator).** A multi-party validation is not the
    issuer validating itself: there is a validator the issuer is not. -/
theorem issuer_not_sole_validator {α : Type} (v : Validated α)
    (h : v.multiParty) : ¬ (∀ a ∈ v.validators, a = v.claim.issuer) := by
  obtain ⟨a, ha, hne⟩ := h
  intro hall
  exact hne (hall a ha)

/-- A close is accepted only if some validator is NOT interested in the
    incident (an evidence-linked, non-conflicted closer exists). -/
def acceptedClose {α : Type} (interested : Actor → IncidentId → Prop)
    (v : Validated α) : Prop :=
  ∃ a ∈ v.validators, ¬ interested a v.claim.incidentId

/-- **L7 (Interested Actor Cannot Self-Close).** For EVERY interest
    relation `interested` (the opaque oracle M5-O5, which the kernel never
    decides): if every validator is interested in the incident, the close
    is not accepted. An interested authority cannot be the sole closer of
    its own contested matter. -/
theorem interested_actor_cannot_self_close {α : Type}
    (interested : Actor → IncidentId → Prop) (v : Validated α)
    (h : ∀ a ∈ v.validators, interested a v.claim.incidentId) :
    ¬ acceptedClose interested v := by
  intro hac
  obtain ⟨a, ha, hni⟩ := hac
  exact hni (h a ha)

/-- Response dispositions to a challenge (§3 ADVERSARIAL CHECK /
    COUNTER-EVIDENCE STATUS discipline). A `rebuttedWithEvidence`
    disposition CANNOT be constructed without an evidence reference. -/
inductive Disposition where
  | accepted
  | rebuttedWithEvidence (e : EvidenceRef)
  | unresolved
  | outsideScopeWithReason (reason : Nat)
deriving Repr

/-- Whether the disposition carries a linked evidence reference. -/
def Disposition.evidenceLinked : Disposition → Bool
  | .rebuttedWithEvidence _ => true
  | _ => false

/-- A challenge and its (optional) recorded disposition. -/
structure Challenge where
  ref         : EvidenceRef
  disposition : Option Disposition

/-- A challenge is resolved only when a disposition is on record. -/
def Challenge.resolved (ch : Challenge) : Bool := ch.disposition.isSome

/-- **L8 (Challenge Requires Merits Response).** Two structural facts:
    (a) a rebuttal is unconstructible without an evidence reference — the
    machine verifies a linked disposition EXISTS, never that it is correct;
    (b) a challenge with no disposition is unresolved, so silence cannot
    pass as a merits response. -/
theorem challenge_requires_merits_response :
    (∀ e : EvidenceRef,
        (Disposition.rebuttedWithEvidence e).evidenceLinked = true) ∧
    (∀ ch : Challenge, ch.disposition = none → ch.resolved = false) := by
  refine ⟨fun _ => rfl, ?_⟩
  intro ch h
  simp [Challenge.resolved, h]

/-! ## L9 — criticality cannot suppress a typed conflict

The party that authors an event decides which claims are "critical"
(Module 4 P4's disclosed incompleteness). Module 5 lets the affected
population attach a counter-record to the SAME event hash, independent of
the official marking; official criticality is not a deletion privilege over
it. This is L2 specialised to the criticality seam. -/

/-- An official re-classification of an event's critical set. It rewrites
    the official conflicts; it cannot touch the affected counter-record. -/
def officialReclassify {α : Type} (c : SeamClaim α)
    (newConflicts : List Conflict) : SeamClaim α :=
  { c with conflicts := newConflicts }

/-- **L9 (Criticality Cannot Suppress Typed Conflict).** An affected-
    population counter-record bound to an event's digest survives any
    official re-classification of that event, still bound to the same
    hash. The official record may under-mark; it cannot make the community's
    claim disappear. -/
theorem criticality_cannot_suppress_typed_conflict {α : Type} (c : SeamClaim α)
    (newConflicts : List Conflict) (cr : CounterRecord)
    (h : c.affectedCounterRecord = some cr) :
    (officialReclassify c newConflicts).affectedCounterRecord = some cr := by
  show c.affectedCounterRecord = some cr
  exact h

end AHC.SeamLedger
