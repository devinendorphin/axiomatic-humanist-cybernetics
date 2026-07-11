/-
  Axiom audit for the Phase 2 drafts, mirroring the Phase 1 kernel's
  discipline: building this module prints the axiom dependencies of every
  draft theorem. Expected: at most [propext, Quot.sound]; never
  Classical.choice; a sorry would surface as sorryAx.
-/
import Phase2Drafts.Hysteresis
import Phase2Drafts.CrisisCapComposition
import Phase2Drafts.PIOReissuance

open AHC.Phase2

-- Hysteresis: temporal anti-chatter (§9.2; finding AHC-P1-002)
#print axioms oscillation_travel
#print axioms flip_anchored
#print axioms travel_reanchor
#print axioms flips_travel_anchored
#print axioms chatter_requires_travel

-- Crisis Cap × Structural Review, composed (§12.3; finding AHC-P1-001)
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

-- PIO re-issuance guard (§5.4; finding AHC-P1-003)
#print axioms pendingHours_confirmed
#print axioms pendingHours_spent
#print axioms pendingHours_pending
#print axioms issuances_zero_of_ne_idle
#print axioms reissue_needs_new_evidence
#print axioms pio_no_relitigation
