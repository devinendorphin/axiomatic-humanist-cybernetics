/-
  Phase 2 DRAFT — Protective Interim Orders: Re-issuance Guard
  (AHC v3.1 §5.4, Tier 0-PIO)
  Addresses ASSESSMENT.md finding AHC-P1-003 (F-3, routed F-4/D).

  The Phase 1 kernel's PIO machine is single-instance: T8 proves ONE
  order resolves within 72 hours, but the model can neither express nor
  refute the laundering path the deadline invites — auto-reversal at
  hour 72 followed by immediate re-issue on the same evidence, cycling
  Tier-1 protection indefinitely on Tier-0 grounds.

  This draft models a subgraph's PIO lifecycle across issuances. The
  guard: after an auto-reversal, re-issuance requires NEW acute
  evidence. Under that guard:

    R1  pio_no_relitigation        — across ANY input sequence containing
                                     no new evidence, total protected
                                     hours never exceed the 72h deadline —
                                     however many re-issue requests arrive
    R2  reissue_needs_new_evidence — without new evidence there is at
                                     most one issuance, ever

  Modeling choices (per the framework's norm) — note these are exactly
  the contestation targets:
  · The guard condition itself is a MODELING PROPOSAL: §5.4's English
    ("attacks with τ_decay < 72h ... automatic reversal if correlational
    confirmation fails") plausibly implies that a failed confirmation
    consumes its evidence, but does not say so in terms. Whether
    "new acute evidence" is the right re-issuance condition is a D-class
    constitutional-interpretation question that must be ruled on BEFORE
    adoption; this draft makes the question precise, not moot.
  · `newEvidence` is a free Boolean input — what counts as new evidence
    is Layer 0 / ATG territory, deliberately outside the machine.
  · Confirmation hands off to the standard tier ladder (`confirmed` is
    absorbing here): once Tier-1 evidence arrives, protection is
    governed by Module 1's ladder, not by the PIO channel. The 72h
    accounting below therefore bounds UNCONFIRMED protection only,
    which is the laundering-relevant quantity.
  · As in Phase 1 (and disclosed per AHC-P1-003): within the deadline
    hour, confirmation takes priority over expiry.

  Status: DRAFT for Phase 2 review, contingent on the D-class ruling
  above. Not part of the circulated Phase 1 packet; the packet's source
  digest is unchanged by this file.

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-11.
-/
import AHCKernel.TieredProtocol

namespace AHC.Phase2

/-- Per-subgraph PIO lifecycle state, across issuances. -/
inductive PState where
  | idle                -- no PIO for this subgraph
  | pending (h : Nat)   -- order active, Layer 0 review pending
  | confirmed           -- Tier-1 confirmation: handed to the tier ladder
  | spent               -- auto-reversed; its evidence is consumed
deriving DecidableEq, Repr

/-- One hour's inputs. -/
structure PInput where
  issue       : Bool    -- request to issue a PIO this hour
  confirm     : Bool    -- Tier-1 correlational confirmation arrived
  newEvidence : Bool    -- NEW acute evidence (τ_decay < 72h) this hour
deriving DecidableEq, Repr

/-- One hour of the guarded lifecycle. From `spent`, nothing moves
    without new evidence — that is the guard. -/
def pstep : PState → PInput → PState
  | .idle, i => cond i.issue (.pending 0) .idle
  | .pending h, i =>
      cond i.confirm .confirmed
        (if h + 1 < reviewDeadline then .pending (h + 1) else .spent)
  | .confirmed, _ => .confirmed
  | .spent, i => cond i.newEvidence (cond i.issue (.pending 0) .idle) .spent

/-- Whether this hour's input issues a fresh order from this state. -/
def isIssue : PState → PInput → Bool
  | .idle, i => i.issue
  | .spent, i => i.newEvidence && i.issue
  | _, _ => false

/-- Count of issuances along a run. -/
def issuances : PState → List PInput → Nat
  | _, [] => 0
  | s, i :: is => cond (isIssue s i) 1 0 + issuances (pstep s i) is

/-- Hours of unconfirmed protection along a run (hours whose starting
    state is `pending`). -/
def pendingHours : PState → List PInput → Nat
  | _, [] => 0
  | s, i :: is =>
      (match s with | .pending _ => 1 | _ => 0) + pendingHours (pstep s i) is

/-! ## Structural lemmas -/

/-- `confirmed` is absorbing and accrues no unconfirmed protection. -/
theorem pendingHours_confirmed :
    ∀ is : List PInput, pendingHours .confirmed is = 0 := by
  intro is
  induction is with
  | nil => rfl
  | cons i is ih => simpa [pendingHours, pstep] using ih

/-- Without new evidence, `spent` is absorbing and accrues nothing:
    the guard, doing its work. -/
theorem pendingHours_spent :
    ∀ is : List PInput, (∀ i ∈ is, i.newEvidence = false) →
      pendingHours .spent is = 0 := by
  intro is
  induction is with
  | nil => intro _; rfl
  | cons i is ih =>
      intro hno
      have hev : i.newEvidence = false := hno i (List.mem_cons_self ..)
      have hrest := ih (fun j hj => hno j (List.mem_cons_of_mem i hj))
      simp [pendingHours, pstep, hev, hrest]

/-- A pending order strictly inside its deadline accrues at most the
    hours remaining to the deadline. -/
theorem pendingHours_pending :
    ∀ (is : List PInput) (h : Nat), h < reviewDeadline →
      (∀ i ∈ is, i.newEvidence = false) →
      pendingHours (.pending h) is ≤ reviewDeadline - h := by
  intro is
  induction is with
  | nil => intro h _ _; simp [pendingHours]
  | cons i is ih =>
      intro h hh hno
      have hno' : ∀ j ∈ is, j.newEvidence = false :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      cases hc : i.confirm with
      | true =>
          simp [pendingHours, pstep, hc, pendingHours_confirmed]
          omega
      | false =>
          by_cases hd : h + 1 < reviewDeadline
          · have := ih (h + 1) hd hno'
            simp [pendingHours, pstep, hc, if_pos hd]
            omega
          · have := pendingHours_spent is hno'
            simp [pendingHours, pstep, hc, if_neg hd, this]
            omega

/-- Without new evidence, no state other than `idle` can issue, and no
    reachable state returns to `idle`: hence zero further issuances. -/
theorem issuances_zero_of_ne_idle :
    ∀ (is : List PInput) (s : PState), s ≠ .idle →
      (∀ i ∈ is, i.newEvidence = false) →
      issuances s is = 0 := by
  intro is
  induction is with
  | nil => intro s _ _; rfl
  | cons i is ih =>
      intro s hs hno
      have hev : i.newEvidence = false := hno i (List.mem_cons_self ..)
      have hno' : ∀ j ∈ is, j.newEvidence = false :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      cases s with
      | idle => exact absurd rfl hs
      | pending h =>
          cases hc : i.confirm with
          | true =>
              have := ih .confirmed (by simp) hno'
              simp [issuances, isIssue, pstep, hc, this]
          | false =>
              by_cases hd : h + 1 < reviewDeadline
              · have := ih (.pending (h + 1)) (by simp) hno'
                simp [issuances, isIssue, pstep, hc, if_pos hd, this]
              · have := ih .spent (by simp) hno'
                simp [issuances, isIssue, pstep, hc, if_neg hd, this]
      | confirmed =>
          have := ih .confirmed (by simp) hno'
          simp [issuances, isIssue, pstep, this]
      | spent =>
          have := ih .spent (by simp) hno'
          simp [issuances, isIssue, pstep, hev, this]

/-! ## The guard theorems -/

/-- **R2 (Re-issuance Needs New Evidence).** From a fresh subgraph, any
    input sequence containing no new acute evidence produces at most one
    issuance — repetition of the request changes nothing. -/
theorem reissue_needs_new_evidence :
    ∀ is : List PInput, (∀ i ∈ is, i.newEvidence = false) →
      issuances .idle is ≤ 1 := by
  intro is
  induction is with
  | nil => intro _; exact Nat.zero_le 1
  | cons i is ih =>
      intro hno
      have hno' : ∀ j ∈ is, j.newEvidence = false :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      cases hi : i.issue with
      | true =>
          have hz := issuances_zero_of_ne_idle is (.pending 0) (by simp) hno'
          simp [issuances, isIssue, pstep, hi, hz]
      | false =>
          have := ih hno'
          simp [issuances, isIssue, pstep, hi]
          exact this

/-- **R1 (No Relitigation of the 72 Hours).** From a fresh subgraph,
    across ANY input sequence containing no new acute evidence — any
    number of issue requests, any confirmation pattern, any length —
    total unconfirmed protected hours never exceed the 72-hour review
    deadline. The deadline of §5.4 bounds the EVIDENCE, not the order:
    auto-reversal consumes the evidence that issued the order, and the
    protection it bought cannot be relitigated by re-filing. Emergency
    protection on partial evidence is bounded in time even against an
    issuer gaming the re-issue channel. -/
theorem pio_no_relitigation :
    ∀ is : List PInput, (∀ i ∈ is, i.newEvidence = false) →
      pendingHours .idle is ≤ reviewDeadline := by
  intro is
  induction is with
  | nil => intro _; exact Nat.zero_le _
  | cons i is ih =>
      intro hno
      have hno' : ∀ j ∈ is, j.newEvidence = false :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      cases hi : i.issue with
      | true =>
          have h72 : (0 : Nat) < reviewDeadline := by decide
          have := pendingHours_pending is 0 h72 hno'
          simp [pendingHours, pstep, hi]
          omega
      | false =>
          have := ih hno'
          simp [pendingHours, pstep, hi]
          exact this

end AHC.Phase2
