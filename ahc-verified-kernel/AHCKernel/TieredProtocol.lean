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

  Episode machine — PIO with two clocks (adopted in v0.4 under
  constitutional ruling D-R1A, ratified 2026-07-12; supersedes v0.3's
  R-family; findings AHC-P1-003, CG-2, CG-5. REVISED in v0.10 under
  findings R2-03/R2-06: Layer 0 outputs are typed dispositions, the
  hold carries a mandatory-review clock, and an unreviewed hold expires
  into the flagged `overdue` state):

    E1  episode_no_relitigation  — across any span with no novel
                                  attestation and no NEW-EPISODE
                                  disposition — close and continue
                                  dispositions may flow freely —
                                  WHATEVER the exceedance pattern, total
                                  unconfirmed full-protection hours ≤ 72
    E2  episode_single_issuance  — one full-PIO issuance per such span
    E3  expiry_routes_by_risk    — at the deadline: continuing exceedance
                                  enters the continuity-hold; subsided
                                  risk parks in `spent`; nothing else
    E4  reonset_refloors         — returning risk re-enters the hold
                                  floor, never the full clock
    E5  floor_persists           — the floor (hold or overdue) is never
                                  withdrawn while risk persists without
                                  a review disposition
    E6  hold_resolution_iff      — the hold returns to ordinary posture
                                  exactly on an explicit NEW-EPISODE
                                  disposition: a denial or a close can
                                  never reach the restart-permitting
                                  state (R2-03)
    E7  novel_restart_from_spent / _from_hold — an attested materially
                                  new claim restarts a full PIO
    E8  exceedance_cannot_restart — the two-clock separation, pointwise:
                                  without novelty, no input re-enters
                                  `pending` from an exhausted state —
                                  including `overdue`
    E9  hold_floor_reversible    — everything the hold floor allows is
                                  reversible
    E10 hold_floor_severity      — the floor is severity-capped at Tier 1
    E11 hold_grants_no_more_than_pio — the floor is a remnant of PIO
                                  authority, never an extension

  Typed dispositions and the clocked hold (adopted in v0.10; external
  review findings R2-03 and R2-06, Reviewer #2 report 2026-07-13):

    E12 close_cannot_launder     — the R2-03 witness, negated: a CLOSE
                                  disposition followed by a stale filing
                                  cannot reach the full clock
    E13 hold_clock_bounded       — no reachable hold state carries a
                                  clock at or past the mandatory-review
                                  deadline
    E14 unreviewed_hold_expires  — under continuing exceedance with no
                                  disposition, the hold reaches the
                                  flagged `overdue` state in at most
                                  holdReviewDeadline hours and stays
                                  there: an infinite SILENT hold is
                                  unconstructible (R2-06)
    E15 overdue_absorbing / overdue_resolution_iff — while risk persists
                                  only a Layer 0 disposition exits
                                  `overdue`, and only NEW-EPISODE reaches
                                  ordinary posture — Module 2's review
                                  discipline, at PIO scale

  Certified reversibility envelopes (adopted in v0.4 under rulings
  D-R2A and D-R3, ratified 2026-07-12; supersede v0.3's scalar V-family;
  findings AHC-P1-005/D-2 incl. Q2, CG-3, CG-4):

    W1  cert_tier_monotone       — T1 lifted to certified actions
    W2  cert_severity_le_evidence — T2 lifted to certified actions
    W3  cert_sub_causal_reversible — everything authorized below Tier 3
                                  is reversible — routing AND severance —
                                  because the uncertified requires Tier 3
    W4  cert_irreversible_iff_causal — T4 lifted to certified actions
    W5a uncertified_routing_needs_causal — no certificate ⇒ Tier 3
    W5b uncertified_severance_needs_causal — Q2 answered (D-R3): hard or
                                  uncertified severance is treated
                                  exactly as irreversible
    W6a certified_route_at_t1    — the graduated ladder is preserved
    W6b certified_severance_at_t2 — certified soft severance at Tier 2
    W7  cert_refinement_conservative — the §9.3 table is a floor that
                                  envelopes raise but never lower
    W8  no_certificate_no_presumption — reversibility of routing or
                                  severance is exactly its certificate
    W9  zero_envelope_constructible — a deployment with NO presumptively
                                  reversible routing or severance is a
                                  legal parameterization (bound_pos
                                  repealed)

  PIO and hold-floor authorization at action granularity (adopted in
  v0.9; external review finding R2-01, Reviewer #2 report 2026-07-13):

    W10 pio_cert_ceiling         — T6 lifted: no PIO state authorizes a
                                  certified action above Tier-1 severity
    W11 pio_cert_reversible      — T7 lifted: everything a PIO authorizes
                                  at action granularity is reversible IN
                                  THE ENVELOPE SENSE — by certificate,
                                  not by the Phase 1 table's fiat
    W12 pio_certificate_backed   — a PIO authorizes routing only inside
                                  its certificate, and can authorize no
                                  severance and no sanction at all
    W13 hold_floor_cert_reversible — E9 lifted to the envelope-indexed
                                  hold policy: floor reversibility is a
                                  THEOREM of the gating, not a field
    W14 hold_floor_cert_severity — E10 lifted
    W15 hold_floor_certificate_backed — the floor's routing is
                                  certificate-backed; severance and
                                  sanctions are unconstructible in it
    W16 hold_cert_grants_no_more_than_pio — E11 lifted
    W17 cert_pio_refines_mech_pio — QUARANTINE: the certified layer never
                                  grants an action whose mechanism the
                                  Phase 1 table would refuse; the legacy
                                  Mech-granularity layer is an outer
                                  presumptive bound, not an authorization
                                  channel
    W18 cert_hold_floor_constructible — non-vacuity: a broadcast-only
                                  certified floor exists for EVERY
                                  envelope, including the zero envelope

  Exposure-indexed certificates and trace safety (adopted in v0.12;
  external review finding R2-07, Reviewer #2 report 2026-07-13, per the
  reviewer's own prescription: a state-transition certificate whose
  authorization consumes and produces an exposure state, with a theorem
  over finite action traces):

    W19 trace_tier_monotone      — T1/W1 at trace altitude: stronger
                                  evidence never de-authorizes a trace
    W20 trace_head_certificate_backed — each action of a sub-causal
                                  trace is certificate-backed AT ITS OWN
                                  EXPOSURE POINT
    W21 trace_stays_inside       — the R2-07 headline: a finite trace
                                  authorized below Tier 3 from inside
                                  the certified region keeps the
                                  exposure inside the region — joint
                                  threshold-crossing by individually
                                  certified actions is unconstructible
    W22 trace_stays_inside_prefix — W21 at every intermediate point
    W23 pointwise_degenerate     — every W1–W18 envelope is the trivial-
                                  exposure special case: old deployments
                                  are conserved; the exposure obligation
                                  is what was missing, not a new burden
    W24 budget_binds_traces      — the reviewer's liquidity example,
                                  formalized: under the cumulative-
                                  budget certificate, TOTAL routed
                                  volume over any authorized trace is
                                  within budget
    W25 pointwise_admits_joint_crossing — the contrast witness: two
                                  actions each certified at frozen zero
                                  exposure whose two-action trace is
                                  refused — exactly the failure R2-07
                                  exhibited, now provably excluded by
                                  the trace regime and provably present
                                  in the pointwise one
    W26 pio_trace_stays_inside   — the emergency channel composes: a
                                  Tier-1 (PIO-grade) authorized sequence
                                  keeps the exposure invariant — R2-01's
                                  closure and R2-07's compose

  Modeling choices for E1–E11 (ruling D-R1A + D-R4):
  · `novel` is an ATG/Layer 0 attestation attached to a claim identity
    (D-R4): rewording, republication, or repetition of the same
    observation is not novelty; the determination is contestable through
    Layer 0 and made outside the machine. `exceedance` is the raw risk
    signal. The two are separate inputs: the hazard clock and the
    epistemic clock never share a needle.
  · The continuity-hold authorizes only a deployment-certified
    `HoldPolicy` floor, constrained by construction to reversible
    mechanisms at or below the Tier-1 requirement.
  · Hold-floor hours are deliberately not counted as full-protection
    hours: the hold is not the authority, and E11 proves it grants
    nothing a live PIO could not.
  · As in the T8 machine: within the deadline hour, confirmation takes
    priority over expiry; `confirmed` hands off to the tier ladder.

  Modeling choices for W1–W9 (rulings D-R2A + D-R3):
  · An action carries an opaque deployment descriptor δ (magnitude,
    concentration, duration, targets, rollback latency, …); the
    `Envelope` is the deployment-certified judgment that the described
    action lies inside the demonstrated-reversible region. The kernel
    verifies the GATING, not the envelope's fidelity to reality — the
    same seam discipline as claim extraction.
  · D-R3's certification conditions for soft severance (time-bounded,
    state-preserving, essential-service floor, tested restoration,
    cascade-safe, repair mechanism) live in the certification process;
    reversibility is judged against affected human and institutional
    state, not machine topology.
  · No positivity constraint: the zero envelope is constructible (W9),
    and the absence of a certificate is never evidence of reversibility
    (W8). The v0.3 scalar regime is the special case δ := Nat,
    routeInside := (· ≤ bound).
  · The Mech-granularity table (`Mech.reversible`, `requiredTier`) is
    retained as the PRESUMPTIVE Phase 1 floor: T1–T7 remain true of it,
    and W7 proves certificates only raise it. At action granularity the
    W-family governs. Since v0.9 (finding R2-01) the table is QUARANTINED
    from deployment-facing use: PIO and hold authorization are judged at
    action granularity under an envelope (`pioAuthorizesC`, `CHoldPolicy`;
    W10–W18), and W17 proves that layer never grants beyond the table —
    the legacy `pioAuthorizes`/`HoldPolicy` objects are outer presumptive
    bounds, not authorization channels.

  Scope disclaimer (constitutionally required, in the spirit of PLOL):
  these proofs verify the SPECIFICATION, not the world. They establish that
  the protocol as written cannot authorize irreversible force on sub-causal
  evidence, cannot hold an emergency order open indefinitely, cannot demand
  escalation and de-escalation simultaneously, and cannot cycle its
  enforcement posture without the signal repeatedly traversing the full
  hysteresis band. Whether measured signals track real harm is an empirical
  question outside the kernel (§2.2, §2.3).

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-13 (v0.9).
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

/-- What a PIO may authorize in each state, at MECHANISM granularity.
    While pending or on confirmation, response is capped at Tier-1
    mechanisms; after auto-reversal only the transparency broadcast
    remains. QUARANTINED since v0.9 (finding R2-01): this is the Phase 1
    presumptive outer bound, not a deployment-facing authorization
    channel — deployments authorize certified actions via
    `pioAuthorizesC` under an `Envelope`, and W17 proves that layer
    never grants beyond this table. -/
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

/-! ## Episode machine: PIO with two clocks (§5.4) — adopted v0.4, ruling D-R1A

Ruling D-R1A (ratified 2026-07-12) separates the HAZARD clock from the
EPISTEMIC clock. Persistence of danger (`exceedance`) is not advancement
of evidence: under v0.3's bar, persistent exceedance could cycle
successive 72h Tier-1 protections indefinitely without the evidentiary
record ever reaching confirmation. Now: only an attested materially new
claim (`novel`, per ruling D-R4 an ATG/Layer 0 determination attached to
a claim identity, contestable, outside the machine) restarts the full
PIO clock. Exceedance instead sustains a CONTINUITY-HOLD: a constrained
floor state that prevents a protection vacuum, grants at most a
deployment-certified subset of reversible Tier-1 measures (`HoldPolicy`;
at action granularity, `CHoldPolicy`), and owes an explicit Layer 0
review — mirroring Module 2's cap → Structural Review pattern.

v0.10 (findings R2-03/R2-06) makes that owed review mechanical: Layer 0
outputs are TYPED dispositions rather than a reset Boolean — a denial or
close can never reach the restart-permitting `idle`; only an explicit
`newEpisode` authorization can — and the hold carries a mandatory-review
clock. A hold left unreviewed for `holdReviewDeadline` hours under
continuing risk lands in the flagged `overdue` state: the floor persists
(no vacuum), but full authority is unavailable and nothing but a
disposition moves the subgraph — the review cannot be waited out. -/

/-- Mandatory hold-review period, in hours (v0.10, finding R2-06). Set
    equal to the PIO review deadline pending a constitutional ruling on
    the constant; the E12–E15 theorems are insensitive to its value
    provided it is positive. -/
def holdReviewDeadline : Nat := 72

/-- A typed Layer 0 review disposition (v0.10, finding R2-03). The v0.4
    machine carried a single `layer0 : Bool` reset bit, collapsing a
    denial, a direction to continue, a close-out, and the authorization
    of a new episode into one transition. Now the disposition is part of
    the input's TYPE; the basis of a `newEpisode` authorization is
    recorded through D-R4's disclosure obligations, outside the machine. -/
inductive Layer0Disposition where
  | continueHold  -- review conducted: continue the floor; the clock re-arms
  | close         -- review conducted: close to ordinary posture (novelty
                  -- required for any new full clock, as from `spent`)
  | newEpisode    -- review conducted: a fresh full-PIO episode is
                  -- explicitly authorized
deriving DecidableEq, Repr

/-- Per-subgraph episode state. `hold k` is the continuity-hold with its
    mandatory-review clock; `overdue` is the flagged breach state: the
    floor persists, but the owed review never arrived and only a Layer 0
    disposition can move the subgraph anywhere else. -/
inductive EpState where
  | idle                -- no PIO for this subgraph
  | pending (h : Nat)   -- full PIO active, review pending
  | hold (k : Nat)      -- continuity-hold: floor protection, review owed
  | overdue             -- review deadline breached: floor persists, flagged
  | spent               -- budget exhausted, risk subsided
  | confirmed           -- Tier-1 confirmation: handed to the tier ladder
deriving DecidableEq, Repr

/-- One hour's inputs to the episode machine. -/
structure EpInput where
  issue      : Bool     -- request to issue a full PIO this hour
  confirm    : Bool     -- Tier-1 correlational confirmation arrived
  novel      : Bool     -- ATG/Layer 0 attestation: materially new claim (D-R4)
  exceedance : Bool     -- sensor signal above threshold (riskPersistent)
  layer0     : Option Layer0Disposition  -- a typed review disposition, if any
deriving DecidableEq, Repr

/-- Budget-exhausted states: protection may continue only as the hold
    floor; the full clock is closed to everything but a novel claim or
    an explicit new-episode disposition. -/
def EpState.exhausted : EpState → Bool
  | .hold _ => true
  | .overdue => true
  | .spent => true
  | .confirmed => true
  | _ => false

/-- Floor-active states: the continuity-hold floor (a `CHoldPolicy`) is
    in force. `overdue` keeps the floor — a review breach must not
    become a protection vacuum (D-R1A). -/
def EpState.floorActive : EpState → Bool
  | .hold _ => true
  | .overdue => true
  | _ => false

/-- One hour of the episode machine (v0.10). At expiry the machine
    routes by risk: continuing exceedance enters the hold with a fresh
    review clock, subsided risk parks in `spent`. From the hold, a typed
    disposition takes priority: `newEpisode` returns to `idle` (the only
    path back to the restart-permitting state), `close` parks in
    `spent`, `continueHold` re-arms the clock while risk persists. With
    no disposition, a novel claim filed with an issuance restarts a full
    PIO; otherwise the hold tracks the risk signal until its
    mandatory-review deadline, where continuing risk lands in `overdue`.
    From `overdue`, only a disposition moves the subgraph anywhere while
    risk persists — filings and novelty wait on the owed review. From
    `spent`, re-onset of exceedance re-enters the hold floor — never the
    full clock. -/
def estep : EpState → EpInput → EpState
  | .idle, i => cond i.issue (.pending 0) .idle
  | .pending h, i =>
      cond i.confirm .confirmed
        (if h + 1 < reviewDeadline then .pending (h + 1)
         else cond i.exceedance (.hold 0) .spent)
  | .hold k, i =>
      match i.layer0 with
      | some .newEpisode   => .idle
      | some .close        => .spent
      | some .continueHold => cond i.exceedance (.hold 0) .spent
      | none =>
          cond (i.novel && i.issue) (.pending 0)
            (if k + 1 < holdReviewDeadline then
               cond i.exceedance (.hold (k + 1)) .spent
             else cond i.exceedance .overdue .spent)
  | .overdue, i =>
      match i.layer0 with
      | some .newEpisode   => .idle
      | some .close        => .spent
      | some .continueHold => cond i.exceedance (.hold 0) .spent
      | none => cond i.exceedance .overdue .spent
  | .spent, i =>
      cond (i.novel && i.issue) (.pending 0)
        (cond i.exceedance (.hold 0) .spent)
  | .confirmed, _ => .confirmed

/-- Whether this hour's input issues a fresh full PIO from this state. -/
def epIsIssue : EpState → EpInput → Bool
  | .idle, i => i.issue
  | .hold _, i =>
      match i.layer0 with
      | none => i.novel && i.issue
      | some _ => false
  | .spent, i => i.novel && i.issue
  | _, _ => false

/-- Run the episode machine over a sequence of hourly inputs. -/
def epRun : EpState → List EpInput → EpState
  | s, [] => s
  | s, i :: is => epRun (estep s i) is

/-- Count of full-PIO issuances along a run. -/
def epIssuances : EpState → List EpInput → Nat
  | _, [] => 0
  | s, i :: is => cond (epIsIssue s i) 1 0 + epIssuances (estep s i) is

/-- Hours of unconfirmed FULL protection along a run (hours whose
    starting state is `pending`; hold-floor hours are deliberately not
    counted — the hold is not the full authority). -/
def epPendingHours : EpState → List EpInput → Nat
  | _, [] => 0
  | s, i :: is =>
      (match s with | .pending _ => 1 | _ => 0) + epPendingHours (estep s i) is

/-- Single-step invariant: with no novel attestation and no new-episode
    disposition, an exhausted state steps to an exhausted state — close
    and continue dispositions included. Only `some .newEpisode` can
    reach `idle`. -/
theorem estep_exhausted (s : EpState) (i : EpInput) (hs : s.exhausted = true)
    (hn : i.novel = false) (hne : i.layer0 ≠ some .newEpisode) :
    (estep s i).exhausted = true := by
  cases s with
  | idle => simp [EpState.exhausted] at hs
  | pending h => simp [EpState.exhausted] at hs
  | confirmed => rfl
  | hold k =>
      cases hl : i.layer0 with
      | none =>
          by_cases hd : k + 1 < holdReviewDeadline <;>
            cases hx : i.exceedance <;>
              simp [estep, hl, hn, hd, hx, EpState.exhausted]
      | some d =>
          cases d with
          | newEpisode => exact absurd hl hne
          | close => simp [estep, hl, EpState.exhausted]
          | continueHold =>
              cases hx : i.exceedance <;>
                simp [estep, hl, hx, EpState.exhausted]
  | overdue =>
      cases hl : i.layer0 with
      | none =>
          cases hx : i.exceedance <;>
            simp [estep, hl, hx, EpState.exhausted]
      | some d =>
          cases d with
          | newEpisode => exact absurd hl hne
          | close => simp [estep, hl, EpState.exhausted]
          | continueHold =>
              cases hx : i.exceedance <;>
                simp [estep, hl, hx, EpState.exhausted]
  | spent =>
      cases hx : i.exceedance <;>
        simp [estep, hn, hx, EpState.exhausted]

/-- Exhausted states issue nothing without novelty. -/
theorem epIsIssue_exhausted (s : EpState) (i : EpInput)
    (hs : s.exhausted = true) (hn : i.novel = false) :
    epIsIssue s i = false := by
  cases s with
  | idle => simp [EpState.exhausted] at hs
  | pending h => simp [EpState.exhausted] at hs
  | hold k => cases hl : i.layer0 <;> simp [epIsIssue, hl, hn]
  | overdue => rfl
  | spent => simp [epIsIssue, hn]
  | confirmed => rfl

/-- Exhausted states never re-enter `pending` across a span with no
    novel attestation and no NEW-EPISODE disposition — whatever the
    exceedance, filing, close, and continue pattern — so they accrue no
    full-protection hours. -/
theorem epPendingHours_exhausted :
    ∀ (is : List EpInput) (s : EpState), s.exhausted = true →
      (∀ i ∈ is, i.novel = false ∧ i.layer0 ≠ some .newEpisode) →
      epPendingHours s is = 0 := by
  intro is
  induction is with
  | nil => intro s _ _; rfl
  | cons i is ih =>
      intro s hs hno
      have hn := (hno i (List.mem_cons_self ..)).1
      have hne := (hno i (List.mem_cons_self ..)).2
      have hno' : ∀ j ∈ is, j.novel = false ∧ j.layer0 ≠ some .newEpisode :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      have htail := ih (estep s i) (estep_exhausted s i hs hn hne) hno'
      cases s with
      | idle => simp [EpState.exhausted] at hs
      | pending h => simp [EpState.exhausted] at hs
      | hold k => simpa [epPendingHours] using htail
      | overdue => simpa [epPendingHours] using htail
      | spent => simpa [epPendingHours] using htail
      | confirmed => simpa [epPendingHours] using htail

/-- Exhausted states issue no full PIOs across such a span. -/
theorem epIssuances_exhausted :
    ∀ (is : List EpInput) (s : EpState), s.exhausted = true →
      (∀ i ∈ is, i.novel = false ∧ i.layer0 ≠ some .newEpisode) →
      epIssuances s is = 0 := by
  intro is
  induction is with
  | nil => intro s _ _; rfl
  | cons i is ih =>
      intro s hs hno
      have hn := (hno i (List.mem_cons_self ..)).1
      have hne := (hno i (List.mem_cons_self ..)).2
      have hno' : ∀ j ∈ is, j.novel = false ∧ j.layer0 ≠ some .newEpisode :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      have htail := ih (estep s i) (estep_exhausted s i hs hn hne) hno'
      have hiss := epIsIssue_exhausted s i hs hn
      cases s with
      | idle => simp [EpState.exhausted] at hs
      | pending h => simp [EpState.exhausted] at hs
      | hold k => simpa [epIssuances, hiss] using htail
      | overdue => simpa [epIssuances, hiss] using htail
      | spent => simpa [epIssuances, hiss] using htail
      | confirmed => simpa [epIssuances, hiss] using htail

/-- A pending episode inside its deadline accrues at most the hours
    remaining to the deadline — and at expiry lands in an exhausted
    state, whatever the risk signal. -/
theorem epPendingHours_pending :
    ∀ (is : List EpInput) (h : Nat), h < reviewDeadline →
      (∀ i ∈ is, i.novel = false ∧ i.layer0 ≠ some .newEpisode) →
      epPendingHours (.pending h) is ≤ reviewDeadline - h := by
  intro is
  induction is with
  | nil => intro h _ _; simp [epPendingHours]
  | cons i is ih =>
      intro h hh hno
      have hno' : ∀ j ∈ is, j.novel = false ∧ j.layer0 ≠ some .newEpisode :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      cases hc : i.confirm with
      | true =>
          have := epPendingHours_exhausted is .confirmed rfl hno'
          simp [epPendingHours, estep, hc, this]
          omega
      | false =>
          by_cases hd : h + 1 < reviewDeadline
          · have := ih (h + 1) hd hno'
            simp [epPendingHours, estep, hc, if_pos hd]
            omega
          · cases hx : i.exceedance with
            | true =>
                have := epPendingHours_exhausted is (.hold 0) rfl hno'
                simp [epPendingHours, estep, hc, if_neg hd, hx, this]
                omega
            | false =>
                have := epPendingHours_exhausted is .spent rfl hno'
                simp [epPendingHours, estep, hc, if_neg hd, hx, this]
                omega

/-- A pending episode issues no further full PIOs across such a span. -/
theorem epIssuances_pending_zero :
    ∀ (is : List EpInput) (h : Nat),
      (∀ i ∈ is, i.novel = false ∧ i.layer0 ≠ some .newEpisode) →
      epIssuances (.pending h) is = 0 := by
  intro is
  induction is with
  | nil => intro h _; rfl
  | cons i is ih =>
      intro h hno
      have hno' : ∀ j ∈ is, j.novel = false ∧ j.layer0 ≠ some .newEpisode :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      cases hc : i.confirm with
      | true =>
          have := epIssuances_exhausted is .confirmed rfl hno'
          simp [epIssuances, epIsIssue, estep, hc, this]
      | false =>
          by_cases hd : h + 1 < reviewDeadline
          · have := ih (h + 1) hno'
            simp [epIssuances, epIsIssue, estep, hc, if_pos hd, this]
          · cases hx : i.exceedance with
            | true =>
                have := epIssuances_exhausted is (.hold 0) rfl hno'
                simp [epIssuances, epIsIssue, estep, hc, if_neg hd, hx, this]
            | false =>
                have := epIssuances_exhausted is .spent rfl hno'
                simp [epIssuances, epIsIssue, estep, hc, if_neg hd, hx, this]

/-- **E1 (Two Clocks / No Relitigation).** The headline of ruling D-R1A,
    STRENGTHENED in v0.10: across ANY input sequence carrying no novel
    attestation and no NEW-EPISODE disposition — close and continue
    dispositions may flow freely, WHATEVER the exceedance pattern,
    however many filings, any confirmation pattern, any length — total
    unconfirmed full-protection hours never exceed the 72-hour deadline.
    Persistence of the hazard signal keeps the floor (E4/E5); it buys
    not one hour of the full authority. Only evidence, or an explicit
    Layer 0 authorization, moves the epistemic clock. -/
theorem episode_no_relitigation :
    ∀ is : List EpInput,
      (∀ i ∈ is, i.novel = false ∧ i.layer0 ≠ some .newEpisode) →
      epPendingHours .idle is ≤ reviewDeadline := by
  intro is
  induction is with
  | nil => intro _; exact Nat.zero_le _
  | cons i is ih =>
      intro hno
      have hno' : ∀ j ∈ is, j.novel = false ∧ j.layer0 ≠ some .newEpisode :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      cases hi : i.issue with
      | true =>
          have h72 : (0 : Nat) < reviewDeadline := by decide
          have := epPendingHours_pending is 0 h72 hno'
          simp [epPendingHours, estep, hi]
          omega
      | false =>
          have := ih hno'
          simp [epPendingHours, estep, hi]
          exact this

/-- **E2 (One Episode, One Issuance).** Across such a span there is at
    most one full-PIO issuance, ever. -/
theorem episode_single_issuance :
    ∀ is : List EpInput,
      (∀ i ∈ is, i.novel = false ∧ i.layer0 ≠ some .newEpisode) →
      epIssuances .idle is ≤ 1 := by
  intro is
  induction is with
  | nil => intro _; exact Nat.zero_le 1
  | cons i is ih =>
      intro hno
      have hno' : ∀ j ∈ is, j.novel = false ∧ j.layer0 ≠ some .newEpisode :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      cases hi : i.issue with
      | true =>
          have hz := epIssuances_pending_zero is 0 hno'
          simp [epIssuances, epIsIssue, estep, hi, hz]
      | false =>
          have := ih hno'
          simp [epIssuances, epIsIssue, estep, hi]
          exact this

/-- **E3 (Expiry Routes by Risk).** At the deadline, an unconfirmed
    episode does not simply vanish: continuing exceedance enters the
    continuity-hold with a fresh review clock, subsided risk parks in
    `spent`. There is no third outcome and no discretion. -/
theorem expiry_routes_by_risk (h : Nat) (i : EpInput)
    (hc : i.confirm = false) (hd : ¬ (h + 1 < reviewDeadline)) :
    estep (.pending h) i = cond i.exceedance (.hold 0) .spent := by
  simp [estep, hc, hd]

/-- **E4 (Re-onset Re-floors).** From `spent`, returning exceedance
    re-enters the hold floor — protection follows the risk — but never
    the full clock (E8). -/
theorem reonset_refloors (i : EpInput)
    (hni : (i.novel && i.issue) = false) (hx : i.exceedance = true) :
    estep .spent i = .hold 0 := by
  simp [estep, hni, hx]

/-- **E5 (The Floor Follows the Risk).** While exceedance persists and
    neither a disposition nor a novel filing arrives, a floor-active
    state steps to a floor-active state: the floor is never withdrawn
    under continuing unreviewed risk — the protection-vacuum failure
    mode of a strict bar stays closed, even across the hold's review
    deadline (`overdue` keeps the floor). -/
theorem floor_persists (s : EpState) (i : EpInput)
    (hf : s.floorActive = true) (hl : i.layer0 = none)
    (hni : (i.novel && i.issue) = false) (hx : i.exceedance = true) :
    (estep s i).floorActive = true := by
  cases s with
  | idle => simp [EpState.floorActive] at hf
  | pending h => simp [EpState.floorActive] at hf
  | spent => simp [EpState.floorActive] at hf
  | confirmed => simp [EpState.floorActive] at hf
  | hold k =>
      by_cases hd : k + 1 < holdReviewDeadline <;>
        simp [estep, hl, hni, hx, hd, EpState.floorActive]
  | overdue => simp [estep, hl, hx, EpState.floorActive]

/-- **E6 (Only Authorization Reopens the Gate).** The hold returns the
    subgraph to the restart-permitting ordinary posture exactly on an
    explicit NEW-EPISODE disposition: time does not do it, filings do
    not do it, exceedance does not do it — and neither does a denial, a
    close, or a continue disposition (finding R2-03). A close parks in
    `spent`, where only novelty reopens the full clock. -/
theorem hold_resolution_iff (k : Nat) (i : EpInput) :
    estep (.hold k) i = .idle ↔ i.layer0 = some .newEpisode := by
  cases hl : i.layer0 with
  | none =>
      cases hni : (i.novel && i.issue) <;>
        by_cases hd : k + 1 < holdReviewDeadline <;>
          cases hx : i.exceedance <;>
            simp [estep, hl, hni, hd, hx]
  | some d =>
      cases d <;> cases hx : i.exceedance <;> simp [estep, hl, hx]

/-- **E7a (Novel Evidence Restarts the Full Clock, from spent).** -/
theorem novel_restart_from_spent (i : EpInput)
    (hn : i.novel = true) (hi : i.issue = true) :
    estep .spent i = .pending 0 := by
  simp [estep, hn, hi]

/-- **E7b (Novel Evidence Restarts the Full Clock, from hold).** -/
theorem novel_restart_from_hold (k : Nat) (i : EpInput)
    (hl : i.layer0 = none) (hn : i.novel = true) (hi : i.issue = true) :
    estep (.hold k) i = .pending 0 := by
  simp [estep, hl, hn, hi]

/-- **E8 (Exceedance Cannot Restart).** The two-clock separation,
    pointwise: without a novel attestation, no input — no exceedance
    value, no filing, no disposition — moves an exhausted subgraph back
    into `pending` in one step. Continuity of a signal is never
    continuity of the full authority. (A `newEpisode` disposition
    reaches `idle`, never `pending` directly; the span theorems E1/E2
    govern what follows.) -/
theorem exceedance_cannot_restart (i : EpInput) (hn : i.novel = false)
    (h' k : Nat) :
    estep .spent i ≠ .pending h' ∧ estep (.hold k) i ≠ .pending h' ∧
    estep .overdue i ≠ .pending h' := by
  refine ⟨?_, ?_, ?_⟩
  · cases hx : i.exceedance <;> simp [estep, hn, hx]
  · cases hl : i.layer0 with
    | none =>
        by_cases hd : k + 1 < holdReviewDeadline <;>
          cases hx : i.exceedance <;>
            simp [estep, hl, hn, hd, hx]
    | some d =>
        cases d <;> cases hx : i.exceedance <;> simp [estep, hl, hx]
  · cases hl : i.layer0 with
    | none => cases hx : i.exceedance <;> simp [estep, hl, hx]
    | some d =>
        cases d <;> cases hx : i.exceedance <;> simp [estep, hl, hx]

/-! ### Typed dispositions and the clocked hold (E12–E15) — adopted
v0.10, findings R2-03/R2-06

R2-03 exhibited the two-step stale restart
`hold --(layer0)--> idle --(issue)--> pending 0` — legal in the v0.4
machine because a single Boolean collapsed every review outcome into a
reset. R2-06 exhibited the unbounded hold: with continuing exceedance
and no Layer 0 output, `hold_persists` permitted an infinite unreviewed
hold. The typed dispositions and the review clock close both, and the
theorems below state the closures. -/

/-- **E12 (A Close Cannot Launder).** The R2-03 witness, negated: a
    CLOSE disposition followed by a stale filing — any exceedance, any
    issuance — cannot reach the full clock. Only `newEpisode` reaches
    `idle`, and that is an explicit, typed, D-R4-disclosed
    authorization, not a reset bit. -/
theorem close_cannot_launder (k : Nat) (i j : EpInput)
    (hc : i.layer0 = some .close) (hjn : j.novel = false) (h' : Nat) :
    estep (estep (.hold k) i) j ≠ .pending h' := by
  have h1 : estep (.hold k) i = .spent := by simp [estep, hc]
  rw [h1]
  cases hx : j.exceedance <;> simp [estep, hjn, hx]

/-- **E13 (The Hold Clock Is Bounded).** No transition produces a hold
    state at or past the mandatory-review deadline: every hold the
    machine can ever occupy has strictly fewer unreviewed hours than
    `holdReviewDeadline` on its clock. -/
theorem hold_clock_bounded (s : EpState) (i : EpInput) (k : Nat)
    (h : estep s i = .hold k) : k < holdReviewDeadline := by
  have hpos : 0 < holdReviewDeadline := by decide
  cases s with
  | idle => cases hi : i.issue <;> simp [estep, hi] at h
  | confirmed => simp [estep] at h
  | pending hh =>
      cases hc : i.confirm <;> by_cases hd : hh + 1 < reviewDeadline <;>
        cases hx : i.exceedance <;> simp [estep, hc, hd, hx] at h <;> omega
  | spent =>
      cases hni : (i.novel && i.issue) <;> cases hx : i.exceedance <;>
        simp [estep, hni, hx] at h <;> omega
  | hold k' =>
      cases hl : i.layer0 with
      | none =>
          cases hni : (i.novel && i.issue) <;>
            by_cases hd : k' + 1 < holdReviewDeadline <;>
              cases hx : i.exceedance <;>
                simp [estep, hl, hni, hd, hx] at h <;> omega
      | some d =>
          cases d <;> cases hx : i.exceedance <;>
            simp [estep, hl, hx] at h <;> omega
  | overdue =>
      cases hl : i.layer0 with
      | none => cases hx : i.exceedance <;> simp [estep, hl, hx] at h
      | some d =>
          cases d <;> cases hx : i.exceedance <;>
            simp [estep, hl, hx] at h <;> omega

/-- **E15a (Overdue Absorbs Under Unreviewed Risk).** While exceedance
    persists and no disposition arrives, `overdue` persists: the breach
    state cannot be waited out. -/
theorem overdue_absorbing (i : EpInput) (hl : i.layer0 = none)
    (hx : i.exceedance = true) : estep .overdue i = .overdue := by
  simp [estep, hl, hx]

/-- **E15b (Only Authorization Exits Overdue to Ordinary Posture).** -/
theorem overdue_resolution_iff (i : EpInput) :
    estep .overdue i = .idle ↔ i.layer0 = some .newEpisode := by
  cases hl : i.layer0 with
  | none => cases hx : i.exceedance <;> simp [estep, hl, hx]
  | some d => cases d <;> cases hx : i.exceedance <;> simp [estep, hl, hx]

/-- Overdue absorbs across any disposition-free span of continuing
    exceedance. -/
theorem overdue_run : ∀ (is : List EpInput),
    (∀ i ∈ is, i.layer0 = none ∧ i.exceedance = true) →
    epRun .overdue is = .overdue := by
  intro is
  induction is with
  | nil => intro _; rfl
  | cons i is ih =>
      intro h
      have hi := h i (List.mem_cons_self ..)
      show epRun (estep .overdue i) is = .overdue
      rw [overdue_absorbing i hi.1 hi.2]
      exact ih (fun j hj => h j (List.mem_cons_of_mem i hj))

/-- **E14 (An Unreviewed Hold Expires).** The R2-06 closure: under
    continuing exceedance with no disposition and no novel filing —
    exactly the conditions under which the v0.4 hold persisted forever —
    the hold reaches the flagged `overdue` state within its
    mandatory-review deadline and stays there until a disposition
    arrives. The floor persists throughout (E5); what is impossible is
    an over-deadline hold that LOOKS like an ordinary hold. -/
theorem unreviewed_hold_expires :
    ∀ (is : List EpInput) (k : Nat), k < holdReviewDeadline →
      (∀ i ∈ is, i.layer0 = none ∧ i.exceedance = true ∧
        (i.novel && i.issue) = false) →
      holdReviewDeadline ≤ k + is.length →
      epRun (.hold k) is = .overdue := by
  intro is
  induction is with
  | nil =>
      intro k hk _ hlen
      exact absurd hk (by simp at hlen; omega)
  | cons i is ih =>
      intro k hk hno hlen
      have hi := hno i (List.mem_cons_self ..)
      have hno' : ∀ j ∈ is, j.layer0 = none ∧ j.exceedance = true ∧
          (j.novel && j.issue) = false :=
        fun j hj => hno j (List.mem_cons_of_mem i hj)
      by_cases hd : k + 1 < holdReviewDeadline
      · have hstep : estep (.hold k) i = .hold (k + 1) := by
          simp [estep, hi.1, hi.2.1, hi.2.2, hd]
        show epRun (estep (.hold k) i) is = .overdue
        rw [hstep]
        refine ih (k + 1) hd hno' ?_
        simp only [List.length_cons] at hlen
        omega
      · have hstep : estep (.hold k) i = .overdue := by
          simp [estep, hi.1, hi.2.1, hi.2.2, hd]
        show epRun (estep (.hold k) i) is = .overdue
        rw [hstep]
        exact overdue_run is (fun j hj => ⟨(hno' j hj).1, (hno' j hj).2.1⟩)

/-- Deployment-certified hold-floor policy (D-R1A: "only the minimum
    reversible measures necessary to prevent an immediate protection
    gap"). WHICH measures constitute the floor is a deployment/Layer 0
    determination outside the kernel; the constitutive constraints are
    that everything allowed is reversible and sits at or below the
    Tier-1 evidence requirement — so the floor can never exceed what a
    live PIO could grant. QUARANTINED since v0.9 (finding R2-01): this
    is the Phase 1 mechanism-granularity bound; deployment-facing hold
    floors are envelope-indexed `CHoldPolicy` values over certified
    actions (W13–W16, W18). -/
structure HoldPolicy where
  allowed : Mech → Bool
  allowed_reversible : ∀ m, allowed m = true → m.reversible = true
  allowed_tier1 : ∀ m, allowed m = true → requiredTier m ≤ Tier.t1

/-- What the continuity-hold authorizes under a policy. -/
abbrev holdAuthorizes (P : HoldPolicy) (m : Mech) : Prop :=
  P.allowed m = true

/-- **E9 (The Floor Is Reversible).** -/
theorem hold_floor_reversible (P : HoldPolicy) (m : Mech)
    (h : holdAuthorizes P m) : m.reversible = true :=
  P.allowed_reversible m h

/-- **E10 (The Floor Is Severity-Capped).** -/
theorem hold_floor_severity (P : HoldPolicy) (m : Mech)
    (h : holdAuthorizes P m) : m.severity ≤ Tier.t1.rank :=
  tier1_severity_cap m (P.allowed_tier1 m h)

/-- **E11 (The Floor Grants No More Than a Live PIO).** Everything the
    hold can authorize, a pending PIO could already authorize: the hold
    is a constrained remnant of the authority, never an extension. -/
theorem hold_grants_no_more_than_pio (P : HoldPolicy) (m : Mech)
    (h : holdAuthorizes P m) : pioAuthorizes (.issued 0) m :=
  P.allowed_tier1 m h

/-! ## Certified reversibility envelopes (§5.4, §9.3 M1/M2) — adopted
v0.4, rulings D-R2A and D-R3

Ruling D-R2A (ratified 2026-07-12) replaces the scalar routing bound:
irreversibility is not monotone in one magnitude number (concentration,
duration, dependency criticality, rollback latency, cascade all bear),
and a zero-safe-routing deployment must be constructible. Ruling D-R3
answers Q2 of the D-2 review: severance CAN be irreversible — judged
against the affected human and institutional state, not machine
topology — and is irreversibility-bearing UNLESS certified soft.

Both land in one construction: an action carries an opaque deployment
descriptor δ (its concentration, duration, targets, …), and a
deployment-certified `Envelope` judges whether the described action lies
inside the demonstrated-reversible region. The kernel does not prove the
envelope describes reality — that is the seam, as always. It proves the
GATING: sub-causal authorization exists only inside a certificate, the
absence of a certificate is treated exactly as irreversibility, and the
mechanism table of §9.3 remains a floor that certificates can only
raise. The v0.3 scalar regime is the special case δ := Nat,
routeInside := (· ≤ bound); no positivity constraint survives, so the
zero envelope — no presumptively reversible routing or severance at
all — is constructible (W9). -/

/-- A deployment-certified reversibility envelope over action
    descriptors δ. `routeInside d` / `sevInside d` are the external
    certificates that a routing (severance) action described by `d` is
    demonstrably reversible: bounded, state-preserving, restorable,
    cascade-safe (D-R3's conditions live in the certification process,
    outside the kernel). No constraint forces either region to be
    nonempty. -/
structure Envelope (δ : Type) where
  routeInside : δ → Bool
  sevInside   : δ → Bool

/-- An enforcement action over descriptors δ: mechanism plus the
    descriptor the envelope judges, where reversibility is at stake. -/
inductive CAction (δ : Type) where
  | broadcast           -- M4 Gradient Warning
  | route (d : δ)       -- M1 Graduated Capital routing
  | severance (d : δ)   -- M2 Selective Dimensional Severance
  | sanction            -- M3 Exogenous Node-Level Sanctions

/-- The mechanism an action instantiates. -/
def CAction.mech {δ : Type} : CAction δ → Mech
  | .broadcast => .m4
  | .route _ => .m1
  | .severance _ => .m2
  | .sanction => .m3

/-- Reversibility relative to an envelope: routing and severance are
    reversible exactly when certified; broadcast always; sanctions
    never. The absence of a certificate is not evidence of
    reversibility (D-R2A). -/
def CAction.reversibleIn {δ : Type} (E : Envelope δ) : CAction δ → Bool
  | .broadcast => true
  | .route d => E.routeInside d
  | .severance d => E.sevInside d
  | .sanction => false

/-- Evidence tier required for an action: certified routing keeps M1's
    Tier 1, certified soft severance keeps M2's Tier 2 (D-R3);
    everything uncertified joins the irreversible class at Tier 3. -/
def requiredTierC {δ : Type} (E : Envelope δ) : CAction δ → Tier
  | .broadcast => .t0
  | .route d => if E.routeInside d = true then .t1 else .t3
  | .severance d => if E.sevInside d = true then .t2 else .t3
  | .sanction => .t3

/-- Authorization judgment for certified actions. -/
abbrev authorizesC {δ : Type} (E : Envelope δ) (t : Tier) (a : CAction δ) : Prop :=
  requiredTierC E a ≤ t

/-- **W1 (Certified Tier Monotonicity).** T1 lifted to certified
    actions: stronger evidence never removes an authorized action. -/
theorem cert_tier_monotone {δ : Type} (E : Envelope δ) :
    ∀ (t t' : Tier) (a : CAction δ),
      authorizesC E t a → t ≤ t' → authorizesC E t' a := by
  intro t t' a h1 h2
  exact Nat.le_trans h1 h2

/-- **W2 (Certified Severity–Evidence Proportionality).** T2 lifted:
    the severity of any authorized action's mechanism is bounded by the
    evidence rank. -/
theorem cert_severity_le_evidence {δ : Type} (E : Envelope δ) :
    ∀ (t : Tier) (a : CAction δ),
      authorizesC E t a → a.mech.severity ≤ t.rank := by
  intro t a h
  cases a with
  | route d =>
      by_cases hc : E.routeInside d = true
      · simp only [authorizesC, requiredTierC, if_pos hc] at h
        exact h
      · simp only [authorizesC, requiredTierC, if_neg hc] at h
        have h3 : (3 : Nat) ≤ t.rank := h
        show (1 : Nat) ≤ t.rank
        omega
  | severance d =>
      by_cases hc : E.sevInside d = true
      · simp only [authorizesC, requiredTierC, if_pos hc] at h
        exact h
      · simp only [authorizesC, requiredTierC, if_neg hc] at h
        have h3 : (3 : Nat) ≤ t.rank := h
        show (2 : Nat) ≤ t.rank
        omega
  | broadcast => exact Nat.zero_le _
  | sanction => exact h

/-- **W3 (Restored Sub-Causal Reversibility, both mechanisms).** Every
    action authorized below Tier 3 is reversible — capital routing AND
    severance — because everything uncertified requires Tier 3. What
    Phase 1 asserted by fiat for M1 and M2 is now a consequence of the
    gating for both. -/
theorem cert_sub_causal_reversible {δ : Type} (E : Envelope δ) :
    ∀ (t : Tier) (a : CAction δ),
      authorizesC E t a → t < .t3 → a.reversibleIn E = true := by
  intro t a h hlt
  cases a with
  | route d =>
      by_cases hc : E.routeInside d = true
      · simp only [CAction.reversibleIn]
        exact hc
      · exfalso
        simp only [authorizesC, requiredTierC, if_neg hc] at h
        have h1 : (3 : Nat) ≤ t.rank := h
        have h2 : t.rank < 3 := hlt
        omega
  | severance d =>
      by_cases hc : E.sevInside d = true
      · simp only [CAction.reversibleIn]
        exact hc
      · exfalso
        simp only [authorizesC, requiredTierC, if_neg hc] at h
        have h1 : (3 : Nat) ≤ t.rank := h
        have h2 : t.rank < 3 := hlt
        omega
  | broadcast => rfl
  | sanction =>
      exfalso
      have h1 : (3 : Nat) ≤ t.rank := h
      have h2 : t.rank < 3 := hlt
      omega

/-- **W4 (Certified Irreversibility Gate).** T4 lifted: an
    irreversibility-bearing action — a sanction, uncertified routing, or
    uncertified severance — is authorized exactly at full causal
    identification. -/
theorem cert_irreversible_iff_causal {δ : Type} (E : Envelope δ) :
    ∀ (t : Tier) (a : CAction δ), a.reversibleIn E = false →
      (authorizesC E t a ↔ t = .t3) := by
  intro t a hrev
  cases a with
  | route d =>
      have hc : ¬ (E.routeInside d = true) := by
        intro hle
        simp [CAction.reversibleIn, hle] at hrev
      simp only [authorizesC, requiredTierC, if_neg hc]
      cases t <;> simp_all <;> decide
  | severance d =>
      have hc : ¬ (E.sevInside d = true) := by
        intro hle
        simp [CAction.reversibleIn, hle] at hrev
      simp only [authorizesC, requiredTierC, if_neg hc]
      cases t <;> simp_all <;> decide
  | broadcast => simp [CAction.reversibleIn] at hrev
  | sanction =>
      simp only [authorizesC, requiredTierC]
      cases t <;> simp_all <;> decide

/-- **W5a (Uncertified Routing Needs Causal ID).** -/
theorem uncertified_routing_needs_causal {δ : Type} (E : Envelope δ)
    (d : δ) (t : Tier) (hnc : E.routeInside d = false)
    (h : authorizesC E t (.route d)) : t = .t3 := by
  have hc : ¬ (E.routeInside d = true) := by simp [hnc]
  simp only [authorizesC, requiredTierC, if_neg hc] at h
  cases t with
  | t3 => rfl
  | t0 => exact absurd h (by decide)
  | t1 => exact absurd h (by decide)
  | t2 => exact absurd h (by decide)

/-- **W5b (Uncertified Severance Needs Causal ID).** Ruling D-R3's
    content: hard, state-destructive, or simply UNCERTIFIED severance is
    treated exactly as irreversible. -/
theorem uncertified_severance_needs_causal {δ : Type} (E : Envelope δ)
    (d : δ) (t : Tier) (hnc : E.sevInside d = false)
    (h : authorizesC E t (.severance d)) : t = .t3 := by
  have hc : ¬ (E.sevInside d = true) := by simp [hnc]
  simp only [authorizesC, requiredTierC, if_neg hc] at h
  cases t with
  | t3 => rfl
  | t0 => exact absurd h (by decide)
  | t1 => exact absurd h (by decide)
  | t2 => exact absurd h (by decide)

/-- **W6a (Certified Routing at Tier 1).** The graduated ladder is
    preserved where reversibility has been demonstrated. -/
theorem certified_route_at_t1 {δ : Type} (E : Envelope δ) (d : δ)
    (hc : E.routeInside d = true) : authorizesC E .t1 (.route d) := by
  simp only [authorizesC, requiredTierC, if_pos hc]
  exact Nat.le_refl _

/-- **W6b (Certified Soft Severance at Tier 2).** -/
theorem certified_severance_at_t2 {δ : Type} (E : Envelope δ) (d : δ)
    (hc : E.sevInside d = true) : authorizesC E .t2 (.severance d) := by
  simp only [authorizesC, requiredTierC, if_pos hc]
  exact Nat.le_refl _

/-- **W7 (Refinement Is Conservative).** Certificates only strengthen
    gating: every action requires at least the evidence tier its
    mechanism required under the Phase 1 table — the §9.3 table remains
    a floor that envelopes can raise but never lower (Principle 19.2). -/
theorem cert_refinement_conservative {δ : Type} (E : Envelope δ)
    (a : CAction δ) : requiredTier a.mech ≤ requiredTierC E a := by
  cases a with
  | route d =>
      by_cases hc : E.routeInside d = true
      · simp only [requiredTierC, if_pos hc, CAction.mech]
        decide
      · simp only [requiredTierC, if_neg hc, CAction.mech]
        decide
  | severance d =>
      by_cases hc : E.sevInside d = true
      · simp only [requiredTierC, if_pos hc, CAction.mech]
        decide
      · simp only [requiredTierC, if_neg hc, CAction.mech]
        decide
  | broadcast => exact Nat.le_refl _
  | sanction => exact Nat.le_refl _

/-- **W8 (No Certificate, No Presumption).** Actions bearing an
    irreversibility risk are reversible-classified ONLY via their
    certificate: reversibility of routing or severance implies the
    certificate exists. Absence of a certificate is never evidence of
    reversibility. -/
theorem no_certificate_no_presumption {δ : Type} (E : Envelope δ) (d : δ) :
    ((CAction.route d).reversibleIn E = true → E.routeInside d = true) ∧
    ((CAction.severance d).reversibleIn E = true → E.sevInside d = true) :=
  ⟨fun h => h, fun h => h⟩

/-- **W9 (The Zero Envelope Is Constructible).** A deployment in which
    NO routing and NO severance is presumptively reversible — payroll,
    medication supply, settlement infrastructure — is a legal
    parameterization: every routing and severance action then requires
    Tier 3 (by W5a/W5b). The v0.3 `bound_pos` constraint, which forced
    every deployment to name a nonzero safe quantum, is repealed. -/
theorem zero_envelope_constructible (δ : Type) :
    ∃ E : Envelope δ,
      (∀ d, E.routeInside d = false) ∧ (∀ d, E.sevInside d = false) :=
  ⟨⟨fun _ => false, fun _ => false⟩, fun _ => rfl, fun _ => rfl⟩

/-! ## PIO and hold authorization at action granularity — adopted v0.9,
finding R2-01 (Reviewer #2 report, 2026-07-13)

Phase 1 defined what a PIO and the continuity-hold floor may authorize
at MECHANISM granularity (`pioAuthorizes`, `HoldPolicy`), where M1's
reversibility is the §5.4 table's declaration. Rulings D-R2A/D-R3 then
made reversibility of routing and severance a per-action certificate
(`Envelope`, W1–W9) — but the emergency path was never lifted onto that
layer, so a routing action whose descriptor lies OUTSIDE the envelope
was rejected by `requiredTierC` while remaining authorized by a pending
PIO and constructible into a hold policy with no certificate at all:
two authorization APIs, and no theorem forcing the stricter one
(finding R2-01).

The definitions below close that seam. `pioAuthorizesC` and
`CHoldPolicy` are the DEPLOYMENT-FACING authorization objects: both are
judged by `requiredTierC` under an envelope, so certificate-backing is
part of authorization itself — reversibility of everything the
emergency path grants is a theorem of the gating (W11, W13), severance
and sanctions are excluded outright (W12, W15), and the floor remains a
remnant of PIO authority (W16). The legacy mechanism-granularity layer
is retained only as the outer presumptive bound it always was: W17
proves the certified layer never grants an action whose mechanism the
Phase 1 table would refuse. -/

/-- What a PIO authorizes at action granularity, under an envelope
    (v0.9, R2-01): while pending or on confirmation, exactly the
    certified actions whose tier requirement under `requiredTierC` sits
    at or below Tier 1; after auto-reversal, only the transparency
    broadcast. Supersedes `pioAuthorizes` for deployment-facing use. -/
abbrev pioAuthorizesC {δ : Type} (E : Envelope δ) (s : PIO)
    (a : CAction δ) : Prop :=
  match s with
  | .issued _  => requiredTierC E a ≤ Tier.t1
  | .confirmed => requiredTierC E a ≤ Tier.t1
  | .reversed  => a = .broadcast

/-- **W10 (Certified PIO Severity Ceiling — T6 lifted).** No state of
    the PIO lifecycle authorizes a certified action above Tier-1
    severity. -/
theorem pio_cert_ceiling {δ : Type} (E : Envelope δ) (s : PIO)
    (a : CAction δ) (h : pioAuthorizesC E s a) :
    a.mech.severity ≤ Tier.t1.rank := by
  cases s with
  | issued _  => exact cert_severity_le_evidence E .t1 a h
  | confirmed => exact cert_severity_le_evidence E .t1 a h
  | reversed  => subst h; exact Nat.zero_le _

/-- **W11 (Certified PIO Reversibility — T7 lifted).** Everything a PIO
    can ever authorize at action granularity is reversible IN THE
    ENVELOPE SENSE: the emergency channel's recoverability is now a
    consequence of certificate gating, not of the Phase 1 table's
    declaration that M1 is reversible. -/
theorem pio_cert_reversible {δ : Type} (E : Envelope δ) (s : PIO)
    (a : CAction δ) (h : pioAuthorizesC E s a) :
    a.reversibleIn E = true := by
  cases s with
  | issued _  => exact cert_sub_causal_reversible E .t1 a h (by decide)
  | confirmed => exact cert_sub_causal_reversible E .t1 a h (by decide)
  | reversed  => subst h; rfl

/-- **W12 (PIO Authorization Is Certificate-Backed).** The reviewer's
    R2-01 witness, closed: a PIO authorizes a routing action ONLY inside
    its envelope certificate, and authorizes no severance and no
    sanction in any state. The uncertified-routing-through-the-PIO path
    is unconstructible. -/
theorem pio_certificate_backed {δ : Type} (E : Envelope δ) (s : PIO) :
    (∀ d, pioAuthorizesC E s (.route d) → E.routeInside d = true) ∧
    (∀ d, ¬ pioAuthorizesC E s (.severance d)) ∧
    ¬ pioAuthorizesC E s .sanction := by
  refine ⟨fun d h => pio_cert_reversible E s (.route d) h,
          fun d h => ?_, fun h => ?_⟩
  · cases s with
    | reversed  => exact CAction.noConfusion h
    | issued _  =>
        exact absurd
          (Nat.le_trans (cert_refinement_conservative E (.severance d)) h)
          (by decide : ¬ (Tier.t2 ≤ Tier.t1))
    | confirmed =>
        exact absurd
          (Nat.le_trans (cert_refinement_conservative E (.severance d)) h)
          (by decide : ¬ (Tier.t2 ≤ Tier.t1))
  · cases s with
    | reversed  => exact CAction.noConfusion h
    | issued _  =>
        exact absurd
          (Nat.le_trans (cert_refinement_conservative E .sanction) h)
          (by decide : ¬ (Tier.t3 ≤ Tier.t1))
    | confirmed =>
        exact absurd
          (Nat.le_trans (cert_refinement_conservative E .sanction) h)
          (by decide : ¬ (Tier.t3 ≤ Tier.t1))

/-- Envelope-indexed hold-floor policy at action granularity (v0.9,
    R2-01): the continuity-hold's floor allows ACTIONS, and its single
    constitutive constraint is stated against the envelope — everything
    allowed sits at or below the Tier-1 requirement under
    `requiredTierC`. Certificate-backing (W15) and reversibility (W13)
    are THEOREMS of this gating, not fields: the floor cannot assert a
    reversibility no certificate supports. Supersedes `HoldPolicy` for
    deployment-facing use. -/
structure CHoldPolicy (δ : Type) (E : Envelope δ) where
  allowed : CAction δ → Bool
  allowed_tier1 : ∀ a, allowed a = true → requiredTierC E a ≤ Tier.t1

/-- What the continuity-hold authorizes under a certified policy. -/
abbrev holdAuthorizesC {δ : Type} {E : Envelope δ} (P : CHoldPolicy δ E)
    (a : CAction δ) : Prop :=
  P.allowed a = true

/-- **W13 (The Certified Floor Is Reversible — E9 lifted).** -/
theorem hold_floor_cert_reversible {δ : Type} {E : Envelope δ}
    (P : CHoldPolicy δ E) (a : CAction δ) (h : holdAuthorizesC P a) :
    a.reversibleIn E = true :=
  cert_sub_causal_reversible E .t1 a (P.allowed_tier1 a h) (by decide)

/-- **W14 (The Certified Floor Is Severity-Capped — E10 lifted).** -/
theorem hold_floor_cert_severity {δ : Type} {E : Envelope δ}
    (P : CHoldPolicy δ E) (a : CAction δ) (h : holdAuthorizesC P a) :
    a.mech.severity ≤ Tier.t1.rank :=
  cert_severity_le_evidence E .t1 a (P.allowed_tier1 a h)

/-- **W15 (The Certified Floor Is Certificate-Backed).** The hold-floor
    half of R2-01, closed: any routing the floor allows carries its
    envelope certificate, and no severance or sanction is allowable at
    all — a hold policy over uncertified actions is unconstructible. -/
theorem hold_floor_certificate_backed {δ : Type} {E : Envelope δ}
    (P : CHoldPolicy δ E) :
    (∀ d, holdAuthorizesC P (.route d) → E.routeInside d = true) ∧
    (∀ d, ¬ holdAuthorizesC P (.severance d)) ∧
    ¬ holdAuthorizesC P .sanction := by
  refine ⟨fun d h => hold_floor_cert_reversible P (.route d) h,
          fun d h => ?_, fun h => ?_⟩
  · exact absurd
      (Nat.le_trans (cert_refinement_conservative E (.severance d))
        (P.allowed_tier1 _ h))
      (by decide : ¬ (Tier.t2 ≤ Tier.t1))
  · exact absurd
      (Nat.le_trans (cert_refinement_conservative E .sanction)
        (P.allowed_tier1 _ h))
      (by decide : ¬ (Tier.t3 ≤ Tier.t1))

/-- **W16 (The Certified Floor Grants No More Than a Live PIO — E11
    lifted).** Everything the certified hold floor can authorize, a
    pending PIO could already authorize under the same envelope. -/
theorem hold_cert_grants_no_more_than_pio {δ : Type} {E : Envelope δ}
    (P : CHoldPolicy δ E) (a : CAction δ) (h : holdAuthorizesC P a) :
    pioAuthorizesC E (.issued 0) a :=
  P.allowed_tier1 a h

/-- **W17 (Quarantine: The Certified Layer Refines the Phase 1
    Table).** The certified emergency layer never grants an action whose
    mechanism the legacy `pioAuthorizes` table would refuse: the
    Mech-granularity layer survives exactly as an outer presumptive
    bound, and consulting it can only ever be conservative. This is the
    theorem that makes the quarantine of the legacy API a proved
    property rather than a documentation convention. -/
theorem cert_pio_refines_mech_pio {δ : Type} (E : Envelope δ) (s : PIO)
    (a : CAction δ) (h : pioAuthorizesC E s a) :
    pioAuthorizes s a.mech := by
  cases s with
  | issued _  => exact Nat.le_trans (cert_refinement_conservative E a) h
  | confirmed => exact Nat.le_trans (cert_refinement_conservative E a) h
  | reversed  => subst h; rfl

/-- **W18 (The Certified Floor Is Constructible).** Non-vacuity guard:
    a broadcast-only floor is a legal certified hold policy for EVERY
    envelope — including the zero envelope (W9), where nothing else
    could be allowed. The strictest deployment still has a floor. -/
theorem cert_hold_floor_constructible (δ : Type) (E : Envelope δ) :
    ∃ P : CHoldPolicy δ E, P.allowed .broadcast = true := by
  refine ⟨⟨fun a => match a with
    | .broadcast => true
    | _ => false, ?_⟩, rfl⟩
  intro a ha
  cases a with
  | broadcast   => exact Nat.zero_le _
  | route d     => exact Bool.noConfusion ha
  | severance d => exact Bool.noConfusion ha
  | sanction    => exact Bool.noConfusion ha

/-! ## Exposure-indexed certificates and trace safety — adopted v0.12,
finding R2-07 (Reviewer #2 report, 2026-07-13)

The W1–W18 envelope is POINTWISE: two Boolean predicates over single
action descriptors. Nothing required monotonicity, cumulative
accounting, or safety under sequences, so ten individually certified
routing actions could jointly cross a liquidity, dependency, or cascade
threshold — the constitutional guarantee rested on an unstated
deployment convention of encoding history in the descriptor (finding
R2-07).

This section adopts the reviewer's prescribed repair: a STATE-TRANSITION
certificate. A deployment carries an exposure state σ (cumulative routed
volume, dependency load, cascade budget, restoration capacity, …);
certification judges an action AT the current exposure and produces the
exposure after it; and the certificate's constitutive obligations —
carried as structure fields, per the house norm — are that certification
is only ever granted where the step keeps the exposure inside the
demonstrated-reversible region `Inv`. Authorization of a TRACE re-judges
every action at the exposure its predecessors accumulated, through the
same pointwise `Envelope` the deployment presents at that state — so all
of W1–W18, including the certified emergency layer, applies at every
step unchanged.

What σ measures, and whether `Inv` describes the deployment's true
reversible region, are certification questions at the seam, as always.
What the kernel proves is that the GATING composes: crossing a certified
threshold means leaving `Inv`, every certified step preserves `Inv`, so
no authorized finite trace crosses (W21) — and the pointwise regime is
recovered exactly as the degenerate case where exposure carries no
information (W23), so no existing deployment is invalidated. -/

/-- A state-transition (exposure-indexed) reversibility certificate
    (v0.12, finding R2-07). `routeOk s d` certifies that routing `d` is
    demonstrably reversible GIVEN the exposure `s` already outstanding;
    `routeNext s d` is the exposure after it (likewise severance). The
    preservation fields are the certificate's constitutive obligations:
    a certificate that grants an action whose performance exits the
    certified region is unconstructible. -/
structure TEnvelope (σ δ : Type) where
  routeOk   : σ → δ → Bool
  sevOk     : σ → δ → Bool
  routeNext : σ → δ → σ
  sevNext   : σ → δ → σ
  Inv       : σ → Prop
  route_preserves :
    ∀ s d, Inv s → routeOk s d = true → Inv (routeNext s d)
  sev_preserves :
    ∀ s d, Inv s → sevOk s d = true → Inv (sevNext s d)

/-- The pointwise envelope a state-transition certificate presents at a
    given exposure: the W1–W18 layer, instantiated at the current
    state. -/
def TEnvelope.envAt {σ δ : Type} (E : TEnvelope σ δ) (s : σ) :
    Envelope δ :=
  ⟨E.routeOk s, E.sevOk s⟩

/-- Exposure evolution: routing and severance consume exposure;
    the broadcast does not, and a sanction is Tier-3 causal territory
    outside every sub-causal trace (W21's hypothesis). -/
def TEnvelope.step {σ δ : Type} (E : TEnvelope σ δ) (s : σ) :
    CAction δ → σ
  | .route d => E.routeNext s d
  | .severance d => E.sevNext s d
  | _ => s

/-- Run the exposure state over a finite action trace. -/
def TEnvelope.run {σ δ : Type} (E : TEnvelope σ δ) :
    σ → List (CAction δ) → σ
  | s, [] => s
  | s, a :: as => E.run (E.step s a) as

/-- Authorization of a finite action trace at tier `t` from exposure
    `s`: each successive action is authorized (in the W1–W18 sense)
    under the pointwise envelope AT the exposure accumulated by its
    predecessors. The object finding R2-07 asked for: authorization
    consumes and produces exposure. -/
inductive TraceAuthorized {σ δ : Type} (E : TEnvelope σ δ) (t : Tier) :
    σ → List (CAction δ) → Prop
  | nil (s : σ) : TraceAuthorized E t s []
  | cons {s : σ} {a : CAction δ} {as : List (CAction δ)} :
      authorizesC (E.envAt s) t a →
      TraceAuthorized E t (E.step s a) as →
      TraceAuthorized E t s (a :: as)

/-- One certified sub-causal step preserves the exposure invariant:
    the discharge of the certificate obligations through the W-family
    gating. -/
theorem step_preserves_inv {σ δ : Type} (E : TEnvelope σ δ) {t : Tier}
    {s : σ} (a : CAction δ) (ha : authorizesC (E.envAt s) t a)
    (ht : t < .t3) (hs : E.Inv s) : E.Inv (E.step s a) := by
  cases a with
  | broadcast => exact hs
  | sanction =>
      exact absurd (Nat.lt_of_lt_of_le ht ha) (Nat.lt_irrefl _)
  | route d =>
      have hc : E.routeOk s d = true :=
        cert_sub_causal_reversible (E.envAt s) t (.route d) ha ht
      exact E.route_preserves s d hs hc
  | severance d =>
      have hc : E.sevOk s d = true :=
        cert_sub_causal_reversible (E.envAt s) t (.severance d) ha ht
      exact E.sev_preserves s d hs hc

/-- **W19 (Trace Tier Monotonicity).** T1/W1 at trace altitude:
    strengthening the evidence never de-authorizes a trace. -/
theorem trace_tier_monotone {σ δ : Type} (E : TEnvelope σ δ)
    {t t' : Tier} {s : σ} {tr : List (CAction δ)}
    (h : TraceAuthorized E t s tr) (ht : t ≤ t') :
    TraceAuthorized E t' s tr := by
  induction h with
  | nil s => exact .nil s
  | cons ha _ ih =>
      exact .cons (cert_tier_monotone _ _ _ _ ha ht) ih

/-- **W20 (Every Step Is Certificate-Backed).** The head action of a
    sub-causally authorized trace is reversible in the envelope the
    deployment presents at its own exposure point, and the tail is
    authorized from the exposure it leaves behind — inductively, every
    action of the trace is certificate-backed at the exposure its
    predecessors accumulated. -/
theorem trace_head_certificate_backed {σ δ : Type} (E : TEnvelope σ δ)
    {t : Tier} {s : σ} {a : CAction δ} {as : List (CAction δ)}
    (h : TraceAuthorized E t s (a :: as)) (ht : t < .t3) :
    a.reversibleIn (E.envAt s) = true ∧
    TraceAuthorized E t (E.step s a) as := by
  cases h with
  | cons ha htail =>
      exact ⟨cert_sub_causal_reversible (E.envAt s) t a ha ht, htail⟩

/-- **W21 (Sub-Causal Traces Stay Inside the Reversible Region).** The
    R2-07 headline: any finite action trace authorized below Tier 3
    from an exposure inside the certified region ends inside the
    region. Ten individually certified actions cannot jointly cross a
    liquidity, dependency, or cascade threshold: crossing means leaving
    `Inv`, and every certified step provably preserves `Inv`. -/
theorem trace_stays_inside {σ δ : Type} (E : TEnvelope σ δ)
    {t : Tier} {s : σ} {tr : List (CAction δ)}
    (h : TraceAuthorized E t s tr) (ht : t < .t3) :
    E.Inv s → E.Inv (E.run s tr) := by
  induction h with
  | nil s => exact id
  | cons ha _ ih =>
      intro hs
      exact ih (step_preserves_inv E _ ha ht hs)

/-- Any prefix of an authorized trace is authorized. -/
theorem traceAuthorized_take {σ δ : Type} (E : TEnvelope σ δ)
    {t : Tier} :
    ∀ (n : Nat) {s : σ} {tr : List (CAction δ)},
      TraceAuthorized E t s tr → TraceAuthorized E t s (tr.take n) := by
  intro n
  induction n with
  | zero => intro s tr _; exact .nil s
  | succ n ih =>
      intro s tr h
      cases h with
      | nil => exact .nil s
      | cons ha htail => exact .cons ha (ih htail)

/-- **W22 (Every Intermediate Exposure Stays Inside).** W21 holds not
    only at the end of the trace but at every point along it: the
    exposure after any prefix of an authorized sub-causal trace is
    inside the certified region. -/
theorem trace_stays_inside_prefix {σ δ : Type} (E : TEnvelope σ δ)
    {t : Tier} {s : σ} {tr : List (CAction δ)}
    (h : TraceAuthorized E t s tr) (ht : t < .t3) (hs : E.Inv s)
    (n : Nat) : E.Inv (E.run s (tr.take n)) :=
  trace_stays_inside E (traceAuthorized_take E n h) ht hs

/-- The trivial-exposure lift of a pointwise envelope. -/
def Envelope.toTEnvelope {δ : Type} (E : Envelope δ) :
    TEnvelope Unit δ where
  routeOk _ d := E.routeInside d
  sevOk _ d := E.sevInside d
  routeNext _ _ := ()
  sevNext _ _ := ()
  Inv _ := True
  route_preserves := fun _ _ _ _ => trivial
  sev_preserves := fun _ _ _ _ => trivial

/-- **W23 (Pointwise Envelopes Are the Degenerate Case).** Every W1–W18
    envelope is an exposure-indexed certificate over the trivial
    exposure state, authorizing exactly what it authorized before: the
    pointwise regime is conserved, and what v0.12 adds is exactly the
    obligation that was missing — not a new constraint on existing
    deployments. -/
theorem pointwise_degenerate {δ : Type} (E : Envelope δ) (s : Unit)
    (t : Tier) (a : CAction δ) :
    authorizesC (E.toTEnvelope.envAt s) t a ↔ authorizesC E t a := by
  cases a <;> exact Iff.rfl

/-- The cumulative-budget certificate: exposure is total routed volume,
    the certified region is `≤ B`, and certification of each routing
    action is judged against the ACCUMULATED total — the liquidity
    example of finding R2-07, formalized. Severance is never certified
    in this instance. -/
def budgetTEnvelope {δ : Type} (B : Nat) (volume : δ → Nat) :
    TEnvelope Nat δ where
  routeOk s d := decide (s + volume d ≤ B)
  sevOk _ _ := false
  routeNext s d := s + volume d
  sevNext s _ := s
  Inv s := s ≤ B
  route_preserves := fun _ _ _ h => of_decide_eq_true h
  sev_preserves := fun _ _ _ h => Bool.noConfusion h

/-- **W24 (The Cumulative Budget Binds Over Traces).** Under the budget
    certificate, the TOTAL routed volume of any trace authorized below
    Tier 3 from zero exposure is at most the budget — not merely each
    action's volume individually. -/
theorem budget_binds_traces {δ : Type} (B : Nat) (volume : δ → Nat)
    {t : Tier} {tr : List (CAction δ)}
    (h : TraceAuthorized (budgetTEnvelope B volume) t 0 tr)
    (ht : t < .t3) :
    (budgetTEnvelope B volume).run 0 tr ≤ B :=
  trace_stays_inside _ h ht (Nat.zero_le B)

/-- **W25 (Pointwise Certification Admits Joint Crossing — the
    contrast).** The R2-07 failure mode, exhibited as a witness in the
    style of A1e: a budget of 10 and two routing actions of volume 6.
    Each is individually certified at zero exposure — a pointwise
    regime frozen there would authorize both — yet the two-action TRACE
    is refused, because the second action is re-judged at the exposure
    the first consumed. Together with W21, this is the formal reason
    certification is exposure-indexed rather than pointwise. -/
theorem pointwise_admits_joint_crossing :
    ∃ (B : Nat) (volume : Nat → Nat) (d₁ d₂ : Nat),
      (budgetTEnvelope B volume).routeOk 0 d₁ = true ∧
      (budgetTEnvelope B volume).routeOk 0 d₂ = true ∧
      ¬ TraceAuthorized (budgetTEnvelope B volume) .t1 0
          [.route d₁, .route d₂] := by
  refine ⟨10, fun _ => 6, 0, 1, rfl, rfl, ?_⟩
  intro h
  cases h with
  | cons ha htail =>
      cases htail with
      | cons ha2 _ => exact absurd ha2 (by decide)

/-- **W26 (The Emergency Channel Composes).** A sequence of actions
    each authorized at Tier-1 grade — what a pending PIO or a certified
    hold floor may grant at its own exposure point (W10–W16) — is a
    sub-causal trace, so the exposure invariant holds throughout:
    R2-01's closure and R2-07's compose, and the emergency path cannot
    accumulate its way across a certified threshold either. -/
theorem pio_trace_stays_inside {σ δ : Type} (E : TEnvelope σ δ)
    {s : σ} {tr : List (CAction δ)}
    (h : TraceAuthorized E .t1 s tr) (hs : E.Inv s) :
    E.Inv (E.run s tr) :=
  trace_stays_inside E h (by decide) hs

end AHC
