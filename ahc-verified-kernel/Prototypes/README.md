# Prototype repairs — v0.12 review findings

These Lean modules prototype the repairs prescribed by the v0.12 multi-lens
external review (findings **V12-01 … V12-06**). They are a **target for a
future kernel version**, not part of the audited kernel.

## Isolation from the audited kernel

- **Not imported** by `AHCKernel.lean`, so `lake build` (the audited
  116-theorem kernel and its axiom audit in `AHCKernel/Audit.lean`) is
  **unaffected** — the digest, the theorem count, and the "zero `sorry`"
  build story are untouched.
- Built under a separate `Prototypes` `lean_lib` target, excluded from
  `defaultTargets`.

```sh
lake build              # audited kernel only (unchanged)
lake build Prototypes   # the prototype repairs below
```

> **Compile status:** authored against the kernel's own proof idioms
> (`decide`, structural induction, `cond`/`simp`, constructor
> disjointness via `nofun`/`noConfusion`) but **not yet machine-checked in
> this environment** — the Lean toolchain host was unreachable under the
> session's egress policy. Run `lake build Prototypes` to confirm before
> relying on any theorem here.

## What each module establishes

| File | Finding | Core repair, as theorems |
|---|---|---|
| `V12_01_TraceInterface.lean` | V12-01 | `PIOExec` / `HoldExec` are exposure-consuming authorization paths; `pioExec_stays_inside` / `holdExec_stays_inside` prove threshold-safety **unconditionally** (not only for traces voluntarily presented as `TraceAuthorized`). `pioAuthorizesC_is_snapshot` quarantines the fixed-`Envelope` API as the trivial-exposure degenerate case. |
| `V12_02_TypedIssuance.lean` | V12-02 | `AcuteTrigger` / `Tier1Certificate` carry the acute-horizon, Tier-0-observation, and lineage obligations as proof fields; `issuance_evidence_backed` / `confirmation_evidence_backed` prove the derived bits cannot fire without evidence; `idle_stays_without_trigger` connects to the kernel machine. |
| `V12_03_ConfirmedHandoff.lean` | V12-03 | `PIO'` replaces the absorbing `confirmed` with a terminal `handedOff`; `handoff_grants_nothing_protective` proves the channel closes (broadcast only); `original_confirmed_is_sink` exhibits the defect being repaired. |
| `V12_04_RoleUniqueness.lean` | V12-04 | `StrictPIOEvent` adds global budget uniqueness and content-level body distinctness; `strict_budget_no_drift_global` closes the noncritical-contradiction path; `strict_no_single_sentence` refutes `basisBody = noveltyBody = falsifBody`. |
| `V12_05_Separation.lean` | V12-05 | `Allocation` types the governance roles with incompatibility obligations; `no_self_certification` / `no_self_review` make separation of powers a proved constraint; `separatedAllocation` is the non-vacuity witness. |
| `V12_06_EnactedReview.lean` | V12-06 | `EnactedOutput` requires proof of enactment **and** resolution; `review_closes_only_enacted` closes the label-discharge path; the monotone `ledger` (`ledger_breach_persists`) makes a recorded breach survive resumption. |

## Status of V12-07 and V12-08

- **V12-07** (map's fourth column) is discharged in
  `docs/normative/THEOREM_TO_TEXT_MAP.md`, not here.
- **V12-08** (public rhetoric) is a wording issue for the brief, not a
  Lean change.

## Relationship to the kernel's method

Each prototype is **additive**: it introduces corrected objects and proves
what they buy, rather than editing the proven E-/W-/P-/G-families in place.
A full adoption would fold the corrected object into the kernel and re-run
the affected proofs — e.g. V12-01 makes `PIOExec` the deployment-facing
authorizer and quarantines `pioAuthorizesC` exactly as R2-01 quarantined
the legacy `Mech` API.
