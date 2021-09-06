import math
import copy


# informatii despre un nod din arborele de parcurgere (nu din graful initial)
class NodParcurgere:
    gr = None  # trebuie setat sa contina instanta problemei

    def __init__(self, info, parinte, cost=0, h=0):
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.g = cost  # consider cost=1 pentru o mutare
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
            print(str(nod))
        if afisCost:
            print("Cost: ", self.g)
        if afisLung:
            print("Lungime: ", len(l))
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
        for linie in self.info:
            sir += " ".join(linie) + "\n"
        return sir

    def __str__(self):
        sir = ""
        for linie in self.info:
            sir += " ".join(linie) + "\n"
        return sir


def cautaPozElemMatr(matr, elemCautat):
    for i, linie in enumerate(matr):
        for j, elem in enumerate(linie):
            if elem == elemCautat:
                return i, j
    return -1


class Graph:  # graful problemei
    def __init__(self, nume_fisier):

        f = open(nume_fisier, "r")
        textFisier = f.read()
        listaSiruriLinii = textFisier.strip().split("\n")  # ["1 2 3","4 5 6","7 0 8"]

        self.start = []
        for linie in listaSiruriLinii:
            self.start.append(linie.strip().split(" "))
        self.scopuri = [[["1", "2", "3"], ["4", "5", "6"], ["7", "8", "0"]]]
        print(self.start)

    def testeaza_scop(self, nodCurent):
        return nodCurent.info in self.scopuri

    def verificaExistentaSolutie(self, infoNod):
        """Returneaza True sau False daca starea data de infoNod corespunde
        unui joc care poate fi rezolvat.

        1 2 3
        4 5 8
        0 6 7

        Ne formam permutarea celor 8 placute citite de sus in jos si de st la dr:
        1 2 3 4 5 8 6 7

        Existenta solutiei depinde de paritatea nr. de inversiuni ale permutarii.
        """
        listaMatr = []
        for linie in infoNod:
            listaMatr.extend(linie)
        listaMatr.remove("0")
        nrInversiuni = 0
        for i, placuta_i in enumerate(listaMatr):
            for placuta_j in listaMatr[i + 1:]:
                if placuta_i > placuta_j:
                    nrInversiuni += 1
        if nrInversiuni % 2 == 1:
            return False
        else:
            return True

    def genereazaSuccesori(self, nodCurent, tip_euristica="euristica banala"):
        listaSuccesori = []
        # lista de directii pentru sus, jos, stanga, dreapta
        directii = [[-1, 0], [1, 0], [0, -1], [0, 1]]
        # caut gol
        linieGol, coloanaGol = cautaPozElemMatr(nodCurent.info, "0")
        for dl, dc in directii:
            linieVecin = linieGol + dl
            coloanaVecin = coloanaGol + dc
            try:
                if linieVecin < 0 or coloanaVecin < 0:
                    continue
                infoNodNou = copy.deepcopy(nodCurent.info)
                infoNodNou[linieGol][coloanaGol] = infoNodNou[linieVecin][coloanaVecin]
                infoNodNou[linieVecin][coloanaVecin] = "0"
                if not nodCurent.contineInDrum(infoNodNou):
                    listaSuccesori.append(
                        NodParcurgere(
                            infoNodNou,
                            nodCurent,
                            nodCurent.g + 1,
                            self.calculeaza_h(infoNodNou, tip_euristica),
                        )
                    )
            except IndexError:
                pass
        return listaSuccesori

    # euristica banala
    def calculeaza_h(self, infoNod, tip_euristica="euristica banala"):
        if tip_euristica == "euristica banala":
            if infoNod not in self.scopuri:
                return 1
            return 0
        else:
            # calculam pentru fiecare piesa diferita de 0 (gol) distanta
            # Manhattan pana la pozitia sa din scop
            best_h = float("inf")
            for scop in self.scopuri:
                h = 0
                for i, linie in enumerate(infoNod):
                    for j, elem in enumerate(linie):
                        if elem == "0":
                            continue
                        scop_i, scop_j = cautaPozElemMatr(scop, elem)
                        h += abs(i - scop_i) + abs(j - scop_j)
                best_h = min(best_h, h)
            return best_h

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return sir


def a_star(gr, nrSolutiiCautate, tip_euristica):
    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)

    if not gr.verificaExistentaSolutie(gr.start):
        print("Nu avem solutii")
        return

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
            while i < len(c):
                if c[i].f >= s.f:
                    break
                i += 1
            c.insert(i, s)


gr = Graph("8puzzle.txt")
NodParcurgere.gr = gr

print("\n\n##################\nSolutii obtinute cu A*:")
nrSolutiiCautate = 3
a_star(gr, nrSolutiiCautate=nrSolutiiCautate, tip_euristica="euristica nebanala")