/-
  AHC Verified Constitutional Kernel — root module.

  Importing this module elaborates and checks the entire kernel.
  The audit module re-verifies the axiom footprint of every named
  theorem at build time; its output appears in the build log.
-/
import AHCKernel.TieredProtocol
import AHCKernel.CrisisCap
import AHCKernel.SensorsAndKernel
import AHCKernel.PLOL
import AHCKernel.ExceedanceBridge
import AHCKernel.SeamLedger
import AHCKernel.Audit
