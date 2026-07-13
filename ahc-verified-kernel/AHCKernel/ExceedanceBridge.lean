/-
  AHC Verified Constitutional Kernel — Bridge module
  Exceedance Derivation: Module 1 × Module 3  (§5.4 × §8.3)

  The episode machine (Module 1) consumes `exceedance` — the raw hazard
  signal that sustains a continuity-hold — as a free Boolean input. This
  module DERIVES it from the measurement layer (Module 3), grounding
  the alarm bit in sensor readings (reviewer solicitation F-4).

  A certified exceedance requires at least f+1 sensors reporting at or
  above the danger threshold. By the pigeonhole core B2
  (`exists_honest_ge`), any such quorum contains an honest sensor — so a
  derived exceedance is always witnessed by AT LEAST ONE honest
  measurement. The property proved is ONE-HONEST-WITNESS
  NON-FABRICATION, not consensus (v0.11 gloss narrowing, finding
  R2-05): an f+1 quorum can be met by the corrupt coalition plus a
  single honest outlier while most honest sensors read below threshold,
  and the danger threshold θ itself remains a free per-hour input that
  a deployment must bind to a fixed, versioned, publicly attested
  configuration — binding θ, and deriving exceedance from a robust
  aggregate (B3 `median_bracketed` is the in-kernel candidate), are the
  named strengthening candidates. What IS proved: a captured minority
  of at most f sensors can neither

    · fabricate the exceedance that would sustain a continuity-hold
      (X4 `manufactured_danger_cannot_sustain_hold`), nor
    · stand as the sole basis of any exceedance the machine acts on
      (X1 `derived_exceedance_honest_witnessed`,
       X2 `derived_exceedance_not_forgeable`).

  X3 `hold_sustained_only_by_witnessed_danger` is the direct
  Module 1 × Module 3 statement: whenever the episode machine keeps a
  subgraph in protective hold on a derived input, at least one honest
  sensor witnesses the danger.

  Modeling choices (per the framework's norm):
  · A `SensorHour` carries the ensemble and danger threshold that DERIVE
    the exceedance bit, alongside the remaining episode inputs (issue,
    confirm, novel, layer0), which stay institutional / Layer 0 signals.
  · "Certified exceedance" is the f+1-quorum reading: it is the weakest
    threshold at which B2 guarantees an honest witness — and only that.
    It does not guarantee that honest sensors generally corroborate the
    alarm, nor that a robust aggregate exceeds θ. A deployment may
    require a stronger quorum; the honest-witness guarantee is monotone
    in that choice.
  · The danger threshold θ is carried per `SensorHour` and is NOT fixed
    by the kernel across time or bound to a policy version: a system
    able to lower θ can raise the alarm without corrupting any sensor.
    Binding θ institutionally is a deployment obligation (R2-05).
  · Honesty remains a ghost variable (Module 3): the theorems quantify
    over all placements of at most f corrupted sensors via the ensemble's
    `faultBound`.

  Scope disclaimer: these proofs verify the specification, not the world.
  Whether the sensors are in fact independent (the ≤ f fault bound) is an
  institutional achievement (OP.1), not a theorem.

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-13 (v0.11).
-/
import AHCKernel.TieredProtocol
import AHCKernel.SensorsAndKernel

namespace AHC

/-- A sensor-grounded hour of episode input: the ensemble and danger
    threshold that DERIVE the exceedance bit, plus the remaining episode
    inputs, which stay institutional / Layer 0 signals. -/
structure SensorHour (f : Nat) where
  ensemble  : Ensemble f
  threshold : Nat     -- danger threshold θ
  issue   : Bool
  confirm : Bool
  novel   : Bool
  layer0  : Option Layer0Disposition

/-- Certified exceedance: at least f+1 sensors report at or above the
    danger threshold θ — the weakest quorum at which B2 guarantees an
    honest witness. -/
def SensorHour.exceedanceCertified {f : Nat} (s : SensorHour f) : Prop :=
  f + 1 ≤ countGE s.threshold s.ensemble.sensors

instance {f : Nat} (s : SensorHour f) : Decidable s.exceedanceCertified :=
  inferInstanceAs (Decidable (_ ≤ _))

/-- The derived exceedance bit. -/
def SensorHour.exceedance {f : Nat} (s : SensorHour f) : Bool :=
  decide s.exceedanceCertified

/-- The episode input this sensor-hour derives: the exceedance bit comes
    from the ensemble; every other field is passed through. -/
def SensorHour.toEpInput {f : Nat} (s : SensorHour f) : EpInput :=
  { issue := s.issue, confirm := s.confirm, novel := s.novel,
    exceedance := s.exceedance, layer0 := s.layer0 }

/-- **X1 (Derived Exceedance Is Honest-Witnessed).** A certified
    exceedance always has an honest sensor reporting at or above the
    danger threshold: the hazard signal the machine acts on is never a
    pure fabrication of the corrupted coalition. -/
theorem derived_exceedance_honest_witnessed {f : Nat} (s : SensorHour f)
    (h : s.exceedance = true) :
    ∃ sen, sen ∈ s.ensemble.sensors ∧ sen.2 = true ∧ s.threshold ≤ sen.1 := by
  rw [SensorHour.exceedance] at h
  exact exists_honest_ge f s.ensemble s.threshold (of_decide_eq_true h)

/-- **X2 (Exceedance Is Not Forgeable).** If every honest sensor reads
    below the danger threshold, exceedance cannot be certified: a
    captured minority of at most f sensors, reporting anything, cannot
    raise the hazard signal on its own. -/
theorem derived_exceedance_not_forgeable {f : Nat} (s : SensorHour f)
    (hhonest : ∀ sen ∈ s.ensemble.sensors, sen.2 = true → sen.1 < s.threshold) :
    s.exceedance = false := by
  rw [SensorHour.exceedance, decide_eq_false_iff_not]
  intro hc
  obtain ⟨sen, hmem, hh, hge⟩ := exists_honest_ge f s.ensemble s.threshold hc
  have hlt := hhonest sen hmem hh
  omega

/-- **X3 (The Hold Is Sustained Only by Witnessed Danger).** The direct
    Module 1 × Module 3 guarantee: whenever the episode machine keeps a
    subgraph in a continuity-hold on a derived input (no disposition,
    no novel filing), AT LEAST ONE honest sensor reports the danger.
    One-honest-witness non-fabrication — not majority corroboration:
    protective authority cannot rest on corrupted sensors alone. -/
theorem hold_sustained_only_by_witnessed_danger {f : Nat} (s : SensorHour f)
    (k k' : Nat)
    (hl : s.layer0 = none) (hni : (s.novel && s.issue) = false)
    (hhold : estep (.hold k) s.toEpInput = .hold k') :
    ∃ sen, sen ∈ s.ensemble.sensors ∧ sen.2 = true ∧ s.threshold ≤ sen.1 := by
  cases hx : s.exceedance with
  | true => exact derived_exceedance_honest_witnessed s hx
  | false =>
      exfalso
      have hspent : estep (.hold k) s.toEpInput = .spent := by
        by_cases hd : k + 1 < holdReviewDeadline <;>
          simp [estep, SensorHour.toEpInput, hl, hni, hx, hd]
      rw [hspent] at hhold
      exact EpState.noConfusion hhold

/-- **X4 (Manufactured Danger Cannot Sustain a Hold).** The dual of X3:
    if every honest sensor reads below the danger threshold, the episode
    machine drops the subgraph out of the continuity-hold to `spent` —
    at any clock value, before or at the review deadline. A captured
    minority cannot keep a community under protective authority by
    fabricating an alarm — the laundering path, closed at the
    measurement layer. -/
theorem manufactured_danger_cannot_sustain_hold {f : Nat} (s : SensorHour f)
    (k : Nat)
    (hl : s.layer0 = none) (hni : (s.novel && s.issue) = false)
    (hhonest : ∀ sen ∈ s.ensemble.sensors, sen.2 = true → sen.1 < s.threshold) :
    estep (.hold k) s.toEpInput = .spent := by
  have hx : s.exceedance = false := derived_exceedance_not_forgeable s hhonest
  by_cases hd : k + 1 < holdReviewDeadline <;>
    simp [estep, SensorHour.toEpInput, hl, hni, hx, hd]

end AHC
