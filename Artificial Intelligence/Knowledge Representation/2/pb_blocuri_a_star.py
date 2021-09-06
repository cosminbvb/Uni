"""
TEMA OPTIONALA PANA LA URMATORUL LABORATOR (PT. BONUS)
------------------------------------------------------

Presupunem ca avem costul de mutare al unui bloc egal cu indicele in alfabet, cu indicii incepănd de la 1 ("a" are cost 1, "b" are cost 2, etc.) .

Folosind algoritmul A* determinati cele mai bune K (K=5) solutii pentru problema blocurilor.

Incercati alte 2 euristici pe langa euristica banala.
"""
import copy


# informatii despre un nod din arborele de parcurgere (nu din graful initial)
class NodParcurgere:
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
        if afisCost:
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
        sir += str(self.info)
        return sir

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
        """
        a x y z
        c b
        d
        ["a x y z","c b","d"]
        [["a","x","y","z"],["c","b"],["d"]]
        """
        stiveSiruri = sir.strip().split("\n")
        listaStive = [
            sirStiva.strip().split(" ") if sirStiva != "#" else []
            for sirStiva in stiveSiruri
        ]
        return listaStive

    def testeaza_scop(self, nodCurent):
        return nodCurent.info in self.scopuri

    # va genera succesorii sub forma de noduri in arborele de parcurgere

    def genereazaSuccesori(self, nodCurent, tip_euristica):
        listaSuccesori = []
        stive_c = nodCurent.info  # stivele din nodul curent
        nr_stive = len(stive_c)
        for idx in range(nr_stive):
            if len(stive_c[idx]) == 0:
                continue
            copie_interm = copy.deepcopy(stive_c)
            bloc = copie_interm[idx].pop(-1)
            for j in range(nr_stive):
                if idx == j:
                    continue
                stive_n = copy.deepcopy(copie_interm)  # lista noua de stive
                stive_n[j].append(bloc)
                costMutareBloc = 1 + ord(bloc) - ord('a')
                nod_nou = NodParcurgere(
                    stive_n,
                    nodCurent,
                    cost=nodCurent.g + costMutareBloc,
                    h=self.calculeaza_h(stive_n, tip_euristica),
                )
                if not nodCurent.contineInDrum(stive_n):
                    listaSuccesori.append(nod_nou)

        return listaSuccesori

    def calculeaza_h(self, infoNod, tip_euristica):
        if tip_euristica == "euristica_banala":
            return self.euristica_banala(infoNod, tip_euristica)
        elif tip_euristica == "euristica_admisibila_1":
            return self.euristica_admisibila_1(infoNod, tip_euristica)
        elif tip_euristica == "euristica_admisibila_2":
            return self.euristica_admisibila_2(infoNod, tip_euristica)
        else:
            raise Exception("Aceasta euristica nu este definita")

    def euristica_banala(self, infoNod, tip_euristica):
        return 0 if infoNod in self.scopuri else 1

    def euristica_admisibila_1(self, infoNod, tip_euristica):
        """Comparam configuratia infoNod cu fiecare dintre starile finale,
        numarand cate blocuri din starea curenta nu se afla la locul lor din
        starea finala. Astfel numarul de blocuri care vor trebui mutate cel putin
        o data reprezinta estimarea costului de a ajunge in acea stare finala.

        Dintre toate estimarile calculate pentru fiecare stare finala, alegem
        drept euristica estimarea minima.
        """
        estimari = [self.diferenta_stari_1(infoNod, stare_finala) for stare_finala in self.scopuri]
        return min(estimari)

    def euristica_admisibila_2(self, infoNod, tip_euristica):
        """Asemanator cu 1. De aceasta data pentru fiecare bloc care nu se
        afla la locul lui, in loc sa adunam 1 la estimare, vom aduna costul
        de a muta blocul respectiv (stim ca blocul acela trebuie mutat cel putin
        o data, deci pentru a ajunge la starea finala vom face la un moment dat
        un pas de costul respectiv).
        """
        estimari = [self.diferenta_stari_2(infoNod, stare_finala) for stare_finala in self.scopuri]
        return min(estimari)

    # e cam spaghetti rezolvarea mea, imi pare rau
    # metoda auxiliara
    @staticmethod
    def diferenta_stari_1(stare1, stare2):
        nr_stive = len(stare1)
        dif = 0  # diferenta totala dintre cele 2 stari
        for i in range(nr_stive):
            s, t = stare1[i], stare2[i]  # stiva i din ambele stari
            dif_stiva = 0  # diferenta a doua stive
            # calculam cate elemente nu sunt in aceleasi pozitii
            for j in range(min(len(s), len(t))):
                if s[j] != t[j]:
                    dif_stiva += 1
            # daca stiva s > stiva t, diferenta de lungime reprezinta blocuri care nu sunt pozitionate bine
            if len(s) > len(t):
                dif_stiva += (len(s)-len(t))
            dif += dif_stiva
        return dif

    # metoda auxiliara
    @staticmethod
    def diferenta_stari_2(stare1, stare2):
        nr_stive = len(stare1)
        dif = 0  # diferenta totala dintre cele 2 stari
        for i in range(nr_stive):
            s, t = stare1[i], stare2[i]  # stiva i din ambele stari
            dif_stiva = 0  # diferenta a doua stive
            # calculam costul total al blocurilor care nu sunt in aceleasi pozitii
            for j in range(min(len(s), len(t))):
                if s[j] != t[j]:
                    dif_stiva += (1 + ord(s[j]) - ord('a'))  # adunam costul de a muta blocul s[j]
            # daca stiva s > stiva t, parcurgem "surplusul" din s
            for j in range(len(t), len(s)):
                dif_stiva += (1 + ord(s[j]) - ord('a'))
            dif += dif_stiva
        return dif

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return sir


def a_star(gr, nrSolutiiCautate, tip_euristica):
    # in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
    c = [NodParcurgere(gr.start, None, 0, gr.calculeaza_h(gr.start, tip_euristica))]
    while len(c) > 0:
        # print("Coada actuala: " + str(c))
        # input()
        nodCurent = c.pop(0)

        if gr.testeaza_scop(nodCurent):
            print("Solutie: ")
            nodCurent.afisDrum()
            print(f"Cost {nodCurent.g}")
            print("\n----------------\n")
            input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent, tip_euristica)
        for s in lSuccesori:
            i = 0
            while i < len(c):
                # diferenta fata de UCS e ca ordonez dupa f
                if c[i].f >= s.f:
                    break
                i += 1
            c.insert(i, s)

gr = Graph("input.txt")
print("\n\n##################\nSolutie obtinuta cu A*:")
# a_star(gr, 5, "euristica_banala")
# a_star(gr, 5, "euristica_admisibila_1")
a_star(gr, 5, "euristica_admisibila_2")