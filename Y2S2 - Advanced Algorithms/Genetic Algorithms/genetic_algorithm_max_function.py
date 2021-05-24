import random
import math
import numpy as np  # am folosit doar argmax, desi pentru optimizare putem folosi np arrays in loc de liste

input_file = open('input.txt', 'r')
coef = [float(i) for i in input_file.readline().split()]  # coeficientii ecuatiei de gradul 2
def f(x):
    return coef[0]*x**3 + coef[1]*x**2 + coef[2]*x + coef[3]

line = input_file.readline().split()
# a, b = capetele intervalului
a, b = float(line[0]), float(line[1])
dimensiune_populatie = int(input_file.readline())
precizie = int(input_file.readline())
probabilitate_recombinare = float(input_file.readline())
probabilitate_mutatie = float(input_file.readline())
etape = int(input_file.readline())

# ---------------------------------------------------------------------------------------

file = open('evolutie.txt', 'w')

lungime_cromozom = math.ceil(math.log((b-a)*(10**precizie), 2))
# lungimea unui cromozom = nr de biti necesari pt reprezentarea numerelor
# = ceil(log2((b-a)*10^precizie))


def to_binary(integer):
    format_string = "0"+str(lungime_cromozom)+"b"
    return format(integer, format_string)  # returnam numarul generat in binar pe lungime_cromozom biti


def decode(binar):
    natural = int(binar, 2)  # convertim din binar in int
    valoare = natural*(b-a)/(2**lungime_cromozom - 1) + a
    # transformam numarul natural in valoarea reala corespunzatoare
    return valoare


def populatia_initiala():
    file.write("Populatia initiala:\n")
    populatie_init = []
    for i in range(dimensiune_populatie):
        rand = random.getrandbits(lungime_cromozom)  # generam un numar pe lungime_cromozom biti
        cromozom = to_binary(rand)
        x = decode(cromozom)  # numarul real generat pe intervalul [a,b) cu precizie p
        file.write(f'{i+1}: {cromozom} x = {x} f = {f(x)}\n')
        populatie_init.append(cromozom)
    file.write('\n')
    return populatie_init


def probabilitati_selectie(pop):
    if iteratie == 0:
        file.write("Probabilitati selectie:\n")
    fitness = [f(decode(i)) for i in pop]
    # fitness ul fiecarui cromozom (mai intai trebuie decodat pentru ca e in binar)
    # fitness ul este chiar functia f
    suma = sum(fitness)  # suma tutoror fitness urilor
    probabilitati = []
    for i in range(dimensiune_populatie):
        prob = fitness[i]/suma  # probabilitatea de selectie a fiecarui cromozom
        if iteratie == 0:
            file.write(f'cromozom {i+1} probabilitate {prob}\n')
        probabilitati.append(prob)
    if iteratie == 0:
        file.write('\n')
    return probabilitati, fitness


def intervale_selectie(probabilitati):
    intervale = [0]
    if iteratie == 0:
        file.write("Intervale probabilitati selectie:\n0\n")
    for p in probabilitati[:len(probabilitati)-1]:  # nu luam si ultimul element, am explicat de ce mai jos
        new = intervale[-1] + p
        if iteratie == 0:
            file.write(f"{new}\n")
        intervale.append(new)
    intervale.append(1)  # suma tuturor fitness urilor desi tinde la 1 nu da mereu 1 (pb de precizie)
    # si pentru a evita un posibil bug la pasul urmator (de ex sa se genereze un numar din afara oricarui interval)
    # il adugam explicit
    if iteratie == 0:
        file.write(f"1\n\n")
    return intervale


def selectie(interval_selectie, fitness, populatie_veche):
    elitist = np.argmax(fitness) + 1  # cromozomul elitist e cel cu functia de fitness cea mai mare
    # +1 deoarece cromozomii sunt indexati de la 1
    selected = [elitist]  # cromozomul elitist intra mereu in selectie
    if iteratie == 0:
        file.write(f'Selectie:\nCromozomul elitist: {elitist}\n')

    # facem selectie de tip ruleta pentru celelalte n-1 locuri
    # (la aceasta selectie intra si cromozomul elitist)
    for i in range(dimensiune_populatie-1):
        u = random.random()  # generam o var uniforma pe [0,1)
        cromozom = binary_search(interval_selectie, 0, len(interval_selectie), u) + 1
        selected.append(cromozom)
        if iteratie == 0:
            file.write(f'u = {u} selectam cromozomul {cromozom}\n')

    # avem in selected indicii cromozomilor selectati
    # trebuie sa construim populatia noua
    if iteratie == 0:
        file.write('\nDupa selectie:\n')
    populatie_selectata = [0]*dimensiune_populatie
    for i, cromozom in enumerate(selected):
        cromozom_nou = populatie_veche[cromozom-1]  # il luam din populatia veche
        populatie_selectata[i] = cromozom_nou  # il punem in cea noua
        if iteratie == 0:
            valoare_cromozom_nou = decode(cromozom_nou)  # il decodam pentru a lua valoarea
            fitness_cromozom_nou = fitness[cromozom - 1]  # ii aflam si functia de fitness
            file.write(f'{i+1}: {cromozom_nou} x = {valoare_cromozom_nou} f = {fitness_cromozom_nou}\n')

    return populatie_selectata


def binary_search(v, p, q, x):
    # cautare binara unde v e vectorul intervalelor de selectie
    # deci ne oprim cand ne-am incadrat intr-un singur interval (adica q-p=1)
    if q-p == 1:
        return p
    else:
        mid = (p+q)//2
        if x > v[mid]:
            return binary_search(v, mid, q, x)
        else:
            return binary_search(v, p, mid, x)


def probabilitate_incrucisare(pop):
    if iteratie == 0:
        file.write(f'\nProbabilitatea de incrucisare {probabilitate_recombinare}\n')
        file.write(f'1: {pop[0]} - cromozomul elitist, nu intra la incrucisare\n')
    indici_recombinare = []  # indicii cromozomilor alesi pentru recombinare
    for i in range(1, dimensiune_populatie):
        # cromozomul elitist am ales sa nu intre la recombinare, de aceea incepem de la 1
        # el poate totusi aparea la recombinare deoarece mai poate aparea ca rezultat
        # al selectiei de tip ruleta, el avand probabilitatea cea mai mare
        u = random.random()
        if u < probabilitate_recombinare:
            indici_recombinare.append(i+1)
            if iteratie == 0:
                file.write(f'{i+1}: {pop[i]} u = {u} < {probabilitate_recombinare} participa\n')
        else:
            if iteratie == 0:
                file.write(f'{i+1}: {pop[i]} u = {u}\n')
    if iteratie == 0:
        file.write('\n')
    return indici_recombinare


def incrucisare(pop, indici):
    # avem indicii cromozomilor ce intra la recombinare (indici incepand de la 1)
    # trebuie sa le dam shuffle
    random.shuffle(indici)
    if len(indici) >= 2:  # daca avem 0 sau un singur cromozom pentru incrucisare nu facem nimic
        if len(indici) % 2 == 1:  # daca avem numar impar de cromozomi, pe ultimii 3 ii incrucisam intre ei
            for i in range(0, len(indici) - 4, 2):  # primii n-3 cromozomi ii luam doi cate doi
                # trebuie sa generam un break point random intre 0 si lungimea cromozomului
                br_point = random.randint(0, lungime_cromozom)
                cromozom1 = pop[indici[i] - 1]  # luam cromozomul din populatie, conform indicelui
                cromozom2 = pop[indici[i+1] - 1]
                new_cromozom1 = cromozom1[:br_point] + cromozom2[br_point:]
                new_cromozom2 = cromozom2[:br_point] + cromozom1[br_point:]
                # ii reintroducem in populatie:
                pop[indici[i] - 1] = new_cromozom1
                pop[indici[i+1] - 1] = new_cromozom2
                if iteratie == 0:
                    file.write(f'Recombinare dintre cromozomul {indici[i]} cu cromozomul {indici[i+1]}:\n')
                    file.write(f'{cromozom1} {cromozom2} punct {br_point}\n')
                    file.write(f'Rezultat {new_cromozom1} {new_cromozom2}\n')
            # pe ultimii 3 ii luam manual:
            n = len(indici)
            cromozom1 = pop[indici[n-1]-1]
            cromozom2 = pop[indici[n-2]-1]
            cromozom3 = pop[indici[n-3]-1]
            br_point = random.randint(0, lungime_cromozom)
            new_cromozom1 = cromozom1[:br_point] + cromozom2[br_point:]
            new_cromozom2 = cromozom2[:br_point] + cromozom3[br_point:]
            new_cromozom3 = cromozom3[:br_point] + cromozom1[br_point:]
            # ii reintroducem in populatie:
            pop[indici[n-1]-1] = new_cromozom1
            pop[indici[n-2]-1] = new_cromozom2
            pop[indici[n-3]-1] = new_cromozom3
            if iteratie == 0:
                file.write(f'Recombinare dintre cromozomii {indici[n-1]}, {indici[n-2]}, {indici[n-3]}:\n')
                file.write(f'{cromozom1} {cromozom2} {cromozom3} punct {br_point}\n')
                file.write(f'Rezultat {new_cromozom1} {new_cromozom2} {new_cromozom3}\n')
        else:  # luam doi cate doi
            for i in range(0, len(indici) - 1, 2):
                # trebuie sa generam un break point random intre 0 si lungimea cromozomului
                br_point = random.randint(0, lungime_cromozom)
                cromozom1 = pop[indici[i] - 1]  # luam cromozomul din populatie, conform indicelui
                cromozom2 = pop[indici[i+1] - 1]
                new_cromozom1 = cromozom1[:br_point] + cromozom2[br_point:]
                new_cromozom2 = cromozom2[:br_point] + cromozom1[br_point:]
                # ii reintroducem in populatie:
                pop[indici[i] - 1] = new_cromozom1
                pop[indici[i+1] - 1] = new_cromozom2
                if iteratie == 0:
                    file.write(f'Recombinare dintre cromozomul {indici[i]} cu cromozomul {indici[i+1]}:\n')
                    file.write(f'{cromozom1} {cromozom2} punct {br_point}\n')
                    file.write(f'Rezultat {new_cromozom1} {new_cromozom2}\n')
    if iteratie == 0:
        file.write('\n')


def print_populatie(pop):
    # afiseaza cromozomul, x si f(x)
    x = [decode(i) for i in pop]
    fitness = [f(i) for i in x]
    for i in range(len(pop)):
        file.write(f'{i+1}: {pop[i]} x = {x[i]} f = {fitness[i]}\n')


def mutatie(pop):
    mutated = set()  # am folosit set pt ca un cromozom poate avea mai multe mutatii (pe mai multe gene)
    # pentru fiecare gena a fiecarui cromozom, generam o val uniforma u pe [0,1)
    # daca u < probabilitate_mutatie, atunci gena respectiva sufera o mutatie (o trecem la complement)
    # dupa ce terminam cu un cromozom, il actualizam in populatie
    for i, cromozom in enumerate(pop):
        cromozom_nou = ""
        for j, bit in enumerate(cromozom):
            u = random.random()  # generam o val uniforma pe [0,1) pentru fiecare bit
            if u < probabilitate_mutatie:  # daca bitul respectiv (adica gena) a fost selectat pt mutatie, il inversam
                mutated.add(i+1)
                if bit == '0':
                    cromozom_nou += '1'
                else:
                    cromozom_nou += '0'
            else:  # daca nu a fost selectat, ramane la fel
                cromozom_nou += bit
        pop[i] = cromozom_nou

    if iteratie == 0:
        file.write(f'\nProbabilitate de mutatie pentru fiecare gena {probabilitate_mutatie}\n')
        if len(mutated) > 0:
            file.write('Au fost modificati cromozomii:\n')
            for x in mutated:
                file.write(f'{x}\n')
        else:
            file.write('Cromozomii nu au fost modificati\n')
        file.write('\n')


def maxim_si_medie(pop):
    # calculeaza fitness-ul maxim din populatie
    fitness = [f(decode(i)) for i in pop]
    best_x = decode(pop[np.argmax(fitness)])
    return max(fitness), sum(fitness)/dimensiune_populatie, best_x


populatie = populatia_initiala()
for iteratie in range(etape):
    prob_selectie, fit = probabilitati_selectie(populatie)  # probabilitatea de selectie a fiecarui cromozom
    interv_selectie = intervale_selectie(prob_selectie)  # intervalul de selectie al fiecarui cromozom
    populatie = selectie(interv_selectie, fit, populatie)  # selectie de tip elitist + ruleta
    indici_incrucisare = probabilitate_incrucisare(populatie)  # aflam ce cromozomi intra la crossover
    incrucisare(populatie, indici_incrucisare)  # facem crossover
    if iteratie == 0:
        file.write('\nDupa recombinare:\n')
        print_populatie(populatie)
    mutatie(populatie)  # facem mutatia
    if iteratie == 0:
        file.write('Dupa mutatie:\n')
        print_populatie(populatie)
        file.write('\nEvolutia fitness-ului:\n')
    maxim, medie, best = maxim_si_medie(populatie)
    file.write(f'media: {medie}, maxim: {maxim}, x_maxim: {best}\n')
    # la fiecare pas calculam fitness-ul maxim si mediu din populatie si valoarea pentru care s-a obtinut f maxim
    # OBS: FUNCTIA DATA TREBUIE SA FIE POZITIVA PE TOT INTERVALUL, altfel se vor genera probabilitati negative
