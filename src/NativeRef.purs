module NativeRef (new, read, write, modify, Ref) where

import Prelude
import Effect (Effect)
import Erl.Data.Tuple (Tuple2, uncurry2)

-- | Handle to a thread-safe reference to a shared value
foreign import data Ref :: Type -> Type

foreign import refEq :: forall a. Ref a -> Ref a -> Boolean

instance Eq (Ref a) where
  eq = refEq

-- | Create a new ref containing value 'a'
foreign import new :: forall a. a -> Effect (Ref a)

--  Reads the latest value from the reference
foreign import read :: forall a. Ref a -> Effect a

-- | Writes a value to the reference
-- | Note: This will block if the reference is presently locked
foreign import write :: forall a. a -> Ref a -> Effect Unit

modify :: forall a. (a -> a) -> Ref a -> Effect a
modify f ref = do
  uncurry2
    ( \lock v -> do
        let n = f v
        _ <- writeWithLock n lock
        pure n
    )
    =<< readWithLock ref

-- | A write-lock for a reference to a shared value
-- | Note: This is not thread safe and is designed for short-term-use only
-- | It is here to support 'modify' functionality only
foreign import data RefLock :: Type -> Type

-- | Reads the value and takes out a lock on writing the value
-- | Note: This is here to support 'modify' functionality and should be used with caution
foreign import readWithLock :: forall a. Ref a -> Effect (Tuple2 (RefLock a) a)

-- | Writes a value to the reference the lock was taken out on
-- | Note: This is here to support 'modify' functionality and should be used with caution
foreign import writeWithLock :: forall a. a -> RefLock a -> Effect Unit
