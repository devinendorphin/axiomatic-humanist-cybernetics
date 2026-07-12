# axiomatic-humanist-cybernetics

envisioning a possible framework for governance involving superintelligent systems

## Contents

- **[`ahc-verified-kernel/`](ahc-verified-kernel/)** — the AHC Verified Constitutional Kernel **v0.3.1**: a Lean 4.15.0 (core-only, no Mathlib) formalization of the order-theoretic core of AHC v3.1. Four modules, 66 audited theorems (28 axiom-free), zero `sorry`s, axiom footprint at most `[propext, Quot.sound]`. v0.2 adopted the Phase 1 review strengthenings (temporal hysteresis; composed cap × review semantics); v0.3 implements the constitutional rulings of 2026-07-12 (PIO re-issuance guard with generous freshness bar; regime-split capital routing); v0.3.1 closes external-review finding CG-1 (fresh-pulse laundering, theorem R5). Digest in [`docs/MANIFEST_v0.3.txt`](docs/MANIFEST_v0.3.txt), change record in [`docs/ERRATA_AND_AMENDMENTS.md`](docs/ERRATA_AND_AMENDMENTS.md); superseded records preserved in `docs/` and git history.
- **[`docs/`](docs/)** — the Phase 1 circulation brief (Plain Language Summary, Formal Appendix, Reviewer Brief), the packet MANIFEST, and the reproduced build/axiom-audit log.
- **[`ASSESSMENT.md`](ASSESSMENT.md)** — independent Phase 1 assessment: full reproduction of every published claim (all reproduce), findings AHC-P1-001..008 addressed to the brief's reviewer solicitations, and the fixes applied in this repository.
- **[`.github/workflows/verify.yml`](.github/workflows/verify.yml)** — CI: rebuilds every proof on each push, fails on any `sorry`, on `Classical.choice`, on any unexpected axiom, or on a deviation from the published audit footprint (66/28).

## Verify locally

With [elan](https://github.com/leanprover/elan) installed:

```
cd ahc-verified-kernel && lake build
```

The build re-checks every proof and prints the axiom audit. Expected: 66 audited theorems, every one at most `[propext, Quot.sound]`, never `Classical.choice`, 28 axiom-free.
