/-
  AHC Verified Constitutional Kernel — Module 3
  Byzantine Measurement Consensus  (AHC v3.1 §8.3)
  Axiom I — Intersectional Viability / Null Kernel  (AHC v3.1 §4.1, §1.1)

  Machine-checked invariants of measurement and aggregation:

    B1  honest_strict_majority   — under the m > 2f+1 quorum, honest sensors
                                   outnumber corrupted ones by at least two
    B2  exists_honest_le/ge      — pigeonhole core: any f+1 readings at or
                                   below (above) a value include an honest one
    B3  median_bracketed         — any median-type statistic over the ensemble
                                   is bracketed by honest readings on BOTH
                                   sides: a coalition of ≤ f captured sensors
                                   cannot drag the derived threshold outside
                                   the envelope of honest measurement
    B4  no_corrupt_certificate   — no coalition of ≤ f corrupted sensors can
                                   certify a fabricated reading: any value
                                   attested by f+1 sensors is attested by an
                                   honest one
    A1a axiomI_null_kernel       — intersection form: one subgraph outside its
                                   viability bounds nullifies global viability,
                                   whatever every other subgraph reports
    A1b axiomI_no_compensation   — global viability certifies each subgraph
    A1c null_kernel_product      — product form: a zero anywhere in the signal
                                   vector forces the global signal to zero,
                                   for EVERY prefix and suffix
    A1d globalSignal_pos_iff     — the global signal is nonzero exactly when
                                   every subgraph signal is
    A1e sum_admits_masking       — the contrast theorem: aggregation by SUM
                                   provably admits the Korematsu Illusion
                                   (§1.1); a witness is exhibited. The choice
                                   of ∏ over Σ is what A1c/A1d verify.

  Modeling choices:
  · A sensor is a pair (reading, isHonest) : Nat × Bool. Honesty is ground
    truth unavailable to the system — which is exactly why the theorems
    quantify over ALL placements of ≤ f corrupted sensors.
  · `Ensemble.quorum` carries the spec's m > 2f+1 as a proof obligation: an
    under-provisioned sensor network is unconstructible. (The bracketing
    math needs only m ≥ 2f+1; the spec's stricter bound provides slack,
    reflected in B1's margin of two.)
  · A "median-type statistic" is any x with at least ⌈m/2⌉ readings ≤ x and
    ⌈m/2⌉ readings ≥ x. This is order-statistics-free: the theorems hold
    for the median, and for anything with the median's counting property.

  Scope disclaimer: these proofs verify the specification, not the world.
  In particular, sensor independence (the hypothesis that at most f are
  corrupted) is an institutional achievement, not a theorem — see OP.1.

  Toolchain: Lean 4.15.0, core only (no Mathlib). Checked 2026-07-11.
-/

namespace AHC

/-! ## Sensors and ensembles -/

/-- A sensor report: (reading, isHonest). -/
abbrev Sensor := Nat × Bool

/-- Number of corrupted sensors in a list. -/
def dishonestCount (l : List Sensor) : Nat :=
  (l.filter (fun s => !s.2)).length

/-- Number of honest sensors in a list. -/
def honestCount (l : List Sensor) : Nat :=
  (l.filter (fun s => s.2)).length

/-- Readings at or below `x`. -/
def countLE (x : Nat) (l : List Sensor) : Nat :=
  (l.filter (fun s => decide (s.1 ≤ x))).length

/-- Readings at or above `x`. -/
def countGE (x : Nat) (l : List Sensor) : Nat :=
  (l.filter (fun s => decide (x ≤ s.1))).length

/-- Readings equal to `v`. -/
def countEQ (v : Nat) (l : List Sensor) : Nat :=
  (l.filter (fun s => decide (s.1 = v))).length

/-- A sensor ensemble under the §8.3 quorum condition. Both conditions are
    carried as proof obligations: an under-provisioned or over-corrupted
    ensemble cannot be constructed. -/
structure Ensemble (f : Nat) where
  sensors : List Sensor
  quorum : 2 * f + 1 < sensors.length
  faultBound : dishonestCount sensors ≤ f

/-! ## Counting lemmas (self-contained; no Mathlib) -/

/-- Every sensor is honest or dishonest; the counts partition the ensemble. -/
theorem honest_dishonest_split (l : List Sensor) :
    honestCount l + dishonestCount l = l.length := by
  unfold honestCount dishonestCount
  induction l with
  | nil => rfl
  | cons s t ih =>
      by_cases hs : s.2
      · have h2 : s.2 = true := hs
        simp [List.filter_cons, h2]
        omega
      · have h2 : s.2 = false := by
          cases hv : s.2 with
          | true => exact absurd hv hs
          | false => rfl
        simp [List.filter_cons, h2]
        omega

/-- Filtering first can only shrink a count: `l.filter p` is a sublist of
    `l`, sublists filter to sublists, and sublists are no longer. -/
theorem length_filter_filter_le {α : Type} (p q : α → Bool) (l : List α) :
    ((l.filter p).filter q).length ≤ (l.filter q).length :=
  ((l.filter_sublist (p := p)).filter q).length_le

/-- Pigeonhole: a list longer than its count of failures contains a success. -/
theorem exists_true_of_few_false {α : Type} (p : α → Bool) :
    ∀ (l : List α) (f : Nat),
      (l.filter (fun a => !p a)).length ≤ f →
      f + 1 ≤ l.length →
      ∃ a, a ∈ l ∧ p a = true := by
  intro l
  induction l with
  | nil =>
      intro f _ hl
      simp only [List.length_nil] at hl
      omega
  | cons a t ih =>
      intro f hd hl
      by_cases hp : p a
      · exact ⟨a, List.mem_cons_self .., hp⟩
      · have hpa : p a = false := by
          cases hv : p a with
          | true => exact absurd hv hp
          | false => rfl
        simp [List.filter_cons, hpa] at hd
        simp only [List.length_cons] at hl
        have ⟨b, hb, hpb⟩ := ih (f - 1) (by omega) (by omega)
        exact ⟨b, List.mem_cons_of_mem a hb, hpb⟩

/-- The pigeonhole core, specialized to honesty: among any f+1 sensors
    satisfying a predicate, at least one is honest — provided the whole
    ensemble contains at most f corrupted sensors. -/
theorem exists_honest_where (l : List Sensor) (q : Sensor → Bool) (f : Nat)
    (hd : dishonestCount l ≤ f) (hc : f + 1 ≤ (l.filter q).length) :
    ∃ s, s ∈ l ∧ s.2 = true ∧ q s = true := by
  have hd' : ((l.filter q).filter (fun s => !s.2)).length ≤ f :=
    Nat.le_trans (length_filter_filter_le q (fun s => !s.2) l) hd
  have ⟨s, hs, hps⟩ :=
    exists_true_of_few_false (fun s : Sensor => s.2) (l.filter q) f hd' hc
  exact ⟨s, (List.mem_filter.mp hs).1, hps, (List.mem_filter.mp hs).2⟩

/-! ## The Byzantine theorems -/

/-- **B1 (Honest Strict Majority).** Under the §8.3 quorum m > 2f+1, honest
    sensors outnumber corrupted ones by at least two: the consensus
    substrate cannot be a coin flip. -/
theorem honest_strict_majority (f : Nat) (E : Ensemble f) :
    dishonestCount E.sensors + 2 ≤ honestCount E.sensors := by
  have hsplit := honest_dishonest_split E.sensors
  have hq := E.quorum
  have hf := E.faultBound
  omega

/-- **B2a (Honest Witness Below).** If at least f+1 readings sit at or below
    `x`, one of them is honest: `x` does not underestimate all honest
    measurement. -/
theorem exists_honest_le (f : Nat) (E : Ensemble f) (x : Nat)
    (hc : f + 1 ≤ countLE x E.sensors) :
    ∃ s, s ∈ E.sensors ∧ s.2 = true ∧ s.1 ≤ x := by
  have ⟨s, h1, h2, h3⟩ :=
    exists_honest_where E.sensors (fun s => decide (s.1 ≤ x)) f E.faultBound hc
  exact ⟨s, h1, h2, of_decide_eq_true h3⟩

/-- **B2b (Honest Witness Above).** Symmetric: if at least f+1 readings sit
    at or above `x`, one of them is honest. -/
theorem exists_honest_ge (f : Nat) (E : Ensemble f) (x : Nat)
    (hc : f + 1 ≤ countGE x E.sensors) :
    ∃ s, s ∈ E.sensors ∧ s.2 = true ∧ x ≤ s.1 := by
  have ⟨s, h1, h2, h3⟩ :=
    exists_honest_where E.sensors (fun s => decide (x ≤ s.1)) f E.faultBound hc
  exact ⟨s, h1, h2, of_decide_eq_true h3⟩

/-- **B3 (Median Bracketing / Capture Resistance).** Any median-type
    statistic over the ensemble — any `x` with at least ⌈m/2⌉ readings on
    each side — is bracketed by honest readings both below and above. A
    coalition of at most f captured sensors, placed anywhere, reporting
    anything, cannot drag a robust threshold outside the envelope of
    honest measurement. This is the formal content of the ATG's
    resistance to threshold manipulation. -/
theorem median_bracketed (f : Nat) (E : Ensemble f) (x : Nat)
    (h1 : (E.sensors.length + 1) / 2 ≤ countLE x E.sensors)
    (h2 : (E.sensors.length + 1) / 2 ≤ countGE x E.sensors) :
    (∃ s, s ∈ E.sensors ∧ s.2 = true ∧ s.1 ≤ x) ∧
    (∃ s, s ∈ E.sensors ∧ s.2 = true ∧ x ≤ s.1) := by
  have hq := E.quorum
  have hle : f + 1 ≤ countLE x E.sensors := by omega
  have hge : f + 1 ≤ countGE x E.sensors := by omega
  exact ⟨exists_honest_le f E x hle, exists_honest_ge f E x hge⟩

/-- **B4 (No Corrupt Certificate).** No value attested by f+1 or more
    sensors is a pure fabrication: at least one honest sensor attests it.
    Equivalently, a corrupted coalition alone can never assemble a
    certifying quorum for a reading no honest sensor made. -/
theorem no_corrupt_certificate (f : Nat) (E : Ensemble f) (v : Nat)
    (hc : f + 1 ≤ countEQ v E.sensors) :
    ∃ s, s ∈ E.sensors ∧ s.2 = true ∧ s.1 = v := by
  have ⟨s, h1, h2, h3⟩ :=
    exists_honest_where E.sensors (fun s => decide (s.1 = v)) f E.faultBound hc
  exact ⟨s, h1, h2, of_decide_eq_true h3⟩

/-! ## Axiom I — Intersectional Viability (§4.1)

"V_global = ∩ᵢ Vᵢ. If the state trajectory of any subgraph is forced
outside its viability bounds, V_global evaluates to the null kernel
regardless of all other subgraphs." Two renderings: the intersection form
over arbitrary index and state types, and the product form over signal
vectors — plus the contrast theorem showing what the chosen aggregation
operator rules out that summation does not. -/

section AxiomI

variable {σ I : Type}

/-- Global viability is the intersection of subgraph viability predicates. -/
def GlobalViable (V : I → σ → Prop) (s : σ) : Prop := ∀ i, V i s

/-- **A1a (Null Kernel, intersection form).** One subgraph outside its
    viability bounds nullifies global viability — whatever every other
    subgraph reports, however many there are, however well they fare. -/
theorem axiomI_null_kernel (V : I → σ → Prop) (s : σ) (j : I)
    (hj : ¬ V j s) : ¬ GlobalViable V s :=
  fun h => hj (h j)

/-- **A1b (No Compensation).** Global viability certifies every subgraph
    individually: the Rawlsian prohibition on trading one group's floor
    for aggregate gains, as a projection. -/
theorem axiomI_no_compensation (V : I → σ → Prop) (s : σ)
    (h : GlobalViable V s) (j : I) : V j s := h j

end AxiomI

/-- The global signal as a product of subgraph signals (Φ_global = ∏ φ). -/
def globalSignal (φs : List Nat) : Nat := φs.foldr (· * ·) 1

/-- **A1c (Null Kernel, product form).** A single collapsed subgraph —
    wherever it sits in the vector, whatever surrounds it — forces the
    global signal to the null kernel. The quantification over `pre` and
    `post` is the word "regardless" in §4.1, made formal. -/
theorem null_kernel_product (pre post : List Nat) :
    globalSignal (pre ++ 0 :: post) = 0 := by
  induction pre with
  | nil =>
      show 0 * globalSignal post = 0
      exact Nat.zero_mul _
  | cons a t ih =>
      show a * globalSignal (t ++ 0 :: post) = 0
      rw [ih]
      exact Nat.mul_zero a

/-- **A1d (Global Positivity).** The global signal is nonzero exactly when
    every subgraph signal is nonzero: no aggregate health without
    every-subgraph health, and conversely. -/
theorem globalSignal_pos_iff : ∀ (φs : List Nat),
    globalSignal φs ≠ 0 ↔ ∀ x ∈ φs, x ≠ 0 := by
  intro φs
  induction φs with
  | nil =>
      constructor
      · intro _ x hx
        cases hx
      · intro _ h
        exact absurd h (by decide)
  | cons a t ih =>
      have hcons : globalSignal (a :: t) = a * globalSignal t := rfl
      rw [hcons]
      constructor
      · intro h x hx
        have hsplit : ¬(a = 0 ∨ globalSignal t = 0) := by
          intro hc
          apply h
          cases hc with
          | inl h0 => rw [h0]; exact Nat.zero_mul _
          | inr h0 => rw [h0]; exact Nat.mul_zero _
        cases hx with
        | head => exact fun h0 => hsplit (Or.inl h0)
        | tail _ hx' =>
            exact (ih.mp (fun h0 => hsplit (Or.inr h0))) x hx'
      · intro h hz
        cases Nat.mul_eq_zero.mp hz with
        | inl h0 => exact h a (List.mem_cons_self ..) h0
        | inr h0 =>
            exact (ih.mpr (fun x hx => h x (List.mem_cons_of_mem a hx))) h0

/-- **A1e (Sum Admits Masking — the Korematsu contrast).** Aggregation by
    summation provably permits a collapsed subgraph to coexist with a
    healthy aggregate: here is a witness. Together with A1c — which shows
    the product form admits no such witness for ANY vector — this is the
    §1.1 Korematsu Illusion stated as a property of the aggregation
    operator, and the formal reason Φ_global is a product, not a sum. -/
theorem sum_admits_masking :
    ∃ φs : List Nat, 0 ∈ φs ∧ 100 ≤ φs.foldr (· + ·) 0 := by
  refine ⟨[0, 100], ?_, ?_⟩ <;> decide

end AHC
