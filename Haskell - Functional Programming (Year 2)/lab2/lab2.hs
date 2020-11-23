import Data.Char

fibo :: Integer -> Integer
fibo x 
   | x < 2 = x
   | otherwise = fibo(x-1)+fibo(x-2)
   
--------------------------------------------  
 
fibo2 :: Integer -> Integer
fibo2 0 = 0
fibo2 1 = 1
fibo2 n = fibo2(n-1)+fibo2(n-2)

--------------------------------------------   
-- L2.1

fiboLiniar :: Integer -> Integer
fiboLiniar 0 = 0
fiboLiniar n = snd (fiboPereche n)
    where 
    fiboPereche :: Integer -> (Integer,Integer)
    fiboPereche 1 = (0,1)
    fiboPereche n = (b, b+a)
         where
         (a,b) = fiboPereche(n-1)

--------------------------------------------   

semiPare :: [Int] -> [Int]
semiPare a
    | null a = a
    | even h = h `div` 2 : t'
    | otherwise = t'
    where
      h = head a
      t = tail a
      t' = semiPare t
      
--------------------------------------------   
     
semiPare2 :: [Int] -> [Int]
semiPare2 [] = []
semiPare2 (h:t)
    | even h = h `div` 2 : t'
    | otherwise = t'
    where 
      t' = semiPare2 t
    
v1 = semiPare [0, 2 , 1 , 7 , 8 , 56 , 17 , 18]
v2 = semiPare2 [0, 2 , 1 , 7 , 8 , 56 , 17 , 18]

--------------------------------------------   

semiPare3 :: [Int] -> [Int]
semiPare3 l = [x `div` 2 | x <- l, even x]

v3 = semiPare3 [0, 2 , 1 , 7 , 8 , 56 , 17 , 18]

--------------------------------------------  
-- L2.2

inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec _ _ [] = []
inIntervalRec a b (x:xs) 
    | x>=a && x<=b = x:inIntervalRec a b xs
    | otherwise = inIntervalRec a b xs

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b list = [x |x <- list, x>=a && x<=b]

--------------------------------------------  
-- L2.3

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (x:xs)
    | x>0 = 1+pozitiveRec xs
    | otherwise = pozitiveRec xs

pozitiveComp :: [Int] -> Int
pozitiveComp list = sum [1 | x<-list, x>0]
     
--------------------------------------------  
-- L2.4   

pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec x = pozitiiImpareAux x 0

pozitiiImpareAux :: [Int] -> Int -> [Int]
pozitiiImpareAux [] _ = []
pozitiiImpareAux (h:t) i | odd h = i : (pozitiiImpareAux t (i+1))
                         | otherwise = pozitiiImpareAux t (i+1)
                         

pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l = [fst x | x <- a , (snd x) `mod` 2 == 1 ]
                       where a = zip [0,1..] l

test1 = pozitiiImpareRec [0,1,-3,-2,8,-1,6,1]
test2 = pozitiiImpareComp [0,1,-3,-2,8,-1,6,1]

--------------------------------------------
-- L2.5

multDigitsComp :: [Char] -> Int
multDigitsComp l = foldr (*) 1 [digitToInt(x) | x<-l, isDigit(x)]

-- https://stackoverflow.com/questions/384797/implications-of-foldr-vs-foldl-or-foldl

multDigitsRec :: [Char] -> Int
multDigitsRec [] = 1
multDigitsRec (x:xs)
     | isDigit(x) = digitToInt(x)*multDigitsRec(xs)
     | otherwise = multDigitsRec(xs)
     
a1 = multDigitsRec "The time is 4:25"
b1 = multDigitsComp "The time is 4:25"

a2 = multDigitsRec "No digits here!"
b2 = multDigitsComp "No digits here!"

--------------------------------------------
-- L2.6

discountComp :: [Float] -> [Float]
discountComp l = [a | a<-[x-(x*0.25) | x<-l], a<200]

test3 = discountComp [150, 300, 250, 200, 450, 100]


discountRec :: [Float] -> [Float]
discountRec [] = []
discountRec (h:t) | a<200 = a : t'
                  | otherwise = t'
                    where
                       a = h-(h*0.25)
                       t' = discountRec t
                     
test4 = discountRec [150, 300, 250, 200, 450, 100]
                     
--------------------------------------------
