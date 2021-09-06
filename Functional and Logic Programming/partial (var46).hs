-- Petrescu Cosmin, Grupa 243
{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are doua celule de memorie, care au valoarea initiala  0.

Instrucțiunea `expr :> i` are urmatoarea semantica:  expresia `expr` este evaluata, 
iar valoarea este pusa in `Mem1` daca i=1, si in `Mem2` altfel.

Un program este o expresie de tip `Prog` care execută pe rând toate instrucțiunile iar rezultatul executiei
este starea finală a memoriei. 
Testare se face apeland `prog test`. 
-}


import Data.Either

data Prog  = On [Stmt]
data Stmt  =  Expr  :> Int 
data Mem = Mem1 | Mem2 
data Expr  =  M Mem | V Int | Expr :+ Expr | If Int Expr Expr


infixl 6 :+
infix 4 :>

type Env = (Int,Int)   -- corespunzator celor doua celule de memorie

  
expr ::  Expr -> Env -> Int
expr (e1 :+  e2) (m1,m2) = (expr  e1 (m1,m2)) + (expr  e2 (m1,m2))
expr (V a) _ = a
expr (M Mem1) (m1, m2) = m1
expr (M Mem2) (m1, m2) = m2
expr (If i e1 e2) (m1, m2)
    | i == 1 = if m1 /= 0 then expr e1 (m1, m2) else expr e2 (m1, m2)
    | i == 2 = if m2 /= 0 then expr e1 (m1, m2) else expr e2 (m1, m2)
    | otherwise = error "i out of bounds"
-- - pentru i=1,  se evaluează  `e1` daca expresia `Mem1` este nenula si `e2` in caz contrar,
-- - pentru i=2,  se evaluează  `e1` daca expresia `Mem2` este nenula si `e2` in caz contrar,
-- - se arunca eroare pentru i diferit de 1 si 2.

stmt :: Stmt -> Env -> Env
stmt (e :> i) (m1, m2) =  if i == 1 then (a, m2)
                          else (m1, a)
                          where a = expr e (m1, m2)

stmts :: [Stmt] -> Env -> Env
stmts [] env = env
stmts (x:xs) env = stmts xs (stmt x env) 

prog :: Prog -> Env
prog (On ss) = stmts ss (0, 0)



test1 = On [V 3 :> 1,  M Mem1 :+ V 5 :> 2]
test2 = On [V 3 :> 2,  V 4 :> 1, (M Mem1 :+ M Mem2) :+ V 5 :> 1]
test3 = On [V 3 :+  V 3 :> 2]

-- Testele pentru 1):
-- *Main> prog test1
-- (3,8)
-- *Main> prog test2
-- (12,3)
-- *Main> prog test3
-- (0,6)


-- Teste pentru 2):
test4 = On [If 1 (V 3 :+  V 3) (V 7) :> 2]
-- If 1 (V 6) (V 7) (0, 0) => V 7
-- V 7 :> 2 => (0, 7)
test5 = On [If 2 (V 3 :+  V 3) (V 7) :> 2]
test6 = On [V 3 :> 2, If 2 (V 3 :+  V 3) (V 7) :> 1]
-- If 2 (V 6) (V 7) (0, 3) => V 6
-- V 6 :> 1 => (6, 3)
test7 = On [If 3 (V 3 :+  V 3) (V 7) :> 2]

-- *Main> prog test4
-- (0,7)
-- *Main> prog test5
-- (0,7)
-- *Main> prog test6
-- (6,3)
-- *Main> prog test7
-- (0,*** Exception: i out of bounds
-- CallStack (from HasCallStack):
--   error, called at var46.hs:33:19 in main:Main

-- Exercitiul 3)
-- Limbajul Extins:

type M a = Either String a -- Either String Env /Either String Int

showM :: Show a => M a -> String
showM (Right a) = "Success: " ++ show a
showM (Left a) = "Error: " ++ show a

exprM ::  Expr -> Env -> M Int
exprM (e1 :+  e2) (m1,m2) = do
                            v1 <- exprM e1 (m1,m2)
                            v2 <- exprM e2 (m1,m2)
                            return (v1+v2)
exprM (V a) _ = return a
exprM (M Mem1) (m1, m2) = return m1
exprM (M Mem2) (m1, m2) = return m2
exprM (If i e1 e2) (m1, m2)
    | i == 1 = if m1 /= 0 then exprM e1 (m1, m2) else exprM e2 (m1, m2)
    | i == 2 = if m2 /= 0 then exprM e1 (m1, m2) else exprM e2 (m1, m2)
    | otherwise = Left "Eroare memorie"

stmtM :: Stmt -> Env -> M Env
stmtM (e :> i) (m1, m2) = do
                          val <- exprM e (m1, m2)
                          case i of
                              1 -> return (val, m2)
                              2 -> return (m1, val)
                              _ -> Left "Eroare memorie"

-- interpretarea instructiunii `expr :> i` 
-- astfel: expresia `expr` este evaluata,  valoarea este pusa in `Mem1` daca i=1,  in `Mem2` 
-- daca i=2, iar pentru i diferit de 1 si 2 rezultatul va fi `Left "Eroare memorie"`.

stmtsM :: [Stmt] -> Env -> M Env
stmtsM [] env = return env
stmtsM (x:xs) env = do 
            env <- stmtM x env
            stmtsM xs env 

progM :: Prog -> M Env
progM (On ss) = stmtsM ss (0, 0)

-- Pentru 3) am folosit aceleasi teste ca la exercitiile precedente, interpretate cu noile functii
-- *Main> progM test1
-- Right (3,8)
-- *Main> progM test2
-- Right (12,3)
-- *Main> progM test3
-- Right (0,6)
-- *Main> progM test4
-- Right (0,7)
-- *Main> progM test5
-- Right (0,7)
-- *Main> progM test6
-- Right (6,3)
-- *Main> progM test7
-- Left "Eroare memorie"



{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresia `If i e1 e2` , unde `i` este un intreg, `e1` si `e2` sunt expresii, semnificatia
fiind urmatoarea: 
- pentru i=1,  se evaluează  `e1` daca expresia `Mem1` este nenula si `e2` in caz contrar,
- pentru i=2,  se evaluează  `e1` daca expresia `Mem2` este nenula si `e2` in caz contrar,
- se arunca eroare pentru i diferit de 1 si 2.
3)(20pct) Definiti interpretarea  limbajului extins astfel incat interpretarea unui program / instrucțiune /expresie
 să aibă tipul rezultat `Either String Env /Either String Int`, schimband interpretarea instructiunii `expr :> i` 
astfel: expresia `expr` este evaluata,  valoarea este pusa in `Mem1` daca i=1,  in `Mem2` 
daca i=2, iar pentru i diferit de 1 si 2 rezultatul va fi `Left "Eroare memorie"`. 
Acelasi rezultat va fi intors si pentru cazul de eroare de la punctul 2).
Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare. 

Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}