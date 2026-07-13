# Theorem-to-Text Map — AHC Verified Kernel v0.12

Prepared 2026-07-13, discharging Reviewer #2 finding R2-12 ("a
quotation-level mapping with exact source snapshots and digests").
Quotations are verbatim from the extracted texts in this directory
(`*.extracted.txt`; hashes in `SOURCES.txt`); **Master** =
`Master_AHC_v3_1_Integrated` (AHC v3.1), **CompA** =
`CompanionA_AHC_L0_v3_1_Integrated`. Theorem identifiers refer to
`ahc-verified-kernel/` at source digest `88ea6583…` (116 audited
theorems). Where the kernel renders a quantity in different units,
supplies a constant the text does not fix, or formalizes a
post-text constitutional ruling rather than a v3.1 sentence, this map
says so — those are the honest deviations a faithfulness reviewer
should examine first.

## Module 1 — Tiered Evidence-Action Protocol (T1–T8) ← Master §5.4

> "The Tiered Evidence-Action Protocol resolves this by formally
> proportioning evidence requirements to response severity and
> reversibility." (Master §5.4)

The §5.4 tier table (Master, tabular matter), quoted by row:

> "Tier 0 | … | Yellow Protocol (M4) only: cryptographic broadcast,
> zero enforcement" — rendered as `requiredTier .m4 = .t0` and T5
> `broadcast_universal`.
>
> "Tier 1 | Tier 0 + matched control shows differential trajectory
> (Correlational) | M1 graduated capital routing begins; API monitoring
> initiated; **all reversible**" — rendered as `requiredTier .m1 = .t1`
> and `Mech.reversible .m1 = true`. (This "all reversible" declaration
> is exactly the fiat that rulings D-R2A/D-R3 later replaced with
> per-action certificates — see the W-family below.)
>
> "Tier 2 | … | M2 selective dimensional severance eligible; **still
> reversible on Layer 0 review**" — rendered as
> `requiredTier .m2 = .t2`, `Mech.reversible .m2 = true`.
>
> "Tier 3 | Full DiD + RD + mechanism verification satisfied (Causal) |
> Full enforcement: M3 sanctions eligible; formal MRI classification
> issued" — rendered as `requiredTier .m3 = .t3`,
> `Mech.reversible .m3 = false`; T4 `irreversible_iff_causal`.

The ladder's monotone reading (T1 `tier_monotone`, T2
`severity_le_evidence`, T3 `sub_causal_reversible`) formalizes
"formally proportioning evidence requirements to response severity and
reversibility" as order-theoretic invariants of that table.

**PIO (T6–T8):**

> "For attacks with τ_decay < 72h, a Tier 0 observational signal
> activates Tier 1 protective responses immediately, subject to
> mandatory Layer 0 review within 72 hours and automatic reversal if
> Tier 1 correlational confirmation fails." (Master §5.4)

Rendered as the `PIO` machine: `reviewDeadline := 72` (hours, the
text's unit), T8 `pio_resolves` (pending past the deadline is
unconstructible), T6 `pio_ceiling` / T7 `pio_reversible` ("activates
Tier 1 protective responses" — nothing above Tier-1 severity).

> "The constitutional logic is identical: the cost of an unjust
> temporary order is recoverable; the cost of failing to prevent an
> acute irreversible harm is not." (Master §5.4)

Quoted in T7's docstring; the theorem is that recoverability claim, at
mechanism granularity (and at certified-action granularity, W11).

## Module 1 — Hysteresis (T9, S1–S3) ← Master §9.2

> "ESCALATE: A_{kl}(t) > A* sustained over Δt_confirm AND causal ID
> tier satisfied (Escalation Condition)
> DE-ESCALATE: A_{kl}(t) < A_reset < A* sustained over Δt_cooldown
> (De-escalation with Hysteresis Gap)" (Master §9.2)

Rendered as `Hysteresis` with the constitutive field
`gap : Areset < Astar`, `escalates := Astar < A`,
`deescalates := A < Areset`. T9 `no_chatter` is instantaneous mutual
exclusivity; S1–S3 supply the temporal anti-cycling content ("within
each tier, hysteresis prevents panic cycles") as total-variation
bounds. **Deviation note:** the text's sustainment windows
(Δt_confirm, Δt_cooldown) and the FAR specification are not modeled;
the kernel isolates the signal inequality (stated in the module
header since v0.2).

## Module 1 — Four Mechanisms ← Master §9.3

> "M1: Graduated Capital | … | Exponential ramp aid routing; graduated
> ESG divestment | …" · "M2: Selective Severance | Terminal_{kl,j} = 1;
> Tier 2 confirmed for attack dimensions | Protocol Zero on specific
> compromised APIs only …" · "M3: Exogenous Sanctions | A > 5A*
> sustained; Tier 3 causal ID satisfied | Node-level sanctions …" ·
> "M4: Gradient Warning | … | Yellow Protocol: cryptographic broadcast.
> Zero enforcement. | Transparent; mobilization function only" (Master
> §9.3, tabular matter)

Rendered as `Mech` with `severity` ranking m4 < m1 < m2 < m3.
**Deviation note:** the magnitude conditions (2A* < A < 5A*, etc.) are
not modeled; the kernel gates on evidence tier only.

## Module 2 — Crisis Frequency Cap (C1–C6, G1–G7) ← Master §10.3, CompA §12.3

> "IF ∑_{t−730}^{t} 𝟙[Emergency Active] · dt > T_cap (e.g., 180 days
> in 24 months) (Crisis Frequency Threshold)" (Master §10.3)
>
> "Emergency authority for any subgraph is unavailable for renewal when
> emergency has been active more than T_cap days in a rolling 24-month
> window (specified at 180 days). Continued terminal threshold
> exceedance after the cap escalates to Structural Review Protocol:
> mandatory full Layer 0 constitutional review … Emergency authority
> cannot resume until one of these outputs is produced and enacted."
> (CompA §12.3)

Rendered as `Cap` (window W, cap T_cap, constitutive `Tcap < W`),
`Valid` traces, C1–C3 (rolling-window bounds), the review automaton
C4–C6 ("cannot resume until one of these outputs is produced"), and
the composed machine G1–G7 with the trip *derived* from the window
arithmetic. **Constants note:** the text fixes the instance — the
summation runs over 730 days with T_cap exemplified at 180 — while the
kernel proves the generic `Tcap < W` family; the concrete audited
W = 730 / T_cap = 180 instance is a named candidate (brief, F-4).

## Module 2 — Axiom II (A2a) ← Master §4.2

> "Formal: If τ_response > τ_decay for the targeted subgraph, the
> system's reversibility claim is nullified. The system is classified
> as locally terminal for the affected subgraph during
> [t_attack, t_response]." (Master §4, axiom table)

Rendered as `Episode`, `reversibilityClaimHolds := response ≤ decay`,
`locallyTerminal := decay < response`; A2a `axiomII_dichotomy` proves
the classification exhaustive and exclusive. **Scope note (finding
R2-09):** A2a is a well-formedness lemma; the text's operational
consequences (nullification forcing a change of procedure) are a named
candidate, not a theorem.

## Module 3 — Byzantine Consensus (B1–B4) ← Master §8.3

> "Computed via Byzantine consensus across m > 2f+1 independent sensor
> nodes tolerating f corrupted inputs [Lamport et al. 1982]. Sensor
> independence is continuously audited" (Master §8.3)

Rendered as `Ensemble` with constitutive `quorum : 2*f + 1 <
sensors.length` and `faultBound`; B1–B4 are the counting consequences
(honest strict majority, honest witnesses, median bracketing, no
corrupt certificate). **Seam note:** "independence is continuously
audited" is the institutional hypothesis behind `faultBound` (OP.1),
stated, not proved.

## Module 3 — Axiom I (A1a–A1e) ← Master §4.1, §7.2, §1.1

> "Formal: V_global = ∩_i V_i. If the state trajectory of any subgraph
> V_i is intentionally forced outside its viability bounds, V_global
> evaluates to the null kernel regardless of all other subgraphs."
> (Master §4, axiom table)
>
> "Φ_global(t) = ∏_{k,l} φ_{kl}(t) (Global Viability Field —
> Continuous Implementation of Axiom I)" (Master §7.2)

Rendered in both forms: intersection (A1a/A1b over arbitrary index and
state types) and product (A1c/A1d over signal vectors); the
quantification over prefix and suffix in A1c is the word "regardless".

> "In 1942, all three branches of U.S. government operated normally for
> the majority population while simultaneously authorizing the mass
> incarceration of 120,000 persons of Japanese ancestry. Every
> aggregate democratic health metric registered as normal." (Master
> §1.1, the Korematsu Illusion)

Rendered as the contrast theorem A1e `sum_admits_masking`: aggregation
by sum provably admits the masking the chosen product rules out.
**Note:** "intentionally" in Axiom I routes to §5.4's causal criteria
and is outside these aggregation theorems.

## Module 4 — PLOL Register Invariance (P1–P6) ← CompA §19.4, §19.4.1, App. B

> "All three records are cryptographically hash-bridged to the same
> underlying classification event. The non-equivalence rule is
> unchanged: no register may substitute for another, and the existence
> of a later register does not excuse omissions from an earlier one."
> (CompA App. B)

Rendered as `Tripartite` (bridged digests; P1/P1').

> "The hash bridge proves all three outputs derive from the same
> classification event. **But the hash bridge proves origin, not
> consistency.** Each register must therefore include a mandatory
> Consistency Statement." (CompA §19.4.1)

Rendered — sentence for sentence — as P2
`bridge_proves_origin_not_consistency` (the limitation proved with a
witness) and P3/P6 (consistency as a separate, decidable relation).

> "PLOL fails constitutional sufficiency if any of the following
> conditions are present in any register: … omits falsification
> pathways; materially diverges from linked registers without a
> Consistency Statement …" (CompA App. B, sufficiency conditions)

Rendered as `Compliant` (no critical omission ∧ no fabrication),
P3' `divergence_convicts`, P4 `residual_divergence_noncritical`.
**Scope note (finding R2-08):** P4 proves divergence is confined to
claims not *marked* critical; completeness of the marking is a seam
obligation.

> "The T+0 output is the most critical. It is generated automatically
> upon threshold breach with no operator intervention required. The
> community cannot be held hostage to the litigation-track
> documentation timeline. If the T+30d technical record is incomplete,
> delayed, or under revision, the T+0 semantic record remains in force
> and visible." (CompA §19.4)

Rendered as `scr_at_breach : releaseHour = 0`, P5 `no_hostage`, and the
window fields (`civic_window ≤ 72`, `tech_window ≤ 720` — hours, the
kernel's rendering of T+72h and T+30d).

> "It is a lock, and the key is sitting in another building …" (CompA
> App. B, simulation finding on the falsification condition)

The passage P5' `contestability_at_breach` glosses: the falsifier
ships in the T+0 record (`falsifier_critical` is constitutive);
whether the key is *usable* is the resource-access problem, outside
the claim-set layer.

## Post-text constructions (mapped to the amendment record, not to v3.1)

The following families formalize constitutional RULINGS and review
repairs adopted after the v3.1 text; their normative source is
`ERRATA_AND_AMENDMENTS.md` and the archived review exchange
(`external-reviews/`), and citing v3.1 sentences for them would
overstate the text:

- **E1–E15** (episode machine, two clocks, typed dispositions, clocked
  hold): ruling D-R1A + findings R2-03/R2-06. The v3.1 anchor is
  §5.4's PIO sentence quoted above; everything beyond it (novelty
  vs. exceedance, the continuity-hold, `overdue`,
  `holdReviewDeadline = 72`) is ruling-level. The 72-hour hold-review
  constant in particular is a **flagged deployment constant pending
  ratification** — no v3.1 sentence fixes it.
- **W1–W18** (certified reversibility envelopes; certified emergency
  authorization): rulings D-R2A/D-R3 + finding R2-01, replacing the
  §5.4 table's "all reversible" declaration quoted above.
- **W19–W26** (exposure-indexed certificates, trace safety): finding
  R2-07, per the reviewing party's prescribed repair.
- **P7–P17** (D-R4 disclosures, typed claim language): ruling D-R4 +
  findings R2-02/R2-04. The v3.1 anchors are App. B's mandatory-field
  regime and §19.4's sequencing, quoted above.
- **X1–X4** (exceedance derivation): reviewer solicitation F-4; the
  v3.1 anchor is §8.3's quorum sentence. The property is
  one-honest-witness non-fabrication (finding R2-05); the danger
  threshold θ is a deployment obligation, unfixed by the text.
