--- Monada Reader
type Environment = [(Name, Value)]

newtype EnvReader a = EnvReader {runEnvReader :: Environment -> a}

instance Show a => Show (EnvReader a) where
    show ma = show $ runEnvReader ma []

instance Monad EnvReader where
    return x = EnvReader (\_ -> x)
    ma >>= k = EnvReader f
        where f env = let a = runEnvReader ma env
                      in runEnvReader (k a) env 

instance Applicative EnvReader where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor EnvReader where
  fmap f ma = pure f <*> ma

-- inspecteaza starea curenta
ask :: EnvReader Environment
ask = EnvReader id

-- modifica  starea doar pt computatia data
local :: (Environment -> Environment) -> EnvReader a -> EnvReader a
local f ma = EnvReader $ (\env -> (runEnvReader ma )(f env))

--- Limbajul si Interpretorul
type M a = EnvReader a

showM :: Show a => M a -> String
showM = show

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
 show (Wrong) = "<wrong>"

lookupM :: Name -> M Value
lookupM var = do
                env <- ask
                case lookup var env of
                    Just val -> return val
                    Nothing -> return Wrong

add :: Value -> Value -> M Value
add (Num nr1) (Num nr2) = return (Num $ nr1 + nr2)
add _ _= return Wrong

apply :: Value -> Value -> M Value
apply (Fun func) var = func var
apply _ _ = return Wrong

interp :: Term -> M Value
interp (Var x) = lookupM x
interp (Con nr) = return (Num nr)
interp (t1 :+: t2) = do
                        var1 <- interp t1
                        var2 <- interp t2
                        add var1 var2
interp (Lam x t) = do
                        env <- ask
                        return $ Fun $ \v -> local (const ((x, v):env)) (interp t)
interp (App t1 t2) = do
                        func <- interp t1
                        var <- interp t2
                        apply func var

test :: Term -> String
test t = showM $ interp t

pgm1 :: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))

pgm2 :: Term
pgm2 = (App (Con 7) (Con 2))
          
-- test pgm
-- test pgm1
