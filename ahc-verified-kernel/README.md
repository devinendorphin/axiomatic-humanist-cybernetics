# AHC Verified Constitutional Kernel

**Version 0.5** — completes ruling D-R4: Module 4 gains the T+0
disclosure theorems (P7–P9), including the kernel's first cross-module
theorem — the disclosed episode budget provably equals and inherits the
bound of Module 1's episode-machine accounting. v0.4 implemented the four
ratified dispositions (two-clock episode machine E1–E11; certified
reversibility envelopes W1–W9). Change record in
`../docs/ERRATA_AND_AMENDMENTS.md`, digest in `../docs/MANIFEST_v0.5.txt`.

Machine-checked formalization (Lean 4) of the order-theoretic core of
**Axiomatic Humanist Cybernetics v3.1** — the Tiered Evidence-Action
Protocol with temporal hysteresis, the Crisis Frequency Cap and Structural
Review gate (including their composition), Byzantine measurement
consensus, Axioms I and II, and the Plain Language Output Layer's
register-invariance guarantees.

**Toolchain:** Lean 4.15.0, core only — **no Mathlib dependency**. Every
proof is self-contained. **Zero `sorry`s.** No theorem depends on
`Classical.choice`; the complete axiom footprint is `propext` and
`Quot.sound` (standard Lean kernel axioms), and thirty-six of the
eighty-one audited theorems depend on no axioms at all — including every
theorem of the PLOL module.

## What is and is not verified

These proofs verify the **specification, not the world**. They establish
that the protocol *as written* cannot authorize irreversible force on
sub-causal evidence, cannot hold an emergency open indefinitely, cannot
have its thresholds dragged outside the envelope of honest measurement by
a captured sensor minority, and cannot report global viability over a
collapsed subgraph. Whether measured signals track real harm, whether
sensors are in fact independent, and whether the Layer 0 institutions
function are empirical and institutional questions outside the kernel
(AHC §2.2–2.3, OP.1). Verification-from-above is one half of the
architecture; legibility-from-below (PLOL, Layer 0) is the other, and
nothing here substitutes for it.

## Theorem ↔ specification map

### Module 1 — `AHCKernel/TieredProtocol.lean`

| Theorem | Spec | Statement |
|---|---|---|
| `tier_monotone` (T1) | §5.4 | Authorization is upward-closed in evidence strength |
| `severity_le_evidence` (T2) | §5.4 | Response severity never exceeds evidence tier: force cannot outrun proof |
| `sub_causal_reversible` (T3) | §5.4 | Everything authorized below Tier 3 is reversible |
| `irreversible_iff_causal` (T4) | §5.4, §5.5 | Irreversible mechanisms are authorized *iff* full causal identification holds |
| `broadcast_universal` (T5) | §9.3 (M4) | The transparency broadcast is authorized at every tier |
| `pio_ceiling` (T6) | §5.4 (Tier 0-PIO) | No PIO state authorizes above Tier-1 severity |
| `pio_reversible` (T7) | §5.4 | Everything a PIO authorizes is reversible |
| `pio_resolves` (T8) | §5.4 | A PIO cannot remain pending past the 72h deadline: confirmed or auto-reversed |
| `no_chatter` (T9) | §9.2 | The hysteresis gap makes simultaneous escalate/de-escalate unsatisfiable (instantaneous; see S3 for the temporal claim) |
| `oscillation_travel` (S1) | §9.2 | Escalating and de-escalating values are separated by more than the gap width |
| `flips_travel_anchored` (S2) | §9.2 | Anchored bound: every posture flip costs the signal more than the gap width of travel |
| `chatter_requires_travel` (S3) | §9.2 | (flips − 1)·(gapWidth+1) ≤ total variation: cycling requires repeated genuine full-band swings; sub-band noise flips the posture at most once |
| `episode_no_relitigation` (E1) | §5.4 | Two clocks: without novel evidence or Layer 0 resolution, whatever the exceedance pattern, unconfirmed full protection ≤ 72h |
| `episode_single_issuance` (E2) | §5.4 | One full-PIO issuance per such span |
| `expiry_routes_by_risk` (E3) | §5.4 | At the deadline: continuing risk → continuity-hold; subsided risk → spent |
| `reonset_refloors` / `hold_persists` (E4–E5) | §5.4 | The hold floor follows the risk and is never withdrawn while it persists |
| `hold_resolution_iff` (E6) | §5.4 | Only a Layer 0 review output returns the hold to ordinary posture |
| `novel_restart_from_spent` / `_from_hold` (E7) | §5.4 | An attested materially new claim restarts the full clock |
| `exceedance_cannot_restart` (E8) | §5.4 | Continuity of a signal is never continuity of the full authority |
| `hold_floor_reversible` / `_severity` / `hold_grants_no_more_than_pio` (E9–E11) | §5.4 | The hold floor is reversible, Tier-1-capped, and a remnant of PIO authority — never an extension |
| `cert_tier_monotone` / `cert_severity_le_evidence` (W1–W2) | §5.4 | T1/T2 lifted to certificate-bearing actions |
| `cert_sub_causal_reversible` (W3) | §5.4 | Everything authorized below Tier 3 is reversible — routing AND severance — as a consequence of gating |
| `cert_irreversible_iff_causal` (W4) | §5.4, §5.5 | T4 lifted to certificate-bearing actions |
| `uncertified_routing_needs_causal` / `uncertified_severance_needs_causal` (W5) | §5.4 | No certificate ⇒ Tier 3; Q2 answered: uncertified severance is treated exactly as irreversible |
| `certified_route_at_t1` / `certified_severance_at_t2` (W6) | §5.4 | The graduated ladder is preserved where reversibility is demonstrated |
| `cert_refinement_conservative` (W7) | §5.4 | The §9.3 table is a floor envelopes raise but never lower |
| `no_certificate_no_presumption` (W8) | §5.4 | Reversibility of routing/severance is exactly its certificate |
| `zero_envelope_constructible` (W9) | §5.4 | A deployment with no presumptively reversible routing or severance is a legal parameterization |

### Module 2 — `AHCKernel/CrisisCap.lean`

| Theorem | Spec | Statement |
|---|---|---|
| `window_head_bound` (C1) | Companion A §12.3 | The current rolling window carries at most T_cap emergency days |
| `rolling_window_bound` (C2) | §12.3 | The bound holds for every historical window at every offset |
| `no_permanent_emergency` (C3) | §12.3 | No protocol-valid history contains more than T_cap consecutive emergency days |
| `no_emergency_in_review` (C4) | §12.3 | No event grants emergency authority during Structural Review |
| `review_absorbing` (C5) | §12.3 | Review survives any event sequence lacking a Layer 0 output |
| `review_gate` (C6) | §12.3 | Across any output-free span, emergency authority is never granted |
| `axiomII_dichotomy` (A2a) | §4.2 | Every episode is exactly one of: reversibility-claim-valid, or locally terminal |
| `dayStep_valid` / `dayRun_valid` (G1) | §12.3 | Every reachable trace of the composed cap × review machine is protocol-valid: C1–C3 apply verbatim |
| `review_day_never_emergency` (G2) | §12.3 | In review, the appended day is `false` for every input: an emergency day during review is unconstructible |
| `review_exit_iff_output` (G3) | §12.3 | Review closes exactly on a Layer 0 output |
| `trip_forced` (G4) | §12.3 | Continued exceedance over a saturated window must trip into review: the trip is derived from the window arithmetic, not discretionary |
| `review_run` / `review_gate_composed` (G5) | §12.3 | Across any output-free span, review persists and the trace extension is all-`false` |
| `emergency_day_provenance` (G6) | §12.3 | Inversion: every emergency day was individually authorized — operational mode, actual request, window strictly below cap |
| `composed_cap_safety` / `composed_no_permanent_emergency` (G7) | §12.3 | C1/C2/C3 restated of the composed machine from its initial state |

### Module 3 — `AHCKernel/SensorsAndKernel.lean`

| Theorem | Spec | Statement |
|---|---|---|
| `honest_strict_majority` (B1) | §8.3 | Under m > 2f+1, honest sensors outnumber corrupted by ≥ 2 |
| `exists_honest_le` / `exists_honest_ge` (B2) | §8.3 | Any f+1 readings at/below (at/above) a value include an honest one |
| `median_bracketed` (B3) | §8.3 | Any median-type statistic is bracketed by honest readings on both sides |
| `no_corrupt_certificate` (B4) | §8.3 | No coalition of ≤ f sensors can certify a reading no honest sensor made |
| `axiomI_null_kernel` (A1a) | §4.1 | One non-viable subgraph nullifies global viability, regardless of all others |
| `axiomI_no_compensation` (A1b) | §4.1 | Global viability certifies every subgraph individually |
| `null_kernel_product` (A1c) | §4.1 | Product form: a zero anywhere forces the global signal to zero, for every prefix and suffix |
| `globalSignal_pos_iff` (A1d) | §4.1 | The global signal is nonzero iff every subgraph signal is |
| `sum_admits_masking` (A1e) | §1.1 | Aggregation by sum provably admits the Korematsu Illusion (witness exhibited); by A1c, the product does not |

### Module 4 — `AHCKernel/PLOL.lean`

| Theorem | Spec | Statement |
|---|---|---|
| `hash_bridge_origin` (P1) | Comp. A §5.1 (Def 5.3) | Equal digests identify a single classification event (under stated collision-freeness) |
| `tripartite_single_origin` (P1') | §19.4 | The three registers of a valid release carry one digest: one event, three voices |
| `bridge_proves_origin_not_consistency` (P2) | §19.4.1 | The spec's own limitation as a theorem-with-witness: equal digests with divergent content exist; the bridge cannot carry consistency |
| `compliant_registers_agree` (P3) | App. B.4 | Two compliant registers agree exactly on the contestation-critical fragment |
| `divergence_convicts` (P3') | App. B.4 | A critical claim absent from a register proves that register non-compliant — divergence is a conviction, not a judgment call |
| `residual_divergence_harmless` (P4) | §19.4.1 | Under compliance, register differences are provably framing, never findings |
| `no_hostage` (P5) | §19.4 | Every critical claim is public at hour zero; contestation never waits on the litigation track |
| `contestability_at_breach` (P5') | App. B.2 | The falsification condition ships in the T+0 record: the key ships with the lock |
| `decCompliant` (P6) | App. B.4 | Compliance is decidable: given extracted claim sets, the divergence audit is mechanical |
| `pio_disclosure_at_breach` (P7) | D-R4 | A valid PIO release ships authorization basis, novelty basis, episode budget, and falsification condition in the T+0 record at hour zero |
| `pio_disclosure_divergence_convicts` (P7') | D-R4 | Omission of any D-R4 field from any register convicts that register |
| `attested_budget_accurate` (P8) | D-R4 | The budget figure carries a proof it equals the episode machine's accounting |
| `attested_budget_bounded` (P9) | D-R4 | Cross-module: an attested budget over a novelty-free, review-free span is ≤ 72h, by E1 |

Module 4 also formally locates **the seam**: every theorem operates on
claim sets, and the relation between a natural-language text and the
claim set it expresses is declared unverifiable — that relation is where
Layer 0 community judgment begins. The machine checks everything that
does not require trust, so trust is spent only where it is irreplaceable
(Proposition 5.1 as a division of labor).

## Design idioms worth noting

Constitutive constraints are carried as **structure fields**, not side
conditions: `Hysteresis.gap` (A_reset < A*), `Cap.cap_lt_window`
(T_cap < W), and `Ensemble.quorum` (m > 2f+1) make degenerate
parameterizations *unconstructible* rather than merely invalid. Sensor
honesty is a **ghost variable** — ground truth the running system cannot
observe — which is why the Byzantine theorems quantify over all placements
of at most f corrupted sensors. The Axiom I intersection theorems depend
on **zero axioms**: the formal mirror of the specification's claim that
Axiom I is a constitutional commitment, not a mathematical finding — all
normative weight sits in the choice of aggregation operator, and A1e
exhibits exactly what that choice rules out.

## Building

With [elan](https://github.com/leanprover/elan) installed:

```
lake build
```

The build elaborates all proofs and prints the axiom audit
(`AHCKernel/Audit.lean`) to the log. A `sorry` anywhere would surface as
the `sorryAx` axiom in that output. Expected audit result:

```
81 audited theorems: every one at most [propext, Quot.sound];
never Classical.choice
no axioms at all (36): broadcast_universal, tier_monotone,
  severity_le_evidence, sub_causal_reversible, irreversible_iff_causal,
  pio_ceiling, pio_reversible, no_emergency_in_review, review_absorbing,
  axiomI_null_kernel, axiomI_no_compensation, null_kernel_product,
  globalSignal_pos_iff, dayStep_valid, dayRun_valid,
  hold_floor_reversible, hold_floor_severity, hold_grants_no_more_than_pio,
  cert_tier_monotone, cert_refinement_conservative,
  no_certificate_no_presumption, zero_envelope_constructible,
  certified_route_at_t1, certified_severance_at_t2,
  pio_disclosure_at_breach, pio_disclosure_divergence_convicts,
  attested_budget_accurate, and all nine Phase 1 PLOL theorems
```

(Counts are audit-log entries — one per `#print axioms` result;
`decCompliant` is a verified `Decidable` instance additional to them.)

## Modeling disclosures

Per the framework's own norm of separating the contestable normative layer
from the formal one, each module header states its modeling choices
explicitly: discretization of time in days/hours; the strict (conservative)
reading of the renewal condition where the spec admits an off-by-one; M3
treated as the irreversibility-bearing mechanism the tier structure gates;
the median characterized by its counting property rather than order
statistics; the enforcement posture as a one-bit Schmitt trigger with
total variation as "travel" (S1–S3); the composed machine's trip condition
as exceedance ∧ failure of the renewal condition, with exceedance a free
input (G1–G7); the two-clock separation with `novel` as a contestable
Layer 0 attestation and the hold floor as a deployment-certified policy
(E1–E11); reversibility envelopes over opaque deployment descriptors,
judged by external certificates the kernel gates on but does not verify
(W1–W9). These choices are the right places to aim contestation.

## Status and non-goals

This kernel covers the order-theoretic and counting-theoretic core:
enforcement gating, emergency time, measurement, aggregation, and
output-register invariance. It does
not attempt the statistical layer (causal identification, §5.5), viability
kernel dynamics over continuous state spaces, or any claim about
institutional performance. Those are respectively the province of
econometrics, viability theory, and Companion B — and, for the
load-bearing empirical hypotheses, of Layer 0 itself.
