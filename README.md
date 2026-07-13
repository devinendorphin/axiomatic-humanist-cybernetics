# axiomatic-humanist-cybernetics

envisioning a possible framework for governance involving superintelligent systems

## Contents

- **[`ahc-verified-kernel/`](ahc-verified-kernel/)** — the AHC Verified Constitutional Kernel **v0.11**: a Lean 4.15.0 (core-only, no Mathlib) formalization of the order-theoretic core of AHC v3.1. Four modules plus a cross-module bridge, 107 audited theorems (46 axiom-free), zero `sorry`s, axiom footprint at most `[propext, Quot.sound]`. v0.2 adopted the Phase 1 review strengthenings (temporal hysteresis; composed cap × review semantics); v0.4 implements the four externally-reviewed dispositions ratified 2026-07-12: the two-clock episode machine with continuity-hold (D-R1A/D-R4) and certified reversibility envelopes for routing and severance (D-R2A/D-R3, answering Q2: severance can be irreversible); v0.5 formalizes D-R4's T+0 disclosure obligations in Module 4, including the first cross-module theorem tying the disclosed episode budget to the authorization machine's accounting; v0.6 derives the episode machine's `exceedance` hazard signal from Module 3's Byzantine measurement layer (bridge theorems X1–X4), so a captured sensor minority can neither fabricate nor solely sustain a continuity-hold; v0.7 extends register invariance to the later civic and technical records (P10–P13), completing both F-4 formalization candidates; v0.8 adopts a typed D-R4 claim language closing Reviewer #2 findings R2-02/R2-04 — the disclosed episode budget and its attestation are one term, and the four disclosure roles are distinct by construction (P14–P17); v0.9 closes finding R2-01 by lifting PIO and continuity-hold authorization onto the certificate-bearing action layer (W10–W18), quarantining the mechanism-granularity table to a proved outer bound; v0.10 closes findings R2-03/R2-06 with typed Layer 0 dispositions and a mandatory-review clock on the continuity-hold — an unreviewed hold expires into a flagged `overdue` state, and only an explicit new-episode authorization reopens the full clock (E12–E15); v0.11 is the claim-surface alignment pass for findings R2-05/R2-08/R2-09 — theorem names and glosses narrowed to exactly what is proved, no proof changed. Digest in [`docs/MANIFEST_v0.11.txt`](docs/MANIFEST_v0.11.txt), change record in [`docs/ERRATA_AND_AMENDMENTS.md`](docs/ERRATA_AND_AMENDMENTS.md); superseded records preserved in `docs/` and git history.
- **[`docs/`](docs/)** — the current [**v0.7 circulation brief**](docs/AHC_VerifiedKernel_v0.7_Brief.md) ([PDF](docs/AHC_VerifiedKernel_v0.7_Brief.pdf), [DOCX](docs/AHC_VerifiedKernel_v0.7_Brief.docx); Plain Language Summary, Formal Appendix, Reviewer Brief), the versioned MANIFESTs, the amendment record, archived external reviews, and the reproduced build/axiom-audit logs. The original Phase 1 brief (`AHC_VerifiedKernel_Phase1_Brief.docx`) is retained as the circulated v0.1 artifact. The assembled [**v0.7 circulation packet**](docs/AHC-VerifiedKernel-v0.7-Circulation-Packet.zip) (kernel source + MANIFEST + brief + change record, source digest `8d262152…`) is a self-contained reviewer snapshot.
- **[`ASSESSMENT.md`](ASSESSMENT.md)** — independent Phase 1 assessment: full reproduction of every published claim (all reproduce), findings AHC-P1-001..008 addressed to the brief's reviewer solicitations, and the fixes applied in this repository.
- **[`.github/workflows/verify.yml`](.github/workflows/verify.yml)** — CI: rebuilds every proof on each push, fails on any `sorry`, on `Classical.choice`, on any unexpected axiom, or on a deviation from the published audit footprint (107/46).

## Verify locally

With [elan](https://github.com/leanprover/elan) installed:

```
cd ahc-verified-kernel && lake build
```

The build re-checks every proof and prints the axiom audit. Expected: 107 audited theorems, every one at most `[propext, Quot.sound]`, never `Classical.choice`, 46 axiom-free.
