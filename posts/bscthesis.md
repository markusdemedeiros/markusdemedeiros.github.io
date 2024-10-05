---
title:  'BSc. Thesis: Coupled Borrows'
date: 'Oct 5, 2024'
content: 'academics'
...

This is an upload of my BSc. thesis, co-supervised by Alexander Summers (UBC) and Aurel Bílý (ETH Zurich). I presented an overview this work to the Prusti team in the summer of 2023; the slides are available below as well.


[[Thesis]](../pdf/Thesis.pdf) _Coupled Borrows: Modelling Rust's Aliasing Information with Capabilities_

[[Presentation]](../pdf/prusti_presentation.pdf) _Coupled Borrows: Expanding Core Proof Inference in Prusti_


**Abstract**

> Prusti is a Rust verification tool which automatically infers a proof of memory safety from the Rust compiler internals. Prusti’s core inference was originally described in terms of a data structure called the Place Capability Summary (or PCS) which describes the capabilities the Rust program has to memory at each program point. The PCS is not implemented in the current version of Prusti; this thesis explores a method for inferring the PCS as a separate step from the rest of Prusti. In doing so, we define a new data structure we call the Coupling Graph, which establishes approximate aliasing relationships between places in a form that is straightforward to derive from the compiler. Our approach enables a PCS to be derived for programs involving reborrowing inside complex dataflow such as loops, which the release version of Prusti does not currently support.
