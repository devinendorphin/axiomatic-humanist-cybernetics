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

  Scope disclaimer: these proofs verify the specification, not the world.

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-11.
-/

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

end AHC.PLOL
