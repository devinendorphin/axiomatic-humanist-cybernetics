# AHC Verified Kernel — Phase 2 Drafts (remaining)

**Status: DRAFT, awaiting a D-class constitutional ruling.** This package
originally carried three draft families answering the Phase 1 assessment
([`../ASSESSMENT.md`](../ASSESSMENT.md)). Two were **adopted into kernel
v0.2** and no longer live here (see
[`../docs/ERRATA_AND_AMENDMENTS.md`](../docs/ERRATA_AND_AMENDMENTS.md)):

- Temporal hysteresis (S1–S3, finding AHC-P1-002) → `AHCKernel/TieredProtocol.lean`
- Composed cap × review semantics (G1–G7, finding AHC-P1-001) → `AHCKernel/CrisisCap.lean`

What remains is the one draft whose adoption is **not** a formal-methods
decision but a constitutional-interpretation one.

## `Phase2Drafts/PIOReissuance.lean` (finding AHC-P1-003)

The kernel's PIO machine is single-instance: T8 proves one order resolves
within 72 hours, but cannot refute re-issuance laundering — auto-reverse
at hour 72, re-file on the same evidence, cycle Tier-1 protection
indefinitely on Tier-0 grounds. Under the guard *re-issuance after
auto-reversal requires new acute evidence*:

| Theorem | Statement |
|---|---|
| `reissue_needs_new_evidence` (R2) | Without new evidence: at most one issuance, ever |
| `pio_no_relitigation` (R1) | **Headline.** Without new evidence, total unconfirmed protected hours ≤ 72 across any re-filing pattern — the deadline bounds the *evidence*, not the order |

⚠️ **The guard condition is a modeling proposal, not settled text.**
Whether a failed confirmation consumes its evidence is a D-class question
for the specification's amendment process. This draft makes the question
precise; the ruling, not the formalization, decides. Once ruled:
*yes* → adopt into `TieredProtocol.lean` (new digest, MANIFEST bump);
*no* → the theorems are retired and the laundering exposure must be
closed by other constitutional means (or accepted, documented).

**Toolchain:** Lean 4.15.0, core only. 6 audited theorems, zero `sorry`s,
no `Classical.choice`, footprint at most `[propext, Quot.sound]`.

```
cd phase2-drafts && lake build   # builds the kernel dependency, then the draft
```
