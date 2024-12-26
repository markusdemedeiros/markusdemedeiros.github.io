---
title:  'Eileen: A plan for Iris in Lean'
date: 'Unpublished'
content: 'Lean'
...

Iris is a world-class framework for developing verified program logics. 


(TODO: More about Iris)


(TODO: More about Lean)


Why do we want Iris in Lean? 

- **Enhanced metaprogramming**. 

- **Performance**.

- **Hindsight**. Iris is the best in its class, but it is also the first in its class. A reimplementation (in any language) gives us the opportunity to re-evaluate the features which are useful from Iris in Lean, and open up areas where we think Iris can grow. 

Why do *I* want to write Iris in Lean?

- As a Lean user, I want to understand the mechanization techniques that makes large verification projects possible. 

- As an Iris user, I want to deeply understand the components of Iris. 

- As a researcher into probabilistic verification, I want to write program logics that can make use of the extensive probability theory development in Mathlib. 

This project, dubbed *Eileen* (a ?? of iLean), is my attempt to realize this vision. 


## The Road to Iris in Lean 

Since this project is larger than anything I've tried before, a realistic plan to reimplement Iris in Lean must have off-ramps at several points in the project where failure does not mean I've wasted my time (unlike a rote translation effort, for example).

### Preparation
- Prior Art
  + Read (and annotate) the main line of Iris papers
  + Learn about metaprogramming in Lean
  + Learn about how Mathlib organizes large mathematical developments. For example, how they structure their typeclass hierarchies.
  + Read the existing Lean Iris paper.
- Planning
  + Take inventory of the existing Iris development
  + Plan realistic milestones, including the smallest number of theorems and definitions to implement them (in dependency order)
 
Over the last few months, I have focused on the reading the past literature, and improving my skills as a Lean developer. 

This blog post will take the next step: starting the planning phase of this project. 

## An Inventory of Iris

There are ?? files in Iris, organized into ?? modules, and including approximately ?? lines of code. 

(TODO: Insert dependency graph)

To get my bearings in this development, I will go through each file in dependency order, and write a deliberately over-simplified summary of its contents.
This is far from a complete summary of the Iris development, but I feel that it is a necessary step in developing a realistic plan for the project. 


### ``iris/prelude/``
    (TODO: Insert dependency graph)
    
| File        | Description |
|-------------|-------------|
| `options.v` |             |
| `prelude.v` |             |


### ``iris/algebra/``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| `ofe.v` | |
| `cofe_solver.v` | |
| `monoid.v` | |
| `cmra.v` | |
| `excl.v` | |
| `big_op.v` | |
| `cmra_big_op.v` | |
| `updates.v` | |
| `local_updates.v` | |
| `gset.v` | |
| `gmultiset.v` | |
| `coPset.v` | |
| `csum.v` | |
| `mra.v` | |
| `list.v` | |
| `functions.v` | |
| `sts.v` | |
| `proofmode_classes.v` | |
| `numbers.v` | |
| `frac.v` | |
| `ufrac.v` | |
| `dfrac.v` | |
| `gmap.v` | |
| `vector.v` | |
| `agree.v` | |
| `max_prefix_list.v` | |
| `view.v` | |
| `auth.v` | |
| `reservation_map.v` | |
| `dyn_reservation_map.v` | |


### ``iris/algebra/lib/``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |

### ``iris/bi/``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |

### ``iris/si_logic/``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |

### ``iris/proofmode/``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |

### ``iris/bi/lib``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |

## ``iris/base_logic/``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |

## ``iris/base_logic/lib/``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |

## ``iris/program_logic/``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |

## ``iris/heap_lang/``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |

## ``iris/heap_lang/lib``

(TODO: Insert dependency graph)
    
| File    | Description |
|---------|-------------|
| | |




- Unstable?
- SI logic is independent, could be good first milestone?
- excl: possible milestone
