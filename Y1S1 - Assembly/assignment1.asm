.data
p:.space 4
v:.space 400
nr:.space 400
nr_updated:.space 400
nr2:.space 400
nr2_updated:.space 400
str:.space 100
str_updated:.space 100
str2:.space 100
str2_updated:.space 100
alfabet:.asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
msj:.asciiz "Introduceti cheia (P): "
error:.asciiz "P nu este prim"
msj1: .asciiz "Generatorul g este: "
msj2: .asciiz "\nIntroduceti textul care trebuie criptat: "
msj3: .asciiz "\nIntroduceti textul care trebuie decriptat: "
test:.asciiz "Nu exista izomorfism"
sp: .asciiz " "
unknown:.asciiz "Unknown error"
.text
main:
la $a0,msj #incarcam in a0 adresa stringului msj
li $v0,4 #cod pentru print string
syscall
li $v0,5 #il citim in v0 pe p, 5-codul de read int
syscall
move $t0,$v0 #mutam in $t0 ce e in $v0, deci $t0=p
sw $t0,p #stocam valoarea din $t0 in memorie (p)
#mai intai verificam daca p e prim sau nu
li $t1,1
bgt $t0,$t1,e_bine #daca t0>t1 atunci sare la label-ul e_bine
la $a0,error #afisare eroare ("P nu e prim")
li $v0,4
syscall
li $v0,10#codul pt exit
syscall
e_bine:
li $t1,2 #initializare i pt verificare prim
div $t0,$t1 #impartim p la 2
mflo $t2 # $t2=$t0/t1=p/2
loop:
   bgt $t1, $t2, exit #daca t1>=t2 atunci exit. Daca se ajunge in exit, atunci p e prim
   div $t0,$t1 #impartim p la i
   addi $t1,$t1,1 #i++
   mfhi $t3 # $t4=$t0%$t1=p%i
   beqz $t3, atunci #daca t4==0 (t4 are divizori), atunci
   j loop
atunci:
   la $a0,error #afisare eroare ("P nu e prim")
   li $v0,4 #cod sistem print string
   syscall
   li $v0,10 #cod pentru exit
   syscall
exit:
#daca am ajuns aici inseamna ca p e prim
#urmeaza sa gasim generatorul
#consideram g bun daca se cicleaza doar la g^p (i.e. g^p=1)
li $t1,2 #prima valoare de la care cautam generatorul(g==$t1)
li $t2,0 #indice pt memorie pt v i=0
li $t3,1 #t3 va retine retul puterilor, initial e 0 pt ca g^0=1 oricare g
sw $t3,v($t2) #v[1]=1
sub $t0,$t0,1 #p-- (sa nu se faca in loop g^(p-1) pt ca o sa fie 1)
addi $t6,$t0,1 #p ul original
li $t5,1 #constanta 1
loop_2:
   bgt $t1,$t0,label_1 # daca t1>=t0 (g>=p) atunci et_2 #nu o sa se ajunga aici oricum
   li $t2,4 #i=2 pt vector
   sw $t1,v($t2) #v[2]=g 
   addi $t2,$t2,4 #i=3 pt vector
   move $t3,$t1 #mutam val din t1 in t3
   li $t4,2 #j=2 (indice pt puteri)
   loop_3:
   bge $t4,$t0,rezultat #daca ajungem la rezultat g e generator
   #daca $t4<$t0 i.e j<p, atunci:
   mul $t3,$t3,$t1 #rest=rest*g
   bgt $t3,$t0,mod #daca rest>p-1 se calculeaza la mod
   #daca nu e, atunci:
   sw $t3,v($t2)#trecem restul in vector
   addi $t2,$t2,4 #crestem indicele pt memorie din 4 in 4
   addi $t4,$t4,1 #crestem puterea
   beq $t3,$t5,try_again #daca $t3=1, i.e a aparut un rest de 1, incercam cu alt g
   #daca $t3!=1, atunci:
   j loop_3 #daca toate sunt bune, ne intoarcem la loop_3 pt a calcula puterile in continuare
   mod:
   div $t3,$t6 # il impartim pe t3 la t6
   mfhi $t3 #t3%=$t6  unde $t6 e p 
   sw $t3,v($t2)#trecem restul in vector
   addi $t2,$t2,4 #crestem indicele pt memorie din 4 in 4
   addi $t4,$t4,1 #crestem puterea
   beq $t3,$t5,try_again #daca $t3=1, i.e a aparut un rest de 1, try_again
   #daca $t3!=1, atunci:
   j loop_3 #ne intoarcem la loop_3 pt a calcula puterile in continuare
   try_again:
   addi $t1,$t1,1 #t1+=1
   j loop_2 #jump to loop_2
   rezultat:
   la $a0,msj1 #incarcam in a0 adresa stringului msj1
   li $v0,4 #cod print string
   syscall
   move $a0,$t1 #il mutam pe $t1 in $a0
   li $v0,1 #cod pt print int
   syscall
   sw $t5, v($t2) #v[p-1]=1
   la $a0,msj2  #incarcam in a0 adresa stringului msj2
   li $v0,4 #cod print string
   syscall
   #---criptare:
   #read string:
   la $a0,str #incarcam in $a0 adresa in care stocam
   li $a1,99 #99 e dimensiunea maxima a sirului
   li $v0,8 #cod pentru read string
   syscall
   #parcurgere str litera cu litera
   li $t0,0 #indice memorie pt str
   lb $t1,str($t0)
   li $t5,0 #indice de mem pt vectorul nr
   loop_4:
   beqz $t1,out #daca am terminat cuvantul, atunci out
   #cautare litera in alfabet
   li $t2,0 #t2=0
   lb $t3,alfabet($t2) #t3=alfabet[t2]
   loop_5:
   beqz $t3,out_2 #nu o sa se ajunga in out_2
   beq $t1,$t3,stocare #daca am gasit litera in alfabet
   addi $t2,$t2,1 #t2+=1
   lb $t3,alfabet($t2)#t3=alfabet[t2]
   j loop_5
   stocare:
   sw $t2, nr($t5) #nr[t5/4]=t2
   addi $t5,$t5,4 #crestem indicele de mem din 4 in 4  (4 bytes)
   addi $t0,$t0,1 #crestem indicele de mem din 1 in 1 (1 byte)
   lb $t1,str($t0) #t1=str[t0]
   j loop_4 #jum to loop_4
   out_2:
   #
   out:
   #aici vectorul nr este format, trebuie trasnformat prin izomorfism
   li $t1,0 #i
   li $t2,0 #indice memorie nr
   li $t3,0 #indice memorie nr_updated
   loop_6:
   bge $t1,$t0,transformare_nr_updated #daca $t1>=$t0, merge la label-ul transformare_nr_updated
   lw $t4,nr($t2) #t4=nr[t2/4]
   mul $t4,$t4,4 #t4*=4
   lw $t5,v($t4) #t5=v[t4/4]
   sw $t5,nr_updated($t3) #nr_updated[t3/4]=t5
   addi $t1,$t1,1 #t1+=1 (i++)
   addi $t2,$t2,4 #t2+=4 
   addi $t3,$t3,4 #t3+=4
   j loop_6 #jump to loop_4
   transformare_nr_updated:
   #avem vectorul nr_updated format, mai trebuie sa il transformam in string
   li $t1,0 #i=0
   li $t2,0 #pt vector 
   li $t3,0 #pt string
   loop_7:
   bge $t1,$t0,afis_str_updated #daca $t1>=$t0, merge la label_ul afis_nr_updated
   lw $t4,nr_updated($t2) #t4=nr_updated[t2/4]
   lb $t5,alfabet($t4) #t5=alfabet[t4]
   sb $t5,str_updated($t3) # str_updated[t3]=t5
   addi $t1,$t1,1 #t1+=1
   addi $t2,$t2,4 #t2+=4 (4 bytes)
   addi $t3,$t3,1 #t3==1 (1 byte)
   j loop_7 #jump to loop_7
   afis_str_updated:
   la $a0,str_updated #incarcam in a0 adresa stringului str_updated
   li $v0,4 #cod apel print string
   syscall
   la $a0,msj3 #incarcam in a0 adresa stringului msj3
   li $v0,4 #cod pt print string
   syscall
   #------decriptare
   #read str2:
   la $a0,str2 #incarcam in a0 adresa in care vrem sa stocam 
   li $a1,99 #in a1 incarcam lungimea maxima 
   li $v0,8 #8=cod pt read sstring
   syscall
   #parcurgere str2 litera cu litera
   li $t0,0 #indice memorie pt str2
   lb $t1,str2($t0) #t1=str2[t0]
   li $t5,0 #indice de mem pt vectorul nr2
   loop_8:
   beqz $t1,out_3 #daca am terminat cuvantul, atunci out
   #cautare litera in alfabet
   li $t2,0 #t2=0
   lb $t3,alfabet($t2) #t3=alfabet[t2]
   loop_9:
   beqz $t3,out_4 #nu o sa se ajunga in out_2
   beq $t1,$t3,stocare_2 #daca am gasit litera in alfabet
   addi $t2,$t2,1 #t2+=1 (1 byte)
   lb $t3,alfabet($t2) #t3=alfabet[t2]
   j loop_9 #jump to loop_9
   stocare_2:
   sw $t2, nr2($t5) #nr2[t5/4]=t2
   addi $t5,$t5,4 #t5+=4 (4 bytes)
   addi $t0,$t0,1 #t0++
   lb $t1,str2($t0) #t1=str2[t0]
   j loop_8 #jump to loop_8
   out_4:
   #
   out_3:
   #aici vectorul nr2 este format(CORECT), trebuie construit nr2_updated 
   li $t1,0 #i
   li $t2,0 #indice memorie nr2 si nr2_updated
   loop_10:
   bge $t1,$t0,transformare_nr2_updated #pt fiecare numar din nr_2
   lw $t3,nr2($t2) #t3=nr2[t2/4]
   #il cautam pe $t3 in v
   li $t4,0#i
   li $t5,0#indice memorie pt v
   lw $t6,p#t6=p
   loop_12:
   bge $t4,$t6,out_5 #pt fiecare nr din v ;(nu o sa se ajunga in out_5)
   lw $t7,v($t5)#t7=v[t5/4]
   beq $t7,$t3,formare#daca l-am gasit pe t4 in v, ii adaugam indicele la nr2_updated
   #daca nu l-am gasit:
   addi $t4,$t4,1 #t4+=1
   addi $t5,$t5,4 #t5+=4
   j loop_12 #jump to loop_12
   out_5:
   la $a0, unknown #incarcam in a0 adresa stringului unknown
   li $v0,4 #cod print string
   syscall
   li $v0,10 #cod exit
   syscall
   formare:
   li $t7,4 #constanta 4
   div $t5,$t7 #t5/t7
   mflo $t5 #mutam din valoarea din lo (catul impartirii lui t5 la t7) in t5
   sw $t5,nr2_updated($t2) #nr2_updated[t2/4]=t5
   addi $t2,$t2,4 #t2+=4 (4 bytes)
   addi $t1,$t1,1 #t1+=1
   j loop_10 #jump to loop_10
   transformare_nr2_updated:
   #avem vectorul nr2_updated format, mai trebuie sa il transformam in string
   li $t1,0 #i=0
   li $t2,0#pt vector 
   li $t3,0#pt string
   loop_11:
   bge $t1,$t0,afis_str2_updated #daca t1>=t0, atunci merge la label-ul afis_str2_updated
   lw $t4,nr2_updated($t2) #t4=nr2_updated[t2/4]
   lb $t5,alfabet($t4) #t5=alfabet[t4]
   sb $t5,str2_updated($t3) #str+updated[t3]=t5
   addi $t1,$t1,1 #i++
   addi $t2,$t2,4 #t2+=4 (4 bytes)
   addi $t3,$t3,1 #t3+=1 (1 byte)
   j loop_11 #jump to loop_11
   afis_str2_updated:
   la $a0,str2_updated #incarcam in a0 adresa stringului str2_updated
   li $v0,4 #cod sistem pt print string
   syscall
   li $v0,10 #cod sistem pt exit
   syscall
   label_1:
   la $a0,test #incarcam in a0 adresa stringului test
   li $v0,4 #cod sistem print string
   syscall
   li $v0,10#cod sistem pt exit
   syscall
