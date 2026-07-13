# Author Response to Reviewer #2 — AHC Verified Kernel v0.7

**Date:** 2026-07-13
**Re:** Reviewer #2 Report (recommendation: major revision), findings R2-01 – R2-12 plus packaging items.
**Verification note:** every code claim below was re-checked against the v0.7 sources on branch `claude/chatgpt-assessment-feedback-95xjd1`. Line numbers refer to that tree.
**Status update (2026-07-13):** the R2-02/R2-04 repairs described below have
since landed as kernel **v0.8** (typed `PIOClaim` language, attestation-bearing
`PIOEvent`, theorems P14–P17; see `ERRATA_AND_AMENDMENTS.md` and
`MANIFEST_v0.8.txt`), CI-verified at 93 audited theorems / 43 axiom-free.
Documentation items 1–4 are also fixed. The R2-01 repair has landed as
kernel **v0.9** (`pioAuthorizesC`, `CHoldPolicy`, theorems W10–W18; the
legacy mechanism-granularity layer is quarantined by theorem W17),
CI-verified at 102 audited theorems / 46 axiom-free. The R2-03/R2-06
repairs have landed as kernel **v0.10** (typed `Layer0Disposition`,
clocked hold with flagged `overdue` state, theorems E12–E15; E1/E2
strengthened), CI-verified at 107 audited theorems / 46 axiom-free. The
claim-surface items have landed as kernel **v0.11** (R2-05/R2-08/R2-09
narrowed in source and brief; R2-10/R2-11 boundaries stated; renames
`residual_divergence_noncritical` / `later_residual_divergence_noncritical`;
new circulation brief `AHC_VerifiedKernel_v0.11_Brief.md` with the full
disposition table in Part II.J). The R2-07 repair has landed as kernel
**v0.12** (`TEnvelope` exposure-indexed certificates, trace-safety
theorems W19–W26, per the report's own prescription), CI-verified at
116 audited theorems / 49 axiom-free — every formal finding of the
report is now closed. Remaining: packaging items 5–7 plus PDF/DOCX
regeneration.

## Preamble: what this review did and did not find

We accept the review as substantially correct and well-founded. The line references map to real code, the counterexamples elaborate against the actual definitions, and the accompanying Python witnesses reproduce real machine traces. We are grateful for it.

One framing point governs every disposition below, and we state it up front so the response is not mistaken for defensiveness:

**No finding alleges an unsound proof, a placeholder, or a `sorry`, and none exists.** The reviewer says as much ("I find no static evidence of a fake proof artifact"). Every theorem in the kernel is true exactly as stated; the axiom footprint remains `propext`/`Quot.sound`. The review's subject is the *distance between our plain-language claims and the propositions the Lean actually discharges* — plus, in two important cases, two formal objects inside the kernel that ought to constrain each other and currently do not.

We therefore sort the findings into four dispositions:

- **ACCEPT (internal gap)** — two formal objects that should be wired together and are not; fixable in Lean. R2-01, R2-02.
- **ACCEPT (narrow the claim)** — the theorem is sound; the brief's prose claims more than it proves; we will narrow the language. R2-05, R2-08, R2-09.
- **ACCEPT IN PART** — an accurate modeling observation; part already lives at the declared seam, part warrants a targeted strengthening. R2-03, R2-04, R2-06, R2-07.
- **CLARIFY / declared seam or module boundary** — already disclosed; we will sharpen the disclosure rather than change the model. R2-10, R2-11, R2-12.
- **ACCEPT (packaging)** — documentation and provenance defects; straightforward fixes. Doc items 1–7.

## Summary disposition table

| Finding | Reviewer severity | Our disposition | Fix locus |
|---|---|---|---|
| R2-01 PIO/hold bypass the certificate layer | Critical | **Accept — internal gap** | Lean (`TieredProtocol`) |
| R2-02 budget claim not linked to attestation | Critical | **Accept — internal gap** | Lean (`PLOL`) |
| R2-03 Layer 0 Boolean resets a stale episode | High | **Accept in part** | Lean + brief |
| R2-04 four D-R4 fields may be one atom | High | **Accept in part** (severity: Low) | Lean + brief |
| R2-05 exceedance = one witness, not consensus | High | **Accept — narrow the claim** | Brief (+ optional Lean) |
| R2-06 continuity-hold is unbounded | High | **Accept in part** | Lean + brief |
| R2-07 certificate predicates not compositional | High | **Accept in part** | Lean (future) + brief |
| R2-08 "non-critical" ≠ "harmless" | Medium | **Accept — narrow the claim** | Brief (theorem gloss) |
| R2-09 Axiom II dichotomy is near-tautological | Medium | **Accept — narrow the claim** | Brief (+ optional Lean) |
| R2-10 crisis-cap not bridged to evidence; constants generic | Medium | **Clarify / boundary** | Brief (+ optional Lean) |
| R2-11 `ShippedTripartite` assumes compliance | Medium | **Clarify** | Brief |
| R2-12 packet not self-contained for faithfulness | — | **Accept** | Packaging |
| Doc 1–7 (README, manifest, digest, CI) | — | **Accept** | Packaging |

---

## Findings

### R2-01 — PIO and hold authorize over `Mech`, not `CAction` — **ACCEPT (internal gap)**

**The finding is correct and it is the most important one.** The D-R2A/D-R3 rulings introduced the certificate-bearing action layer (`CAction`, `Envelope`, `requiredTierC`, W1–W9) precisely to abolish the fiat that M1 routing is reversible: reversibility "is exactly its certificate" (W8). But the PIO and continuity-hold were never lifted to that layer:

- `pioAuthorizes` (`TieredProtocol.lean:346-350`) is defined over `Mech`; `pio_reversible` (`:379-385`) discharges its conclusion through `Mech.reversible .m1 = true` (`:191-195`) — the exact Boolean D-R2A repudiated.
- `HoldPolicy.allowed : Mech → Bool` (`:937-944`) is likewise `Mech`-indexed, and `hold_floor_reversible` leans on the same Boolean.

Consequently `pioAuthorizes (.issued 0) .m1` holds unconditionally, with no `Envelope` in scope, while the same routing described by a descriptor outside the envelope is sent to Tier 3 by `requiredTierC`. No theorem forces a PIO- or hold-authorized routing/severance action to be certificate-backed. This is not a seam — both objects are internal and formal — so it is a genuine composition gap, and the brief's reliance on T7 ("everything a PIO authorizes is reversible") to describe the *certified* regime is not earned.

**Planned repair (adopting the reviewer's own recipe).** Make `CAction δ` under an `Envelope δ` the sole authorization object for the emergency path: redefine PIO and hold authorization over certified actions, replace `HoldPolicy.allowed : Mech → Bool` with an envelope-indexed action policy, and prove that every PIO/hold-authorized routing or severance is certificate-backed. Retain the `Mech` table only as the explicitly-labelled Phase-1 presumptive floor (W7), quarantined from deployment-facing authorization. This is a v0.8 kernel change, not a wording change.

### R2-02 — the disclosed `budgetClaim` is not the attested figure — **ACCEPT (internal gap)**

**Correct.** `PIOEvent.budgetClaim : Claim` (`PLOL.lean:349-355`) is an abstract atom whose only obligation is `∈ critical`. `BudgetAttestation` (`:396-399`) is a *separate* structure carrying `claimedHours` and the `accurate` proof that it equals `epPendingHours`. P7 (`:363-373`) proves the atom is disclosed; P8/P9 (`:403-418`) prove facts about the attestation. Nothing states `budgetClaim` encodes `BudgetAttestation.claimedHours`. So P7–P9 can all hold with `budgetClaim` reading "0 hours" and an unattached attestation correctly proving "72."

This directly undercuts two brief sentences: "**The disclosed budget figure carries a proof** it equals the episode machine's accounting" (P8 gloss, brief l.283) and "the … authorization layer cannot **drift apart on the one figure**" (brief l.299). In the Lean, the *disclosed* figure and the *proven* figure are different objects.

We note for the record that this is **not** pre-conceded by limitation L-2. L-2 concedes a deeper seam — whether the *recorded history* is the true history. R2-02 is more basic and is on the formal side of the seam: even the chosen attestation is not attached to the disclosed claim. The catch stands.

**Planned repair.** Move `BudgetAttestation` inside `PIOEvent` and *define* the published budget claim from it (a typed `PIOClaim.budget (hours) (incident)` constructor), so P7's disclosed field and P8's proven field are the same term by construction. Anchor `history` to a canonical append-only log head rather than an unconstrained `List EpInput` (this last part addresses the L-2 seam too, and we welcome it).

### R2-03 — Layer 0 Boolean resets a stale episode — **ACCEPT IN PART**

**The trace is real.** `estep .hold` sends `layer0 = true` to `.idle` unconditionally (`:655-658`), and `estep .idle` sends `issue = true` to `.pending 0` with no novelty check (`:649-650`); so `hold --(layer0)--> idle --(issue)--> pending 0` restarts a full clock with `novel = false` throughout. E8 is pointwise over direct transitions from exhausted states and E1 explicitly excludes spans containing a Layer 0 output, so neither forbids this two-step path.

**Where we push back on framing.** The brief's actual claim is narrower than "no stale restart": it says "genuinely new evidence — **not the mere persistence of the alarm** — can restart a full [PIO]" (l.60), and that is exactly E8/`exceedance_cannot_restart`, which is true. The reviewer's path restarts not through persistence but through a *Layer 0 review output* followed by a fresh issuance. A Layer 0 output is a mandatory, substantive human review — the constitutional resolver of a hold (E6) — not a free reset bit; returning to `idle` after review is by design.

**What we accept.** The reviewer is nonetheless right that `layer0 : Bool` cannot distinguish "resume ordinary posture," "continue the hold," "hand off to Tier 1," and "authorize a new episode," and that collapsing them loses information the constitution cares about.

**Planned repair.** Replace `layer0 : Bool` with a typed `Layer0Disposition`, and route to a *distinct* post-review state rather than undifferentiated `idle`, so that a subsequent full PIO requires either a fresh evidence token or a disposition that explicitly authorizes (and records the basis of) a new episode. We will also soften the brief so it does not read as a blanket "only new evidence restarts."

### R2-04 — the four D-R4 fields may be the same atom — **ACCEPT IN PART (severity: Low)**

**Factually correct:** `PIOEvent`'s `basisClaim`, `noveltyClaim`, `budgetClaim` and the inherited `falsifier` are all of abstract type `Claim` with only `∈ critical` obligations (`:349-355`); nothing prevents one atom from filling all four roles, in which case P7 proves the same membership four times.

**Why we contest the "High" severity.** *What* each field says is content, and content is the declared seam ("WHAT the basis or novelty claims say is at the seam, as always"). The residue that genuinely survives the seam is narrow: the *distinctness/existence of four roles* is a structural property, not a content property, and it is currently untyped.

**Planned repair (proportionate).** Introduce role-tagged claims (or a composite `PIOClaim` whose type carries all four components) and prove each mandatory role is represented. This is a small, bounded change; we will make it alongside R2-02, since both want a typed PIO claim language. We will not describe the current state as proving "four fields exist."

### R2-05 — exceedance proves one honest witness, not consensus — **ACCEPT (narrow the claim)**

**The proof is sound and the finding is fair.** `exceedanceCertified` is `f + 1 ≤ countGE θ` (`ExceedanceBridge.lean:66-67`) and X1 delivers *one* honest witness via `exists_honest_ge`. The reviewer's `f = 1` witness (corrupt 100, honest 100, honest 0, honest 0, θ = 50) certifies with two of three honest sensors below threshold — reproduced. And `threshold : Nat` is an unconstrained field of `SensorHour` (`:55-61`), so the bridge relocates the free input rather than eliminating it.

The kernel's own doc-comments are careful here ("not forgeable by corrupted sensors alone," X2). The overreach is in the **brief's adjectives**: "corruption-resistant measurements" (l.82), the X3 gloss "honest **sensors corroborate** the danger" (l.314, plural — the proof yields a single witness), and "this closes the emergency loop's **last free input**" (l.318, when the threshold remains free).

**Planned repair.** Narrow the brief to state the proven property precisely: *non-fabrication / one guaranteed honest witness*, not "consensus" or "corroboration," and drop "closes the last free input." **Optional stronger fix** (which we are inclined toward): derive exceedance from `median_bracketed` (B3) — which *is* the robust-aggregate result already in `SensorsAndKernel.lean:190-198` — and bind `threshold` to a fixed, versioned, publicly-attested configuration, then state the honest-corroboration level quantitatively. The stronger property exists in the codebase; the bridge simply does not use it yet.

### R2-06 — the continuity-hold is unbounded — **ACCEPT IN PART**

**Correct and worth acting on.** `EpState.hold` carries no clock (`:618-623`); `hold_persists` (`:893-896`) keeps the subgraph in `hold` for as long as exceedance continues with no Layer 0 output, and E6 makes `layer0` the *only* exit. Unlike the full PIO, which auto-resolves at 72h (T8/`pio_resolves`), the hold has no forced deadline. "Reversible per action" (E9) is indeed not "reversible under unbounded iteration," and repeated reversible restrictions can compound into irreversible deprivation.

**Planned repair.** Give the hold a time budget with a mandatory periodic Layer 0 review (mirroring T8's structure and Module 2's cap → Structural Review pattern), so an unresolved hold cannot persist indefinitely without a forced constitutional checkpoint. We will not claim cumulative-trajectory viability without a theorem to back it.

### R2-07 — certificate predicates are not compositional — **ACCEPT IN PART**

**Correct.** `Envelope` is two pointwise predicates `routeInside, sevInside : δ → Bool` (`:994-996`); the W-family reasons about single actions. Nothing requires monotonicity, cumulative accounting, or safety over sequences, so N individually-certified actions may jointly cross a threshold. As the reviewer grants, `δ` *can* voluntarily encode exposure history, but the kernel does not require it, so the guarantee rests on an unstated deployment convention.

**Planned repair.** Add an explicit compositionality obligation — a resource-indexed / state-transition envelope where authorization depends on current exposure and yields a new exposure state — and a theorem over finite action traces. We scope this as a v0.8+ item; it is the largest of the accepted changes.

### R2-08 — "non-critical" does not imply "harmless" — **ACCEPT (narrow the claim)**

**Correct as a naming critique.** `residual_divergence_harmless` (`:256-261`) proves a divergent claim is genuine and `∉ e.critical` — i.e., the event constructor did not *label* it critical. There is no completeness obligation that `critical` captures every material finding, so "harmless" overstates "unlabelled." A misclassified material finding would be called "harmless" by the theorem.

**Planned repair.** Rename the gloss to what it proves (e.g. "residual divergence is confined to non-critical-labelled content") and add, as a stated modeling assumption, the completeness obligation on the critical classification — or a typed findings-vs-framing distinction — rather than implying it.

### R2-09 — Axiom II is a definitional dichotomy — **ACCEPT (narrow the claim)**

**Correct.** `axiomII_dichotomy` (`CrisisCap.lean:387-397`) is the totality/exclusivity of `≤` vs `<` on `Nat` (`Nat.lt_or_ge` + `omega`). It is true but carries no constitutional consequence: it does not show terminality is detected, iteration halts, authority changes mode, or a remedy issues. Calling it "the machine-checked content of Axiom II" oversells it.

**Planned repair.** Either reframe A2a honestly as a well-formedness lemma, or — preferably — add the operational theorem the reviewer asks for: connect `locallyTerminal` to a prohibited transition or a mandatory structural-review handoff, so Axiom II has verified teeth.

### R2-10 — crisis-cap not bridged to evidence; constants generic — **CLARIFY / boundary (+ optional Lean)**

**Accurate observations, partly by design.** `dayStep` grants an emergency day on `requested ∧ window has room` (`:434-440`) without requiring `exceedance` or a PIO/Module-1 authorization; `exceedance` only forces review at saturation. `Cap` admits any `Tcap < W` (`:122-125`); the spec's `W = 730, Tcap = 180` live only in comments.

The module boundary is intentional — Module 2 bounds the *frequency* of emergency authority; *whether* a given day was evidence-authorized is Module 1's job — but the reviewer is right that a "kernel" should either bridge the two or say plainly that it doesn't. **Planned action:** state the boundary explicitly in the brief, and add (optional, low-cost) a concrete audited `Cap` instance with the constitutional constants and, if tractable, a bridge lemma that each `requested` day carried a Module-1 authorization.

### R2-11 — `ShippedTripartite` assumes compliance — **CLARIFY**

**Correct and largely already our position.** `ShippedTripartite` (`:433-437`) extends `Tripartite` with `civic_compliant`/`tech_compliant` as hypotheses; there is no publication event or ordering among release hours, and both later records may carry `releaseHour = 0`. The theorems are sound *conditional* statements (postconditions of an attested shipped release), not a verified publication workflow. **Planned action:** describe P10–P13 in the brief explicitly as postconditions of an externally-attested shipped release, and (optional) add a release-ordering obligation so the timeline is modelled rather than assumed.

### R2-12 — packet not self-contained for faithfulness review — **ACCEPT**

Correct: AHC v3.1 and Companion A are not in the circulation packet, and there is no quotation-level theorem-to-text map with source digests, so the brief's F-1 faithfulness question cannot be answered in the strict sense. **Planned action:** include the normative sources (or pinned excerpts) with version hashes and a theorem-to-sentence map in the next circulation.

---

## Documentation, audit, and packaging — **ACCEPT (all)**

Verified against the tree:

1. **README self-contradiction — confirmed.** The overview says "thirty-six of the eighty-one audited theorems" (`ahc-verified-kernel/README.md:24-26`); the build section says 89 audited / 40 axiom-free (`:174-176`). The actual `#print axioms` count in `Audit.lean` is **89**. The "81/36" figures are stale. → correct to 89/40.
2. **Broken doc paths — confirmed.** README references `../docs/ERRATA_AND_AMENDMENTS.md` and `../docs/MANIFEST_v0.7.txt` (`:10-11`); both exist in the repo `docs/` but not inside the circulation packet. → ship them in the packet or fix the paths.
3. **Manifest brief version mismatch.** `MANIFEST.txt` naming the v0.5 brief while the packet carries v0.7 → update.
4. **PDF appendix "additional to the 81" vs 89 on the same page** → reconcile to 89.
5. **Digest binds bytes, not filenames/boundaries, and excludes CI** → move to a conventional checksums manifest or a deterministic archive hash.
6. **No signed CI log / commit id / provenance** binding the supplied bytes to the bytes that passed CI → add a provenance attestation.
7. **CI bootstrap not fully pinned** (latest elan installer, mutable action tags) → pin the elan installer and action SHAs.

These do not bear on soundness but they do undercut the audit posture, and we will clear all seven before the next circulation.

---

## What we are changing, in priority order

1. **Fix the README/manifest/PDF number contradictions and doc paths** (immediate; no proof risk).
2. **Close R2-02 and R2-04** together with a typed PIO claim language: `BudgetAttestation` inside `PIOEvent`, published claim defined from it, role-tagged fields.
3. **Close R2-01** by lifting PIO and hold authorization onto `CAction`/`Envelope` and proving certificate-backing; quarantine the `Mech` table as the labelled presumptive floor.
4. **Bound the continuity-hold (R2-06)** with a time budget + mandatory periodic review.
5. **Type the Layer 0 disposition (R2-03)** and stop resetting to undifferentiated `idle`.
6. **Narrow the brief language (R2-05, R2-08, R2-09, R2-11)** to match the proven propositions; optionally derive exceedance from `median_bracketed` and pin the threshold.
7. **Compositional envelopes and finite-trace safety (R2-07)** and the Axiom-II operational theorem (R2-09) — larger, scheduled for v0.8+.
8. **Provenance and self-containment (R2-10 constants, R2-12)** for the next circulation.

We do not accept the aggregate framing that the plain-language guarantees are unverified — most of them are, and the review confirms the proofs are real. We do accept that the *certificate* and *budget-disclosure* guarantees, as worded, presently claim more than the integrated model discharges, and that the fix is to close the two internal interfaces (R2-01, R2-02) and narrow the remaining prose to the propositions actually proved.
