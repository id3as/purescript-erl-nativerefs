{-
-}
{ name = "nativeref"
, dependencies = [ "effect", "prelude", "erl-tuples" ]
, packages = ./packages.dhall
, sources = [ "ps/**/*.purs", "ps/*.purs"]
, backend = "purerl"
}
