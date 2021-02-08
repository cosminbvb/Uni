data Fruct
    = Mar String Bool
    | Portocala String Int

ionatanFaraVierme = Mar "Ionatan" False
goldenCuVierme = Mar "Golden Delicious" True
portocalaSicilia10 = Portocala "Sanguinello" 10
listaFructe = [Mar "Ionatan" False,
            Portocala "Sanguinello" 10,
            Portocala "Valencia" 22,
            Mar "Golden Delicious" True,
            Portocala "Sanguinello" 15,
            Portocala "Moro" 12,
            Portocala "Tarocco" 3,
            Portocala "Moro" 12,
            Portocala "Valencia" 2,
            Mar "Golden Delicious" False,
            Mar "Golden" False,
            Mar "Golden" True]

ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Mar _ _) = False
ePortocalaDeSicilia (Portocala tip _) = tip `elem` ["Tarocoo", "Moro", "Sanguinello"]

nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia list = sum [x | Portocala _ x <- filter ePortocalaDeSicilia list]

nrMereViermi :: [Fruct] -> Int
nrMereViermi [] = 0
nrMereViermi (Portocala _ _ : t) = nrMereViermi t
nrMereViermi (Mar _ x : t) 
                    | x==True = 1+nrMereViermi(t)
                    | otherwise = nrMereViermi(t)       

nrMereViermiV2 :: [Fruct] -> Int
nrMereViermiV2 f = length [1 | (Mar _ True) <- f]                   


data Linie = L[Int]
     deriving Show
data Matrice = M[Linie]

verifica :: Matrice -> Int -> Bool
verifica (M list) nr = foldr (&&) True ( map (\ (L li) -> foldr(+) 0 li == nr) list )
--sau verifica (M m) nr = foldr (&&) True [sum x == nr | (L x) <- m]

--pt show linie ori scoatem deriving Show si scriem asta ori facem o functie
--instance Show Linie where
--    show (L l) = foldr (++) "" (map (\x ->( (show x)++" ")) l)

showL :: Linie -> [Char]
showL( L []) = ""
showL( L (h:t)) = show h ++ " " ++ showL(L t)

instance Show Matrice where
    show (M []) = ""
    show (M (l:linii)) = showL l ++ "\n" ++ show(M linii)

    
    
linePoz::Linie -> Int -> Bool
linePoz (L l) n = length(l)/=n || and [x>0|x<-l]
doarPozN::Matrice -> Int -> Bool
doarPozN (M l) n = and (map (\x -> linePoz x n) l)
    