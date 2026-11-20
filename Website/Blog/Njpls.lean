import VersoBlog
import Website.Categories

open Verso Genre Blog
open Lean (Html)

private def blob1 : Html := .raw r#"<p><img src="img/njpls-matt.png"
title="Me at a podium, with the first Iris-Lean slide projected in the background. Photo credit Matt Davis."
width="500" /></p>"#

#doc (Post) "NJPLS Talk: Iris-Lean" =>
%%%
authors := ["Markus de Medeiros"]
date := {year := 2025, month := 12, day := 5}
categories := [Website.Cat.academics, Website.Cat.irisLean]
%%%

On December 5 I got the change to talk about Iris-Lean at the [New Jersey Programming Languages and Systems Seminar](https://njpls.org/dec2025.html). My slides are available in [pdf](pdf/IrisLean.pdf).

:::blob blob1
:::
