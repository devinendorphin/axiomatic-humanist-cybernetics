/-
  Phase 2 DRAFT — Hysteresis: Temporal Anti-Chatter  (AHC v3.1 §9.2)
  Addresses ASSESSMENT.md finding AHC-P1-002 (F-1, routed F-4).

  The Phase 1 kernel's T9 (`no_chatter`) proves that escalation and
  de-escalation conditions are mutually exclusive AT A SINGLE INSTANT.
  That theorem is true but does not use the strict width of the gap, and
  it is satisfied by a zero-width band — a design hysteresis exists to
  prevent. The behavior §9.2 targets is TEMPORAL: a signal oscillating
  across the band flipping the enforcement posture on alternate steps.

  These drafts state the temporal content:

    S1  oscillation_travel       — any escalating value and any
                                   de-escalating value are separated by
                                   MORE than the gap width
    S2  flips_travel_anchored    — machine version, anchored: starting
                                   from a posture consistent with its
                                   last flip, every posture flip costs
                                   the signal at least gapWidth+1 of
                                   travel; N flips cost N·(gapWidth+1)
    S3  chatter_requires_travel  — headline, unanchored: over ANY signal
                                   trajectory, (flips − 1)·(gapWidth+1)
                                   never exceeds the total variation of
                                   the signal. Chatter requires real,
                                   repeated, full-band swings — it cannot
                                   be produced by noise smaller than the
                                   gap, no matter the noise pattern.

  Modeling choices (per the framework's norm):
  · The enforcement posture is a single bit stepped per observation:
    escalated de-escalates only on A < A_reset; calm escalates only on
    A* < A. This is the standard Schmitt-trigger reading of §9.2.
  · "Travel" is the total variation of the signal sequence — the sum of
    absolute successive differences. No continuity is assumed.
  · The first flip of a trajectory is free (the start posture carries no
    anchor); every subsequent flip is charged. Hence the −1 in S3.

  Adoption path: these theorems verify sentences of §9.2 already in the
  specification ("formal hysteresis", "prevents enforcement chatter");
  no new mechanism is introduced (Companion A Principle 19.2). On
  adoption, S3 belongs beside T9 in Module 1 and the T9 gloss should
  narrow from "cycling" to "simultaneous escalate/de-escalate".

  Status: DRAFT for Phase 2 review. Not part of the circulated Phase 1
  packet; the packet's source digest is unchanged by this file.

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-11.
-/
import AHCKernel.TieredProtocol

namespace AHC.Phase2

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

/-! ## The posture machine -/

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

/-- **S3 (Chatter Requires Travel — headline).** Over ANY signal
    trajectory from ANY starting posture, all flips beyond the first are
    paid for by total variation: `(flips − 1) · (gapWidth + 1) ≤ travel`.
    Contrapositive, as §9.2 means it: bounded-variation noise strictly
    inside the band can flip the enforcement posture at most once, ever.
    N oscillations demand the signal genuinely traverse the full band N
    times — chatter is a property of large real swings, not of noise or
    of scheduling. This, not instantaneous exclusivity (T9), is the
    anti-cycling content of the hysteresis gap; the gap width appears in
    the bound, so a degenerate band provably buys no protection. -/
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

end AHC.Phase2
