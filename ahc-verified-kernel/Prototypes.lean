/-
  AHC Verified Constitutional Kernel — PROTOTYPES root.

  These modules prototype the repairs prescribed by the v0.12 multi-lens
  external review (findings V12-01 … V12-06). They are DELIBERATELY
  SEPARATE from the audited kernel:

    · they are NOT imported by `AHCKernel.lean`, so `lake build` (the
      audited 116-theorem kernel and its axiom audit) is unaffected;
    · they are NOT counted in `AHCKernel/Audit.lean`;
    · they build under the `Prototypes` lean_lib target: `lake build
      Prototypes`.

  Each module states, in Lean, what the corresponding repair would buy —
  a target for folding into a future kernel version after review, not a
  claim that the repair is already adopted.
-/
import Prototypes.V12_01_TraceInterface
import Prototypes.V12_02_TypedIssuance
import Prototypes.V12_03_ConfirmedHandoff
import Prototypes.V12_04_RoleUniqueness
import Prototypes.V12_05_Separation
import Prototypes.V12_06_EnactedReview
