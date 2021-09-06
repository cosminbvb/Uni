import Data.Maybe
import Data.List

type Name = String

data Pgm  = Pgm [Name] Stmt --lista aia e un fel de lista de variabile globale
        deriving (Read, Show)

data Stmt = Skip | Stmt ::: Stmt | If BExp Stmt Stmt | While BExp Stmt | Name := AExp
        deriving (Read, Show)

data AExp = Lit Integer | AExp :+: AExp | AExp :*: AExp | Var Name
        deriving (Read, Show)

data BExp = BTrue | BFalse | AExp :==: AExp | Not BExp
        deriving (Read, Show)

infixr 2 :::
infix 3 :=
infix 4 :==:
infixl 6 :+:
infixl 7 :*:


type Env = [(Name, Integer)]


factStmt :: Stmt
factStmt =
  "p" := Lit 1 ::: "n" := Lit 3 :::
  While (Not (Var "n" :==: Lit 0))
    ( "p" := Var "p" :*: Var "n" :::
      "n" := Var "n" :+: Lit (-1)
    )
    
pg1 = Pgm [] factStmt 


aEval :: AExp -> Env -> Integer
aEval (Lit i) env = i
aEval (a1 :+: a2) env = (aEval a1 env) + (aEval a2 env)
aEval (a1 :*: a2) env = (aEval a1 env) * (aEval a2 env)
-- aEval (Lit 1 :+: Lit 2) [("p", 0), ("n", 0)] = (aEval (Lit 1) [("p", 0), ("n", 0)] )
                                        --      + (aEval (Lit 2) [("p", 0), ("n", 0)] )
                                        --      = 1 + 2 = 3
                                             
-- aEval (Var "p" :+: Lit 2) [("p", 0), ("n", 0)] = (aEval (Var "p") [("p", 0), ("n", 0)] )
                                        --        + (aEval (Lit 2) [("p", 0), ("n", 0)] ) 
                                        --        = 0 + 2 = 2

aEval (Var x) env = fromMaybe (error "Variabila nu este declarata") (lookup x env)


bEval :: BExp -> Env -> Bool
bEval BTrue _ = True 
bEval BFalse _ = False 
bEval (a1 :==: a2) env = (aEval a1 env) == (aEval a2 env)
bEval (Not a1) env = not (bEval a1 env)

update :: Env -> Name -> Integer -> Env
update env x i = (x, i) : filter ((x /=).fst) env

sEval :: Stmt -> Env -> Env
sEval Skip env = env
sEval (s1 ::: s2) env = sEval s2 (sEval s1 env)
sEval (If b s1 s2) env = if (bEval b env) then (sEval s1 env) else (sEval s2 env)
sEval (While b s1) env 
        | bEval b env == True = sEval (While b s1) (sEval s1 env)
        | otherwise = sEval Skip env -- sau direct otherwise = env
sEval (x := a) env = update env x (aEval a env)
       
        
pEval :: Pgm -> Env
pEval (Pgm lista s) = sEval s (zip lista (repeat 0)) 
-- din lista facem un env cu toate variabilele = 0 si apelam sEval de s acel env 

-- *Main> pEval pg1
-- [("n",0),("p",6)]
