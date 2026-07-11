# Phase 1 Assessment — AHC Verified Constitutional Kernel

**Artifact:** Phase 1 Circulation Packet v0.1 (2026-07-11) — `ahc-verified-kernel/` + `docs/AHC_VerifiedKernel_Phase1_Brief.docx`
**Assessment date:** 2026-07-11
**Method:** independent reproduction (source-integrity check, clean build on the pinned toolchain, mechanical audit of every published claim), followed by line-by-line review of all four modules against the brief's theorem–specification map, answering the Part III solicitations (F-1..F-4, D-1..D-4, L-1..L-3).

---

## 1. Verification results — every published claim reproduces

| Claim (MANIFEST / Brief / README) | Measured | Verdict |
|---|---|---|
| Source digest `2b51cac67e278c54003bbf2d5974da19d581caeaa4bc6f3f8f23043cffea7609` (sha256 over sorted `*.lean`, `lakefile.toml`, `lean-toolchain`) | `2b51cac6…ea7609` | ✅ match |
| Builds with Lean 4.15.0, core only, no Mathlib, no external deps | `lake build` succeeds; `lake-manifest.json` packages: `[]` | ✅ |
| Zero `sorry`s | `sorryAx` occurrences in audit log: **0**; no `sorry`/`axiom`/`native_decide` in source | ✅ |
| No theorem depends on `Classical.choice` | occurrences in audit log: **0** | ✅ |
| Total axiom footprint ≤ `[propext, Quot.sound]` | 12 theorems `[propext, Quot.sound]`, 1 theorem `[propext]`, 22 axiom-free, nothing else | ✅ |
| "22 of 34 theorems depend on no axioms at all" | **22** axiom-free of **35** audited declarations (see AHC-P1-006 on the 34 vs 35 bookkeeping) | ✅ with a bookkeeping note |
| "including all nine PLOL theorems" | all 9 audited `AHC.PLOL.*` theorems axiom-free | ✅ |
| README's 13-name axiom-free list for Modules 1–3 | exactly those 13 | ✅ |

Full audit output: [`docs/phase1-build-audit.log`](docs/phase1-build-audit.log). The brief's docx in `docs/` is byte-identical (sha256) to the one inside the circulation zip.

**Bottom line:** the artifact is what it says it is. All 34/35 declared theorems elaborate; the axiom discipline is real and unusually clean; the packet's headline numbers are reproducible by exactly the one command it advertises. The kernel directory in this repo is byte-identical to the circulated packet, so the MANIFEST digest remains checkable against it.

---

## 2. Findings

Findings are numbered `AHC-P1-nnn`, tagged with the Part III class they answer, and dispositioned per the brief's own routing rules ("Disposition of findings"). None of the findings below breaks a proof: **no F-class finding against a theorem was found.** The substantive findings are all at the translation surface the brief solicits attack on.

### AHC-P1-001 · F-2 / D-1 · **Medium** — Module 2's two formalisms never compose

The Crisis Cap is proved over `Valid : Cap → List Bool → Prop` traces; the Structural Review gate is proved over a separate `Mode`/`Event` automaton (`modeStep`, `grants`). **No theorem connects them.** In particular:

- Nothing forces a `capTrip` event to occur when a trace's window load reaches `T_cap` under continued exceedance — the automaton's trigger is an unmodeled input.
- Nothing forbids a trace from continuing to accrue `true` (emergency) days while the automaton sits in `structuralReview`. `grants` and `Valid.emergency` are unrelated judgments; a history can satisfy `Valid` day-by-day while the mode automaton would deny every grant.

So the integrated guarantee the brief's Part I sentence promises — *"once the cap trips, only a full constitutional review … can restore emergency powers"* — is verified in two halves that are never joined. C1–C3 verify the arithmetic half; C4–C6 verify the automaton half; the conjunction is asserted by prose, not by Lean. This is exactly the F-2 "gaming path through the interaction" question, and the answer is: the interaction is currently unverified, so gaming it cannot be excluded *by the kernel*.

**Disposition:** strengthening candidate (F-4). A combined semantics is order-theoretic enough to join the kernel: a product state `(Mode × List Bool)`, one step function consuming one `Event` per day, with `capTrip` *derived* (fires iff `load W trace ≥ T_cap` ∧ exceedance flag) rather than free, and the theorem *"in `structuralReview`, no reachable successor extends the trace with `true`."* This adds no new specification — it verifies the sentence of §12.3 the two halves already target — so it should survive Principle 19.2. Deliberately **not** added to the kernel here, to keep the circulated packet byte-stable under its published digest; route to Phase 2. **Drafted, machine-checked, and — per the 2026-07-11 addendum below — adopted into kernel v0.2:** [`ahc-verified-kernel/AHCKernel/CrisisCap.lean`](ahc-verified-kernel/AHCKernel/CrisisCap.lean) (theorems G1–G7). **Resolved.**

### AHC-P1-002 · F-1 · **Medium** — T9 `no_chatter` verifies less than the hysteresis intent

As formalized, `escalates p A ≡ Astar < A` and `deescalates p A ≡ A < Areset` are mutually exclusive *at a single instant, for a single value `A`*. Two observations:

1. The proof needs only `Areset ≤ Astar`; the constitutive **strict** gap does no work in T9 beyond that. A zero-width band (`Areset = Astar`, unconstructible here but the point stands) would satisfy the same instantaneous exclusivity.
2. The behavior hysteresis exists to prevent is **temporal**: a signal oscillating `Astar+ε, Areset−ε, Astar+ε, …` flips escalate/de-escalate on alternate steps. That system exhibits maximal chatter while satisfying T9 at every instant. A behavior that satisfies the Lean model while violating the English intent is precisely the brief's definition of the strongest F-1 finding.

T9 is true and worth having (it rules out *simultaneous* contradictory directives), but the module summary's gloss — "makes single-signal panic **cycling** logically impossible" — overstates what was proved. Cycling is a property of trajectories, and there are no trajectories in T9.

**Disposition:** strengthening candidate (F-4), one theorem: for any escalation at time *i* (`Astar < A_i`) and any de-escalation at time *j* (`A_j < Areset`), `A_i − A_j > Astar − Areset` — i.e. **each oscillation costs signal travel exceeding the gap width**, so N oscillations require total variation > N·gap. That is the honest formal content of hysteresis (chatter requires large real swings, not noise), it is core-`omega` provable, and it makes the gap field load-bearing. Also route a one-word edit: "cycling" → "simultaneous escalate/de-escalate" in the T9 gloss until the stronger theorem lands. **Drafted, machine-checked, and — per the 2026-07-11 addendum below — adopted into kernel v0.2:** [`ahc-verified-kernel/AHCKernel/TieredProtocol.lean`](ahc-verified-kernel/AHCKernel/TieredProtocol.lean) (S1 pointwise; S2 anchored machine bound; S3 headline `(flips − 1)·(gapWidth+1) ≤ total variation`), with the T9 gloss corrected. **Resolved.**

### AHC-P1-003 · F-3 · **Low** — PIO discretization: two benign losses, one worth stating

- **Mid-hour confirmation:** within the deadline hour, `pioStep` gives confirmation priority over expiry (`.issued 71` + `confirm=true` → `.confirmed`, even though `71+1 = 72`). This is the generous-to-confirmation reading of "within 72 hours"; it is defensible but is a modeling choice not listed in Part II.F — add it to the disclosures.
- **Concurrent PIOs:** the machine is single-instance. Two overlapping PIOs for one subgraph (e.g. re-issue at hour 71 to reset the clock) are unrepresentable, so the kernel cannot yet refute the *re-issuance laundering* path: reversal at hour 72 followed by immediate re-issue on the same evidence. §5.4's English plausibly forbids it; the model neither forbids nor exhibits it.

**Disposition:** the re-issuance question routes as F-4 (a `List PIO`-per-subgraph machine with a no-refresh-without-new-evidence side condition is order-theoretic enough); the confirmation-priority note routes as a Part II.F disclosure amendment. **Drafted and machine-checked** (contingent on the D-class ruling on the guard condition): [`phase2-drafts/Phase2Drafts/PIOReissuance.lean`](phase2-drafts/Phase2Drafts/PIOReissuance.lean) (R1 total unconfirmed protection ≤ 72h without new evidence; R2 at most one issuance).

### AHC-P1-004 · D-4 · **Low** — bracketing bounds position, not displacement

`median_bracketed` proves a captured minority cannot drag a median-type statistic *outside the honest envelope* `[min honest, max honest]`. It does not bound displacement *within* the envelope: f corrupted sensors placed at an honest extreme still shift the median toward that extreme. This is inherent to f-robustness (no estimator does better without distributional assumptions) and is not a defect — but ATG threshold derivations downstream should not read B3 as "thresholds are unaffected by capture," only as "thresholds remain inside honest measurement." Also per the brief's own D-4: trimmed means are *not* covered unless their counting property (≥ ⌈m/2⌉ on each side) is separately established — for heavily trimmed means it holds; for lightly trimmed means it does not in general.

**Disposition:** documentation note to Companion B / ATG derivation; no kernel change.

### AHC-P1-005 · D-2 · **Note** — the reversibility table is definitional, and says so

`Mech.reversible` marks M1/M2 reversible *by fiat*; T3/T7's guarantees are exactly as strong as that classification. If any deployment scenario makes graduated capital routing (M1) or severance (M2) effectively irreversible (insolvency cascades, network partition with state divergence), the theorems are vacuously satisfied while the English intent is violated. The brief already names the one-line amendment site (`requiredTier` / `Mech.reversible`); this assessment concurs and has nothing to add beyond: the classification is the single highest-leverage row in the kernel for domain reviewers to attack, because every Module 1 guarantee flows through it.

### AHC-P1-006 · Accounting · **Info** — "34 theorems" vs 35 audited declarations

The audit log contains **35** `#print axioms` results. The brief's "34" counts table rows: `exists_honest_le`/`_ge` share one row (B2), `decCompliant` is counted as a theorem row (it is a `Decidable` instance — verified by elaboration, not auditable by `#print axioms`), and `scr_no_fabrication` (audited, axiom-free) appears in no table. Nothing is wrong, but a packet whose thesis is that plain-language and technical registers must agree on the contestation-critical fragment should make its own counts register-invariant. Suggest Phase 2 docs enumerate: *35 audited theorems + 1 verified instance; 22 of 35 axiom-free.*

### AHC-P1-007 · CI · **High (fixed here)** — the circulated workflow could pass on a failed build

`ahc-verified-kernel/.github/workflows/ci.yml` runs `lake build 2>&1 | tee build.log` in an Actions `run:` step **without explicit `shell: bash`**. Actions' implicit default is `bash -e {0}` *without* `pipefail`, so the step's status is `tee`'s (always 0): **a completely failed build passes the step**, and the subsequent guard greps only for `sorryAx`, which a failed build does not contain. Net effect: the circulated CI can go green on a kernel that does not compile — the exact inversion of the packet's purpose.

**Fix applied:** root-level [`.github/workflows/verify.yml`](.github/workflows/verify.yml) with (a) explicit `shell: bash` (Actions then adds `-o pipefail`), (b) `working-directory: ahc-verified-kernel` so it runs from this repo's layout, (c) the sorry guard, (d) new guards the circulated CI lacked: fail on `Classical.choice`, fail on any axiom set other than `[propext(, Quot.sound)]`, and assert the exact published footprint (35 audited / 22 axiom-free) so a theorem silently dropped from `Audit.lean` also fails. The nested `ci.yml` is retained untouched for packet fidelity (GitHub ignores workflows outside root `.github/`), but it should be patched upstream before the packet circulates further.

### AHC-P1-008 · Packaging · **Low (fixed here)** — layout and hygiene

The kernel lives in a subdirectory of this repo, so the packet-internal workflow would never run (addressed by AHC-P1-007's root workflow). Added `.gitignore` for `.lake/` build artifacts. `docs/` carries the MANIFEST, the brief, and the reproduced audit log as evidence.

---

## 3. Answers to the remaining Part III solicitations

**F-1 (faithfulness), remaining disclosures:** the strict off-by-one reading of the cap renewal (`load (W−1) t < T_cap` before adding the day) is correctly conservative — under it `window_head_bound` yields ≤ `T_cap` inclusive of the new day, and the permissive reading would allow `T_cap + 1`-day windows. The M4-at-every-tier reading (`requiredTier .m4 = .t0`) faithfully renders §9.3's broadcast asymmetry. `Ensemble.quorum` renders "m > 2f+1" exactly (`2*f+1 < length`). No divergence found beyond AHC-P1-002/003.

**D-1 (coverage):** Module 2 is the only module with a silently-omitted load-bearing guarantee (the composition, AHC-P1-001). Module 1's omission of *who may issue* a PIO and Module 4's omission of *claim-extraction correctness* are both declared, not silent.

**D-3 (window semantics):** keep the strict reading. It is the only reading under which C1's bound is `≤ T_cap` rather than `≤ T_cap + 1`, and the constitutional text's ambiguity should resolve toward the reading that makes the cap mean its own number.

**L-1 (reflexive PLOL compliance):** Part I of the brief genuinely carries the falsification pathway (one command, failure surfaces as `sorryAx`) and it functions for a non-expert — this reproduction followed exactly that pathway, plus the digest check, with no recourse to the authors. One gap: Part I nowhere states *where findings go* in plain language; the routing lives only in Part III's register. Under the packet's own P3 standard, if finding-routing is contestation-critical, its absence from the plain register is a B.4 problem. Suggest one plain-language sentence in Part I.

**L-2 (the seam's placement):** the placement is coherent and honestly disclosed, and `decCompliant` genuinely mechanizes everything downstream of extraction. But note what L-2 suspects is partially true: the burden moved to extraction is *adversarial* (a hostile publisher optimizes text against the extractor), and nothing in the architecture yet resources that asymmetry. This is correctly parked in the Open Problems Register; it should not be allowed to quietly become "communities run the extractor."

**L-3:** out of formal scope; concur with routing extraction tooling/Fund provision to a post-review Appendix B field.

---

## 4. Changes made in this repository

| Change | Path | Rationale |
|---|---|---|
| Installed circulation packet (kernel byte-identical to circulated digest) | `ahc-verified-kernel/` | requested install |
| Installed brief + MANIFEST + reproduced audit logs | `docs/` | provenance & evidence |
| Root CI workflow, hardened | `.github/workflows/verify.yml` | AHC-P1-007/008 |
| Build-artifact ignore | `.gitignore` | hygiene |
| This assessment | `ASSESSMENT.md` | requested analysis |
| Phase 2 strengthening drafts (21 machine-checked theorems answering AHC-P1-001/002/003) | `phase2-drafts/` | requested drafts; kernel untouched |

Kernel sources were deliberately **not** modified: every proof checks, so the only defensible in-kernel changes would be strengthenings (AHC-P1-001/002/003), and those belong to the packet's own Phase 2 amendment route — not silently inside a copy whose MANIFEST digest reviewers may still verify.

---

## 5. Overall assessment

As a *verified kernel*, the artifact is high quality: self-contained core-only Lean with a clean axiom story, honest and unusually explicit modeling disclosures, constitutive constraints as structure fields (degenerate parameterizations unconstructible), and a self-limiting claim discipline ("origin, not consistency"; "specification, not the world") that its own theorems then formalize — `bridge_proves_origin_not_consistency` proving the limits of its own integrity mechanism is the strongest single design choice in the packet.

The two findings that matter for Phase 2 are structural, not proofs: the **unjoined halves of Module 2** (AHC-P1-001) and the **temporal gap in T9** (AHC-P1-002). Both have small, Principle-19.2-compatible strengthenings sketched above. The one operational defect — CI capable of passing a failed build — is fixed in this repository and should be fixed upstream before further circulation, since the packet's entire trust argument routes through "the build would fail and say so."

---

## Addendum — kernel v0.2 (2026-07-11, post-assessment)

The findings above were assessed against the circulated v0.1 packet; the
body of this document is preserved as that record. Subsequently, per the
brief's own disposition routing:

- **Adopted into the kernel (v0.2):** the temporal-hysteresis family
  (AHC-P1-002 → S1–S3 in `TieredProtocol.lean`, T9 gloss corrected) and
  the composed cap × review semantics (AHC-P1-001 → G1–G7 in
  `CrisisCap.lean`). Kernel footprint is now **50 audited theorems, 24
  axiom-free**; new digest in [`docs/MANIFEST_v0.2.txt`](docs/MANIFEST_v0.2.txt).
- **Packet errata applied:** the nested `ci.yml` pipefail defect
  (AHC-P1-007) is fixed in place; brief amendments E3–E5 (Part II.F
  confirmation-priority disclosure, Part I plain-language finding
  routing, count normalization) are recorded in
  [`docs/ERRATA_AND_AMENDMENTS.md`](docs/ERRATA_AND_AMENDMENTS.md), the
  v0.1 docx being retained unmodified as the circulated artifact.
- **Still open:** AHC-P1-003 (PIO re-issuance guard, in
  [`phase2-drafts/`](phase2-drafts/), awaiting the D-class ruling on
  whether auto-reversal consumes its evidence), AHC-P1-004 (trimmed-mean
  counting property, deployment-conditional), AHC-P1-005 / D-2 (the
  reversibility classification — a domain judgment, the highest-leverage
  open review item), and the declared non-goals (statistical layer,
  viability dynamics, Layer 0 extraction tooling).

Statements in the body such as "kernel sources were deliberately not
modified" and "byte-identical to the circulated packet" were true of the
assessment date and remain true of the v0.1 record (git commit `ffed6c1`,
digest `2b51cac6…ea7609`); they are superseded for the current tree by
this addendum.
