/-
  Axiom audit for the Phase 2 drafts, mirroring the kernel's discipline:
  building this module prints the axiom dependencies of every draft
  theorem. Expected: at most [propext, Quot.sound]; never
  Classical.choice; a sorry would surface as sorryAx.
-/
import Phase2Drafts.PIOReissuance

open AHC.Phase2

-- PIO re-issuance guard (§5.4; finding AHC-P1-003, awaiting D-class ruling)
#print axioms pendingHours_confirmed
#print axioms pendingHours_spent
#print axioms pendingHours_pending
#print axioms issuances_zero_of_ne_idle
#print axioms reissue_needs_new_evidence
#print axioms pio_no_relitigation
