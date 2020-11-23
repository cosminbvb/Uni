import Data.List

myInt = 5555555555555555555555555555555555555555555555555555555555555555555555555555555555555

double :: Integer -> Integer
double x = x+x

triple :: Integer -> Integer
triple x = x*3

-- maxim : N X N -> N
maxim :: Integer -> Integer -> Integer
maxim x y = if (x > y)
               then x
          else y
          
maxim2 (x, y) = if (x > y)
               then x
          else y
          
maxim3 x y z = maxim x (maxim y z)


max3 x y z = let
             u = maxim x y
             in (maxim  u z)

               
max3v2 x y z =
            let
                u = maxim x y
            in 
                (maxim u z)         
        

maxim4 x y z t = maxim (maxim2(x,y)) (maxim2(z,t))


max4 x y z t = let
                u = maxim x y
               in
                  let 
                   w = maxim z t 
                  in (maxim u w)
  
-- tema --
  
data Alegere 
    = Piatra 
    | Foarfeca 
    | Hartie 
    deriving (Eq, Show)   

data Rezultat 
    = Victorie
    | Infrangere
    | Egalitate
    deriving (Eq, Show)

partida :: Alegere -> Alegere -> Rezultat
partida x y = if (x==y) then Egalitate
              else if x==Piatra && y==Foarfeca ||
                      x==Foarfeca && y==Hartie ||
                      x==Hartie && y==Piatra then Victorie
                   else Infrangere
        
{- 
*Main> partida Piatra Hartie
Infrangere
*Main> partida Piatra Piatra
Egalitate
*Main> partida Foarfeca Piatra
Infrangere
*Main> partida Hartie Piatra
Victorie
-}