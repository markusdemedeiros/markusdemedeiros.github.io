import VersoBlog
import Website

open Verso Genre Blog Site Syntax

/-- The layout of the site. Add new posts under `"blog"`; the front page lists them by date. -/
def website : Site := site Website.Front /
  static "img" ← "assets/img"
  static "stylesheet.css" ← "assets/stylesheet.css"
  static "favicon.ico" ← "assets/favicon.ico"
  static "pdf" ← "assets/pdf"
  static "spiderworld" ← "assets/spiderworld"
  static "slotmachordle.html" ← "assets/slotmachordle.html"
  "preprints" Website.Preprints
  "blog" Website.Blog with
    Website.Blog.AwesomeIrisLean
    Website.Blog.NoSlop
    Website.Blog.NycPrivacyDay
    Website.Blog.LeanRocks
    Website.Blog.Robot
    Website.Blog.Njpls
    Website.Blog.Qual
    Website.Blog.SampCert
    Website.Blog.Eileen2
    Website.Blog.PennBloomberg
    Website.Blog.Eileen
    Website.Blog.IrisLean
    Website.Blog.BscThesis
    Website.Blog.PhdOneYear
    Website.Blog.Nesvd
    Website.Blog.SurvivingYourMathDegree
    Website.Blog.HelloWorld

/--
Posts that the pandoc site served at `pages/<old name>.html`, paired with the module that now holds
them. The build leaves a redirect at each old address.
-/
def movedPosts : List (String × Lean.Name) := [
  ("awesomeirislean", `Website.Blog.AwesomeIrisLean),
  ("noslop", `Website.Blog.NoSlop),
  ("nycprivacyday", `Website.Blog.NycPrivacyDay),
  ("leanrocks", `Website.Blog.LeanRocks),
  ("robot", `Website.Blog.Robot),
  ("njpls", `Website.Blog.Njpls),
  ("qual", `Website.Blog.Qual),
  ("sampcert", `Website.Blog.SampCert),
  ("eileen2", `Website.Blog.Eileen2),
  ("penn_bloomberg", `Website.Blog.PennBloomberg),
  ("eileen", `Website.Blog.Eileen),
  ("iris_lean", `Website.Blog.IrisLean),
  ("bscthesis", `Website.Blog.BscThesis),
  ("phd_one_year", `Website.Blog.PhdOneYear),
  ("nesvd", `Website.Blog.Nesvd),
  ("surviving_your_math_degree", `Website.Blog.SurvivingYourMathDegree),
  ("hello_world", `Website.Blog.HelloWorld)
]

def redirectPage (target : String) : String :=
  "<!DOCTYPE html>\n<html>\n  <head>\n    <meta charset=\"utf-8\">\n    <title>Moved</title>\n" ++
  s!"    <link rel=\"canonical\" href=\"{target}\">\n" ++
  s!"    <meta http-equiv=\"refresh\" content=\"0; url={target}\">\n" ++
  s!"  </head>\n  <body>\n    <p>This page has moved <a href=\"{target}\">here</a>.</p>\n  </body>\n</html>\n"

def outputDir : List String → System.FilePath
  | "--output" :: dir :: _ => dir
  | _ :: more => outputDir more
  | [] => "_site"

/-- Writes a redirect at every address the old site used. -/
def writeRedirects (dir : System.FilePath) : IO UInt32 := do
  IO.FS.createDirAll (dir / "pages")
  let posts := Website.allPosts website
  let mut status := 0
  for (old, module) in movedPosts do
    match posts.find? (fun (_, post) => module.isPrefixOf post.id) with
    | some (blogDir, post) =>
      let date := (post.contents.metadata.map (·.date)).getD ⟨1900, 1, 1⟩
      let name := defaultPostName date post.contents.titleString
      IO.FS.writeFile (dir / "pages" / s!"{old}.html") (redirectPage s!"../{blogDir}{name}/")
    | none =>
      IO.eprintln s!"No post found for the old page '{old}' ({module})"
      status := 1
  IO.FS.writeFile (dir / "preprints.html") (redirectPage "preprints/")
  return status

def main (args : List String) : IO UInt32 := do
  let status ← blogMain Website.theme website (options := args)
  if status != 0 then return status
  writeRedirects (outputDir args)
