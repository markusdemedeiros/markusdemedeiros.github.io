---
title:  "What makes Iris tick? 1: Algebra"
date: ''
content: 'Iris'
...

Iris is a sizable Coq development, clocking in at around 37Kloc. 

Despite the fact that I work with Iris every day Iris' implementation still feels
deeply mysterious to me. 

To fix this, I want to fully read through the Iris source code. 

This post contains loosely structured notes I'm taking thoughout this process. 

The main questions I want to answer are:
- What are the main definitions and lemmas in Iris? 
- Which features depend on which subsets of Iris definitions?
- Which proofs in Iris are challenging, and why?
- How do the features from the Iris papers translate into the formal development?

I will make very little effort to editorialize these posts, mainly because I don't know
enough to do that. 
I expect that I will edit these posts as I understand more about the project.

## Orienteering 

Below is the inter-module dependency graph [generated from the CoqProject file](https://gist.github.com/markusdemedeiros/b029c5c74ec24bae93d093f7da1ab01f)
of Iris. 

The plan is to work through the above graph in bottom-up order, skipping the modules that are 
either devoid of interesting content, or unstable. 

(Graph here)

We will fix the Iris version to the one I downloaded on August 20th, 2024 (commit hash ``657b34ad877f1ba22414e0e85ad2a49e56a188e0``).

## Algebra

### ofe.v
- Unbundled version:
  - `Dist A` class (w/ `dist : nat -> relation A` constructor): shallow embedding of OFE's in Coq
  - Inerits `Equiv` (stdpp, notated with triple equals, works with stdpp rewrites)
  - OFE rules (monotonicity, equivalence relation, equal implies related) in `OfeMixin` record
- Bundled version: the structure `ofe` 
  - Has coercion to carrier type
- `NonExpansive` is notation for `Proper`; allows setoid rewriting
- Discrete OFE: OFE w/ 0 relation is equivalence
- `chain (a : ofe)`: a sequence `c` w/ `forall n ≤ m, c(n) =[n]= c(m)`
- `chain_map`: map non-expansive function through chain
- `cofe` : `ofe` with `compl` limit function.
  - `compl c =[n]= c(n)` for all `n`
  - limits commute with `chain_map` 
- Many lemmas related to rewriting
- Many lemmas related to elementary properties of ofe/cofe/chain
- Contractive functions
  - `dist_later`: indexed relation, equiv for all `m` less than `n`
    - What is this doing? If `p` equiv `q` at `n`, then `dist_later (n+1) p q` because they're related at every index strictly less than `n+1`.
  - `dist_later_fin`: equivalent, computational
  - `Contractive` is `Proper` for `(dist_later n ==> dist n)`
- Tactics and notations for proving contractivity
- Limit preserving predicate: true at all points in chain implies true at limit
  - Limit preservation proofs for some basic logical connectives
- Iterating a contractive function gives a chain
- `fixpoint`: limit of a chain of iterates in a cofe
  - Q: If we can define this, does that mean we only need the classic fixpoint theorems to prove that an OFE is a COFE? 
  - Limit lemmas 
  - Fixpoint induction
    ```
     Lemma fixpoint_ind (P : A → Prop) :
      Proper ((≡) ==> impl) P →
      (∃ x, P x) → (∀ x, P x → P (f x)) →
      LimitPreserving P →
      P (fixpoint f). 
    ```
    How does this proof work? 
- Fixpoints for K-iterates (not sure why this is so special)
- Mutual fixpoints
- Space of non-expansive morphisms `ofe_mor`
  - This itself is an OFE, and a COFE when result type is COFE. 
  - OFE morphisms include identity, constant, and composition
- They construct a bunch of (C)OFE's, but they call them "types". Why?
  - The "type" is the carrier type of the OFE
  - Nothing to do with CCC? 
- Unit, empty, product, sum OFE's from OFE's
- Confusing: OFE->COFE functor
  - What is this doing? 
- Discrete OFE from equivalence 
- Leibniz OFE: relationship is equality (OFE is discrete)
- Discrete OFE over Prop using iff 
- Option type
- `later`: record w/ one field and ctor `Next`
  - OFE: `dist_later` on the carriers
  - `Next` is contractive
  - `later` over COFE is a COFE: limit is `Next` of limit.
  - Some subtlety about `inj` and `uninj`? Not sure what they're getting at
  - Classification of contractive functions `contractive_alt`: can rewrite all contractive functions as the later of a non-expansive funciton.
- (skim) constructions for other types:
  - Dependent functions over a discrete OFE domain `-d>`
  - OFE from isomrphism (what?)
  - Many dependent and non-dependent Sigma types

### cofe_solver.v

This file is quite confusing, and I'm can't make sense of the intermediate definitions.

The file seems to be in service of constructing `Solution` for an `oFunctor`, which is a `cofe` that is the fixpoint of the `oFunctor`.

There are some items in the context for this construction: including that the functor takes `cofe`'s to `cofe`'s, and is `oFunctorContractive`.

### monoid.v

- Monoid definition with type, operation as parameters, but unit bundled.
- Instance for Proper and RightId
- Weak monoid homomorphism typeclass: monoid homomorphism which may not preserve unit
- Monoid homomorphism: does preserve unit.
- Monoid homomorphisms are paramaterized by a generic preorder, and must be non-expansive. 



