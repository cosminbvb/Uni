-- imp -- pentru chestii care mi se par imp
import Data.List
import Data.Char
import Test.QuickCheck
--------------LAB 1----------------
a = permutations [1..3]

b = subsequences [1,2,3] --submultimi

maxim :: Integer -> Integer -> Integer
maxim a b = if(a>b) then a else b
--or
maxim2 :: Integer -> Integer -> Integer
maxim2 a b =
    if(a>b)
        then a
        else b

maxim3 :: Integer -> Integer -> Integer -> Integer
maxim3 a b c = maxim a (maxim b c)

-- data Bool = False | True
-- in acest context Bool e un contructor de tip iar True si False
-- sunt constructori de date

--------------LAB 2---------------- complet 

fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n 
    | n < 2 = n
    | otherwise = fibonacciCazuri(n-1) + fibonacciCazuri(n-2)

inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec _ _ [] = []
inIntervalRec a b (x:xs) 
    | x>=a && x<=b = x:inIntervalRec a b xs
    | otherwise = inIntervalRec a b xs

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b list = [x |x <- list, x>=a && x<=b]

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (x:xs)
    | x>0 = 1+pozitiveRec xs
    | otherwise = pozitiveRec xs

pozitiveComp :: [Int] -> Int
pozitiveComp list = sum [1 | x<-list, x>0]

pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec list = pozitiiImpareAux list 0
    where 
        pozitiiImpareAux :: [Int] -> Int -> [Int]
        pozitiiImpareAux [] _ = []
        pozitiiImpareAux (x:xs) i
            | odd x = i:pozitiiImpareAux xs (i+1)
            | otherwise = pozitiiImpareAux xs (i+1)
    
pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp list = [snd x | x<-aux, odd (fst x)]
    where 
        aux = zip list [0..]

multDigitsRec :: [Char] -> Int
multDigitsRec [] = 1
multDigitsRec (x:xs)
    | isDigit(x) = digitToInt(x) * multDigitsRec xs
    | otherwise = multDigitsRec xs

multDigitsComp :: [Char] -> Int
multDigitsComp string = product [digitToInt x | x <- string, isDigit x]

discountRec :: [Double] -> [Double]
discountRec [] = []
discountRec (x:xs)
    | new<200 = new : discountRec xs
    | otherwise = discountRec xs
    where
        new = x-x*0.25

discountComp :: [Double] -> [Double]
discountComp list = [x-x*0.25 | x<-list, x-x*0.25<200]

--------------LAB 3---------------- complet

factori :: Int -> [Int]
factori n = [x | x <- [1..n], n `mod` x == 0]

prim :: Int -> Bool
prim n = if (length(factori n)==2) then True else False

numerePrime :: Int -> [Int]
numerePrime n = [x | x<-[2..n], prim x]

myzip3 :: [Int] -> [Int] -> [Int] -> [(Int,Int,Int)]
myzip3 [] _ _ = []
myzip3 _ [] _ = []
myzip3 _ _ [] = []
myzip3 (x:xs) (y:ys) (z:zs) = (x,y,z):myzip3 xs ys zs 

firstEl :: [(a,b)] -> [a]
firstEl list = map (\(a,b) -> a) list -- sau map fst x

sumList :: [[Integer]] -> [Integer]
sumList list = map sum list

prel2 :: [Integer] -> [Integer]
prel2 list = map aux list
    where
        aux :: Integer -> Integer
        aux x = if even x
                then x `div` 2
                else x*2
    
f1 :: Char -> [[Char]] -> [[Char]]
f1 c list = filter (c `elem`) list

--conditional lambda expression ex (\x -> if x `mod` 2 == 0 then x*x else x)

f2 :: [Int] -> [Int]
f2 list = map (^2) (filter odd list)

f3 :: [Int] -> [Int]
f3 list = map(\(x,y) -> x^2) (filter(\(x,y) -> odd y) (zip list [0..]))

numaiVocale :: [[Char]] -> [[Char]]
numaiVocale list = map aux list
    where
        aux :: [Char] -> [Char]
        aux string = filter (`elem` "aeiouAEIOU") string 

numerePrimeCiur :: Int -> [Int]
numerePrimeCiur n = aux [2..n]
    where 
        aux [] = []
        aux (x:xs) = x : aux(xs \\ [x,x+x..n])

ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x:xs) = and (map (\(x,y) -> x < y) aux)
    where 
        aux = zip (x:xs) xs 
    
ordonataNat2 :: [Int] -> Bool
ordonataNat2 [] = True
ordonataNat2 [x] = True
ordonataNat2 (x1:x2:xs) = x1<x2 && ordonataNat2 (x2:xs)

ordonata :: [a] -> (a->a->Bool) ->Bool
ordonata [] rel = True
ordonata [x] rel = True
ordonata (x1:x2:xs) rel = rel x1 x2 && ordonata (x2:xs) rel

(*<*) :: (Integer, Integer) -> (Integer, Integer) -> Bool
(a,b) *<* (c,d)
    | a<c = True
    | a==c && b<d = True
    | otherwise = False

compuneList :: (b -> c) -> [(a -> b)] -> [(a -> c)]
compuneList f list = map (f.) list

aplicaList :: a -> [(a->b)] -> [b]
aplicaList a list = [f a | f <- list]

myzip3V2 :: [a] -> [b] -> [c] -> [(a,b,c)]
myzip3V2 l1 l2 l3 = map (\((x,y),z) -> (x,y,z)) (zip (zip l1 l2) l3)

--------------LAB 4---------------- tot in afara de evaluarea lenesa

produsRec ::[Integer] -> Integer
produsRec [] = 1;
produsRec (x:xs) = x*produsRec xs

produsFold :: [Integer] -> Integer
produsFold = foldr (*) 1 

andRec :: [Bool] -> Bool
andRec [] = True;
andRec (x:xs) = x && andRec xs

andFold :: [Bool] -> Bool
andFold = foldr (&&) True

concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (x:xs) = x ++ concatRec xs

concatFold :: [[a]] -> [a]
concatFold = foldr (++) []

rmChar :: Char -> String -> String
rmChar c s = [x | x <- s, x/=c]

rmCharsRec :: String -> String -> String
rmCharsRec _ [] = []
rmCharsRec s (x:xs) 
    | x `elem` s = rmCharsRec s xs
    | otherwise = x:rmCharsRec s xs

-- imp --
rmCharsFold :: String -> String -> String
rmCharsFold s1 s2 = foldr (\x y -> if x `elem` s1 then y else x:y) [] s2

--sau
{-
rmCharsFold s1 s2 = foldr aux [] s2
    where
        aux x y 
            | x `elem` s1 = y
            | otherwise = x:y
-}

semn :: [Integer] -> [Char]
semn [] = []
semn (x:xs)
    | x>9 || x<(-9) = semn xs
    | x>0 = '+':semn xs
    | x<0 = '-':semn xs
    | otherwise = '0':semn xs

semnFoldr :: [Integer] -> [Char]
semnFoldr = foldr op unit
    where
        unit = []
        c `op` string
            | c > 9 || c < (-9) = string
            | c > 0 = '+':string
            | c < 0 = '-':string
            | otherwise = '0':string

--------------LAB 5---------------- tot in afara de evaluarea lenesa si cele din 4

corect :: [[a]] -> Bool
corect matrix = and (map (\(x,y)->x==y) (zip aux (tail aux)))
    where
        aux = map length matrix

el :: [[a]] -> Int -> Int -> a
el matrix i j = (matrix !! i) !! j

zipAux :: [a] -> [(a, Int)]
zipAux list = zip list [0..]
insereazaPozitie :: ([(a, Int)], Int) -> [(a, Int, Int)]
insereazaPozitie (lista, linie) = map (\(x, coloana) -> (x, linie, coloana)) lista
transforma :: [[a]] -> [(a, Int, Int)]
transforma m = concat (map insereazaPozitie (zipAux (map zipAux m)))

--------------simulare----------------

f :: Char -> Bool 
f c
    | toLower(c)>='a' && toLower(c)<='m' = True
    | toLower(c)>'m' = False
    | otherwise = error "Nu e alfabetic"

g :: String -> Bool
g s = length aux1 > length aux2  
      where
          aux1 = [c | c <- s, toLower c >='a' && toLower c <='z' && f c]
          aux2 = [c | c <- s, toLower c >='a' && toLower c <='z' && not(f c)]
    
h :: String -> Bool
h s = length (aux1 s) > length (aux2 s)
      where
          aux1 [] = []
          aux1 (x:xs)
                | toLower x >='a' && toLower x <= 'z' && f x = x:aux1 xs
                | otherwise = aux1 xs
          aux2 [] = []
          aux2 (x:xs)
                | toLower x >='a' && toLower x <= 'z' && not(f x) = x:aux2 xs
                | otherwise = aux2 xs
            
c :: [Int] -> [Int]
c list = [x | (x,y) <- aux, x==y]
    where
        aux = zip list (tail list)    
    
d :: [Int] -> [Int] 
d list = aux (zip list (tail list))
    where 
        aux [] = []
        aux (x:xs)
            | fst x == snd x = fst x : aux xs
            | otherwise = aux xs
    
--sau mai simplu
{-
d [] = []
d [x] = []
d (x:y:list) = if x==y 
               then x:d(y:list)
               else d(y:list)
-}

prop_cd :: [Int] -> Bool
prop_cd list = c list == d list

--------------LAB 6---------------- complet

data Fruct 
    = Mar String Bool
    | Portocala String Int

ionatanFaraVierme = Mar "Ionatan" False
goldenCuVierme = Mar "Golden Delicious" True
portocalaSicilia10 = Portocala "Sanguinello" 10
listaFructe = [Mar "Ionatan" False,
                Portocala "Sanguinello" 10,
                Portocala "Valencia" 22,
                Mar "Golden Delicious" True,
                Portocala "Sanguinello" 15,
                Portocala "Moro" 12,
                Portocala "Tarocco" 3,
                Portocala "Moro" 12,
                Portocala "Valencia" 2,
                Mar "Golden Delicious" False,
                Mar "Golden" False,
                Mar "Golden" True]

ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala soi _)
    | soi == "Tarocco" || soi == "Moro" || soi == "Sanguinello" = True
    | otherwise = False
ePortocalaDeSicilia _ = False

nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia list = sum [felii | (Portocala soi felii)<-list, 
                           ePortocalaDeSicilia(Portocala soi felii)]
--sau nrFeliiSicilia list = sum [x | Portocala _ x <- filter ePortocalaDeSicilia list]

nrMereViermi :: [Fruct] -> Int
nrMereViermi list = sum [1 | (Mar _ True) <- list]

data Linie = L [Int]
    deriving Show
data Matrice = M [Linie]

verifica :: Matrice -> Int -> Bool
verifica (M list) nr = foldr (&&) True (map (\(L li) -> sum li == nr) list)
--sau verifica (M m) nr = foldr (&&) True [sum x == nr | (L x) <- m]

showL :: Linie -> [Char]
showL (L []) = ""
showL (L (h:t)) = show h ++ " " ++ showL(L t)

instance Show Matrice where
    show (M []) = ""
    show (M (l:linii)) = showL l ++ "\n" ++ show(M linii)

--------------LAB 7---------------- pana la Testare pentru tipuri de date algebrice

double :: Int -> Int
double x = 2*x

triple :: Int -> Int
triple x = 3*x

penta :: Int -> Int
penta x = 5*x

test x = (double x + triple x) == penta x
-- *Main> quickCheck test
-- +++ OK, passed 100 tests.

myLookUp :: Int -> [(Int, String)] -> Maybe String
myLookUp _ [] = Nothing
myLookUp n (x:xs) = if fst x == n 
                    then Just (snd x)
                    else myLookUp n xs

testLookUp :: Int -> [(Int, String)] -> Bool
testLookUp n map = myLookUp n map == lookup n map
-- *Main> quickCheck testLookUp
-- +++ OK, passed 100 tests.

testLookUpCond :: Int -> [(Int, String)] -> Property
testLookUpCond n list = n > 0 && n `div` 5 == 0 ==> testLookUp n list
-- *Main> quickCheck testLookUpCond
-- *** Gave up! Passed only 68 tests; 1000 discarded tests.

myLookUp' :: Int -> [(Int, String)] -> Maybe String
myLookUp' _ [] = Nothing
myLookUp' n ((nr, (c :sir)):xs)
    | n == nr = Just ((toUpper c):sir)
    | otherwise = myLookUp' n xs

-- *Main> myLookUp' 2 [(1,"mere"),(2,"pere")]
-- Just "Pere"
