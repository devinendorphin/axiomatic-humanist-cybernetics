# AHC Verified Constitutional Kernel — Errata & Amendments

## v0.7 → v0.8 (2026-07-13) — typed D-R4 claims (Module 4; findings R2-02, R2-04)

Closes two findings of the Reviewer #2 report (2026-07-13; author
response in `external-reviews/2026-07-13-reviewer2-response.md`):

- **R2-02 (Critical):** the disclosed `budgetClaim` was an arbitrary
  atom, never connected to the `BudgetAttestation` whose accuracy P8
  proves — all of P7–P9 could hold while the published figure said
  "0 hours" and an unattached attestation correctly proved "72".
- **R2-04 (High):** the four D-R4 "fields" were untyped roles that one
  claim could fill simultaneously.

`PLOL.lean` gains the typed claim language `PIOClaim` (constructors
`basis`, `novelty`, `budget (hours : Nat)`, `falsif`, `free` — role is
type, not content, and the budget role carries its figure as a number).
`PIOEvent` now extends `Event (PIOClaim Claim)`, carries its
`BudgetAttestation` as a field, requires the critical set to contain
`budget attestation.claimedHours` (so the disclosed and proven figures
are one term), requires the mandatory falsifier to occupy the `falsif`
role, and carries `budget_unique` (no second, conflicting critical
budget claim is constructible). Four theorems state the closure:

- **P14 `pio_roles_distinct`** — the four D-R4 roles are pairwise
  distinct claims, by constructor disjointness.
- **P15 `pio_register_budget_accurate`** — every compliant register
  contains the budget claim whose figure IS `epPendingHours` over the
  attested history: disclosed = attested = machine accounting.
- **P16 `pio_budget_no_drift`** — any budget-role claim in the critical
  set carries the machine's figure.
- **P17 `pio_disclosed_budget_bounded`** — the published figure inherits
  E1's 72-hour bound (P9, restated of the disclosed number).

Statements of P7/P7'/P12 are unchanged up to the typed claim parameter;
`basisClaim`/`noveltyClaim`/`budgetClaim` survive as definitions (the
budget one now defined FROM the attestation). Seam movement: whether a
claim occupies a D-R4 role is now formal; WHAT the basis/novelty/falsif
claims say remains at the seam, and anchoring the attested history to an
append-only log head remains institutional (L-2) — the next candidate.

Footprint: **93 audited theorems, 43 axiom-free**. Digest in
`MANIFEST_v0.8.txt`.

---

## v0.6 → v0.7 (2026-07-12) — later-register compliance (Module 4)

Closes the second F-4 reviewer solicitation. Phase 1 made only the T+0
semantic record a compliance obligation of a valid release; the civic
(T+72h) and technical (T+30d) registers were "checked when they ship".
`PLOL.lean` gains `ShippedTripartite` (a release in which both later
registers have shipped, carrying their B.4 compliance as proof
obligations) and four theorems extending register invariance across the
full timeline:

- **P10 `tripartite_critical_consensus`** — the three registers agree on
  the entire contestation-critical fragment.
- **P11 `later_registers_no_hostage`** — every critical claim is present
  in the civic and technical records; a later register cannot narrow the
  contestable set.
- **P12 `shipped_pio_disclosure_all_registers`** — the four D-R4 fields
  appear in all three registers of a shipped PIO release, not the T+0
  record alone.
- **P13 `later_residual_divergence_harmless`** — any claim differing
  between the later registers is provably non-critical.

Footprint: **89 audited theorems, 40 axiom-free** (P10–P13 all
axiom-free). Digest in `MANIFEST_v0.7.txt`. This completes both F-4
formalization candidates named in the v0.5 brief (exceedance derivation
in v0.6, later-register compliance in v0.7); the remaining open surfaces
are institutional (certificate and hold-policy governance) rather than
order-theoretic.

---

## v0.5 → v0.6 (2026-07-12) — exceedance derivation (Module 1 × Module 3)

Closes the F-4 reviewer solicitation to derive the episode machine's
`exceedance` hazard signal from Module 3's Byzantine measurement layer.
New source module `ExceedanceBridge.lean` imports both Module 1 and
Module 3 and introduces `SensorHour` (the ensemble and danger threshold
that derive the exceedance bit, plus the pass-through episode inputs) and
`SensorHour.toEpInput`.

- **X1 `derived_exceedance_honest_witnessed`** — a certified exceedance
  (f+1 sensors at/above the danger threshold) always has an honest
  witness, by B2 (`exists_honest_ge`).
- **X2 `derived_exceedance_not_forgeable`** — if every honest sensor
  reads below threshold, exceedance cannot be certified: a captured
  minority cannot raise the hazard signal on its own.
- **X3 `hold_sustained_only_by_witnessed_danger`** — the direct
  Module 1 × Module 3 guarantee: whenever the episode machine keeps a
  subgraph in a continuity-hold on a derived input, honest sensors
  corroborate the danger.
- **X4 `manufactured_danger_cannot_sustain_hold`** — the dual: fabricated
  alarm drops the subgraph out of the hold to `spent`; the laundering
  path is closed at the measurement layer.

Footprint: **85 audited theorems, 36 axiom-free** (X1–X4 route through
the Module 3 pigeonhole core and carry `[propext, Quot.sound]`). Digest
in `MANIFEST_v0.6.txt`. Seam unchanged: whether the ≤ f fault bound holds
is institutional (OP.1); the theorems quantify over all placements of at
most f corrupted sensors.

---

## v0.4 → v0.5 (2026-07-12) — D-R4 disclosure formalization (Module 4)

Completes ruling D-R4: the T+0 record obligations adopted as
constitutional text in v0.4 are now theorems. `PLOL.lean` gains
`PIOEvent` (the four D-R4 fields — authorization basis, novelty basis
and lineage, cumulative episode protection, falsification condition —
as mandatory members of the contestation-critical set: a withholding
event is unconstructible) and `BudgetAttestation` (the budget figure
carried with a proof it equals Module 1's `epPendingHours` accounting).

- **P7 `pio_disclosure_at_breach`** — all four D-R4 fields are in the
  T+0 semantic record at hour zero: contestation of a PIO, including of
  the novelty determination itself, never waits on a later register.
- **P7' `pio_disclosure_divergence_convicts`** — omission of any D-R4
  field from any register proves that register non-compliant.
- **P8 `attested_budget_accurate`** — the figure carries its proof:
  given the incident history, a misstated budget is unconstructible.
- **P9 `attested_budget_bounded`** — the kernel's first cross-module
  theorem (Module 1 × Module 4): an attested budget over a span with no
  novel evidence and no Layer 0 resolution is ≤ 72 hours, by E1. The
  disclosure layer and the authorization layer cannot drift apart on
  the one figure that measures unreviewed protection.

Footprint: **81 audited theorems, 36 axiom-free**. Digest in
`MANIFEST_v0.5.txt`. Seam disclosures: what the claims SAY remains at
claim extraction; whether the recorded history is the true history is
institutional (append-only logs, Layer 0 audit).

---

## v0.3.1 → v0.4 (2026-07-12) — ratification of the external-review dispositions

The project owner ratified all four proposed constitutional dispositions
of the Phase 2 external review **as proposed**, in the order received:
D-R1A adopt · D-R2A adopt · D-R3 adopt · D-R4 adopt as text, formalize
with D-R1A. Implemented in `TieredProtocol.lean`; digest in
`MANIFEST_v0.4.txt`. Footprint: **77 audited theorems, 33 axiom-free**.

### D-R1A + D-R4 → the episode machine (E1–E11; resolves CG-2, CG-5)

The hazard clock and the epistemic clock are separated. `exceedance`
(riskPersistent) no longer restarts the full PIO: at budget expiry,
continuing risk enters a **continuity-hold** — a floor state
(`HoldPolicy`: deployment-certified, provably reversible-only and
Tier-1-capped, E9–E11) that persists while risk persists (E5) and owes
an explicit Layer 0 review, which is the only thing that returns the
subgraph to ordinary posture (E6). Only an attested materially new claim
(`novel`, per D-R4 attached to a claim identity, contestable through
Layer 0, determined outside the machine) restarts a full PIO (E7).
Headlines: **E1** — across any span without novelty or Layer 0
resolution, whatever the exceedance and filing pattern, unconfirmed full
protection ≤ 72 hours; **E8** — continuity of a signal is never
continuity of the full authority. The v0.3 R-family (R1–R5) is
superseded and removed: its `fresh = novelClaim || exceedance` bar is
unconstitutional under D-R1A. D-R4's disclosure obligations for the T+0
record (authorization basis, novelty basis, cumulative episode
protection, falsification condition) are adopted as constitutional text;
their PLOL field formalization is deferred to the next Module 4 pass.

### D-R2A + D-R3 → certified reversibility envelopes (W1–W9; resolves CG-3, CG-4, and Q2)

The scalar `RoutingRegime` (and its `bound_pos`) is repealed; the v0.3
V-family is superseded and removed. An action now carries an opaque
deployment descriptor δ (magnitude, concentration, duration, rollback
latency, cascade …) judged by a deployment-certified `Envelope`.
**Q2 is answered: yes** — severance can be irreversible, judged against
affected human and institutional state, not machine topology. Certified
routing keeps Tier 1 (W6a); certified soft severance keeps Tier 2 (W6b);
everything uncertified — including *uncertified* severance — requires
Tier-3 causal identification (W5a/W5b). The §9.3 mechanism table remains
a presumptive floor that certificates can only raise (W7); the absence
of a certificate is never evidence of reversibility (W8); and the zero
envelope — no presumptively reversible routing or severance at all — is
a legal parameterization (W9). D-R3's soft-severance certification
conditions (time-bounded, state-preserving, essential-service floor,
tested restoration, cascade-safe, repair mechanism) are adopted as
constitutional text governing the certification process.

### Remaining amendment surfaces after v0.4

- Deployment certification processes: who issues, contests, and revokes
  `Envelope` and `HoldPolicy` certificates (public, contestable,
  revocable per D-R2A) — institutional, Layer 0 / Companion B territory.
- D-R4's T+0 record fields → Module 4 formalization (next PLOL pass).
- Trimmed-mean rule (CG-6): estimator guarantees require a separately
  proved two-sided counting property — deployment rule text, no kernel
  change.

---

## v0.3 → v0.3.1 (2026-07-12) — external review, findings register

A Phase 2 external review (ChatGPT; archived at
`external-reviews/2026-07-12-phase2-external-review-chatgpt.txt`) was
received against v0.3. Findings are registered CG-1..CG-6 with
dispositions per Part III routing.

**CG-1 — `pstep` transition loophole (F-class, against the
implementation): FIXED in v0.3.1.** From `spent`, a fresh input with no
issuance request moved the machine to `idle`; from `idle` a later STALE
filing was accepted. A one-hour fresh pulse could therefore launder the
spent marker for an arbitrarily delayed stale filing — a two-step trace
outside R1/R2's all-stale hypotheses and R4's single-step scope. Fix:
`spent` now moves only on `fresh && issue` together — freshness is
consumed by the issuance it authorizes, never banked, and there is no
path from `spent` back to `idle`. New theorem **R5
`freshness_consumed_not_banked`** verifies the closure. Footprint:
66 audited theorems, 28 axiom-free. R1–R4 re-verify unchanged.

**CG-2 — D-R1 conflates the hazard clock with the epistemic clock
(D-class, proposed disposition D-R1A): PENDING OWNER RULING.** Under the
generous bar, persistent exceedance can cycle successive 72h Tier-1
protections indefinitely without the evidentiary record ever advancing
to confirmation — the order expires but the authority functionally
continues. Proposal: split `riskPersistent` (prevents a protection
vacuum; does NOT restart the clock) from `evidenceFresh` (restarts a
full PIO); after an episode's unconfirmed budget is exhausted,
continuing risk enters a constrained continuity-hold that only Layer 0
review can resolve — mirroring Module 2's cap → Structural Review
pattern. Assessment concurs: recommended ADOPT.

**CG-3 — scalar positive bound too strong (D-class, proposed D-R2A):
PENDING OWNER RULING.** (a) `bound_pos` makes a zero-safe-routing
deployment unconstructible, yet payroll/medication/settlement-critical
systems may have no presumptively reversible routing quantum;
(b) irreversibility is not monotone in one scalar (concentration,
duration, criticality, rollback latency, cascade). Proposal: replace the
scalar bound with a deployment-certified reversibility ENVELOPE —
sub-causal routing authorized only with a certificate that the action
lies inside it; no certificate ⇒ no presumptive reversibility.
Assessment concurs (the scalar bound is the degenerate one-dimensional
envelope): recommended ADOPT.

**CG-4 — Q2 answered: severance can be irreversible (D-class, proposed
D-R3): PENDING OWNER RULING.** Reconnection does not reverse missed
care, lost income, divergent state: reversibility should be evaluated
against the affected human/institutional state, not machine topology.
Proposal: severance is irreversibility-bearing UNLESS certified soft
(time-bounded, state-preserving, essential-service floor, tested
restoration); certified soft severance stays Tier 2, otherwise Tier 3.
Assessment concurs: recommended ADOPT, using the same certificate
machinery as CG-3.

**CG-5 — novelClaim needs constitutional structure (proposed D-R4):
PENDING OWNER RULING.** Novelty attaches to a structured claim/incident
identity with disclosed lineage; rewording or repetition is not novelty;
the T+0 semantic record must state the authorization basis
(freshness / continuing risk / both), the episode's cumulative
unconfirmed protection, and the falsification condition; determinations
contestable via Layer 0. Assessment concurs; formalization would ride on
CG-2's episode identity. Recommended ADOPT as constitutional text,
formalize with D-R1A.

**CG-6 — trimmed means confer no status (deployment rule): CONCURS WITH
EXISTING POSITION.** An estimator receives B3's Byzantine guarantee only
after its two-sided counting property is separately proved — already the
kernel's stance (AHC-P1-004); adopt the sentence into deployment rules.

---

## v0.2 → v0.3 (2026-07-12)

Two constitutional rulings were made by the project owner on 2026-07-12,
resolving the questions the Phase 1/2 review had left to the amendment
process. Both are implemented in `TieredProtocol.lean`; digest in
`MANIFEST_v0.3.txt`.

### Ruling D-R1 — PIO re-issuance guard (finding AHC-P1-003): **YES, generous bar**

A failed confirmation consumes its evidence: re-issuance after
auto-reversal requires *fresh* evidence, with freshness defined
generously — `fresh = novelClaim || exceedance`, so ongoing threshold
exceedance itself re-qualifies and only **stale** claims are blocked.
Adopted as R1–R4 (the former `phase2-drafts` guard, upgraded with the
generous bar):

- **R1 `pio_no_relitigation`** — stale evidence buys at most 72
  unconfirmed protected hours, against any re-filing pattern.
- **R2 `reissue_needs_new_evidence`** — under staleness, at most one
  issuance, ever.
- **R3 `ongoing_attack_reprotects`** — *new, the generous bar's payoff:*
  under ongoing exceedance a spent subgraph re-protects immediately on
  request; the protection-gap failure mode of a strict bar is closed by
  construction.
- **R4 `reissue_blocked_iff_stale`** — the guard blocks exactly stale
  claims and nothing else.

The `phase2-drafts/` package is retired: nothing awaits ruling there
any longer. (Its build logs remain in `docs/` as provenance.)

### Ruling D-R2 — reversibility of capital routing (finding AHC-P1-005 / brief D-2): **Q1 yes, Q3 regime-bound**

Graduated capital routing (M1) *can* bear irreversible harm, but only
beyond an identifiable magnitude regime. Adopted as the `Action` /
`RoutingRegime` split, V1–V7: routing at or below the
deployment-specified `RoutingRegime.bound` is reversible and keeps its
Tier-1 requirement (V6 preserves the graduated ladder); routing beyond
the bound joins the irreversible class and requires Tier-3 causal
identification (V5). The Phase 1 guarantee "everything below Tier 3 is
reversible" — previously true of M1 by fiat — is now a consequence of
the gating (V3), and the refinement is provably conservative (V7): no
action authorized under the split was forbidden under the Phase 1 table.
`bound_pos` is constitutive; **where the bound sits for a given
deployment is the remaining amendment surface** and must be specified
per deployment class.

### Left open by the rulings

- **Q2 of the D-2 review** — whether selective dimensional severance
  (M2) is irreversible in any intended deployment — was not reached by
  the ruling path (Q1-yes routed to Q3) and **remains unruled**. M2
  keeps its Phase 1 reversible classification; V-theorems inherit it.
  This should be ruled explicitly in a future pass rather than left
  implicit.
- **What counts as a `novelClaim`** is ATG / Layer 0 territory,
  deliberately outside the machine (same seam discipline as claim
  extraction in Module 4).

---

## v0.1 → v0.2 (2026-07-11)

This document is the change record between the circulated Phase 1 packet
(v0.1, `MANIFEST.txt`) and kernel v0.2 (`MANIFEST_v0.2.txt`). Each entry
cites the Phase 1 assessment finding it resolves (`ASSESSMENT.md`) and its
disposition class under the brief's Part III routing. The v0.1 brief
(`AHC_VerifiedKernel_Phase1_Brief.docx`) is retained unmodified as the
circulated artifact; textual amendments to the brief are recorded here
(E3–E5) pending regeneration of a v0.2 brief.

### Adoptions (F-4 strengthenings, verified and merged into the kernel)

**A1 — Temporal hysteresis (finding AHC-P1-002).**
`TieredProtocol.lean` gains S1 `oscillation_travel`,
S2 `flips_travel_anchored`, S3 `chatter_requires_travel` (plus helpers
`gapWidth`, `postureStep`, `flips`, `travel`, `anchoredAt`,
`flip_anchored`, `flip_gap`, `travel_reanchor`, `flips_cons_eq/ne`).
Headline: `(flips − 1)·(gapWidth + 1) ≤ total variation` over any signal
trajectory — sub-band noise can flip the enforcement posture at most once;
N oscillations require N genuine full-band traversals. The constitutive
strict gap is now load-bearing in a theorem.

**A2 — Composed cap × review semantics (finding AHC-P1-001).**
`CrisisCap.lean` gains `DayInput`, `SysState`, `dayStep`, `dayRun` and
theorems G1–G7 (`dayStep_valid`, `dayRun_valid`,
`review_day_never_emergency`, `review_exit_iff_output`, `trip_forced`,
`review_run`, `review_gate_composed`, `emergency_day_provenance`,
`composed_cap_safety`, `composed_no_permanent_emergency`). The Phase 1
gap — cap arithmetic and review automaton proved separately, never
joined — is closed: one machine, cap trip derived from the window
arithmetic, emergency days during review unconstructible.

**Not adopted:** the PIO re-issuance guard (finding AHC-P1-003) remains a
draft in `phase2-drafts/`, pending the D-class ruling on whether
auto-reversal consumes the issuing evidence.

### Errata (corrections to the circulated packet)

**E1 — CI could pass on a failed build (finding AHC-P1-007, High).**
The v0.1 workflow ran `lake build 2>&1 | tee build.log` in an Actions
`run:` step without explicit `shell: bash`; the implicit shell lacks
`pipefail`, so the step's status was `tee`'s (always success), and the
sorry-grep does not catch a compile failure. v0.2's `ci.yml` sets
`shell: bash` explicitly and adds guards: fail on `Classical.choice`, on
any axiom set other than `[propext(, Quot.sound)]`, and on deviation from
the exact 50/24 audit footprint.

**E2 — T9 gloss overstated (finding AHC-P1-002, part).**
v0.1 glossed `no_chatter` as making "single-signal panic cycling logically
impossible". Cycling is a property of trajectories; T9 is instantaneous.
The docstring and module header now say "simultaneous
escalate/de-escalate", and point to S3 for the temporal claim.

### Amendments to the brief (recorded here; docx unchanged)

**E3 — Part II.F, additional modeling disclosure (finding AHC-P1-003,
part).** Add to the disclosure list:
> Within the 72-hour deadline hour, confirmation takes priority over
> expiry: a PIO whose Tier-1 confirmation arrives during hour 72 is
> confirmed, not auto-reversed. This is the reading generous to
> confirmation; the machine in `TieredProtocol.lean` (`pioStep`)
> implements it.

**E4 — Part I, plain-language finding routing (finding L-1).** The v0.1
Plain Language Summary states how to check the proofs but not, in plain
language, where a finding goes. Add to Part I, "What would prove this
wrong, and how to challenge it":
> If you find a problem — with a proof, with a translation choice, or
> with this document itself — Part III of this packet says exactly where
> it goes and who must answer it. A broken proof is fixed in the kernel;
> a wrong translation goes to the constitution's own amendment process;
> a problem with how burden is placed on communities goes to the Open
> Problems Register. Disagreement does not need our permission to be
> filed.

**E5 — Theorem-count normalization (finding AHC-P1-006).** v0.1 said
"34 theorems" (table rows: B2a/B2b merged, `decCompliant` counted,
`scr_no_fabrication` omitted) while the audit log printed 35 entries.
v0.2 counts one way everywhere: **audit-log entries** — 50 audited
theorems, 24 axiom-free, plus `decCompliant` as a verified `Decidable`
instance additional to the count.

### Digest

- v0.1: `2b51cac67e278c54003bbf2d5974da19d581caeaa4bc6f3f8f23043cffea7609`
- v0.2: `4d44fb1835c732c3cf876b50b0042ff8da793afdfd57f70c120da45a4fef651e`

Per `bridge_proves_origin_not_consistency`, the digest proves origin, not
consistency: consistency you verify by building (`lake build`).
