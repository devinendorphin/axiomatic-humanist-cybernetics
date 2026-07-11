# axiomatic-humanist-cybernetics

envisioning a possible framework for governance involving superintelligent systems

## Contents

- **[`ahc-verified-kernel/`](ahc-verified-kernel/)** — the AHC Verified Constitutional Kernel **v0.2**: a Lean 4.15.0 (core-only, no Mathlib) formalization of the order-theoretic core of AHC v3.1. Four modules, 50 audited theorems (24 axiom-free), zero `sorry`s, axiom footprint at most `[propext, Quot.sound]`. v0.2 adopts the Phase 1 review strengthenings (temporal hysteresis; composed cap × review semantics); digest in [`docs/MANIFEST_v0.2.txt`](docs/MANIFEST_v0.2.txt), change record in [`docs/ERRATA_AND_AMENDMENTS.md`](docs/ERRATA_AND_AMENDMENTS.md). The circulated v0.1 record is preserved in [`docs/MANIFEST.txt`](docs/MANIFEST.txt) and git history (tag point: commit `ffed6c1`).
- **[`docs/`](docs/)** — the Phase 1 circulation brief (Plain Language Summary, Formal Appendix, Reviewer Brief), the packet MANIFEST, and the reproduced build/axiom-audit log.
- **[`ASSESSMENT.md`](ASSESSMENT.md)** — independent Phase 1 assessment: full reproduction of every published claim (all reproduce), findings AHC-P1-001..008 addressed to the brief's reviewer solicitations, and the fixes applied in this repository.
- **[`phase2-drafts/`](phase2-drafts/)** — remaining Phase 2 draft: the PIO re-issuance guard (6 theorems, same core-only discipline), held out of the kernel pending a D-class constitutional ruling on whether auto-reversal consumes its issuing evidence. The other two draft families were adopted into kernel v0.2.
- **[`.github/workflows/verify.yml`](.github/workflows/verify.yml)** — CI: rebuilds every proof (kernel and drafts) on each push, fails on any `sorry`, on `Classical.choice`, on any unexpected axiom, or on a deviation from the published audit footprints (50/24 kernel, 6 drafts).

## Verify locally

With [elan](https://github.com/leanprover/elan) installed:

```
cd ahc-verified-kernel && lake build
```

The build re-checks every proof and prints the axiom audit. Expected: 50 audited theorems, every one at most `[propext, Quot.sound]`, never `Classical.choice`, 24 axiom-free.
