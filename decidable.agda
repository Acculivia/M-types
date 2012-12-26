
{-# OPTIONS --without-K  #-}

module decidable where

open import level            using (Level)
open import sets.empty using (⊥; ¬_)
open import sets.unit using (⊤)

-- Decidable relations.

data Dec {i} (P : Set i) : Set i where
  yes : ( p :   P) → Dec P
  no  : (¬p : ¬ P) → Dec P

True : ∀ {i}{P : Set i} → Dec P → Set
True (yes _) = ⊤
True (no _) = ⊥

witness : ∀ {i}{P : Set i}{d : Dec P} → True d → P
witness {d = yes x} _ = x
witness {d = no _} ()
