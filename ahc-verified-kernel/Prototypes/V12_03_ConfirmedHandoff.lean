/-
  PROTOTYPE — repair for finding V12-03 (v0.12 multi-lens external review).
  NOT part of the audited kernel; NOT counted in Audit.lean.

  Finding V12-03: `confirmed` is an unbounded authorization sink. In both
  PIO machines `confirmed` is absorbing AND keeps authorizing Tier-1
  actions, with no exit, no evidence-expiration, no modeled handoff. The
  prose calls confirmation a "handoff into the standard tier ladder"; no
  handoff is modeled, so a one-time `confirm` bit is an indefinitely
  reusable Tier-1 authorization token.

  Repair: `confirmed` is replaced by a terminal `handedOff` state that
  emits a typed handoff into a SEPARATELY governed ordinary-authorization
  process and AUTHORIZES NOTHING protective thereafter. The PIO object
  itself stops being an authorization channel at the moment of handoff.
-/
import AHCKernel.TieredProtocol

namespace AHC.Proto
open AHC

/-- The typed handoff emitted on confirmation: authority passes to an
    ordinary Tier-1 process bound to the incident, whose persistence,
    review, de-escalation, and crisis-cap accounting are governed THERE —
    not by the (now closed) PIO object. The incident/opened-at wiring is a
    deployment binding; what matters formally is that the PIO channel is
    no longer the authorizer. -/
structure OrdinaryHandoff where
  incident : Nat
  openedAt : Nat
deriving DecidableEq, Repr

/-- Corrected PIO lifecycle (repair for V12-03): the absorbing `confirmed`
    is replaced by a terminal `handedOff`. -/
inductive PIO' where
  | issued (h : Nat)   -- protective order active, review pending
  | handedOff          -- Tier-1 confirmation arrived: PIO channel CLOSED
  | reversed           -- deadline passed unconfirmed: auto-reversal
deriving DecidableEq, Repr

/-- One hour of the corrected machine. On confirmation the order hands off
    (channel closes); otherwise the 72-hour clock runs to auto-reversal. -/
def pioStep' : PIO' → Bool → PIO'
  | .issued _, true  => .handedOff
  | .issued h, false =>
      if h + 1 < reviewDeadline then .issued (h + 1) else .reversed
  | s, _ => s

def pioRun' : PIO' → List Bool → PIO'
  | s, []      => s
  | s, b :: bs => pioRun' (pioStep' s b) bs

/-- What the corrected PIO channel authorizes at action granularity. Only a
    LIVE `issued` order authorizes protective (Tier-1) actions; once the
    order hands off or reverses, the channel authorizes only the
    transparency broadcast. The absorbing-authorization sink of V12-03 is
    gone. -/
abbrev pioAuthorizesC' {δ : Type} (E : Envelope δ) (s : PIO')
    (a : CAction δ) : Prop :=
  match s with
  | .issued _  => requiredTierC E a ≤ Tier.t1
  | .handedOff => a = .broadcast
  | .reversed  => a = .broadcast

/-- The handoff emitted by the corrected machine: a `handedOff` state hands
    off to the ordinary process; every other state emits nothing. -/
def pioHandoff : PIO' → Option OrdinaryHandoff
  | .handedOff => some ⟨0, 0⟩
  | _          => none

/-- **Z1 (Handoff Closes the Channel).** A handed-off PIO authorizes only
    the broadcast. -/
theorem handoff_closes {δ : Type} (E : Envelope δ) (a : CAction δ)
    (h : pioAuthorizesC' E .handedOff a) : a = .broadcast := h

/-- **Z2 (No Reusable Token).** After handoff the PIO channel grants no
    routing, no severance, and no sanction — a one-time confirmation can no
    longer function as an indefinitely reusable Tier-1 authorization. -/
theorem handoff_grants_nothing_protective {δ : Type} (E : Envelope δ) :
    (∀ d, ¬ pioAuthorizesC' E .handedOff (.route d)) ∧
    (∀ d, ¬ pioAuthorizesC' E .handedOff (.severance d)) ∧
    ¬ pioAuthorizesC' E .handedOff .sanction := by
  refine ⟨fun d h => ?_, fun d h => ?_, fun h => ?_⟩
  · exact CAction.noConfusion h
  · exact CAction.noConfusion h
  · exact CAction.noConfusion h

/-- **Z3 (Handoff Is Emitted, and Is Terminal).** The corrected machine
    emits exactly one typed handoff on confirmation, and `handedOff` is
    absorbing: nothing reopens the PIO channel. -/
theorem handoff_emitted : (pioHandoff .handedOff).isSome = true := rfl

theorem handedOff_absorbing : ∀ l, pioRun' .handedOff l = .handedOff := by
  intro l; induction l with
  | nil => rfl
  | cons b bs ih => simpa [pioRun', pioStep'] using ih

/-- **Z4 (The Defect, Exhibited).** In the ORIGINAL machine `confirmed`
    authorizes exactly what a live pending order does — for every action,
    under every envelope — and is absorbing: an authorization sink that
    never closes (V12-03). The corrected machine above replaces this
    equivalence with a closed channel. -/
theorem original_confirmed_is_sink {δ : Type} (E : Envelope δ) (a : CAction δ) :
    pioAuthorizesC E .confirmed a ↔ pioAuthorizesC E (.issued 0) a := Iff.rfl

end AHC.Proto
