# informatii despre un nod din arborele de parcurgere (nu din graful initial)
class NodParcurgere:
    graf = None  # static

    def __init__(self, id, info, parinte, cost, h):
        self.id = id  # este indicele din vectorul de noduri
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.g = cost  # costul de la radacina la nodul curent
        self.h = h  # distanta estimata de la nodul curent pana la nodul final
        self.f = self.g + self.h

    def obtineDrum(self):
        l = [self.info]
        nod = self
        while nod.parinte is not None:
            l.insert(0, nod.parinte.info)
            nod = nod.parinte
        return l

    def afisDrum(self):  # returneaza si lungimea drumului
        l = self.obtineDrum()
        print(("->").join(l))
        print("Cost: ", self.g)
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
        sir += self.info + "("
        sir += "id = {}, ".format(self.id)
        sir += "drum="
        drum = self.obtineDrum()
        sir += ("->").join(drum)
        sir += " g:{}".format(self.g)
        sir += " h:{}".format(self.h)

        sir += " f:{})".format(self.f)
        return sir


class Graph:  # graful problemei
    def __init__(
            self, noduri, matriceAdiacenta, matricePonderi, start, scopuri, lista_h
    ):
        self.noduri = noduri
        self.matriceAdiacenta = matriceAdiacenta
        self.matricePonderi = matricePonderi
        self.nrNoduri = len(matriceAdiacenta)
        self.start = start
        self.scopuri = scopuri
        self.lista_h = lista_h

    def indiceNod(self, n):
        return self.noduri.index(n)

    def testeaza_scop(self, nodCurent):
        return nodCurent.info in self.scopuri

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent):
        listaSuccesori = []
        for i in range(self.nrNoduri):
            if self.matriceAdiacenta[nodCurent.id][
                i
            ] == 1 and not nodCurent.contineInDrum(self.noduri[i]):
                nodNou = NodParcurgere(
                    i,
                    self.noduri[i],
                    nodCurent,
                    nodCurent.g + self.matricePonderi[nodCurent.id][i],
                    self.calculeaza_h(self.noduri[i]),
                )
                listaSuccesori.append(nodNou)
        return listaSuccesori

    def calculeaza_h(self, infoNod):
        return self.lista_h[self.indiceNod(infoNod)]

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return sir


##############################################################################################
#                                 Initializare problema                                      #
##############################################################################################

# pozitia i din vectorul de noduri da si numarul liniei/coloanei corespunzatoare din matricea de adiacenta
noduri = ["a", "b", "c", "d", "e", "f", "g", "i", "j", "k"]

m = [
    [0, 1, 1, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
    [0, 0, 1, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 1, 0, 0],
    [0, 0, 1, 0, 1, 0, 0, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
]
mp = [
    [0, 3, 9, 7, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 4, 100, 0, 0, 0, 0],
    [0, 0, 0, 0, 10, 0, 5, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 4, 0, 0],
    [0, 0, 1, 0, 0, 10, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 7, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
]
start = "a"
scopuri = ["f"]
# exemplu de euristica banala (1 daca nu e nod scop si 0 daca este)
vect_h = [0, 10, 3, 7, 8, 0, 14, 3, 1, 2]

gr = Graph(noduri, m, mp, start, scopuri, vect_h)
NodParcurgere.graf = gr

# -----------------------------------------------------------------------------------------

# Obs importanta
# A search algorithm is said to be admissible if it is guaranteed to return an optimal solution.
# If the heuristic function used by A* is admissible, then A* is admissible.
# Ce inseamna ca euristica sa fie admisibila? - http://www.irinaciocan.ro/inteligenta_artificiala/a_star.php

# Euristica admisibila iti garanteaza ca A* iti da cele mai mici drumuri in ordine crescatoare.
# In particular, A* optimziat ti-o da pe cea mai mica doar, pentru ca am zis ca in varianta optimizata ne oprim dupa
# ce am gasit o solutie.
# -----------------------------------------------------------------------------------------


# A* pentru mai multe solutii
def a_star(gr, nrSolutiiCautate=4):
    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    c = [
        NodParcurgere(
            gr.noduri.index(gr.start), gr.start, None, 0, gr.calculeaza_h(gr.start)
        )
    ]

    while len(c) > 0:
        print("Coada actuala: " + str(c))
        input()
        nodCurent = c.pop(0)

        if gr.testeaza_scop(nodCurent):
            print("Solutie: ", end="")
            nodCurent.afisDrum()
            print("\n----------------\n")
            input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent)
        for s in lSuccesori:
            i = 0
            while i < len(c):
                # diferenta fata de UCS e ca ordonez dupa f
                if c[i].f >= s.f:
                    break
                i += 1
            c.insert(i, s)


# solutia optima A* pentru solutie unica
# pt optimizare c se poate lua ca heap dar e mai tricky la remove(nod)
def a_star_optimizat(gr):
    # coada OPEN (cu nodurile descoperite care inca nu au fost expandate)
    c = [
        NodParcurgere(
            gr.noduri.index(gr.start), gr.start, None, 0, gr.calculeaza_h(gr.start)
        )
    ]  # se pune nodul de pornire
    closed = []  # (cu nodurile descoperite si expandate)

    while len(c) > 0:
        print("Coada actuala: " + str(c))
        input()

        # se extrage primul nod din open si se pune in closed
        nodCurent = c.pop(0)
        closed.append(nodCurent)

        # test scop => oprim cautarea si afisam drumul
        if gr.testeaza_scop(nodCurent):
            print("Solutie: ", end="")
            nodCurent.afisDrum()
            print("\n--------------------\n")
            return

        lSuccesori = gr.genereazaSuccesori(nodCurent)  # generam succesorii
        lSuccesoriCopy = lSuccesori.copy()
        for s in lSuccesoriCopy:
            # pentru fiecare succesor s
            gasitOpen = False
            for elem in c:
                # pentru fiecare nod din open
                if s.info == elem.info:  # daca am gasit nodul s in open
                    gasitOpen = True
                    if s.f < elem.f:  # daca noul nod s are un f mai mic
                        c.remove(elem)  # stergem vechiul nod din open
                    else:
                        lSuccesori.remove(s)  # altfel, il stergem din lista succesorilor
                    break
            if not gasitOpen:  # daca nodul s nu se afla in open
                for elem in closed:  # il cautam in closed
                    if s.info == elem.info:
                        if s.f < elem.f:  # daca noul nod s are un f mai mic
                            closed.remove(elem)  # il stergem in closed
                        else:
                            lSuccesori.remove(s)  # altfel, il stergem din lista succesorilor
                        break

        # inseram succesorii in open pastrand coada open sortata crescator dupa f
        for s in lSuccesori:
            i = 0
            while i < len(c):
                if c[i].f >= s.f:
                    break
                i += 1
            c.insert(i, s)


# a_star(gr)
a_star_optimizat(gr)
