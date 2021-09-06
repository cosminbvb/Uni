module Checker where

import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

import SIMPLE

data Type = TInt | TBool
  deriving (Eq)

instance Show Type where
    show TInt = "int"
    show TBool = "bool"

type CheckerState = Map Name Type

emptyCheckerState :: CheckerState
emptyCheckerState = Map.empty

newtype EReader a =
    EReader { runEReader :: CheckerState -> (Either String a) }

throwError :: String -> EReader a
throwError e = EReader (\_ -> (Left e))

instance Monad EReader where
    return a = EReader (\env ->  Right a)
    act >>= k = EReader  f
                where
                 f env  = case (runEReader act env) of
                           Left s -> Left s
                           Right va -> runEReader (k va) env


instance Functor EReader where
    fmap f ma = do { a <- ma; return (f a) }

instance Applicative EReader where
    pure = return
    mf <*> ma = do { f <- mf; a <- ma; return (f a)}

askEReader :: EReader CheckerState
askEReader = EReader (\env -> Right env)

localEReader :: (CheckerState -> CheckerState) -> EReader a -> EReader a
localEReader f ma = EReader (\env -> (runEReader ma) (f env))

type M = EReader

expect :: (Show t, Eq t, Show e) => t -> t -> e -> M ()
expect tExpect tActual e =
    if (tExpect /= tActual)
    then     (throwError
        $ "Type mismatch. Expected " <> show tExpect <> " but got " <> show tActual
        <> " for " <> show e)
    else (return ())

lookupM :: Name -> M Type
lookupM x = do
                env <- askEReader
                case (Map.lookup x env) of
                    Nothing -> throwError $ "Variable " <> x <> " not declared"
                    Just t -> return t


checkExp :: Exp -> M Type
checkExp (Id x) = lookupM x
checkExp (I _) = return TInt
checkExp (B _) = return TBool
checkExp (UMin e) = do
                        t <- checkExp e
                        expect TInt t e
                        return TInt
checkExp (BinA _ e1 e2) = do
                            t1 <- checkExp e1
                            expect TInt t1 e1
                            t2 <- checkExp e2
                            expect TInt t2 e2
                            return TInt
checkExp (BinC _ e1 e2) = do
                            t1 <- checkExp e1
                            expect TInt t1 e1
                            t2 <- checkExp e2
                            expect TInt t2 e2
                            return TBool
checkExp (BinE _ e1 e2) = do
                            t1 <- checkExp e1
                            expect TInt t1 e1
                            t2 <- checkExp e2
                            expect TInt t2 e2
                            return TBool   
checkExp (BinL _ e1 e2) = do
                            t1 <- checkExp e1
                            expect TBool t1 e1
                            t2 <- checkExp e2
                            expect TBool t2 e2
                            return TBool  
checkExp (Not e) = do
                        t <- checkExp e
                        expect TBool t e
                        return TBool

checkStmt :: Stmt -> M ()
checkStmt (Asgn x e) = do
                            t1 <- lookupM x
                            t2 <- checkExp e
                            expect t1 t2 e
checkStmt (If e s1 s2) = do
                            t <- checkExp e
                            expect TBool t e
                            checkStmt s1
                            checkStmt s2
checkStmt (Read _ x) = do
                            t <- lookupM x
                            expect TInt t x
                            return ()
checkStmt (Print _ e) = do
                            t <- checkExp e
                            expect TInt t e
                            return ()
checkStmt (While e s) = do
                            t <- checkExp e
                            expect TBool t e
                            checkStmt s
checkStmt (Block ss) = checkBlock ss
checkStmt (Decl _ _) = return ()

checkBlock :: [Stmt] -> M ()
checkBlock [] = return ()
checkBlock (Decl x e : ss) = do
                                t <- checkExp e
                                localEReader (Map.insert x t) (checkBlock ss)
checkBlock (s : ss) = checkStmt s >> checkBlock ss

checkPgm :: [Stmt] -> Bool
checkPgm pgm =
    case  (runEReader (checkBlock pgm)) emptyCheckerState of
        Left err -> error err
        Right _ -> True

exp = (BinC Lte (B True) (BinA Add (I 2) (Id "x")))

pgm = [ Block [ 
        Decl "n" (I 5),
        Decl "fact" (Id "n"),
        Decl "i" (I 1),
        While (BinE Neq  (Id "n") (Id "i")) 
                 (Block [ Asgn "fact" (BinA Mul (Id "fact") (Id "i")),
                        Asgn "i" (BinA Add (Id "i") (I 1))
                        ]
                 )
               ]
      ]  
-- *Checker> checkPgm pgm
-- True  


pgm1 = Block [
                Decl "n" (I 5),
                Decl "fact" (B True),
                Decl "i" (I 1),
                While (BinE Neq  (Id "n") (Id "i"))
                            (Block [ Asgn "i" (BinA Add (Id "i") (B False)),
                            Asgn "fact" (BinL And (B True) (Id "i"))        
                                ]
                            )
                ]

-- *Checker> checkPgm [pgm1]
-- *** Exception: Type mismatch. Expected int but got bool for false
-- CallStack (from HasCallStack):
--   error, called at lab6.hs:138:21 in main:Checker