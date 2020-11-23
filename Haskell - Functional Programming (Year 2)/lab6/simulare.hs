import Data.Char

-- 1 a)
f :: Char -> Bool
f c
    | ord(c) >= 97 && ord(c) <= 109 = True
    | ord(c) >= 65 && ord(c) <= 77  = True
    | isAlpha(c) = False
    | otherwise = error "Nu e litera"
-- a = 97
-- m = 109
-- A = 65
-- M = 77

-- 1 b)
g :: [Char] -> Bool
g s 
  | length(aux(s))>length(aux1(s)) = True
  | otherwise = False
  
aux :: [Char] -> [Char]
aux s = [a | a <- s, isAlpha(a) && f(a)==True]

aux1 :: [Char] -> [Char]
aux1 s = [a | a <- s, isAlpha(a) && f(a)==False]
    
-- 1 c)
h :: [Char] -> Bool
h s 
   | aux2(s)>aux3(s) = True
   | otherwise = False

aux2 :: [Char] -> Int
aux2 [] = 0
aux2 (x:xs)
  | isAlpha(x) && f(x)==True = 1+aux2(xs)
  | otherwise = aux2(xs)
      
aux3 :: [Char] -> Int
aux3 [] = 0
aux3 (x:xs)
  | isAlpha(x) && f(x)==False = 1+aux3(xs)
  | otherwise = aux3(xs)
      
-- 2 a)
c :: [Int] -> [Int]
c a = [x | (x,y) <- zip a (tail a), x == y]
     
-- 2 b)
d :: [Int] -> [Int]
d [] = []
d [x] = []
d (x: y: list) = if x==y then x:d([y]++list)
                 else d([y]++list)
     
-- 2 c)
prop_cd :: [Int] -> Bool
prop_cd a = c(a)==d(a)
