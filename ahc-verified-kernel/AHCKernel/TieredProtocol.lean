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

  Temporal hysteresis theorems (adopted in v0.2 from Phase 1 review,
  finding AHC-P1-002):

    S1  oscillation_travel      — any escalating value and any de-escalating
                                  value are separated by MORE than the gap width
    S2  flips_travel_anchored   — anchored machine bound: every posture flip
                                  costs the signal more than the gap width
                                  of travel
    S3  chatter_requires_travel — over ANY signal trajectory,
                                  (flips − 1)·(gapWidth+1) never exceeds the
                                  signal's total variation: chatter requires
                                  repeated genuine full-band swings; sub-band
                                  noise can flip the posture at most once, ever

  Modeling choices for S1–S3 (stated, per the framework's norm):
  · The enforcement posture is one bit stepped per observation: escalated
    de-escalates only on A < A_reset; calm escalates only on A* < A
    (the Schmitt-trigger reading of §9.2).
  · "Travel" is total variation — the sum of absolute successive
    differences. No continuity is assumed.
  · The first flip of a trajectory is free (the start posture carries no
    anchor); every later flip is charged. Hence the −1 in S3.

  PIO re-issuance guard (adopted in v0.3 under constitutional ruling
  D-R1, 2026-07-12; finding AHC-P1-003):

    R1  pio_no_relitigation      — across any input sequence with only
                                  STALE evidence (no novel claim, no
                                  ongoing exceedance), total unconfirmed
                                  protected hours never exceed 72 —
                                  however many re-issue requests arrive
    R2  reissue_needs_new_evidence — under staleness, at most one
                                  issuance, ever
    R3  ongoing_attack_reprotects — the generous bar's payoff: under
                                  ongoing exceedance a spent subgraph
                                  re-protects immediately on request; an
                                  ongoing attack can never be locked out
    R4  reissue_blocked_iff_stale — re-issuance is blocked EXACTLY when
                                  the claim is stale

  Regime-split capital routing (adopted in v0.3 under constitutional
  ruling D-R2, 2026-07-12; finding AHC-P1-005 / brief question D-2):

    V1  action_tier_monotone     — T1 lifted to magnitude-bearing actions
    V2  action_severity_le_evidence — T2 lifted to actions
    V3  action_sub_causal_reversible — the restored T3: EVERY action
                                  authorized below Tier 3 is reversible,
                                  including capital routing, because
                                  unbounded routing now requires Tier 3
    V4  action_irreversible_iff_causal — T4 lifted to actions
    V5  unbounded_routing_needs_causal — routing beyond the regime bound
                                  is authorized only at Tier 3
    V6  bounded_routing_at_t1    — the graduated ladder is preserved:
                                  bounded routing stays available on
                                  correlational evidence
    V7  refinement_conservative  — the split only strengthens gating:
                                  every action requires at least its
                                  mechanism's Phase 1 tier

  Modeling choices for R1–R4 (ruling D-R1, "yes, generous bar"):
  · Evidence freshness is `novelClaim || exceedance`: a genuinely new
    acute claim, OR the sensor signal still above threshold this hour.
    An ongoing attack therefore re-qualifies trivially; auto-reversal
    consumes only STALE claims. What counts as a novel claim is ATG /
    Layer 0 territory, deliberately outside the machine.
  · Confirmation hands off to the standard tier ladder (`confirmed` is
    absorbing here): the 72h accounting bounds UNCONFIRMED protection,
    the laundering-relevant quantity.
  · As in the T8 machine (disclosed per AHC-P1-003): within the deadline
    hour, confirmation takes priority over expiry.

  Modeling choices for V1–V7 (ruling D-R2, "Q1 yes, Q3 regime-bound"):
  · An `Action` is a mechanism with magnitude where magnitude matters
    (capital routing). Magnitude units are deployment-specified and
    abstract here (Nat).
  · `RoutingRegime.bound` is the deployment-specified magnitude at or
    below which routing is reversible; positivity is constitutive
    (`bound_pos`), so a regime in which no routing is reversible is
    unconstructible. Where the boundary sits for a given deployment is
    the amendment surface.
  · M2 (severance) keeps its Phase 1 classification: question Q2 of the
    D-2 review (is severance irreversible in any intended deployment?)
    remains OPEN and unruled — see ERRATA_AND_AMENDMENTS.md.

  Scope disclaimer (constitutionally required, in the spirit of PLOL):
  these proofs verify the SPECIFICATION, not the world. They establish that
  the protocol as written cannot authorize irreversible force on sub-causal
  evidence, cannot hold an emergency order open indefinitely, cannot demand
  escalation and de-escalation simultaneously, and cannot cycle its
  enforcement posture without the signal repeatedly traversing the full
  hysteresis band. Whether measured signals track real harm is an empirical
  question outside the kernel (§2.2, §2.3).

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-12 (v0.3).
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

/-- **T9 (No Chatter, instantaneous).** For any hysteresis parameters and
    any signal value, the escalation and de-escalation conditions are
    mutually exclusive: no single signal value can simultaneously demand
    escalation and de-escalation. (Gloss corrected in v0.2 per finding
    AHC-P1-002: this theorem is instantaneous; the TEMPORAL anti-cycling
    content of the gap is S3, `chatter_requires_travel`, below.) -/
theorem no_chatter (p : Hysteresis) (A : Int) :
    ¬(escalates p A ∧ deescalates p A) := by
  intro ⟨h1, h2⟩
  have := p.gap
  simp [escalates, deescalates] at h1 h2
  omega

/-! ## Temporal hysteresis (§9.2) — adopted v0.2, finding AHC-P1-002

T9 rules out contradictory directives at an instant, but is satisfied even
by a zero-width band — a design hysteresis exists to prevent. The theorems
below state what the strict gap actually buys: posture cycling costs the
signal real, repeated, full-band traversals. -/

/-- Width of the hysteresis band. Positive by `Hysteresis.gap`. -/
def gapWidth (p : Hysteresis) : Int := p.Astar - p.Areset

/-- **S1 (Oscillation Travel, pointwise).** Any value that escalates and
    any value that de-escalates are separated by more than the full gap
    width. One escalate/de-escalate round trip therefore costs the signal
    strictly more than the band, before any machine is even introduced. -/
theorem oscillation_travel (p : Hysteresis) (Ae Ad : Int)
    (he : escalates p Ae) (hd : deescalates p Ad) :
    gapWidth p < Ae - Ad := by
  have hg := p.gap
  have hgw : gapWidth p = p.Astar - p.Areset := rfl
  simp [escalates] at he
  simp [deescalates] at hd
  omega

/-- Enforcement posture after one signal observation: an escalated system
    de-escalates only on `A < A_reset`; a calm system escalates only on
    `A* < A`. Inside the band, the posture holds (that is the hysteresis). -/
def postureStep (p : Hysteresis) (esc : Bool) (A : Int) : Bool :=
  if esc then !decide (A < p.Areset) else decide (p.Astar < A)

/-- Number of posture flips along a signal trajectory. -/
def flips (p : Hysteresis) : Bool → List Int → Nat
  | _, [] => 0
  | esc, A :: rest =>
      (if postureStep p esc A = esc then 0 else 1)
        + flips p (postureStep p esc A) rest

/-- Total variation of the signal path starting at `a`: the sum of
    absolute successive differences. -/
def travel : Int → List Int → Int
  | _, [] => 0
  | a, b :: t => ((a - b).natAbs : Int) + travel b t

theorem flips_cons_eq (p : Hysteresis) (esc : Bool) (b : Int) (t : List Int)
    (hf : postureStep p esc b = esc) :
    flips p esc (b :: t) = flips p esc t := by
  simp [flips, hf]

theorem flips_cons_ne (p : Hysteresis) (esc : Bool) (b : Int) (t : List Int)
    (hf : postureStep p esc b ≠ esc) :
    flips p esc (b :: t) = 1 + flips p (postureStep p esc b) t := by
  simp [flips, hf]

/-- Re-anchoring a path can only lengthen it by the anchor hop
    (triangle inequality, one step). -/
theorem travel_reanchor (a b : Int) (t : List Int) :
    travel a t ≤ ((a - b).natAbs : Int) + travel b t := by
  cases t with
  | nil => simp [travel]; omega
  | cons c t' => simp only [travel]; omega

/-- The posture is consistent with an anchor value: an escalated posture
    was last set by a value above `A*`, a calm one by a value below
    `A_reset`. -/
def anchoredAt (p : Hysteresis) : Bool → Int → Prop
  | true, a => p.Astar < a
  | false, a => a < p.Areset

/-- A flip's witnessing value anchors the new posture. -/
theorem flip_anchored (p : Hysteresis) (esc : Bool) (b : Int)
    (hf : postureStep p esc b ≠ esc) :
    anchoredAt p (postureStep p esc b) b := by
  cases esc with
  | true =>
      by_cases hb : b < p.Areset
      · simp [postureStep, hb, anchoredAt]
      · exact absurd (by simp [postureStep, hb]) hf
  | false =>
      by_cases hb : p.Astar < b
      · simp [postureStep, hb, anchoredAt]
      · exact absurd (by simp [postureStep, hb]) hf

/-- A flip from an anchored posture costs strictly more than the gap:
    the old anchor and the flip value sit on opposite sides of the band. -/
theorem flip_gap (p : Hysteresis) (esc : Bool) (a b : Int)
    (ha : anchoredAt p esc a) (hf : postureStep p esc b ≠ esc) :
    gapWidth p + 1 ≤ ((a - b).natAbs : Int) := by
  have hg := p.gap
  have hgw : gapWidth p = p.Astar - p.Areset := rfl
  cases esc with
  | true =>
      have haA : p.Astar < a := ha
      have hbB : b < p.Areset := by
        by_cases hb : b < p.Areset
        · exact hb
        · exact absurd (by simp [postureStep, hb]) hf
      omega
  | false =>
      have haA : a < p.Areset := ha
      have hbB : p.Astar < b := by
        by_cases hb : p.Astar < b
        · exact hb
        · exact absurd (by simp [postureStep, hb]) hf
      omega

/-- **S2 (Anchored Travel Bound).** From a posture consistent with its
    anchor, every flip costs the signal strictly more than the gap width:
    `flips` flips cost at least `flips · (gapWidth + 1)` of total
    variation. -/
theorem flips_travel_anchored (p : Hysteresis) :
    ∀ (l : List Int) (esc : Bool) (a : Int), anchoredAt p esc a →
      (flips p esc l : Int) * (gapWidth p + 1) ≤ travel a l := by
  intro l
  induction l with
  | nil =>
      intro esc a _
      simp [flips, travel]
  | cons b t ih =>
      intro esc a ha
      by_cases hf : postureStep p esc b = esc
      · -- No flip: the posture (and its anchor) persist; re-anchor the path.
        have h1 : (flips p esc t : Int) * (gapWidth p + 1) ≤ travel a t :=
          ih esc a ha
        have h2 := travel_reanchor a b t
        rw [flips_cons_eq p esc b t hf]
        simp only [travel]
        exact Int.le_trans h1 h2
      · -- Flip: the crossing pays more than the gap, and the flip value
        -- re-anchors the new posture for the tail.
        have h1 : (flips p (postureStep p esc b) t : Int) * (gapWidth p + 1)
            ≤ travel b t :=
          ih (postureStep p esc b) b (flip_anchored p esc b hf)
        have h2 := flip_gap p esc a b ha hf
        rw [flips_cons_ne p esc b t hf]
        simp only [travel]
        have hone : ((1 + flips p (postureStep p esc b) t : Nat) : Int)
            = 1 + (flips p (postureStep p esc b) t : Int) := by
          omega
        rw [hone, Int.add_mul, Int.one_mul]
        exact Int.add_le_add h2 h1

/-- **S3 (Chatter Requires Travel).** Over ANY signal trajectory from ANY
    starting posture, all flips beyond the first are paid for by total
    variation: `(flips − 1) · (gapWidth + 1) ≤ travel`. Contrapositive, as
    §9.2 means it: bounded-variation noise strictly inside the band can
    flip the enforcement posture at most once, ever. N oscillations demand
    the signal genuinely traverse the full band N times — chatter is a
    property of large real swings, not of noise or of scheduling. This,
    not instantaneous exclusivity (T9), is the anti-cycling content of the
    hysteresis gap; the gap width appears in the bound, so a degenerate
    band provably buys no protection. -/
theorem chatter_requires_travel (p : Hysteresis) :
    ∀ (l : List Int) (esc : Bool) (a : Int),
      (flips p esc l : Int) * (gapWidth p + 1)
        ≤ travel a l + (gapWidth p + 1) := by
  intro l
  induction l with
  | nil =>
      intro esc a
      have hg := p.gap
      have hgw : gapWidth p = p.Astar - p.Areset := rfl
      simp [flips, travel]
      omega
  | cons b t ih =>
      intro esc a
      by_cases hf : postureStep p esc b = esc
      · -- No flip: recurse, re-anchoring the path at b.
        have h1 := ih esc b
        rw [flips_cons_eq p esc b t hf]
        simp only [travel]
        exact Int.le_trans h1 (by omega)
      · -- The flip (first or later): its value anchors the tail, whose
        -- flips are then fully paid by the anchored bound S2.
        have h1 : (flips p (postureStep p esc b) t : Int) * (gapWidth p + 1)
            ≤ travel b t :=
          flips_travel_anchored p t _ b (flip_anchored p esc b hf)
        rw [flips_cons_ne p esc b t hf]
        simp only [travel]
        have hone : ((1 + flips p (postureStep p esc b) t : Nat) : Int)
            = 1 + (flips p (postureStep p esc b) t : Int) := by
          omega
        rw [hone, Int.add_mul, Int.one_mul]
        exact Int.le_trans (Int.add_le_add_left h1 _) (by omega)

/-! ## PIO re-issuance guard (§5.4) — adopted v0.3, ruling D-R1

T8 proves one order resolves within 72 hours, but a single-instance
machine cannot refute re-issuance laundering: auto-reverse at hour 72,
re-file on the same evidence, cycle Tier-1 protection indefinitely on
Tier-0 grounds. Ruling D-R1 (2026-07-12): a failed confirmation consumes
its evidence, with the freshness bar set GENEROUSLY — ongoing threshold
exceedance itself counts as fresh evidence, so an ongoing attack is never
locked out; only stale claims are blocked. -/

/-- Per-subgraph PIO lifecycle state, across issuances. -/
inductive PState where
  | idle                -- no PIO for this subgraph
  | pending (h : Nat)   -- order active, Layer 0 review pending
  | confirmed           -- Tier-1 confirmation: handed to the tier ladder
  | spent               -- auto-reversed; its evidence is consumed
deriving DecidableEq, Repr

/-- One hour's inputs to the lifecycle. -/
structure PInput where
  issue      : Bool     -- request to issue a PIO this hour
  confirm    : Bool     -- Tier-1 correlational confirmation arrived
  novelClaim : Bool     -- a genuinely new acute-evidence claim this hour
  exceedance : Bool     -- sensor signal above threshold this hour
deriving DecidableEq, Repr

/-- The generous freshness bar (ruling D-R1): evidence is fresh if a
    genuinely new acute claim arrives OR the signal still exceeds
    threshold. An ongoing attack re-qualifies trivially; auto-reversal
    consumes only stale claims. -/
def PInput.fresh (i : PInput) : Bool := i.novelClaim || i.exceedance

/-- One hour of the guarded lifecycle. From `spent`, nothing moves
    without fresh evidence — that is the guard. -/
def pstep : PState → PInput → PState
  | .idle, i => cond i.issue (.pending 0) .idle
  | .pending h, i =>
      cond i.confirm .confirmed
        (if h + 1 < reviewDeadline then .pending (h + 1) else .spent)
  | .confirmed, _ => .confirmed
  | .spent, i => cond i.fresh (cond i.issue (.pending 0) .idle) .spent

/-- Whether this hour's input issues a fresh order from this state. -/
def isIssue : PState → PInput → Bool
  | .idle, i => i.issue
  | .spent, i => i.fresh && i.issue
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

/-- `confirmed` is absorbing and accrues no unconfirmed protection. -/
theorem pendingHours_confirmed :
    ∀ is : List PInput, pendingHours .confirmed is = 0 := by
  intro is
  induction is with
  | nil => rfl
  | cons i is ih => simpa [pendingHours, pstep] using ih

/-- Under staleness, `spent` is absorbing and accrues nothing:
    the guard, doing its work. -/
theorem pendingHours_spent :
    ∀ is : List PInput, (∀ i ∈ is, i.fresh = false) →
      pendingHours .spent is = 0 := by
  intro is
  induction is with
  | nil => intro _; rfl
  | cons i is ih =>
      intro hno
      have hfr : i.fresh = false := hno i (List.mem_cons_self ..)
      have hrest := ih (fun j hj => hno j (List.mem_cons_of_mem i hj))
      simp [pendingHours, pstep, hfr, hrest]

/-- A pending order strictly inside its deadline accrues at most the
    hours remaining to the deadline. -/
theorem pendingHours_pending :
    ∀ (is : List PInput) (h : Nat), h < reviewDeadline →
      (∀ i ∈ is, i.fresh = false) →
      pendingHours (.pending h) is ≤ reviewDeadline - h := by
  intro is
  induction is with
  | nil => intro h _ _; simp [pendingHours]
  | cons i is ih =>
      intro h hh hno
      have hno' : ∀ j ∈ is, j.fresh = false :=
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

/-- Under staleness, no state other than `idle` can issue, and no
    reachable state returns to `idle`: hence zero further issuances. -/
theorem issuances_zero_of_ne_idle :
    ∀ (is : List PInput) (s : PState), s ≠ .idle →
      (∀ i ∈ is, i.fresh = false) →
      issuances s is = 0 := by
  intro is
  induction is with
  | nil => intro s _ _; rfl
  | cons i is ih =>
      intro s hs hno
      have hfr : i.fresh = false := hno i (List.mem_cons_self ..)
      have hno' : ∀ j ∈ is, j.fresh = false :=
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
          simp [issuances, isIssue, pstep, hfr, this]

/-- **R2 (Re-issuance Needs Fresh Evidence).** From a fresh subgraph, any
    input sequence carrying only stale evidence produces at most one
    issuance — repetition of the request changes nothing. -/
theorem reissue_needs_new_evidence :
    ∀ is : List PInput, (∀ i ∈ is, i.fresh = false) →
      issuances .idle is ≤ 1 := by
  intro is
  induction is with
  | nil => intro _; exact Nat.zero_le 1
  | cons i is ih =>
      intro hno
      have hno' : ∀ j ∈ is, j.fresh = false :=
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
    across ANY input sequence carrying only stale evidence — any number
    of issue requests, any confirmation pattern, any length — total
    unconfirmed protected hours never exceed the 72-hour review deadline.
    The deadline of §5.4 bounds the EVIDENCE, not the order: auto-reversal
    consumes the claim that issued the order, and the protection it
    bought cannot be relitigated by re-filing. -/
theorem pio_no_relitigation :
    ∀ is : List PInput, (∀ i ∈ is, i.fresh = false) →
      pendingHours .idle is ≤ reviewDeadline := by
  intro is
  induction is with
  | nil => intro _; exact Nat.zero_le _
  | cons i is ih =>
      intro hno
      have hno' : ∀ j ∈ is, j.fresh = false :=
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

/-- **R3 (No Protection Gap).** The generous bar's payoff: under ongoing
    threshold exceedance, a spent subgraph re-protects immediately on
    request. An ongoing attack can never be locked out by the guard —
    only a claim whose signal has subsided is consumed. -/
theorem ongoing_attack_reprotects (i : PInput)
    (hx : i.exceedance = true) (hi : i.issue = true) :
    pstep .spent i = .pending 0 := by
  simp [pstep, PInput.fresh, hx, hi]

/-- **R4 (Only Staleness Blocks).** From `spent`, a re-issue request is
    refused exactly when the claim is stale: no novel claim and no
    ongoing exceedance. The guard blocks nothing else. -/
theorem reissue_blocked_iff_stale (i : PInput) (hi : i.issue = true) :
    pstep .spent i = .spent ↔ (i.novelClaim = false ∧ i.exceedance = false) := by
  cases hn : i.novelClaim <;> cases hx : i.exceedance <;>
    simp [pstep, PInput.fresh, hn, hx, hi]

/-! ## Regime-split capital routing (§5.4, §9.3 M1) — adopted v0.3, ruling D-R2

Ruling D-R2 (2026-07-12, D-2 review): graduated capital routing CAN bear
irreversible harm (Q1: yes), but only beyond an identifiable magnitude
regime (Q3: regime-bound). The mechanism is therefore split in the model:
routing at or below the deployment-specified bound is reversible and
keeps its Tier-1 requirement; routing beyond it joins the irreversible
class and requires full causal identification. "Reversible because small"
becomes a proof obligation, not an assumption. -/

/-- Deployment-specified reversibility regime for capital routing:
    magnitudes at or below `bound` are reversible. Positivity is
    constitutive: a regime in which no routing is reversible cannot be
    constructed. Where the boundary sits is the amendment surface. -/
structure RoutingRegime where
  bound : Nat
  bound_pos : 0 < bound

/-- An enforcement action: a mechanism, with magnitude where magnitude
    bears on reversibility (capital routing). -/
inductive Action where
  | broadcast               -- M4 Gradient Warning
  | route (magnitude : Nat) -- M1 Graduated Capital routing
  | severance               -- M2 Selective Dimensional Severance
  | sanction                -- M3 Exogenous Node-Level Sanctions
deriving DecidableEq, Repr

/-- The mechanism an action instantiates. -/
def Action.mech : Action → Mech
  | .broadcast => .m4
  | .route _ => .m1
  | .severance => .m2
  | .sanction => .m3

/-- Reversibility relative to a regime: routing is reversible exactly
    within the bound. Other mechanisms inherit their Phase 1
    classification (M2's is question Q2 of the D-2 review, still open). -/
def Action.reversibleIn (R : RoutingRegime) : Action → Bool
  | .route m => decide (m ≤ R.bound)
  | a => a.mech.reversible

/-- Evidence tier required for an action: unbounded routing joins the
    irreversible class at Tier 3; everything else keeps its mechanism's
    requirement. -/
def requiredTierAct (R : RoutingRegime) : Action → Tier
  | .route m => if m ≤ R.bound then .t1 else .t3
  | a => requiredTier a.mech

/-- Authorization judgment for actions. -/
abbrev authorizesAct (R : RoutingRegime) (t : Tier) (a : Action) : Prop :=
  requiredTierAct R a ≤ t

/-- **V1 (Action Tier Monotonicity).** T1 lifted to actions: stronger
    evidence never removes an authorized action. -/
theorem action_tier_monotone (R : RoutingRegime) :
    ∀ (t t' : Tier) (a : Action),
      authorizesAct R t a → t ≤ t' → authorizesAct R t' a := by
  intro t t' a h1 h2
  exact Nat.le_trans h1 h2

/-- **V2 (Action Severity–Evidence Proportionality).** T2 lifted to
    actions: the severity of any authorized action's mechanism is bounded
    by the evidence rank. -/
theorem action_severity_le_evidence (R : RoutingRegime) :
    ∀ (t : Tier) (a : Action),
      authorizesAct R t a → a.mech.severity ≤ t.rank := by
  intro t a h
  cases a with
  | route m =>
      by_cases hm : m ≤ R.bound
      · simp only [authorizesAct, requiredTierAct, if_pos hm] at h
        exact h
      · simp only [authorizesAct, requiredTierAct, if_neg hm] at h
        have h3 : (3 : Nat) ≤ t.rank := h
        show (1 : Nat) ≤ t.rank
        omega
  | broadcast => exact Nat.zero_le _
  | severance => exact h
  | sanction => exact h

/-- **V3 (Restored Sub-Causal Reversibility).** The restored T3: under
    the regime split, EVERY action authorized below Tier 3 is reversible
    — including capital routing, because unbounded routing now requires
    Tier 3. What the Phase 1 table asserted by fiat is here a
    consequence of the gating. -/
theorem action_sub_causal_reversible (R : RoutingRegime) :
    ∀ (t : Tier) (a : Action),
      authorizesAct R t a → t < .t3 → a.reversibleIn R = true := by
  intro t a h hlt
  cases a with
  | route m =>
      by_cases hm : m ≤ R.bound
      · simp [Action.reversibleIn, hm]
      · exfalso
        simp only [authorizesAct, requiredTierAct, if_neg hm] at h
        have h1 : (3 : Nat) ≤ t.rank := h
        have h2 : t.rank < 3 := hlt
        omega
  | broadcast => rfl
  | severance => rfl
  | sanction =>
      exfalso
      have h1 : (3 : Nat) ≤ t.rank := h
      have h2 : t.rank < 3 := hlt
      omega

/-- **V4 (Action Irreversibility Gate).** T4 lifted to actions: an
    irreversible action — a sanction, or routing beyond the regime bound
    — is authorized exactly at full causal identification. -/
theorem action_irreversible_iff_causal (R : RoutingRegime) :
    ∀ (t : Tier) (a : Action), a.reversibleIn R = false →
      (authorizesAct R t a ↔ t = .t3) := by
  intro t a hrev
  cases a with
  | route m =>
      have hm : ¬ m ≤ R.bound := by
        intro hle
        simp [Action.reversibleIn, hle] at hrev
      simp only [authorizesAct, requiredTierAct, if_neg hm]
      cases t <;> simp_all <;> decide
  | broadcast => simp [Action.reversibleIn, Action.mech, Mech.reversible] at hrev
  | severance => simp [Action.reversibleIn, Action.mech, Mech.reversible] at hrev
  | sanction =>
      simp only [authorizesAct, requiredTierAct]
      cases t <;> simp_all <;> decide

/-- **V5 (Unbounded Routing Needs Causal ID).** The ruling's content:
    capital routing beyond the regime bound is authorized only at
    Tier 3. -/
theorem unbounded_routing_needs_causal (R : RoutingRegime) (m : Nat)
    (t : Tier) (hm : R.bound < m)
    (h : authorizesAct R t (.route m)) : t = .t3 := by
  have hnb : ¬ m ≤ R.bound := by omega
  simp only [authorizesAct, requiredTierAct, if_neg hnb] at h
  cases t with
  | t3 => rfl
  | t0 => exact absurd h (by decide)
  | t1 => exact absurd h (by decide)
  | t2 => exact absurd h (by decide)

/-- **V6 (Graduated Ladder Preserved).** Routing within the regime bound
    remains available on correlational evidence: the split closes the
    irreversibility loophole without collapsing the graduated response
    ladder to "speak or prove". -/
theorem bounded_routing_at_t1 (R : RoutingRegime) (m : Nat)
    (hm : m ≤ R.bound) : authorizesAct R .t1 (.route m) := by
  simp only [authorizesAct, requiredTierAct, if_pos hm]
  exact Nat.le_refl _

/-- **V7 (Refinement Is Conservative).** The split only strengthens
    gating: every action requires at least the evidence tier its
    mechanism required under the Phase 1 table. Nothing authorized in
    the split model was forbidden before — Principle 19.2's demand that
    amendment refine, not relax. -/
theorem refinement_conservative (R : RoutingRegime) (a : Action) :
    requiredTier a.mech ≤ requiredTierAct R a := by
  cases a with
  | route m =>
      by_cases hm : m ≤ R.bound
      · simp only [requiredTierAct, if_pos hm, Action.mech]
        decide
      · simp only [requiredTierAct, if_neg hm, Action.mech]
        decide
  | broadcast => exact Nat.le_refl _
  | severance => exact Nat.le_refl _
  | sanction => exact Nat.le_refl _

end AHC
