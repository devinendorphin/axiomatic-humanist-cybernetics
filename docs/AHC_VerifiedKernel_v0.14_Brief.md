# The Verified Constitutional Kernel
## Machine-Checked Invariants of Axiomatic Humanist Cybernetics v3.1

**Plain Language Summary · Formal Appendix · Reviewer Brief**
**Kernel version 0.14 — 2026-07-15**

Companion artifact to AHC v3.1 and Companion A (integrated), and — new in
this version — to the **Veriticide General Ledger**, whose machinery Module 5
imports.
**133 theorems · 5 modules + a cross-module bridge · Lean 4.15.0, core only · zero unproven claims.**
Source digest (sha256 over sorted sources):
`57aee1fd0aa9640610a1795682457a51a786659873616b04a58be4c178527e18`

Circulated under Principle 19.2 (Complexity Ceiling): this artifact adds no
new specification. It verifies specification that already exists and
identifies precisely where verification ends. Every change since the Phase 1
packet followed external review, never preceded it. Through v0.12 the kernel
is robust against MALFORMED inputs; **Module 5 — the Seam Ledger (Contested
Attestation Ledger)**, introduced in v0.13, opened a seam class the review
surface had not previously named, and **v0.14 completes it**: this version
executes the deprecation Module 5 scheduled — the naked issuing interface is
now gated behind the wrapper (§G, L10–L11), the sanctioned `seamStep` is the
issuing entry, and the naked path is deprecated in-code. Module 5
addresses the kernel's exposure to
WELL-TYPED LIES from legitimate authorities: its trusted inputs (the
emergency signals, the danger threshold, certificate validity, the
criticality classification, the Layer 0 dispositions) were naked values an
authority could cheaply assert, and the kernel reasoned correctly from
whatever it was given. Module 5 imports the *machinery* — not the corpus —
of the Veriticide General Ledger and wraps each such input in a `SeamClaim`:
a dated, attributed, contestable object. Its deliberate omission is a `truth`
field: **it proves no payload true.** It does not catch lies; it converts a
single administrative utterance into a visible multi-party act with preserved
contradictions. The two repositories cross-reference; they do not merge. The
full accounting is the new Part II.G; the design record is
`docs/module5/SEAM_TO_LEDGER_MAP.md`, and the change record is
`ERRATA_AND_AMENDMENTS.md` with every superseded digest retained for audit.

---

## Part I — Plain Language Summary

This summary follows the framework's own Plain Language Output Layer
requirement (AHC §10.4; Companion A Appendix B), applied to this artifact. A
constitutional architecture that requires plain-language accountability of
every output owes the same of its own proofs.

### What this is, and what has been done

The AHC constitution contains rules written in careful English: rules about
when the system may act and how hard, about how long an emergency may last,
about how measurements are combined, about what the public record of a
decision must contain. We translated five families of those rules into a
language a computer can check with complete rigor — a proof assistant called
Lean — and proved 133 statements about them. A proof assistant does not test a
rule on examples; it verifies that no counterexample can exist, anywhere,
ever, within the rules as written.

This is the thirteenth iteration of the kernel. The three prior review rounds
did exactly what review is for, and their repairs are settled (Part II.J).
This version does something different: it adds a fifth family addressed to a
gap no earlier round had named. Every guarantee through the twelfth version
protects against *malformed* inputs — a badly-built certificate, an
impossible sensor network. None protected against a *well-formed lie from a
legitimate authority.* The kernel's most load-bearing inputs — the request to
open an emergency, the claim a threat was confirmed, the mark that a finding
is or is not "critical" — were naked values a single official could assert,
and the machine reasoned correctly from a false premise. The fifth family
closes that seam, and is careful about exactly how far it reaches. The five
families:

**1. When the system may act, and how hard (the evidence ladder and the
emergency clock).** The system can never act more forcefully than its evidence
permits, and everything it does on less-than-conclusive evidence can be
undone. An emergency protective order that is not confirmed within 72 hours
reverses itself automatically — and the 72-hour limit bounds the *evidence*,
not merely the paperwork: a system cannot let a protective order lapse and
re-file the same stale case to buy another 72 hours. If real danger genuinely
persists past the deadline, the system does not simply lose all protection
(that would be inhumane) and does not silently keep its full emergency powers
(that would be lawless). It enters a narrow **continuity-hold**: a floor of
the mildest, certified-reversible measures, while a mandatory human review
decides what happens next. As of this version that review has teeth in both
directions. The review's outcome is *typed*: a denial or a close-out can
never quietly reset the system so a stale case can be re-filed — only an
explicit, publicly disclosed authorization of a new episode reopens the full
clock, and genuinely new evidence remains the other path. And the review
itself cannot be waited out: a hold left unreviewed for 72 hours under
continuing danger lands in a flagged **overdue** state — the protective floor
stays (a review breach is never a protection vacuum), but full emergency
authority is unavailable until the owed review actually happens, and the
record can never disguise an over-deadline hold as an ordinary one.
*Continuity of a signal is never continuity of authority.* This is proved.

**2. What "irreversible" means, and when the gravest tools are unlocked.** The
system's strongest enforcement mechanisms — cutting off capital, severing a
community from part of the network — are not presumed harmless. Whether a given
action is reversible is decided per deployment, by a public, contestable
certificate that must account for how concentrated it is, how long it lasts,
how critical the dependency, how fast it can be rolled back, and what cascades
it could trigger. Reversibility is judged by whether the *affected people and
institutions* can be restored — not by whether a wire can be reconnected.
Without such a certificate, an action is treated as irreversible and requires
the highest evidentiary tier (full causal proof). As of this version there is
no back door through the emergency system: an emergency order and the
continuity-hold floor can authorize an action *only through that same
certificate* — the reviewer showed that the older, mechanism-level emergency
rules could be read as bypassing the certificates, and that bypass is now
provably closed, with the old rules demoted to an outer bound the certified
layer can never exceed. A deployment in which *no* amount of a given action is
presumed safe — think payroll, medication supply, settlement infrastructure —
is a legal configuration. The absence of a certificate is never evidence of
reversibility.

**3. How measurements survive corruption.** If a minority of the system's
sensors are captured or corrupted, they cannot drag its robust statistics
outside the range of honest measurements, and they can never assemble a
certified reading entirely on their own. The emergency alarm is derived from
these measurements, and here is exactly what that buys — no more: every
certified alarm is vouched for by *at least one* honest sensor, so a captured
minority alone can neither manufacture the alarm that keeps a community under
protective authority nor sustain it. It does **not** yet mean that most honest
sensors agree with the alarm: a corrupted coalition plus a single honest
outlier can certify one. And the danger threshold the alarm is measured
against is, in the current model, an input the deployment must bind to a
fixed, public configuration — a system free to move its own threshold could
raise the alarm without touching any sensor. Both strengthenings — an alarm
derived from the robust median rather than a bare quorum, and a threshold
pinned to an attested policy — are named candidates for the next
formalization round, not claims of this one.

**4. What the public record of a decision must contain, and when.** If any one
community's viability collapses, the system's global health signal reads zero —
no prosperity elsewhere can mask it (and we prove that a *sum* would allow
masking where the chosen *product* does not; the design choice is what
prevents it). The plain-language record and the technical record of any
decision cannot disagree about anything *marked as mattering* for challenging
that decision while both comply with the rules — and if they do disagree, the
disagreement itself proves which record broke the rules. Whether everything
that genuinely matters is so marked is a human obligation at the seam, and we
now say so explicitly rather than letting "harmless" imply it. Everything
needed to challenge a decision is public at the moment the decision is made.
For an emergency order the record must state, at hour zero: *why* it was
authorized, *what makes any "new evidence" claim genuinely new* (challengeable
in itself), *how many hours of unreviewed protection the incident has already
consumed*, and *what evidence would prove the order wrong*. As of this
version those four fields are typed roles no single sentence can fill twice,
and the disclosed hour-count is not merely accompanied by a proof — it *is*
the machine's own count, one and the same object, in every version of the
record: the immediate one and the later civic and technical ones alike.

**5. When a trusted input is a naked assertion (the seam ledger — new in
this version).** Everything above assumes the values fed to the machine are
honest. The gravest inputs were, until now, bare: one official could flip the
"open an emergency" bit, assert a threat was "confirmed," declare a matter
"materially new," set the danger threshold, certify an action reversible, or
mark a damaging finding "not critical" — and the proofs would run correctly
on the lie. Module 5 takes each such input and requires it to arrive as a
**dated, attributed, contestable record**: who authorized it, what evidence
supports it, how that evidence is held, what warnings existed, what
counter-evidence exists, what observation would prove it wrong, and — kept on
the same record and never erasable — the affected population's own
counter-account. Opening an emergency now costs a coordinated, attributable,
auditable act by named roles, not the flip of a bit. **What this does not do,
stated plainly and meant literally: it does not catch lies.** There is no
field in which the system decides a claim is true. A false emergency can
still be declared; a false certificate can still be issued; an official can
still under-mark a finding. What changes is that each becomes a *visible,
multi-party, dated act that carries its own contradiction*, instead of one
person's silent assertion. And one guarantee here is a hard wall, not a cost:
a community filing under the ledger can *preserve, disclose, demand audit,
and demand provisional restraint* — and none of those can become punishment.
The two are different types with no path between them. This is deliberate: it
is what stops the ledger from becoming a new unaccountable power of its own.
An allegation never, by itself, unlocks coercion. This machinery is imported
from a separate working repository — the Veriticide General Ledger — which
this artifact cites as origin and does not absorb.

### What this system of proofs can and cannot see

The proofs verify the rules as written — not the world the rules act on. They
cannot see whether the sensors are truly independent, whether measurements
track real harm, whether a reversibility certificate honestly describes
reality, whether the recorded history of an incident is its true history,
whether the danger threshold has been honestly pinned, whether everything
material has been marked contestation-critical, or whether a plain-language
document genuinely means what its formal record claims. Those gaps are
deliberate and named in the artifact as **the seam**: machines check
everything that does not require human judgment, so that human judgment —
exercised by affected communities through Layer 0 — is spent only where
nothing can replace it. Module 5 is honest about its own limit here: wrapping
a naked input in a contestable record **relocates** trust — to whoever
attests the authorization chain, judges an actor "interested," or binds the
threshold configuration — it does not eliminate it. Those nine relocated
trust points (M5-O1..O9) are enumerated as first-class contestation targets
in the design record, and none of them is decided by any automated
classifier.

### What this artifact does not do right now

It does not make the AHC system exist, does not validate its statistical
methods, and does not certify any deployment. It certifies that the
constitutional text, in the parts formalized, cannot be lawyered into its
opposite — and that the resolutions of the questions raised against earlier
versions, including the most adversarial round to date, genuinely mean what
they say.

### What would prove this wrong, and how to challenge it

Every claim above is checkable by anyone, without trusting us. The complete
source is included; one command (`lake build`) re-verifies every proof from
scratch in seconds on an ordinary computer. If any proof were broken or
missing, the build would fail and say so. The honest points of challenge are
not the proofs but the modeling choices — the places where English was turned
into mathematics — and the standing question of whether the certificate,
disposition, and continuity-hold designs place their trust in the right
hands. Each module lists its own choices on its first page; Part III asks
reviewers to attack exactly those. The previous review round demonstrated the
method works: its findings were exhibited against the model, ruled on, and
closed with new theorems inside a version cycle.

If you find a problem — with a proof, with a translation choice, or with this
document itself — Part III says exactly where it goes and who must answer it. A
broken proof is fixed in the kernel; a wrong translation goes to the
constitution's own amendment process; a problem with how burden is placed on
communities goes to the Open Problems Register. Disagreement does not need our
permission to be filed.

### Where the full technical record is

The complete machine-checked source accompanies this document
(`ahc-verified-kernel/`), with build instructions in its README and the
theorem-to-specification map in Part II below. This summary is a navigation
entry point, not a substitute for that record.

---

## Part II — Formal Appendix

### A. Scope and claim

The kernel formalizes the order-theoretic and counting-theoretic core of AHC
v3.1: enforcement gating and the evidence–action ladder (§5.4, §9.2–9.3),
emergency time and the crisis cap (Companion A §12.3, AHC §10.3, §4.2),
measurement and aggregation (§8.3, §4.1–4.2, §1.1), output-register
invariance (§10.4; Companion A §5, §19.4, Appendix B), and — new in v0.13 —
the contested-attestation layer that wraps the kernel's trusted external
inputs, importing the machinery of the Veriticide General Ledger (§G). The
claim is exact and limited: the specification, as modeled, provably possesses
the 133 properties below. **The proofs verify the specification, not the
world** — and Module 5's theorems in particular are *procedural*: they prove
no wrapped input true (§G).

**Toolchain:** Lean 4.15.0, core library only — no Mathlib, no external
dependencies. **Zero `sorry` placeholders.** No theorem uses classical choice;
the total axiom footprint is `propext` and `Quot.sound` (the standard Lean
kernel axioms), and **60 of 133 theorems depend on no axioms at all**.
`decCompliant` is a verified `Decidable` instance, checked by elaboration and
additional to the 133.

### B. Module 1 — Tiered Evidence-Action Protocol (`TieredProtocol.lean`)

**Phase 1 core (§5.4, §9.2–9.3).**

| Theorem | Verified guarantee |
|---|---|
| `tier_monotone` (T1) | Authorization is upward-closed: stronger evidence never removes an authorized response. |
| `severity_le_evidence` (T2) | Response severity never exceeds evidence rank: force cannot outrun proof. |
| `sub_causal_reversible` (T3) | Everything authorized below Tier 3 is reversible. |
| `irreversible_iff_causal` (T4) | Irreversible mechanisms are authorized exactly at full causal identification. |
| `broadcast_universal` (T5) | The transparency broadcast is authorized at every tier: the system can always say what it sees. |
| `pio_ceiling` / `pio_reversible` (T6, T7) | No PIO state authorizes above Tier-1 severity; everything a PIO authorizes is reversible — at MECHANISM granularity, per the Phase 1 table. Since v0.9 this layer is quarantined: deployment-facing authorization is W10–W18. |
| `pio_resolves` (T8) | A PIO cannot remain pending past 72 hours: confirmed or auto-reversed (state-machine termination). |
| `no_chatter` (T9) | The hysteresis gap makes simultaneous escalate/de-escalate conditions unsatisfiable (instantaneous). |

**Temporal hysteresis — S1–S3 (§9.2; adopted v0.2, finding AHC-P1-002).** T9
holds at an instant but is satisfied even by a zero-width band. S1–S3 state the
*temporal* content of the gap: `oscillation_travel` (S1), `flips_travel_anchored`
(S2), and `chatter_requires_travel` (S3, headline) — over any trajectory,
(flips − 1)·(gap+1) ≤ total variation, so sub-band noise can flip the
enforcement posture at most once. Cycling requires genuine, repeated,
full-band swings.

**Episode machine, two clocks — E1–E15 (§5.4; adopted v0.4, rulings
D-R1A + D-R4; revised v0.10, findings R2-03/R2-06).** The hazard clock (danger
persists) and the epistemic clock (evidence advances) are separated. Layer 0
review outputs are typed dispositions (`continueHold | close | newEpisode`);
the continuity-hold carries a mandatory-review clock
(`holdReviewDeadline = 72`, a flagged deployment constant pending
ratification).

| Theorem | Verified guarantee |
|---|---|
| `episode_no_relitigation` (E1) | Across any span with no novel evidence and no NEW-EPISODE disposition — close and continue dispositions may flow freely — *whatever the exceedance and filing pattern*, unconfirmed full protection ≤ 72 hours. Strengthened in v0.10. |
| `episode_single_issuance` (E2) | At most one full-PIO issuance per such span. |
| `expiry_routes_by_risk` (E3) | At the deadline: continuing risk → continuity-hold; subsided risk → spent. No third outcome, no discretion. |
| `reonset_refloors` / `floor_persists` (E4, E5) | The floor follows the risk and is never withdrawn while risk persists unreviewed — the flagged `overdue` state keeps the floor. |
| `hold_resolution_iff` (E6) | Only an explicit new-episode disposition returns the hold to the restart-permitting posture. A denial, a close, or a continue cannot. |
| `novel_restart_from_spent` / `_from_hold` (E7) | An attested materially new claim restarts a full PIO. |
| `exceedance_cannot_restart` (E8) | Without novelty, no input re-enters the full clock from `hold`, `spent`, or `overdue`. |
| `hold_floor_reversible` / `_severity` / `hold_grants_no_more_than_pio` (E9–E11) | The Phase 1 mechanism-level floor bounds (superseded for deployment by W13–W16). |
| `close_cannot_launder` (E12) | A close disposition followed by a stale filing cannot reach the full clock — the third review's two-step restart witness, negated. |
| `hold_clock_bounded` (E13) | No reachable hold state carries a clock at or past the mandatory-review deadline. |
| `unreviewed_hold_expires` (E14) | Under continuing exceedance with no disposition, the hold reaches the flagged `overdue` state within its deadline and stays there: an infinite *silent* hold is unconstructible. |
| `overdue_absorbing` / `overdue_resolution_iff` (E15) | While risk persists, only a disposition exits `overdue`, and only a new-episode disposition reaches ordinary posture — Module 2's review discipline at PIO scale. |

**Certified reversibility envelopes — W1–W9 (§5.4, §9.3; adopted v0.4, rulings
D-R2A + D-R3).** An action carries an opaque deployment descriptor judged by a
deployment-certified `Envelope`. Routing *and* severance are
irreversibility-bearing unless certified. `cert_tier_monotone` /
`cert_severity_le_evidence` (W1, W2), `cert_sub_causal_reversible` (W3),
`cert_irreversible_iff_causal` (W4), `uncertified_routing_needs_causal` /
`uncertified_severance_needs_causal` (W5 — **Q2 answered: uncertified
severance is treated exactly as irreversible**), `certified_route_at_t1` /
`certified_severance_at_t2` (W6), `cert_refinement_conservative` (W7),
`no_certificate_no_presumption` (W8), `zero_envelope_constructible` (W9).

**Certified emergency authorization — W10–W18 (adopted v0.9, finding R2-01).**
The third review's most severe finding: the emergency path still authorized at
mechanism granularity, so a routing action outside every envelope was rejected
by the certificate layer while remaining authorized by a pending PIO — two
authorization APIs, no theorem forcing the stricter one. Closed:

| Theorem | Verified guarantee |
|---|---|
| `pio_cert_ceiling` / `pio_cert_reversible` (W10, W11) | T6/T7 lifted to certified actions: the emergency channel is severity-capped and reversible in the ENVELOPE sense — by certificate, not by the Phase 1 table's declaration. |
| `pio_certificate_backed` (W12) | A PIO authorizes routing only inside its envelope certificate, and no severance and no sanction in any state. |
| `hold_floor_cert_reversible` / `_severity` (W13, W14) | E9/E10 lifted to the envelope-indexed hold policy: floor reversibility is a theorem of the gating, not an asserted field. |
| `hold_floor_certificate_backed` (W15) | The floor's routing carries its certificate; severance and sanctions are unconstructible in it. |
| `hold_cert_grants_no_more_than_pio` (W16) | The certified floor is a remnant of PIO authority under the same envelope. |
| `cert_pio_refines_mech_pio` (W17) | Quarantine: the certified layer never grants an action whose mechanism the Phase 1 table would refuse — the legacy layer survives exactly as an outer presumptive bound. |
| `cert_hold_floor_constructible` (W18) | Non-vacuity: a broadcast-only certified floor exists for every envelope, including the zero envelope. |

**Exposure-indexed certificates and trace safety — W19–W26 (adopted v0.12,
finding R2-07).** The third review's structural centerpiece: pointwise
envelopes let ten individually certified actions jointly cross a liquidity,
dependency, or cascade threshold. Closed with the reviewer's prescribed
repair — a state-transition certificate. `TEnvelope` carries an exposure
state σ; certification judges each action *at* the accumulated exposure and
produces the exposure after it; the constitutive obligation (a structure
field) is that certification is only granted where the step keeps exposure
inside the demonstrated-reversible region. What σ measures, and whether the
region describes reality, are certification questions at the seam; what is
proved is that the gating composes.

| Theorem | Verified guarantee |
|---|---|
| `trace_tier_monotone` (W19) | T1/W1 at trace altitude: stronger evidence never de-authorizes a trace. |
| `trace_head_certificate_backed` (W20) | Every action of a sub-causal trace is certificate-backed at its own exposure point. |
| `trace_stays_inside` / `_prefix` (W21, W22) | **Headline:** a finite trace authorized below Tier 3 from inside the certified region stays inside it — at the end and at every intermediate point. Joint threshold-crossing by individually certified actions is unconstructible. |
| `pointwise_degenerate` (W23) | Every pointwise envelope is the trivial-exposure special case, authorizing exactly what it did: existing deployments are conserved; the obligation is what was missing, not a new burden. |
| `budget_binds_traces` (W24) | The review's liquidity example, formalized: under the cumulative-budget certificate, TOTAL routed volume over any authorized trace is within budget. |
| `pointwise_admits_joint_crossing` (W25) | The contrast witness (in the style of A1e): two actions each certified at frozen zero exposure whose two-action trace is refused — the old reading's failure mode, exhibited and excluded. |
| `pio_trace_stays_inside` (W26) | Tier-1 (PIO-grade) authorized sequences keep the exposure invariant: the emergency channel cannot accumulate its way across a certified threshold either. |

### C. Module 2 — Crisis Frequency Cap, Structural Review, Axiom II (`CrisisCap.lean`)

**Phase 1 core + composition.** `window_head_bound` (C1), `rolling_window_bound`
(C2), `no_permanent_emergency` (C3): the rolling window carries at most T_cap
emergency days, at every offset, for any continuation. `no_emergency_in_review`
(C4), `review_absorbing` (C5), `review_gate` (C6): no event grants emergency
authority during Structural Review, which only a Layer 0 constitutional output
can close. G1–G7 (adopted v0.2): the cap arithmetic and the review automaton
joined into one daily-step machine with the cap trip *derived* from the window
arithmetic.

**`axiomII_dichotomy` (A2a) — stated at its true strength (v0.11, finding
R2-09).** Every episode is exactly one of reversibility-claim-valid or locally
terminal: the §4.2 classification is exhaustive and exclusive, so "the system
corrected itself eventually" and "the harm was irreversible" cannot both be
asserted of one episode. This is a *well-formedness lemma* — the linear-order
dichotomy on the two latencies. It does not prove that terminality is
detected, that iteration halts, or that a terminal finding forces a change of
decision procedure; that operational content of Axiom II is a named
formalization candidate (Part III, F-4), not a theorem of this kernel.

**Module boundary, stated (finding R2-10).** The composed machine's
`requested` input is not bridged to Module 1's evidence-action protocol: the
crisis cap bounds the *frequency* of emergency authority; whether a given day
was evidence-authorized is Module 1's job, and a bridge theorem tying each
`requested` day to a Module 1 authorization is a named candidate. Likewise the
cap is generic in `T_cap < W`; a concrete audited instance at the spec's
constants (W = 730, T_cap = 180) is a candidate. Neither genericity weakens
C1–C3/G1–G7, which hold for every instance.

### D. Module 3 — Byzantine Measurement Consensus, Axiom I (`SensorsAndKernel.lean`)

*Unchanged since v0.1.* `honest_strict_majority` (B1), `exists_honest_le`/`_ge`
(B2), `median_bracketed` (B3): under m > 2f+1, a captured minority cannot drag a
median-type statistic outside the honest envelope. `no_corrupt_certificate`
(B4): no coalition of ≤ f sensors can certify a reading no honest sensor made.
`axiomI_null_kernel` (A1a) through `sum_admits_masking` (A1e): one non-viable
subgraph nullifies global viability (intersection and product forms), the
global signal is nonzero exactly when every subgraph's is, and aggregation by
sum provably admits the Korematsu Illusion that the product rules out.

### E. Module 4 — Plain Language Output Layer: Register Invariance (`PLOL.lean`)

**Phase 1 core.** `hash_bridge_origin` (P1), `tripartite_single_origin` (P1'),
`bridge_proves_origin_not_consistency` (P2, the specification's own limitation
proved with a witness), `compliant_registers_agree` (P3), `divergence_convicts`
(P3'), `no_hostage` (P5), `contestability_at_breach` (P5'), `decCompliant`
(P6): compliance is decidable; the divergence audit needs no expertise and no
discretion.

**`residual_divergence_noncritical` (P4) and
`later_residual_divergence_noncritical` (P13) — renamed to what they prove
(v0.11, finding R2-08).** Under compliance, any claim differing between
registers is a genuine claim of the event that was *not marked*
contestation-critical. The former name ("harmless") and the gloss "framing,
never findings" implied more: they are earned only under the additional
assumption that the critical classification is COMPLETE — that every material
finding is in fact marked critical. That completeness is an extraction /
Layer 0 obligation at the seam, now stated as such in the module header. The
theorems bound where divergence can live; they do not certify that what lives
there is benign.

**D-R4 disclosures — P7–P9 (adopted v0.5) and the typed claim language —
P14–P17 (adopted v0.8, findings R2-02/R2-04).** The third review exhibited the
gap: the disclosed budget claim was an untyped atom never connected to the
attestation whose accuracy P8 proves, and one claim could fill all four
mandatory disclosure roles. Closed: `PIOClaim` makes the four roles distinct
constructors, and `PIOEvent` carries its `BudgetAttestation` with the critical
set required to contain the budget claim bearing *the attested figure*.

| Theorem | Verified guarantee |
|---|---|
| `pio_disclosure_at_breach` (P7) | All four D-R4 fields are in the T+0 semantic record at hour zero. |
| `pio_disclosure_divergence_convicts` (P7') | Omission of any D-R4 field from any register proves that register non-compliant. |
| `attested_budget_accurate` (P8) / `attested_budget_bounded` (P9) | A budget attestation cannot misstate the episode machine's accounting, and is ≤ 72h over any novelty-free, authorization-free span (by E1). |
| `pio_roles_distinct` (P14) | The four disclosure roles are pairwise distinct claims, by constructor disjointness — one sentence cannot fill two roles. |
| `pio_register_budget_accurate` (P15) | Every compliant register contains the budget claim whose figure IS the machine's count over the attested history: disclosed = attested = computed, one term. |
| `pio_budget_no_drift` (P16) | Any budget-role claim in the critical set carries the machine's figure: two conflicting critical budget disclosures are unconstructible. |
| `pio_disclosed_budget_bounded` (P17) | The published figure inherits E1's 72-hour bound. |

**Later-register invariance — P10–P13 (adopted v0.7).**
`tripartite_critical_consensus` (P10), `later_registers_no_hostage` (P11),
`shipped_pio_disclosure_all_registers` (P12), and P13 above extend register
invariance across the full release. **Stated precisely (finding R2-11):**
`ShippedTripartite` carries later-register compliance as proof obligations —
these theorems are postconditions of an externally attested shipped release,
not a machine-verified publication workflow; no publication event or
release-hour ordering among the later registers is modeled.

### F. Bridge — Exceedance Derivation (`ExceedanceBridge.lean`, Module 1 × Module 3)

The episode machine consumes `exceedance` — the hazard signal that sustains a
continuity-hold — as an input. Adopted v0.6, this bridge derives it from the
measurement layer: a certified exceedance requires f+1 sensors reporting at or
above the danger threshold θ, so by B2 it always carries an honest witness.

**Stated at its true strength (v0.11, finding R2-05).** The property proved is
**one-honest-witness non-fabrication**: a captured minority of at most f
sensors can neither certify an alarm alone (X2) nor sustain a hold on a
fabricated one (X4), and every alarm the machine acts on is vouched for by at
least one honest sensor (X1, X3). It is **not** consensus: an f+1 quorum can
be met by the corrupt coalition plus a single honest outlier while most honest
sensors read below θ. And θ itself is carried per hour, unbound by the kernel
across time or policy version — a deployment able to lower θ can raise the
alarm without corrupting any sensor. Binding θ to a fixed, versioned, publicly
attested configuration is a deployment obligation; deriving exceedance from a
robust aggregate (B3 `median_bracketed` is the in-kernel candidate) with a
quantified honest-corroboration level is a named strengthening candidate
(Part III, F-4).

| Theorem | Verified guarantee |
|---|---|
| `derived_exceedance_honest_witnessed` (X1) | A certified exceedance always has an honest sensor at or above θ: never a pure fabrication of the corrupted coalition. |
| `derived_exceedance_not_forgeable` (X2) | If every honest sensor reads below θ, exceedance cannot be certified. |
| `hold_sustained_only_by_witnessed_danger` (X3) | Whenever the machine keeps a subgraph in a continuity-hold on a derived input, at least one honest sensor witnesses the danger. |
| `manufactured_danger_cannot_sustain_hold` (X4) | If every honest sensor reads below θ, the machine drops the subgraph out of the hold — at any hold-clock value. |

### G. Module 5 — Seam Ledger: Contested Attestation Ledger (`SeamLedger.lean`)

**Origin and scope (new in v0.13).** Module 5 imports the *machinery* of the
Veriticide General Ledger — its Documentation & Standing Protocol v0.1
(the six tracks, the two-step standing doctrine, the Forum-Now toggle), its
Provenance Grading Protocol (the cost-to-fake rule), and its case-file
grammar (the custody ladder, the adversarial-check and counter-evidence
fields) — as a neutral formal object. The ledger's corpus, named parties, and
structural-identity claim stay in that repository; **the two repositories
cross-reference, they do not merge.** `SeamClaim α` wraps a load-bearing
external input (`payload : α`, the naked v0.12 value verbatim) as a dated,
attributed, contestable object with an authorization chain, evidence refs, a
custody-ladder status, warnings-available, counter-evidence, a falsification
path, an affected-population counter-record, conflicts, and a procedural
status. **The deliberate omission is a `truth` field: the module proves no
payload true.** Every theorem is procedural — provenance identified, evidence
preserved, counter-evidence not erasable, issuer not sole validator,
contestation visible, responses evidence-linked, no silent rewrites.

**Tier A — state-machine invariants.**

| Theorem | Verified guarantee |
|---|---|
| `no_naked_authority_bit` (L1) / `naked_issue_no_pending` (L1') | An `issue` accompanied by no authorization chain or no evidence never initiates an emergency; bound to the real episode machine, from `idle` a gate-failing claim stays `idle`. |
| `counterrecord_persists` / `_run` (L2) / `counterrecord_digest_stable` (L2') | No official transition — re-status, add-evidence, re-classify, close — singly or in any finite sequence erases an attached affected-population counter-record or moves it off its event hash. |
| `step_one_never_implies_step_two` (L3) | **The firewall.** No act a community/ledger trigger makes available (preserve / disclose / audit / demand provisional restraint) is a step-two (punitive / irreversible) authorization: the two are disjoint by type. This is what keeps the ledger from becoming a new unconstrained authority; an allegation never itself unlocks coercion. |
| `remedy_label_not_remedy` (L4) / `remedy_stages_distinct` | A remediation in stage `planIssued` cannot close a Structural Review; the lifecycle `planIssued / implementationBegun / implementationVerified / effectVerified / failed / contested` is distinct by construction — a plan announced is never silently read as an effect verified. |
| `contested_cannot_unlock_irreversible` (L5) / `contested_blocks_trace` (L5'') / `seam_trace_stays_inside` (L5') | A materially contested claim unlocks nothing on its own, and the guard COMPOSES with the v0.12 exposure layer: an uncontested authorized sub-causal trace still stays inside the certified region (W21 verbatim), a contested one is refused. |
| `seam_no_naked_initiation` (L10) — *v0.14* | L1' lifted from `idle` to EVERY episode state: an unaccompanied claim (no authorization chain, or no evidence) initiates no fresh PIO from `idle`, `pending`, `hold`, `overdue`, `spent`, or `confirmed`. The naked bit is gated everywhere, not just at rest. |
| `seam_initiation_requires_accompaniment` (L11) — *v0.14* | The deployment-facing contrapositive: if the sanctioned interface (`seamStep`) initiates a fresh PIO, the driving claim carried BOTH a non-empty authorization chain AND at least one evidence reference. Emergency issuance from a bare bit is unconstructible at the sanctioned boundary. |

**Tier B — opaque-predicate relations.** Each relation the kernel cannot
verify (who "truly validated," who is "interested," whether a rebuttal is on
the merits) is modelled as an abstract predicate the theorem quantifies over
EVERY valuation of — the pattern Module 3 already uses for sensor honesty
(ground truth unavailable to the system). The kernel proves the structural
property for all valuations; it never decides the oracle, and no automated
classifier decides any protected-path question.

| Theorem | Verified guarantee (structural) — and the oracle it does NOT decide |
|---|---|
| `issuer_not_sole_validator` (L6) | A multi-party validation has a validator distinct from the issuer. (Not: whether a listed actor truly validated — M5-O1.) |
| `interested_actor_cannot_self_close` (L7) | For every interest relation: if all validators are interested, the close is not accepted. (Not: who is "interested" — M5-O5.) |
| `challenge_requires_merits_response` (L8) | A rebuttal is unconstructible without an evidence reference; an undisposed challenge is unresolved. (Not: whether the rebuttal is correct — M5-O9.) |
| `criticality_cannot_suppress_typed_conflict` (L9) | An affected-population counter-record bound to an event digest survives official re-classification. (Not: who may *weight* it — M5-O8, deferred pending governance machinery.) |

**Relocated trust, disclosed.** The wrapper relocates trust boundaries, it
does not remove them; nine oracles M5-O1..O9 are named as first-class
contestation targets in `docs/module5/SEAM_TO_LEDGER_MAP.md §3`. Weighted
community standing (M5-O8) is *deferred* pending governance machinery for
representation, revocation, and intra-population disagreement — not stubbed
with a Boolean. Backward compatibility does not preserve a safety bypass:
v0.13 shipped the wrappers additively alongside the naked `EpInput` /
`Envelope` / `Event` interfaces; **v0.14 executes the deprecation.** The
sanctioned issuing interface is now `seamStep` (the episode machine driven
through a `SeamClaim`), the naked issuing path is marked
`@[deprecated seamStep]` in-code, and **L10–L11** prove the gate is total —
no unaccompanied bit initiates a fresh PIO from *any* state, and sanctioned
issuance implies a non-empty authorization chain and evidence. The internal
`estep`/`EpInput` remain undeprecated: they are the machine, not the bypass.

### H. Modeling disclosures — the contestation targets

Per the framework's norm, every translation choice is stated in the header of
its module. The most load-bearing:

- **Time is discretized** — hours for the PIO/episode machine, days for the
  Crisis Cap trace; the 72h PIO constant is the spec's. The hold's
  mandatory-review period (`holdReviewDeadline = 72`) is set equal to the PIO
  deadline **pending a constitutional ruling on the constant** — the E12–E15
  theorems hold for any positive value.
- **Layer 0 outputs are typed dispositions** (v0.10): continue, close, or
  new-episode. The *substance* of a disposition and the basis of a
  new-episode authorization live outside the machine, disclosed through
  D-R4. From the flagged `overdue` state, novel filings wait on the owed
  review; Layer 0 can authorize immediately via a new-episode disposition —
  the same body that attests novelty.
- **The episode's `novel` input is an ATG/Layer 0 attestation** attached to a
  claim identity (D-R4); `exceedance` is the raw risk signal. The hazard
  clock and the epistemic clock never share a needle.
- **Reversibility is an opaque deployment certificate** (`Envelope`); the
  kernel gates on the certificate but does not verify that it describes
  reality. Since v0.9 the PIO and hold floor authorize only certified
  actions (`pioAuthorizesC`, `CHoldPolicy`), and W17 proves the legacy
  mechanism table is an outer bound, not an authorization channel.
  Since v0.12 certification is exposure-indexed (`TEnvelope`, W19–W26):
  each action is certified against the deployment's accumulated exposure,
  with invariant preservation the constitutive obligation. What the
  exposure state measures is a certification question at the seam.
- **The danger threshold θ is a free per-hour input** the deployment must
  bind institutionally (finding R2-05); the quorum property is
  one-honest-witness non-fabrication, not consensus.
- **The budget attestation's figure IS the disclosed claim** (v0.8); whether
  the *recorded history* is the true history is institutional (append-only
  logs, Layer 0 audit) — anchoring the history to a canonical log head is a
  named candidate.
- **Completeness of the critical classification** — that every material
  finding is marked contestation-critical — is an extraction/Layer 0
  obligation at the seam (v0.11, finding R2-08).
- **Constitutive constraints are structure fields** — the hysteresis gap,
  T_cap < W, the m > 2f+1 quorum, the D-R4 roles with the attested figure —
  so degenerate or withholding parameterizations are unconstructible.
- **A `SeamClaim` carries no `truth` field** (v0.13): Module 5 proves no
  wrapped input true. Its Tier B relations (actor-identity/conflict,
  contestation-materiality, rebuttal merits) are opaque predicates quantified
  over every valuation, à la Module 3 sensor honesty; the kernel checks
  structure, never substance, and no automated classifier decides any
  protected-path question. The nine relocated oracles M5-O1..O9 are the
  contestation targets, weighted community standing (M5-O8) is deferred, and
  the naked input interfaces are retained additively pending v0.14 removal.

### I. What is not verified, and why

The statistical layer (three-stage causal identification §5.5) is not
Lean-shaped; its instrument is pre-registration and blind historical
validation (OP.4, Companion B). Viability-kernel dynamics over continuous
state spaces are the province of viability theory. Sensor independence is an
institutional achievement (OP.1), assumed as the ≤ f fault bound. The
certificate, disposition, and continuity-hold designs move trust to named
institutional points — who issues, contests, and revokes an `Envelope`,
`CHoldPolicy`, or Layer 0 disposition; who binds θ; who guarantees an
incident's recorded history; who marks the critical set completely — and
those points are named, not resolved, here. The relation between a
natural-language text and the claim set it expresses — the seam — is formally
unverifiable by construction: all trust is consumed at claim extraction, none
after it, and extraction belongs to Layer 0. The kernel's contribution is to
prove that everything after extraction is mechanical (`decCompliant`), that
divergence convicts (`divergence_convicts`, `pio_disclosure_divergence_convicts`),
and that the one quantitative disclosure is the machine's own number
(P15/P16). Module 5 (v0.13) does not close the seam — it *instruments* it:
it does not verify that an authorization chain truly approved an act, that a
custody status honestly describes an artifact's provenance, that a stated
falsifier is the right one, or that an actor flagged "interested" really is.
Those are the nine relocated oracles M5-O1..O9, each disclosed as a
contestation target; the module's honest claim is redistribution — from a
single cheap anonymous bit to a dated, attributed, multi-party record whose
falsification is itself an act on the record — not elimination of trust.

### J. Reproduction

Requirements: any machine with `elan` (the Lean toolchain manager). Then:

```
cd ahc-verified-kernel
lake build
```

The build elaborates every proof and prints the axiom audit
(`AHCKernel/Audit.lean`) to the log. A missing or broken proof fails the
build; a placeholder surfaces as the `sorryAx` axiom. **Expected:** 133
audited theorems, each at most `[propext, Quot.sound]`; never
`Classical.choice`; 60 axiom-free. A continuous-integration workflow re-runs
this check on every change and fails on any deviation from the 133/60
footprint.

### K. Disposition of the review rounds (Reviewer #2, 2026-07-13) and the v0.13 addition

| Finding | Severity | Disposition |
|---|---|---|
| R2-01 emergency path bypasses the certificate layer | Critical | **Closed in Lean** — v0.9, W10–W18 (quarantine theorem W17). |
| R2-02 disclosed budget claim not linked to its attestation | Critical | **Closed in Lean** — v0.8, P14–P17 (one term by construction). |
| R2-03 Layer 0 Boolean launders a stale restart | High | **Closed in Lean** — v0.10, typed dispositions; E6 revised, E12. |
| R2-04 four disclosure fields may be one atom | High | **Closed in Lean** — v0.8, P14 (constructor disjointness). |
| R2-05 exceedance overclaimed as consensus; θ free | High | **Claims narrowed** (v0.11, Part II.F); θ-binding and median-derived exceedance are named candidates. |
| R2-06 continuity-hold unbounded | High | **Closed in Lean** — v0.10, clocked hold, `overdue`, E13–E15. |
| R2-07 envelope predicates not compositional | High | **Closed in Lean** — v0.12, `TEnvelope` and W19–W26, per the report's prescribed repair. |
| R2-08 "harmless" ≠ "not marked critical" | Medium | **Renamed and re-scoped** (v0.11, P4/P13); completeness stated as a seam obligation. |
| R2-09 Axiom II dichotomy near-tautological | Medium | **Re-glossed as well-formedness** (v0.11); operational theorem is a named candidate. |
| R2-10 crisis cap not evidence-bridged; constants generic | Medium | **Boundary stated** (Part II.C); bridge and concrete instance are named candidates. |
| R2-11 shipped-release compliance assumed | Medium | **Stated as postconditions** of an attested shipped release (Part II.E). |
| R2-12 packet not self-contained for faithfulness review | — | **Packaging commitment**: the next circulation packet will include pinned excerpts of AHC v3.1/Companion A with a theorem-to-text map. |
| Documentation items 1–7 | — | Items 1–4 fixed; checksums manifest, provenance attestation, and CI pinning are packaging work in progress. |

**v0.13 is not a finding closure.** Every row above was settled by v0.12.
Module 5 is the first addition that does not answer a Reviewer #2 item but
opens a seam class the three rounds had not named: the kernel's robustness
against malformed inputs never extended to well-typed lies from legitimate
authorities. It is introduced under the same discipline — the design record
(`docs/module5/SEAM_TO_LEDGER_MAP.md`) states its scope, its cost-to-fake
analysis, and its nine relocated oracles before any Lean; Part III solicits
attack on exactly those. Reflexivity, carried per the imported ledger's own
provenance rule: the Veriticide corpus documents Anthropic among its
subjects and Module 5 was authored by an Anthropic model, IN-FRAMEWORK
(near-zero convergence value; the worth rests in the externally checkable
artifacts — these proofs compile core-only with the published footprint, or
they do not).

**v0.14 closes the loop Module 5 left open.** Where v0.13 shipped the wrapper
alongside the naked interfaces and merely *scheduled* their removal, v0.14
executes that schedule: L10–L11 lift the gate from `idle` to every state and
give it a deployment-facing contrapositive, `seamStep` becomes the sanctioned
entry, and the naked issuing path is `@[deprecated]` in-code — a preserved
bypass turned into a marked, migrating one. The footprint moves 131/60 →
133/60; nothing else in Module 5's guarantees or disclosures changes.

## Part III — Reviewer Brief

Companion A Principle 19.2 holds that further specification must follow, not
precede, external review. Three rounds have now done so: Phase 1 findings
(AHC-P1-001..008), the constitutional-review findings (CG-1..CG-6) with
rulings D-R1A/D-R2A/D-R3/D-R4, and the adversarial third round (R2-01..R2-12)
whose disposition is Part II.J. Notably, the third round answered a question
this brief's predecessor posed: v0.7's F-2 asked whether the hold should carry
"a bound … before mandatory resolution", and R2-06's answer is now theorem
E14. This round solicits attack on the repairs themselves, and on the
surfaces they expose.

### For formal-methods reviewers

**F-1 (Faithfulness of the repairs).** For each third-round repair, does the
formal reading weaken or strengthen the constitution's intent? Specific
targets: does `overdue`'s refusal of novel-evidence restarts (a materially new
claim must wait on the owed review, or arrive as a new-episode disposition)
match §5.4's intent, or over-punish the protected community for the
institution's failure to review? Is routing every disposition's substance
outside the machine the right seam placement? Does W17's quarantine leave any
deployment-facing use of the legacy mechanism table that should be forbidden
outright?

**F-2 (Disposition and overdue semantics).** The typed dispositions collapse
Layer 0's decision space to three outcomes. Is that the right partition —
should a denial be distinguished from a close, or a conditional continuation
carry structure? From `overdue`, exceedance subsiding returns the subgraph to
`spent`: does the review obligation rightly evaporate with the risk, or
should a breach flag survive into the record's ordinary posture?

**F-3 (The exposure-indexed certificate — review of the R2-07 repair).**
v0.12 implements the report's prescribed state-transition certificate
(`TEnvelope`, W19–W26): certification consumes and produces an exposure
state, and invariant preservation is the constitutive obligation. Solicited:
is a single per-deployment exposure state the right altitude, or do distinct
resources (liquidity, dependency, cascade) need distinct, jointly-constrained
states? Should exposure *decay* (rollbacks and restorations reducing it), and
what does a sound decay obligation look like? Is `Inv`-preservation the right
obligation, or should the certificate carry a quantitative margin? And does
anything in D-R2A/D-R3's intent require the trace regime to be mandatory
rather than the pointwise degenerate case remaining constructible (W23)?

**F-4 (Strengthening candidates, updated).** Named and open: (i) exceedance
from a robust aggregate (B3) with a quantified honest-corroboration level, and
θ bound to an attested configuration (R2-05); (ii) the operational content of
Axiom II — `locallyTerminal` forcing a prohibited transition or mandatory
structural review (R2-09); (iii) a Module 1 × Module 2 bridge tying each
crisis-cap `requested` day to an evidence authorization, and a concrete
audited instance at W = 730, T_cap = 180 (R2-10); (iv) anchoring the budget
attestation's history to a canonical append-only log head (L-2); (v) a
publication-event model making P10–P13 unconditional (R2-11).

**F-5 (The seam ledger — review of Module 5, new this round).** Module 5
proves procedural status only and carries no `truth` field; its Tier B
relations are opaque predicates quantified over every valuation. Solicited:
is the `SeamClaim` field set complete for the six-track discipline it
imports, or does a load-bearing input escape the wrapper? Is
`step_one_never_implies_step_two` — the firewall making community triggers
and punitive authorizations disjoint types — stated at the right altitude,
and does any composition let a step-one object reach a step-two channel? Does
`seam_trace_stays_inside` compose correctly with W21, or does the
contestation guard interact with the exposure invariant in an unintended way?
And is the opaque-predicate modeling (M5-O5/O7/O9) genuinely
valuation-independent, or does any Tier B theorem smuggle in a fact about the
oracle it claims not to decide? A reviewer finding a tenth relocated oracle
the seam map does not disclose has found a defect in the map.

### For constitutional and domain reviewers

**D-1 (Certificate governance).** Rulings D-R2A/D-R3 place reversibility in a
deployment certificate that must be public, contestable, and revocable — and
since v0.9 the emergency path cannot act outside it. Who issues it, who may
contest it, and what happens to actions taken under a certificate later
revoked?

**D-2 (The novelty determination).** D-R4 makes `novel` a contestable Layer 0
attestation. Who adjudicates novelty under time pressure during an ongoing
incident, and does the contestability right function before, not only after,
the protective window it governs?

**D-3 (Hold humaneness in deployment).** The continuity-hold prevents an
abrupt protection vacuum (E5), and now cannot be left silently unreviewed
(E14). Does a real deployment's certified floor actually protect an affected
community, or could a minimal floor satisfy the theorems while leaving people
materially unprotected?

**D-4 (Severance certification in the field).** D-R3's soft-severance
conditions are constitutional text. Are they the right conditions, and is
"tested restoration rather than theoretical reconnection" operationalizable?

**D-5 (Disposition governance — new this round).** The typed dispositions and
the `overdue` state give Layer 0's review real mechanical force: a
new-episode disposition is now the only non-evidentiary path to full
authority, and an unperformed review parks a community's emergency apparatus
in a breach state. Who staffs that review at the required cadence, what
happens to communities whose institutions chronically run `overdue`, and is
`holdReviewDeadline = 72` the right constant to ratify?

**D-6 (Seam-ledger governance — new this round).** Module 5 relocates trust
to named oracles rather than eliminating it, and defers weighted community
standing (M5-O8) pending governance machinery. Solicited: what body attests
an authorization chain, and what is the remedy when a chain is later shown
false? Who is authorized to attach an affected-population counter-record, and
how is standing to *weight* competing counter-records to be constructed
without recreating the very authority the two-step firewall forbids
(representation, revocation, intra-population disagreement)? And on
deprecation, now that **v0.14 has executed it** (the naked issuing path is
`@[deprecated]`, `seamStep` is the sanctioned entry, L10–L11 prove the gate
is total): is deprecating only the *issuing* surface the right scope, or
should the certificate (`Envelope`) and criticality (`Event`) construction
sites be gated on the same schedule? And is an in-code `@[deprecated]`
attribute a strong enough removal commitment, or should a future version make
the naked constructors unreachable outright?

### For community and legibility reviewers

**L-1 (Reflexive compliance).** Part I claims PLOL conformance for this
document. Audit it against Appendix B.2 and the D-R4 fields: is anything a
community reviewer needs missing, and does the falsification pathway function
for a non-expert with the Community Statistical Support Fund's resources?

**L-2 (The budget figure's meaning, updated).** P15/P16 now make the
disclosed figure the machine's own count — the attachment gap the third round
exhibited is closed. What remains is the deeper half: the figure is only as
honest as the recorded incident history. Is "the recorded history is the true
history" a burden that quietly falls on communities, and what institutional
guarantee (append-only logs, independent Layer 0 audit, the named log-head
anchor) does it require?

**L-3 (The seam's placement, revisited).** This cycle moved trust to further
named points — disposition substance, θ binding, critical-set completeness —
alongside certificate issuance, novelty attestation, and history integrity.
Are these the right custodians, or does the accumulation relocate expert
burden onto communities across several fronts at once?

**L-4 (The ledger's burden and its promise — new this round).** Module 5
gives affected populations a same-hash counter-record that no official
transition can erase — a real shift of standing toward the affected. But it
also asks them to produce dated, custody-bearing records to make a
contestation "material," and the cost-to-fake discipline it imports is
demanding. Does the wrapper's requirement land as protection or as a new
documentary burden on the least-resourced party, and does the imported
Community Statistical Support Fund posture extend to the custody and
falsification work the `SeamClaim` fields now presuppose? Is the promise —
lying made visible and multi-party rather than caught — the right honest
claim to make to a community, or does "we do not catch the lie" undercut the
protection in practice?

### Disposition of findings

Findings against proofs (F-class) invalidate specific theorems and are
corrected in the kernel. Findings against modeling choices and rulings (F-1,
D-class) are constitutional-interpretation questions and route to the
specification's amendment processes; the kernel then re-verifies the amended
reading — as it has done through eleven versions and three review rounds.
Findings against the seam's placement (L-class) route to the Open Problems
Register. In all three cases the artifact's function is the same: it converts
disagreement about what the constitution means into a precise, checkable
object — which is what a formal layer is for.

---

*— End of circulation brief. The machine-checked source, the module READMEs,
the theorem-to-specification map (with the new Module 5 cross-repository
section), the Module 5 design record and circulation amendment
(`docs/module5/SEAM_TO_LEDGER_MAP.md`, `docs/module5/CIRCULATION_AMENDMENT.md`),
the amendment record (`ERRATA_AND_AMENDMENTS.md`), the author response to the
third review (`external-reviews/2026-07-13-reviewer2-response.md`), the
archived external reviews, and the CI workflow accompany this document. The
Veriticide General Ledger, whose machinery Module 5 imports, is a separate
repository cited as origin and not absorbed. —*
