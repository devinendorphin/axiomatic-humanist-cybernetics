# AGENTS.md — axiomatic-humanist-cybernetics

## Scope and authority

This file is Codex's entry point. It does not replace `CLAUDE.md`, the Lean source, the current manifest, the errata, or numbered external-review findings.

Before substantive work, read `CLAUDE.md`, the relevant module, the current manifest and errata, and the review finding or solicitation the change answers. When prose and the kernel disagree, narrow the prose to the proof.

## Formal discipline

- Run `cd ahc-verified-kernel && lake build` before making a verification claim.
- Preserve the exact audit footprint enforced by the current manifest and CI: no `sorry`, no `Classical.choice`, and no unannounced widening of permitted axioms or changes to audited and axiom-free counts.
- Keep theorem names, glosses, and public claims no stronger than the theorem statements.
- Treat source digests as origin evidence, not proof of consistency. The build establishes consistency within the stated formal boundary.
- Tie releases and substantive changes to numbered review findings; use versioned manifests and visible errata rather than rewriting prior releases.
- Preserve Module 5's seam: it imports Veriticide's machinery, not its corpus. A `SeamClaim` has no truth field and must not be described as proving its payload true.
- Preserve reviewer questions, limitations, and affected-population counter-records. Do not make the issuer the sole validator.

## Change and review workflow

- Work on a `codex/<task>` branch and open a draft pull request. Do not push directly to `main`, enable auto-merge, or merge without Endorphin's explicit instruction for that specific pull request.
- Do not alter a theorem, audit list, manifest digest, version, or review disposition without updating every dependent surface and stating the footprint change explicitly.
- Require the repository verification workflow to pass before recommending merge. Record local or CI checks that could not be run.
- Mark uncertain speech-to-text repairs as `[?original→guess]`; never silently guess Endorphin's wording.
- End each task with a ledger of theorem and prose surfaces changed, findings addressed, build and audit results, footprint effects, and open limitations.

## Code review rules

Flag theorem names stronger than their statements, prose that treats a seam payload as proven, unexpected axioms, omitted audit entries, stale manifests, silent version rewrites, and any merge recommendation made without a green verification run.
