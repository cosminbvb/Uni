{- Monada Maybe este definita in GHC.Base 

instance Monad Maybe where
  return = Just
  Just va  >>= k   = k va
  Nothing >>= _   = Nothing


instance Applicative Maybe where
  pure = return
  mf <*> ma = do
    f <- mf
    va <- ma
    return (f va)       

instance Functor Maybe where              
  fmap f ma = pure f <*> ma   
-}
f1 :: String -> Maybe Int
f1 x = if length x >2 then Just $ length x else Nothing

g1 :: Int -> Maybe String
g1 x = if x > 0 then Just $concat $ replicate x "ab" else Nothing
-- *Main> g1<=<f1 $ "abc"
-- Just "ababab"

f2, f3, f4 :: Int -> Maybe Int
f2 x = if x>2 then Just (x*x) else Nothing
f3 x = if x>3 then Just (x+x) else Nothing
f4 x = if x> 50 then Just $ x*x*x else Nothing


(<=<) :: (a -> Maybe b) -> (c -> Maybe a) -> c -> Maybe b
f <=< g = (\ x -> g x >>= f)
-- *Main> f2 <=< f3 $ 4
-- Just 64
-- *Main> f3 <=< f2 $ 4
-- Just 32

asoc :: (Int -> Maybe Int) -> (Int -> Maybe Int) -> (Int -> Maybe Int) -> Int -> Bool
asoc f g h x = (h <=< (g <=< f) $ x) == ((h <=< g) <=< f $ x)

pos :: Int -> Bool
pos  x = if (x>=0) then True else False

foo :: Maybe Int ->  Maybe Bool 
foo  mx =  mx  >>= (\x -> Just (pos x))

foo2 :: Maybe Int ->  Maybe Bool 
foo2  mx =  do{
               x <- mx;
               Just (pos x)
            }

-- 3
-- folosind sabloane 
addM1 :: Maybe Int -> Maybe Int -> Maybe Int  
addM1 (Just x) (Just y) = Just (x+y)
addM1 _ _ = Nothing 

-- folosind operatii monadice si notatia do
addM2 :: Maybe Int -> Maybe Int -> Maybe Int  
addM2 mx my = do
               x <- mx -- x::Int
               y <- my -- y::Int
               return (x+y)
               -- sau Just (x+y)

            
addM3 :: Maybe Int -> Maybe Int -> Maybe Int  
addM3 mx my = mx >>= (\x -> my >>= (\y -> Just(x+y)))  

-- 4
cartesianProd xs ys = do
                        x <- xs
                        y <- ys
                        return ((x,y))
-- *Main> cartesianProd (Just 3) (Just 2)
-- Just (3,2)

func x y = x + y
prod f xs ys = [ f x y | x <- xs, y <-ys]
prod_do f xs ys = do
                    x <- xs
                    y <- ys 
                    return (f x y)   


{-
prod_do func (Just 3) (Just 2)
Just 5
*Main> prod_do func [1,2,3] [4,5]
[5,6,6,7,7,8]
*Main>
-}

myGetLine :: IO String
myGetLine = getChar >>= \x -> if x == '\n' then return [] 
                              else myGetLine >>= \xs -> return (x:xs) 

myGetLineDo :: IO String
myGetLineDo = do
                 x <- getChar
                 if x == '\n' then return []
                 else 
                     do
                         xs <- myGetLineDo
                         return (x:xs)

-- 5
ioNumber = do
    noin <- readLn :: IO Float
    putStrLn $ "Intrare\n" ++ (show noin)
    let noout = sqrt noin
    putStrLn $ "Iesire"
    print noout

ioNumber2 = (readLn :: IO Float) >>= (\noin -> (putStrLn $ ("Intrare\n" ++ show noin)) >> 
            (let noout = sqrt noin in (putStrLn $ "Iesire") >> print noout))  

-- sau varianta mai clean:
ioNumber3 = (readLn :: IO Float) >>= (\noin -> putStrLn ("Intrare\n" ++ show noin) >> putStrLn "Iesire" >> print (sqrt noin))