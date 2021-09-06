import copy


# informatii despre un nod din arborele de parcurgere (nu din graful initial)
class NodParcurgere:
    def __init__(self, info, parinte):
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere

    def obtineDrum(self):
        l = [self];
        nod = self
        while nod.parinte is not None:
            l.insert(0, nod.parinte)
            nod = nod.parinte
        return l

    def afisDrum(self, afisLung=False):  # returneaza si lungimea drumului
        l = self.obtineDrum()
        for nod in l:
            print(str(nod))
        if afisLung:
            print("Lungime: ", len(l) - 1, " pasi")
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
        return (sir)

    def __str__(self):
        sir = ""
        maxInalt = max([len(stiva) for stiva in self.info])
        for inalt in range(maxInalt, 0, -1):
            for stiva in self.info:
                if len(stiva) < inalt:
                    sir += "  "
                else:
                    sir += stiva[inalt - 1] + " "
            sir += "\n"
        sir += "-" * (2 * len(self.info) - 1)
        return sir


class Graph:  # graful problemei
    def __init__(self, nume_fisier):
        f = open(nume_fisier, "r")
        continut_fisier = f.read()

        siruriStari = continut_fisier.split("stari_finale")
        self.start = self.obtineStive(siruriStari[0])

        self.scopuri = []
        siruriStariFinale = siruriStari[1].strip().split("---")
        for scop in siruriStariFinale:
            self.scopuri.append(self.obtineStive(scop))

        print("Stare initiala: ", self.start)
        print("Stari finale: ", self.scopuri)
        input()

    def obtineStive(self, sir):
        stiveSiruri = sir.strip().split("\n")
        listaStive = [sirStiva.strip().split(" ") if sirStiva != "#" else [] for sirStiva in stiveSiruri]
        return listaStive

    def testeaza_scop(self, nodCurent):
        return nodCurent.info in self.scopuri

    def genereazaSuccesori(self, nodCurent):
        listaSuccesori = []
        stive_c = nodCurent.info
        for idx in range(len(stive_c)):
            if len(stive_c[idx]) == 0:
                continue
            copie_interm = copy.deepcopy(stive_c)
            bloc = copie_interm[idx].pop()
            for j in range(len(stive_c)):
                if j == idx:
                    continue
                stive_nou = copy.deepcopy(copie_interm)
                stive_nou[j].append(bloc)
                if not nodCurent.contineInDrum(stive_nou):
                    nod_nou = NodParcurgere(stive_nou, nodCurent)
                    listaSuccesori.append(nod_nou)

        return listaSuccesori


def breadth_first(gr, nrSolutiiCautate):
    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    c = [NodParcurgere(gr.start, None)]

    while len(c) > 0:
        # print("Coada actuala: " + str(c))
        # input()
        nodCurent = c.pop(0)

        if gr.testeaza_scop(nodCurent):
            print("Solutie:")
            nodCurent.afisDrum(afisLung=True)
            print("\n----------------\n")
            input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent)
        c.extend(lSuccesori)


def depth_first_iterativ(gr, adMaxima, nrSolutiiCautate=1):
    for i in range(1, adMaxima + 1):
        if nrSolutiiCautate == 0:
            return
        print("**************\nAdancime maxima: ", i)
        nrSolutiiCautate = dfi(
            NodParcurgere(gr.start, None),
            i,
            nrSolutiiCautate,
        )


def dfi(nodCurent, adancime, nrSolutiiCautate):
    if adancime == 1 and gr.testeaza_scop(nodCurent):
        print("Solutie:")
        nodCurent.afisDrum(afisLung=True)
        print("\n----------------\n")
        input()
        nrSolutiiCautate -= 1
        if nrSolutiiCautate == 0:
            return 0
    if adancime > 1:
        lSuccesori = gr.genereazaSuccesori(nodCurent)
        for sc in lSuccesori:
            if nrSolutiiCautate != 0:
                nrSolutiiCautate = dfi(sc, adancime - 1, nrSolutiiCautate)
    return nrSolutiiCautate


gr = Graph("input.txt")

# OBS - ENTER pentru progres
print("\n\n##################\nSolutii obtinute cu BF:")
print("\nObservatie: stivele sunt afisate pe orizontala, cu baza la stanga si varful la dreapta.")
breadth_first(gr, nrSolutiiCautate=4)
# depth_first_iterativ(gr, adMaxima=10, nrSolutiiCautate=4)
