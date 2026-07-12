/-
  Axiom audit. Building this module prints the axiom dependencies of every
  named theorem in the kernel. Expected result: every theorem depends on at
  most `propext` and `Quot.sound` (standard Lean kernel axioms); none
  depends on `Classical.choice`; several depend on no axioms at all.

  A theorem listed here that acquires an unexpected axiom — or a `sorry`,
  which surfaces as the `sorryAx` axiom — will be visible in the build log.
-/
import AHCKernel.TieredProtocol
import AHCKernel.CrisisCap
import AHCKernel.SensorsAndKernel
import AHCKernel.PLOL

open AHC

-- Module 1: Tiered Evidence-Action Protocol (§5.4, §9.2–9.3)
#print axioms tier_monotone
#print axioms severity_le_evidence
#print axioms sub_causal_reversible
#print axioms irreversible_iff_causal
#print axioms broadcast_universal
#print axioms pio_ceiling
#print axioms pio_reversible
#print axioms pio_resolves
#print axioms no_chatter
-- Temporal hysteresis (S1-S3, adopted v0.2; finding AHC-P1-002)
#print axioms oscillation_travel
#print axioms flip_anchored
#print axioms travel_reanchor
#print axioms flips_travel_anchored
#print axioms chatter_requires_travel
-- PIO re-issuance guard (R1-R4, adopted v0.3; ruling D-R1, finding AHC-P1-003)
#print axioms pendingHours_confirmed
#print axioms pendingHours_spent
#print axioms pendingHours_pending
#print axioms issuances_zero_of_ne_idle
#print axioms reissue_needs_new_evidence
#print axioms pio_no_relitigation
#print axioms ongoing_attack_reprotects
#print axioms reissue_blocked_iff_stale
#print axioms freshness_consumed_not_banked
-- Regime-split capital routing (V1-V7, adopted v0.3; ruling D-R2, finding AHC-P1-005)
#print axioms action_tier_monotone
#print axioms action_severity_le_evidence
#print axioms action_sub_causal_reversible
#print axioms action_irreversible_iff_causal
#print axioms unbounded_routing_needs_causal
#print axioms bounded_routing_at_t1
#print axioms refinement_conservative

-- Module 2: Crisis Frequency Cap & Structural Review (§12.3); Axiom II (§4.2)
#print axioms window_head_bound
#print axioms rolling_window_bound
#print axioms no_permanent_emergency
#print axioms no_emergency_in_review
#print axioms review_absorbing
#print axioms review_gate
#print axioms axiomII_dichotomy
-- Composed cap x review semantics (G1-G7, adopted v0.2; finding AHC-P1-001)
#print axioms dayStep_valid
#print axioms dayRun_valid
#print axioms review_day_never_emergency
#print axioms review_exit_iff_output
#print axioms trip_forced
#print axioms review_run
#print axioms review_gate_composed
#print axioms emergency_day_provenance
#print axioms composed_cap_safety
#print axioms composed_no_permanent_emergency

-- Module 3: Byzantine Measurement Consensus (§8.3); Axiom I (§4.1, §1.1)
#print axioms honest_strict_majority
#print axioms exists_honest_le
#print axioms exists_honest_ge
#print axioms median_bracketed
#print axioms no_corrupt_certificate
#print axioms axiomI_null_kernel
#print axioms axiomI_no_compensation
#print axioms null_kernel_product
#print axioms globalSignal_pos_iff
#print axioms sum_admits_masking

-- Module 4: PLOL Register Invariance (§10.4; Companion A §5, §19.4, App. B)
#print axioms AHC.PLOL.hash_bridge_origin
#print axioms AHC.PLOL.bridge_proves_origin_not_consistency
#print axioms AHC.PLOL.compliant_registers_agree
#print axioms AHC.PLOL.divergence_convicts
#print axioms AHC.PLOL.residual_divergence_harmless
#print axioms AHC.PLOL.tripartite_single_origin
#print axioms AHC.PLOL.no_hostage
#print axioms AHC.PLOL.contestability_at_breach
#print axioms AHC.PLOL.scr_no_fabrication
