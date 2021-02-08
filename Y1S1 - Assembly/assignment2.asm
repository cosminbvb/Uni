.data
vector:.word 3 6 7 0 8 9 13 -2 54 43
n:.word 10
space:.asciiz " "
.text
main:
#incarcam n pe stiva:
lw $t0,n
subu $sp,$sp,4
sw $t0,0($sp)
#incarcam adresa de start a lui v pe stiva:
la $t0,vector
subu $sp,$sp,4
sw $t0,0($sp)
jal modifica #apelam modifica
addu $sp,$sp,8 #eliberam spatiul de pe stiva
#afisare vector:
li $t0,1 #i=1
lw $t1,n
li $t2,0 #indice pt vector
loop_afis:
bgt $t0,$t1,close #daca t0>t1 => close
lw $a0,vector($t2) #afisam elementul
li $v0,1
syscall
la $a0,space #afisam spatiu
li $v0,4
syscall
addi $t0,$t0,1 # i++
addi $t2,$t2,4 # crestem indicele de mem cu 4
j loop_afis
close:
li $v0,10
syscall
modifica:
subu $sp,$sp,4
sw $fp,0($sp) 
addi $fp,$sp,4 # $sp:($fp v)$fp:(vector)(n)
subu $sp,$sp,4
sw $ra,0($sp) # $sp:($ra v)($fp v)$fp:(vector)(n)
subu $sp,$sp,4
sw $s0,0($sp)
subu $sp,$sp,4
sw $s1,0($sp) # $sp:($s1)($s0)($ra v)($fp v)$fp:(vector)(n)
lw $s0,0($fp) # s0<-adresa de inc a lui v
lw $s1,4($fp) # s1<-n
beqz $s1,exit  # daca n==0 => exit ( while $s1!=0: ...)
lw $t0,0($s0) # t0 <- primul element
# aici undeva trebuie pusa o conditie: trebuie modificate doar elementele >0
blez $t0,nu_modifica # daca $t0<=0 => nu_modifica
#-- modificam $t0:
subu $sp,$sp,4
sw $t0,0($sp)
li $v0,0
jal suma_patrate
addu $sp,$sp,4
sw $v0,0($s0) # primul element <- t0
#--
nu_modifica:
addi $s0,$s0,4 # crestem cu 4 adresa de start a vectorului
addi $s1,$s1,-1 # n--
subu $sp,$sp,4
sw $s1,0($sp) # punem noul s1 pe stiva
subu $sp,$sp,4
sw $s0,0($sp) # punem noul s0 pe stiva
jal modifica # apelam functia cu argumentele s1 si s0
addu $sp,$sp,8 # eliberam spatiu de pe stiva
exit: # restauram cadrul de apel:
lw $s1,-16($fp)
lw $s0,-12($fp)
lw $ra,-8($fp)
lw $fp,-4($fp)
addu $sp,$sp,16 #eliberam spatiu de pe stiva
jr $ra
suma_patrate: # suma_patrate(x)=(x-1)^2+suma_patrate(x-1) daca x>=1 ; 0 altfel
subu $sp,$sp,4
sw $fp,0($sp) 
addi $fp,$sp,4
subu $sp,$sp,4
sw $ra,0($sp) 
subu $sp,$sp,4
sw $s0,0($sp) # $sp:($s0)($ra v)($fp v)$fp:($t0)
lw $s0,0($fp) # s0<-x
beqz $s0,exit_2 # daca $s0 (adica x) ==0 atunci exit_2
#--
addi $s0,$s0,-1 # $s0--
mul $t1,$s0,$s0
add $v0,$v0,$t1
subu $sp,$sp,4 
sw $s0,0($sp)  # incarcam noul s0 pe stiva si devine argument la urmatoarea apelare
jal suma_patrate
addu $sp,$sp,4
exit_2:
#restauram cadrul de apel:
lw $s0,-12($fp)
lw $ra,-8($fp)
lw $fp,-4($fp)
addu $sp,$sp,12
jr $ra
