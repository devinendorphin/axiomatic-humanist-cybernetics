# AHC Verified Constitutional Kernel — Errata & Amendments

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
