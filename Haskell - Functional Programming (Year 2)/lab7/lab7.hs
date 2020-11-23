import Test.QuickCheck
import Data.Char

double :: Int -> Int
double x = x+x
triple :: Int -> Int
triple x = 3*x
penta :: Int -> Int
penta x = 5*x

test x = (double x + triple x) == penta x
-- *Main> quickCheck test
-- +++ OK, passed 100 tests.

myLookUp :: Int -> [(Int, String)] -> Maybe String -- adica nothing sau just string
myLookUp nr [] = Nothing
myLookUp nr (x : xs)
     | fst x == nr = Just (snd x)
     | otherwise = myLookUp nr xs
     
testLookUp :: Int -> [(Int, String)] -> Bool
testLookUp x l = myLookUp x l == lookup x l
-- *Main> quickCheck  testLookUp
-- +++ OK, passed 100 tests.

testLookUpCond :: Int -> [(Int,String)] -> Property
testLookUpCond n list = n > 0 && n  `div` 5 == 0 ==> testLookUp n list
-- *Main> quickCheck  testLookUpCond
-- *** Gave up! Passed only 72 tests; 1000 discarded tests.

myLookUp' :: Int -> [(Int, String)] -> Maybe String
myLookUp' nr [] = Nothing
myLookUp' nr ((n, (c : sir)) : t)
     | n == nr = Just ((toUpper c) : sir)
     | otherwise = myLookUp' nr t
-- *Main> myLookUp' 2 [(1,"mere"),(2,"pere")]
-- Just "Pere"