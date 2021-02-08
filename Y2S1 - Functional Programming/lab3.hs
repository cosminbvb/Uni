import Data.List

--L3.1
factori :: Int ->[Int]
factori n = [x| x<-[2..n], n `mod` x == 0]

prim :: Int -> Bool
prim n 
    | product(factori n) == n = True
    | otherwise = False
    
numerePrime :: Int -> [Int]
numerePrime n = [x | x<-[2..n], prim(x)]


--L3.2
myzip3 :: [Int] -> [Int] -> [Int] -> [(Int,Int,Int)]
myzip3 (h1:t1) (h2:t2) (h3:t3) = (h1,h2,h3) : myzip3 t1 t2 t3
myzip3 _ _ _ = []


--L3.3.1
firstEl :: [(a,b)] -> [a]
firstEl x = map fst x


--L3.3.2
sumList :: [[Integer]] -> [Integer]
sumList l = map sum l  


--L3.3.3
prel :: Integer -> Integer
prel x 
    | odd x = x*2
    | otherwise  = x `div` 2
prel2 :: [Integer] -> [Integer]
prel2 x = map prel x


--L3.4.1
f :: Char -> [[Char]] -> [[Char]]
f s l = filter(s `elem`) l


--L3.4.2
f2 :: [Int] -> [Int]
f2 x = map(^2)(filter odd x)


--L3.4.3
f3 :: [Int] -> [Int]
f3 x = map((^2).snd)(filter (odd.fst) (zip [1,2..] x))


--L3.4.4
elimina :: [Char] -> [Char]
elimina s = filter (`elem` "aeiouAEIOU") s
numaiVocale :: [[Char]] -> [[Char]]
numaiVocale l = map elimina l
--sau
numaiVocale2 :: [[Char]] -> [[Char]]
numaiVocale2 l = map (filter (`elem` "aeiouAEIOU")) l
 

--L3.5 - Ciurul lui Eratostene
numerePrimeCiur :: Int -> [Int]
numerePrimeCiur n = aux [2..n]
            where
                aux :: [Int] -> [Int]
                aux [] = []    
                aux (x:xs) = x : aux (xs \\ [x,x+x..n])
                -- operatorul \\ din Data.List face diferenta pe liste

--L3.5.1
ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x:xs) = and(map(\(x,y) -> x<=y) (zip (x:xs) xs))
{-cu zip formam tupluri de elemente consecutive din lista
dupa care pe fiecare tuplu aplicam functia anonima 
iar apoi facem && intre toate elementele listei
ex: [3,4,5,6]->[(3,4),(4,5),(5,6)]->[True,True,True]->True
-}


--L3.5.2
ordonataNat2 :: [Int] -> Bool
ordonataNat2 [] = True;
ordonataNat2 [x] = True;
ordonataNat2 (x1:x2:xs) = x1<=x2 && ordonataNat2(x2:xs) 

--L3.5.3
ordonata :: [a] -> (a -> a-> Bool) -> Bool
ordonata [] r = True;
ordonata [x] r = True;
ordonata (x1:x2:xs) r = r x1 x2 && ordonata(x2:xs) r
{- ordonata [1,2,3,4,5] (<=) => True
   ordonata [1.2, 2.4, 5, 7,8] (<=) => True
   ordonata ["abcd","b","bd"] (<=) => True (ordine lexicografica)
   ordonata [[1,2],[1,2,3],[1,3]] (<=) => True
   ordonata [8,4,2,1] (\x y -> if mod x y == 0 then True else False) => True
   ordonata [8,3,2,1] (\x y -> if mod x y == 0 then True else False) => False
-}


(*<*) :: (Integer, Integer) -> (Integer, Integer) -> Bool
{-
(a,b) *<* (c,d) 
          | a<c && b<d = True
          | otherwise = False
-}
--sau
(a,b) *<* (c,d) = if a<c && b<d then True
                  else False                   
-- ordonata [(3,4),(4,10),(8,11),(9,12)] (*<*)  => True 



--L.3.5.4
compuneList :: (b->c) -> [(a->b)] -> [(a->c)]
compuneList f list = map(f.) list
aplicaList :: a -> [(a->b)] -> [b]
aplicaList a list = [f a| f<-list]
-- aplicaList 9 [sqrt, (^2), (/2)] => [3.0,81.0,4.5]
-- aplicaList 9 (compuneList (+1) [sqrt, (^2), (/2)]) => [4.0,82.0,5.5]
-- dar compuneList (+1) [sqrt, (^2), (/2)] => error
-- imo e de la "lazyness"

myzip3V2 :: [a] -> [b] -> [c] -> [(a,b,c)]
myzip3V2 l1 l2 l3 = map (\((x,y), z) -> (x,y,z)) (zip (zip l1 l2) l3)