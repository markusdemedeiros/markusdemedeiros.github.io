import VersoBlog

open Lean (Html)

/-! Publication lists, kept as data and rendered to the same HTML the old site used. -/

namespace Website

structure Paper where
  title : String
  authors : List String
  venue : String
  /-- Text placed before the venue, such as "Submitted to". -/
  status : String := ""
  award : Option String := none
  /-- Pairs of link label and URL. -/
  links : List (String × String) := []

def me : String := "Markus de Medeiros"

def Paper.toHtml (p : Paper) : Html :=
  let authors := p.authors.toArray.mapIdx fun i a =>
    let name : Html := if a == me then html%{<em>{a}</em>} else .text a
    if i == 0 then name else .seq #[.text ", ", name]
  let award : Html := match p.award with
    | none => .empty
    | some a => html%{<u style="color: #FF0019; padding: 5pt">{s!" {a} "}</u>}
  let links := p.links.toArray.map fun (label, url) =>
    html%{<a href={url}>{s!" [ {label} ] "}</a>}
  html%{
    <li>
      <ul class="paper_item">
        <li><b>{p.title}</b></li>
        <li>{.seq authors}</li>
        <li>{p.status}<b>{p.venue}</b>{" "}{award}{.seq links}</li>
      </ul>
    </li>
  }

def paperList (papers : List Paper) : Html :=
  html%{<ul class="papers__main">{.seq (papers.toArray.map Paper.toHtml)}</ul>}

def publications : Html := paperList [
  { title := "Verifying Exact Samplers for Continuous Distributions with a Discrete Program Logic"
    authors := [me, "Puming Liu", "Kwing Hei Li", "Alejandro Aguirre", "Lars Birkedal", "Joseph Tassarotti"]
    venue := "LICS 2026"
    links := [("DOI", "https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.LICS.2026.71"),
              ("arXiv", "https://arxiv.org/abs/2605.13526")] },
  { title := "Place Capability Graphs: A General-Purpose Model of Rust's Ownership and Borrowing Guarantees"
    authors := ["Zachary Grannan", "Aurel Bíly", "Jonáš Fiala", "Jasper Geer", me, "Peter Müller", "Alexander J. Summers"]
    venue := "OOPSLA 2025"
    links := [("DOI", "https://dl.acm.org/doi/10.1145/3763122")] },
  { title := "Verified Foundations for Differential Privacy"
    authors := [me, "Muhammad Naveed", "Tancrete Lepoint", "Temesghen Kahsai", "Tristan Ravitch",
                "Stefan Zetzsche", "Anjali Joshi", "Joseph Tassarotti", "Aws Albarghouthi", "Jean-Baptiste Tristan"]
    venue := "PLDI 2025"
    award := some "Distinguished Artifact Award"
    links := [("DOI", "https://dl.acm.org/doi/10.1145/3729294"),
              ("arXiv", "https://arxiv.org/abs/2412.01671"),
              ("Cryptology ePrint Archive", "https://eprint.iacr.org/2024/2040")] },
  { title := "Tachis: Higher-Order Separation Logic with Credits for Expected Costs"
    authors := ["Philipp G. Haselwarter", "Kwing Hei Li", me, "Simon Oddershede Gregersen",
                "Alejandro Aguirre", "Joseph Tassarotti", "Lars Birkedal"]
    venue := "OOPSLA 2024"
    links := [("DOI", "https://dl.acm.org/doi/10.1145/3689753"),
              ("arXiv", "https://arxiv.org/abs/2405.20083")] },
  { title := "Error Credits: Resourceful Reasoning about Error Bounds for Higher-Order Probabilistic Programs"
    authors := ["Alejandro Aguirre", "Philipp G. Haselwarter", me, "Kwing Hei Li",
                "Simon Oddershede Gregersen", "Joseph Tassarotti", "Lars Birkedal"]
    venue := "ICFP 2024"
    award := some "Distinguished Paper Award"
    links := [("DOI", "https://dl.acm.org/doi/10.1145/3674635"),
              ("arXiv", "https://arxiv.org/abs/2404.14223")] },
  { title := "Spike Solutions to the Supercritical Fractional Gierer-Meinhardt System"
    authors := ["Daniel Gomez", me, "Jun-Cheng Wei", "Wen Yang"]
    venue := "J. Nonlinear Sci. 2024"
    links := [("DOI", "https://doi.org/10.1007/s00332-023-10002-6")] },
  { title := "Existence and stability of symmetric and asymmetric patterns for the half-Laplacian Gierer-Meinhardt system in one-dimensional domain"
    authors := [me, "Jun-Cheng Wei", "Wen Yang"]
    venue := "M3AS 2022"
    links := [("DOI", "https://www.worldscientific.com/doi/10.1142/S0218202522500270")] }
]

def preprints : Html := paperList [
  { title := "Iris in Lean"
    authors := [me, "Sergei Stepanenko", "Zongyuan Liu", "Oliver Soeser", "Fernando Leal", "Alvin Tang",
                "Max Vistrup", "Ralf Jung", "Mario Carneiro", "Joseph Tassarotti", "Michael Sammler", "Lars Birkedal"]
    status := "Submitted to "
    venue := "CPP 2027"
    links := [("arXiv", "https://arxiv.org/abs/2609.24252")] }
]

end Website
