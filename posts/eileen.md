---
title:  'Eileen: A plan for Iris in Lean'
date: 'Unpublished'
content: 'Lean'
...

Iris is a world-class framework for developing verified program logics. 


(TODO: More about Iris)


(TODO: More about Lean)


Why do we want Iris in Lean? 

- **Enhanced metaprogramming**. 

- **Performance**.

- **Hindsight**. Iris is the best in its class, but it is also the first in its class. A reimplementation (in any language) gives us the opportunity to re-evaluate the features which are useful from Iris in Lean, and open up areas where we think Iris can grow. 

Why do *I* want to write Iris in Lean?

- As a Lean user, I want to understand the mechanization techniques that makes large verification projects possible. 

- As an Iris user, I want to deeply understand the components of Iris. 

- As a researcher into probabilistic verification, I want to write program logics that can make use of the extensive probability theory development in Mathlib. 

This project, dubbed *Eileen* (a ?? of iLean), is my attempt to realize this vision. 


## The Road to Iris in Lean 

Since this project is larger than anything I've tried before, a realistic plan to reimplement Iris in Lean must have off-ramps at several points in the project where failure does not mean I've wasted my time (unlike a rote translation effort, for example).

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

To get my bearings in this development, I will go through each file in dependency order, and write a deliberately over-simplified summary of its contents.
This is far from a complete summary of the Iris development, but I feel that it is a necessary step in developing a realistic plan for the project. 


### ``iris/prelude/``
    (TODO: Insert dependency graph)
    
| File        | Description                |
|-------------|----------------------------|
| `options.v` | Global Rocq configuration. |
| `prelude.v` | Global coercions.          |


### ``iris/algebra/``

(TODO: Insert dependency graph)
    
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
| `auth.v`                |                                                                                                                                   |
| `reservation_map.v`     | CMRA for partial functions + permission to add entries.                                                                           |
| `dyn_reservation_map.v` | CMRA for partial functions + permission to add an unbounded number of fresh entries.                                              |


### ``iris/algebra/lib/``

(TODO: Insert dependency graph)
    
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

### ``iris/bi/``

(TODO: Insert dependency graph)
    
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

### ``iris/si_logic/``

(TODO: Insert dependency graph)
    
| File       | Description                                                                       |
|------------|-----------------------------------------------------------------------------------|
| `siprop.v` | Pure, Nat-indexed Prop, COFE and BI defs. Soundness for pure, internal eq, later. |
| `bi.v`     | BI TC instances for siProp.                                                       |

### ``iris/bi/lib``

(TODO: Insert dependency graph)
    
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

### ``iris/base_logic/``

(TODO: Insert dependency graph)
    
| File           | Description                                                                                                    |
|----------------|----------------------------------------------------------------------------------------------------------------|
| `upred.v`      | uPred for general UCMRA, COFE + BI defs. Nonexpansive and proof rules. Soundness for later, pure, internal eq. |
| `bi.v`         | BI TC instances for upred.                                                                                     |
| `derived.v`    | Derived laws, TC instances for valid. Soundness for bupd, modalities.                                          |
| `algebra.v`    |                                                                                                                |
| `proofmode.v`  | Pure and splitting TC instances for uPred.                                                                     |
| `base_logic.v` | Exports.                                                                                                       |
| `bupd_alt.v`   |                                                                                                                |

### ``iris/base_logic/lib/``

(TODO: Insert dependency graph)
    
| File                      | Description                                                                                                     |
|---------------------------|-----------------------------------------------------------------------------------------------------------------|
| `fancy_update_from_vs.v`  | Fancy updates as view shift.                                                                                    |
| `iprop.v`                 | iProp: solution to uPred recurrence. TC for GFunctors: lists of locally contractive rFunctors. iPropO: the OFE. |
| `own.v`                   |                                                                                                                 |
| `token.v`                 |                                                                                                                 |
| `ghost_map.v`             |                                                                                                                 |
| `ghost_var.v`             |                                                                                                                 |
| `mono_nat.v`              |                                                                                                                 |
| `saved_prop.v`            |                                                                                                                 |
| `proph_map.v`             |                                                                                                                 |
| `gset_bij.v`              |                                                                                                                 |
| `wsat.v`                  |                                                                                                                 |
| `later_credits.v`         |                                                                                                                 |
| `fancy_updates.v`         |                                                                                                                 |
| `invariants.v`            |                                                                                                                 |
| `na_invariants.v`         |                                                                                                                 |
| `cancelable_invariants.v` |                                                                                                                 |
| `boxes.v`                 |                                                                                                                 |
| `gen_heap.v`              |                                                                                                                 |
| `gen_inv_heap.v`          |                                                                                                                 |

### ``iris/program_logic/``

(TODO: Insert dependency graph)
    
| File                   | Description |
|------------------------|-------------|
| `language.v`           |             |
| `weakestpre.v`         |             |
| `total_weakestpre.v`   |             |
| `adequacy.v`           |             |
| `total_adequacy.v`     |             |
| `atomic.v`             |             |
| `lifting.v`            |             |
| `extx_langauge.v`      |             |
| `extxi_langauge.v`     |             |
| `extx_lifting.v`       |             |
| `ownp.v`               |             |
| `total_lifting.v`      |             |
| `total_extx_lifting.v` |             |

### ``iris/heap_lang/``

(TODO: Insert dependency graph)
    
| File                | Description |
|---------------------|-------------|
| `locations.v`       |             |
| `lang.v`            |             |
| `notation.v`        |             |
| `pretty.v`          |             |
| `metatheory.v`      |             |
| `tactics.v`         |             |
| `class_instances.v` |             |
| `proph_erasure.v`   |             |
| `primitive_laws.v`  |             |
| `derived_laws.v`    |             |
| `proofmode.v`       |             |
| `adequacy.v`        |             |
| `total_adequacy.v`  |             |


# What's next?
- Unstable?
- SI logic: possible milestone
- excl: possible milestone
- weakestpre: possible milestone
