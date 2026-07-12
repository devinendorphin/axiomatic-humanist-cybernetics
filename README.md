# axiomatic-humanist-cybernetics

envisioning a possible framework for governance involving superintelligent systems

## Contents

- **[`ahc-verified-kernel/`](ahc-verified-kernel/)** — the AHC Verified Constitutional Kernel **v0.5**: a Lean 4.15.0 (core-only, no Mathlib) formalization of the order-theoretic core of AHC v3.1. Four modules, 81 audited theorems (36 axiom-free), zero `sorry`s, axiom footprint at most `[propext, Quot.sound]`. v0.2 adopted the Phase 1 review strengthenings (temporal hysteresis; composed cap × review semantics); v0.4 implements the four externally-reviewed dispositions ratified 2026-07-12: the two-clock episode machine with continuity-hold (D-R1A/D-R4) and certified reversibility envelopes for routing and severance (D-R2A/D-R3, answering Q2: severance can be irreversible); v0.5 formalizes D-R4's T+0 disclosure obligations in Module 4, including the first cross-module theorem tying the disclosed episode budget to the authorization machine's accounting. Digest in [`docs/MANIFEST_v0.5.txt`](docs/MANIFEST_v0.5.txt), change record in [`docs/ERRATA_AND_AMENDMENTS.md`](docs/ERRATA_AND_AMENDMENTS.md); superseded records preserved in `docs/` and git history.
- **[`docs/`](docs/)** — the Phase 1 circulation brief (Plain Language Summary, Formal Appendix, Reviewer Brief), the packet MANIFEST, and the reproduced build/axiom-audit log.
- **[`ASSESSMENT.md`](ASSESSMENT.md)** — independent Phase 1 assessment: full reproduction of every published claim (all reproduce), findings AHC-P1-001..008 addressed to the brief's reviewer solicitations, and the fixes applied in this repository.
- **[`.github/workflows/verify.yml`](.github/workflows/verify.yml)** — CI: rebuilds every proof on each push, fails on any `sorry`, on `Classical.choice`, on any unexpected axiom, or on a deviation from the published audit footprint (81/36).

## Verify locally

With [elan](https://github.com/leanprover/elan) installed:

```
cd ahc-verified-kernel && lake build
```

The build re-checks every proof and prints the axiom audit. Expected: 81 audited theorems, every one at most `[propext, Quot.sound]`, never `Classical.choice`, 36 axiom-free.
