import Numeric.Natural
import Test.QuickCheck

--1.1a
produsRec :: [Integer] -> Integer
produsRec [] = 1
produsRec (x:xs) = x*produsRec(xs)

--1.1b
produsFold :: [Integer] -> Integer
produsFold list = foldr (*) 1 list 

--1.2.a
andRec :: [Bool] -> Bool
andRec [] = True
andRec (x:xs) = x && andRec(xs) 


--1.2.b
andFold :: [Bool] -> Bool
andFold list = foldr (&&) True list

prop_and :: [Bool] -> Bool
prop_and l = andRec l == andFold l
--quickCheck prop_and => +++ OK, passed 100 tests.

--1.3.a
concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (x:xs) = x++concatRec(xs)

--1.3.b
concatFold :: [[a]] -> [a]
concatFold list = foldr (++) [] list

--1.4.a
rmChar :: Char -> String -> String
rmChar c s = [x | x<-s, x/=c]

--1.4.b
rmCharsRec :: String -> String -> String
rmCharsRec s [] = []
rmCharsRec s (x:xs)
            | x `elem` s = rmCharsRec s xs
            | otherwise = x : rmCharsRec s xs

--1.4.c
rmCharsFold :: String -> String -> String
rmCharsFold s t = foldr f [] t
       where f x y | not(x `elem` s) = x:y
                   | otherwise = y
                
test_rmChars :: String -> String -> Bool
test_rmChars a b = rmCharsRec a b == rmCharsFold a b
--quickCheck test_rmChars  => +++ OK, passed 100 tests.

rmCharsFoldV2:: String -> String -> String
rmCharsFoldV2 cuv1 cuv2=foldr rmChar cuv2 cuv1

test_rmCharsV2 :: String -> String -> Bool
test_rmCharsV2 a b = rmCharsRec a b == rmCharsFoldV2 a b
--quickCheck test_rmCharsV2 => +++ OK, passed 100 tests.
--------------------------------------------------------

--continuarea in lab 5


