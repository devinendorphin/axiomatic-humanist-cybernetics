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
-- Episode machine: PIO with two clocks (E1-E11, adopted v0.4; ruling D-R1A + D-R4)
#print axioms epPendingHours_exhausted
#print axioms epIssuances_exhausted
#print axioms epPendingHours_pending
#print axioms epIssuances_pending_zero
#print axioms episode_no_relitigation
#print axioms episode_single_issuance
#print axioms expiry_routes_by_risk
#print axioms reonset_refloors
#print axioms hold_persists
#print axioms hold_resolution_iff
#print axioms novel_restart_from_spent
#print axioms novel_restart_from_hold
#print axioms exceedance_cannot_restart
#print axioms hold_floor_reversible
#print axioms hold_floor_severity
#print axioms hold_grants_no_more_than_pio
-- Certified reversibility envelopes (W1-W9, adopted v0.4; rulings D-R2A + D-R3)
#print axioms cert_tier_monotone
#print axioms cert_severity_le_evidence
#print axioms cert_sub_causal_reversible
#print axioms cert_irreversible_iff_causal
#print axioms uncertified_routing_needs_causal
#print axioms uncertified_severance_needs_causal
#print axioms certified_route_at_t1
#print axioms certified_severance_at_t2
#print axioms cert_refinement_conservative
#print axioms no_certificate_no_presumption
#print axioms zero_envelope_constructible

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
-- D-R4 disclosures (P7-P9, adopted v0.5; ruling D-R4)
#print axioms AHC.PLOL.pio_disclosure_at_breach
#print axioms AHC.PLOL.pio_disclosure_divergence_convicts
#print axioms AHC.PLOL.attested_budget_accurate
#print axioms AHC.PLOL.attested_budget_bounded
