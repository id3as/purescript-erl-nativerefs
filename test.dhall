let conf = ./spago.dhall

in    conf
    ⫽ { sources = conf.sources # [ "test/*.purs" ]
      , dependencies = conf.dependencies # [ "effect", "assert", "erl-test-eunit", "free", "erl-lists"]
      }
