"""
TEMA OPTIONALA PANA LA URMATORUL LABORATOR (PT. BONUS)
------------------------------------------------------

Implementati o alta euristica admisibila (explicati in comentarii ce calculati si de ce este admisibila).

Aplicati algoritmul IDA* pentru determinarea solutiilor.
"""
import math


# informatii despre un nod din arborele de parcurgere (nu din graful initial)
class NodParcurgere:
    gr = None  # trebuie setat sa contina instanta problemei

    def __init__(self, info, parinte, cost=0, h=0):
        # info = (canibali pe malul init, misionari pe malul init, poz. barca)
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.g = cost
        self.h = h
        self.f = self.g + self.h

    def obtineDrum(self):
        l = [self]
        nod = self
        while nod.parinte is not None:
            l.insert(0, nod.parinte)
            nod = nod.parinte
        return l

    def afisDrum(
        self, afisCost=False, afisLung=False
    ):  # returneaza si lungimea drumului
        l = self.obtineDrum()
        for nod in l:
            if nod.parinte is not None:
                if nod.parinte.info[2] == 1:
                    mbarca1 = self.__class__.gr.malInitial
                    mbarca2 = self.__class__.gr.malFinal
                else:
                    mbarca1 = self.__class__.gr.malFinal
                    mbarca2 = self.__class__.gr.malInitial
                print(
                    ">>> Barca s-a deplasat de la malul {} la malul {} cu {} oameni.".format(
                        mbarca1,
                        mbarca2,
                        abs(
                            nod.info[0]
                            + nod.info[1]
                            - nod.parinte.info[0]
                            - nod.parinte.info[1]
                        ),
                    )
                )
            print(str(nod))
        if afisCost:
            print("Cost: ", self.g)
        if afisCost:
            print("Nr noduri: ", len(l))
        return len(l)

    def contineInDrum(self, infoNodNou):
        nodDrum = self
        while nodDrum is not None:
            if infoNodNou == nodDrum.info:
                return True
            nodDrum = nodDrum.parinte

        return False

    def __repr__(self):
        sir = ""
        sir += str(self.info)
        return sir

    def __str__(self):
        if self.info[2] == 1:
            barcaMalInitial = "<barca>"
            barcaMalFinal = "       "
        else:
            barcaMalInitial = "       "
            barcaMalFinal = "<barca>"
        return (
            "Mal: "
            + self.gr.malInitial
            + " Canibali: {} Misionari: {} {}  |||  Mal:"
            + self.gr.malFinal
            + " Canibali: {} Misionari: {} {}"
        ).format(
            self.info[0],
            self.info[1],
            barcaMalInitial,
            self.__class__.gr.N - self.info[0],
            self.__class__.gr.N - self.info[1],
            barcaMalFinal,
        )


class Graph:  # graful problemei
    def __init__(self, nume_fisier):
        """
        (CanibaliMalInitial, MisionariMalInitial, MalBarca)
        MalBarca = 1 daca e pe malul initial si 0 daca e pe malul final
        """
        f = open(nume_fisier, "r")
        continutFisier = f.read()
        infoFisier = continutFisier.split()
        self.N = int(infoFisier[0])
        self.M = int(infoFisier[1])
        self.malInitial = infoFisier[2]
        self.malFinal = infoFisier[3]
        self.start = (self.N, self.N, 1)
        self.scopuri = [(0, 0, 0)]

    def testeaza_scop(self, nodCurent):
        return nodCurent.info in self.scopuri

    # va genera succesorii sub forma de noduri in arborele de parcurgere

    """
    def genereazaSuccesori(self, nodCurent, tip_euristica="euristica banala"):

        #functie ajutatoare pentru a nu duplica codul
        def adaugaUnSuccesor(graf,nodCurent,listaSuccesori,canBarca,misBarca,bOpus, tip_euristica):
            infoNodNou=(nodCurent.info[0]+operatie*canBarca, nodCurent.info[1]+operatie*misBarca,bOpus)
            if not nodCurent.contineInDrum(infoNodNou):
                costSuccesor=canBarca*2+misBarca # presupunem ca mutarea unui canibal costa de 2 ori mai mult
                listaSuccesori.append(NodParcurgere( infoNodNou , parinte=nodCurent, cost=nodCurent.g+costSuccesor, h=graf.calculeaza_h(infoNodNou, tip_euristica)))

        listaSuccesori=[]
        if nodCurent.info[2]==1:
            canMalCurent=nodCurent.info[0]
            misMalCurent=nodCurent.info[1]
            operatie=-1
        else:
            operatie=1
            canMalCurent=self.N-nodCurent.info[0]
            misMalCurent=self.N-nodCurent.info[1]

        bOpus=1-nodCurent.info[2]


        #Voi incerca sa generez numerele de misionari si canibali care pleaca cu barca, cat mai eficient, astfel incat sa nu generez perechi care nu ar verifica conditia din enunt.

        #Observatie: daca am si misionari si canibali  pe un mal, atunci, pe acel mal:
        #- ori sunt toti misionarii si canibali pot fi oricati
        #- ori numarul de misionari e egal cu numarul de canibali

        #daca am avea si misionari si canibali (deci numarul lor diferit de 0) pe ambele maluri si nu ar fi in numar egal, presupunem ca M1 si C1 sunt pe malul 1
        conditia cere M1>=C1 si cum am zis ca testam ce se intampla cand nu sunt in numar egal, presupunem M1>C1 (strict)
        atunci avem pe celalalt mal N-M1 si N-C1 dar pentru care e adevarat ca N-M1<N-C1 deci nu indeplineste conditia


        #generez intai toti succesorii pentru canibali cand numarul de misionari este 0

        #canibalii pot pleca singuri doar daca toti misionarii sunt pe un singur mal, altfel daca avem M1 misionari pe primul mal, respectiv M2 misionari pe al doilea mal, ca sa avem echilibru, obligatoriu avem tot M1 si M2 canibali, iar la mutarea unui grup de canibali pe un mal nu se va mai indeplini conditia
        if misMalCurent==0:
            #pleaca 0 misionari si oricati canibali
            for can in range(1, min(self.M, canMalCurent)+1):
                    adaugaUnSuccesor(self,nodCurent,listaSuccesori,can,0,bOpus, tip_euristica)
        else:
            #singurul caz in care pot pleca doar canibali daca exista si misionari pe malul curent este cand toti misionarii sunt pe malul curent
            if misMalCurent==self.N:
                for can in range(1, min(self.M, canMalCurent)+1):
                    adaugaUnSuccesor(self,nodCurent,listaSuccesori,can,0,bOpus,tip_euristica)

            #pot pleca toti misionarii gramada + canibali cat mai incap in barca
            if misMalCurent<=self.M:
                for can in range(0, self.M-misMalCurent+1):
                    adaugaUnSuccesor(self,nodCurent,listaSuccesori,can,misMalCurent,bOpus,tip_euristica)

            #daca nu pleaca toti misionarii, sunt restrictionati de cati canibali sunt pe malul curent si opus
            # de exemplu, pe malul curent : can:C1 mis:N   opus: can:N-C1 mis:0 atunci pot pleca doar de la N-C1 misionari incolo. Daca pleaca N-C1+K misionari, trebuie sa trimit obligatoriu si K canibali.
            #daca misionarii sunt in numar nenul, mai mic decat N pe malul curent, malurile sigur arata asa: can:X mis:X can:N-X mis: N-X si atunci pleaca in numar egal; N-C1 de mai sus ar fi X-X= 0 in cazul asta, 
            minimMisionari=min(misMalCurent-canMalCurent,misMalCurent)#nu pot pleca mai multi misionari decat am pe malul curent, dar nici mai multi decat diferenta dintre numarul de misionari si canibali pe malul curent (care reprezinta surplusul de canibali de pe malul opus). De exemplu 3m 1c | 0m 2c din stanga nu pot pleca mai putin de  2 misionari fiindca malul din dreapta nu ar mai respecta conditia
            minK=1 if minimMisionari==0 else 0#trebuie sa plece macar un misionar ca sa nu pic pe cazul de mai sus cand pleaca doar canibali
            for k in range(minK, min(canMalCurent, (self.M-minimMisionari)//2, misMalCurent-minimMisionari-1)+1):		
                #print("minK", minK, "minimMisionari", minimMisionari, "can ", k, "mis ",minimMisionari+k) #pentru debug
                adaugaUnSuccesor(self,nodCurent,listaSuccesori,k,minimMisionari+k,bOpus, tip_euristica)

        return listaSuccesori
    """

    def genereazaSuccesori(self, nodCurent, tip_euristica="euristica banala"):
        def conditie(mis, can):
            return mis == 0 or mis >= can

        listaSuccesori = []

        # malul curent este cel de pe care porneste barca

        if nodCurent.info[2] == 1:  # malul curent este malul initial
            canMalCurent = nodCurent.info[0]
            misMalCurent = nodCurent.info[1]
            canMalOpus = self.N - canMalCurent
            misMalOpus = self.N - misMalCurent
        else:
            canMalOpus = nodCurent.info[0]
            misMalOpus = nodCurent.info[1]
            canMalCurent = self.N - canMalOpus
            misMalCurent = self.N - misMalOpus

        maxMisionari = min(misMalCurent, self.M)
        for misBarca in range(maxMisionari + 1):
            if misBarca == 0:
                minCan = 1
                maxCan = min(canMalCurent, self.M)
            else:
                minCan = 0
                maxCan = min(canMalCurent, self.M - misBarca, misBarca)
            for canBarca in range(minCan, maxCan + 1):
                nouMisMalCurent = misMalCurent - misBarca
                nouCanMalCurent = canMalCurent - canBarca
                nouMisMalOpus = misMalOpus + misBarca
                nouCanMalOpus = canMalOpus + canBarca

                if not conditie(nouMisMalCurent, nouCanMalCurent):
                    continue
                if not conditie(nouMisMalOpus, nouCanMalOpus):
                    continue
                if nodCurent.info[2] == 1:  # malul curent este malul initial
                    infoNodNou = (nouCanMalCurent, nouMisMalCurent, 0)
                else:
                    infoNodNou = (nouCanMalOpus, nouMisMalOpus, 1)
                if not nodCurent.contineInDrum(infoNodNou):
                    costArc = 1
                    # costArc=2*canBarca+misBarca
                    listaSuccesori.append(
                        NodParcurgere(
                            infoNodNou,
                            nodCurent,
                            nodCurent.g + costArc,
                            self.calculeaza_h(infoNodNou, tip_euristica),
                        )
                    )
        return listaSuccesori

    # euristica banala
    def calculeaza_h(self, infoNod, tip_euristica="euristica banala"):
        if tip_euristica == "euristica banala":
            if infoNod not in self.scopuri:
                return 1
            return 0
        else:
            # calculez cati oameni mai am de mutat si impart la nr de locuri in barca
            return max(
                0,
                2 * math.ceil((infoNod[0] + infoNod[1] - 1) / (self.M - 1))
                + (1 - infoNod[2])
                - 1
            )

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return sir


def a_star(gr, nrSolutiiCautate, tip_euristica):
    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    c = [NodParcurgere(gr.start, None, 0, gr.calculeaza_h(gr.start, tip_euristica))]

    while len(c) > 0:
        nodCurent = c.pop(0)

        if gr.testeaza_scop(nodCurent):
            print("Solutie: ")
            nodCurent.afisDrum(afisCost=True, afisLung=True)
            print("\n----------------\n")
            input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent, tip_euristica=tip_euristica)
        for s in lSuccesori:
            i = 0
            gasit_loc = False
            for i in range(len(c)):
                # diferenta fata de UCS e ca ordonez dupa f
                if c[i].f >= s.f:
                    gasit_loc = True
                    break
            if gasit_loc:
                c.insert(i, s)
            else:
                c.append(s)


def a_star_eficient(gr, tip_euristica):
    c = [NodParcurgere(gr.start, None, 0, gr.calculeaza_h(gr.start, tip_euristica))]
    closed = []

    while len(c) > 0:
        nodCurent = c.pop(0)
        closed.append(nodCurent)

        if gr.testeaza_scop(nodCurent):
            print("Solutie: ")
            nodCurent.afisDrum(afisLung=True, afisCost=True)
            print("\n--------------------\n")
            return

        lSuccesori = gr.genereazaSuccesori(nodCurent, tip_euristica)
        lSuccesoriCopy = lSuccesori.copy()
        for s in lSuccesoriCopy:
            gasitOpen = False
            for elem in c:
                if s.info == elem.info:
                    gasitOpen = True
                    if s.f < elem.f:
                        c.remove(elem)
                    else:
                        lSuccesori.remove(s)
                    break
            if not gasitOpen:
                for elem in closed:
                    if s.info == elem.info:
                        if s.f < elem.f:
                            closed.remove(elem)
                        else:
                            lSuccesori.remove(s)
                        break

        for s in lSuccesori:
            i = 0
            while i < len(c):
                if c[i].f >= s.f:
                    break
                i += 1
            c.insert(i, s)

def ida_star(gr, nrSolutiiCautate, tip_euristica):
    limita = gr.calculeaza_h(gr.start, tip_euristica)
    nodStart = NodParcurgere(
        gr.start, None, 0, gr.calculeaza_h(gr.start, tip_euristica)
    )
    while True:

        # print("Limita de pornire: ", limita)
        nrSolutiiCautate, rez = construieste_drum(
            gr, nodStart, limita, nrSolutiiCautate, tip_euristica
        )
        if rez == "gata":
            break
        if rez == float("inf"):
            print("Nu exista suficiente solutii!")
            break
        limita = rez
        # print(">>> Limita noua: ", limita)
        # input()


def construieste_drum(gr, nodCurent, limita, nrSolutiiCautate, tip_euristica):
    # print("A ajuns la: ", nodCurent)
    if nodCurent.f > limita:
        return nrSolutiiCautate, nodCurent.f
    if gr.testeaza_scop(nodCurent) and nodCurent.f == limita:
        print("Solutie: ")
        nodCurent.afisDrum()
        print(limita)
        print("\n----------------\n")
        input()
        nrSolutiiCautate -= 1
        if nrSolutiiCautate == 0:
            return nrSolutiiCautate, "gata"
    lSuccesori = gr.genereazaSuccesori(nodCurent, tip_euristica)
    minim = float("inf")
    for s in lSuccesori:
        nrSolutiiCautate, rez = construieste_drum(gr, s, limita, nrSolutiiCautate, tip_euristica)
        if rez == "gata":
            return nrSolutiiCautate, "gata"
        # print("Compara ", rez, " cu ", minim)
        if rez < minim:
            minim = rez
            # print("Noul minim: ", minim)
    return nrSolutiiCautate, minim

gr = Graph("canmis.txt")
NodParcurgere.gr = gr

# print("\n\n##################\nSolutii obtinute cu A*:")
# nrSolutiiCautate = 3
# a_star(gr, nrSolutiiCautate=nrSolutiiCautate, tip_euristica="euristica banala")



# print("\n\n##################\nSolutia obtinuta cu A* eficient:")
# a_star_eficient(gr, tip_euristica="euristica nebanala")

print("\n\n##################\nSolutii obtinute cu IDA*:")
nrSolutiiCautate = 3
ida_star(gr, nrSolutiiCautate=nrSolutiiCautate, tip_euristica="euristica nebanala")
