module Test.NativeRef where

import Prelude
import Control.Monad.Free (Free)
import Effect.Unsafe (unsafePerformEffect)
import Erl.Data.List (List)
import Erl.Test.EUnit (TestF, TestSet, collectTests, suite, test)
import NativeRef as Ref
import Test.Assert (assertEqual)

main_test_ :: List TestSet
main_test_ =
  collectTests
    $ do
        tests

tests :: Free TestF Unit
tests =
  suite "NativeRef" do
    test "creating a ref and reading its value" do
      ref <- Ref.new 100
      value <- Ref.read ref
      assertEqual { expected: 100, actual: value }
    test "writing a new value to a ref" do
      ref <- Ref.new 100
      Ref.write 50 ref
      value <- Ref.read ref
      assertEqual { expected: 50, actual: value }
    test "modifying a value in-situ" do
      ref <- Ref.new 100
      n <- Ref.modify (\a -> a + 50) ref
      value <- Ref.read ref
      assertEqual { expected: 150, actual: value }
      assertEqual { expected: 150, actual: n }
