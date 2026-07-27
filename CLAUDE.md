# axiomatic-humanist-cybernetics

**Register: formal / verified.** A Lean 4.15.0 kernel with a published audit footprint.
Claims here are machine-checked; the standard is proof, not argument.

**Thesis:** a governance framework for superintelligent systems (AHC v3.1) with a formally
verified order-theoretic core — the AHC Verified Constitutional Kernel.

## Repo-specific discipline

- **The audit footprint is load-bearing.** 133 audited theorems, 60 axiom-free, zero
  `sorry`s, axioms at most `[propext, Quot.sound]`, never `Classical.choice`. CI fails on any
  deviation. Do not add a proof that widens the footprint without saying so explicitly.
- **Verify before claiming:** `cd ahc-verified-kernel && lake build`.
- **Claim-surface alignment.** v0.11 was an entire release spent narrowing theorem names and
  glosses to exactly what is proved. Hold that line: a theorem's name must not promise more
  than its statement.
- **Version against review findings.** Releases close numbered external findings (R2-01…
  R2-09). New work should say which finding or solicitation it answers.
- **Module 5 is the seam to the world.** The Seam Ledger addresses well-typed lies from
  legitimate authorities, importing the machinery — not the corpus — of
  `veriticide-general-ledger`. A `SeamClaim` deliberately has no `truth` field; it proves no
  payload true. Preserve that.

## The harness

The canonical working agreements, the atlas of all 20 repos, and the shared glossary live in
**`devinendorphin/claude-at-claude`**. Pull it in when you need the full map:

```
add_repo devinendorphin/claude-at-claude
```

This container is ephemeral, so anything that matters gets committed *this turn*. Be a
collaborator rather than a cheerleader, and run a disconfirming test on primed claims.
Endorphin works from a phone and often dictates while walking — expect speech-to-text
artifacts, and mark guessed corrections `[?original→guess]`.
