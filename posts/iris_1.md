---
title:  "What makes Iris tick? 1: Algebra"
date: ''
content: 'Iris'
...

Iris is a sizable Coq[^1] development, clocking in at around 37Kloc. 

Despite the fact that I work with Iris every day Iris' implementation still feels
deeply mysterious to me. 

To fix this, I want to fully read through the Iris source code. 

This post contains loosely structured notes I'm taking thoughout this process. 

The main questions I want to answer are:
- What are the main definitions and lemmas in Iris? 
- Which features depend on which subsets of Iris definitions?
- Which proofs in Iris are challenging, and why?
- How do the features from the Iris papers translate into the formal development?

I will make very little effort to editorialize these posts, mainly because I don't know
enough to do that. 
I expect that I will edit these posts as I understand more about the project.

## Orienteering 

Below is the inter-module dependency graph [generated from the CoqProject file](https://gist.github.com/markusdemedeiros/b029c5c74ec24bae93d093f7da1ab01f)
of Iris. 

The plan is to work through the above graph in bottom-up order, skipping the modules that are 
either devoid of interesting content, or unstable. 

(Graph here)

We will fix the Iris version to the one I downloaded on August 20th, 2024 (commit hash ``657b34ad877f1ba22414e0e85ad2a49e56a188e0``).

## Algebra






[^1]: I'm calling it Coq until the website changes. 
