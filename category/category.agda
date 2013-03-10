{-# OPTIONS --without-K #-}

module category.category where

open import level using (Level ; lsuc ; _⊔_)
open import sum
open import equality.core
open import hott.hlevel

open import category.structure
import category.graph as Graph

record IsCategory {i j}(X : Set i) : Set (lsuc (i ⊔ j)) where
  field
    is-gph : Graph.IsGraph {i}{j} X

  open Graph.IsGraph is-gph
  field
    id : (A : X) → hom A A
    _∘_ : {A B C : X} → hom B C → hom A B → hom A C

    left-unit : {A B : X}(f : hom A B)
              → id B ∘ f ≡ f
    right-unit : {A B : X}(f : hom A B)
               → f ∘ id A ≡ f
    associativity : {A B C D : X}
                    (f : hom A B)
                    (g : hom B C)
                    (h : hom C D)
                  → (h ∘ g) ∘ f ≡ h ∘ (g ∘ f)


record Category (i j : Level) : Set (lsuc (i ⊔ j)) where
  field
    obj : Set i
    is-cat : IsCategory {i}{j} obj

  open IsCategory is-cat
  open Graph.IsGraph is-gph

  field
    trunc : ∀ x y → h 2 (hom x y)

  open Graph.IsGraph is-gph public
  open IsCategory is-cat public

-- opposite category
op : ∀ {i j} → Category i j → Category i j
op C = record
  { obj = obj
  ; is-cat = record
    { is-gph = record { hom = flip hom }
    ; id = id
    ; _∘_ = flip _∘_
    ; left-unit = right-unit
    ; right-unit = left-unit
    ; associativity = λ f g h → sym (associativity h g f) }
  ; trunc = flip trunc }
  where
    open Category C
    open import function.core
      using (flip)

-- interface

module cat-interface {i j} ⦃ st : Structure {lsuc (i ⊔ j)}
                                            (IsCategory {i}{j}) ⦄
                           (C : Structure.Sort st) where
  open IsCategory (Structure.struct st C)
  open Graph.IsGraph is-gph

  private X = Structure.obj st C
  open import function.core
    using (Composition; Identity)

  category-comp : Composition _ _ _ _ _ _
  category-comp = record
    { U₁ = X
    ; U₂ = X
    ; U₃ = X
    ; hom₁₂ = λ x y → hom x y
    ; hom₂₃ = λ x y → hom x y
    ; hom₁₃ = λ x y → hom x y
    ; _∘_ = λ f g → f ∘ g }

  category-identity : Identity _ _
  category-identity = record
    { U = X
    ; endo = λ x → hom x x
    ; id = λ {x} → id x }

  open overloaded IsCategory C public

open Graph

graph : ∀ {i j}
      → ⦃ st : Structure {lsuc (i ⊔ j)} (IsCategory {i}{j}) ⦄
      → Structure.Sort st → Graph.Graph i j
graph ⦃ st ⦄ C = record
  { obj = Structure.obj st C
  ; is-gph = IsCategory.is-gph (Structure.struct st C) }

cat-cat-instance : ∀ {i j} → Structure IsCategory
cat-cat-instance {i}{j} = record
  { Sort = Category i j
  ; obj = Category.obj
  ; struct = Category.is-cat }

cat-gph-instance : ∀ {i j} → Structure IsGraph
cat-gph-instance {i}{j} = record
  { Sort = Category i j
  ; obj = Category.obj
  ; struct = λ C → Graph.is-gph (graph C) }

module CategoryInterface {i j} ⦃ sub : IsSubtype {lsuc (i ⊔ j)}
                                       (IsCategory {i}{j}) ⦄ where
  open import function.core public
  open IsSubtype sub
  open IsCategory structure public
    hiding (is-gph; _∘_; id)
open CategoryInterface public
