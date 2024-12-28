---
title:  'Eileen: A plan for Iris in Lean'
date: 'Dec 28, 2024'
content: 'Eileen'
...

Iris is a world-class framework for mechanizing program logics in Rocq. 
The framework boasts an impressive list of [publications](https://iris-project.org/#publications), with users applying Iris to wide range of verification problems across the software stack. 
The logic of Iris is the synthesis of a [long line](https://en.wikipedia.org/wiki/Interference_freedom#Dependencies_on_interference_freedom)[^2] of work on separation logic design, and the [Iris implementation](https://gitlab.mpi-sws.org/iris/iris/) is a premier example of proof engineering in Rocq. 

Lean is an interactive theorem prover and functional programming langauge.
Since the release of Lean 4, the language has seen widespread popularity amongst researchers in formal verification and mechanized mathematics. 
Its popularity can be attributed to a number of features, including but not limited to its system of developer tooling, extensive mathematical library, and organized and active communuity. 

Because Iris is not written in Lean, these two groups of mechanization experts cannot directly build off of each other's work. 
As someone interested in program verification and Lean I think this is a shame, and I think that there is a case to be made that both projects would benefit from an implementation of an Iris-like program logic in Lean:

- **Mathematical Interest**. 
Much of Iris is based around the theory of OFE's, a mathematical structure that could be of interest to the Mathlib community. 
Conversely, a version of Iris built upon Mathlib-compatible mathematics could open the door to exploring other mathematical results as Iris continues to grow. 

- **Enhanced (meta)programming**. 
Lean is implemented in Lean itself, and was designed to serve as a standalone functional programming language. 
This means that rather than using bespoke metalanguages such as Ltac, a Lean metaprogrammer can use the full extent of the Lean programming environment to implement tactics, commands, and macros specific to their needs.

- **A Fresh Perspective**. 
Rocq, Lean, and Iris are projects under active development, with their own pros, cons, and quirks.
A second implementation of a substantial project (in any language) gives us the opportunity to contrast them, and generate new ideas for how to improve our tools. 
The process of reimplementing Iris presents an opportunity to distill the key ideas from its implementation, lowering the bar for new contributors to the project. 

While I've been convinced that *someone* should take on this reimplementation effort for some time,[^1] I've recently reflected on some reasons why *I* might want to invest my time into the effort.

- *As an Iris user* I want to deeply understand the components of Iris (aspirationally) to the degree that I could reimplement them.

- *As a Lean user* I want to understand the mechanization techniques that makes large, collaborative verification projects feasible and sustainable. 

- *As a probabilistic verification researcher* I want to give myself the right tools for developing program logics based around classical mathematical techniques.
For example, I want to make use of verified probability theory which is already extensively developed in Mathlib. 

In this post, I will elaborate on the planning I've been doing to try and bring the dream of Iris in Lean a little closer to reality. 
I've dubbed the project **Eileen**, a malapropism of *iLean*, which itself is a portmanteau of *Iris + Lean*.

## Concepts of a Plan

I estimate that this project has a reasonable chance of failure:
The scope may be too large, it may be too personally challenging, it may even involve features that are not in the roadmap for Lean itself.
A realistic commitment to implementing Iris in Lean involves hedging against these failures by giving myself milestones that are personally valuable in their own right.
I have brainstormed a few:

- Learn more about lean:
  - Learn metaprogramming, and Lean's metaprogramming methodology
  - Learn about how Mathlib structures its mathematical hierarchies (typeclasses, rather than canonical structures)
  - Practice using the Lean development environment
- Lean more about Iris:
  - Contents and dependencies of the Iris development
  - The core results of the Iris development
  - Self-contained reimplementations of independent Iris components 
  - Understand the history and theory behind Iris
- Face and document technical limitations for implementing program logics in lean
- Project organization

Oriented around these goals, I came up with some short term tasks to help me assess and plan the project.

- Prior Art
  + Read (and annotate) the main line of Iris papers
  + Learn about metaprogramming in Lean
  + Learn about how Mathlib organizes large mathematical developments. For example, how they structure their typeclass hierarchies
  + Read the existing Lean Iris paper (implementation of MoSeL in Lean)
- Planning
  + Take inventory of the existing Iris development
  + Plan realistic milestones, including the smallest number of theorems and definitions to implement them (in dependency order)

My past few months have focused heavily on the reading aspect of this plan: reading, and working on small mechanization experiments. 
This blog post takes the next step, by reading enough the Iris source code to organize plans and milestones for the Eileen implementation. 

## An Inventory of Iris

There are 200 files in Iris, including approximately 50,000 lines of Rocq code. 
Not all of these files are relevant to Eileen, the proofmode portion of it of it has already [been implemented](https://github.com/leanprover-community/iris-lean).
This is a high-level dependency graph of Iris,[^3] generated by my [Rocq dependency graph script](https://github.com/markusdemedeiros/coqdep/tree/main) (implemented in Lean, of course!).

<p align="center">
![](../img/iris_deps/overview.svg "Dependency graph: Overview"){#id .class width=100%} 
</p>

To get my bearings in this development, I went through each file in the Iris repository in dependency order. 
The tables below are a deliberately over-simplified summary of their contents--not enough to serve as a complete summary of the Iris development, but enough to arrive at a realistic checklist of lemmas going forward.


*Lines are left blank or italicized if I am still reading them.*

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

&nbsp;

---

## What else?

The remaining modules are

- **HeapLang-related**: these are developed internally to the Iris logic, and I am confident do not need to be a medium-term priority.
- **Proofmode-related**: The existing Lean-iris project has done extensive work on replicating the proofmode in Lean.
- **Unstable**: No essential lemmas depend on these.
- **Tests**: Will change greatly in a reimplementation. 

## A Plan for Iris in Lean

Building off of this inventory, here are some things I think I can concretely start working on. 
I've tried to keep the list of goals short, though I expect it to grow as I discover unknown dependencies. 


- Fundamental structures
  - Files for a focused reading and documentation:
    - ``algebra/ofe.v``
    - ``algebra/cofe_solver.v``
    - ``algebra/cmra.v``
    - ``algebra/updates.v``, ``algebra/local_updates.v``
    - ``algebra/excl.v``
    - ``algebra/frac.v``
    - ``algebra/view.v``
      - How does this differ from Auth? 
    - ``algebra/auth.v``
  - OFE/CMRA/RA hierarchy definition
    - Define OFE/COFE, bundled (category) and semi-bundled (typeclasses)
    - Hierarchy of nonexpansive functions, using mathlib-style morphism typeclasses
    - Feedback from the Lean Zulip
      - Possible Goal: Mathlib PR
  - Goal: the proofs of the fixpoint constructions 
  - Goal: the proofs for the oFunctor fixpoint 
  - **Milestone**: implement Excl
    - Getting the hierarchy definition into a place where I can state excl, even if the constructions aren't done.
  - Goal: implement Frac 
  - Goal: define local updates
    - How bundled are similar definitions in mathlib?
  - Goal: implement View
  - **Milestone**: Auth
- Generalized Rewriting 
  - Mark the places where I am doing manual rewriting work in ``ofe.lean``
  - Follow the development of generalized rewriting 
  - Understand the monotone rewriting tactics in ``iris-lean``.
  - Try to implement a search metaprogram for our use case in the meantime
- Separation Logic
  - Files for a focused reading and documentation:
    - I will need to read everything on the main depdndency graph closely before I can confidently implement it.
      - ``bi/interface.v``
      - ``bi/derived_connectives.v``
      - ``bi/extensions.v``
      - ``bi/derived_laws.v``
      - ``bi/derived_laws_later.v``
      - ``bi/internal_eq.v``
      - ``bi/plainly.v``
      - ``bi/updates.v``
    - The BI definition and extensions in ``iris-lean``
      - The right BI definition for tactics might not be the same as the right BI definition for math. 
  - Hierarchy of BI logics
    - Definitions for properties of elements in BI logics
- Instance of ``iris-lean`` for a simple separation logic
  - Formalize "Bringing Order to the Separation Logic Jungle", try instantiating it
- **Milestone:** Instance of ``iris-lean`` for ``si_logic``
  - This might already be developed (they have a similar-looking logic). In this case, I need to understand it. 
- Base logic
  - Files for a focused reading and documentation:
    - ``base_logic/upred.v``
    - ``base_logic/bi.v``
    - ``base_logic/derived.v``
  - Goal: Understand and state ``upred``
- **Main Milestone**: Instance of ``iris-lean`` for base logic 
  - The soundness theorems from ``base_logic/derived.v`` and ``base_logic/bi.v``

The short term involves plenty of reading and documentation. 
Any progress I make will continue to be posted on my website.

## The Future

I think that an ergonomic definition of the structures leading up to ``uPred`` are the bare minimum for an implementation of Iris in Lean. 
It's hard to plan further, but a development that gets that far can be confident enough in the definitions so that the other files low in the dependency order will be amenable to a distributed effort.
Of course there is still a lot of work between that point and a usable logic--but much of that work is internal to the Iris logic, which is less likely to fail outright. 

While the list of tasks will surely grow, the amount of work I *don't* have to do gives me confidence that this is a realistic plan. 
Along the way I plan to document as much of my process as possible, so in the event of my failure somebody else can pick up the torch.
If anyone would like to get in contact about this effort, the main page of my website has my contact information. 


[^1]: Anecdotally, the labmates I've been pestering with the *Why can't we have Iris in Lean* conversation have found it *very* convincing. 
[^2]: This diagram is not complete. Among other things, its missing the geneology of step-indexed and modal program logics, which Iris is also heavily based upon. 
[^3]: Iris commit hash ``657b34ad877f1ba22414e0e85ad2a49e56a188e0``
