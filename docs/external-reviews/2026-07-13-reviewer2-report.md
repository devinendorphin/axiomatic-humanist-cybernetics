# Reviewer #2 Report — AHC Verified Constitutional Kernel v0.7

**Recommendation: major revision.**

The project is unusually candid about the distinction between proving a model and validating the world. The problem is not that distinction. The problem is that several of the packet’s strongest plain-language guarantees are not properties of the integrated model actually supplied. The proofs live in parallel interfaces that do not constrain one another, and some public-record claims are not connected to the attestations said to justify them.

I would not circulate v0.7 as a “verified constitutional kernel” without addressing Findings R2-01 through R2-05. The underlying work is worth preserving. The current claim surface is not.

## Review scope and reproduction notes

I unpacked the circulation archive, checked the ZIP integrity, rendered and visually inspected all ten pages of the reviewer brief, and read the Lean sources, audit module, CI workflow, README, manifest, amendment record, and archived prior review.

The advertised source digest is reproducible. Concatenating the byte contents of the sorted `*.lean`, `lakefile.toml`, and `lean-toolchain` files yields:

`8d262152c5f9036b20de9ea1c395a8edf31b4bfd2df893e8a4466d65b56736d0`

I found 89 `#print axioms` entries in `AHCKernel/Audit.lean` and no source-level `sorry`, `admit`, explicit `axiom`, `unsafe`, or `Classical.choice` occurrence outside prose/audit checks.

I could not execute `lake build` in the review environment because Lean/`lake` was not installed and external network access was unavailable. Accordingly, this is a static source and model review, not an independent elaboration certificate.

The packet does not include AHC v3.1 or Companion A. That makes the brief’s F-1 faithfulness review impossible in the strict sense. I can assess faithfulness to the circulation brief, amendment record, and source comments, but not to the cited constitutional text itself.

## Major findings

### R2-01 — Critical: the certificate regime can be bypassed by the PIO and hold APIs

The new certificate-bearing action layer says uncertified routing requires Tier 3:

- `TieredProtocol.lean:994-1034` defines `Envelope`, `CAction`, `reversibleIn`, and `requiredTierC`.
- `TieredProtocol.lean:1132-1142` proves uncertified routing needs causal identification.

But the PIO and continuity-hold do not use that action layer:

- `TieredProtocol.lean:188-205` retains the old mechanism-level declaration that all M1 routing is reversible and requires Tier 1.
- `TieredProtocol.lean:343-350` defines `pioAuthorizes` over `Mech`, not `CAction`.
- `TieredProtocol.lean:937-944` defines `HoldPolicy` over `Mech`, and its “reversibility” proof uses the old `Mech.reversible` Boolean.

Therefore a routing action whose deployment descriptor is outside the envelope is rejected by `requiredTierC`, while the same category of action remains authorized by a pending PIO and can be included in a valid hold policy with no envelope certificate at all.

A concrete logical witness is immediate:

1. Choose `d` with `E.routeInside d = false`.
2. Then `requiredTierC E (.route d) = .t3`.
3. Independently, `pioAuthorizes (.issued 0) .m1` holds because `requiredTier .m1 = .t1`.
4. A `HoldPolicy` allowing `.m1` is constructible because `Mech.reversible .m1 = true` by definition.

This is not merely an institutional seam. It is an internal composition failure. The legacy mechanism API and the certificate-bearing action API disagree, and no theorem forces deployments to use the stricter one.

**Required repair:** make `CAction` the sole authorization object. Define PIO and hold authorization over `CAction δ` under an `Envelope δ`. Replace `HoldPolicy.allowed : Mech → Bool` with an action-level, envelope-indexed policy. Prove that every PIO/hold-authorized routing or severance action is certificate-backed. Remove or quarantine the legacy `pioAuthorizes`/`Mech.reversible` route from deployment-facing use.

### R2-02 — Critical: the public budget claim is not linked to the budget attestation

The brief says the disclosed cumulative budget “carries a proof” and that the public figure cannot drift from the episode machine. The source does not connect those two objects.

- `PLOL.lean:349-355` gives `PIOEvent` an arbitrary `budgetClaim : Claim` and only proves membership in the critical set.
- `PLOL.lean:396-400` defines a separate `BudgetAttestation` with `history`, `claimedHours`, and an equality proof.
- `PLOL.lean:403-418` proves facts about that separate attestation.
- No field or theorem states that `PIOEvent.budgetClaim` encodes `BudgetAttestation.claimedHours`, refers to its history, or is the claim published in any record.

As a result, all of P7-P9 can hold while the record’s `budgetClaim` says “0 hours” and a separate unattached `BudgetAttestation` correctly proves “72 hours.” The theorem proves accuracy of an object; it does not prove accuracy of the public claim.

The same gap permits an empty or selectively truncated `history` to support a formally accurate zero-hour attestation. The packet acknowledges that true-history integrity is institutional, but this is more basic: even the chosen attestation is not attached to the disclosed claim.

**Required repair:** use a typed PIO claim language, for example a `PIOClaim` constructor `budget (hours : Nat) (incident : IncidentId)`. Put the `BudgetAttestation` inside `PIOEvent`, define the published budget claim from that attestation, and prove the exact claim appears in every register. The incident history should be anchored to a canonical append-only log head or state-transition certificate, not supplied as an unconstrained list.

### R2-03 — High: a Layer 0 Boolean launders an exhausted incident back into a stale full PIO

The plain-language summary says only genuinely new evidence can restart a full emergency order. The transition function permits a two-step stale restart:

- `TieredProtocol.lean:655-658`: from `hold`, any `layer0 = true` input goes to `idle`, regardless of novelty, issue, or continuing exceedance.
- `TieredProtocol.lean:649-650`: from `idle`, any later `issue = true` goes to `pending 0`; novelty is not checked.

Counterexample trace:

`hold --(layer0=true, novel=false)--> idle --(issue=true, novel=false)--> pending 0`

E8 does not rule this out because it is pointwise over a transition directly from an exhausted state. E1 explicitly excludes spans containing a Layer 0 output.

A Layer 0 decision may legitimately authorize a new disposition, but the model has only a Boolean and does not encode what the decision was. A denial, a direction to continue the hold, a handoff to ordinary Tier-1 authority, and authorization of a new PIO all collapse into the same reset-to-idle transition.

**Required repair:** replace `layer0 : Bool` with a typed disposition. Do not erase episode history by returning to undifferentiated `idle`. A new full PIO should require either a fresh evidence token or an explicit Layer 0 disposition that authorizes a new episode and records its basis.

### R2-04 — High: the four D-R4 “fields” are untyped roles that may all be the same atom

`PIOEvent` requires `basisClaim`, `noveltyClaim`, and `budgetClaim`, while `Event` supplies a falsifier. There is no role tag, content predicate, or distinctness requirement. One arbitrary claim can fill all four slots and appear once in the critical list.

This does not prove that four accountability fields exist. It proves that four field names point to claims, possibly the same claim, whose meanings are left entirely outside the type system.

The seam can properly contain natural-language interpretation. It should not contain whether a budget claim is a budget claim, whether a novelty claim carries lineage, or whether four mandatory roles have been instantiated.

**Required repair:** introduce a tagged claim type or role-indexed claims, and prove each required role is represented. A single composite disclosure is acceptable only if the type explicitly contains all four components.

### R2-05 — High: the exceedance bridge proves one honest witness, not Byzantine-robust consensus

`ExceedanceBridge.lean:63-74` defines exceedance as at least `f+1` readings at or above a freely supplied threshold. This guarantees that at least one of those readings is honest. It does not show that honest sensors generally corroborate the alarm, that the robust aggregate exceeds the threshold, or that the alarm resists a corrupt coalition assisted by one honest outlier.

For `f = 1`, take four reports:

- corrupt: 100
- honest: 100
- honest: 0
- honest: 0
- threshold: 50

The quorum is two, so exceedance is certified. Yet two of the three honest sensors are below threshold. The corrupt sensor plus one honest false positive determines the alarm.

The bridge also moves the free input rather than eliminating it: every `SensorHour` contains an unconstrained `threshold : Nat` (`ExceedanceBridge.lean:55-61`). A system that can lower the threshold can raise the alarm without corrupting any sensor. No theorem fixes the threshold across time or binds it to a public policy/version.

The source accurately proves “not forgeable by corrupted sensors alone.” The brief repeatedly uses stronger language such as “corruption-resistant measurements,” “honest sensors corroborate,” and “closes the last free input.” Those formulations should be narrowed unless the construction is strengthened.

**Required repair:** bind the threshold to a fixed, versioned, publicly attested configuration; derive exceedance from a robust aggregate or a quorum chosen for the intended corroboration level; and state quantitatively how many honest witnesses are guaranteed. If the desired property is merely one-honest-witness non-fabrication, name it that and do not call it consensus.

## Further substantive findings

### R2-06 — High: the continuity-hold is unbounded and reversibility is pointwise, not temporal

`EpState.hold` carries no clock (`TieredProtocol.lean:618-623`). With continuing exceedance and no Layer 0 output, `hold_persists` permits an infinite hold. The theorem that each allowed mechanism is “reversible” does not establish that indefinite repetition is humane or reversible in cumulative effect. Temporary routing restrictions repeated forever can cause irreversible deprivation even when each individual step is technically rollback-capable.

The hold needs a time budget, periodic mandatory review, or an explicit proof that the policy’s cumulative trajectory remains inside a viability envelope. “Reversible per action” is not “reversible under unbounded iteration.”

### R2-07 — High: certificate predicates are not compositional

`Envelope` is only two pointwise Boolean predicates over descriptors (`TieredProtocol.lean:994-996`). Nothing requires monotonicity, closure, cumulative accounting, or safety under action sequences. Ten individually certified actions may jointly cross a liquidity, dependency, or cascade threshold.

A descriptor could voluntarily encode history, but the kernel does not require it. The constitutional guarantee therefore depends on an unstated deployment convention.

The appropriate object is a state-transition certificate or resource-indexed envelope: authorization should depend on current exposure and produce a new exposure state. At minimum, add an explicit compositionality obligation and a theorem covering finite action traces.

### R2-08 — Medium: “non-critical” does not imply “harmless framing”

`Compliant` only requires inclusion of marked critical claims and absence of claims outside the event (`PLOL.lean:184-188`). `residual_divergence_harmless` proves that a differing claim is genuine and not in the designated critical list (`PLOL.lean:249-261`).

That does not establish harmlessness, framing, or non-finding status. It establishes only that the event constructor did not label the claim critical. A materially important or contradictory finding can be misclassified as non-critical, and the theorem will call the resulting divergence harmless.

Rename the theorem to what it proves, or add a typed distinction between findings and framing plus a completeness obligation for the critical classification.

### R2-09 — Medium: “Axiom II” is a definitional dichotomy with no constitutional consequence

`CrisisCap.lean:367-397` defines `reversibilityClaimHolds` as `response ≤ decay` and `locallyTerminal` as `decay < response`, then proves the linear-order dichotomy.

The theorem is correct but substantively tautological. It does not prove that terminality is detected, that iteration stops, that authority changes mode, or that an affected subgraph receives a remedy. Calling this the machine-checked content of Axiom II overstates what is verified.

Add an operational theorem connecting `locallyTerminal` to a prohibited transition, mandatory structural review, or a change in decision procedure.

### R2-10 — Medium: the crisis-cap machine is not connected to evidence authorization, and the constitutional constants are not instantiated

`dayStep` grants an emergency day whenever authority is requested and the window has room (`CrisisCap.lean:428-440`). It does not require `exceedance`, a Tier-0/PIO authorization, or any Module 1 evidence condition. `exceedance` is used only to force review once the cap is saturated.

This may be an intentional module boundary, but the packet describes a constitutional kernel rather than independent lemmas. There is no bridge proving that each crisis-cap `requested` input was authorized by the evidence-action protocol.

Also, `Cap` permits any `Tcap < W` (`CrisisCap.lean:122-125`). The kernel does not define and audit a concrete `W = 730`, `Tcap = 180` constitutional instance. Genericity is useful, but a concrete pinned instance should be part of the verified artifact.

### R2-11 — Medium: the PLOL “shipped” state assumes compliance rather than modeling publication

`ShippedTripartite` extends a structure that already contains all three records and merely adds compliance proofs (`PLOL.lean:429-437`). There is no current-time witness, publication event, or ordering relation among release hours. Civic and technical records may both have release hour zero.

The theorems are valid conditional statements about compliant records. They do not verify the publication process. The packet should describe them as postconditions of an externally attested shipped release, not as a machine-verified shipping workflow.

### R2-12 — Medium: the formal review packet is not self-contained for faithfulness review

The reviewer brief explicitly asks whether the formal reading weakens or strengthens AHC v3.1 and Companion A. Those texts are not in the packet, nor is there a quotation-level mapping with exact source snapshots and digests.

Include the normative sources, exact version hashes, and a theorem-to-text map quoting the sentences being formalized. Section numbers alone are insufficient for adversarial faithfulness review.

## Documentation, audit, and packaging findings

1. The README contradicts itself. Near the top it says 81 audited theorems and 36 axiom-free; the build section correctly says 89 and 40.
2. The README points to `../docs/ERRATA_AND_AMENDMENTS.md` and `../docs/MANIFEST_v0.7.txt`, but the circulation packet has neither path.
3. `MANIFEST.txt` identifies the circulation brief as `AHC_VerifiedKernel_v0.5_Brief.md`, while the packet contains the v0.7 PDF/DOCX.
4. The PDF’s formal appendix says `decCompliant` is “additional to the 81” while the same page says 89 theorems.
5. The source digest is a hash of concatenated file bytes. It does not bind filenames or file boundaries, and it excludes the CI workflow. A conventional checksums manifest or deterministic archive hash would be stronger.
6. The packet contains no signed CI log, commit identifier, or provenance attestation showing that the supplied bytes are the bytes that passed CI.
7. The CI downloads the latest elan installer and uses mutable action tags. The Lean toolchain is pinned, but the bootstrap chain is not fully pinned.

These are not the main reasons for major revision, but they undermine the packet’s audit posture and should be fixed before the next circulation.

## Positive assessment

The source is readable, compact, and unusually explicit about modeling choices. The amendment record is excellent as a trace of how external criticism changed the formalization. The source digest matches the supplied kernel. The audit inventory is transparent. The brief also correctly directs reviewers toward modeling choices rather than treating successful elaboration as the end of review.

The most valuable next step is not adding more isolated theorems. It is closing the interfaces:

- certificate-bearing actions must be the only actions PIO and hold states can authorize;
- disclosed claims must be typed and attached to the attestations said to justify them;
- Layer 0 outputs must carry dispositions rather than act as reset bits;
- exceedance must be derived from a fixed policy and a stated level of honest corroboration;
- temporal and compositional safety must be proved over action sequences.

## Final disposition

I find no static evidence of a fake proof artifact or an obvious placeholder. I do find multiple behaviors that satisfy the supplied Lean model while violating the circulation brief’s strongest English claims. That is exactly the F-1/F-2/F-3 class of failure the review brief asks reviewers to locate.

**Disposition: major revision; do not accept the present plain-language guarantees as verified.**
