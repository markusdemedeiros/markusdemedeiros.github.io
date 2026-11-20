import VersoBlog
import Website.Categories

open Verso Genre Blog
open Lean (Html)

private def blob1 : Html := .raw r#"<p><img src="img/Eris_talk.jpg"
title="Me at a podium, with Eris slides projected in the background. Photo credit Simon Oddershede Gregersen"
width="500" /></p>"#

#doc (Post) "NESVD Talk: ERIS" =>
%%%
authors := ["Markus de Medeiros"]
date := {year := 2024, month := 4, day := 27}
categories := [Website.Cat.academics]
%%%

On April 26 I gave a talk at the [New England Systems Verification Day](https://svd.csail.mit.edu/2024/) workshop, located at MIT.

The talk is about Eris, for which we have recently put out a [preprint](https://arxiv.org/abs/2404.14223). My slides are available in [pdf](pdf/Eris_Presentation_nonanimated.pdf), or [keynote](pdf/Eris_Presentation.key) (fancy animations!)

:::blob blob1
:::
