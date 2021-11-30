-module(nativeRef@foreign).

-export([ new/1
        , read/1
        , write/2
        , readWithLock/1
        , writeWithLock/2
        ]).

new(Val) ->
  fun() ->
    { ok, Ref } = nativerefs:ref_new(Val),
    Ref
  end.

read(Ref) ->
  fun() ->
    { ok, Value } = nativerefs:ref_read(Ref),
    Value
  end.

write(Value, Ref) ->
  fun() ->
      case nativerefs:ref_try_write(Ref, Value) of
        ok ->
          ok;
        busy ->
          ok = nativerefs:ref_write(Ref, Value)
      end
  end.

readWithLock(Ref) ->
  fun() ->
    case nativerefs:ref_try_read_with_lock(Ref) of
      { ok, Lock, Value } ->
     %%   io:format(user, "read-with-lock: not_busy ~n", []),
        { Lock, Value };
      busy ->
        { Time, Result } = timer:tc(fun() ->
                                        { ok, Lock, Value } = nativerefs:ref_read_with_lock(Ref),
                                        { Lock, Value }
                                    end),
        Result
    end
  end.

writeWithLock(Value, Lock) ->
  fun() ->
    ok = nativerefs:ref_write_with_lock(Lock, Value)
  end.


