import Data.Monoid
import Data.Semigroup
import Data.Foldable
import Data.Char

-- 1
elem :: (Foldable t, Eq a) => a -> t a -> Bool
elem x = foldr (\a b -> b || a == x) False

null :: (Foldable t) => t a -> Bool
null = foldr (\a b -> False) True

length :: (Foldable t) => t a -> Int
length = foldr (\a b -> b + 1) 0

toList :: (Foldable t) => t a -> [a]
toList = foldr (\a b -> a : b) []

--2
-- class Foldable t where
-- fold :: Monoid m => t m -> m
-- foldMap :: Monoid m => (a -> m) -> t a -> m
-- foldr :: (a->b->b) -> b -> t a -> b
-- definitia minimala completa contine fie foldMap, fie foldr

data Constant a b = Constant b
instance Foldable (Constant a) where
    foldr func el (Constant a) = func a el

data Two a b = Two a b
instance Foldable (Two a) where
    foldr func el (Two el1 el2) = func el2 el

-- foldable (si functor) nu accepta decat un constructor de tip cu un singur parametru
-- deci avem constructorul de tip (Two a) cu a fixat care accepta un parametru de tip b

data Three a b c = Three a b c
instance Foldable (Three a b) where
    foldr func el (Three el1 el2 el3) = func el3 el

data Three' a b = Three' a b b
instance Foldable (Three' a) where
    foldr func el (Three' el1 el2 el3) = func el2 (func el3 el)

data Four' a b = Four' a b b b
instance Foldable (Four' a) where
  foldr func el (Four' el1 el2 el3 el4) = func el2 (func el3 (func el4 el))

data GoatLord a = NoGoat
                | OneGoat a
                | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)

instance Foldable GoatLord where
    foldr f b goat = 
        case goat of
            NoGoat -> b
            OneGoat a -> f a b
            MoreGoats u v w -> foldr f (foldr f (foldr f b u) v) w


-- Functor
-- class Functor m where
-- fmap :: (a->b) -> m a -> m b

newtype Identity a = Identity a
instance Functor Identity where
    fmap f (Identity a) = Identity (f a)

data Pair a = Pair a a 
instance Functor Pair where
    fmap f (Pair a b) = Pair (f a)(f b)

data Quant a b = Finance | Desk a | Bloor b
instance Functor (Quant a) where
    fmap f Finance = Finance
    fmap f (Desk a) = Desk a
    fmap f (Bloor b) = Bloor (f b)

data K a b = K a
instance Functor (K a) where
    fmap f (K a) = K a

-- Obs: nu poti aplica functia decat pe datele care nu au fost fixate

data LiftItOut f a = LiftItOut (f a)
instance Functor f => Functor (LiftItOut f) where
    fmap f (LiftItOut x) = LiftItOut $ fmap f x

data Parappa f g a = DaWrappa (f a) (g a)
instance (Functor f, Functor g) => Functor (Parappa f g) where
    fmap f (DaWrappa x y) = DaWrappa (fmap f x) (fmap f y)
 
data IgnoreOne f g a b = IgnoringSomething (f a) (g b)
instance Functor g => Functor (IgnoreOne f g a) where
    fmap f (IgnoringSomething x y) = IgnoringSomething x (fmap f y)

data Notorious g o a t = Notorious (g o) (g a) (g t)
instance Functor g => Functor (Notorious g o a) where
    fmap f (Notorious o a t) = Notorious o a (fmap f t)
  
data TalkToMe a = Halt | Print String a | Read (String -> a)
instance Functor TalkToMe where
    fmap f Halt = Halt
    fmap f (Print s a) = Print s $ f a
    fmap f (Read g) = Read $ f . g