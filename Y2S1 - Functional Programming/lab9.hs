data Expr = Const Int -- integer constant
          | Expr :+: Expr -- addition
          | Expr :*: Expr -- multiplication
           deriving Eq

instance Show Expr where
    show (Const x) = show x
    show (x :+: y) = par (show x ++ " + " ++ show y)
    show (x :*: y) = par (show x ++ " * " ++ show y)

par :: String -> String
par s = "(" ++ s ++ ")"

evalExp :: Expr -> Int
evalExp (Const x) = x
evalExp (x :+: y) = evalExp x + evalExp y
evalExp (x :*: y) = evalExp x * evalExp y

exp1 = ((Const 2 :*: Const 3) :+: (Const 0 :*: Const 5))
exp2 = (Const 2 :*: (Const 3 :+: Const 4))
exp3 = (Const 4 :+: (Const 3 :*: Const 3))
exp4 = (((Const 1 :*: Const 2) :*: (Const 3 :+: Const 1)) :*: Const 2)

test11 = evalExp exp1 == 6
test12 = evalExp exp2 == 14
test13 = evalExp exp3 == 13
test14 = evalExp exp4 == 16




data Operation = Add | Mult deriving (Eq, Show)

data Tree = Lf Int -- leaf
          | Node Operation Tree Tree -- branch
           deriving (Eq, Show)


evalArb :: Tree -> Int
evalArb (Lf x) = x
evalArb (Node Add a1 a2) = evalArb a1 + evalArb a2
evalArb (Node Mult a1 a2) = evalArb a1 * evalArb a2


arb1 = Node Add (Node Mult (Lf 2) (Lf 3)) (Node Mult (Lf 0)(Lf 5))
arb2 = Node Mult (Lf 2) (Node Add (Lf 3)(Lf 4))
arb3 = Node Add (Lf 4) (Node Mult (Lf 3)(Lf 3))
arb4 = Node Mult (Node Mult (Node Mult (Lf 1) (Lf 2)) (Node Add (Lf 3)(Lf 1))) (Lf 2)

test21 = evalArb arb1 == 6

expToArb :: Expr -> Tree
expToArb (Const x) = Lf x
expToArb (x :+: y) = Node Add (expToArb x) (expToArb y)
expToArb (x :*: y) = Node Mult (expToArb x) (expToArb y)

class MySmallCheck a where
    smallValues :: [a]
    smallCheck :: ( a -> Bool ) -> Bool
    smallCheck prop = and [ prop x | x <- smallValues ]

instance MySmallCheck Expr where
    smallValues = [exp1, exp2, exp3, exp4]

checkExp :: Expr -> Bool
checkExp expr = evalExp(expr) == evalArb(expToArb(expr))

test5 = smallCheck checkExp


type Key = Int
type Value = String

class Collection c where
    cempty :: c 
    csingleton :: Key ->  Value -> c 
    cinsert:: Key -> Value -> c  -> c 
    cdelete :: Key -> c  -> c 
    clookup :: Key -> c -> Maybe Value
    ctoList :: c  -> [(Key, Value)]
    ckeys :: c  -> [Key]
    cvalues :: c  -> [Value]
    cfromList :: [(Key,Value)] -> c
    ckeys c = [fst p | p <- ctoList c]
    cvalues c = [snd p | p <- ctoList c]
    cfromList [] = cempty
    cfromList ((k,v):t) = cinsert k v (cfromList t)

newtype PairList 
  = PairList { getPairList :: [(Key, Value)] }

instance Show PairList where
    show (PairList l) = "PairList " ++ show l

instance Collection PairList where
    cempty = PairList []
    csingleton k v = PairList [(k,v)]
    cinsert k v (PairList l) = PairList $ (k,v) : filter ((/=k).fst) l
    cdelete k (PairList l) = PairList $ filter ((/=k).fst) l
    ctoList = getPairList
    clookup k  =  lookup k . getPairList

-- *Main> cinsert 4 "d" (PairList [(1,"a"),(2,"b"),(3,"c")])
--  PairList [(4,"d"),(1,"a"),(2,"b"),(3,"c")]

data SearchTree
    = Empty
    | Nod
        SearchTree -- elemente cu cheia mai mica
        Key -- cheia elementului
        (Maybe Value) -- valoarea elementului
        SearchTree -- elemente cu cheia mai mare
    deriving Show

instance Collection SearchTree where
    cempty = Empty
    csingleton k v = Nod Empty k (Just v) Empty
    cinsert k v = go --arborele primit ca parametru se subintelege (puteam scrie c insert k v tree = go tree ...)
        where
            go Empty = csingleton k v
            go (Nod arbstanga cheie valoare arbdreapta)
                | k == cheie = Nod arbstanga k (Just v) arbdreapta
                | k < cheie = Nod (go arbstanga) cheie valoare arbdreapta
                | otherwise = Nod arbstanga cheie valoare (go arbdreapta) 
    cdelete k = go
        where
        go Empty = Empty
        go (Nod t1 ky val t2)
            | k == ky = Nod t1 k Nothing t2  
            | k < ky = Nod (go t1) ky val t2
            | otherwise = Nod t1 ky val (go t2)
    ctoList Empty = []
    ctoList (Nod arbstanga cheie valoare arbdreapta) = ctoList arbstanga ++ kvtoList cheie valoare ++ ctoList arbdreapta
        where
            kvtoList k (Just v) = [(k,v)]
            kvtoList _ Nothing = []
    clookup k = go
        where
            go Empty = Nothing 
            go (Nod arbstanga cheie valoare arbdreapta)
                | k == cheie = valoare
                | k < cheie = go arbstanga
                | otherwise = go arbdreapta

-- *Main> cfromList [(1,"a"),(2,"b"),(3,"c")] :: PairList
-- PairList [(1,"a"),(2,"b"),(3,"c")]

-- *Main> cfromList [(1,"a"),(2,"b"),(3,"c")] :: SearchTree
-- Nod (Nod (Nod Empty 1 (Just "a") Empty) 2 (Just "b") Empty) 3 (Just "c") Empty

{-
                 3:c

           2:b        empty

      1:a      empty

empty    empty

-}

-- exemplu 
tree :: SearchTree
tree = cempty
tree2 :: SearchTree
tree2 = cinsert 1 "a" tree 
tree3 :: SearchTree
tree3 = Nod (Nod (Nod Empty 1 (Just "a") Empty) 2 (Just "b") Empty) 3 (Just "c") Empty
