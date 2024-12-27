---
title:  'Eileen: A plan for Iris in Lean'
date: 'Unpublished'
content: 'Lean'
...

Iris is a world-class framework for developing verified program logics. 
It has seen wide adoption in a number of fields and boasts an impressive list of publications. 

Lean is a interactive theorem prover which has seen widespread popularity. 

Iris is written in Rocq, not Lean. 
However, I think there's a case to be made that a reimplementation of some of the ideas 

- **Enhanced metaprogramming**. Lean is implemented in Lean itself, and anecdotally, the metaprogramming experience in Lean is far superior to Roqc. Rather than using bespoke langauges such as LTac, a Lean metaprogrammer can use the full extent of the Lean functional programming language to write tactics, commands, 

- **Hindsight**. Iris is the best in its class, but it is also the first in its class. A reimplementation (in any language) gives us the opportunity to re-evaluate the features which are useful from Iris in Lean, and open up areas where we think Iris can grow. 

- **Mathematical Interest**. The categorical theory underlying Iris's model in Rocq may be of independent interest to mathematicians working on Mathlib. 
Dually, the mathlib contributors may develop

While attractive, these advantages have not inspired a sustained attempt to formalize a logic such as Iris in Lean. 
A reimplementation is a massive undertaking 
Unfortunately, over the past few months I have come to realize that *I* might be just the right person to convince himself that it's worth it:

- As an Iris user, I want to deeply understand the components of Iris (aspirationally) to the degree that I could reimplement them.

- As a Lean user, I want to understand the mechanization techniques that makes large, collaborative verification projects feasible and sustainable. 

- As a researcher into probabilistic verification I want to give myself the right tools for developing program logics based around classical mathematical techniques.
For example, I want to make use of verified probability theory, which is extensively developed in Mathlib. 


This project, dubbed *Eileen* (a ?? of iLean), is my attempt to realize this vision. 


## The Road to Iris in Lean 

Since this project is larger than anything I've tried before, I've decided that a realistic commitment to this project involves coming up with "off ramps" 


a realistic plan to reimplement Iris in Lean must have off-ramps at several points in the project where failure does not mean I've wasted my time (unlike a rote translation effort, for example).

### Preparation
- Prior Art
  + Read (and annotate) the main line of Iris papers
  + Learn about metaprogramming in Lean
  + Learn about how Mathlib organizes large mathematical developments. For example, how they structure their typeclass hierarchies.
  + Read the existing Lean Iris paper.
- Planning
  + Take inventory of the existing Iris development
  + Plan realistic milestones, including the smallest number of theorems and definitions to implement them (in dependency order)
 
Over the last few months, I have focused on the reading the past literature, and improving my skills as a Lean developer. 

This blog post will take the next step: starting the planning phase of this project. 

## An Inventory of Iris

There are 164 files in Iris, organized into 17 modules, and including approximately ?? lines of code. 


(TODO: Link depgraph script)
(TODO: Mark commit hash)


(TODO: Insert dependency graph)

<p align="center">
![](../img/iris_deps/overview.svg "Dependency graph: Overview"){#id .class width=100%} 
</p>

To get my bearings in this development, I will go through each file in dependency order, and write a deliberately over-simplified summary of its contents.
This is far from a complete summary of the Iris development, but I feel that it is a necessary step in developing a realistic plan for the project. 


___

## ``iris/prelude/``

<p align="center">
![](../img/iris_deps/iris_prelude.svg "Dependency graph: prelude"){#id .class width=30%} 
</p>

| File        | Description                |
|-------------|----------------------------|
| `options.v` | Global Rocq configuration. |
| `prelude.v` | Global coercions.          |

&nbsp;

--- 

## ``iris/algebra/``

<p align="center">
![](../img/iris_deps/iris_algebra.svg "Dependency graph: algebra"){#id .class width=100%} 
</p>

| File                    | Description                                                                                                                       |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `ofe.v`                 | OFE/COFE structures, nonexpansive/contractive maps, fixpoints, oFunctors, (C)OFE-(iso)morphisms, OFEs based on types/laters.      |
| `cofe_solver.v`         | COFE fixpoint of oFunctor.                                                                                                        |
| `monoid.v`              | Semi-bundled nonexpansive monoids, and morphisms. Used for big ops.                                                               |
| `cmra.v`                | Variants of CMRA structures, properties of CMRA elements, morphisms, COFE to CMRA functors, resource algebra. CMRA constructions. |
| `excl.v`                | The excl COFE/CMRA.                                                                                                               |
| `big_op.v`              | Iterated monoid operation over finite structures. Morphisms and laws.                                                             |
| `cmra_big_op.v`         | Laws for big op with option OFE.                                                                                                  |
| `updates.v`             | (Nondeterministic) frame-perserving updates. FP updates based on type.                                                            |
| `local_updates.v`       | Local updates, laws, and constructions.                                                                                           |
| `gset.v`                | CMRAs of sets of countable type: union and disjoint union.                                                                        |
| `gmultiset.v`           | CMRA for multisets of countable type.                                                                                             |
| `coPset.v`              | CMRAs of sets of countable type: union and disjoint union.                                                                        |
| `csum.v`                | OFE/COFE/CMRA construction: sum with bottom.                                                                                      |
| `mra.v`                 | Lift preorder to CMRA.                                                                                                            |
| `list.v`                | (C)OFE of lists. Nonexpansisivity of list functions.                                                                              |
| `functions.v`           | Laws for discrete function OFE, into UCMRA or OFE.                                                                                |
| `sts.v`                 | STS RA (historical).                                                                                                              |
| `proofmode_classes.v`   | Typeclass reflection of monoid op.                                                                                                |
| `numbers.v`             | RA of number types with arithmetic ops.                                                                                           |
| `frac.v`                | Leibniz RA of rationals `0 < q <= 1` with add op.                                                                                 |
| `ufrac.v`               | Leibniz RA of rationals `0 < q` with add op.                                                                                      |
| `dfrac.v`               | Leibniz RA of discardable fractions.                                                                                              |
| `gmap.v`                | COFE/CMRA of gmap (lifts value OFE pointwise). Laws for basic gmap operations.                                                    |
| `vector.v`              | Vector OFEs (same as list).                                                                                                       |
| `agree.v`               | Agreement OFE: Lists are n-equiv when each element has an n-equiv counterpart.                                                    |
| `max_prefix_list.v`     | Partial OFE on lists, where `X ⋅ X ++ Y = X ++ Y`.                                                                                |
| `view.v`                |                                                                                                                                   |
| `auth.v`                | Auth CMRA.                                                                                                                        |
| `reservation_map.v`     | CMRA for partial functions + permission to add entries.                                                                           |
| `dyn_reservation_map.v` | CMRA for partial functions + permission to add an unbounded number of fresh entries.                                              |

&nbsp;

---

## ``iris/algebra/lib/``

<p align="center">
![](../img/iris_deps/iris_algebra_lib.svg "Dependency graph: algebra/lib"){#id .class width=100%} 
</p>

| File            | Description                                                                        |
|-----------------|------------------------------------------------------------------------------------|
| `frac_auth.v`   | Auth CMRA, with splittable fractional part rather than auth part.                  |
| `mono_list.v`   | Auth CMRA over max prefix list CMRA.                                               |
| `mono_nat.v`    | Auth CMRA over max Nat CMRA.                                                       |
| `mono_Z.v`      | Auth CMRA over max Z CMRA.                                                         |
| `gmap_view.v`   | Auth CMRA over map: frags are RW access to single entries, or persistent R access. |
| `gset_bij.v`    |                                                                                    |
| `ufrac_auth.v`  |                                                                                    |
| `excl_auth.v`   |                                                                                    |
| `dfrac_agree.v` |                                                                                    |

&nbsp;

---

## ``iris/bi/``

<p align="center">
![](../img/iris_deps/iris_bi.svg "Dependency graph: bi"){#id .class width=50%} 
</p>

| File                    | Description                                                                     |
|-------------------------|---------------------------------------------------------------------------------|
| `notation.v`            | Reserved notations.                                                             |
| `interface.v`           | Axioms of BI/+Persistency/+Later. ``bi`` structure bundles syntax + axioms.     |
| `derived_connectives.v` | Defines affinely, absorbingly, intuitionistically, except 0, timeless, later n. |
| `weakestpre.v`          | Class and notations for WP, TWP.                                                |
| `extensions.v`          | Axioms+TC for additional rules to ``bi``.                                       |
| `derived_laws.v`        | Derived ``bi`` laws.                                                            |
| `derived_laws_later.v`  | Derived ``bi`` laws about step indexing. Löb and variants. Other modal laws.    |
| `big_op.v`              | Big sep, and, or, over finite types.                                            |
| `internal_eq.v`         | Axioms+TC for BI with internal equality that respects step indexing.            |
| `plainly.v`             | Axioms+TC for BI with plainly modality. Laws.                                   |
| `updates.v`             | Axioms+TC for BI with bupd, fupd. Laws, laws involving persistently.            |
| `ascii.v`               | Notation.                                                                       |
| `embedding.v`           | Axioms+TC for embedding one ``bi`` in another.                                  |
| `bi.v`                  | Exports.                                                                        |
| `telescopes.v`          |                                                                                 |
| `monopred.v`            |                                                                                 |

&nbsp;

---

## ``iris/si_logic/``

<p align="center">
![](../img/iris_deps/iris_si_logic.svg "Dependency graph: si_logic"){#id .class width=30%} 
</p>
    
| File       | Description                                                                       |
|------------|-----------------------------------------------------------------------------------|
| `siprop.v` | Pure, Nat-indexed Prop, COFE and BI defs. Soundness for pure, internal eq, later. |
| `bi.v`     | BI TC instances for siProp.                                                       |

&nbsp;

---

## ``iris/bi/lib``

<p align="center">
![](../img/iris_deps/iris_bi_lib.svg "Dependency graph: bi/lib"){#id .class width=80%} 
</p>
    
| File                | Description                                                       |
|---------------------|-------------------------------------------------------------------|
| `counterexamples.v` | Paradoxes.                                                        |
| `laterable.v`       |                                                                   |
| `fixpoint.v`        | Derived lfp and gfp of a monotone function, induction principles. |
| `relations.v`       | Closure, iterate of relations. Internal, with internal eq.        |
| `atomic.v`          |                                                                   |
| `cmra.v`            | Internalize included, given internal equality.                    |
| `fractional.v`      |                                                                   |
| `core.v`            | TC for core of a prop. Internal.                                  |

&nbsp;

---

## ``iris/base_logic/``

<p align="center">
![](../img/iris_deps/iris_base_logic.svg "Dependency graph: base_logic"){#id .class width=50%} 
</p>

| File           | Description                                                                                                    |
|----------------|----------------------------------------------------------------------------------------------------------------|
| `upred.v`      | uPred for general UCMRA, COFE + BI defs. Nonexpansive and proof rules. Soundness for later, pure, internal eq. |
| `bi.v`         | BI TC instances for upred.                                                                                     |
| `derived.v`    | Derived laws, TC instances for valid. Soundness for bupd, modalities.                                          |
| `algebra.v`    | *Internalizes properties of CMRA.*                                                                             |
| `proofmode.v`  | Pure and splitting TC instances for uPred.                                                                     |
| `base_logic.v` | Exports.                                                                                                       |
| `bupd_alt.v`   | *Alternate bupd definition.*                                                                                   |

&nbsp;

---

## ``iris/base_logic/lib/``

<p align="center">
![](../img/iris_deps/iris_base_logic_lib.svg "Dependency graph: base_logic/lib"){#id .class width=100%} 
</p>

| File                      | Description                                                                                                                       |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `fancy_update_from_vs.v`  | Fancy updates as view shift.                                                                                                      |
| `iprop.v`                 | iProp: solution to uPred recurrence. TC for GFunctors: lists of locally contractive rFunctors, for the solution. iPropO: the OFE. |
| `own.v`                   | TC for CMRA being in GFunctors. Definition of ghost ownership. Updates, allocation.                                               |
| `token.v`                 | GFunctor for unique ownership of symbol.                                                                                          |
| `ghost_map.v`             | GFunctor for ghost heap.                                                                                                          |
| `ghost_var.v`             | GFunctor for ghost mutable variable.                                                                                              |
| `mono_nat.v`              | GFunctor for auth/frag of mono nat/lower bound.                                                                                   |
| `saved_prop.v`            |                                                                                                                                   |
| `proph_map.v`             |                                                                                                                                   |
| `gset_bij.v`              |                                                                                                                                   |
| `wsat.v`                  | *Related to world satisfaction style modalities.*                                                                                 |
| `later_credits.v`         | GFunctor for later credits. Later update modality.                                                                                |
| `fancy_updates.v`         | GFunctor for fupd. Laws & soundness (dependent on later credits). GFunctor for enabling invariants.                               |
| `invariants.v`            | Internal construction of invariants.                                                                                              |
| `na_invariants.v`         | GFunctor for non-atomic invariants.                                                                                               |
| `cancelable_invariants.v` | GFunctor for cancelable invariants.                                                                                               |
| `boxes.v`                 |                                                                                                                                   |
| `gen_heap.v`              | GFunctor for physical heap.                                                                                                       |
| `gen_inv_heap.v`          | GFunctor for heap of invariants (persistent).                                                                                     |


# What's next?
- Unstable?
- SI logic: possible milestone
- excl: possible milestone
- weakestpre: possible milestone
