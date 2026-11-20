import VersoBlog
import Website.Categories

open Verso Genre Blog
open Lean (Html)

private def blob1 : Html := .raw r#"<p><img src="img/iris_deps/overview.svg"
title="Dependency graph: Overview" style="width:100.0%" /></p>"#

private def blob2 : Html := .raw r#"<hr />"#

private def blob3 : Html := .raw r#"<p><img src="img/iris_deps/iris_prelude.svg"
title="Dependency graph: prelude" style="width:30.0%" /></p>
<table>
<thead>
<tr>
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>options.v</code></td>
<td>Global Rocq configuration.</td>
</tr>
<tr>
<td><code>prelude.v</code></td>
<td>Global coercions.</td>
</tr>
</tbody>
</table>"#

private def blob4 : Html := .raw r#"<p><img src="img/iris_deps/iris_algebra.svg"
title="Dependency graph: algebra" style="width:100.0%" /></p>
<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 83%" />
</colgroup>
<thead>
<tr>
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>ofe.v</code></td>
<td>OFE/COFE structures, nonexpansive/contractive maps, fixpoints,
oFunctors, (C)OFE-(iso)morphisms, OFEs based on types/laters.</td>
</tr>
<tr>
<td><code>cofe_solver.v</code></td>
<td>COFE fixpoint of oFunctor.</td>
</tr>
<tr>
<td><code>monoid.v</code></td>
<td>Semi-bundled nonexpansive monoids, and morphisms. Used for big
ops.</td>
</tr>
<tr>
<td><code>cmra.v</code></td>
<td>Variants of CMRA structures, properties of CMRA elements, morphisms,
COFE to CMRA functors, resource algebra. CMRA constructions.</td>
</tr>
<tr>
<td><code>excl.v</code></td>
<td>The excl COFE/CMRA.</td>
</tr>
<tr>
<td><code>big_op.v</code></td>
<td>Iterated monoid operation over finite structures. Morphisms and
laws.</td>
</tr>
<tr>
<td><code>cmra_big_op.v</code></td>
<td>Laws for big op with option OFE.</td>
</tr>
<tr>
<td><code>updates.v</code></td>
<td>(Nondeterministic) frame-perserving updates. FP updates based on
type.</td>
</tr>
<tr>
<td><code>local_updates.v</code></td>
<td>Local updates, laws, and constructions.</td>
</tr>
<tr>
<td><code>gset.v</code></td>
<td>CMRAs of sets of countable type: union and disjoint union.</td>
</tr>
<tr>
<td><code>gmultiset.v</code></td>
<td>CMRA for multisets of countable type.</td>
</tr>
<tr>
<td><code>coPset.v</code></td>
<td>CMRAs of sets of countable type: union and disjoint union.</td>
</tr>
<tr>
<td><code>csum.v</code></td>
<td>OFE/COFE/CMRA construction: sum with bottom.</td>
</tr>
<tr>
<td><code>mra.v</code></td>
<td>Lift preorder to CMRA.</td>
</tr>
<tr>
<td><code>list.v</code></td>
<td>(C)OFE of lists. Nonexpansisivity of list functions.</td>
</tr>
<tr>
<td><code>functions.v</code></td>
<td>Laws for discrete function OFE, into UCMRA or OFE.</td>
</tr>
<tr>
<td><code>sts.v</code></td>
<td>STS RA (historical).</td>
</tr>
<tr>
<td><code>proofmode_classes.v</code></td>
<td>Typeclass reflection of monoid op.</td>
</tr>
<tr>
<td><code>numbers.v</code></td>
<td>RA of number types with arithmetic ops.</td>
</tr>
<tr>
<td><code>frac.v</code></td>
<td>Leibniz RA of rationals <code>0 &lt; q &lt;= 1</code> with add
op.</td>
</tr>
<tr>
<td><code>ufrac.v</code></td>
<td>Leibniz RA of rationals <code>0 &lt; q</code> with add op.</td>
</tr>
<tr>
<td><code>dfrac.v</code></td>
<td>Leibniz RA of discardable fractions.</td>
</tr>
<tr>
<td><code>gmap.v</code></td>
<td>COFE/CMRA of gmap (lifts value OFE pointwise). Laws for basic gmap
operations.</td>
</tr>
<tr>
<td><code>vector.v</code></td>
<td>Vector OFEs (same as list).</td>
</tr>
<tr>
<td><code>agree.v</code></td>
<td>Agreement OFE: Lists are n-equiv when each element has an n-equiv
counterpart.</td>
</tr>
<tr>
<td><code>max_prefix_list.v</code></td>
<td>Partial OFE on lists, where <code>X &#x22C5; X ++ Y = X ++ Y</code>.</td>
</tr>
<tr>
<td><code>view.v</code></td>
<td></td>
</tr>
<tr>
<td><code>auth.v</code></td>
<td>Auth CMRA.</td>
</tr>
<tr>
<td><code>reservation_map.v</code></td>
<td>CMRA for partial functions + permission to add entries.</td>
</tr>
<tr>
<td><code>dyn_reservation_map.v</code></td>
<td>CMRA for partial functions + permission to add an unbounded number
of fresh entries.</td>
</tr>
</tbody>
</table>"#

private def blob5 : Html := .raw r#"<p><img src="img/iris_deps/iris_algebra_lib.svg"
title="Dependency graph: algebra/lib" style="width:100.0%" /></p>
<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 83%" />
</colgroup>
<thead>
<tr>
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>frac_auth.v</code></td>
<td>Auth CMRA, with splittable fractional part rather than auth
part.</td>
</tr>
<tr>
<td><code>mono_list.v</code></td>
<td>Auth CMRA over max prefix list CMRA.</td>
</tr>
<tr>
<td><code>mono_nat.v</code></td>
<td>Auth CMRA over max Nat CMRA.</td>
</tr>
<tr>
<td><code>mono_Z.v</code></td>
<td>Auth CMRA over max Z CMRA.</td>
</tr>
<tr>
<td><code>gmap_view.v</code></td>
<td>Auth CMRA over map: frags are RW access to single entries, or
persistent R access.</td>
</tr>
<tr>
<td><code>gset_bij.v</code></td>
<td></td>
</tr>
<tr>
<td><code>ufrac_auth.v</code></td>
<td></td>
</tr>
<tr>
<td><code>excl_auth.v</code></td>
<td></td>
</tr>
<tr>
<td><code>dfrac_agree.v</code></td>
<td></td>
</tr>
</tbody>
</table>"#

private def blob6 : Html := .raw r#"<p><img src="img/iris_deps/iris_bi.svg" title="Dependency graph: bi"
style="width:50.0%" /></p>
<table>
<colgroup>
<col style="width: 23%" />
<col style="width: 76%" />
</colgroup>
<thead>
<tr>
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>notation.v</code></td>
<td>Reserved notations.</td>
</tr>
<tr>
<td><code>interface.v</code></td>
<td>Axioms of BI/+Persistency/+Later. <code>bi</code> structure bundles
syntax + axioms.</td>
</tr>
<tr>
<td><code>derived_connectives.v</code></td>
<td>Defines affinely, absorbingly, intuitionistically, except 0,
timeless, later n.</td>
</tr>
<tr>
<td><code>weakestpre.v</code></td>
<td>Class and notations for WP, TWP.</td>
</tr>
<tr>
<td><code>extensions.v</code></td>
<td>Axioms+TC for additional rules to <code>bi</code>.</td>
</tr>
<tr>
<td><code>derived_laws.v</code></td>
<td>Derived <code>bi</code> laws.</td>
</tr>
<tr>
<td><code>derived_laws_later.v</code></td>
<td>Derived <code>bi</code> laws about step indexing. L&#xF6;b and variants.
Other modal laws.</td>
</tr>
<tr>
<td><code>big_op.v</code></td>
<td>Big sep, and, or, over finite types.</td>
</tr>
<tr>
<td><code>internal_eq.v</code></td>
<td>Axioms+TC for BI with internal equality that respects step
indexing.</td>
</tr>
<tr>
<td><code>plainly.v</code></td>
<td>Axioms+TC for BI with plainly modality. Laws.</td>
</tr>
<tr>
<td><code>updates.v</code></td>
<td>Axioms+TC for BI with bupd, fupd. Laws, laws involving
persistently.</td>
</tr>
<tr>
<td><code>ascii.v</code></td>
<td>Notation.</td>
</tr>
<tr>
<td><code>embedding.v</code></td>
<td>Axioms+TC for embedding one <code>bi</code> in another.</td>
</tr>
<tr>
<td><code>bi.v</code></td>
<td>Exports.</td>
</tr>
<tr>
<td><code>telescopes.v</code></td>
<td></td>
</tr>
<tr>
<td><code>monopred.v</code></td>
<td></td>
</tr>
</tbody>
</table>"#

private def blob7 : Html := .raw r#"<p><img src="img/iris_deps/iris_si_logic.svg"
title="Dependency graph: si_logic" style="width:30.0%" /></p>
<table>
<colgroup>
<col style="width: 12%" />
<col style="width: 87%" />
</colgroup>
<thead>
<tr>
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>siprop.v</code></td>
<td>Pure, Nat-indexed Prop, COFE and BI defs. Soundness for pure,
internal eq, later.</td>
</tr>
<tr>
<td><code>bi.v</code></td>
<td>BI TC instances for siProp.</td>
</tr>
</tbody>
</table>"#

private def blob8 : Html := .raw r#"<p><img src="img/iris_deps/iris_bi_lib.svg"
title="Dependency graph: bi/lib" style="width:80.0%" /></p>
<table>
<colgroup>
<col style="width: 23%" />
<col style="width: 76%" />
</colgroup>
<thead>
<tr>
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>counterexamples.v</code></td>
<td>Paradoxes.</td>
</tr>
<tr>
<td><code>laterable.v</code></td>
<td></td>
</tr>
<tr>
<td><code>fixpoint.v</code></td>
<td>Derived lfp and gfp of a monotone function, induction
principles.</td>
</tr>
<tr>
<td><code>relations.v</code></td>
<td>Closure, iterate of relations. Internal, with internal eq.</td>
</tr>
<tr>
<td><code>atomic.v</code></td>
<td></td>
</tr>
<tr>
<td><code>cmra.v</code></td>
<td>Internalize included, given internal equality.</td>
</tr>
<tr>
<td><code>fractional.v</code></td>
<td></td>
</tr>
<tr>
<td><code>core.v</code></td>
<td>TC for core of a prop. Internal.</td>
</tr>
</tbody>
</table>"#

private def blob9 : Html := .raw r#"<p><img src="img/iris_deps/iris_base_logic.svg"
title="Dependency graph: base_logic" style="width:50.0%" /></p>
<table>
<colgroup>
<col style="width: 12%" />
<col style="width: 87%" />
</colgroup>
<thead>
<tr>
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>upred.v</code></td>
<td>uPred for general UCMRA, COFE + BI defs. Nonexpansive and proof
rules. Soundness for later, pure, internal eq.</td>
</tr>
<tr>
<td><code>bi.v</code></td>
<td>BI TC instances for upred.</td>
</tr>
<tr>
<td><code>derived.v</code></td>
<td>Derived laws, TC instances for valid. Soundness for bupd,
modalities.</td>
</tr>
<tr>
<td><code>algebra.v</code></td>
<td><em>Internalizes properties of CMRA.</em></td>
</tr>
<tr>
<td><code>proofmode.v</code></td>
<td>Pure and splitting TC instances for uPred.</td>
</tr>
<tr>
<td><code>base_logic.v</code></td>
<td>Exports.</td>
</tr>
<tr>
<td><code>bupd_alt.v</code></td>
<td><em>Alternate bupd definition.</em></td>
</tr>
</tbody>
</table>"#

private def blob10 : Html := .raw r#"<p><img src="img/iris_deps/iris_base_logic_lib.svg"
title="Dependency graph: base_logic/lib" style="width:100.0%" /></p>
<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 82%" />
</colgroup>
<thead>
<tr>
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>fancy_update_from_vs.v</code></td>
<td>Fancy updates as view shift.</td>
</tr>
<tr>
<td><code>iprop.v</code></td>
<td>iProp: solution to uPred recurrence. TC for GFunctors: lists of
locally contractive rFunctors, for the solution. iPropO: the OFE.</td>
</tr>
<tr>
<td><code>own.v</code></td>
<td>TC for CMRA being in GFunctors. Definition of ghost ownership.
Updates, allocation.</td>
</tr>
<tr>
<td><code>token.v</code></td>
<td>GFunctor for unique ownership of symbol.</td>
</tr>
<tr>
<td><code>ghost_map.v</code></td>
<td>GFunctor for ghost heap.</td>
</tr>
<tr>
<td><code>ghost_var.v</code></td>
<td>GFunctor for ghost mutable variable.</td>
</tr>
<tr>
<td><code>mono_nat.v</code></td>
<td>GFunctor for auth/frag of mono nat/lower bound.</td>
</tr>
<tr>
<td><code>saved_prop.v</code></td>
<td></td>
</tr>
<tr>
<td><code>proph_map.v</code></td>
<td></td>
</tr>
<tr>
<td><code>gset_bij.v</code></td>
<td></td>
</tr>
<tr>
<td><code>wsat.v</code></td>
<td><em>Related to world satisfaction style modalities.</em></td>
</tr>
<tr>
<td><code>later_credits.v</code></td>
<td>GFunctor for later credits. Later update modality.</td>
</tr>
<tr>
<td><code>fancy_updates.v</code></td>
<td>GFunctor for fupd. Laws &amp; soundness (dependent on later
credits). GFunctor for enabling invariants.</td>
</tr>
<tr>
<td><code>invariants.v</code></td>
<td>Internal construction of invariants.</td>
</tr>
<tr>
<td><code>na_invariants.v</code></td>
<td>GFunctor for non-atomic invariants.</td>
</tr>
<tr>
<td><code>cancelable_invariants.v</code></td>
<td>GFunctor for cancelable invariants.</td>
</tr>
<tr>
<td><code>boxes.v</code></td>
<td></td>
</tr>
<tr>
<td><code>gen_heap.v</code></td>
<td>GFunctor for physical heap.</td>
</tr>
<tr>
<td><code>gen_inv_heap.v</code></td>
<td>GFunctor for heap of invariants (persistent).</td>
</tr>
</tbody>
</table>"#

#doc (Post) "Eileen: A plan for Iris in Lean" =>
%%%
authors := ["Markus de Medeiros"]
date := {year := 2024, month := 12, day := 28}
categories := [Website.Cat.irisLean]
%%%

Iris is a world-class framework for mechanizing program logics in Rocq. The framework boasts an impressive list of [publications](https://iris-project.org/#publications), with users applying Iris to wide range of verification problems across the software stack. The logic of Iris is the synthesis of a [long line](https://en.wikipedia.org/wiki/Interference_freedom#Dependencies_on_interference_freedom)[^1] of work on separation logic design, and the [Iris implementation](https://gitlab.mpi-sws.org/iris/iris/) is a premier example of proof engineering in Rocq.

Lean is an interactive theorem prover and functional programming langauge. Since the release of Lean 4, the language has seen widespread popularity amongst researchers in formal verification and mechanized mathematics. Its popularity can be attributed to a number of features, including but not limited to its developer tooling, extensive mathematical library, and organized and active communuity.

Because Iris is not written in Lean, these two groups of mechanization experts cannot directly build off of each other’s work. As someone interested in program verification and Lean I think this is a shame, and I think that there is a case to be made that both projects would benefit from an implementation of an Iris-like program logic in Lean:

* *Mathematical Interest*. Much of Iris is based around the theory of OFE’s, a mathematical structure that could be of interest to the Mathlib community. Conversely, a version of Iris built using Mathlib-compatible data structures could open the door to exploring variants of Iris as it continues to grow.
* *Enhanced (meta)programming*. Lean is implemented in Lean itself, and was designed to serve as a standalone functional programming language. This means that rather than using bespoke metalanguages such as Ltac, a Lean metaprogrammer can use the full extent of the Lean programming environment to implement tactics, commands, and macros specific to their needs.
* *A Fresh Perspective*. Rocq, Lean, and Iris are projects under active development, with their own pros, cons, and quirks. A second implementation of a substantial project (in any language) gives us the opportunity to contrast them, and generate new ideas for how to improve our tools. The process of reimplementing Iris presents an opportunity to distill key ideas from its implementation, which can lower the bar for new contributors to the project.

While I’ve been convinced that _someone_ should take on this reimplementation effort for some time,[^2] I’ve recently reflected on some reasons why _I_ might want to invest my time into the effort.

* _As an Iris user_ I want to understand the components of Iris (aspirationally) to the degree that I could reimplement them.
* _As a Lean user_ I want to understand the mechanization techniques that make large, collaborative verification projects feasible and sustainable.
* _As a probabilistic verification researcher_ I want to give myself the right tools for developing program logics based around classical mathematical techniques. For example, I want to make use of verified probability theory which is already extensively developed in Mathlib.

In this post, I will elaborate on the planning I’ve been doing to try and bring the dream of Iris in Lean a little closer to reality. I’ve dubbed the project *Eileen*, a malapropism of _iLean_, which itself is a portmanteau of _Iris + Lean_.

# Concepts of a Plan

I estimate that this project has a reasonable chance of failure: The scope may be too large, it may be too personally challenging, it may even involve features that are not in the roadmap for Lean itself. A realistic commitment to implementing Iris in Lean involves hedging against these failures by giving myself milestones that are personally valuable in their own right. I have brainstormed a few:

* Learn more about lean:

  * Learn metaprogramming, and Lean’s metaprogramming methodology
  * Learn about how Mathlib structures its mathematical hierarchies (typeclasses, rather than canonical structures)
  * Practice using the Lean development environment
* Lean more about Iris:

  * Contents and dependencies of the Iris development
  * The core results of the Iris development
  * Self-contained reimplementations of independent Iris components
  * Understand the history and theory behind Iris
* Face and document technical limitations for implementing program logics in lean
* Project organization

Oriented around these goals, I came up with some short term tasks to help me assess and plan the project.

* Prior Art

  * Read (and annotate) the main line of Iris papers
  * Learn about metaprogramming in Lean
  * Read the Mathlib papers
  * Read the details about typeclass inference and structure extension
  * Read the existing Lean Iris paper (implementation of MoSeL in Lean)
* Planning

  * Take inventory of the existing Iris development
  * Find realistic implementation milestones

My past few months have focused on the reading aspect of this plan, alongside some preliminary mechanization experiments. This blog post takes the next step.

# An Inventory of Iris

There are approximately 200 files in Iris, containing 50,000 lines of Rocq code. Not all of these files are relevant to Eileen. Some of them are library code that can be worked on after the fact, and the proofmode portion of it of it has already [been implemented](https://github.com/leanprover-community/iris-lean). To develop project milestones, the first thing I need to do read enough the Iris source code to determine which parts are which.

This is a high-level dependency graph of Iris,[^3] generated by my [Rocq dependency graph script](https://github.com/markusdemedeiros/coqdep/tree/main) (implemented in Lean, of course!)

:::blob blob1
:::

I went through each file in the Iris repository in dependency order. The tables below are a deliberately over-simplified summary of their contents–not enough to paint a complete picture of the Iris development, but enough to chart a reasonable course to step through more carefully.

_Lines are left blank or italicized if I am still trying to understand them._

:::blob blob2
:::

# `iris/prelude/`

:::blob blob3
:::



:::blob blob2
:::

# `iris/algebra/`

:::blob blob4
:::



:::blob blob2
:::

# `iris/algebra/lib/`

:::blob blob5
:::



:::blob blob2
:::

# `iris/bi/`

:::blob blob6
:::



:::blob blob2
:::

# `iris/si_logic/`

:::blob blob7
:::



:::blob blob2
:::

# `iris/bi/lib`

:::blob blob8
:::



:::blob blob2
:::

# `iris/base_logic/`

:::blob blob9
:::



:::blob blob2
:::

# `iris/base_logic/lib/`

:::blob blob10
:::



:::blob blob2
:::

# What else?

The remaining modules are

* *HeapLang-related*: these are developed internally to the Iris logic, and I am confident do not need to be a medium-term priority.
* *Proofmode-related*: The existing Lean-iris project has done extensive work on replicating the proofmode in Lean.
* *Unstable*: No essential lemmas depend on these.
* *Tests*: Will change greatly in a reimplementation.

# A Plan for Iris in Lean

Building off of this inventory, here are some things I think I can concretely start working on. I’ve tried to keep the list of goals minimal, because I expect it to grow.

* Fundamental structures

  * Files for a focused reading and documentation:

    * `algebra/ofe.v`
    * `algebra/cofe_solver.v`
    * `algebra/cmra.v`
    * `algebra/updates.v`, `algebra/local_updates.v`
    * `algebra/excl.v`
    * `algebra/frac.v`
    * `algebra/view.v`

      * How does this differ from Auth?
    * `algebra/auth.v`
  * OFE/CMRA/RA hierarchy definition

    * Define OFE/COFE, bundled (category) and semi-bundled (typeclasses)
    * Hierarchy of nonexpansive functions, using mathlib-style morphism typeclasses
    * Feedback from the Lean Zulip

      * Possible Goal: Mathlib PR
  * Goal: the proofs of the fixpoint constructions
  * Goal: the proofs for the oFunctor fixpoint
  * *Milestone*: implement Excl

    * Getting the hierarchy definition into a place where I can state excl, even if the constructions aren’t done.
  * Goal: implement Frac
  * Goal: define local updates

    * How bundled are similar definitions in mathlib?
  * Goal: implement View
  * *Milestone*: Auth
* Generalized Rewriting

  * Mark the places where I am doing manual rewriting work in `ofe.lean`
  * Follow the development of generalized rewriting
  * Understand the monotone rewriting tactics in `iris-lean`.
  * Try to implement a search metaprogram for our use case in the meantime
* Separation Logic

  * Files for a focused reading and documentation:

    * I will need to read everything on the main depdndency graph closely before I can confidently implement it.

      * `bi/interface.v`
      * `bi/derived_connectives.v`
      * `bi/extensions.v`
      * `bi/derived_laws.v`
      * `bi/derived_laws_later.v`
      * `bi/internal_eq.v`
      * `bi/plainly.v`
      * `bi/updates.v`
    * The BI definition and extensions in `iris-lean`

      * The right BI definition for tactics might not be the same as the right BI definition for math.
  * Hierarchy of BI logics

    * Definitions for properties of elements in BI logics
* Instance of `iris-lean` for a simple separation logic

  * Formalize “Bringing Order to the Separation Logic Jungle”, try instantiating it
* *Milestone:* Instance of `iris-lean` for `si_logic`

  * This might already be developed (they have a similar-looking logic). In this case, I need to understand it.
* Base logic

  * Files for a focused reading and documentation:

    * `base_logic/upred.v`
    * `base_logic/bi.v`
    * `base_logic/derived.v`
  * Goal: Understand and state `upred`
* *Main Milestone*: Instance of `iris-lean` for base logic

  * The soundness theorems from `base_logic/derived.v` and `base_logic/bi.v`

The short term involves plenty of reading and documentation. Any progress I make will continue to be posted on my website.

# The Future

I think that an ergonomic definition of the structures leading up to `uPred` are the bare minimum for an implementation of Iris in Lean. It’s hard to plan further, but a development that gets that far can be confident enough in the definitions so that the other files low in the dependency order will be amenable to a distributed effort. Of course there is still a lot of work between that point and a usable logic–but much of that work is internal to the Iris logic, which is less likely to fail outright.

While the list of tasks will surely grow, the amount of work I _don’t_ have to do gives me confidence that this is a realistic plan. Along the way I plan to document as much of my process as possible, so in the event of my failure somebody else can pick up the torch. If anyone would like to get in contact about this effort, the main page of my website has my contact information.

[^1]: This diagram is not complete. Among other things, its missing the geneology of step-indexed and modal program logics, which Iris is also heavily based upon.

[^2]: Anecdotally, the labmates I’ve been pestering with the _Why can’t we have Iris in Lean_ conversation have found it _very_ convincing.

[^3]: Iris commit hash `657b34ad877f1ba22414e0e85ad2a49e56a188e0`
