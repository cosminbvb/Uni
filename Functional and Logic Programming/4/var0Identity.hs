--- Monada Identity

newtype Identity a = Identity { runIdentity :: a }

instance Show a => Show (Identity a) where
    show (Identity a) = show a

instance Monad Identity where
    return a = Identity a
    ma >>= k = k (runIdentity ma) --scoatem informatia din ma si aplicam functia 

instance Applicative Identity where
    pure = return
    mf <*> ma = do
      f <- mf
      va <- ma
      return (f va)       

instance Functor Identity where              
    fmap f ma = pure f <*> ma

--- Limbajul si  Interpretorul

type M a = Identity a

showM :: Show a => M a -> String
showM x = show (runIdentity x)

type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
  deriving (Show)

pgm :: Term
pgm = App
  (Lam "y"
    (App
      (App
        (Lam "f"
          (Lam "y"
            (App (Var "f") (Var "y"))
          )
        )
        (Lam "x"
          (Var "x" :+: Var "y")
        )
      )
      (Con 3)
    )
  )
  (Con 4)


data Value = Num Integer
           | Fun (Value -> M Value)
           | Wrong

instance Show Value where
 show (Num x) = show x
 show (Fun _) = "<function>"
 show Wrong   = "<wrong>"

type Environment = [(Name, Value)]

lookupM :: Name -> Environment -> M Value
lookupM x env = case lookup x env of
                  Just v -> return v
                  Nothing -> return Wrong

add :: Value -> Value -> Value
add (Num i) (Num j) = Num (i+j)
add _ _ = Wrong

apply :: Value -> Value -> M Value
apply (Fun k) v = k v -- k: a -> M a
apply _ _ = return Wrong

interp :: Term -> Environment -> M Value
interp (Con i) env = return (Num i) -- Identity (Num 7)
interp (Var x) env = lookupM x env
interp (t1 :+: t2) env = do
      v1 <- interp t1 env
      v2 <- interp t2 env
      return (add v1 v2)
interp (Lam x e) env = return (Fun $ \v -> interp e ((x, v) : env))
interp (App t1 t2) env = do
      f <- interp t1 env -- sper sa fie functie 
      v <- interp t2 env 
      apply f v 

test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x"))) ((Con 10) :+:  (Con 11))

pgm11:: Term
pgm11 = App (((Var "x") :+: (Var "x"))) ((Con 10) :+: (Con 11))

pgm2:: Term
pgm2 = App(Lam "x" ((Var "x") :+: (Var "y")))((Con 10) :+: (Con 11))

-- *Main> test pgm1
-- "42"
-- *Main> test pgm11 (nu se stie x)
-- "<wrong>"
-- *Main> test pgm2  (nu se stie y)
-- "<wrong>"