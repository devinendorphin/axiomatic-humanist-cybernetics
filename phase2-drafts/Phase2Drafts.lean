/-
  AHC Verified Constitutional Kernel — Phase 2 strengthening DRAFTS.

  Importing this module elaborates and checks every remaining draft
  theorem. The temporal-hysteresis and composed cap/review drafts were
  adopted into the kernel in v0.2 (see ../docs/ERRATA_AND_AMENDMENTS.md);
  what remains here is the PIO re-issuance guard, which is contingent on
  a D-class constitutional-interpretation ruling and therefore stays a
  draft until that ruling is made.
-/
import Phase2Drafts.PIOReissuance
import Phase2Drafts.Audit
