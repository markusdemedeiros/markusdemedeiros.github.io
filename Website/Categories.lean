import VersoBlog

open Verso.Genre.Blog.Post

/-! The labels shown in the "Content" column of the post table. -/

namespace Website.Cat

def blogging : Category where
  name := "meta"
  slug := "meta"

def academics : Category where
  name := "academics"
  slug := "academics"

def iris : Category where
  name := "iris"
  slug := "iris"

def irisLean : Category where
  name := "iris-lean"
  slug := "iris-lean"

def theoremProving : Category where
  name := "theorem proving"
  slug := "theorem-proving"

end Website.Cat
