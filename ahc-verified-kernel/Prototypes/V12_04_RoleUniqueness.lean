/-
  PROTOTYPE — repair for finding V12-04 (v0.12 multi-lens external review).
  NOT part of the audited kernel; NOT counted in Audit.lean.

  Finding V12-04, two halves:
   (a) P14 ("one sentence cannot fill two roles") proves only that the
       ROLE CONSTRUCTORS differ; the three underlying `Claim` bodies of a
       `PIOEvent` may be the SAME sentence copied three times.
   (b) `budget_unique` constrains only the CRITICAL set: a compliant record
       may carry the accurate `budget 72` (critical) AND a contradictory
       `budget 0` (a genuine but noncritical event claim).

  Repair: a `StrictPIOEvent` wraps a `PIOEvent` with two extra obligations
  the type system can already enforce — global budget uniqueness over the
  WHOLE claim set, and content-level distinctness of the three role bodies.
  Then: no contradictory budget claim anywhere, and one sentence cannot
  fill two roles at the level of content, not merely of label.
-/
import AHCKernel.PLOL

namespace AHC.Proto
open AHC

/-- A structured disclosure-role body (the recommended payload shape): a
    role claim should carry incident identity, evidence lineage, a decision
    rule, and a falsification test — not an arbitrary sentence. Two bodies
    with distinct incident identities are distinct, so structured payloads
    make role distinctness checkable without reading natural language.
    Included as the target body type; the theorems below use raw `Claim`
    distinctness so they apply to any body representation. -/
structure RoleBody (Claim : Type) where
  incident     : Nat
  lineage      : Nat
  decisionRule : Claim
  falsTest     : Claim

/-- A strengthened PIO disclosure event (repair for V12-04). It carries a
    `PIOEvent` plus two obligations:
    · `budget_unique_global` — ANY budget-role claim in the whole claim set
      carries the attested figure (not just those marked critical);
    · `bodies_distinct` — the three role bodies are pairwise distinct as
      content, so no single sentence can occupy two roles. -/
structure StrictPIOEvent (Claim : Type) where
  event : PIOEvent Claim
  budget_unique_global : ∀ h, PIOClaim.budget h ∈ event.toEvent.claims →
                           h = event.attestation.claimedHours
  bodies_distinct : event.basisBody ≠ event.noveltyBody ∧
                    event.basisBody ≠ event.falsifBody ∧
                    event.noveltyBody ≠ event.falsifBody

/-- **U1 (No Budget Drift Anywhere).** ANY budget-role claim in the whole
    event — critical or not — carries the machine's accounting figure. The
    noncritical-contradiction path of V12-04(b) is closed: a `budget 0`
    alongside the accurate figure is unconstructible, not merely
    unmarked-critical. Strictly stronger than the kernel's `budget_unique`,
    which quantifies only over the critical subset. -/
theorem strict_budget_no_drift_global {Claim : Type} (D : StrictPIOEvent Claim)
    (h : Nat) (hmem : PIOClaim.budget h ∈ D.event.toEvent.claims) :
    h = epPendingHours .idle D.event.attestation.history :=
  (D.budget_unique_global h hmem).trans D.event.attestation.accurate

/-- **U2 (One Sentence Cannot Fill Two Roles — in content).** The exact
    failure V12-04(a) exhibited — `basisBody = noveltyBody = falsifBody = c`
    — is unconstructible for a `StrictPIOEvent`: there is no single claim
    that fills all three role bodies. Where P14 ruled out identical
    CONSTRUCTORS, this rules out identical CONTENT. -/
theorem strict_no_single_sentence {Claim : Type} (D : StrictPIOEvent Claim) :
    ¬ ∃ c : Claim, D.event.basisBody = c ∧ D.event.noveltyBody = c ∧
        D.event.falsifBody = c := by
  rintro ⟨_, hb, hn, _⟩
  exact D.bodies_distinct.1 (hb.trans hn.symm)

end AHC.Proto
