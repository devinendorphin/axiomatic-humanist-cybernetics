# Circulation Amendment — Module 5: Seam Ledger

**PLOL-conformant brief section for the v0.13 packet.**
Prepared 2026-07-14. Companion to `SEAM_TO_LEDGER_MAP.md` (the design
record) and `AHCKernel/SeamLedger.lean` (the machine-checked object).
Structure follows PLOL: **(I) Plain-Language Summary · (II) Formal
Appendix · (III) Theorem-to-Text Mapping.** The v0.12 circulation brief is
retained unchanged as the artifact of its round; this amendment is the
Module 5 addendum, not a rewrite of that brief.

---

## I. Plain-Language Summary

**What was already true.** Through v0.12 the kernel is strong against
*malformed* inputs: you cannot build an under-provisioned sensor network,
a certificate that authorizes an unsafe action, or an emergency day during
a Structural Review. Those are theorems about badly-formed objects.

**The gap Module 5 addresses.** The kernel had no defense against a
*well-formed lie from a legitimate authority.* Its most load-bearing
inputs — the request to open an emergency, the signal that a threat was
confirmed, the claim that a matter is "materially new," the danger
threshold, the certificate that an action is reversible, the mark that a
finding is or is not "critical," and the Layer 0 dispositions that close a
review — were **naked values**: a single actor could assert any of them,
and the kernel would reason correctly from a false premise. The strongest
theorems in the system rest on inputs nobody was required to justify.

**What Module 5 does.** It wraps each such input in a `SeamClaim`: a
**dated, attributed, contestable record** carrying who authorized the act,
what evidence supports it, how that evidence is held in custody, what
warnings were available, what counter-evidence exists, what observation
would prove the claim wrong, and — critically — the affected population's
own counter-record. Building the wrapper for an emergency now costs a
coordinated, attributable, auditable act by named roles, not the flip of a
bit.

**What Module 5 does NOT do — stated plainly and repeated everywhere.**
It **does not catch lies.** It has no `truth` field and proves no payload
true. A false emergency can still be declared; a false certificate can
still be issued; an official can still under-mark a finding. What changes
is that each of these becomes a **visible multi-party act with preserved
contradictions** instead of a silent administrative utterance. The system
converts lying from one person's cheap assertion into a documentary event
that names its participants and carries its own refutation. That, and only
that, is the claim.

**The one guarantee that is a hard wall, not a cost.** A community filing
under the ledger can *preserve, disclose, demand audit, and demand
provisional restraint* — and it can do **none** of these things become
punishment. The two are different types with no function between them
(`step_one_never_implies_step_two`). This is deliberate: it is what keeps
the ledger from becoming a new unconstrained authority. An allegation of
discernment-corruption never, by itself, unlocks coercion.

---

## II. Formal Appendix

Module 5 is `AHCKernel/SeamLedger.lean`: core-only Lean 4.15.0, no Mathlib,
15 audited theorems, axiom footprint at most `[propext, Quot.sound]`
(11 of the 15 axiom-free), zero `sorry`. It imports Modules 1 and 2 to bind
its theorems to the real episode machine and certificate layer.

**The wrapper.** `SeamClaim α` carries `payload : α` (the naked v0.12 value
verbatim) plus `incidentId`, `issuer`, `authorizationChain`,
`evidenceRefs`, `sourceBundleDigest`, `custodyStatus` (the ledger's
five-rung custody ladder `inLedger → captureRequired → locatorVerified →
hashedPendingBackup → verified`), `warningsAvailable`, `counterEvidence`,
`falsificationPath`, `affectedCounterRecord`, `conflicts`, and a procedural
`status`. It has **no `truth` field**, by design.

**Tier A — state-machine invariants.**

| Thm | Name | Statement (informal) |
|---|---|---|
| L1 | `no_naked_authority_bit` | An `issue` accompanied by no authorization chain or no evidence is never issued (the gate returns `false`). |
| L1' | `naked_issue_no_pending` | Bound to `estep`: from `idle`, a gate-failing `SeamClaim` produces no pending PIO. |
| L2 | `counterrecord_persists`(`_run`) | No official transition (`setStatus / addEvidence / reclassifyConflicts / close`), singly or in any finite sequence, alters an attached counter-record. |
| L2' | `counterrecord_digest_stable` | The counter-record stays bound to the same event hash across every official transition. |
| L3 | `step_one_never_implies_step_two` | No act a community/ledger trigger makes available (`preserve / disclose / audit / provisionalRestraint`) is a step-two (`punish / irreversibleEnforce`) authorization. |
| L4 | `remedy_label_not_remedy` | A remediation in stage `planIssued` does not close a Structural Review; `remedy_stages_distinct` proves the lifecycle stages are distinct by construction. |
| L5 | `contested_cannot_unlock_irreversible` | A `SeamClaim` with `status = materiallyContested` cannot satisfy the unlock predicate for any action. |
| L5' | `seam_trace_stays_inside` | Composed with W21: an uncontested authorized sub-causal trace from inside the certified region ends inside it; `contested_blocks_trace` refuses a contested trace. |

**Tier B — opaque-predicate relations.** Each relation the kernel cannot
verify is modelled as an abstract predicate the theorem quantifies over
every valuation of — the pattern Module 3 already uses for sensor honesty
(ground truth unavailable to the system). The kernel proves the structural
property for *all* valuations; it never decides the oracle.

| Thm | Name | Structural property proved | What is NOT proved (the oracle) |
|---|---|---|---|
| L6 | `issuer_not_sole_validator` | A multi-party validation has a validator distinct from the issuer. | Whether a listed actor truly validated (M5-O1). |
| L7 | `interested_actor_cannot_self_close` | For every interest relation: if all validators are interested, the close is not accepted. | Who is "interested" (M5-O5). |
| L8 | `challenge_requires_merits_response` | A rebuttal is unconstructible without an evidence reference; an undisposed challenge is unresolved. | Whether the rebuttal is correct (M5-O9). |
| L9 | `criticality_cannot_suppress_typed_conflict` | An affected-population counter-record bound to an event's digest survives official re-classification. | Who may *weight* the counter-record (M5-O8, deferred). |

**Modeling disclosures (labelled contestation targets).** The wrapper
**relocates** trust boundaries; it does not eliminate them. The nine new
oracles M5-O1..O9 are enumerated in `SEAM_TO_LEDGER_MAP.md §3`. Three carry
the boundary constraint that **no LLM classifier decides them** (M5-O3,
M5-O5, M5-O7, M5-O9 — all protected-path judgments). One (M5-O8, weighted
community standing) is **deferred pending governance machinery** for
representation, revocation, and intra-population disagreement — it is *not*
stubbed with a Boolean; the counter-register currently preserves any
attributed attachment, and standing to weight it is future work. If a
reviewer finds a tenth oracle the module hides, that is a finding against
the map.

**Deprecation.** v0.13 ships the wrappers additively; the naked
`EpInput` / `Envelope` / `Event` interfaces are marked deprecated with a
removal target of **v0.14**. A preserved bypass is technical debt made
normative; retaining the naked interfaces this round keeps the 116 v0.12
theorems stable, and the gating migration is scheduled, not indefinite.

**CI expectations (updated).** `docs/MANIFEST_v0.13.txt`. The build asserts
**131 audited theorems, 60 axiom-free** (v0.12's 116/49 plus Module 5's
15/11), every theorem at most `[propext, Quot.sound]`, never
`Classical.choice`, zero `sorry`. Source digest
`eca4b27e24d0999b90d913857839b4806b8ea7764b7ba0aa1f7c84bd9b1940ea`.

---

## III. Theorem-to-Text Mapping

Module 5 is the first module whose source text is **not** AHC v3.1 /
Companion A but the **Veriticide General Ledger** — cited as origin, not
merged. The mapping rows are therefore cross-repository citations. Full
quotation-level rows are appended to
`docs/normative/THEOREM_TO_TEXT_MAP.md` under "Module 5"; the correspondence
in brief:

| Kernel object | Veriticide source (machinery, not corpus) |
|---|---|
| `SeamClaim` fields (chain / evidence / warnings / counter-evidence / custody / falsifier / counter-record) | Documentation & Standing Protocol v0.1 §2 (six tracks A–F); §3 (ADVERSARIAL CHECK, COUNTER-EVIDENCE STATUS); case-file grammar `00-charge-theory` … `05-custody-manifest` |
| `CustodyStatus` ladder | `cases/*/05-custody-manifest.md` §1 (the five custody states) |
| `FalsificationCondition` | `cases/*/04-falsification-memo.md` |
| L3 `step_one_never_implies_step_two` | Standing Protocol §7 (the two-step position; "the clause that does not narrow away"); §7-bis (Forum-Now toggle) |
| L4 `remedy_label_not_remedy` | Convention/Protocol remedy-vs-label distinction; the toggle's "flipping is a logged act" |
| L8 `challenge_requires_merits_response` | Standing Protocol §3 (the two mandatory analytical fields) |
| L9 `criticality_cannot_suppress_typed_conflict` | Provenance Protocol §3 counter-register; Module 4 P4's disclosed incompleteness turned to the community's benefit |
| Cost-to-fake analyses (map column d) | Provenance Grading & Corpus-Absorption Protocol, Part II §5 (the cost-to-fake rule) |

The honest deviation a faithfulness reviewer should examine first: unlike
Modules 1–4, whose theorems formalize sentences of a fixed constitutional
text, Module 5's theorems formalize the *procedural machinery* of a
separate working repository. The correspondence is structural (a `SeamClaim`
field ↔ a protocol track), not quotational (a theorem ↔ a v3.1 sentence).
This is stated so it is not mistaken for the tighter Module 1–4 mapping.
