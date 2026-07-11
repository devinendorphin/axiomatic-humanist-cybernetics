/-
  AHC Verified Constitutional Kernel — Module 1
  Tiered Evidence-Action Protocol  (AHC v3.1, §5.4, §9.2–9.3)

  Machine-checked invariants of the enforcement layer:

    T1  tier_monotone           — authorization is upward-closed in evidence
    T2  severity_le_evidence    — response severity never exceeds evidence tier
    T3  sub_causal_reversible   — everything below Tier 3 is reversible
    T4  irreversible_iff_causal — irreversible action ⟺ full causal ID (Tier 3)
    T5  broadcast_universal     — M4 transparency broadcast available at every tier
    T6  pio_ceiling             — a PIO never authorizes above Tier-1 severity
    T7  pio_reversible          — everything a PIO authorizes is reversible
    T8  pio_resolves            — a PIO cannot remain pending past the 72h
                                  review deadline: it is confirmed or auto-reversed
    T9  no_chatter              — hysteresis gap (A_reset < A*) makes simultaneous
                                  escalate/de-escalate conditions unsatisfiable

  Scope disclaimer (constitutionally required, in the spirit of PLOL):
  these proofs verify the SPECIFICATION, not the world. They establish that
  the protocol as written cannot authorize irreversible force on sub-causal
  evidence, cannot hold an emergency order open indefinitely, and cannot
  oscillate on a single signal value. Whether measured signals track real
  harm is an empirical question outside the kernel (§2.2, §2.3).

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-11.
-/

namespace AHC

/-! ## Evidence tiers (§5.4, Table: Tiered Evidence-Action Protocol) -/

/-- Evidence tiers ordered by epistemic strength.
    `t0` observational · `t1` correlational · `t2` quasi-experimental · `t3` causal. -/
inductive Tier where
  | t0 | t1 | t2 | t3
deriving DecidableEq, Repr

/-- Numeric rank of a tier (used only to define the order). -/
def Tier.rank : Tier → Nat
  | .t0 => 0
  | .t1 => 1
  | .t2 => 2
  | .t3 => 3

instance : LE Tier := ⟨fun a b => a.rank ≤ b.rank⟩
instance : LT Tier := ⟨fun a b => a.rank < b.rank⟩

instance (a b : Tier) : Decidable (a ≤ b) :=
  inferInstanceAs (Decidable (a.rank ≤ b.rank))
instance (a b : Tier) : Decidable (a < b) :=
  inferInstanceAs (Decidable (a.rank < b.rank))

/-! ## Enforcement mechanisms (§9.3, Table: The Four Enforcement Mechanisms) -/

/-- Enforcement mechanisms ordered by severity.
    `m4` Gradient Warning (cryptographic broadcast, zero enforcement)
    `m1` Graduated Capital routing
    `m2` Selective Dimensional Severance
    `m3` Exogenous Node-Level Sanctions. -/
inductive Mech where
  | m4 | m1 | m2 | m3
deriving DecidableEq, Repr

/-- Severity scale. Broadcast < capital routing < severance < sanctions. -/
def Mech.severity : Mech → Nat
  | .m4 => 0
  | .m1 => 1
  | .m2 => 2
  | .m3 => 3

/-- Reversibility classification per §5.4: M1 "all reversible", M2 "still
    reversible on Layer 0 review", M3 full enforcement (treated as the
    irreversibility-bearing mechanism the tier structure exists to gate). -/
def Mech.reversible : Mech → Bool
  | .m4 => true
  | .m1 => true
  | .m2 => true
  | .m3 => false

/-- Minimum evidence tier required to authorize each mechanism (§5.4). -/
def requiredTier : Mech → Tier
  | .m4 => .t0
  | .m1 => .t1
  | .m2 => .t2
  | .m3 => .t3

/-- Authorization judgment: evidence tier `t` authorizes mechanism `m`. -/
abbrev authorizes (t : Tier) (m : Mech) : Prop := requiredTier m ≤ t

/-! ## Core protocol theorems -/

/-- **T1 (Tier Monotonicity).** Authorization is upward-closed: strengthening
    the evidence never removes an authorized response. There is no tier at
    which the system is forced to act with LESS than what weaker evidence
    already permitted. -/
theorem tier_monotone :
    ∀ (t t' : Tier) (m : Mech), authorizes t m → t ≤ t' → authorizes t' m := by
  intro t t' m
  cases t <;> cases t' <;> cases m <;> decide

/-- **T2 (Severity–Evidence Proportionality).** The severity of any authorized
    mechanism is bounded by the rank of the evidence tier. Force cannot
    outrun proof. -/
theorem severity_le_evidence :
    ∀ (t : Tier) (m : Mech), authorizes t m → m.severity ≤ t.rank := by
  intro t m
  cases t <;> cases m <;> decide

/-- **T3 (Sub-Causal Reversibility).** Any mechanism authorized on evidence
    weaker than full causal identification is reversible. The protocol
    cannot do permanent damage on correlational or quasi-experimental
    grounds. -/
theorem sub_causal_reversible :
    ∀ (t : Tier) (m : Mech), authorizes t m → t < .t3 → m.reversible = true := by
  intro t m
  cases t <;> cases m <;> decide

/-- **T4 (Irreversibility Gate).** An irreversible mechanism is authorized
    exactly when the full three-stage causal identification of §5.5 is
    satisfied — never earlier, and never blocked once it is. -/
theorem irreversible_iff_causal :
    ∀ (t : Tier) (m : Mech), m.reversible = false →
      (authorizes t m ↔ t = .t3) := by
  intro t m
  cases t <;> cases m <;> decide

/-- **T5 (Broadcast Universality).** The M4 transparency broadcast is
    authorized at every tier: the system can always SAY what it sees, even
    when it may not yet ACT. This is the formal core of the fail-safe /
    mobilization asymmetry. -/
theorem broadcast_universal : ∀ (t : Tier), authorizes t .m4 := by
  intro t; cases t <;> decide

/-! ## Protective Interim Order (§5.4, Tier 0-PIO)

A PIO authorizes Tier-1 protective response on Tier-0 evidence for acute
attacks (τ_decay < 72h), subject to mandatory Layer 0 review within 72
hours and automatic reversal if correlational confirmation fails. We model
it as a state machine stepped once per hour: at each step the review either
confirms (input `true`) or has not yet confirmed (input `false`). -/

/-- Mandatory review deadline, in hours (§5.4). -/
def reviewDeadline : Nat := 72

/-- PIO lifecycle states. -/
inductive PIO where
  | issued (hoursElapsed : Nat)  -- protective order active, review pending
  | confirmed                    -- Tier-1 correlational confirmation arrived
  | reversed                     -- deadline passed unconfirmed: auto-reversal
deriving DecidableEq, Repr

/-- One hour of PIO evolution. `confirm = true` means Tier-1 confirmation
    arrived during this hour. -/
def pioStep : PIO → Bool → PIO
  | .issued _, true  => .confirmed
  | .issued h, false =>
      if h + 1 < reviewDeadline then .issued (h + 1) else .reversed
  | s, _ => s

/-- Run the PIO machine over a sequence of hourly review outcomes. -/
def pioRun : PIO → List Bool → PIO
  | s, []      => s
  | s, b :: bs => pioRun (pioStep s b) bs

/-- Terminal states are absorbing. -/
theorem pioRun_confirmed : ∀ l, pioRun .confirmed l = .confirmed := by
  intro l; induction l with
  | nil => rfl
  | cons b bs ih => simpa [pioRun, pioStep] using ih

theorem pioRun_reversed : ∀ l, pioRun .reversed l = .reversed := by
  intro l; induction l with
  | nil => rfl
  | cons b bs ih => simpa [pioRun, pioStep] using ih

/-- Structural lemma: if the order is still pending after processing `l`,
    the clock advanced by exactly `l.length`, and (unless `l` was empty)
    the clock remained strictly under the deadline. -/
theorem pio_pending_clock :
    ∀ (l : List Bool) (h h' : Nat),
      pioRun (.issued h) l = .issued h' →
      h + l.length = h' ∧ (l.length = 0 ∨ h' < reviewDeadline) := by
  intro l
  induction l with
  | nil =>
      intro h h' hrun
      simp [pioRun] at hrun
      simp [hrun]
  | cons b bs ih =>
      intro h h' hrun
      cases b with
      | true =>
          simp [pioRun, pioStep, pioRun_confirmed] at hrun
      | false =>
          by_cases hd : h + 1 < reviewDeadline
          · simp only [pioRun, pioStep, if_pos hd] at hrun
            have hih := ih (h + 1) h' hrun
            refine ⟨by simp only [List.length_cons]; omega, Or.inr ?_⟩
            rcases hih.2 with hz | hlt
            · omega
            · exact hlt
          · simp [pioRun, pioStep, hd, pioRun_reversed] at hrun

/-- **T8 (PIO Bounded Review).** Once the review deadline has elapsed, a PIO
    cannot still be pending: it has either been confirmed into the standard
    tier ladder or automatically reversed. Emergency protection on partial
    evidence cannot become a standing state of exception. This is the
    Tier 0-PIO analogue of the Crisis Frequency Cap. -/
theorem pio_resolves :
    ∀ (outcomes : List Bool), reviewDeadline ≤ outcomes.length →
      pioRun (.issued 0) outcomes = .confirmed ∨
      pioRun (.issued 0) outcomes = .reversed := by
  intro outcomes hlen
  cases hfinal : pioRun (.issued 0) outcomes with
  | issued h' =>
      exfalso
      have hinv := pio_pending_clock outcomes 0 h' hfinal
      have hd72 : reviewDeadline = 72 := rfl
      rcases hinv.2 with hz | hlt
      · omega
      · have h1 := hinv.1
        omega
  | confirmed => exact Or.inl rfl
  | reversed => exact Or.inr rfl

/-- What a PIO may authorize in each state. While pending or on
    confirmation, response is capped at Tier-1 mechanisms; after
    auto-reversal only the transparency broadcast remains. -/
abbrev pioAuthorizes (s : PIO) (m : Mech) : Prop :=
  match s with
  | .issued _  => requiredTier m ≤ Tier.t1
  | .confirmed => requiredTier m ≤ Tier.t1
  | .reversed  => m = .m4

/-- Helper: any mechanism whose evidence requirement sits at or below
    Tier 1 has severity at most Tier-1 rank. -/
theorem tier1_severity_cap :
    ∀ m : Mech, requiredTier m ≤ Tier.t1 → m.severity ≤ Tier.t1.rank := by
  intro m; cases m <;> decide

/-- Helper: any mechanism whose evidence requirement sits at or below
    Tier 1 is reversible. -/
theorem tier1_reversible :
    ∀ m : Mech, requiredTier m ≤ Tier.t1 → m.reversible = true := by
  intro m; cases m <;> decide

/-- **T6 (PIO Severity Ceiling).** No state of the PIO lifecycle authorizes
    a mechanism above Tier-1 severity. The emergency channel cannot be used
    to smuggle in severance or sanctions. -/
theorem pio_ceiling :
    ∀ (s : PIO) (m : Mech), pioAuthorizes s m → m.severity ≤ Tier.t1.rank := by
  intro s m hm
  cases s with
  | issued _  => exact tier1_severity_cap m hm
  | confirmed => exact tier1_severity_cap m hm
  | reversed  => subst hm; decide

/-- **T7 (PIO Reversibility).** Everything a PIO can ever authorize is
    reversible. The constitutional logic of §5.4 — "the cost of an unjust
    temporary order is recoverable" — is a theorem of the protocol, not an
    aspiration. -/
theorem pio_reversible :
    ∀ (s : PIO) (m : Mech), pioAuthorizes s m → m.reversible = true := by
  intro s m hm
  cases s with
  | issued _  => exact tier1_reversible m hm
  | confirmed => exact tier1_reversible m hm
  | reversed  => subst hm; decide

/-! ## Hysteresis (§9.2, Graduated Enforcement with Formal Hysteresis) -/

/-- Hysteresis parameters: escalation threshold `Astar` and de-escalation
    reset `Areset`, with the constitutive gap `Areset < Astar` carried as a
    proof obligation — a `Hysteresis` value cannot be constructed without it. -/
structure Hysteresis where
  Astar  : Int
  Areset : Int
  gap    : Areset < Astar

/-- Escalation condition on the attack discriminant (sustainment window and
    causal-ID tier are handled by T1–T4 above; this isolates the signal
    inequality). -/
def escalates (p : Hysteresis) (A : Int) : Prop := p.Astar < A

/-- De-escalation condition. -/
def deescalates (p : Hysteresis) (A : Int) : Prop := A < p.Areset

/-- **T9 (No Chatter).** For any hysteresis parameters and any signal value,
    the escalation and de-escalation conditions are mutually exclusive: the
    gap makes single-signal panic cycling logically impossible, not merely
    unlikely. -/
theorem no_chatter (p : Hysteresis) (A : Int) :
    ¬(escalates p A ∧ deescalates p A) := by
  intro ⟨h1, h2⟩
  have := p.gap
  simp [escalates, deescalates] at h1 h2
  omega

end AHC
