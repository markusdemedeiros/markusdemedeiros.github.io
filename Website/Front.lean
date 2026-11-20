import VersoBlog
import Website.Papers
import Website.Preprints

open Verso Genre Blog
open Lean (Html)

namespace Website

def divider : Html := html%{<br/><hr/>}

def dog : Html := html%{
  <div align="center">
    <img src="img/jazz.jpg" alt="Brown dog sitting on a couch" width="250em"/>
  </div>
}

def webRing : Html := html%{
  <div align="center">
    <br/><br/>
    <span>
      <a href="https://bobs-club.net/site/rat/pred" title="previous site">{"[ ↤ ] "}</a>
      <a href="https://bobs-club.net/site/rat/random" title="random site">{"[ destruct ⊥ ] "}</a>
      <a href="https://bobs-club.net/" title="web ring">{"[ bob's club ] "}</a>
      <a href="https://bobs-club.net/site/rat/succ" title="next site">{"[ ↦ ]"}</a>
    </span>
  </div>
}

end Website

open Website

#doc (Page) "Markus de Medeiros" =>

# About Me

I'm Markus, a PhD student at NYU working with Joseph Tassarotti. I am broadly interested in *formal methods*, namely in verifying challenging properties of randomized systems at a realistic scale.

Here are some projects I've worked on:

* [Iris-Lean](https://github.com/leanprover-community/iris-lean): a port of the Iris logic to the Lean theorem prover.
* [Clutch](https://github.com/logsem/clutch): a family of program logics for verifying properties of randomized programs in Rocq.
* [SampCert](https://github.com/leanprover/SampCert): a differential privacy library which is verified in Lean and deployed at AWS.
* [Prusti](https://www.pm.inf.ethz.ch/research/prusti.html): developing an embedding of the Rust type system in a separation logic.

:::blob divider
:::

# Publications

_See also:_ {page_link Website.Preprints}[\[ preprints \]]

:::blob publications
:::

:::blob divider
:::

# Blog Posts

:::htmlDiv (class := "post-table")
The theme puts the table of posts here.
:::

:::blob divider
:::

# Dog

Here is my cute dog!

:::blob dog
:::

:::blob webRing
:::
