/-
  PROTOTYPE — repair for finding V12-01 (v0.12 multi-lens external review).
  NOT part of the audited kernel; NOT counted in Audit.lean.

  Finding V12-01: the trace-safe certificate layer (W19–W26) is bypassable.
  The deployment-facing emergency APIs `pioAuthorizesC` / `CHoldPolicy` take
  a FIXED pointwise `Envelope`; W26 only preserves the invariant for traces
  ALREADY presented as `TraceAuthorized`. Nothing forces the emergency
  channel through the stateful interface, so two individually certified
  actions can jointly cross a threshold via the pointwise path — the same
  class of defect as R2-01, one level up.

  Repair (the R2-01 pattern, again): make the exposure-aware object the
  SOLE emergency-authorization path. Authorization consumes the current
  exposure and produces the next; the composition theorem is then
  UNCONDITIONAL — a property of every trace the interface authorizes, not
  only of traces voluntarily written in `TraceAuthorized` form. The old
  fixed-`Envelope` API is recovered exactly as the trivial-exposure
  snapshot (W23), so no deployment is invalidated — but a real deployment
  supplies a non-trivial exposure and must route through `PIOExec`.
-/
import AHCKernel.TieredProtocol

namespace AHC.Proto
open AHC

/-! ## Exposure-aware PIO authorization (sole deployment-facing path) -/

/-- Exposure-aware PIO authorization: a PIO in lifecycle state `s`
    authorizes certified action `a` AT the current exposure `x`, judged
    through the pointwise envelope the state-transition certificate
    presents there (`E.envAt x`). Unlike `pioAuthorizesC`, this cannot be
    invoked without an exposure to consume. -/
abbrev pioAuthorizesT {σ δ : Type} (E : TEnvelope σ δ) (s : PIO) (x : σ)
    (a : CAction δ) : Prop :=
  pioAuthorizesC (E.envAt x) s a

/-- A PIO-executed trace: each successive action is authorized (in the
    exposure-aware sense) at the exposure its predecessors accumulated,
    and the exposure advances by `E.step`. This is the object the repair
    makes sole: authorization is a state transition over exposure. -/
inductive PIOExec {σ δ : Type} (E : TEnvelope σ δ) (s : PIO) :
    σ → List (CAction δ) → Prop
  | nil (x : σ) : PIOExec E s x []
  | cons {x : σ} {a : CAction δ} {as : List (CAction δ)} :
      pioAuthorizesT E s x a →
      PIOExec E s (E.step x a) as →
      PIOExec E s x (a :: as)

/-- Every exposure-aware PIO authorization is a Tier-1 certified
    authorization at that exposure — including the reversed state, whose
    only grant is the broadcast (Tier 0 ≤ Tier 1). -/
theorem pioAuthorizesT_authorizesC {σ δ : Type} (E : TEnvelope σ δ) (s : PIO)
    {x : σ} {a : CAction δ} (h : pioAuthorizesT E s x a) :
    authorizesC (E.envAt x) Tier.t1 a := by
  cases s with
  | issued _ => exact h
  | confirmed => exact h
  | reversed =>
      have hb : a = CAction.broadcast := h
      subst hb; decide

/-- Any PIO-executed trace is a Tier-1 authorized exposure trace. -/
theorem pioExec_traceAuthorized {σ δ : Type} (E : TEnvelope σ δ) (s : PIO)
    {x : σ} {tr : List (CAction δ)} (h : PIOExec E s x tr) :
    TraceAuthorized E Tier.t1 x tr := by
  induction h with
  | nil x => exact TraceAuthorized.nil x
  | cons ha _ ih =>
      exact TraceAuthorized.cons (pioAuthorizesT_authorizesC E s ha) ih

/-- **The repair (V12-01), PIO channel.** Every trace the exposure-aware
    emergency interface authorizes keeps the exposure inside the certified
    region — UNCONDITIONALLY, not only for traces voluntarily presented as
    `TraceAuthorized`. Because `PIOExec` is the sole path and it consumes
    and produces exposure, two individually certified actions can no longer
    jointly cross a certified threshold through the emergency channel. -/
theorem pioExec_stays_inside {σ δ : Type} (E : TEnvelope σ δ) (s : PIO)
    {x : σ} {tr : List (CAction δ)} (h : PIOExec E s x tr) (hx : E.Inv x) :
    E.Inv (E.run x tr) :=
  trace_stays_inside E (pioExec_traceAuthorized E s h) (by decide) hx

/-! ## Exposure-aware continuity-hold floor -/

/-- Exposure-aware continuity-hold policy: what the floor allows is judged
    at the CURRENT exposure, and everything allowed sits at or below the
    Tier-1 requirement of the envelope presented THERE. Supersedes
    `CHoldPolicy` (fixed `Envelope`) for deployment-facing use. -/
structure CHoldPolicyT (σ δ : Type) (E : TEnvelope σ δ) where
  allowed       : σ → CAction δ → Bool
  allowed_tier1 : ∀ x a, allowed x a = true →
                    requiredTierC (E.envAt x) a ≤ Tier.t1

/-- A hold-executed trace: each action allowed by the floor at its running
    exposure. -/
inductive HoldExec {σ δ : Type} {E : TEnvelope σ δ} (P : CHoldPolicyT σ δ E) :
    σ → List (CAction δ) → Prop
  | nil (x : σ) : HoldExec P x []
  | cons {x : σ} {a : CAction δ} {as : List (CAction δ)} :
      P.allowed x a = true →
      HoldExec P (E.step x a) as →
      HoldExec P x (a :: as)

theorem holdExec_traceAuthorized {σ δ : Type} {E : TEnvelope σ δ}
    (P : CHoldPolicyT σ δ E) {x : σ} {tr : List (CAction δ)}
    (h : HoldExec P x tr) : TraceAuthorized E Tier.t1 x tr := by
  induction h with
  | nil x => exact TraceAuthorized.nil x
  | cons ha _ ih => exact TraceAuthorized.cons (P.allowed_tier1 _ _ ha) ih

/-- **The repair (V12-01), hold floor.** Every trace the exposure-aware
    hold floor authorizes stays inside the certified region. -/
theorem holdExec_stays_inside {σ δ : Type} {E : TEnvelope σ δ}
    (P : CHoldPolicyT σ δ E) {x : σ} {tr : List (CAction δ)}
    (h : HoldExec P x tr) (hx : E.Inv x) : E.Inv (E.run x tr) :=
  trace_stays_inside E (holdExec_traceAuthorized P h) (by decide) hx

/-! ## The quarantine: the fixed-`Envelope` API is the trivial snapshot -/

/-- The quarantined pointwise interface is exactly the per-exposure
    snapshot of the exposure-aware one at the TRIVIAL exposure (W23's
    degeneracy, lifted to the PIO layer): authorizing against a fixed
    `Envelope E₀` is authorizing against `E₀.toTEnvelope` at its only
    exposure. The repair keeps the old API callable ONLY as this
    degenerate instance; a genuine deployment supplies a non-trivial
    exposure and is forced onto `PIOExec`. -/
theorem pioAuthorizesC_is_snapshot {δ : Type} (E₀ : Envelope δ) (s : PIO)
    (a : CAction δ) :
    pioAuthorizesT E₀.toTEnvelope s () a ↔ pioAuthorizesC E₀ s a := by
  cases s with
  | issued _ => exact pointwise_degenerate E₀ () Tier.t1 a
  | confirmed => exact pointwise_degenerate E₀ () Tier.t1 a
  | reversed => exact Iff.rfl

end AHC.Proto
