---
title:  'OOPSLA24 Paper: TACHIS' 
date: 'July 20, 2024'
content: 'academics'
...

Our paper *Tachis: Higher-Order Separation Logic with Credits for Expected Costs* will appear at OOPSLA 2024. 


This paper was written in collaboration with Philipp G. Haselwarter, Kwing Hei Li, Simon Oddershede Gregersen, Alejandro Aguirre, Joseph Tassarotti, and Lars Birkedal.



**Abstract**


> We present Tachis, a higher-order separation logic to reason about the expected cost of probabilistic programs. Inspired by the uses of time credits for reasoning about the running time of deterministic programs, we introduce a novel notion of probabilistic cost credit. Probabilistic cost credits are a separation logic resource that can be used to pay for the cost of operations in programs, and that can be distributed across all possible branches of sampling instructions according to their weight, thus enabling us to reason about expected cost. The representation of cost credits as separation logic resources gives Tachis a great deal of flexibility and expressivity. In particular, it permits reasoning about amortized expected cost by storing excess credits as potential into data structures to pay for future operations. Tachis further supports a range of cost models, including running time and entropy usage. We showcase the versatility of this approach by applying our techniques to prove upper bounds on the expected cost of a variety of probabilistic algorithms and data structures, including randomized quicksort, hash tables, and meldable heaps.
> All of our results have been mechanized using Coq, Iris, and the Coquelicot real analysis library.

A preprint is available on [arxiv](https://arxiv.org/abs/2405.20083).