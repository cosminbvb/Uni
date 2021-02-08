import Data.Char
import Data.List

prelStr strin = map toUpper strin
ioString = do
    strin <- getLine
    putStrLn $ "Intrare\n" ++ strin
    let strout = prelStr strin
    putStrLn $ "Iesire\n" ++ strout


prelNo noin = sqrt noin
ioNumber = do
    noin <- readLn :: IO Double
    putStrLn $ "Intrare\n" ++ (show noin)
    let noout = prelNo noin
    putStrLn $ "Iesire"
    print noout


inoutFile = do
    sin <- readFile "Input.txt"
    putStrLn $ "Intrare\n" ++ sin
    let sout = prelStr sin
    putStrLn $ "Iesire\n" ++ sout
    writeFile "Output.txt" sout

aux1 :: Int -> [String] -> Int -> IO()
aux1 0 lista maxim = do
    putStrLn $ (concat lista) ++ " " ++ (show maxim)
aux1 n list ma = do
    nume <- getLine
    varsta <- readLn :: IO Int
    if varsta == ma
        then aux1 (n-1) (nume : list) varsta
    else
        if varsta > ma
            then aux1 (n-1) [nume] varsta
        else aux1 (n-1) list ma
ex1 = do
n<- readLn :: IO Int
aux1 n [] 0

--2
toTuplu :: [String] -> (String, Int)
toTuplu [a, b] = (a, read b)

myConcat :: [String] -> String
myConcat [] = ""
myConcat (x : xs) = x ++ "\n" ++ myConcat xs

inPersFis = 
    do
        fis <- readFile "ex2.in"
        let linii = lines fis
        let persoane = map (\pers -> toTuplu (splitOn "," pers)) lines
        let max = foldr (\(_, var) vechiMax -> max var vechiMax) 0 persoane
        let persVarMax = filter (\(a, b) -> b == max) persoane 
        putStrLn $ myConcat $ map fst persVarMax