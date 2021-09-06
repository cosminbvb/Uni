import Test.QuickCheck
import Data.Char
import Test.QuickCheck.Gen
import Data.Maybe
import System.Random

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

--Constrangeri
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

isUpperList :: [(Int, String)] -> Bool
isUpperList [] = True
isUpperList ((n, "") : xs) = False
isUpperList ((n, (y : ys)) : xs) = and [isUpper y, isUpperList xs]

testLookUp' :: Int -> [(Int, String)] -> Property
testLookUp' nr list = isUpperList list ==> myLookUp' nr list == lookup nr list

{-
testLookUpCond2 :: Int -> [(Int,String)] -> Property
testLookUpCond2 n list = foldr (&&) True (map (\x ->(capitalized (snd x)) == (snd x)) list) ==> testLookUp' n list

capitalized :: String -> String
capitalized (h:t) = (toUpper h): t
capitalized [] = []myLookUp3 :: Int -> [(Int, String)] -> Maybe String

myLookUp3 nr [] = Nothing
myLookUp3 nr ((n, sirul) : t)
     | n == nr && sirul == "" = Just ""
     | n == nr = let (c:sir ) = sirul in Just ((toUpper c) : sir)
     | otherwise = myLookUp3 nr t

--aici crapa la head ""
testLookUpCond3 n list = foldr (&&) True (map (\x -> toUpper(head(snd x))==head(snd x))  list )   ==> testLookUp' n list
-}

data ElemIS = I Int | S String
     deriving (Show,Eq)

-- din ce am inteles, pentru a folosi quickCheck pe
-- un tip de date nou, trebuie sa fie instanta a clasei Arbitrary
-- si codul de mai jos genereaza random un int si un string
-- iar apoi ia una dintre valori cu oneof

instance Arbitrary ElemIS where
     arbitrary = elements ((I (fst $ random (mkStdGen 1) :: Int)) : 
               [(S (take (fst $ random (mkStdGen 1) :: Int) (randomRs ('A' , 'z') (mkStdGen 1) :: [Char])))])
--sau
{-
instance Arbitrary ElemIS where
    arbitrary = oneof [geni, gens]
        where
            f = (unGen (arbitrary :: Gen Int)) 
            g = (unGen (arbitrary :: Gen String))
            geni = MkGen (\s i -> let x = f s i in (I x)) 
            gens = MkGen (\s i -> let x = g s i in (S x))
-}

myLookUpElem :: Int -> [(Int, ElemIS)]-> Maybe ElemIS
myLookUpElem nr [] = Nothing
myLookUpElem nr (x : xs)
     | fst x == nr = Just (snd x)
     | otherwise = myLookUpElem nr xs

testLookUpElem :: Int -> [(Int, ElemIS)] -> Bool
testLookUpElem nr list = myLookUpElem nr list == lookup nr list