
--- Monada Writer

newtype WriterS a = Writer { runWriter :: (a, String) }  deriving Show


instance Monad WriterS where
  return va = Writer (va, "")
  ma >>= k = let (va, log1) = runWriter ma
                 (vb, log2) = runWriter (k va)
             in  Writer (vb, log1 ++ log2)


instance Applicative WriterS where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance Functor WriterS where              
  fmap f ma = pure f <*> ma     

tell :: String -> WriterS () 
tell log = Writer ((), log)
  
logIncrement :: Int -> WriterS Int
logIncrement x = do
                     tell ("increment:" ++ (show x) ++ "\n")
                     return (x+1)

logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x 1 = logIncrement x 
logIncrementN x n = do
                     y <- logIncrement x -- y :: Int
                     logIncrementN y (n-1)

-- *Main> runWriter $ logIncrement 5
-- (6,"increment:5\n")
-- *Main> runWriter $ logIncrementN 5 4
-- (9,"increment:5\nincrement:6\nincrement:7\nincrement:8\n")              


-- Log Increment 2 cu do si bind:

logIncrement2_1 :: Int -> WriterS Int
logIncrement2_1 x = do
                    y <- logIncrement x
                    logIncrement y
-- *Main> runWriter $ logIncrement2_1 10
-- (12,"increment:10\nincrement:11\n")
logIncrement2_2 :: Int -> WriterS Int
logIncrement2_2 x = logIncrement x >>= logIncrement
-- *Main> runWriter $ logIncrement2_2 10
-- (12,"increment:10\nincrement:11\n")

combo :: WriterS Int
combo = do
          Writer(4, "ceva ")
          Writer(5, "altceva")
-- *Main> runWriter $ combo
-- (5,"ceva altceva")