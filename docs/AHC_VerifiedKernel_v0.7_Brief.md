# The Verified Constitutional Kernel
## Machine-Checked Invariants of Axiomatic Humanist Cybernetics v3.1

**Plain Language Summary · Formal Appendix · Reviewer Brief**
**Kernel version 0.7 — 2026-07-12**

Companion artifact to AHC v3.1 and Companion A (integrated).
**89 theorems · 4 modules + a cross-module bridge · Lean 4.15.0, core only · zero unproven claims.**
Source digest (sha256 over sorted sources):
`8d262152c5f9036b20de9ea1c395a8edf31b4bfd2df893e8a4466d65b56736d0`

Circulated under Principle 19.2 (Complexity Ceiling): this artifact adds no
new specification. It verifies specification that already exists — including
five rulings and two cross-module bridges arising from the first two review rounds — and
identifies precisely where verification ends. Every change since the Phase 1
packet followed external review, never preceded it; the full change record is
`ERRATA_AND_AMENDMENTS.md`, and every superseded version's digest is retained
there for audit.

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
decision must contain. We translated four families of those rules into a
language a computer can check with complete rigor — a proof assistant called
Lean — and proved 89 statements about them. A proof assistant does not test a
rule on examples; it verifies that no counterexample can exist, anywhere,
ever, within the rules as written.

This is the seventh iteration of that kernel. The first (v0.1, 34 theorems) was
circulated for review. Reviewers found no broken proof, but they found places
where the English said more than the mathematics had captured, and questions
the constitution had left open. Those findings were ruled on by the
framework's stewards and the rulings were formalized — so the kernel now
proves not only the original invariants but the resolutions of every question
raised against it. The four families:

**1. When the system may act, and how hard (the evidence ladder and the
emergency clock).** The system can never act more forcefully than its evidence
permits, and everything it does on less-than-conclusive evidence can be
undone. An emergency protective order that is not confirmed within 72 hours
reverses itself automatically — and, as of this version, the 72-hour limit
bounds the *evidence*, not merely the paperwork: a system cannot let a
protective order lapse and immediately re-file the same stale case to buy
another 72 hours. If real danger genuinely persists past the deadline, the
system does not simply lose all protection (that would be inhumane) and does
not silently keep its full emergency powers (that would be lawless). It enters
a narrow **continuity-hold**: a floor of the mildest, fully reversible
measures, while a mandatory human review decides what happens next. Only
genuinely new evidence — not the mere persistence of the alarm — can restart a
full emergency order. *Continuity of a signal is never continuity of
authority.* This is proved.

**2. What "irreversible" means, and when the gravest tools are unlocked.** The
system's strongest enforcement mechanisms — cutting off capital, severing a
community from part of the network — are not presumed harmless. Whether a given
action is reversible is decided per deployment, by a public, contestable
certificate that must account for how concentrated it is, how long it lasts,
how critical the dependency, how fast it can be rolled back, and what cascades
it could trigger. Reversibility is judged by whether the *affected people and
institutions* can be restored — not by whether a wire can be reconnected.
Without such a certificate, an action is treated as irreversible and requires
the highest evidentiary tier (full causal proof). A deployment in which *no*
amount of a given action is presumed safe — think payroll, medication supply,
settlement infrastructure — is a legal configuration. The absence of a
certificate is never evidence of reversibility.

**3. How measurements survive corruption.** If a minority of the system's
sensors are captured or corrupted, they cannot drag its thresholds outside the
range of honest measurements, and they can never fabricate a certified reading
on their own. As of this version, the emergency system's alarm itself is
derived from these same corruption-resistant measurements: a captured minority
can neither manufacture the alarm that would keep a community under protective
authority, nor stand as the sole basis of one.

**4. What the public record of a decision must contain, and when.** If any one
community's viability collapses, the system's global health signal reads zero —
no prosperity elsewhere can mask it (and we prove that a *sum* would allow
masking where the chosen *product* does not; the design choice is what
prevents it). The plain-language record and the technical record of any
decision cannot disagree about anything that matters for challenging that
decision while both comply with the rules — and if they do disagree, the
disagreement itself proves which record broke the rules. Everything needed to
challenge a decision is public at the moment the decision is made. As of this
version, an emergency protective order's public record must additionally state,
at hour zero: *why* it was authorized (new evidence, continuing danger, or
both), *what makes any "new evidence" claim genuinely new* (and that
determination can itself be challenged), *how many hours of unreviewed
protection the incident has already consumed* — and that number provably
matches the system's own internal count, so the public figure cannot be
understated — and *what evidence would prove the order wrong.* These
accountability fields, and the findings they accompany, must appear in *every*
version of the public record — the immediate one and the later civic and
technical ones alike; a later version cannot quietly drop what the first made
public.

### What this system of proofs can and cannot see

The proofs verify the rules as written — not the world the rules act on. They
cannot see whether the sensors are truly independent, whether measurements
track real harm, whether a reversibility certificate honestly describes
reality, whether the recorded history of an incident is its true history, or
whether a plain-language document genuinely means what its formal record
claims. Those gaps are deliberate and named in the artifact as **the seam**:
machines check everything that does not require human judgment, so that human
judgment — exercised by affected communities through Layer 0 — is spent only
where nothing can replace it.

### What this artifact does not do right now

It does not make the AHC system exist, does not validate its statistical
methods, and does not certify any deployment. It certifies that the
constitutional text, in the parts formalized, cannot be lawyered into its
opposite — and that the resolutions of the questions raised against earlier
versions genuinely mean what they say.

### What would prove this wrong, and how to challenge it

Every claim above is checkable by anyone, without trusting us. The complete
source is included; one command (`lake build`) re-verifies every proof from
scratch in seconds on an ordinary computer. If any proof were broken or
missing, the build would fail and say so. The honest points of challenge are
not the proofs but the modeling choices — the places where English was turned
into mathematics — and the newer question of whether the certificate and
continuity-hold designs place their trust in the right hands. Each module
lists its own choices on its first page; Part III asks reviewers to attack
exactly those.

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
measurement and aggregation (§8.3, §4.1–4.2, §1.1), and output-register
invariance (§10.4; Companion A §5, §19.4, Appendix B). The claim is exact and
limited: the specification, as modeled, provably possesses the 89 properties
below. **The proofs verify the specification, not the world.**

**Toolchain:** Lean 4.15.0, core library only — no Mathlib, no external
dependencies. **Zero `sorry` placeholders.** No theorem uses classical choice;
the total axiom footprint is `propext` and `Quot.sound` (the standard Lean
kernel axioms), and **40 of 89 theorems depend on no axioms at all**, including
every Phase 1 theorem of the PLOL module. `decCompliant` is a verified
`Decidable` instance, checked by elaboration and additional to the 89.

### B. Module 1 — Tiered Evidence-Action Protocol (`TieredProtocol.lean`)

**Phase 1 core (§5.4, §9.2–9.3).**

| Theorem | Verified guarantee |
|---|---|
| `tier_monotone` (T1) | Authorization is upward-closed: stronger evidence never removes an authorized response. |
| `severity_le_evidence` (T2) | Response severity never exceeds evidence rank: force cannot outrun proof. |
| `sub_causal_reversible` (T3) | Everything authorized below Tier 3 is reversible. |
| `irreversible_iff_causal` (T4) | Irreversible mechanisms are authorized exactly at full causal identification. |
| `broadcast_universal` (T5) | The transparency broadcast is authorized at every tier: the system can always say what it sees. |
| `pio_ceiling` / `pio_reversible` (T6, T7) | No PIO state authorizes above Tier-1 severity; everything a PIO authorizes is reversible. |
| `pio_resolves` (T8) | A PIO cannot remain pending past 72 hours: confirmed or auto-reversed (state-machine termination). |
| `no_chatter` (T9) | The hysteresis gap makes simultaneous escalate/de-escalate conditions unsatisfiable (instantaneous). |

**Temporal hysteresis — S1–S3 (§9.2; adopted v0.2, finding AHC-P1-002).** T9
holds at an instant but is satisfied even by a zero-width band. S1–S3 state the
*temporal* content of the gap: `oscillation_travel` (S1) — escalating and
de-escalating values differ by more than the gap width; `flips_travel_anchored`
(S2) — every posture flip costs the signal more than the gap of travel;
`chatter_requires_travel` (S3, headline) — over any trajectory,
(flips − 1)·(gap+1) ≤ total variation, so sub-band noise can flip the
enforcement posture at most once. Cycling requires genuine, repeated,
full-band swings.

**Episode machine, two clocks — E1–E11 (§5.4; adopted v0.4, rulings
D-R1A + D-R4).** The hazard clock (danger persists) and the epistemic clock
(evidence advances) are separated. Only an attested materially new claim
restarts a full 72-hour PIO; persistence of the alarm sustains only a
constrained **continuity-hold** floor.

| Theorem | Verified guarantee |
|---|---|
| `episode_no_relitigation` (E1) | Across any span with no novel evidence and no Layer 0 resolution, *whatever the exceedance and filing pattern*, unconfirmed full protection ≤ 72 hours. |
| `episode_single_issuance` (E2) | At most one full-PIO issuance per such span. |
| `expiry_routes_by_risk` (E3) | At the deadline: continuing risk → continuity-hold; subsided risk → spent. No third outcome, no discretion. |
| `reonset_refloors` / `hold_persists` (E4, E5) | The hold floor follows the risk and is never withdrawn while risk persists unresolved. |
| `hold_resolution_iff` (E6) | Only a Layer 0 review output returns the hold to ordinary posture — not time, not filings. |
| `novel_restart_from_spent` / `_from_hold` (E7) | An attested materially new claim restarts a full PIO. |
| `exceedance_cannot_restart` (E8) | Without novelty, no input re-enters the full clock: continuity of a signal is never continuity of the full authority. |
| `hold_floor_reversible` / `_severity` / `hold_grants_no_more_than_pio` (E9–E11) | The hold floor is reversible-only, Tier-1-capped, and a remnant of PIO authority — never an extension. |

**Certified reversibility envelopes — W1–W9 (§5.4, §9.3; adopted v0.4, rulings
D-R2A + D-R3).** An action carries an opaque deployment descriptor (magnitude,
concentration, duration, rollback latency, cascade …) judged by a
deployment-certified `Envelope`. Routing *and* severance are
irreversibility-bearing unless certified.

| Theorem | Verified guarantee |
|---|---|
| `cert_tier_monotone` / `cert_severity_le_evidence` (W1, W2) | T1/T2 lifted to certificate-bearing actions. |
| `cert_sub_causal_reversible` (W3) | Everything authorized below Tier 3 is reversible — routing and severance — as a consequence of gating, not fiat. |
| `cert_irreversible_iff_causal` (W4) | T4 lifted to certificate-bearing actions. |
| `uncertified_routing_needs_causal` / `uncertified_severance_needs_causal` (W5a, W5b) | No certificate ⇒ Tier 3. **Q2 answered: uncertified severance is treated exactly as irreversible.** |
| `certified_route_at_t1` / `certified_severance_at_t2` (W6a, W6b) | The graduated ladder is preserved where reversibility is demonstrated. |
| `cert_refinement_conservative` (W7) | The §9.3 mechanism table is a floor certificates can only raise, never lower. |
| `no_certificate_no_presumption` (W8) | Reversibility of routing/severance is exactly its certificate. |
| `zero_envelope_constructible` (W9) | A deployment with no presumptively reversible routing or severance is a legal parameterization. |

### C. Module 2 — Crisis Frequency Cap, Structural Review, Axiom II (`CrisisCap.lean`)

**Phase 1 core + composition.** `window_head_bound` (C1), `rolling_window_bound`
(C2), `no_permanent_emergency` (C3): the rolling 24-month window carries at most
T_cap = 180 emergency days, at every offset, for any continuation.
`no_emergency_in_review` (C4), `review_absorbing` (C5), `review_gate` (C6): no
event grants emergency authority during Structural Review, which only a Layer 0
constitutional output can close. `axiomII_dichotomy` (A2a): every episode is
exactly one of reversibility-claim-valid or locally terminal.

**Composed cap × review — G1–G7 (adopted v0.2, finding AHC-P1-001).** The cap
arithmetic and the review automaton, proved separately in Phase 1, are joined
into one daily-step machine with the cap trip *derived* from the window
arithmetic: `dayStep_valid`/`dayRun_valid` (G1, every reachable trace is
protocol-valid, so C1–C3 apply verbatim), `review_day_never_emergency` (G2, an
emergency day during review is unconstructible), `review_exit_iff_output` (G3),
`trip_forced` (G4), `review_run`/`review_gate_composed` (G5),
`emergency_day_provenance` (G6, every emergency day was individually
authorized), `composed_cap_safety`/`composed_no_permanent_emergency` (G7).

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
(P3'), `residual_divergence_harmless` (P4), `no_hostage` (P5),
`contestability_at_breach` (P5'), `decCompliant` (P6): compliance is decidable;
the divergence audit needs no expertise and no discretion.

**D-R4 disclosures — P7–P9 (§10.4; adopted v0.5, ruling D-R4).** A PIO-related
event (`PIOEvent`) must carry the four D-R4 fields — authorization basis,
novelty basis and lineage, cumulative episode protection, falsification
condition — as mandatory members of the contestation-critical set; a
withholding event is unconstructible.

| Theorem | Verified guarantee |
|---|---|
| `pio_disclosure_at_breach` (P7) | All four D-R4 fields are in the T+0 semantic record at hour zero: contestation, including of the novelty determination itself, never waits. |
| `pio_disclosure_divergence_convicts` (P7') | Omission of any D-R4 field from any register proves that register non-compliant. |
| `attested_budget_accurate` (P8) | The disclosed budget figure carries a proof it equals the episode machine's accounting: given the incident history, a misstated figure is unconstructible. |
| `attested_budget_bounded` (P9) | **Cross-module (Module 1 × Module 4):** any attested budget over a novelty-free, review-free span is ≤ 72 hours, by E1. The public figure inherits the machine's constitutional bound. |

**Later-register invariance — P10–P13 (§19.4, App. B.4; adopted v0.7).** Phase 1
obliged only the T+0 semantic record at release; the civic (T+72h) and
technical (T+30d) registers are checked *when they ship*. `ShippedTripartite`
carries their compliance as proof obligations.

| Theorem | Verified guarantee |
|---|---|
| `tripartite_critical_consensus` (P10) | The three registers of a shipped compliant release agree on the *entire* contestation-critical fragment: one event, three voices, same findings. |
| `later_registers_no_hostage` (P11) | Every critical claim is present in the civic and technical records too; a later register cannot drop what the semantic record carried. |
| `shipped_pio_disclosure_all_registers` (P12) | The four D-R4 fields appear in all three registers of a shipped PIO release, not the T+0 record alone. |
| `later_residual_divergence_harmless` (P13) | Any claim differing between the later registers is provably non-critical: differences are framing, never findings. |

P9 is the kernel's first cross-module theorem: the disclosure layer and the
authorization layer cannot drift apart on the one figure that measures how much
unreviewed protection an incident has consumed.

### F. Bridge — Exceedance Derivation (`ExceedanceBridge.lean`, Module 1 × Module 3)

The episode machine consumes `exceedance` — the hazard signal that sustains a
continuity-hold — as an input. Adopted v0.6, this bridge derives it from the
Byzantine measurement layer: a certified exceedance requires f+1 sensors
reporting at or above the danger threshold, so by B2 (`exists_honest_ge`) it is
always witnessed by an honest sensor.

| Theorem | Verified guarantee |
|---|---|
| `derived_exceedance_honest_witnessed` (X1) | A certified exceedance always has an honest sensor at or above the danger threshold: the hazard signal is never a pure fabrication of the corrupted coalition. |
| `derived_exceedance_not_forgeable` (X2) | If every honest sensor reads below threshold, exceedance cannot be certified: a captured minority cannot raise the alarm alone. |
| `hold_sustained_only_by_witnessed_danger` (X3) | Whenever the machine keeps a subgraph in a continuity-hold on a derived input, honest sensors corroborate the danger. |
| `manufactured_danger_cannot_sustain_hold` (X4) | Fabricated alarm drops the subgraph out of the hold to `spent`: the laundering path closed at the measurement layer. |

Together with E1/E8 (the authorization layer) and the D-R4 disclosures (the
record layer), this closes the emergency loop's last free input: alarm,
authority, and disclosure are now grounded in one another, and no one of them
can be manufactured without the others.

### G. Modeling disclosures — the contestation targets

Per the framework's norm of separating the contestable normative layer from the
formal one, every translation choice is stated in the header of its module.
These, not the proofs, are the right places to aim review. The most
load-bearing:

- **Time is discretized** — hours for the PIO/episode machine, days for the
  Crisis Cap trace; the 72h, 180-day and 24-month constants are the spec's.
- **The episode's `novel` input is an ATG/Layer 0 attestation** attached to a
  claim identity (D-R4): rewording or repetition is not novelty, and the
  determination is contestable through Layer 0, made *outside* the machine.
  `exceedance` is the raw risk signal. The two are separate inputs by design —
  the hazard clock and the epistemic clock never share a needle.
- **The continuity-hold floor is a deployment-certified `HoldPolicy`,**
  constrained by construction to reversible mechanisms at or below Tier 1.
  Which measures constitute the floor is a deployment/Layer 0 determination.
- **Reversibility is an opaque deployment certificate** (`Envelope`) over a
  descriptor the kernel does not interpret; the kernel gates on the certificate
  but does not verify that it describes reality. The v0.3 scalar bound is the
  special case δ := ℕ, `routeInside := (· ≤ bound)`; no positivity survives.
- **A budget attestation carries its own proof** of equality with the episode
  machine's count; whether the *recorded history* is the true history is
  institutional (append-only logs, Layer 0 audit).
- **Constitutive constraints are structure fields** — the hysteresis gap,
  T_cap < W, the m > 2f+1 quorum, the mandatory D-R4 disclosure fields — so
  degenerate or withholding parameterizations are unconstructible, not merely
  invalid.

### H. What is not verified, and why

The statistical layer (three-stage causal identification §5.5, synthetic
control validity, capture-rate estimation) is not Lean-shaped; its instrument
is pre-registration and blind historical validation (OP.4, Companion B).
Viability-kernel dynamics over continuous state spaces are the province of
viability theory. Sensor independence is an institutional achievement (OP.1),
assumed here as the ≤ f fault bound. The certificate and continuity-hold
designs move trust to new institutional points — who issues, contests, and
revokes an `Envelope` or `HoldPolicy`, and who guarantees an incident's
recorded history — and those points are named, not resolved, here. And the
relation between a natural-language text and the claim set it expresses — the
seam — is formally unverifiable by construction: all trust is consumed at claim
extraction, none after it, and extraction belongs to Layer 0. The kernel's
contribution to that division of labor is to prove that everything after
extraction is mechanical (`decCompliant`), that divergence convicts
(`divergence_convicts`, `pio_disclosure_divergence_convicts`), and now that the
one quantitative disclosure cannot lie (P8, P9).

### I. Reproduction

Requirements: any machine with `elan` (the Lean toolchain manager). Then:

```
cd ahc-verified-kernel
lake build
```

The build elaborates every proof and prints the axiom audit
(`AHCKernel/Audit.lean`) to the log. A missing or broken proof fails the build;
a placeholder surfaces as the `sorryAx` axiom. **Expected:** 89 audited
theorems, each at most `[propext, Quot.sound]`; never `Classical.choice`; 40
axiom-free. A continuous-integration workflow re-runs this check on every
change and fails on any `sorry`, any classical choice, any unexpected axiom, or
any deviation from the 89/40 footprint.

---

## Part III — Reviewer Brief

Companion A Principle 19.2 holds that further specification must follow, not
precede, external review. This artifact complies: the first two review rounds
produced findings (AHC-P1-001..008; CG-1..CG-6), the framework's stewards ruled
on them (D-R1A, D-R2A, D-R3, D-R4), and the rulings were formalized. This round
solicits attack on the results of that process, and on the surfaces the newest
work exposes. Findings at any of the following addresses are the intended
product of circulation.

### For formal-methods reviewers

**F-1 (Faithfulness of the rulings).** For each ruling now in the kernel, does
the formal reading weaken or strengthen the constitution's intent? The
strongest finding is a behavior satisfying the Lean model while violating the
English, or vice versa. Specific targets: does the episode machine's routing at
expiry (E3) match §5.4's intent for an unconfirmed order under persisting
danger? Does `exceedance_cannot_restart` (E8) forbid any legitimate re-escalation
the spec intends?

**F-2 (The continuity-hold semantics).** The hold is modeled as a single
per-subgraph mode with a `HoldPolicy` floor. Does this admit any gaming path —
e.g., alternating hold/spent to reset an implicit clock, or a `HoldPolicy` that
is nominally reversible yet materially punitive? Is there a bound the hold
*should* carry (a maximum hold duration before mandatory resolution) that it
does not?

**F-3 (Certificate expressiveness).** Envelopes are opaque predicates over an
abstract descriptor. Is that the right altitude, or should the kernel constrain
the descriptor's structure (e.g., require monotonicity in a stated coordinate,
or compositionality under combined actions)? Does anything in the spec's intent
survive only if the certificate carries more structure than a bare Boolean?

**F-4 (Strengthening candidates).** The two candidates named in the previous
brief are now discharged: `exceedance` is derived from Module 3 (v0.6, X1–X4,
Part II.F) and later-register compliance is proved (v0.7, P10–P13). The
order-theoretic surface that remains is thinner, and the highest-leverage open
questions have shifted from the formal layer to the institutional one
(D-1..D-4 below). A reviewer who still sees an order-theoretic sentence of
§5.4, §12.3, §19.4, or Appendix B that could join the kernel — and survive
Principle 19.2 — should name it here; that is now the scarcer finding.

### For constitutional and domain reviewers

**D-1 (Certificate governance).** Rulings D-R2A/D-R3 place reversibility in a
deployment certificate that must be public, contestable, and revocable. Who
issues it, who may contest it, and what happens to actions taken under a
certificate later revoked? This is the largest open institutional surface the
kernel opens and does not close.

**D-2 (The novelty determination).** D-R4 makes `novel` a contestable Layer 0
attestation. In practice, who adjudicates novelty under time pressure during an
ongoing incident, and does the contestability right function before, not only
after, the protective window it governs?

**D-3 (Hold humaneness in deployment).** The continuity-hold prevents an abrupt
protection vacuum in theory (E5). Does a real deployment's `HoldPolicy` floor
actually protect an affected community, or could a minimal floor satisfy the
theorem while leaving people materially unprotected — reproducing the
lock-without-key pattern one level down?

**D-4 (Severance certification in the field).** D-R3's soft-severance conditions
(time-bounded, state-preserving, essential-service floor, tested restoration,
cascade-safe, repair mechanism) are constitutional text. Are they the right
conditions, and is "tested restoration rather than theoretical reconnection"
operationalizable for the deployments AHC intends?

### For community and legibility reviewers

**L-1 (Reflexive compliance).** Part I claims PLOL conformance for this
document. Audit it against Appendix B.2 and the new D-R4 fields: is anything a
community reviewer needs missing, and does the falsification pathway function
for a non-expert with the Community Statistical Support Fund's resources?

**L-2 (The budget figure's meaning).** P8/P9 prove the disclosed episode budget
cannot understate the machine's count. But the figure is only as honest as the
recorded incident history. Is "the recorded history is the true history" a
burden that quietly falls on communities, and what institutional guarantee
(append-only logs, independent Layer 0 audit) does it require?

**L-3 (The seam's placement, revisited).** Every ruling this cycle moved trust
to a new named point — certificate issuance, novelty attestation, history
integrity. Are these the right custodians, or does the accumulation relocate
expert burden onto communities across several fronts at once?

### Disposition of findings

Findings against proofs (F-class) invalidate specific theorems and are
corrected in the kernel. Findings against modeling choices and rulings (F-1,
D-class) are constitutional-interpretation questions and route to the
specification's amendment processes; the kernel then re-verifies the amended
reading — as it did five times to reach this version. Findings against the
seam's placement (L-class) route to the Open Problems Register. In all three
cases the artifact's function is the same: it converts disagreement about what
the constitution means into a precise, checkable object — which is what a formal
layer is for.

---

*— End of circulation brief. The machine-checked source, the module READMEs,
the theorem-to-specification map, the amendment record (`ERRATA_AND_AMENDMENTS.md`),
the archived external reviews (`external-reviews/`), and the CI workflow
accompany this document. —*
