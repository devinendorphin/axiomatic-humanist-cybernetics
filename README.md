# axiomatic-humanist-cybernetics

envisioning a possible framework for governance involving superintelligent systems

## Contents

- **[`ahc-verified-kernel/`](ahc-verified-kernel/)** — the AHC Verified Constitutional Kernel: a Lean 4.15.0 (core-only, no Mathlib) formalization of the order-theoretic core of AHC v3.1. Four modules, 35 audited theorems, zero `sorry`s, axiom footprint at most `[propext, Quot.sound]`. Byte-identical to the Phase 1 Circulation Packet v0.1; its source digest still matches [`docs/MANIFEST.txt`](docs/MANIFEST.txt).
- **[`docs/`](docs/)** — the Phase 1 circulation brief (Plain Language Summary, Formal Appendix, Reviewer Brief), the packet MANIFEST, and the reproduced build/axiom-audit log.
- **[`ASSESSMENT.md`](ASSESSMENT.md)** — independent Phase 1 assessment: full reproduction of every published claim (all reproduce), findings AHC-P1-001..008 addressed to the brief's reviewer solicitations, and the fixes applied in this repository.
- **[`.github/workflows/verify.yml`](.github/workflows/verify.yml)** — CI: rebuilds every proof on each push, fails on any `sorry`, on `Classical.choice`, on any unexpected axiom, or on a deviation from the published 35/22 audit footprint.

## Verify locally

With [elan](https://github.com/leanprover/elan) installed:

```
cd ahc-verified-kernel && lake build
```

The build re-checks every proof and prints the axiom audit. Expected: every theorem at most `[propext, Quot.sound]`, never `Classical.choice`, 22 audited theorems axiom-free.
