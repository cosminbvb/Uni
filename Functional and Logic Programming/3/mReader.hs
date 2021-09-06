import Data.Char

--- Monada Reader

newtype Reader env a = Reader { runReader :: env -> a }

instance Monad (Reader env) where
  return x = Reader (\_ -> x)
  ma >>= k = Reader f
    where f env = let a = runReader ma env
                  in  runReader (k a) env

instance Applicative (Reader env) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor (Reader env) where
  fmap f ma = pure f <*> ma


-- monada cu functia identitate
ask :: Reader env env
ask = Reader id

-- modifica  starea doar pt computatia data
local :: (r -> r) -> Reader r a -> Reader r a
local f ma = Reader $ (\r -> (runReader ma)(f r))


-- Reader Person String
-- 1
data Person = Person { name :: String, age :: Int }

-- 1.1
showPersonN :: Person -> String
showPersonN (Person name age) = "NAME:" ++ name

showPersonA :: Person -> String
showPersonA (Person name age) = "AGE:" ++ show age

-- 1.2
showPerson :: Person -> String
showPerson pers = "(" ++ showPersonN pers ++ "," ++ showPersonA pers ++ ")"

-- 1.3
mshowPersonN :: Reader Person String
mshowPersonN = do
                p <- ask -- p :: Person pt ca ask :: Reader Person Person (cred)
                return ("Name: " ++ name p)
-- *Main> (runReader mshowPersonN) (Person "ada" 20) 
-- "Name: ada"
-- sau
-- mshowPersonN = Reader $ showPersonN >>= \pers -> return pers

mshowPersonA :: Reader Person String
mshowPersonA = Reader $ showPersonA >>= \pers -> return pers

mshowPerson :: Reader Person String
mshowPerson = do
                x <- mshowPersonN -- mshowPersonN :: Reader Person String => x :: String
                y <- mshowPersonA 
                return ("(" ++ x ++ ", " ++ y ++ ")")
-- mshowPerson = Reader $ showPerson >>= \pers -> return pers
