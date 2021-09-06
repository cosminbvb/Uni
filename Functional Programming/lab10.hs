import Test.QuickCheck
import Test.QuickCheck.Gen
import System.Random
semigroupAssoc :: (Eq m, Semigroup m) => m -> m -> m -> Bool
semigroupAssoc a b c = (a <> (b <> c)) == ((a <> b) <> c)
monoidLeftIdentity :: (Eq m, Monoid m) => m -> Bool
monoidLeftIdentity a = (mempty <> a) == a
monoidRightIdentity :: (Eq m, Monoid m) => m -> Bool
monoidRightIdentity a = (a <> mempty) == a

--1

data Trivial = Trivial
    deriving (Eq, Show)
instance Semigroup Trivial where
    _ <> _ = Trivial
instance Monoid Trivial where
    mempty = Trivial
instance Arbitrary Trivial where
    arbitrary = elements [Trivial]
type TrivAssoc = Trivial -> Trivial -> Trivial -> Bool
type TrivId = Trivial -> Bool
-- quickCheck (semigroupAssoc :: TrivAssoc)
-- quickCheck (monoidLeftIdentity :: TrivId)
-- quickCheck (monoidRightIdentity :: TrivId)

--2
newtype BoolConj = BoolConj Bool
    deriving (Eq, Show)
instance Semigroup BoolConj where
    BoolConj a <> BoolConj b = BoolConj (a && b)
instance Monoid BoolConj where
    mempty = BoolConj True
instance Arbitrary BoolConj where
    arbitrary = MkGen ( \s i -> BoolConj ((unGen arbitrary) s i))

{-- sau cv de genul:
    arbitrary = elements (map BoolConj list)
        where
            list = take 50000 (randoms(mkStdGen 0)) :: [Bool]
--}

type BoolConjAssoc = BoolConj -> BoolConj -> BoolConj -> Bool
type BoolConjId = BoolConj -> Bool

-- quickCheck (semigroupAssoc :: BoolConjAssoc)
-- quickCheck (monoidLeftIdentity :: BoolConjId)
-- quickCheck (monoidRightIdentity :: BoolConjId)


--3
newtype BoolDisj = BoolDisj Bool deriving (Eq, Show)

instance Semigroup BoolDisj where
    BoolDisj a <> BoolDisj b = BoolDisj (a || b)
instance Monoid BoolDisj where
    mempty = BoolDisj False 
instance Arbitrary BoolDisj where
    arbitrary = fmap BoolDisj arbitrary

type BoolDisjAssoc = BoolDisj -> BoolDisj -> BoolDisj -> Bool
type BoolDisjId = BoolDisj -> Bool

-- quickCheck (semigroupAssoc :: BoolDisjAssoc)
-- quickCheck (monoidLeftIdentity :: BoolDisjId)
-- quickCheck (monoidRightIdentity :: BoolDisjId)

--4
newtype Identity a = Identity a
    deriving (Eq, Show)
instance Semigroup a => Semigroup (Identity a) where
     (Identity a) <> (Identity b) = Identity (a <> b)
instance Monoid a => Monoid (Identity a) where
     mempty  = Identity mempty 
instance Arbitrary a => Arbitrary (Identity a) where
    arbitrary = MkGen ( \s i -> Identity ((unGen arbitrary) s i))
type IdentityAssoc a = Identity a -> Identity a -> Identity a -> Bool
type IdentityId a = Identity a -> Bool

-- quickCheck (semigroupAssoc :: IdentityAssoc String)
-- quickCheck (monoidLeftIdentity :: IdentityId [Int])
-- quickCheck (monoidRightIdentity :: IdentityId [Int])

--5
data Two a b = Two a b
    deriving (Eq, Show)
instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where
    Two x y <> Two z t = Two (x <> z) (y <> t) 
instance (Monoid a, Monoid b) => Monoid (Two a b) where
    mempty = Two mempty mempty 
instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
    arbitrary = MkGen ( \s i -> Two ((unGen (arbitrary)) s i) ((unGen (arbitrary)) s i))
type TwoAssoc a b = Two a b -> Two a b -> Two a b -> Bool
type TwoId a b = Two a b -> Bool

-- quickCheck (semigroupAssoc :: TwoAssoc String [Int])
-- quickCheck (monoidLeftIdentity :: TwoId [Int] String)
-- quickCheck (monoidRightIdentity :: TwoId [Int] [Int])

--6
data Or a b = Fst a | Snd b
  deriving (Eq, Show)

instance  Semigroup (Or a b) where 
  Fst _ <> x =  x
  y     <> _ =  y

instance (Arbitrary a, Arbitrary b) => Arbitrary (Or a b) where
  arbitrary = oneof [MkGen ( \s i -> Fst ((unGen arbitrary) s i)), 
                     MkGen ( \s i -> Snd ((unGen arbitrary) s i))]

type OrAssoc a b = Or a b -> Or a b -> Or a b -> Bool

-- quickCheck (semigroupAssoc :: OrAssoc String Int)
-- quickCheck (semigroupAssoc :: OrAssoc String [Int])