---
title: 'An Anecdote Against Slop Artifacts'
date: 'Aug 14, 2026'
content: 'Theorem Proving'
...

This is a cautionary tale.

## Act I

My latest paper "Verifying Exact Samplers for Continuous Distributions with a Discrete Program Logic" involved quite a lot of proof work. 
In that paper we showed how you can use program logic techniques to prove stuff about a particular implementation of real numbers (lazy bitstreams), and we formally verified it using the Iris framework in Rocq. 

The core "program logic" nugget at the heart of this paper is really simple and elegant; of course, this is because Joe went "wolf mode" and cooked this part of the project over a single weekend. 
My main contribution to the paper was exploring how far this trick could get us, in the end scaling all the way up to verified implementations of cool and counterintuitive sampling algorithms. 

In particular, I spent a couple months hacking on this idea, and in the process, went completely insane. 
Through tears I verified the existence of, and absolute convergence of, and commutation of, ten thousand different Riemann integrals in Rocq, working around the scant and inconsistent support for this in our analysis libraries. 
I was not a heavy user of AI at the time--this mental torture was sourced organically. 
As an effect, I forgot the feeling of joy, but I knew pretty much every line of this repository inside and out. 

## Act II

Because of our weird representation of real numbers, our _adequacy theorem_ (the main metatheorem relevant for correctness of program logics) had to be stated in a somewhat nonstandard way. 
The statement is more or less as follows:

> Theorem **Adequacy**.
>
> - Let `e` be a program, and `mu` be a proper distribution over R. 
> - Let `P/2^Q` be any dyadic rational number.
> - Suppose you prove `HasDistribution(e, mu)` (the main "judgment" of our logic).
> - Suppose that `IsLessThanDyadic(e, P/2^Q)` terminates with probability 1. 
> 
> Then, the probability that `IsLessThanDyadic(e, P/2^Q)` returns `true` is equal to `mu(P/2^Q)`

All of the weirdness has to do with `IsLessThanDyadic`, a necessary layer for simulating real numbers in a language that doesn't have them.
The program `IsLessThanDyadic` works by iteratively comparing approximations of the real number returned by `e` against approximations of `P/2^Q`. 
For example, if `P/2^Q` is the dyadic binary number `b0.110111...`, the program will iteratively try to compare increasingly finer approximations of `e` against it, until the first comparison that decides which side that `e` lands on:

- `b0.0 < e < b0.1`?
- `b0.10 < e < b0.11`?
- `b0.110 < e < b0.111`?
- `b0.1100 < e < b0.1101`?
- and on and on

Of course, when `e` is randomly sampled from a sufficiently nice probability distribution like the Gaussian, the chances that exactly equals `P/2^Q` is zero, so a simple inductive argument justifies that the obvious implementation of `IsLessThanDyadic` really will terminate with probability 1 as required.
And it's easy to justify to yourself (and inside our logic) that this process will output `true` if `e < P/2^Q` and `false` if if `P/2^Q < e`.
By appealing to some elementary measure theory, the fact that we know `IsLessThanDyadic(e, P/2^Q)` for every dyadic number `P/2^Q` is enough to characterize the cumulative density function of `e` over the entire real line, and so the proofs we carry out inside our logic are the real stuff.

Our final artifact includes random sampling algorithms for the real-valued, honest-to-god Gaussian and Laplace distributions, and a library of verified arithmetic complete _enough_ to fill an unverified hole in prior work. 
At the time we submitted I was super proud of this, especially given how much work I'd put in to making every little detail of the math work out just right. 

The reviewers agreed it was cool, and it was accepted. Yay! 

## Act III 

While our adequacy theorem is nice, that fourth bullet point is sort of weird, and we highlighted in our paper that a separate tool such as Total Eris would have no issue demonstrating that `IsLessThanDyadic(e, P/2^Q)` terminates with probability 1 in Rocq.
Come rebuttal time we decided to actually sit down and do it, at least for the uniform sampler over `[0,1]`.
So there I was, sitting in a hotel room in Providence, hacking away on a Total Eris proof when I realized 

## Act FUckfuckfuckfuckfuckfu

Our implementation of `IsLessThanDyadic` was NOT comparing increasingly more precise approximations of `P/2^Q`. 
Due to a sign error in our code, it was checking the outcome of `e` against increasingly _coarser_ approximations of our dyadic:

- `0 < e < 1`
- `0 < e < 2`
- `0 < e < 4`
- `0 < e < 8`
- And on and on forever, haha, uh oh, I'm in danger

So, worse than being unprovable, the program actually did _not_ terminate! 

Why did the proof checker still accept this? 
Well, Eris is a _partial correctness logic_, so it trivially accepts anything about nonterminating programs (indeed, partial correctness is necessary for the logic's main trick to work).
Loeb induction, the principle we use to verify properties about ``IsLessThanDyadic`` in Iris, simply assumes that your program is in a terminating trace, causing the termination assumption we handwaved away to bubble all the way up to the adequacy theorem.
When you're in the muck of a Loeb induction proof, a correct proof and a proof that is vacuous due to nontermination look just about the same.

The only (minor) difference is that, if your proof is vacuous due to nontermination, you can prove _anything_ about it using Loeb induction, but it will _not be possible_ to close off that final termination hypothesis in your adequacy theorem. 
This is exactly the situation I was in, that horrible night in Providence.

The paper could simply not be published in this state, and I was mentally preparing myself to retract our submission.

## Act V

I freaked out for a little bit, but then I stopped freaking out, and corrected the sign error. 
The proofs still worked and I was able to finish the Total Eris proof, closing the last hypothesis.

## Act... what the hell?

I thought the same thing.

While the proof I'd written was vacuous, I'd actually still written a _correct_ proof, just in an vacuous context.
With the sign errors corrected, nothing changed about my partial correctness arguments, but my termination statement changed from being false to being true (generally speaking this a good change to make).

The reason this went thought alright was becase I did not "adversarially exploit" the Loeb induction hypothesis. 
The final proof still went through by Loeb induction, and the thing is, I still have parts of my proof that genuinely rely on the fact that we can avoid traces that don't terminate!
What is an exploit versus a correct proof can be hard to determine, and it's important for proof engineering that you know the difference.

This mistake was not a big deal but it very well could have been. 
I spent months mentally torturing myself with the details of these arguments, and as a consequence I understood them completely, and knew that even if not correct, they were fixable.
So that's exactly what I did.

A couple hours later, we submitted the rebuttal confidently asserting that yes, we also verified the obvious hypothesis too.  
Close one, cowboy. 

## Conclusion 

This is a cautionary tale. 
Now that AI is readily available, and generally pretty good, some people believe that you can simply slop out a proof and submit it for the extra badges on your cover page. 
I'm not sure I would have noticed an AI that decided to avail itself of my nonterminating program. 
I'm quite sure I wouldn't have been able to fix it so quickly--the time alone to regenerate a correct version from scratch might have even been too long. 

You have to be careful with these things. 
Formal methods is still hard, and you need an expert to interpret the results. 
And when your slopped out artifact doesn't exactly match the text of your paper, I've got to say, the once-bitten part of me just doesn't buy it. 