# AHC Verified Kernel — Phase 2 Strengthening Drafts

**Status: DRAFT.** Machine-checked candidate strengthenings answering the
findings of the Phase 1 assessment ([`../ASSESSMENT.md`](../ASSESSMENT.md)).
This package **imports the Phase 1 kernel and adds to it; it does not touch
it** — `../ahc-verified-kernel/` remains byte-identical to the circulated
packet and its MANIFEST digest still verifies. Adoption of any draft into
the kernel is a Phase 2 act that follows the packet's own disposition
routing, and produces a new digest and a new MANIFEST version.

**Toolchain:** Lean 4.15.0, core only — same discipline as the kernel:
21 theorems, zero `sorry`s, no `Classical.choice`, axiom footprint at most
`[propext, Quot.sound]` (3 theorems axiom-free). Reproduced audit log:
[`../docs/phase2-drafts-build-audit.log`](../docs/phase2-drafts-build-audit.log).

```
cd phase2-drafts && lake build     # builds the kernel dependency, then the drafts
```

## Module 1 — `Phase2Drafts/Hysteresis.lean` (finding AHC-P1-002 → F-4)

Phase 1's T9 proves escalate/de-escalate are mutually exclusive *at an
instant* — true, but satisfied by a zero-width band. These drafts state the
*temporal* content of §9.2's gap:

| Theorem | Statement |
|---|---|
| `oscillation_travel` (S1) | Any escalating value and any de-escalating value are separated by **more than the gap width** |
| `flips_travel_anchored` (S2) | Anchored machine bound: every posture flip costs the signal at least gapWidth+1 of total variation |
| `chatter_requires_travel` (S3) | **Headline.** Over any trajectory, `(flips − 1)·(gapWidth+1) ≤ total variation`: noise smaller than the band can flip the posture at most once, ever; N oscillations require N genuine full-band traversals |

The gap width appears in the bound, so — unlike in T9 — the constitutive
strict gap is load-bearing. Proposed adoption: S3 beside T9 in kernel
Module 1, with T9's gloss narrowed from "cycling" to "simultaneous
escalate/de-escalate".

## Module 2 — `Phase2Drafts/CrisisCapComposition.lean` (finding AHC-P1-001 → F-4)

Phase 1 proves the cap arithmetic (C1–C3) and the review gate (C4–C6) over
two machines that never compose. This module joins them: one machine,
stepped daily, in which the emergency-day decision, the cap trip, and the
Structural Review gate are one transition function — and `capTrip` is
**derived** from the window arithmetic, not a free input.

| Theorem | Statement |
|---|---|
| `dayStep_valid` / `dayRun_valid` (G1) | Every reachable trace is protocol-`Valid`, so C1–C3 apply to the composed system verbatim |
| `review_day_never_emergency` (G2) | In review, the appended day is `false` for **every** input — an emergency day during review is unconstructible |
| `review_exit_iff_output` (G3) | Review closes **exactly** on a Layer 0 output (C5, as an iff) |
| `trip_forced` (G4) | Operational + continued exceedance + saturated window **must** trip into review: the trip is arithmetic, not discretion |
| `review_run` / `review_gate_composed` (G5) | Across any output-free span, review persists and the trace extension is all-`false` — §12.3's sentence about the same trace the cap counts |
| `emergency_day_provenance` (G6) | Inversion: every emergency day was individually authorized (operational mode ∧ actual request ∧ window strictly below cap). No other path exists |
| `composed_cap_safety` / `composed_no_permanent_emergency` (G7) | C1/C2/C3 restated of the composed machine from its initial state |

Together these close the F-2 question: in the composed semantics there is
no gaming path through the trace/automaton interaction.

## Module 3 — `Phase2Drafts/PIOReissuance.lean` (finding AHC-P1-003 → F-4, contingent on a D-ruling)

Phase 1's PIO machine is single-instance, so it cannot refute re-issuance
laundering (auto-reverse at hour 72, re-file on the same evidence). Under
the guard *re-issuance after auto-reversal requires new acute evidence*:

| Theorem | Statement |
|---|---|
| `reissue_needs_new_evidence` (R2) | Without new evidence: at most one issuance, ever |
| `pio_no_relitigation` (R1) | **Headline.** Without new evidence, total unconfirmed protected hours ≤ 72 across any input sequence — the deadline bounds the *evidence*, not the order |

⚠️ The guard condition is a **modeling proposal**, not settled
constitutional text: whether "new acute evidence" is the right re-issuance
condition is a D-class interpretation question that must be ruled on before
adoption. The draft makes that question precise; it does not moot it.

## Principle 19.2 compliance

No new mechanism is introduced. Every machine here refines semantics the
specification already states in English (§9.2 hysteresis, §12.3 trip/review
sentences, §5.4 PIO reversal); every translation choice is disclosed in its
module header and is a named contestation target. Modules 1–2 verify
existing sentences directly; Module 3 is explicitly contingent on an
interpretation ruling and is packaged so the ruling, not the formalization,
decides.
