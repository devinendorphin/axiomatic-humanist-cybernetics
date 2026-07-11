# axiomatic-humanist-cybernetics

envisioning a possible framework for governance involving superintelligent systems

## Contents

- **[`ahc-verified-kernel/`](ahc-verified-kernel/)** — the AHC Verified Constitutional Kernel: a Lean 4.15.0 (core-only, no Mathlib) formalization of the order-theoretic core of AHC v3.1. Four modules, 35 audited theorems, zero `sorry`s, axiom footprint at most `[propext, Quot.sound]`. Byte-identical to the Phase 1 Circulation Packet v0.1; its source digest still matches [`docs/MANIFEST.txt`](docs/MANIFEST.txt).
- **[`docs/`](docs/)** — the Phase 1 circulation brief (Plain Language Summary, Formal Appendix, Reviewer Brief), the packet MANIFEST, and the reproduced build/axiom-audit log.
- **[`ASSESSMENT.md`](ASSESSMENT.md)** — independent Phase 1 assessment: full reproduction of every published claim (all reproduce), findings AHC-P1-001..008 addressed to the brief's reviewer solicitations, and the fixes applied in this repository.
- **[`phase2-drafts/`](phase2-drafts/)** — machine-checked Phase 2 strengthening drafts answering findings AHC-P1-001/002/003: temporal anti-chatter for the hysteresis gap, a composed Crisis-Cap × Structural-Review semantics with a derived cap trip, and a PIO re-issuance guard. 21 theorems, same core-only axiom discipline; imports the kernel without modifying it, so the circulated digest stays verifiable.
- **[`.github/workflows/verify.yml`](.github/workflows/verify.yml)** — CI: rebuilds every proof (kernel and drafts) on each push, fails on any `sorry`, on `Classical.choice`, on any unexpected axiom, or on a deviation from the published audit footprints (35/22 kernel, 21 drafts).

## Verify locally

With [elan](https://github.com/leanprover/elan) installed:

```
cd ahc-verified-kernel && lake build
```

The build re-checks every proof and prints the axiom audit. Expected: every theorem at most `[propext, Quot.sound]`, never `Classical.choice`, 22 audited theorems axiom-free.
