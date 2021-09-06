import Data.List
import Data.Maybe

type Nume = String --folosim type pt "redenumiri"
data Prop
    = Var Nume
    | F
    | T
    | Not Prop
    | Prop :|: Prop
    | Prop :&: Prop
    | Prop :->: Prop
    | Prop :<->: Prop
    deriving Eq
infixr 2 :|:
infixr 3 :&:

--1
p1, p2, p3 :: Prop
p1 = (Var "p" :|: Var "q") :&: (Var "p" :&: Var "q")
p2 = (Var "p" :|: Var "q") :&: (Not (Var "p") :&: Not (Var "q"))
p3 = (Var "p" :&: (Var "q" :|: Var "r")) :&: ((Not (Var "p") :|: Not (Var "q")) :&: (Not (Var "p") :|: Not (Var "r")))

--2
showProp :: Prop -> String
showProp (Var x) = x
showProp F = "F"
showProp T = "T"
showProp (Not p) = par ("~"++showProp p)
showProp (p :|: q) = par (showProp p ++ "|" ++ showProp q)
showProp (p :&: q) = par (showProp p ++ "&" ++ showProp q)
showProp (p :->: q) = par (showProp p ++ "->" ++ showProp q)
showProp (p :<->: q) = par (showProp p ++ "<->" ++ showProp q)

par :: String -> String
par s = "(" ++ s ++ ")"

instance Show Prop where
    show = showProp

test_ShowProp :: Bool
test_ShowProp = show (Not (Var "p") :&: Var "q") == "((~p)&q)"


--Evaluarea expresiilor

type Env = [(Nume, Bool)]

impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust . lookup a

--3
eval :: Prop -> Env -> Bool
eval (Var p) e = impureLookup p e
eval F e = False
eval T e = True
eval (Not p) e = not (eval p e)
eval (p :|: q) e = eval p e || eval q e
eval (p :&: q) e = eval p e && eval q e
eval (p :->: q) e = eval (Not p :|: q) e
eval (p :<->: q) e = eval ((p :->: q) :&: (q :->: p)) e

--sau, in loc de ultimele 2 eval folosim functiile
impl :: Bool -> Bool -> Bool
impl False _ = True
impl _ x = x
echiv :: Bool -> Bool -> Bool
echiv x y = x==y
--si avem 
--eval (p :->: q) e = eval p e `impl` eval q e
--eval (p :<->: q) e = eval p e `echiv` eval q e


test_eval = eval (Var "p" :|: Var "q") [("p", True), ("q", False)] == True

variabile :: Prop -> [Nume]
variabile (Var x) = [x]
variabile F = []
variabile T = []
variabile (Not p) = variabile p
variabile (p :|: q) = nub (variabile p ++ variabile q)
variabile (p :&: q) = nub (variabile p ++ variabile q)
variabile (p :->: q) = nub (variabile p ++ variabile q)
variabile (p :<->: q) = nub (variabile p ++ variabile q)


envs :: [Nume] -> [Env]
envs [] = [[]]
envs (x:xs) = [ (x, False) : e | e <- envs xs] ++
              [ (x, True) : e | e <- envs xs]

satisfiabila :: Prop -> Bool
satisfiabila p = or [eval p env | env <- envs(variabile p)]

test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q") == True
test_satisfiabila2 = satisfiabila (Not (Var "P") :&: Var "P") == False

valida :: Prop -> Bool
valida p = and [eval p env | env <- envs(variabile p)]

test_valida1 = valida (Not (Var "P") :&: Var "Q") == False
test_valida2 = valida (Not (Var "P") :|: Var "P") == True


show_Bool :: Bool -> String
show_Bool True = "T"
show_Bool False = "F"
tabelAdevar :: Prop -> String
tabelAdevar p = concat $ map (++ "\n") tabel
    where
        vars = variabile p
        afis_prima = concat $ (map (++ " ") vars) ++ [show p]
        evaluari = envs vars
        aux_af tv = (show_Bool tv)++ " "
        afis_evaluare ev = concat $ (map aux_af [snd p | p <- ev]) ++ [show_Bool (eval p ev)]
        tabel = afis_prima : (map afis_evaluare evaluari)


------------------------------------------------------------------

centre :: Int -> String -> String
centre w s  =  replicate h ' ' ++ s ++ replicate (w-n-h) ' '
            where
            n = length s
            h = (w - n) `div` 2
-- functie care centreaza string-ul s in functie de nr de spatii dat de w

dash :: String -> String
dash s  =  replicate (length s) '-'
-- creaza un sir de liniute care are lungimea sirului dat ca parametru
-- utilitate: sub fiecare caracter apare cate o liniuta

fort :: Bool -> String
fort False  =  "F"
fort True   =  "T"
-- inlocuieste o valoare booleana cu un sir de caractere (un string) de lungime 1


-- Prelude> unlines ["Hello", "World", "!"]
-- "Hello\nWorld\n!\n"
-- Prelude> zipWith (+) [1, 2, 3] [4, 5, 6]
-- [5,7,9]
-- Prelude> unwords ["Lorem", "ipsum", "dolor"]
-- "Lorem ipsum dolor"


showTable :: [[String]] -> IO ()
showTable tab  =  putStrLn (
  unlines [ unwords (zipWith centre widths row) | row <- tab ] )
    where
      widths  = map length (head tab) -- reduce lista de lista de stringuri intr-o lista de lungimi de stringuri
      -- folosita pentru a determina spatierea si centrarea valorilor de adevar
-- functia scrie pe cate un rand capul de tabel, linia orizontala delimitatoare
-- si apoi valorile de adevar pt fiecare predicat respectiv evaluarea fiecarei propozitii in functie de valori
      
-- Prelude> import Data.List
-- Prelude Data.List> nub [1,2,3,4,3,2,1,2,4,3,5]
-- [1,2,3,4,5]

table p = tables [p]
aux = [p1, p2, p3]

tables :: [Prop] -> IO ()
tables ps  =
  let xs = nub (concatMap variabile ps) in -- scoate toate predicatele distincte din proprozitii ("P", "Q", "R"...)
  -- concatMap = concat + map
  -- concatMap lista = concat (map f lista)
  -- partea de mapare extrage predicatele din fiecare propozitie
  -- partea de concatenare lipeste predicatele, cu tot cu duplicate
  -- nub elimina duplicatele
    showTable (
      [ xs            ++ ["|"] ++ [show p | p <- ps]           ] ++           -- capul de tabel; asaza predicatele si propozitiile care vor fi evaluate
      [ dashvars xs   ++ ["|"] ++ [dash (show p) | p <- ps ]   ] ++           -- linia delimitatoare (cate o liniuta sub fiecare predicat si liniute sub fiecare propozitie)
      [ evalvars e    ++ ["|"] ++ [fort (eval p e) | p <- ps] | e <- envs xs]
    )
    where  dashvars xs        =  [ dash x | x <- xs ]
           -- se construieste linia orizontala delimitatoare pt predicate
           evalvars e         =  map (\(x,y) -> fort y) e
           -- e este de forma [("P", False),("Q",False)...]; Din acesta dorim sa extragem variabilele boolene (de pe a doua pozitie)
           -- pe care le vom simplifica notarea cu F/T (aplicarea lui fort)
           -- Valorile de adevar sunt trecute in stanga liniei verticale (|) si semnifica
           -- valoarea de adevar pe care o are fiecare predicat in parte