/-
  AHC Verified Constitutional Kernel — Module 4
  Plain Language Output Layer: Register Invariance  (AHC v3.1 §10.4;
  Companion A §5, §19.4, Appendix B revised)

  Machine-checked invariants of the tripartite output architecture:

    P1  hash_bridge_origin       — equal digests identify a single underlying
                                   classification event (under the stated
                                   collision-freeness hypothesis)
    P1' tripartite_single_origin — the three registers of a valid release
                                   carry one digest: one event, three voices
    P2  bridge_proves_origin_not_consistency
                                 — §19.4.1's sentence as a theorem-with-
                                   witness: records with EQUAL digests and
                                   DIVERGENT content exist. The bridge is
                                   structurally incapable of carrying
                                   consistency; consistency must be a
                                   separate, checkable relation — which is
                                   why the Consistency Statement exists
    P3  compliant_registers_agree— two B.4-compliant registers agree exactly
                                   on the contestation-critical fragment
    P3' divergence_convicts      — contrapositive, as an auditor uses it:
                                   a critical claim present in one register
                                   and absent from another PROVES the
                                   omitting register violates B.4. Divergence
                                   is not a judgment call; it is a conviction
    P4  residual_divergence_harmless
                                 — whatever divergence survives compliance is
                                   confined to true-but-noncritical content:
                                   §19.4.1's defense made formal — differences
                                   in framing are provably not inconsistency
                                   in findings
    P5  no_hostage               — every contestation-critical claim is public
                                   at hour zero of a valid release: the
                                   community's record never waits on the
                                   litigation track (T+30d)
    P5' contestability_at_breach — in particular the falsification condition
                                   is in the T+0 record: the key ships with
                                   the lock
    P6  decCompliant             — B.4 compliance is DECIDABLE: given
                                   extracted claim sets, the divergence audit
                                   is a mechanical check requiring no
                                   expertise and no discretion

  D-R4 disclosure theorems (adopted in v0.5 under constitutional ruling
  D-R4, ratified 2026-07-12; formalizing the deferred T+0 record
  obligations):

    P7  pio_disclosure_at_breach — a valid release over a PIO-related
                                   event ships all four D-R4 fields —
                                   authorization basis, novelty basis,
                                   cumulative episode protection, and the
                                   falsification condition — in the T+0
                                   semantic record, at hour zero
    P7' pio_disclosure_divergence_convicts — a register omitting ANY of
                                   the four D-R4 fields is thereby proved
                                   non-compliant: the omission convicts
    P8  attested_budget_accurate — a well-formed budget attestation
                                   cannot misstate the episode machine's
                                   accounting: the figure carries its
                                   proof
    P9  attested_budget_bounded  — CROSS-MODULE (Module 1 × Module 4):
                                   any attested budget over a span with
                                   no novel evidence and no Layer 0
                                   resolution is ≤ 72 hours, by E1. The
                                   record's number inherits the machine's
                                   constitutional bound

  Later-register compliance theorems (adopted in v0.7; §19.4, App. B.4;
  reviewer solicitation F-4). Phase 1 obliged only the T+0 semantic
  record at release; the civic (T+72h) and technical (T+30d) registers
  are checked WHEN THEY SHIP. `ShippedTripartite` carries their
  compliance as proof obligations, extending register invariance across
  the full release:

    P10 tripartite_critical_consensus — the three registers of a shipped
                                   compliant release agree on the ENTIRE
                                   contestation-critical fragment: one
                                   event, three voices, same findings
    P11 later_registers_no_hostage — every critical claim is present in
                                   the civic and technical records too;
                                   a later register cannot drop what the
                                   semantic record carried
    P12 shipped_pio_disclosure_all_registers — the four D-R4 fields
                                   appear in ALL THREE registers of a
                                   shipped PIO release, not the T+0
                                   record alone
    P13 later_residual_divergence_harmless — any claim differing between
                                   the civic and technical records is
                                   provably non-critical: later-register
                                   differences are framing, never findings

  ── THE SEAM (what this module does not and cannot prove) ──────────────

  Every theorem above operates on claim sets: abstract, register-neutral
  units of substantive content. The relation between a natural-language
  TEXT and the claim set it expresses — whether the words on the page mean
  what the record asserts, whether a literate non-expert reads them in
  three minutes, whether understanding occurs — is formally unverifiable,
  and this module makes no attempt to verify it. That relation is the seam
  between the two halves of the architecture. On the formal side of the
  seam: origin is provable (P1), consistency is checkable (P6), divergence
  convicts (P3'). On the other side: extraction of claims from text is
  human judgment, exercised by the communities the PLOL exists to serve,
  through Layer 0. This is Proposition 5.1 — semantic contestability and
  technical reproducibility, neither sufficient for the other — realized
  as a division of labor: the machine checks everything that does not
  require trust, so that trust is spent only where it is irreplaceable.

  Modeling choices:
  · A classification event carries a claim set and a distinguished
    contestation-critical subset (label, tier, cohort, reason,
    falsification condition, active measures — Appendix B.2's mandatory
    fields, abstracted). `Event.critical_sub` and
    `Event.falsifier_critical` are carried as proof obligations.
  · B.4 compliance for a register = no critical omission ∧ no fabrication.
  · Collision-freeness of the digest function is a CRYPTOGRAPHIC
    assumption, not a logical fact; it is carried honestly as a field of
    `HashScheme`, so every theorem that uses it displays its dependence.
  · Release timing: `Tripartite` carries T+0 / ≤72h / ≤30d windows and
    T+0 compliance as proof obligations — a release violating §19.4's
    sequencing or B.4's semantic-record requirement is unconstructible.

  Modeling choices for P7–P9 (ruling D-R4, v0.5):
  · The four mandatory disclosures are abstract claims REQUIRED (as
    structure fields, hence proof obligations) to sit in the
    contestation-critical set of a `PIOEvent`: a PIO-related event that
    withholds any of them is unconstructible. WHAT the basis or novelty
    claims say is at the seam, as always; that they are present,
    critical, and public at T+0 is what the kernel proves.
  · `BudgetAttestation` bridges to Module 1: the claimed cumulative
    unconfirmed protection carries a proof it equals `epPendingHours`
    over the incident's input history. Whether the recorded history is
    the true history is an institutional question (append-only logs,
    Layer 0 audit); given the history, the figure cannot lie.
  · Novelty determinations are contestable through Layer 0 (D-R4): the
    kernel's contribution is P7 — the novelty basis is public at hour
    zero, so contestation never waits.

  Scope disclaimer: these proofs verify the specification, not the world.

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-12 (v0.7).
-/
import AHCKernel.TieredProtocol

namespace AHC.PLOL

/-! ## Events, registers, records -/

/-- A classification event, abstracted to its substantive content: a claim
    set with a distinguished contestation-critical subset, of which the
    falsification condition is always a member. -/
structure Event (Claim : Type) where
  claims   : List Claim
  critical : List Claim
  falsifier : Claim
  critical_sub : ∀ c ∈ critical, c ∈ claims
  falsifier_critical : falsifier ∈ critical

/-- The three registers of §19.4. -/
inductive Register where
  | semantic   -- T+0   Semantic Contestability Record
  | civic      -- T+72h Civic/Legislative Translation Record
  | technical  -- T+30d Technical Reproducibility Record
deriving DecidableEq, Repr

/-- A published record: register, digest, release hour, and the claim set
    its text expresses. (The extraction of `claims` from the text is the
    seam — see module header.) -/
structure Record (Claim : Type) where
  register : Register
  digest : Nat
  releaseHour : Nat
  claims : List Claim

/-- An abstract digest scheme. `collisionFree` is a cryptographic
    assumption about the deployed hash on the deployed domain, carried
    honestly as a hypothesis rather than smuggled in as a fact. -/
structure HashScheme (α : Type) where
  h : α → Nat
  collisionFree : ∀ a b, h a = h b → a = b

/-- **B.4 compliance** of a record against its event: every
    contestation-critical claim is present (no critical omission), and
    every asserted claim is genuine (no fabrication). -/
def Compliant {Claim : Type} (e : Event Claim) (r : Record Claim) : Prop :=
  (∀ c ∈ e.critical, c ∈ r.claims) ∧ (∀ c ∈ r.claims, c ∈ e.claims)

/-- **P6 (The Audit Is Mechanical).** Given extracted claim sets,
    B.4 compliance — and therefore divergence — is decidable: a
    community auditor with the two claim lists needs no statistics, no
    model access, and no discretion to run the check. All expertise and
    all trust are consumed BEFORE this point, at extraction; none is
    required after it. -/
instance decCompliant {Claim : Type} [DecidableEq Claim]
    (e : Event Claim) (r : Record Claim) : Decidable (Compliant e r) :=
  inferInstanceAs (Decidable
    ((∀ c ∈ e.critical, c ∈ r.claims) ∧ (∀ c ∈ r.claims, c ∈ e.claims)))

/-! ## The bridge theorems -/

/-- **P1 (Hash Bridge Soundness — Origin).** Two records carrying equal
    digests derive from the same classification event, given
    collision-freeness. Note how cheap this proof is: origin is the EASY
    property, which is exactly why the bridge can carry it. -/
theorem hash_bridge_origin {Claim α : Type} (H : HashScheme α)
    (e₁ e₂ : α) (r₁ r₂ : Record Claim)
    (hb₁ : r₁.digest = H.h e₁) (hb₂ : r₂.digest = H.h e₂)
    (heq : r₁.digest = r₂.digest) : e₁ = e₂ :=
  H.collisionFree e₁ e₂ (by rw [← hb₁, ← hb₂]; exact heq)

/-- **P2 (The Bridge Proves Origin, Not Consistency).** §19.4.1's sentence
    as a theorem-with-witness: there exist records with EQUAL digests and
    DIVERGENT claim sets. Digest equality is therefore structurally
    incapable of entailing content agreement — no strengthening of the
    hash can close this gap, because the gap is type-theoretic, not
    cryptographic. Consistency must be checked as a separate relation on
    claim sets (P3/P6); the Consistency Statement is that check's
    constitutional home. -/
theorem bridge_proves_origin_not_consistency :
    ∃ r₁ r₂ : Record Nat, r₁.digest = r₂.digest ∧ r₁.claims ≠ r₂.claims :=
  ⟨⟨.semantic, 0, 0, [0]⟩, ⟨.technical, 0, 720, [1]⟩, rfl, by decide⟩

/-! ## The invariance theorems -/

/-- **P3 (Register Invariance).** Any two B.4-compliant registers agree
    exactly on the contestation-critical fragment: a critical claim is in
    one iff it is in the other. The plain-language record and the
    technical record cannot diverge on anything that matters for
    contestation while both remain compliant. -/
theorem compliant_registers_agree {Claim : Type}
    (e : Event Claim) (r₁ r₂ : Record Claim)
    (h₁ : Compliant e r₁) (h₂ : Compliant e r₂) :
    ∀ c ∈ e.critical, (c ∈ r₁.claims ↔ c ∈ r₂.claims) :=
  fun c hc => ⟨fun _ => h₂.1 c hc, fun _ => h₁.1 c hc⟩

/-- **P3' (Divergence Convicts).** The contrapositive, in the form an
    auditor uses it: a contestation-critical claim present in one register
    and absent from another is PROOF that the omitting register violates
    B.4. Material divergence is never an interpretive dispute about
    framing; it is a conviction, and it names the guilty register. -/
theorem divergence_convicts {Claim : Type}
    (e : Event Claim) (r₂ : Record Claim) (c : Claim)
    (hc : c ∈ e.critical) (h₂ : c ∉ r₂.claims) :
    ¬ Compliant e r₂ :=
  fun h => h₂ (h.1 c hc)

/-- **P4 (Residual Divergence Is Harmless).** Whatever difference survives
    between two compliant registers is confined to claims that are (a)
    genuine claims of the event and (b) not contestation-critical.
    §19.4.1 anticipates hostile actors characterizing register differences
    as inconsistency in findings; this theorem is the reply: under
    compliance, differences between registers are provably framing, never
    findings. -/
theorem residual_divergence_harmless {Claim : Type}
    (e : Event Claim) (r₁ r₂ : Record Claim)
    (h₁ : Compliant e r₁) (h₂ : Compliant e r₂) (c : Claim)
    (hin : c ∈ r₁.claims) (hout : c ∉ r₂.claims) :
    c ∈ e.claims ∧ c ∉ e.critical :=
  ⟨h₁.2 c hin, fun hcrit => hout (h₂.1 c hcrit)⟩

/-! ## The tripartite release (§19.4) -/

/-- A valid tripartite release. The §19.4 sequencing windows, the hash
    bridging of all three registers, and B.4 compliance of the T+0
    semantic record are proof obligations: a release that delays the
    community's record, breaks the bridge, or ships a non-compliant
    semantic record is unconstructible. (Compliance of the later registers
    is checked when they ship — at T+72h and T+30d they do not yet exist;
    the semantic record's compliance is the one that cannot wait.) -/
structure Tripartite (Claim : Type) (H : HashScheme (Event Claim)) where
  event : Event Claim
  scr   : Record Claim   -- T+0   Semantic Contestability Record
  civic : Record Claim   -- T+72h Civic/Legislative Translation Record
  tech  : Record Claim   -- T+30d Technical Reproducibility Record
  scr_register   : scr.register = .semantic
  civic_register : civic.register = .civic
  tech_register  : tech.register = .technical
  bridged_scr   : scr.digest = H.h event
  bridged_civic : civic.digest = H.h event
  bridged_tech  : tech.digest = H.h event
  scr_at_breach : scr.releaseHour = 0     -- "no delay permitted"
  civic_window  : civic.releaseHour ≤ 72
  tech_window   : tech.releaseHour ≤ 720
  scr_compliant : Compliant event scr     -- B.4, at the hour of breach

/-- **P1' (One Event, Three Voices).** The three registers of a valid
    release carry a single digest: whatever their differences of register
    and audience, they are cryptographically nailed to one classification
    event, and (by P1) to only one. -/
theorem tripartite_single_origin {Claim : Type} {H : HashScheme (Event Claim)}
    (T : Tripartite Claim H) :
    T.scr.digest = T.civic.digest ∧ T.civic.digest = T.tech.digest := by
  rw [T.bridged_scr, T.bridged_civic, T.bridged_tech]
  exact ⟨rfl, rfl⟩

/-- **P5 (No Hostage).** Every contestation-critical claim of the event is
    in the semantic record, and the semantic record is public at hour
    zero. The community's ability to contest never waits on the
    advocacy track (T+72h) or the litigation track (T+30d): if the
    technical record is late, incomplete, or under revision, everything
    contestation needs is already in force. -/
theorem no_hostage {Claim : Type} {H : HashScheme (Event Claim)}
    (T : Tripartite Claim H) :
    ∀ c ∈ T.event.critical, c ∈ T.scr.claims ∧ T.scr.releaseHour = 0 :=
  fun c hc => ⟨T.scr_compliant.1 c hc, T.scr_at_breach⟩

/-- **P5' (The Key Ships With the Lock).** In particular, the
    falsification condition — what evidence would change the
    classification — is in the T+0 record. The simulation's finding of
    "a lock whose key sits in another building" is, for the claim-set
    layer, unconstructible: a release without the key is not a valid
    release. (Whether the key is USABLE — the resource-access problem —
    is Field C's institutional burden, on the far side of the seam.) -/
theorem contestability_at_breach {Claim : Type} {H : HashScheme (Event Claim)}
    (T : Tripartite Claim H) :
    T.event.falsifier ∈ T.scr.claims ∧ T.scr.releaseHour = 0 :=
  ⟨T.scr_compliant.1 _ T.event.falsifier_critical, T.scr_at_breach⟩

/-- Nothing the semantic record asserts is fabricated: every claim it
    makes is a genuine claim of the classification event. Paired with
    `no_hostage`, this pins the T+0 record from both sides — complete on
    the critical fragment, sound on everything. -/
theorem scr_no_fabrication {Claim : Type} {H : HashScheme (Event Claim)}
    (T : Tripartite Claim H) :
    ∀ c ∈ T.scr.claims, c ∈ T.event.claims :=
  T.scr_compliant.2

/-! ## D-R4 disclosures (§10.4; ruling D-R4) — adopted v0.5

Ruling D-R4 (ratified 2026-07-12) obliges the T+0 semantic record of any
PIO-related classification to state: the authorization basis (fresh
evidence, continuing risk, or both), the basis of any novelty
determination with its lineage, the cumulative unconfirmed protection
already granted to the incident, and the falsification condition. Here
those obligations are structure fields: an event that withholds them is
unconstructible, and by the Module 4 invariance theorems they are public
at hour zero and their omission from any register convicts it. -/

/-- A PIO-related classification event: an `Event` whose
    contestation-critical set is REQUIRED to contain the D-R4 fields.
    `basisClaim` states whether authorization rests on evidentiary
    freshness, continuing risk, or both; `noveltyClaim` states the basis
    and lineage of any novelty determination (contestable through
    Layer 0); `budgetClaim` states the incident's cumulative unconfirmed
    protection. The falsification condition is already mandatory on
    every `Event`. -/
structure PIOEvent (Claim : Type) extends Event Claim where
  basisClaim   : Claim
  noveltyClaim : Claim
  budgetClaim  : Claim
  basis_critical   : basisClaim ∈ critical
  novelty_critical : noveltyClaim ∈ critical
  budget_critical  : budgetClaim ∈ critical

/-- **P7 (D-R4 Disclosure at Breach).** A valid tripartite release over
    a PIO-related event ships all four D-R4 fields in the T+0 semantic
    record, at hour zero: the authorization basis, the novelty basis,
    the episode budget, and the falsification condition are public
    before any later register exists. Contestation of a PIO — including
    of the novelty determination itself — never waits. -/
theorem pio_disclosure_at_breach {Claim : Type} {H : HashScheme (Event Claim)}
    (D : PIOEvent Claim) (T : Tripartite Claim H)
    (hT : T.event = D.toEvent) :
    (D.basisClaim ∈ T.scr.claims ∧ D.noveltyClaim ∈ T.scr.claims ∧
     D.budgetClaim ∈ T.scr.claims ∧ D.falsifier ∈ T.scr.claims)
    ∧ T.scr.releaseHour = 0 := by
  have hc := T.scr_compliant.1
  rw [hT] at hc
  exact ⟨⟨hc _ D.basis_critical, hc _ D.novelty_critical,
          hc _ D.budget_critical, hc _ D.toEvent.falsifier_critical⟩,
         T.scr_at_breach⟩

/-- **P7' (D-R4 Omission Convicts).** A register from which ANY of the
    four D-R4 fields is absent is thereby proved non-compliant — the
    omission is a conviction, not an editorial difference (P3',
    instantiated at the fields ruling D-R4 makes mandatory). -/
theorem pio_disclosure_divergence_convicts {Claim : Type}
    (D : PIOEvent Claim) (r : Record Claim)
    (h : D.basisClaim ∉ r.claims ∨ D.noveltyClaim ∉ r.claims ∨
         D.budgetClaim ∉ r.claims ∨ D.falsifier ∉ r.claims) :
    ¬ Compliant D.toEvent r :=
  fun hc => match h with
  | .inl h => h (hc.1 _ D.basis_critical)
  | .inr (.inl h) => h (hc.1 _ D.novelty_critical)
  | .inr (.inr (.inl h)) => h (hc.1 _ D.budget_critical)
  | .inr (.inr (.inr h)) => h (hc.1 _ D.toEvent.falsifier_critical)

/-- A machine-checkable budget attestation: the claimed cumulative
    unconfirmed protection for an incident, carried WITH the proof that
    it equals the episode machine's accounting over the incident's input
    history. Given the history, a misstated figure is unconstructible;
    whether the history is true is an institutional question (append-only
    logs, Layer 0 audit) at the seam. -/
structure BudgetAttestation where
  history : List EpInput
  claimedHours : Nat
  accurate : claimedHours = epPendingHours .idle history

/-- **P8 (The Figure Carries Its Proof).** A well-formed budget
    attestation cannot misstate the episode machine's accounting. -/
theorem attested_budget_accurate (B : BudgetAttestation) :
    B.claimedHours = epPendingHours .idle B.history :=
  B.accurate

/-- **P9 (Attested Budget Is Bounded — Module 1 × Module 4).** Any
    attested budget over an incident span containing no novel evidence
    and no Layer 0 resolution is at most the 72-hour deadline: the
    number the community reads in the T+0 record inherits the episode
    machine's constitutional bound (E1). The disclosure layer and the
    authorization layer cannot drift apart on the one figure that
    measures how much unreviewed protection an incident has consumed. -/
theorem attested_budget_bounded (B : BudgetAttestation)
    (hno : ∀ i ∈ B.history, i.novel = false ∧ i.layer0 = false) :
    B.claimedHours ≤ reviewDeadline := by
  rw [B.accurate]
  exact episode_no_relitigation B.history hno

/-! ## Later-register compliance (§19.4, App. B.4) — adopted v0.7

Phase 1 made only the T+0 semantic record a compliance obligation of a
valid release; the civic and technical registers, which ship later, were
"checked when they ship". `ShippedTripartite` records that both have
shipped and carries their B.4 compliance as proof obligations, so the
register-invariance guarantees (P3, P3', P4) and the D-R4 disclosures
(P7) extend across the full tripartite release. -/

/-- A fully-shipped tripartite release: the later registers have shipped
    and their B.4 compliance is now a proof obligation. A shipped release
    that ships a non-compliant civic or technical record is
    unconstructible. -/
structure ShippedTripartite (Claim : Type) (H : HashScheme (Event Claim))
    extends Tripartite Claim H where
  civic_compliant : Compliant event civic
  tech_compliant  : Compliant event tech

/-- **P10 (Tripartite Critical Consensus).** The three registers of a
    shipped compliant release agree on the entire contestation-critical
    fragment: a critical claim is in the semantic record iff in the civic
    record iff in the technical record. One classification event, three
    registers, no divergence on anything that matters for contestation —
    now proved for the full release, not the T+0 record alone. -/
theorem tripartite_critical_consensus {Claim : Type}
    {H : HashScheme (Event Claim)} (T : ShippedTripartite Claim H) :
    ∀ c ∈ T.event.critical,
      (c ∈ T.scr.claims ↔ c ∈ T.civic.claims) ∧
      (c ∈ T.civic.claims ↔ c ∈ T.tech.claims) := by
  intro c hc
  exact ⟨compliant_registers_agree T.event T.scr T.civic
           T.scr_compliant T.civic_compliant c hc,
         compliant_registers_agree T.event T.civic T.tech
           T.civic_compliant T.tech_compliant c hc⟩

/-- **P11 (Later Registers Take No Hostage).** Every contestation-critical
    claim is present in the civic and technical records: a later register
    cannot narrow the contestable set by dropping what the semantic
    record already made public. `no_hostage` (P5), extended down the
    release timeline. -/
theorem later_registers_no_hostage {Claim : Type}
    {H : HashScheme (Event Claim)} (T : ShippedTripartite Claim H) :
    ∀ c ∈ T.event.critical, c ∈ T.civic.claims ∧ c ∈ T.tech.claims :=
  fun c hc => ⟨T.civic_compliant.1 c hc, T.tech_compliant.1 c hc⟩

/-- The four D-R4 fields are present in any register compliant against a
    PIO-related event. -/
theorem pio_fields_in_compliant {Claim : Type} (D : PIOEvent Claim)
    (r : Record Claim) (hc : Compliant D.toEvent r) :
    D.basisClaim ∈ r.claims ∧ D.noveltyClaim ∈ r.claims ∧
    D.budgetClaim ∈ r.claims ∧ D.falsifier ∈ r.claims :=
  ⟨hc.1 _ D.basis_critical, hc.1 _ D.novelty_critical,
   hc.1 _ D.budget_critical, hc.1 _ D.toEvent.falsifier_critical⟩

/-- **P12 (D-R4 Disclosures in Every Register).** For a shipped PIO
    release, all four D-R4 fields — authorization basis, novelty basis,
    episode budget, falsification condition — appear in all three
    registers, not the T+0 record alone. Whichever register a contestant
    reads, the accountability fields are there. -/
theorem shipped_pio_disclosure_all_registers {Claim : Type}
    {H : HashScheme (Event Claim)} (D : PIOEvent Claim)
    (T : ShippedTripartite Claim H) (hT : T.event = D.toEvent) :
    (D.basisClaim ∈ T.scr.claims ∧ D.noveltyClaim ∈ T.scr.claims ∧
      D.budgetClaim ∈ T.scr.claims ∧ D.falsifier ∈ T.scr.claims) ∧
    (D.basisClaim ∈ T.civic.claims ∧ D.noveltyClaim ∈ T.civic.claims ∧
      D.budgetClaim ∈ T.civic.claims ∧ D.falsifier ∈ T.civic.claims) ∧
    (D.basisClaim ∈ T.tech.claims ∧ D.noveltyClaim ∈ T.tech.claims ∧
      D.budgetClaim ∈ T.tech.claims ∧ D.falsifier ∈ T.tech.claims) := by
  refine ⟨pio_fields_in_compliant D T.scr ?_,
          pio_fields_in_compliant D T.civic ?_,
          pio_fields_in_compliant D T.tech ?_⟩
  · rw [← hT]; exact T.scr_compliant
  · rw [← hT]; exact T.civic_compliant
  · rw [← hT]; exact T.tech_compliant

/-- **P13 (Later Residual Divergence Is Harmless).** Any claim present in
    the civic record but absent from the technical record (or vice versa)
    is provably a genuine, non-critical claim: differences between the
    later registers are framing, never findings. `residual_divergence_
    harmless` (P4), applied across the release timeline. -/
theorem later_residual_divergence_harmless {Claim : Type}
    {H : HashScheme (Event Claim)} (T : ShippedTripartite Claim H)
    (c : Claim) (hin : c ∈ T.civic.claims) (hout : c ∉ T.tech.claims) :
    c ∈ T.event.claims ∧ c ∉ T.event.critical :=
  residual_divergence_harmless T.event T.civic T.tech
    T.civic_compliant T.tech_compliant c hin hout

end AHC.PLOL
