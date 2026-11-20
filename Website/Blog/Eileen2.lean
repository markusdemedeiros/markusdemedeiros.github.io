import VersoBlog
import Website.Categories

open Verso Genre Blog
open Lean (Html)

private def blob1 : Html := .raw r#"<figure>
<img src="img/Iris-Lean-Example.png"
title="An example proof in Iris-Lean, using iProp and the agreement monoid."
width="500" alt="Looks like everyone loves Iris-Lean ;)" />
<figcaption aria-hidden="true"><em>Looks like everyone loves Iris-Lean
;)</em></figcaption>
</figure>"#

#doc (Post) "Eileen is Dead, Long Live Iris-Lean!" =>
%%%
authors := ["Markus de Medeiros"]
date := {year := 2025, month := 5, day := 5}
categories := [Website.Cat.irisLean]
%%%

Just a quick update for this one. Since my last post on Eileen, work has restarted on the main Iris-Lean project, and I’ve been contributing there instead. It’s always a shame to see a good name go to waste, but I’m more than happy to give it up in exchange for a realistic shot at finishing the project.

Since the switch we’ve managed to finish a definition for `iProp`, and even get an example Iris proof working!

:::blob blob1
:::

We are coordinating on the `#iris-lean` channel in the [Lean Zulip](https://leanprover.zulipchat.com/#narrow/channel/490604-iris-lean/). New contributors are always welcome (for example Suhr, who took a heroic chunk out of the CMRA lemmas). If you message in the Zulip, I’m sure I’ll be able to find you something to do!
