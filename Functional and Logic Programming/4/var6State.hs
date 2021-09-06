--- Monada State
newtype IntState a = IntState { runIntState :: Integer -> (a, Integer) }

instance Show a => Show (IntState a) where
    show ma = "Value: " ++ show a ++ " Count: " ++ show state
        where (a, state) = runIntState ma 0

instance Monad IntState where
    return x = IntState (\s -> (x, s))
    ma >>= k = IntState (\state -> let (a, state1) = runIntState ma state
                                   in runIntState (k a) state1)
                    

instance Applicative IntState where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor IntState where
  fmap f ma = pure f <*> ma

-- schimba starea
modify :: (Integer -> Integer) -> IntState ()
modify fun = IntState (\s -> ((), fun s))

-- crestere stare contor
tickS :: IntState ()
tickS = modify (+1)

-- obtinere stare curenta
get :: IntState Integer
get = IntState (\s -> (s, s))

--- Limbajul si Interpretorul
type M a = IntState a

showM :: Show a => M a -> String
showM = show

type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
          | Count
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
 show (Wrong) = "<wrong>"

type Environment = [(Name, Value)]

lookupM :: Name -> Environment -> M Value
lookupM var env = case lookup var env of
  Just val -> return val
  Nothing -> return Wrong

add :: Value -> Value -> M Value
add (Num nr1) (Num nr2) = tickS >> return (Num $ nr1 + nr2)
add _ _ = return Wrong

apply :: Value -> Value -> M Value
apply (Fun func) var = tickS >> func var
apply _ _ = return Wrong

interp :: Term -> Environment -> M Value
interp (Var x) env = lookupM x env
interp (Con nr) _ = return (Num nr)
interp (t1 :+: t2) env = do
                            var1 <- interp t1 env
                            var2 <- interp t2 env
                            add var1 var2
interp (Lam x t) env = return $ Fun $ \v -> interp t ((x, v):env)
interp (App t1 t2) env = do
                        func <- interp t1 env
                        var <- interp t2 env
                        apply func var
interp Count _ = do
                    count <- get
                    return (Num count)

test :: Term -> String
test t = showM $ interp t []

pgm1 :: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
-- *Main> test pgm1
-- "Value: 42 Count: 3"


pgm2 :: Term
pgm2 = (App (Con 7) (Con 2))
-- *Main> test pgm2
-- "Value: <wrong> Count: 0"


pgm3 :: Term
pgm3 = ((Con 1 :+: Con 2) :+: Count)
-- *Main> test pgm3
-- "Value: 4 Count: 2"

-- *Main> test (Con 1 :+: Con 2)
-- "Value: 3 Count: 1"