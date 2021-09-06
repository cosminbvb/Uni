--- Monada Writer
newtype StringWriter a = StringWriter { runStringWriter :: (a, String) }

instance Show a => Show (StringWriter a) where
    show ma = "Output: " ++ sir ++ " Value: " ++ show a
        where (a, sir) = runStringWriter ma

instance Monad StringWriter where
    return x = StringWriter (x, "")
    ma >>= k = let
                    (a, sir1) = runStringWriter ma
                    (b, sir2) = runStringWriter (k a)
                in
                    StringWriter(b, sir1  ++ sir2)

instance Applicative StringWriter where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor StringWriter where
  fmap f ma = pure f <*> ma

-- producere mesaj
tell :: String -> StringWriter ()
tell sir = StringWriter((), sir)

--- Limbajul si Interpretorul
type M a = StringWriter a

showM :: Show a => M a -> String
showM = show

type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
          | Out Term
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
add (Num nr1) (Num nr2) = return (Num $ nr1 + nr2)
add _ _ = return Wrong

apply :: Value -> Value -> M Value
apply (Fun func) var = func var
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
interp (Out t) env = do
                        var <- interp t env
                        tell (show var ++ "; ")
                        return var

test :: Term -> String
test t = showM $ interp t []

pgm1 :: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))

pgm2 :: Term
pgm2 = (App (Con 7) (Con 2))

pgm3 :: Term
pgm3 = (Out (Con 41) :+: Out (Con 1)) 

-- *Main> interp (Out (Con 41) :+: Out (Con 1)) []      
-- Output: 41; 1;  Value: 42