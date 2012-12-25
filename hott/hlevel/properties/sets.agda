{-# OPTIONS --without-K #-}
module hott.hlevel.properties.sets where

open import decidable
open import sum
open import equality
open import function using (id; const)
open import sets.empty
open import sets.unit
open import hott.hlevel

-- ⊤ is contractible
⊤-contr : h 0 ⊤
⊤-contr = tt , c
  where
    c : (x : ⊤) → tt ≡ x
    c tt = refl

-- ⊥ is propositional
⊥-prop : h 1 ⊥
⊥-prop x _ = ⊥-elim x

-- Hedberg's theorem
hedberg : ∀ {i} {A : Set i}
        → ((x y : A) → Dec (x ≡ y))
        → h 2 A
hedberg {A = A} dec x y = isProp⇒h1 (x ≡ y) prop
  where
    open ≡-Reasoning

    canonical : {x y : A} → x ≡ y → x ≡ y
    canonical {x} {y} p with dec x y
    ... | yes q = q
    ... | no _ = p

    canonical-const : {x y : A}
                    → (p q : x ≡ y)
                    → canonical p ≡ canonical q
    canonical-const {x} {y} p q with dec x y
    ... | yes _ = refl
    ... | no f = ⊥-elim (f p)

    canonical-inv : {x y : A}(p : x ≡ y)
                  → canonical p ⊚ sym (canonical refl) ≡ p
    canonical-inv refl = left-inverse (canonical refl)
  
    prop : {x y : A}(p q : x ≡ y) → p ≡ q
    prop p q = begin
        p
      ≡⟨ sym (canonical-inv p) ⟩
        canonical p ⊚ sym (canonical refl)
      ≡⟨ cong (λ z → z ⊚ sym (canonical refl))
              (canonical-const p q) ⟩
        canonical q ⊚ sym (canonical refl)
      ≡⟨ canonical-inv q ⟩
        q
      ∎

-- Bool is a set
private
  module BoolSet where
    open import sets.bool
    bool-set : h 2 Bool
    bool-set = hedberg _≟_
open BoolSet public

-- Nat is a set
private
  module NatSet where
    open import sets.nat
    nat-set : h 2 ℕ
    nat-set = hedberg _≟_
open NatSet public

-- Fin is a set
private
  module FinSet where
    open import sets.fin
    fin-set : ∀ n → h 2 (Fin n)
    fin-set n = hedberg _≟_
open FinSet public