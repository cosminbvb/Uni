import heapq
import math
import time
import stopit


def cautaElev(clasa, nume):
    """
    Cauta pozitia unui elev intr-o anumita clasa
    :param clasa: matrice bidimensionala de strings
    :param nume: string - numele elevului
    :return: (int, int) - coordonatele elevului, daca este gasit, -1 altfel
    """
    for i, linie in enumerate(clasa):
        for j, elem in enumerate(linie):
            if elem == nume:
                return i, j
    return -1


# informatii despre un nod din arborele de parcurgere
class NodParcurgere:

    gr = None  # static
    counter = 0

    def __init__(self, info, parinte, cost):
        # O stare e dată de poziția biletului și cine e ascultat de profesor la acel moment.
        # persoana ascultata de profesor e data prin indicele din lista "ascultati"
        # Am mai adaugat si timpul ramas pentru ascultarea persoanei respective
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.g = cost  # costul de la radacina la nodul curent
        NodParcurgere.counter += 1

    def obtineDrum(self):
        nodesList = [self]
        nod = self
        while nod.parinte is not None:
            nodesList.insert(0, nod.parinte)
            nod = nod.parinte
        return nodesList

    def afisDrum(self):  # returneaza si lungimea drumului
        nodesList = self.obtineDrum()
        for nod in nodesList:
            if nod.parinte is not None:
                nume = self.gr.clasa[nod.info[0]][nod.info[1]]
                numeParinte = self.gr.clasa[nod.parinte.info[0]][nod.parinte.info[1]]
                iParinte, jParinte = nod.parinte.info[0], nod.parinte.info[1]
                i, j = nod.info[0], nod.info[1]
                self.gr.outputFile.write(numeParinte)
                if iParinte > i:  # biletul a urcat
                    self.gr.outputFile.write(" ^ ")
                if iParinte < i:  # biletul a coborat
                    self.gr.outputFile.write(" v ")
                if jParinte > j:  # biletul a mers la stanga
                    if jParinte % 2 == 0:  # biletul a mers pe alta coloana de banci
                        self.gr.outputFile.write(" << ")
                    else:  # biletul a mers la stanga in aceeasi banca
                        self.gr.outputFile.write(" < ")
                if jParinte < j:  # biletul a mers la dreapta
                    if jParinte % 2 == 1:  # biletul a mers pe alta coloana de banci
                        self.gr.outputFile.write(" >> ")
                    else:
                        self.gr.outputFile.write(" > ")
                if nod == nodesList[-1]:  # afisam si ultimul nume (receiverul)
                    self.gr.outputFile.write(nume + "\n")
        return len(nodesList)

    def contineInDrum(self, infoNodNou):
        nodDrum = self
        while nodDrum is not None:
            if infoNodNou == nodDrum.info:
                return True
            nodDrum = nodDrum.parinte
        return False

    def __lt__(self, other):  # pentru heap
        return self.g < other.g

    def __str__(self):
        return f"({self.info[0]}, {self.info[1]}, {self.info[2]}, {self.info[3]})"

    def __repr__(self):
        return f"({self.info[0]}, {self.info[1]}, {self.info[2]}, {self.info[3]})"


class Graph:  # graful problemei
    def __init__(self, fileData, outputFile):
        self.clasa = fileData[0]
        self.shape = (len(self.clasa), len(self.clasa[0]))  # linii si coloane de elevi
        self.K = fileData[1]  # coloane de banci
        self.suparati = fileData[2]
        self.M = fileData[3]
        self.ascultati = fileData[4]
        self.mesaj = fileData[5]  # mesaj[0] = sender, mesaj[1] = receiver
        # construim starea initiala:
        i, j = cautaElev(self.clasa, self.mesaj[0])  # pozitia biletului = pozitia senderului
        self.start = (i, j, 0, self.M)
        i, j = cautaElev(self.clasa, self.mesaj[1])  # pozitia receiverului
        self.scop = (i, j)  # nu cred ca mai conteaza cine e ascultat
        self.outputFile = outputFile

    def testeaza_scop(self, nodCurent):
        return nodCurent.info[0] == self.scop[0] and nodCurent.info[1] == self.scop[1]

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent):

        # Un copil poate da fara probleme biletul catre colegul de banca,
        # la fel neobservat de catre profesor poate da biletul catre colegii
        # din fata sau din spatele lui, insa nu si in diagonala, deoarece,
        # intinzandu-se peste banca ar atrage privirea profesorului.

        # De asemenea, trecerea biletelului de pe un rand pe altul este mai
        # anevoioasa, deoarece poate fi vazut foarte usor de catre profesor,
        # de aceea singurele banci intre care se poate face transferul sunt
        # penultimele si ultimele de pe fiecare rand.

        listaSuccesori = []

        linieCurenta, coloanaCurenta, indicePersAscultata, timpRamas = nodCurent.info
        if indicePersAscultata == -1:
            # nu mai este nimeni de ascultat
            ascultat = -1
        else:
            ascultat = self.ascultati[indicePersAscultata]
            # trebuie sa testam daca starea e valida pentru cazul in care profesorul schimba persoana
            # pe care o asculta si biletul e in raza sa
            # in cazul in care biletul e in raza profesorului (starea e invalida), nu o mai expandam (returnam [])
            linieAscultat, coloanaAscultat = cautaElev(self.clasa, ascultat)
            if self.vizibil(linieCurenta, coloanaCurenta, linieAscultat, coloanaAscultat):
                return listaSuccesori

        directii = [[-1, 0], [1, 0], [0, -1], [0, 1]]
        for dl, dc in directii:
            linieNoua = linieCurenta + dl
            coloanaNoua = coloanaCurenta + dc

            if linieNoua < 0 or coloanaNoua < 0 or linieNoua >= self.shape[0] or coloanaNoua >= self.shape[1]:
                # daca pozitia e out of bounds, nu e bine
                continue
            if coloanaCurenta // 2 != coloanaNoua // 2 and linieCurenta < self.shape[0] - 2:
                # coloana // 2 = indicele coloanei de banci
                # daca biletul trece intre coloane de banci si nu se afla pe unul din ultimele 2 randuri, nu e bine
                continue
            if self.clasa[linieNoua][coloanaNoua] == "liber":
                # nu putem da biletul catre un loc gol
                continue
            # biletul nu se poate da catre un coleg suparat
            colegi = [self.clasa[linieCurenta][coloanaCurenta], self.clasa[linieNoua][coloanaNoua]]
            if colegi in self.suparati or colegi.reverse() in self.suparati:
                continue

            # criteriul cu persoana ascultata:
            if ascultat == -1:
                # daca nu e nimeni ascultat, nu mai verificam nimic
                infoNodNou = (linieNoua, coloanaNoua, -1, 0)
            else:
                # daca cineva e ascultat
                # trebuie sa obtinem pozitia elevului ascultat
                linieAscultat, coloanaAscultat = cautaElev(self.clasa, ascultat)
                # si apoi sa verificam daca locul unde trimitem biletul este vizibil de catre profesor
                # daca este, incercam alt loc
                if self.vizibil(linieNoua, coloanaNoua, linieAscultat, coloanaAscultat):
                    continue
                # daca nu este vizibil:
                if timpRamas > 1:
                    # si profesorul nu a terminat de ascultat pers respectiva
                    infoNodNou = (linieNoua, coloanaNoua, indicePersAscultata, timpRamas-1)
                elif indicePersAscultata < len(self.ascultati) - 1:
                    # profesorul a terminat de ascultat pers respectiva
                    # si mai are elevi de ascultat
                    infoNodNou = (linieNoua, coloanaNoua, indicePersAscultata+1, self.M)
                else:
                    # nu mai e nimeni de ascultat
                    infoNodNou = (linieNoua, coloanaNoua, -1, 0)

            # daca nodul nou nu apare deja in drum, il adaugam la succesori
            if not nodCurent.contineInDrum(infoNodNou):
                #  Costul unei mutări de bilet în aceeași bancă e 0,
                #  între bănci consecutive e 1 și între coloanele de bănci e 2
                costMutare = 0
                if coloanaNoua == coloanaCurenta:  # biletul merge in sus sau in jos
                    costMutare = 1
                if coloanaCurenta // 2 != coloanaNoua // 2:  # biletul merge intre coloane de banci
                    costMutare = 2

                listaSuccesori.append(
                    NodParcurgere(
                        infoNodNou,
                        nodCurent,
                        nodCurent.g + costMutare
                    )
                )
        return listaSuccesori

    @staticmethod
    def vizibil(linieNoua, coloanaNoua, linieAscultat, coloanaAscultat):
        """Verifica daca biletul este vizibil de catre profesor in timp ce
        acesta asculta persoana de la pozitia (linieAscultat, coloanaAscultat)

        :param linieNoua: linia pozitiei biletului
        :param coloanaNoua: coloana pozitiei biletului
        :param linieAscultat: linia elevului ascultat
        :param coloanaAscultat: coloana elevului ascultat
        :return: bool (true daca biletul este vizibil, false in caz contrar)
        """
        bancaNoua = (linieNoua, coloanaNoua//2)
        bancaAscultat = (linieAscultat, coloanaAscultat//2)
        # distanta euclidiana
        dist = math.sqrt((bancaNoua[0]-bancaAscultat[0])**2 + (bancaNoua[1]-bancaAscultat[1])**2)
        # daca am inteles corect, biletul nu se poate afla in bancile din jurul
        # celei in care sta elevul ascultat (inclusiv bancile din diagonala)
        # ceea ce inseamna ca daca distanta dintre cele doua banci este 1 sau sqrt(2) = 1.41..
        # biletul este vizibil. Deci, daca distanta este < 1.5, biletul e vizibil
        return dist < 1.5


@stopit.threading_timeoutable(default="TLE")  # default = valoarea returnata de functie cand intra in timeout
def UCS(gr, nrSolutiiCautate=1):
    startTime = time.time()  # timpul de start al algoritmului
    c = []
    NodParcurgere.counter = 0
    heapq.heappush(c, NodParcurgere(gr.start, None, 0))
    while len(c) > 0:
        # print("Coada actuala: " + str(input_c.txt))
        # input()
        nodCurent = heapq.heappop(c)

        if gr.testeaza_scop(nodCurent):
            endTime = time.time()  # timpul gasirii solutiei
            gr.outputFile.write("Solutie:\n")
            lungimeDrum = nodCurent.afisDrum()
            gr.outputFile.write(f"Cost: {nodCurent.g}\n")
            gr.outputFile.write(f"Lungime drum: {lungimeDrum}\n")
            gr.outputFile.write(f"Timp: {endTime-startTime} secunde\n")
            gr.outputFile.write(f"Numarul total de noduri calculate: {NodParcurgere.counter}")
            gr.outputFile.write("\n---------------------------------\n")
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return

        lSuccesori = gr.genereazaSuccesori(nodCurent)
        for s in lSuccesori:
            heapq.heappush(c, s)
