-- Bibliografie:  Graham Hutton, Programming in Haskell, 2nd edition, Chapter 13

import Data.Char
import Control.Monad
import Control.Applicative

newtype Parser a =
    Parser { apply :: String -> [(a, String)] }
    
          
parse :: Parser a -> String -> a
parse m s = head [ x | (x,t) <- apply m s, t == "" ]

                    
-- Recunoasterea unui caracter arbitrar                                       
anychar :: Parser Char
anychar = Parser f
    where
    f :: String -> [(Char, String)]
    f []     = []
    f (c:s) = [(c,s)]
-- *Main> apply anychar "a"
-- [('a',"")]
-- *Main> apply anychar "ab"
-- [('a',"b")]
-- *Main> apply anychar "abc"
-- [('a',"bc")]

-- *Main> parse anychar "a" => head ['a'] = 'a'
-- 'a'
-- *Main> parse anychar "ab" => head [] => exceptie
-- *** Exception: Prelude.head: empty list


-- Recunoasterea unui caracter cu o proprietate
satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser f
    where
    f :: String -> [(Char, String)]
    f []                 = []
    f (c:s) | p c        = [(c, s)] -- daca c indeplineste proprietatea p
            | otherwise = []
-- *Main> parse (satisfy isUpper) "A"
-- 'A'
-- *Main> parse (satisfy isUpper) "a"
-- *** Exception: Prelude.head: empty list
-- *Main> apply (satisfy isUpper) "Ab"
-- [('A',"b")]
-- *Main> apply (satisfy isUpper) "aB"
-- []

-- Recunoasterea unui anumit caracter
char :: Char -> Parser Char
char c = satisfy (== c)     
-- *Main> parse (char 'a') "a"
-- 'a'
-- *Main> parse (char 'a') "ab"
-- *** Exception: Prelude.head: empty list
-- *Main> apply (char 'a') "ab"
-- [('a',"b")]
-- *Main> apply (char 'a') "bb"
-- []
 
-- Recunoasterea unui cuvant cheie caracter
string :: String -> Parser String
string [] = Parser (\s -> [([],s)])
string (x:xs) = Parser f  
 where
   f s = [(y:z,zs)| (y,ys)<- apply (char x) s, 
                    (z,zs) <- apply (string xs) ys]    
-- *Main> parse (string "abc") "abc"
-- "abc"
-- *Main> parse (string "abc") "abcd"
-- "*** Exception: Prelude.head: empty list
-- *Main> apply (string "abc") "abcd"
-- [("abc","d")]

-- Exercitiul 1    

three :: Parser (Char, Char)
three = Parser f
  where 
    f (x:xx:xxx:xs) = [((x, xxx), xs)] 
    f _ = []

three2 :: Parser (Char, Char)
three2 = Parser f
  where
    f x = [((x1, x3), xs3) | (x1, xs1) <- (apply anychar x), 
           (x2, xs2) <- (apply anychar xs1), (x3, xs3) <- (apply anychar xs2)]


-- Exercitiul 2

instance Monad Parser where
    return x = Parser (\s -> [(x, s)])
    m >>= k  = Parser (\s -> [(y, ys) | (x, xs) <- apply m s, 
                                        (y, ys) <- apply (k x) xs])
                                       
instance Applicative Parser where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance Functor Parser where              
--   fmap f ma = pure f <*> ma 
     fmap f ma = Parser (\s -> [(f v, t) | (v, t) <- apply ma s])                     

stringM :: String -> Parser String
stringM [] = return []
stringM (x:xs) = do
                  y <- char x
                  ys <- stringM xs
                  return (y:ys)

threeM :: Parser (Char, Char)
threeM = do
            x1 <- anychar
            x2 <- anychar
            x3 <- anychar 
            return (x1, x3)
-- *Main> apply threeM "abc"
-- [(('a','c'),"")]


-- Exercitiul 3

anycharord :: Parser Int
anycharord = Parser f
  where 
    f [] = []
    f (x:xs) = [(ord x, xs)]      
          
-- Exercitiul 4                     
failM = Parser (\s ->[])

instance MonadPlus Parser where
    mzero      = failM
    mplus m n  = Parser (\s -> apply m s ++ apply n s)

instance Alternative Parser where
  empty  = mzero
  (<|>) = mplus 


satisfyM :: (Char -> Bool) -> Parser Char
satisfyM p = do 
            c <- anychar
            if p c then return c else failM   
            
digit = satisfyM isDigit
abcP = satisfyM (`elem` ['A','B','C'])

alt :: Parser a -> Parser a -> Parser a
alt p1 p2 = Parser f
          where f s = apply p1 s ++ apply p2 s   
-- *Main> apply (digit <|> abcP) "A12c"
-- [('A',"12c")]
-- *Main> apply (digit <|> abcP) "a12c"
-- []
-- *Main> apply (digit <|> abcP) "12c" 
-- [('1',"2c")]
-- *Main> apply (alt digit abcP) "12c"
-- [('1',"2c")]
-- *Main> apply (alt digit abcP) "a12c"
-- []
-- *Main> apply (alt digit abcP) "A12c"
-- [('A',"12c")] 

 
manyP :: Parser a -> Parser [ a ]
manyP p = someP p <|> return [ ]
-- *Main> apply (manyP digit) "123abd"
-- [("123","abd"),("12","3abd"),("1","23abd"),("","123abd")]
-- *Main> apply (someP digit) "123abd"
-- [("123","abd"),("12","3abd"),("1","23abd")]

someP :: Parser a -> Parser [ a ]
someP p = do 
          x <- p
          xs <- manyP p
          return ( x : xs )

identifier :: Parser Char -> Parser Char -> Parser String
identifier firstCh nextCh = do 
                             c <- firstCh
                             s <- many nextCh
                             return ( c : s )
 
decimal :: Parser Int
decimal = do 
           s <- someP digit
           return ( read s )

negative :: Parser Int
negative = do    
              char '-'
              n <- decimal
              return (-n)
                  
integer :: Parser Int
integer = decimal `mplus` negative
  
skipSpace :: Parser ()
skipSpace = do 
              _ <- many ( satisfyM isSpace )
              return ()
              
tokenS :: Parser a -> Parser a
tokenS p = do 
           skipSpace
           x <- p
           skipSpace
           return x     

isA :: Parser Char
isA = satisfyM (== 'a')

isB :: Parser Char
isB = satisfyM (== 'b')

isAOrB :: Parser Char
isAOrB = isA <|> isB

-- Exercitiul 5
-- consuma prefixele nenule formate numai din caracterul dat ca argument s, i întoarce lungimea acestora
howmany :: Char -> Parser Int
howmany c = fmap length (someP (char c))
-- *Main> apply (howmany 'a') "aaaaaal"
-- [(6,"l"),(5,"al"),(4,"aal"),(3,"aaal"),(2,"aaaal"),(1,"aaaaal")]      
-- *Main> apply (someP (char 'a')) "aaaaaal" -- ce e mai sus e asta cu length aplicat
-- [("aaaaaa","l"),("aaaaa","al"),("aaaa","aal"),("aaa","aaal"),("aa","aaaal"),("a","aaaaal")]

-- Exercitiul 6 
{-
*Main> :t fmap
fmap :: Functor f => (a -> b) -> f a -> f b

*Main> :t fmap (+)
fmap (+) :: (Functor f, Num a) => f a -> f (a -> a)

*Main> :t (<*>)
(<*>) :: Applicative f => f (a -> b) -> f a -> f b

*Main> :t fmap (+) (Just 2) <*> (Just 3)
fmap (+) (Just 2) <*> (Just 3) :: Num b => Maybe b

*Main> :t fmap (+) ([1,2]) <*> ([4,5,6]) 
fmap (+) ([1,2]) <*> ([4,5,6]) :: Num b => [b]

*Main> :t fmap (+) anycharord
fmap (+) anycharord :: Parser (Int -> Int)
-}

twocharord :: Parser Int
twocharord = Parser f
  where
    f (x:xx:xs) = [(ord x + ord xx, xs)]
    f _ = []
-- *Main> apply twocharord "abc"
-- [(195,"c")]     

-- sau cu fmap:
twocharord2 = fmap (+) anycharord <*> anycharord
-- *Main> apply twocharord2 "abc"
-- [(195,"c")]


-- Exercitiul 7
no :: Int -> Int -> Int -> Int -> Int
no x y z v = x*1000+y*100+z*10 + v                  

fourdigit :: Parser Int
fourdigit = Parser f
  where
    f (x1:x2:x3:x4:xs) = [(no (digitToInt x1) (digitToInt x2) (digitToInt x3) (digitToInt x4), xs)]
    f _ = []

{-
*Main> apply fourdigit "123" 
[]

*Main> apply fourdigit "123456"
[(1234,"56")]
-}