import VersoBlog
import Iris
import Website.Categories

open Verso Genre Blog

#doc (Post) "Hello Verso" =>
%%%
authors := ["Markus de Medeiros"]
date := {year := 2026, month := 11, day := 19}
categories := [Website.Cat.blogging, Website.Cat.irisLean]
%%%

This post tests the two things the old pandoc build did not give me: checked Lean code and LaTeX.

# LaTeX

Inline math looks like $`P \ast Q \vdash Q \ast P`, and display math looks like

$$`\frac{P \vdash Q \qquad R \vdash S}{P \ast R \vdash Q \ast S}`

# Iris-Lean

Lean elaborates the code below against Iris-Lean while it builds the site. Hover over a name to see its type, and click a tactic to see the proof state.

```leanInit iris
```

```lean iris
open Iris BI in
theorem sep_swap [BI PROP] (P Q : PROP) : P ∗ Q ⊢ Q ∗ P := by
  iintro ⟨HP, HQ⟩
  isplitl [HQ]
  · iexact HQ
  · iexact HP
```
