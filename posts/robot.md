---
title:  'My Conversation with the Bot'
date: 'Dec 12, 2025'
content: 'theorem proving'
...

_My Dinner With André_ is a 1981 comedy film centering around a schizophrenic conversation between a cynical, overworked, broke playwright (Wally Shawn) and his long-winded, pseudo-spiritual, presumably delusional friend André. 

In other news, I've been chatting with Claude code while I work. 

<p align="center">
![](../img/andre.jpeg "The titular André"){#id .class width=400} 
</p>

#### AI? Gross. 

If you're waiting to tell me that AI is probably bad for the environment, or our brains, or our economy... save it. 
I already agree with you. 
The MIT technology review has a [great running story](https://www.technologyreview.com/supertopic/ai-energy-package/) on the energy cost of AI, which I don't have the qualifications to summarize, but look. 
It's bad.

On top of that, I just don't like, _like_ AI.
AI writing is really disgusting to me, and I agree with [Alex Martsinovich's opinion](https://distantprovince.by/posts/its-rude-to-show-ai-output-to-people/) that giving somebody AI generated text is "rude". 
I don't have a need for AI image generation, if I wanted to fill my presentations with flat design corpo-sludge I'd gladly just pay a human $1 to do it. 
It also astounds me that people actually use those AI summaries.
At this point I'm sure you've also had your fill of [glue pizza](https://www.forbes.com/sites/jackkelly/2024/05/31/google-ai-glue-to-pizza-viral-blunders/) moments, but I'll share my own.
One time I was at a poker game with a more AI-friendly PhD student who asked ChatGPT about the all-in splitting rules; the AI got it wrong (lol), and for some reason the PhD student still came to its defense. 
It was genuinely pretty hard to take him seriously after that performance. 

Honestly, I don't even really enjoy the process of using AI. 
The AI chatbots are flaky, inconsistent, and don't guarantee good results. 
You know this. They don't guarantee anything!
I recall having a genuine moment of doubt before putting my credit card information into the Anthropic website... after all, the payment portal was probably written by Claude coders (derogatory), right? 

Lastly, I'm a student. 
My job is to learn, and when I see the way that some people use AI I get the same radioactive, slimy feeling as looking for answers in the back of the book. 
Would using AI stunt my growth as a researcher? 
Where's the line between routine chores and practice?

#### But?

I'm also, at least aspirationally, a scientist, and I think it's important to keep an open mind.
I don't think it's fair to say that there is _no_ possible future where AI stops being such a nightmare. 
Maybe there's a world where businesspeople remember that money has value and they stop donating it to the construction of redundant datacenters.
Or maybe demand, or the bubble, or regulation, or whatever, will shrink the industry to the point where spinning up new ([also known as "worse"](https://www.politico.com/news/2025/11/27/ai-gives-coal-plants-a-lifeline-as-trump-makes-them-dirtier-00661839)) coal burning power plants is not actually worth $∞ per quarter when [more inference does not mean more profit](https://www.wheresyoured.at/costs/#anthropic-is-in-real-troubleand-the-current-cost-of-doing-business-is-unsustainable-meaning-prices-must-increase).

Maybe, in that world, and in some cases, AI could be useful. 

I don't think it's my job to make that world possible, or even to determine if we're there yet.
But since I've had a coherent opinion on the topic, I've decided that I would wait for any benefits of AI to show themselves before really trying to figure them out for myself.
And for the past two years I've seen a lot of speculation, toy benchmarks, and rhetoric, but nothing compelling enough to be worth my soul.

#### So what changed, then?

AI presented me a solution to a problem. 
I had been working on Iris-Lean, trying to wrangle some horrible type transports I had never done before.
Zongyuan Liu, a PhD student at Aarhus, tried asking Claude and amazingly the machine spat out a solution!
It really was "A Solution" in the same way that I'd submit "A Solution" to my differential equations homework at 11:59:59. 
The code was extremely repetitive and did not make use of good abstractions. 
Many of the proofs were unmaintainable trash that would need to be completely rewritten, not even worth refactoring. 

But, much like the differential equations assignments I made my TA's suffer through, there were a few good nuggets amidst the muck.
The code made use of some lemmas from the Lean core libraries that I didn't know about, and presented a refactoring that caused some of the dependent type errors I was running into to disappear.
Once this pattern was uncovered, I was able to make progress on the actual proofs.

Claude _did not_ produce a good solution, it produced a statistically unsurprising one that I didn't have the data to see.

This brings us back to André.

> The worst thing of all was that I'd been trapped by an odd series of circumstances 
> into agreeing to have dinner with a man I'd been avoiding literally for years.
> His name was André Gregory.

My main research project these days involves formalizing a bunch of math in Coquelicot, one of several Rocq libraries for real analysis. 
At this stage of the project, my time is dominated by repetitive, low-level analysis results which are very well-studied, and for which the Coquelicot developers have already laid the foundations to formalize.

My experience with Iris-Lean led me to try out AI for these tasks, and I've been doing so for a few weeks now. 
This morning, I had a good and relatively typical experience with the AI, so I decided now would be a good time to record my experiences with the tool so far.

## Prelude

I use the $20 per month Claude Pro plan with Claude Code. 
I actually use two of them; over the last few weeks I've found myself hitting the recently-implemented bandwidth caps almost every session, despite making a concerted effort to be efficient with my usage.
For one example, on each query I individually decide whether or not to use the "thinking" feature. 
Aside from efficiency I've found that this often improves performance, because Claude--

Actually wait a second. 
Can I just pause to mention how much I hate the anthropomorphization of these robots?
I think it's kind of funny to refer to Claude as André Gregory but phrases like "thinking" or "hallucination" leaves a terrible taste in my mouth. 
Calling it _the bot_ feels much better.

Anyways, the bot can't _really_ think, and I've found that when I know a solution exists and should be simple to find I actually want it to "think" less.

The bot is basically unusable for my purposes without Rocq-MCP: this is an extension to Claude Code which allows the bot to create and manipulate Rocq proof goals.
It doesn't edit Rocq files directly, it'll use Rocq-MCP come up with a complete (checked) proof and then offer to insert the text into my file. 
For some ridiculous reason the process of translating a complete Rocq-MCP proof to my proof script is lossy.
I suspect that the bot is just looking over its chat history to reconstruct a proof script out of the tactics it executed, so sometimes it will create a correct proof and then the script it gives you back fails to typecheck. 
I've found that asking it to fix these type errors can lead to loops where it just iteratively guesses and makes the solution worse, so I typically just fix its proofs myself.
Not a big deal for me, because I'm running this thing in a highly supervised environment, but clearly it's not smart enough to be left to its own devices.


The bot actually prefers to not use Rocq-MCP and guess wildly at possible solutions instead.
To rectify this, I added a section to my ``CLAUDE.md``:
```
## General Theorem Proving Guidelines (IMPORTANT!)

- When writing proofs in Coq/Rocq I am REQUIRED to check all proofs using Rocq-MCP, and I 
  should never try to guess a complete proof script. 
- I am supposed to write in the Coquelicot style, sticking mainly to lemmas and results from 
  Coquelicot where possible.
- I am encouraged to search the Coquelicot source code for similar proofs that I can mimic.
- I may be allowed to add hypotheses to the lemmas I am proving. If I want to do this, I am 
  supposed to pause and ask the user for permission.
- If I am stuck, the user prefers that I pause and ask them for guidance. 
- Generally speaking, be concise.
- DO NOT USE BULLETS in Rocq-MCP. Bullets are known to be buggy. Focus goals using curly 
  brackets instead.
```
Despite being labeled as ``IMPORTANT!``, the bot typically forgets all about my rules. 
At the beginning of a proof session, or when I see that it's forgotten about them, I typically ask if it "remembers" my proof guidelines. 
It then apologizes and spits them back to me verbatim, and for a while, the train will be back on the tracks.

I've found that this strategy of asking rhetorical questions, like asking for a summary of the theorems I know I want it to use, works pretty well. 
It's the same technique I used when TA'ing undergrads, funny enough. 
Today it also told me, and I'm not kidding,
```
You're right, I apologize! Let me actually prove the goals.
```
Which I also have heard from undergrads as well. 

## Act 1

The theorem I used it to prove today is sometimes colloquially known as a _periodisation lemma_. 
In this case, I want to show that the improper integral of a function from zero to infinity can be split up by the decimal parts of the real number. 

To start, I stated the theorem in a Rocq file that had access to all of my lemmas, and then asked it to explain to me why the theorem is true (N.B. `RInt_gen` is a Coquelicot improper integral, `SeriesC` is a sum, and `RInt` is the regular Riemann integral):
```coq
Lemma RInt_sep (F : R → R) (UB : nat → R) :
      RInt_gen F (at_point 0) (Rbar_locally Rbar.p_infty) 
    = RInt (fun x => SeriesC (fun (k : nat) => F (x + k))) 0 1
Proof. Admitted.
```
Of course, this theorem isn't true.
There are a number of convergence properties you need to assume about ``F`` for this to be provable (in this setting, I don't care about the most general theorem, just about proving this theorem with the lemmas available to me, and leaving assumptions that will be provable for the single ``F`` I care to instantiate it with).
Off the top of my head I couldn't remember what they were, so I told the bot that if it wanted additional hypotheses, it could ask me for them. 

The bot produced a convincing-looking breakdown of the proof into three steps. 
```
  Goal: Prove that ∫[0,∞) F = ∫[0,1] Σ_{k=0}^∞ F(x+k) dx

  Step 1: Express improper integral as series of proper integrals

  - Transform: ∫[0,∞) F = Σ_{k=0}^∞ ∫[k,k+1] F
  - This decomposes the infinite interval into a sum of unit intervals

  Step 2: Change of variables in each integral

  - Prove: ∫[k,k+1] F(t) dt = ∫[0,1] F(x+k) dx for each k
  - This is a translation/substitution lemma shifting each interval to [0,1]

  Step 3: Apply Fubini to exchange series and integral

  - Swap the order: Σ_{k=0}^∞ ∫[0,1] F(x+k) dx = ∫[0,1] Σ_{k=0}^∞ F(x+k) dx

  Combining all steps:

  ∫[0,∞) F = Σ_k ∫[k,k+1] F
          = Σ_k ∫[0,1] F(x+k) dx
          = ∫[0,1] Σ_k F(x+k) dx
```

Of course, I already knew that the proof would look something like this.
Maybe I would have done the steps in a different order or something, but generally speaking when the bot comes up with a plausible plan I follow its lead or it might get confused by my micromanagement. 
Letting it follow its nose and then modifying a complete (or incomplete) proof script after the fact is generally easier.

I also knew that step 3 was proven and used many times in this repository, and there were a couple bot-generated examples of steps similar to step 1 as well. 
I asked it to get started on the first goal, and it generated the following helper lemma, which relates an integral from 0 to ``N`` with a partial sum of integrals over unit intervals.
```coq
Lemma RInt_decompose_nat (F : R → R) (N : nat) :
  (∀ k : nat, (k < N)%nat → ex_RInt F (INR k) (INR k + 1)) →
  ex_RInt F 0 (INR N) →
  RInt F 0 (INR N) = sum_n (fun k => RInt F (INR k) (INR k + 1)) (N - 1).
```
I say _something like_ because partway through this conversation it needed to compact, and the original statement was lost to time. 
The bot does an okay job summarizing the conversation before the compaction, but it's not perfect.
Compaction is super annoying. 


Anyways, the version it came up with was not provable: it has an off-by-one error.
The bot got stuck proving the base case and asked me for help due to my instructions.
I suggested that we just try to prove the actual theorem, and come back to this statement if we needed it. 
We did, and eventually we would converge on a version that was both correct and provable:
```coq
Lemma RInt_decompose_nat (F : R → R) (N : nat) :
  (∀ k : nat, (k <= N)%nat → ex_RInt F (INR k) (INR k + 1)) →
  ex_RInt F 0 (INR (S N)) →
  RInt F 0 (INR (S N)) = sum_n (fun k => RInt F (INR k) (INR k + 1)) N.
```
This is the same proof technique I use when I don't know how to best state a theorem, I like how some of these high-level strategies can be adapted for bot-maintainence. 

In the process of proving the correct version of this theorem the bot did make a couple transcription errors, but I fixed them and moved on. 


## Act 2

The ``RInt_decompose_nat`` lemma was used to prove the following helper lemma, which the bot both stated and proved:

```coq
Lemma RInt_gen_as_series (F : R → R) :
  ex_RInt_gen F (at_point 0) (Rbar_locally Rbar.p_infty) →
  (∀ b : R, ex_RInt F 0 b) →
  (∀ k : nat, ex_RInt F (INR k) (INR k + 1)) →
  RInt_gen F (at_point 0) (Rbar_locally Rbar.p_infty) =
  SeriesC (fun k => RInt F (INR k) (INR k + 1)).
```

This lemma makes up "Step 1" of the bot's plan: turning an improper integral into the sum of unit integrals. 
It generated a plausible proof of this fact, leaving three admits. 
One was trivial, I tried to tell the bot to do it before realizing it was much faster to do it myself.
The second and third admits were more involved, pertaining first to the convergence of the sequence of partial sums of unit integrals:
```coq
Lim_seq.ex_lim_seq (sum_n (λ k : nat, RInt F k (k + 1)))
```
and second to the fact that this sequence converges to the improper integral itself:
```coq
filterlim (λ M : nat, sum_n (λ n : nat, RInt F n (n + 1)) M) eventually
  (locally 
    (iota 
      (λ IF : R, filterlim (λ b : R, RInt F 0 b) (Rbar_locally Rbar.p_infty) (locally IF))))
```
Interestingly, the bot picked out that the difficulty in both cases had to do with the relationship between continuous and discrete limits: if `f : R -> R` converges to `L` as a function, then `f : N -> R` converges to `L` as a sequence.
The bot stated and proved this fact:
```coq
Lemma continuous_to_discrete_limit {f : R → R} {L : R} :
  filterlim f (Rbar_locally Rbar.p_infty) (locally L) →
  filterlim (λ n : nat, f (INR (S n))) eventually (locally L).
```
The proof is relatively basic, and if you told me it was hidden away in Coquelicot somewhere I would not be surprised.
I suppose now is a good time to mention: the code is not great, but for my purposes it doesn't have to be. 
This code will likely live and die in one branch of our project used once, and if we decide to reuse it I'll have to look through it by hand anyways.

I make a point out of not subjecting human reviewers to slop code. 

Somewhere around here I hit my first context limit. 
A GitHub user named Ming made a [script](https://github.com/ming86/cc-account-switcher/blob/main/ccswitch.sh) to switch between multiple Anthropic accounts and it works pretty well.
Use it at your own risk. 
Switching accounts messes up my Rocq-MCP states (you need to quit and reopen Claude code) so it's important to be careful about when it happens. 

One other note: observant readers will have spotted that the convergence conditions on ``RInt_gen_as_series`` are in fact redundant. 
The first condition requires that the integral exist on every interval `[0, b]`, and the second that it exist on every unit interval `[K, K+1]`. 
These two statements are mathematically, and provably, equivalent. 
This lemma was only used in one other place right now, so I left it.

## Act 3
Now, the hardest part of the proof was done. 
I asked it to put the remaining pieces together and implement its plan (steps two and three were to apply a change of variables and Fubini's theorem).
It got a little stuck on one silly goal in the change of variables 
```coq
have Hsimp : (λ x : R, F (x + k)) = λ y : R, scal 1 (F (1 * y + k))
```
I have no idea why it got so confused by this, but it was easy enough for me to do myself so I didn't stick around to find out. 

After some prodding, I got it to put the entire proof plan together, and push all the hypotheses up to the theorem statement:
```
1. ex_RInt_gen F (at_point 0) (Rbar_locally Rbar.p_infty) - improper integral exists
2. (∀ b : R, ex_RInt F 0 b) - all proper integrals from 0 exist
3. (∀ k : nat, ex_RInt F (INR k) (INR k + 1)) - integrals over unit intervals exist
4. (∀ k : nat, ex_RInt (fun x => F (x + INR k)) 0 1) - shifted integrals exist
5. ex_seriesC UB - uniform bound series converges
6. (∀ x n, 0 < x < 1 → 0 <= F (x + INR n)) - non-negativity for Fubini
7. (∀ x n, 0 < x < 1 → Rabs (F (x + INR n)) <= UB n) - uniform bound for Fubini
 ```
These hypotheses are... interesting. 
And by interesting I mean redundant. 
I believe that telling the bot that it could assume convergence conditions meant that it made no absolutely attempt to minimize the number of these assumptions. 

I got it to derive hypotheses 3 and 4 in terms of the other ones, but it missed the fact that #2 is a consequence of #1. 
When asked further it seemed to start cooking up a plan, but I don't really care for my application anyways, so I'll leave it. 

The bot, of course, got struck by some terrible unification error caused (I think) by an error when translating its Rocq-MCP proof.
Fortunately I am an expert in terrible unification errors, so I just solved it for the bot instead of wasting any more time.

## Finale 

[The final code](https://github.com/logsem/clutch/blob/523c667b6328f6fd0d749d61b89e60c976815483/theories/eris/examples/math.v#L14)


Overall, I would say the bot helped me here. 
Remembering all the theorems to use, and brute-forcing parts myself, would have taken a lot longer. 
I normally work concurrently on other parts of the development while the bot is going--this time I was reading a paper and planning one of our next examples that depended on this theorem.

My experience with this example is fairly representative of the cases where I've given the bot a theorem I knew how to prove with tools I knew it already had access to (for example, the Fubini exchange it used in Step 3, which we derived a while ago).
Even for some really twisted theorems, like quadruple-nested limit exchanges that I only vaguely think are true but would be uncomplicated to prove if so, it can do pretty good as long as it doesn't need to be clever.

Clever theorems are different, for those I run it in the hope that the impending car crash will teach me something about automotive safety.
I got it to help me prove the Weierstrass M-Test: the result that a series of nonnegative functions converges uniformly when the functions have uniform upper bounds which also converge.
My first few attempts at getting the bot to prove this were a complete loss, even when the bot was pointed to a complete (correct) mathematical proof. 
For reasons I could not discern, a later attempt managed to fail into a state which admitted only some facts about the tail bounds on the respective series, which I was able to prove myself.
Sometimes, even when the bot gets stuck, its attempts can show me the way through the tricky manipulations that I get stuck on myself.

Will I keep using the bot?
Probably. 
I'm still not happy with not knowing how bad this is for the environment, but in all honesty I think the jury is still out on individual usage.
I have literally not once wanted to use this for anything outside of technical work and I don't expect that to change, I've also played around with their "Opus" model but it really doesn't fit a niche in my work like this basic model does so I can't really see myself upgrading either.
I'll definitely downgrade to one plan though, lol.

Every now and then I pick up some new Coquelicot idioms from André, I mean the bot, I mean Sylvie Boldo and Catherine Lelay and Assia Mahboubi and Micaela Mayero and Guillaume Melquiond, the authors of Coquelicot. 
The bot doesn't do anything new (it has repeatedly shown itself to be too stupid do so when asked), but it is very good at repackaging the hard-wrought insights of real scientists. 
And that's great. 
Forget all the "AGI" noise: the quicker you can walk the well-trodden path, the more energy you will have when you hit the frontier. 

Like _My Dinner with André_, there's no grand conclusion to this story. Like I said, that's not my job, and now it is time for you to leave. 
Dinner is over and I've got more stuff to get to. 

> I treated myself to a taxi, I rode home through the city streets. [...]
> When I finally came in, Debby was home from work, and I told her everything about my dinner with André.
