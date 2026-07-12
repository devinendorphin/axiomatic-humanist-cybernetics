# axiomatic-humanist-cybernetics

envisioning a possible framework for governance involving superintelligent systems

## Contents

- **[`ahc-verified-kernel/`](ahc-verified-kernel/)** — the AHC Verified Constitutional Kernel **v0.7**: a Lean 4.15.0 (core-only, no Mathlib) formalization of the order-theoretic core of AHC v3.1. Four modules plus a cross-module bridge, 89 audited theorems (40 axiom-free), zero `sorry`s, axiom footprint at most `[propext, Quot.sound]`. v0.2 adopted the Phase 1 review strengthenings (temporal hysteresis; composed cap × review semantics); v0.4 implements the four externally-reviewed dispositions ratified 2026-07-12: the two-clock episode machine with continuity-hold (D-R1A/D-R4) and certified reversibility envelopes for routing and severance (D-R2A/D-R3, answering Q2: severance can be irreversible); v0.5 formalizes D-R4's T+0 disclosure obligations in Module 4, including the first cross-module theorem tying the disclosed episode budget to the authorization machine's accounting; v0.6 derives the episode machine's `exceedance` hazard signal from Module 3's Byzantine measurement layer (bridge theorems X1–X4), so a captured sensor minority can neither fabricate nor solely sustain a continuity-hold; v0.7 extends register invariance to the later civic and technical records (P10–P13), completing both F-4 formalization candidates. Digest in [`docs/MANIFEST_v0.7.txt`](docs/MANIFEST_v0.7.txt), change record in [`docs/ERRATA_AND_AMENDMENTS.md`](docs/ERRATA_AND_AMENDMENTS.md); superseded records preserved in `docs/` and git history.
- **[`docs/`](docs/)** — the current [**v0.7 circulation brief**](docs/AHC_VerifiedKernel_v0.7_Brief.md) ([PDF](docs/AHC_VerifiedKernel_v0.7_Brief.pdf), [DOCX](docs/AHC_VerifiedKernel_v0.7_Brief.docx); Plain Language Summary, Formal Appendix, Reviewer Brief), the versioned MANIFESTs, the amendment record, archived external reviews, and the reproduced build/axiom-audit logs. The original Phase 1 brief (`AHC_VerifiedKernel_Phase1_Brief.docx`) is retained as the circulated v0.1 artifact. The assembled [**v0.7 circulation packet**](docs/AHC-VerifiedKernel-v0.7-Circulation-Packet.zip) (kernel source + MANIFEST + brief + change record, source digest `8d262152…`) is a self-contained reviewer snapshot.
- **[`ASSESSMENT.md`](ASSESSMENT.md)** — independent Phase 1 assessment: full reproduction of every published claim (all reproduce), findings AHC-P1-001..008 addressed to the brief's reviewer solicitations, and the fixes applied in this repository.
- **[`.github/workflows/verify.yml`](.github/workflows/verify.yml)** — CI: rebuilds every proof on each push, fails on any `sorry`, on `Classical.choice`, on any unexpected axiom, or on a deviation from the published audit footprint (89/40).

## Verify locally

With [elan](https://github.com/leanprover/elan) installed:

```
cd ahc-verified-kernel && lake build
```

The build re-checks every proof and prints the axiom audit. Expected: 89 audited theorems, every one at most `[propext, Quot.sound]`, never `Classical.choice`, 40 axiom-free.
