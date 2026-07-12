# AHC Verified Constitutional Kernel

**Version 0.3.1** — v0.2 adopted two strengthening families from Phase 1
external review (temporal hysteresis, composed cap × review semantics);
v0.3 implements the two constitutional rulings of 2026-07-12 (PIO
re-issuance guard with a generous freshness bar, ruling D-R1; regime-split
capital routing, ruling D-R2). Change record in
`../docs/ERRATA_AND_AMENDMENTS.md`, digest in `../docs/MANIFEST_v0.3.txt`.
v0.3.1 closes external-review
finding CG-1 (theorem R5: freshness is consumed by issuance, never
banked). Open: proposed dispositions CG-2..CG-5 (see errata) await
ruling, including Q2 (severance reversibility).

Machine-checked formalization (Lean 4) of the order-theoretic core of
**Axiomatic Humanist Cybernetics v3.1** — the Tiered Evidence-Action
Protocol with temporal hysteresis, the Crisis Frequency Cap and Structural
Review gate (including their composition), Byzantine measurement
consensus, Axioms I and II, and the Plain Language Output Layer's
register-invariance guarantees.

**Toolchain:** Lean 4.15.0, core only — **no Mathlib dependency**. Every
proof is self-contained. **Zero `sorry`s.** No theorem depends on
`Classical.choice`; the complete axiom footprint is `propext` and
`Quot.sound` (standard Lean kernel axioms), and twenty-eight of the
sixty-six audited theorems depend on no axioms at all — including every
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
| `pio_no_relitigation` (R1) | §5.4 | Stale evidence buys at most 72 unconfirmed protected hours, against any re-filing pattern |
| `reissue_needs_new_evidence` (R2) | §5.4 | Under staleness, at most one PIO issuance, ever |
| `ongoing_attack_reprotects` (R3) | §5.4 | Under ongoing exceedance a spent subgraph re-protects immediately: an ongoing attack is never locked out |
| `reissue_blocked_iff_stale` (R4) | §5.4 | The guard blocks exactly stale claims and nothing else |
| `freshness_consumed_not_banked` (R5) | §5.4 | A fresh pulse without a filing changes nothing: `spent` never returns to `idle`, closing the CG-1 laundering path |
| `action_tier_monotone` / `action_severity_le_evidence` (V1–V2) | §5.4 | T1/T2 lifted to magnitude-bearing actions |
| `action_sub_causal_reversible` (V3) | §5.4 | Restored T3: every action authorized below Tier 3 is reversible — now a consequence of gating, not fiat |
| `action_irreversible_iff_causal` (V4) | §5.4, §5.5 | T4 lifted to actions |
| `unbounded_routing_needs_causal` (V5) | §5.4 | Capital routing beyond the regime bound is authorized only at Tier 3 |
| `bounded_routing_at_t1` (V6) | §5.4 | Bounded routing stays available on correlational evidence: the graduated ladder is preserved |
| `refinement_conservative` (V7) | §5.4 | The split only strengthens gating relative to the Phase 1 table |

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
66 audited theorems: every one at most [propext, Quot.sound];
never Classical.choice
no axioms at all (28): broadcast_universal, tier_monotone,
  severity_le_evidence, sub_causal_reversible, irreversible_iff_causal,
  pio_ceiling, pio_reversible, no_emergency_in_review, review_absorbing,
  axiomI_null_kernel, axiomI_no_compensation, null_kernel_product,
  globalSignal_pos_iff, dayStep_valid, dayRun_valid,
  pendingHours_confirmed, action_tier_monotone, bounded_routing_at_t1,
  refinement_conservative, and all nine PLOL theorems
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
input (G1–G7); PIO evidence freshness as novelClaim ∨ exceedance — the
ruling D-R1 generous bar (R1–R4); the routing regime bound as a
deployment-specified constitutive field, with magnitude units abstract
(V1–V7). These choices are the right places to aim contestation.

## Status and non-goals

This kernel covers the order-theoretic and counting-theoretic core:
enforcement gating, emergency time, measurement, aggregation, and
output-register invariance. It does
not attempt the statistical layer (causal identification, §5.5), viability
kernel dynamics over continuous state spaces, or any claim about
institutional performance. Those are respectively the province of
econometrics, viability theory, and Companion B — and, for the
load-bearing empirical hypotheses, of Layer 0 itself.
