---
title:  'ICFP24 Paper: ERIS'
date: 'July 20, 2024'
content: 'academics'
...

Our paper *Error Credits: Resourceful Reasoning about Error Bounds for Higher-Order Probabilistic Programs* will appear at ICFP 2024. 


This paper was written in collaboration with Alejandro Aguirre, Philipp G. Haselwarter, Kwing Hei Li, Simon Oddershede Gregersen, Joseph Tassarotti, and Lars Birkedal.


**Abstract**

> Probabilistic programs often trade accuracy for efficiency, and are thus only approximately correct. It is important to obtain precise error bounds for these approximations, but existing approaches rely on simplifications that make the error bounds excesively coarse, or only apply to first-order programs. In this paper we present Eris, a higher-order separation logic for probabilistic programs written in an expressive higher-order language.
> Our key novelty is the introduction of error credits, a separation logic resource that tracks the error bound of a program. By representing error bounds as a resource, we recover the benefits of separation logic, including compositionality, modularity, and dependency between errors and program terms, allowing for more precise specifications. Moreover, we enable novel reasoning principles such as expectation-preserving error composition, amortized error reasoning, and proving almost-sure termination by induction on the error.
> We illustrate the advantages of our approach by proving amortized error bounds on a range of examples, including collision probabilities in hash functions, which allows us to write more modular specifications for data structures that use them as clients. We also use our logic to prove correctness and almost-sure termination of rejection sampling algorithms. All of our results have been mechanized in the Coq proof assistant using the Iris separation logic framework and the Coquelicot real analysis library.


A preprint is available on [arxiv](https://arxiv.org/abs/2404.14223).
