# purescript-erl-nativeref

A process-less implementation of Effect.Ref using nifs.

Using
-----

To use this package you will need to:

- Add erl-nativeref to your spago.dhall 
- Add the erlang dependency containing the nif to your rebar.config ( [https://github.com/id3as/nativerefs](https://github.com/id3as/nativerefs) ).
- Add nativerefs to your application dependencies (your app.src)

With a fair wind, your Purescript will just work with

```

import NativeRef as Ref

cool :: Effect Unit
cool = do
  ref <- Ref.new 0
  x <- Read.read -- 0
  Read.write 1 ref
  x2 <- Read.read -- 1
```


And so on.

Building/Contributing
---

In theory, you should be able to clone this repo and run rebar3 eunit, and everything will be pulled down and the tests will run. Good luck.
