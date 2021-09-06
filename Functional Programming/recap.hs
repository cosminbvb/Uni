import Data.List
import Data.Char
import Test.QuickCheck
import System.Random
import Data.Maybe

f :: [Int] -> [Int]
f list = map(\(a,b) -> a^2) (filter(odd.snd) (zip list [1..]))

rmCharsFold :: String -> String -> String
rmCharsFold a b = foldr (\x y -> if x `elem` a then y else x:y) [] b

suma :: [Integer] -> Integer
suma = foldr op unit
    where
        unit = 0
        a `op` suma 
            | odd a = a*a+suma
            | otherwise = suma

corect :: [[a]] -> [(Int, Int)]
corect matrix = zip aux (tail aux)
    where
        aux = map length matrix

data Fruct 
    = Mar String Bool
    | Portocala String Int

e :: Fruct -> Bool
e (Portocala s _) = s `elem` ["Tarocco", "Moro", "Sanguinello"]
e _ = False

portocalaSicilia10 = Portocala "Sanguinello" 10

data Linie = L [Int]
    deriving Show
data Matrice = M [Linie]

verifica :: Matrice -> Int -> Bool
verifica (M list) n = and (map (\(L li) -> sum li == n) list) 

instance Show Matrice where
    show (M []) = ""
    show (M (x:xs)) = show x ++ "\n" ++ show (M xs)

double :: Int -> Int
double x = 2*x

triple :: Int -> Int
triple x = 3*x

penta :: Int -> Int
penta x = 5*x

test x = (double x + triple x) == penta x

--------------------------curs7 - random--------------------------

genInt = fst $ random (mkStdGen 1000) :: Int
genInts = randoms (mkStdGen 500) :: [Int]
genChar = fst $ randomR ('a', 'z') (mkStdGen 500) :: Char
genChars = randomRs ('a', 'z') (mkStdGen 500) :: [Char]
--pt genInts/genChars putem folosi take n genInts/genChars

-- facem Season instanta a clasei Arbitrary, apoi putem folosi quickCheck
data Season = Spring | Summer | Autumn | Winter
    deriving (Show, Eq)

instance Arbitrary Season where
    arbitrary = elements [Spring, Summer, Autumn, Winter]

myreverse :: [a] -> [a]
myreverse [] = []
myreverse (x:xs) = myreverse xs ++ [x]

testQuickCheck :: [Season] -> Bool
testQuickCheck list = myreverse list == reverse list
-- *Main> quickCheck testQuickCheck 
-- +++ OK, passed 100 tests.

-- alt exemplu:
newtype MyInt = My Int
    deriving (Show, Eq)

instance Arbitrary MyInt where
    arbitrary = elements (map My list)
        where
            list = take 50000 (randoms(mkStdGen 0)) :: [Int]

wrongTest :: [MyInt] -> Bool
wrongTest list = myreverse list == list
-- *** Failed! Falsified (after 3 tests):
-- [My 168348164460923949,My (-5513153053059728700)]


--------------------------curs 8--------------------------

data Point a b = Pt a b 
-- instantierea prin derivare automata: deriving Eq
-- instantierea explicita:
instance Eq a => Eq (Point a b) where
    (==) (Pt x1 y1) (Pt x2 y2) = x1 == x2

-- Maybe: 
-- data Mayve a = Nothing | Just a
divide :: Int -> Int -> Maybe Int
divide n 0 = Nothing 
divide n m = Just (n `div` m)

right :: Int -> Int -> Int
right n m = case divide n m of
                Nothing -> 3
                Just r -> r+3

-- Either:
-- data Either a b = Left a | Left b
mylist :: [Either Int String]
mylist = [Left 4, Left 1, Right "hello", Left 2, Right "CEVA"]

addints :: [Either Int String] -> Int
addints [] = 0
addints (Left x : xs) = x + addints xs
addints (Right x : xs) = addints xs
-- *Main> addints mylist 
-- 7

data Exp = Lit Int
         | Add Exp Exp  
         | Mul Exp Exp
    
par :: String -> String
par s = " ( " ++ s ++ " ) " 

showExp :: Exp -> String
showExp (Lit n) = show n
showExp (Add e1 e2) = par (showExp e1 ++ " + " ++ showExp e2)
showExp (Mul e1 e2) = par (showExp e1 ++ " * " ++ showExp e2)

instance Show Exp where
    show = showExp

e1 :: Exp
e1 = Add (Lit 2) (Mul (Lit 3) (Lit 3))
-- *Main> e1
-- ( 2 +  ( 3 * 3 )  )

evalExp :: Exp -> Int
evalExp (Lit n) = n
evalExp (Add e1 e2) = evalExp e1 + evalExp e2
evalExp (Mul e1 e2) = evalExp e1 * evalExp e2
-- *Main> evalExp e1
-- 11

--sau puteam avea ca la propozitii (lab 8), expresii cu operatori 
--data Exp = Lit Int
--         | Exp :+: Exp
--         | Exp :*: Exp 
-- evalExp :: Exp −> Int
-- evalExp ( Lit n ) = n
-- evalExp ( e :+: f ) = evalExp e + evalExp f
-- evalExp ( e :*: f ) = evalExp e * evalExp f
-- trebuie schimbat si show ul

--------------------------curs 9 si 10 --------------------------
data Arbore a = Nil 
              | Nod a (Arbore a) (Arbore a)

instance Functor Arbore where
    fmap f Nil = Nil
    fmap f (Nod x l r) = Nod (f x) (fmap f l) (fmap f r)

-- (M,*,e) monoid daca: * este asociativa si e element neutru (e apartine M)
-- Un semigrup este un monoid fara element neutru

-- monoidul contine o functie mconcat definita astfel (generalizarea la liste):
-- mconcat :: [a] -> a
-- mconcat = foldr (<>) mempty

-- pentru a face o instanta a clasei semigroup, trebuie definita operatia
-- si pentru monoid, (care mosteneste semigrup, sau cel putin asa am inteles eu)
-- mai trebuie definit elementul neutru, adica mempty

-- newtype Nat = MkNat Integer
-- newtype se foloseste cand un singur constructor e aplicat unui singur tip
-- de date. Declaratia cu newtype e mai eficienta decat cea cu date
-- type redenumeste tipul, newtype face o copie si permite redefinirea operatiilor

-- asa putem definit instante diferite pentru acelasi tip
-- de ex, avem monoizii (Int, +, 0), (Int, *, 1), ambii cu Int

-- Bool ca monoid fata de conjunctie:
newtype All = All {getAll :: Bool}
    deriving (Eq, Read, Show)

instance Semigroup All where
    All x <> All y = All (x && y)
instance Monoid All where
    mempty = All True

lista :: [All]
lista = map All [True, True, False, True] 
-- am facut cu map sa nu scriu la fiecare elem din
-- lista All True/False

-- *Main> mconcat lista
-- All {getAll = False}

-- *Main> getAll $ mconcat lista
-- False

lista2 :: [All]
lista2 = map All [True, True, True, True]
-- *Main> mconcat lista2
-- All {getAll = True}

-- Num a ca monoid fata de adunare
newtype Suma a = Suma {getSuma :: a}
    deriving (Eq, Read, Show)

instance Num a => Semigroup (Suma a) where
    Suma x <> Suma y = Suma (x+y)
instance Num a => Monoid (Suma a) where
    mempty = Suma 0

lista3 :: [Suma Int]
lista3 = map Suma [1,2,3,4,5]
rez_suma = getSuma $ mconcat lista3 :: Int -- = 15


-- Ord a ca semigrup fata de operatia de minim
newtype Min a = Min {getMin :: a}
    deriving (Eq, Read, Show)

instance Ord a => Semigroup (Min a) where
    Min x <> Min y = Min (min x y)

instance (Ord a, Bounded a) => Monoid (Min a) where
    mempty = Min maxBound


-- Functii ca instante
newtype Endo a = Endo {appEndo :: a -> a}
instance Semigroup (Endo a) where
    Endo g <> Endo f = Endo (g.f)
instance Monoid (Endo a) where
    mempty = Endo id

end = mconcat [Endo (+1), Endo (+2), Endo (+3)]
rez = (appEndo end) 0 -- = 6



-- Foldable:

-- class Foldable t where
-- fold :: Monoid m => t m -> m
-- foldMap :: Monoid m => (a -> m) -> t a -> m
-- foldr :: (a->b->b) -> b -> t a -> b
-- definitia minimala completa contine fie foldMap, fie foldr

data BinaryTree a = Leaf a
                  | Node (BinaryTree a) (BinaryTree a)
        deriving Show

foldTree :: (a->b->b) -> b -> BinaryTree a -> b
foldTree f i (Leaf x) = f x i
foldTree f i (Node l r) = foldTree f (foldTree f i r) l 

myTree = Node (Node (Leaf 1)(Leaf 2))(Node (Leaf 3)(Leaf 4))
-- *Main> foldTree (+) 0 myTree
-- 10

instance Foldable BinaryTree where
    foldr = foldTree
-- *Main> foldr (+) 0 myTree
-- 10

-- definitia minimala completa contine fie foldMap, fie foldr

-- Obs: in curs, la definitia clasei foldable (class Foldable t), la functiile fold 
-- si foldMap, t are constrangerea de monoid

-- Obs: in definitia clasei Foldable, t nu reprezinta un tip concret ([a], Sum a)
-- ci un constructor de tip (BinaryTree)

-- Acum avem definite automat foldMap si mai multe functii precum foldl, foldr',..
-- ex:

-- *Main> foldMap Suma myTree
-- Suma {getSuma = 10}

-- *Main> sum myTree
-- 10

-- *Main> elem 1 myTree
-- True

-- *Main> maximum myTree
-- 4


--------------------------curs 11 --------------------------

-- Finger Tree
data FTree v a = Leaff v a
               | Nodee  v (FTree v a) (FTree v a)
    deriving (Eq, Show)

exFT = Nodee 5 
           (Nodee 2 
                 (Leaff 1 'a') (Leaff 1 'b')) 
           (Nodee 3 
                 (Leaff 1 'c') 
                 (Nodee 2
                        (Leaff 1 'd')
                        (Leaff 1 'e')))

-- (P1) valoarea fiecarui nod intern reprezinta numarul de elemente din arborele respectiv
tag :: FTree v a -> v
tag (Leaff n _) = n
tag (Nodee n _ _) = n


-- lista datelor e alcatuita din frunze
toList :: FTree v a -> [a]
toList (Leaff v a) = [a]
toList (Nodee _ x y) = toList x ++ toList y

-- Contructia unui arbore (P1) se poate face cu functii constructor
type Size = Int

leaf :: a -> FTree Size a
leaf x = Leaff 1 x

node :: FTree Size a -> FTree Size a -> FTree Size a
node t1 t2 = Nodee (tag t1 + tag t2) t1 t2

egal1 = exFT == node (node (leaf 'a') (leaf 'b')) (node (leaf 'c') (node (leaf 'd')(leaf 'e')))
-- true

-- Accesarea elementului din pozitia n
(!!!) :: FTree Size a -> Int -> a
(Leaff _ a) !!! 0 = a
(Nodee _ x y) !!! n 
    | n < tag x = x !!! n
    | otherwise = y !!! (n - tag x)

-- *Main> exFT !!! 3
-- 'd'
-- ("indexarea" incepe de la 0)


-- (P2) Valoarea fiecarui nod intern reprezinta cea mai mica prioriatate din arborele respectiv
type Priority = Int
pqFT :: FTree Priority Char
pqFT = Nodee 2
            (Nodee 4
                    (Leaff 16 'a')
                    (Leaff 4 'b'))
            (Nodee 2
                    (Leaff 2 'c')
                    (Nodee 8
                            (Leaff 32 'd')
                            (Leaff 8 'e')))

-- Constructia unui arbore (P2) se poate face cu functii constructor specifice:
pleaf :: Priority -> a -> FTree Priority a
pleaf n x = Leaff n x

pnode :: FTree Priority a -> FTree Priority a -> FTree Priority a
pnode t1 t2 = Nodee ((tag t1) `min` (tag t2)) t1 t2

egal2 = pqFT == pnode (pnode (pleaf 16 'a')(pleaf 4 'b'))
                      (pnode (pleaf 2 'c') (pnode (pleaf 32 'd')
                      (pleaf 8 'e')))
-- true

-- Determinarea elementului castigator
winner :: FTree Priority a -> a
winner t = go t
    where
        go (Leaff _ a) = a
        go (Nodee _ x y)
            | tag x == tag t = go x
            | tag y == tag t = go y
-- *Main> winner pqFT
-- 'c'

