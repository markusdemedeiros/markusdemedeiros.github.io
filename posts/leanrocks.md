---
title:  'Lean 4 is the Greatest to Ever Do It'
date: 'March 20, 2026'
content: ''
...

Someone, I don't know who, once said that Lean is the Python of theorem provers. 
I'm can't be sure if they meant it derisively, but I've certainly heard this comparison made derisively since. 

The thing is... they're right. 
Lean 4 is the Python of theorem provers. 

It's also the greatest theorem prover to ever do it. 

## Garbled Circuits
Lately I've been trying to get a footing in the field of multi-party computation. 
Specifically, I've been looking at some of the proofs of security for _garbled circuits_.

Circuit garbling is the most passive-aggressive possible way to evaluate a logical circuit: the technique allows two people to collaboratively evaluate a (boolean) function while being perfectly coy about their inputs. 
The key idea is pretty simple. 
You, the garbler,[^1] start off with a logical circuit known to both parties:

<p align="center">
![](../img/FullAdder.svg "A full adder circuit, credit WikiMedia"){#id .class width=60%} 
</p>

Then, for each wire `W`, you generate two encryption keys: a key to represent that <span style="color:#FF6600">[🔑 W is False]</span>, and another for when <span style="color:#0099FF">[🔑 W is True]</span>.
Using these keys you can generate truth tables for each gate in the circuit, for example that of an `AND` gate:

<center>
| Input A | Input B | Output C |
| ------- | ------- | -------- |
| <span style="color:#FF6600">[🔑 A is False]</span> | <span style="color:#FF6600">[🔑 B is False]</span> | <span style="color:#FF6600">[🔑 C is False]</span> |
| <span style="color:#FF6600">[🔑 A is False]</span> | <span style="color:#0099FF">[🔑 B is True]</span>  | <span style="color:#FF6600">[🔑 C is False]</span> |
| <span style="color:#0099FF">[🔑 A is True]</span>  | <span style="color:#FF6600">[🔑 B is False]</span> | <span style="color:#FF6600">[🔑 C is False]</span> |
| <span style="color:#0099FF">[🔑 A is True]</span>  | <span style="color:#0099FF">[🔑 B is True]</span>  | <span style="color:#0099FF">[🔑 C is True]</span> |
</center>

The (and I am so sorry for what I am about to write) _key_ step is to take this truth table and turn it into a table of four encrypted values, where you use the input keys to encrypt the output.
For example, to read off the third row in the truth table for this `AND` gate, I need to use a <span style="color:#0099FF">[🔑 A is True]</span> key and a <span style="color:#FF6600">[🔑 B is False]</span> key, in order to unlock the <span style="color:#FF6600">[🔑 C is False]</span> key it contains.
<center>
| Garbled Gate |
| ------------ |
| <span style="color:#FF6600">[🔒 A is False]</span> <span style="color:#FF6600">[🔒 B is False]</span> <span style="color:#FF6600">[🔑 C is False]</span> |
| <span style="color:#FF6600">[🔒 A is False]</span> <span style="color:#0099FF">[🔒 B is True]</span> <span style="color:#FF6600">[🔑 C is False]</span> |
| <span style="color:#0099FF">[🔒 A is True]</span> <span style="color:#FF6600">[🔒 B is False]</span> <span style="color:#FF6600">[🔑 C is False]</span> |
| <span style="color:#0099FF">[🔒 A is True]</span> <span style="color:#0099FF">[🔒 B is True]</span> <span style="color:#0099FF">[🔑 C is True]</span> |
</center>

Importantly, while I've labeled every term in this table with the details of how it is encrypted, to anyone else this table and all of the keys just looks like indistinguishable junk, that you decrypt using other indistinguishable junk:
<center>
| Garbled Gate |
| ------------ |
| 0x0D4A4F482F4005CD78C47FB2F4B98A8D |
| 0xB66C7CDEC56F9D9FE1B23D7DF7F4E7DE |
| 0xA5CF86BAFA02BC551F76E7B580EA2994 |
| 0x8913DADB3B5AC434D1A12CF2E2DEAA0F |
</center>

Now we can collect all of these junk tables, and the junk keys corresponding to the real values of our inputs to the circuit, and give them to our friend Bob. 
Glossing over some details, it is possible for us to also provide Bob a service for secretly obtaining the truth or falsity keys for _his_ secret inputs, and now, Bob has everything he needs to evaluate the circuit. 

Gate by gate, Bob can blindly try his collection of keys on the garbled tables. 
For each of them, only one entry will unlock, thereby decrypting the next key Bob needs to continue churning through the circuit. 
At the end, Bob can share the keys associated to the circuit's output wires with us, and we can figure out what they mean. 

At no point in this procedure do _we_ learn anything about Bob's input, and all Bob is doing is trying a bunch of random-looking keys on a bunch of random-looking locks, so he doesn't learn anything about our input either. 
Perfect for passive-aggressives everywhere!

## Where's the but?

If we give the table above, and he unlocks the third entry, he learns for sure that A is True, B is False, and that they key he found is the key representing <span style="color:#FF6600">[🔑 C is False]</span>.
This is because a table is _ordered_: the index of an unlocked entry leaks what that entry means.
It is important for circuit garbling algorithms to randomly permute the table entries before publishing them: the order doesn't matter to a truthful Bob, and an index into a permuted table tells you nothing about its input. 

Except that's not all. 
When a physical lock doesn't open it's easy to tell. 
One time I got locked out of my house in the frigid Canadian winter: standing outside waiting for my mom to get home I could tell you with a high degree of confidence that the lock did not open. 
Digital locks aren't always the same. 
Some encryption algorithms will tell you when they fail to open, but simpler ones like a one-time pad or SHA will not! 
Assuming we are properly generating keys, it should not be possible to distinguish a property-decrypted key and improperly-decrypted trash just by looking at it. 

A popular and elegant way to solve this is called _point-and-permute_, where each entry in the table also stores information about how the next table is permuted.
Under point-and-permute, Bob gets an indicator towards the _one_ lock which is sure to open.

To do this, we generate a bunch of random bits, we `XOR` these bits with the truth or falsity each key represents, and store them alongisde the keys in each row of the table, `XOR`ing as appropriate.
Continuing with boolean magic, we use these bits to permute the tables in a deterministic manner. 
Bob can use the permutation bits he decrypts to figure out which entry in the table to read, but he also doesn't figure out how the table was permuted.

Look if this sounds confusing and like it surely must leak information somehow, join the club.
I was totally lost about how point-and-permute worked about this for longer than I'd like to admit. 
There are so many little details in this algorithm, like how we can store these pointing bits while also not leaking the truth or falsity they represent, or which information is safe to send to Bob, and they are all critical to the algorithm's security and correctness.
Moreover, point-and-permute is a core algorithm in MPC, and a lot of the follow-on circuit garbling literature I want to read depends on a good understanding of how this technique works.

## It's Lean Time

As someone with no formal training in cryptography, I found many of the descriptions of this algorithm to be.... appropriately cryptic. 
So, to figure it out, I decided to try implementing it in my favorite proof assistant.

The goal here was not to write good code, or to copy code from somewhere and read it (I've actually already tried the latter to no avail!).
My goal was to collect all the little bits and pieces I understood about point-and-permute, and try to assemble a hideous circuit garbling algorithm _which I understand_.

So let's do that, let's make `MicroCircuit.lean`, a tiny version of gabled circuits.

## Circuits

Acycylic boolean circuits, the kind used in MPC, are simple data structures, and they're easy to make _micro_.
In that spirit, I'll just use natural numbers for the names of my wires.

```
inductive GateT | And | Xor

def GateT.eval : GateT → Bool → Bool → Bool
| .And => and
| .Xor => xor

structure Gate where
  prim : GateT
  wA : Wire
  wB : Wire
```

I'll evaluate the circuit in a Debruijn-y manner, binding the result of each gate to the `0` wire, incrementing the rest of the names. 
This way my evaluator can take the inputs as a list of values, and each step of evaluation pushes onto it.
Seems pretty stateful so I'll use the state monad transformer, which I don't need to dig up from some crazy external dependency because honestly you should always have the state monad.

```
abbrev CircuitEvalM := StateT (List Bool) Id

def Gate.eval (g : Gate) (l : List Bool) : Bool :=
  let vA := l[g.wA]!
  let vB := l[g.wB]!
  g.prim.eval vA vB

def Circuit.eval (c : Circuit) : CircuitEvalM Unit :=
  match c with
  | [] => return
  | (g :: c) => do
    let l ← StateT.get
    StateT.set (g.eval l :: l)
    Circuit.eval c
```

Done. 
Well, okay not done. 
I'm very well aware that while this representation is in fact _micro_ is also majorly horrible. 
All the names change every time! 
I guess I should make my TA's proud and test it?
Of course I'll just write these simple smoke tests in-file with `#guard` statements, 

```
#guard
  ((Circuit.eval [{ prim := GateT.Xor, wA := 1, wB := 0 },
                  { prim := GateT.And, wA := 0, wB := 1 }]).run [true, true]).2 =
  [false, false, true, true]
```

Jesus lord in heaven literally cannot even tell if that is true. 
I have no idea how to read that circuit. 
Fortunately, gentlemen, we can build a better syntax. 
We have the technology.

## Metaprogramming

My goal here is to just generate easy-to-read test inputs, so I'll abide by KISS and just clank together a tiny DSL.
In this language, each input and gate output gets a name, and the macro does all the index-pushing demanded by my putrid little language.

```
private def runCircuit (c : Circuit) (inputs : List Bool) : List Bool :=
  (c.eval.run inputs).2
  
private def shadowGate : Circuit := circuit(
  input A
  input B
  A ← xor A B
  A ← and A B 
)

#guard runCircuit shadowGate [true, true] = [false, false, true, true]
```

The macro is nothing spectacular, but it took like three minutes to generate using my statistical model du jour. 
Fortunately, since Lean macros are just regular imperative code, so it's pretty easy to apply the smell test and `#eval` a couple circuits to conclude that it's fine enough for now.

```
declare_syntax_cat gate_type
declare_syntax_cat circuit_stmt

syntax "and" : gate_type
syntax "xor" : gate_type
syntax "input" ident : circuit_stmt
syntax ident " ← " gate_type ident ident : circuit_stmt

syntax "circuit(" circuit_stmt* ")" : term

private def findWire : List (String × Nat) → String → Option Nat
  | [], _ => none
  | (n, idx) :: rest, name => if n == name then some idx else findWire rest name

open Lean in
macro_rules
  | `(circuit( $stmts* )) => do
    let mut numInputs := 0
    for stmt in stmts do
      if let `(circuit_stmt| input $_:ident) := stmt then numInputs := numInputs + 1
    let mut inputIdx := 0
    let mut map : List (String × Nat) := []
    let mut gates : Array (TSyntax `term) := #[]
    for stmt in stmts do
      match stmt with
      | `(circuit_stmt| input $name:ident) =>
        map := map ++ [(toString name.getId, numInputs - 1 - inputIdx)]
        inputIdx := inputIdx + 1
      | `(circuit_stmt| $out:ident ← $gt:gate_type $a:ident $b:ident) =>
        let nA := toString a.getId
        let nB := toString b.getId
        let some idxA := findWire map nA | Macro.throwError s!"unknown wire: {nA}"
        let some idxB := findWire map nB | Macro.throwError s!"unknown wire: {nB}"
        let gtSyn ← match gt with
          | `(gate_type| and) => `(GateT.And)
          | `(gate_type| xor) => `(GateT.Xor)
          | _ => Macro.throwError "unknown gate type"
        gates := gates.push (← `({ prim := $gtSyn, wA := $(quote idxA), wB := $(quote idxB) : Gate}))
        map := map.map fun (n, idx) => (n, idx + 1)
        map := (toString out.getId, 0) :: map
      | _ => Macro.throwError "unknown circuit statement"
    `([$gates,*])
```

There are a couple problems with this macro and if I end up using this I'll rewrite it.
It'll be great practice!
But I'm not doing that today, because today I'm learning about MPC, and that does not stand for Macro Polishing Crap.

I have bigger tests now, and my evaluator seems fine, so onward we go.

## FFI

So my pure evaluator, the one which does no encryption, works fine and will serve as a spec. 
Now I need to do some cryptography. 
I started by searching for Lean cryptography packages and realizing none suited my needs I broke out the SHA spec and...

Kidding. 
I did none of that.
The first think I did was smash my dumb fingers into my keyboard until I got a google hit for "C library encryption" and, yep, OpenSSL exists, looks fully featured, and is already installed on my computer.
Their wiki even has a tutorial example of encrypting and decrypting with SHA, which is great beacause I've never written cryptographic code in my life.

I put together a little Lean file with my bindings and dumped the OpenSSL SHA tutorial in a C file, and then [glued](https://github.com/markusdemedeiros/Metrology/blob/main/Metrology/LibCrypto/LibCryptoBindings.c) on some [boilerplate](https://github.com/markusdemedeiros/Metrology/blob/main/lakefile.lean) to make Lean link it all together.

```
@[extern "enc_aes128_c"]
opaque encAes128 : ByteArray → ByteArray → ByteArray → ByteArray

@[extern "dec_aes128_c"]
opaque decAes128 : ByteArray → ByteArray → ByteArray → ByteArray
```
Astute readers will notice that there is no `IO` in the above declarations, because the Lean compiler now treats my OpenSSL encryption and decryption just like any other function.
You can't prove anything about it other than its existence (Lean enforces that extern'd definitions are declared only by inhabited types!), but that's fine, and I'll be happy not to write `IO` everywhere.

And now I can encrypt and decrypt with SHA, and if I want to change to a encryption that can detect mis-decryptions or tweak the block sizes or anything I can follow the battle-tested OpenSSL documentation instead of some bespoke Lean implementation.
I wouldn't want to use it for real crypto, but it's good enough for my testing!

I wrote lakefile and FFI boilerplate myself based off of a prior project I did, mostly because I did want some extra practice on this, but I got a LLM to check my work and I'm certain it could have done it itself. 
Next time I bet I'll get it first try.

## Weren't you trying to implement something?

Right. Garbling.
As I mentioned several hundred lines ago, each table entry contains a key (128 bit) and a permutation bit. 
```
structure WireState where
  key : Key
  perm : Bool
```
Each `WireState` needs to be serialized into a 256-bit `ByteArray` for encryption. 
This is easy enough to do, but due to the fundamental theorem of bitwise programs being always incorrect, we might as well write an easy proof that our serializer behaves properly.
```
def WireState.encode (w : WireState) : Encoding :=
  w.key + (w.perm.toNat <<< 128)

def Encoding.decode (e : Encoding) : WireState where
  key := e &&& (2^128 - 1)
  perm := (e >>> 128) == 1

theorem WireState.encode_decode {w : WireState} (Hk : w.key < 2^128) :
    w.encode.decode = w := by
  obtain ⟨k, p⟩ := w
  simp only [WireState.encode, Encoding.decode, Nat.shiftLeft_eq, mk.injEq] at Hk ⊢
  rw [Nat.and_two_pow_sub_one_eq_mod, Nat.shiftRight_eq_div_pow]
  cases p <;> simp [Bool.toNat, Nat.add_mod_right, Nat.mod_eq_of_lt Hk,
    Nat.add_div_right _ (by omega : (0:Nat) < 2^128), Nat.div_eq_of_lt Hk] <;> omega
```

Now we can write the code to construct an individual encrypted row of the tables, and to decrypt it given two keys we are confident will work.

```
def encryptTableEntry (k1 k2 : Key) (payload : WireState) : ByteArray :=
  let enc_256 := payload.encode.toByteArrayLE 32 |>.get!
  let iv_128  := GARBLE_IV.toByteArrayLE 16 |>.get!
  let k1_128  := k1.toByteArrayLE 16 |>.get!
  let k2_128  := k2.toByteArrayLE 16 |>.get!
  let cipher2 := LibCrypto.encAes128 enc_256 iv_128 k2_128
  let cipher1 := LibCrypto.encAes128 cipher2 iv_128 k1_128
  cipher1

def decryptTableEntry (k1 k2 : Key) (cipher1 : ByteArray) : WireState :=
  let iv_128  := GARBLE_IV.toByteArrayLE 16 |>.get!
  let k1_128  := k1.toByteArrayLE 16 |>.get!
  let k2_128  := k2.toByteArrayLE 16 |>.get!
  let cipher2 := LibCrypto.decAes128 cipher1 iv_128 k1_128
  let plaintx := LibCrypto.decAes128 cipher2 iv_128 k2_128
  Encoding.decode (Nat.ofByteArrayLE plaintx)
```

It was pretty easy, but to make sure, I added another `lean_exe` endpoint to my `lakefile` so I could test this code. 
Seeing actual table entries get encrypted and decrypted was very satisfying, especially once I fixed the orders that they keys were decrypting in, so that it was not returning random trash!

## The main course

The work so far has been in service of getting to this point: trying to figure out how the hell these permutation bits work. 
The trick, at a high level, is to use the permutation bit stored from one of the inputs to decide if we want to swap rows 1/2 and 3/4, and the permutation bit from the second input for the rows 1/3 and 2/4.
If these permutation bits are uniformly random to Bob, then the permutation looks uniformly random, and he doesn't learn anything from the location of the value he decrypts.

The bits must _look_ uniformly random to bob, but they can't be totally arbitrary either!
They need to correlate with the truth or falsity of each statement, because the entry that Bob ends up looking up needs to correspond to the correct locks for the keys he has access to.
This, intrepid reader, is where I spent most of my time on this project: reading papers, rereading papers, writing down truth tables, and generally living a confused existence while I tried to reconcile these facts against the implementations of point-and-permute I found floating around the web.

The key understanding came from this paper,[^2] where the author notes that 

> [The garbler] always places [the row for inputs vi and vj] in the (2 p(vi, i) + p(vj, j))th spot in the table.

where `p(vi, i)` is the value `vi` `XOR`'d with a random bit `ri` generated beforehand. 

<center><b>⚠️⚠️  <span style="color:#FF6600">THIS IS NOT THE DECLARATIVE WAY TO DESCRIBE THIS ALGORITHM!</span> ⚠️⚠️</b></center>

Sorry. 
This is not the declarative way to describe this algorithm. 
Instead of asking the question 

> "Which value goes in this slot in the permuted table?" 

for each slot in the table (as you might do if you were generating a functional-style or optimized version of point-and-permute), the algorithm described above asks 

> "When I'm generating the table entry for this pair of true inputs, which slot should I put it in?"

Imperative, unoptimized, and so much easier to understand. 
Converting the imperative description into the declarative form involves undoing the arithmetic and bitwise operations for `p(vi, i)`, and it _loses_ the clear connection between the private random bit `r` and the published value Bob decrypts using his keys.
Seeing the algorithm described this way cleared up all of my confusions about how point-and-permute was supposed to work, so we should implement that.
I could do this with a map or whatever, but because Lean supports an imperative programming style, I will just write down the obvious-looking iterative code that calculates every piece step-by-step exactly as described by the prose.
This way, I get to test my understanding _before_ doing the mental gymnastics back to the declarative versions I was reading in papers:

```
def encryptTable (ki kj kk : Bool → Key) (ri rj rk : Bool) (f : Bool → Bool → Bool) :
    Id (Table ByteArray) := do
  let mut t : Table ByteArray := ⟨.empty, .empty, .empty, .empty⟩
  for vi in [false, true] do
    for vj in [false, true] do
      let pi := xor vi ri
      let pj := xor vj rj
      let vk := f vi vj
      let pk := xor vk rk
      let E : WireState := { key := kk vk, perm := pk }
      t := t.set pi pj (encryptTableEntry (ki vi) (kj vj) E)
  return t

def decryptTable (wi wj : WireState) (t : Table ByteArray) : Id WireState := do
  let ⟨ki, si⟩ := wi
  let ⟨kj, sj⟩ := wj
  decryptTableEntry ki kj (t.get si sj)
```

And wouldn't you know it, my gate garbling procedure is complete, and lifting it to circuits is straightforward.
I plugged in a binary full adder, double checked its truth table to ensure my hacked up metaprogramming was still fine, and then checked that the garbled evaluator computes and matches as well:
```
def test_garble_adder : IO Unit := do
  exhaustive3 (circuit(
    input A
    input B
    input Cin
    AB   ← xor A B
    S    ← xor AB Cin
    AB2  ← and A B
    CAB  ← and Cin AB
    Cout ← xor AB2 CAB ))
  IO.println "garble adder: all passed"
```
    
All passed. Bingo.


## Conclusion

I'm a well-known Lean glazer. 
I fucking love this shit. 
And for what it's worth, I also genuinely do not know of another tool that can do all of the following:

- ML-style (not insane) functional programming
- Metaprogramming so easy you can do it just to make your life easier
- Access to every C library ever written
- Honest to god proofs for your pure code
- Monadic style (not insane) imperative programming.

It's just... so easy to do all of this stuff when the moment calls.
This was so easy I could _actually use it to understand something_! 
I was _assisted_! 
By my _proof assistant_!

Maybe I could have written this in Rust, if I wanted to rip out those horrid circuit AST's by hand and pray to god I didn't accidentally do bit casts wrongly in my serializer.
Or maybe I could have written it in Rocq, I mean Metarocq, I mean called Joomy and asked him how to defile Rocq enough to link against C.
Or maybe I could have written it in Python, the Lean of the programming languages world, and... 

Or maybe I could have used something else. 
I'll leave Lean in a second if something better comes along, but for now, man, Lean is the greatest to ever do it. 

[^1]: 🫵 garbler! 
[^2]: A Gentle Introduction to Yao’s Garbled Circuits, Sophia Yakoubov
