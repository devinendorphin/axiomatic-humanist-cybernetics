# AHC Verified Constitutional Kernel

Machine-checked formalization (Lean 4) of the order-theoretic core of
**Axiomatic Humanist Cybernetics v3.1** — the Tiered Evidence-Action
Protocol, the Crisis Frequency Cap and Structural Review gate, Byzantine
measurement consensus, Axioms I and II, and the Plain Language Output
Layer's register-invariance guarantees.

**Toolchain:** Lean 4.15.0, core only — **no Mathlib dependency**. Every
proof is self-contained. **Zero `sorry`s.** No theorem depends on
`Classical.choice`; the complete axiom footprint is `propext` and
`Quot.sound` (standard Lean kernel axioms), and twenty-two theorems depend
on no axioms at all — including every theorem of the PLOL module.

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
| `no_chatter` (T9) | §9.2 | The hysteresis gap makes simultaneous escalate/de-escalate unsatisfiable |

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
every theorem: at most [propext, Quot.sound]; never Classical.choice
no axioms at all: broadcast_universal, tier_monotone, severity_le_evidence,
  sub_causal_reversible, irreversible_iff_causal, pio_ceiling,
  pio_reversible, no_emergency_in_review, review_absorbing,
  axiomI_null_kernel, axiomI_no_compensation, null_kernel_product,
  globalSignal_pos_iff, and all nine PLOL theorems
```

## Modeling disclosures

Per the framework's own norm of separating the contestable normative layer
from the formal one, each module header states its modeling choices
explicitly: discretization of time in days/hours; the strict (conservative)
reading of the renewal condition where the spec admits an off-by-one; M3
treated as the irreversibility-bearing mechanism the tier structure gates;
the median characterized by its counting property rather than order
statistics. These choices are the right places to aim contestation.

## Status and non-goals

This kernel covers the order-theoretic and counting-theoretic core:
enforcement gating, emergency time, measurement, aggregation, and
output-register invariance. It does
not attempt the statistical layer (causal identification, §5.5), viability
kernel dynamics over continuous state spaces, or any claim about
institutional performance. Those are respectively the province of
econometrics, viability theory, and Companion B — and, for the
load-bearing empirical hypotheses, of Layer 0 itself.
