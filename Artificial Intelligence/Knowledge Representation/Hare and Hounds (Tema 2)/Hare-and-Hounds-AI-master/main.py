import math
import sys
import time
import copy
import pygame
import statistics

ADANCIME_MAX = 3


def distEuclid(p0, p1):
    (x0, y0) = p0
    (x1, y1) = p1
    return math.sqrt((x0 - x1) ** 2 + (y0 - y1) ** 2)


def in_bounds(i, j):
    # True - daca pozitia i, j este in bounds, altfel False
    if i < 0 or i > 2 or j < 0 or j > 4:
        return False
    if (i == 0 or i == 2) and (j == 0 or j == 4):
        return False
    return True


def mutari_posibile(jucator, i, j):
    # functia primeste tipul de jucator si coordonatele sale
    # si returneaza o lista cu coordonatele mutarilor disponibile
    coordonate_disponibile = []
    pozitii_fara_diagonale = [[1, 1], [1, 3], [0, 2], [2, 2]]  # pozitiile care nu au muchii diagonale
    if jucator == "hare" and [i, j] in pozitii_fara_diagonale:
        directii = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    elif jucator == "hare":
        directii = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    elif jucator == "hound" and [i, j] in pozitii_fara_diagonale:
        directii = [[-1, 0], [1, 0], [0, 1]]
    else:
        directii = [[-1, 0], [-1, 1], [0, 1], [1, 0], [1, 1]]

    for directie in directii:
        p, q = directie
        if in_bounds(p + i, q + j):
            coordonate_disponibile.append([p + i, q + j])
    return coordonate_disponibile
    # OBS: nu se verifica daca pozitiile returnate se afla deja un animal


class Joc:
    """
    Clasa care defineste jocul.
    """

    NR_COLOANE = 5
    NR_LINII = 3
    JMIN = None
    JMAX = None
    GOL = "*"

    # GUI:
    display = None
    noduri = None
    muchii = None
    hound_img = None
    hare_img = None
    selected_img = None
    winner_img = None
    scalare = None
    translatie = None
    razaPct = None
    razaPiesa = None
    diametruPiesa = None
    coordonateNoduri = None
    culoareEcran, culoareLinii = None, None
    nodPiesaSelectata = None

    def __init__(self, tabla=None, mutari_verticale_consecutive=0):
        if tabla is not None:
            self.matr = tabla
        else:
            self.matr = [[Joc.GOL for _ in range(Joc.NR_COLOANE)] for _ in range(Joc.NR_COLOANE)]
            self.matr[1][0] = "hound"
            self.matr[0][1] = "hound"
            self.matr[2][1] = "hound"
            self.matr[1][4] = "hare"

        # TODO uncomment the following line for the anti-stall rule:
        # self.mutari_verticale_consecutive = mutari_verticale_consecutive

    @classmethod
    def initialize_GUI(cls, display):
        # initializam proprietati ale clasei pentru GUI
        cls.display = display
        # nodurile sunt de forma (coloana, linie)
        cls.noduri = [(0, 1), (1, 0), (1, 1), (1, 2), (2, 0), (2, 1), (2, 2), (3, 0), (3, 1), (3, 2), (4, 1)]
        # muchiile sunt de forma (indice nod1, indice nod2), unde indicele este cel corespunzator din vectorul de noduri
        cls.muchii = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 4), (1, 5), (2, 3), (2, 5), (3, 5), (3, 6), (4, 5),
                      (4, 7), (5, 6), (5, 7), (5, 8), (5, 9), (6, 9), (7, 8), (7, 10), (8, 9), (8, 10), (9, 10)]
        cls.hound_img = pygame.image.load('assets/hound.png')
        cls.hare_img = pygame.image.load('assets/hare.png')
        cls.selected_img = pygame.image.load('assets/selected.png')
        cls.winner_img = pygame.image.load('assets/winner.png')
        cls.scalare = 100
        cls.translatie = 20
        cls.razaPct = 10
        cls.razaPiesa = 20
        cls.diametruPiesa = 2 * cls.razaPiesa
        cls.hound_img = pygame.transform.scale(cls.hound_img, (cls.diametruPiesa, cls.diametruPiesa))
        cls.hare_img = pygame.transform.scale(cls.hare_img, (cls.diametruPiesa, cls.diametruPiesa))
        cls.selected_img = pygame.transform.scale(cls.selected_img, (cls.diametruPiesa, cls.diametruPiesa))
        cls.winner_img = pygame.transform.scale(cls.winner_img, (cls.diametruPiesa, cls.diametruPiesa))
        cls.coordonateNoduri = [[cls.translatie + cls.scalare * x for x in nod] for nod in cls.noduri]
        cls.culoareEcran = (255, 255, 255)
        cls.culoareLinii = (0, 0, 0)

    def draw(self):
        # functia deseneaza matricea jocului
        self.__class__.display.fill(self.__class__.culoareEcran)
        # desenam nodurile:
        for nod in self.__class__.coordonateNoduri:
            pygame.draw.circle(surface=self.__class__.display, color=self.__class__.culoareLinii,
                               center=nod, radius=self.__class__.razaPct, width=0)
            # width=0 face un cerc plin
        # desenam muchiile:
        for muchie in self.__class__.muchii:
            p0 = self.__class__.coordonateNoduri[muchie[0]]
            p1 = self.__class__.coordonateNoduri[muchie[1]]
            pygame.draw.line(surface=self.__class__.display, color=self.__class__.culoareLinii,
                             start_pos=p0, end_pos=p1, width=5)

        for i in range(self.__class__.NR_LINII):
            for j in range(self.__class__.NR_COLOANE):
                # tranformam coordonatele din matrice in coordonate fizice pentru GUI
                coord = [self.__class__.translatie + self.__class__.scalare * x for x in [j, i]]
                # pune simbolul unui hound la locatia corespunzatoare
                if self.matr[i][j] == "hound":
                    self.__class__.display.blit(self.__class__.hound_img,
                                                (coord[0] - self.__class__.razaPiesa,
                                                 coord[1] - self.__class__.razaPiesa))
                # asemanator pt hare
                elif self.matr[i][j] == "hare":
                    self.__class__.display.blit(self.__class__.hare_img,
                                                (coord[0] - self.__class__.razaPiesa,
                                                 coord[1] - self.__class__.razaPiesa))
        # daca exista vreo piesa selectata, o coloram
        if self.__class__.nodPiesaSelectata:
            self.__class__.display.blit(self.__class__.selected_img,
                                        (self.__class__.nodPiesaSelectata[0] - self.__class__.razaPiesa,
                                         self.__class__.nodPiesaSelectata[1] - self.__class__.razaPiesa))
        pygame.display.update()  # update GUI

    def draw_winner(self, jucator):
        # displays a crown above the winning player(s)
        if jucator == "hare":
            hare = self.find_hare()
            coord = [self.__class__.translatie + self.__class__.scalare * x for x in [hare[1], hare[0]]]
            self.__class__.display.blit(self.__class__.winner_img,
                                        (coord[0] - self.__class__.razaPiesa,
                                         coord[1] - 2 * self.__class__.razaPiesa))
        else:
            hounds = self.find_hounds()
            for hound in hounds:
                coord = [self.__class__.translatie + self.__class__.scalare * x for x in [hound[1], hound[0]]]
                self.__class__.display.blit(self.__class__.winner_img,
                                            (coord[0] - self.__class__.razaPiesa,
                                             coord[1] - self.__class__.razaPiesa))
        pygame.display.update()

    @classmethod
    def jucator_opus(cls, jucator):
        if jucator == cls.JMIN:
            return cls.JMAX
        else:
            return cls.JMIN

    def find_hounds(self):
        hounds = []
        for i in range(3):
            for j in range(5):
                if self.matr[i][j] == "hound":
                    hounds.append([i, j])
        return hounds

    def find_hare(self):
        for i in range(3):
            for j in range(5):
                if self.matr[i][j] == "hare":
                    return [i, j]

    def final(self):
        # returneaza simbolul jucatorului castigator sau False daca starea nu e finala

        # o stare e finala daca iepurele nu mai are mutari disponibile pe
        # care sa nu se afle niciun caine
        # sau daca iepurele a trecut de toti cainii
        hare = self.find_hare()  # pozitia iepurelui
        hounds = self.find_hounds()  # pozitia cainilor

        # cazul in care iepurele e blocat:
        pozitii_disponibile_hare = mutari_posibile("hare", *hare)  # pozitiile posibile pe care poate merge iepurele
        stuck_hare = True  # verificam daca iepurele e blocat
        # daca iepurele are cel putin o pozitie disponibila pe care nu se afla niciun caine,
        # inseamna ca iepurele nu e blocat
        for pozitie in pozitii_disponibile_hare:
            if pozitie not in hounds:
                stuck_hare = False
                break
        if stuck_hare:
            return "hound"

        # cazul in care iepurele a trecut de caini:
        escaped = True  # presupunem ca trecut de toti cainii
        # daca gasim un caine mai la stanga in harta, atunci nu a scapat
        for hound in hounds:
            if hound[1] < hare[1]:
                escaped = False
                break
        if escaped:
            return "hare"

        # TODO uncomment the following lines for the anti-stall rule
        # cazul in care cainii au mutat de 10 ori consecutiv pe verticala (castiga tot hare)
        # if self.mutari_verticale_consecutive >= 10:
        #     return "hare"

        return False

    def mutari_jucator(self, jucator, i, j):
        # jucator = simbolul jucatorului care muta
        # i, j = coordonatele jucatorului care muta
        pozitii_posibile_jucator = mutari_posibile(jucator, i, j)
        pozitii_ocupate = [self.find_hare()] + self.find_hounds()  # pozitiile pe care se afla deja ceva
        l_mutari = []
        for pozitie in pozitii_posibile_jucator:
            if pozitie in pozitii_ocupate:
                continue
            p, q = pozitie
            copie_matr = copy.deepcopy(self.matr)
            copie_matr[i][j] = Joc.GOL
            copie_matr[p][q] = jucator

            # TODO uncomment the following lines for the anti-stall rule:
            # if jucator == "hound" and j == q:  # daca hounds au mutat pe verticala
            #     l_mutari.append(Joc(copie_matr, self.mutari_verticale_consecutive + 1))
            # elif jucator == "hound":
            #     l_mutari.append(Joc(copie_matr))  # resetam nr de mutari verticale
            # else:
            #     l_mutari.append(Joc(copie_matr, self.mutari_verticale_consecutive))

            # TODO comment the following line for the anti-stall rule:
            l_mutari.append(Joc(copie_matr))

        return l_mutari

    def mutari(self, jucator):
        hare = self.find_hare()
        hounds = self.find_hounds()
        if jucator == "hare":
            return self.mutari_jucator(jucator, *hare)
        else:
            l_mutari = []
            for hound in hounds:
                l_mutari += self.mutari_jucator(jucator, *hound)
            return l_mutari

    def noduri_reachable(self):
        # nodurile reachable din harta, din perspectiva iepurelui

        hounds = self.find_hounds()

        # facem bfs pe harta
        queue = []
        visited = set()
        start = self.find_hare()
        queue.append(start)
        visited.add((start[0], start[1]))
        while queue:
            poz = queue.pop(0)
            for pozitie in mutari_posibile("hare", *poz):
                if pozitie not in hounds and (pozitie[0], pozitie[1]) not in visited:
                    queue.append(pozitie)
                    visited.add((pozitie[0], pozitie[1]))
        return len(visited)  # numarul de pozitii reachable

    # Estimarea 1
    # numaram in mutari_valide cate mutari poate face iepurele din pozitia curenta
    # cand jucatorul este hare, vrea sa maximizeze numarul de mutari pe care le poate face
    # cand jucatorul este hounds, vrea sa minimizez numarul de mutari pe care le poate face iepurele,
    #                             (i.e sa incolteasca iepurele), adica sa maximizeze -numarul de mutari
    def estimare1(self, jucator):
        hare = self.find_hare()
        hounds = self.find_hounds()
        mutari_posibile_hare = mutari_posibile("hare", *hare)
        mutari_valabile_hare = 0
        for mutare in mutari_posibile_hare:
            if mutare not in hounds:
                mutari_valabile_hare += 1
        if jucator == "hare":
            return mutari_valabile_hare
        else:
            return -mutari_valabile_hare

    # Estimarea 2 - (Mai puternica)
    # se face BFS incepand cu pozitia iepurelui, numarandu-se numarul total de noduri accesibile din graf
    # cand jucatorul este hare, vrea sa maximizeze numarul total de noduri accesibile
    # cand jucatorul este hounds, vrea sa minimizeze acest numar, adica sa maximizeze 11 - numarul de noduri accesibile
    #                             (avem 11 noduri in total)
    # Obs: Estimarea 1 se poate vedea ca o varianta mai slaba a estimarii 2, unde BFS-ul are range = 1
    def estimare2(self, jucator):
        if jucator == "hare":
            return self.noduri_reachable()
        return 11 - self.noduri_reachable()

    def estimeaza_scor(self, adancime):
        t_final = self.final()
        if t_final == self.__class__.JMAX:
            return 99 + adancime
        elif t_final == self.__class__.JMIN:
            return -99 - adancime
        else:
            # Estimarea 1
            # return self.estimare1(self.__class__.JMAX)
            # Estimarea 2
            return self.estimare2(self.__class__.JMAX)

    def __str__(self):
        sir = "  "
        for i in range(1, Joc.NR_COLOANE - 1):
            if self.matr[0][i] == "hound":
                sir += "c"
            elif self.matr[0][i] == "hare":
                sir += "i"
            else:
                sir += Joc.GOL
            if i != 3:
                sir += "-"
        sir += "\n /|\\|/|\\\n"
        for i in range(Joc.NR_COLOANE):
            if self.matr[1][i] == "hound":
                sir += "c"
            elif self.matr[1][i] == "hare":
                sir += "i"
            else:
                sir += Joc.GOL
            if i != 4:
                sir += "-"
        sir += "\n \\|/|\\|/\n  "
        for i in range(1, Joc.NR_COLOANE - 1):
            if self.matr[2][i] == "hound":
                sir += "c"
            elif self.matr[2][i] == "hare":
                sir += "i"
            else:
                sir += Joc.GOL
            if i != 3:
                sir += "-"
        return sir


class Stare:
    """
    Clasa folosita de algoritmii minimax si alpha-beta
    O instanta din clasa stare este un nod din arborele minimax
    Are ca proprietate tabla de joc
    Functioneaza cu conditia ca in cadrul clasei Joc sa fie definiti JMIN si JMAX (cei doi jucatori posibili)
    De asemenea cere ca in clasa Joc sa fie definita si o metoda numita mutari() care ofera lista cu configuratiile
    posibile in urma mutarii unui jucator
    """

    def __init__(self, tabla_joc, j_curent, adancime, parinte=None, estimare=None):
        self.tabla_joc = tabla_joc
        self.j_curent = j_curent

        # adancimea in arborele de stari
        self.adancime = adancime

        # estimarea favorabilitatii starii (daca e finala) sau al celei mai bune stari-fiice (pentru jucatorul curent)
        self.estimare = estimare

        # lista de mutari posibile (tot de tip Stare) din starea curenta
        self.mutari_posibile = []

        # cea mai buna mutare din lista de mutari posibile pentru jucatorul curent
        # e de tip Stare (cel mai bun succesor)
        self.stare_aleasa = None

    def mutari(self):
        # lista de informatii din nodurile succesoare
        l_mutari = self.tabla_joc.mutari(self.j_curent)

        juc_opus = Joc.jucator_opus(self.j_curent)

        # mai jos calculam lista de noduri-fii (succesori)
        l_stari_mutari = [
            Stare(mutare, juc_opus, self.adancime - 1, parinte=self)
            for mutare in l_mutari
        ]

        return l_stari_mutari

    def __str__(self):
        sir = str(self.tabla_joc) + "\n(Juc curent:" + self.j_curent + ")\n"
        return sir


def min_max(stare):
    # daca sunt la o frunza in arborele minimax sau la o stare finala
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    # calculez toate mutarile posibile din starea curenta
    stare.mutari_posibile = stare.mutari()

    # aplic algoritmul minimax pe toate mutarile posibile (calculand astfel subarborii lor)
    mutariCuEstimare = [
        min_max(x) for x in stare.mutari_posibile
    ]  # expandez(constr subarb) fiecare nod x din mutari posibile

    if stare.j_curent == Joc.JMAX:
        # daca jucatorul e JMAX aleg starea-fiica cu estimarea maxima
        stare.stare_aleasa = max(mutariCuEstimare, key=lambda x: x.estimare)
    else:
        # daca jucatorul e JMIN aleg starea-fiica cu estimarea minima
        stare.stare_aleasa = min(mutariCuEstimare, key=lambda x: x.estimare)

    stare.estimare = stare.stare_aleasa.estimare
    return stare


def alpha_beta(alpha, beta, stare):
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    if alpha > beta:
        return stare  # este intr-un interval invalid deci nu o mai procesez

    stare.mutari_posibile = stare.mutari()

    if stare.j_curent == Joc.JMAX:
        estimare_curenta = float("-inf")

        for mutare in stare.mutari_posibile:
            # calculeaza estimarea pentru starea noua, realizand subarborele
            stare_noua = alpha_beta(
                alpha, beta, mutare
            )  # aici construim subarborele pentru stare_noua

            if estimare_curenta < stare_noua.estimare:
                stare.stare_aleasa = stare_noua
                estimare_curenta = stare_noua.estimare
            if alpha < stare_noua.estimare:
                alpha = stare_noua.estimare
                if alpha >= beta:
                    break

    elif stare.j_curent == Joc.JMIN:
        estimare_curenta = float("inf")
        # completati cu rationament similar pe cazul stare.j_curent==Joc.JMAX
        for mutare in stare.mutari_posibile:
            # calculeaza estimarea
            stare_noua = alpha_beta(
                alpha, beta, mutare
            )  # aici construim subarborele pentru stare_noua

            if estimare_curenta > stare_noua.estimare:
                stare.stare_aleasa = stare_noua
                estimare_curenta = stare_noua.estimare
            if beta > stare_noua.estimare:
                beta = stare_noua.estimare
                if alpha >= beta:
                    break

    stare.estimare = stare.stare_aleasa.estimare

    return stare


def afis_daca_final(stare_curenta):
    # metoda final() returneaza castigatorul sau False daca nu e stare finala
    final = stare_curenta.tabla_joc.final()
    if final:
        print("A castigat " + final)
        return final
    return False


def afis_variante():
    # folosit pentru alegerile userului din consola
    print("  1-4-7\n /|\\|/|\\\n0-2-5-8-10\n \\|/|\\|/\n  3-6-9\n")


def mutare_valida(matr, coord_piesa, coord_pozitie_noua):
    # matr - matricea jocului
    # coord_piesa - locatie sursa
    # coord_pozitie_noua - locatie destinatie
    if matr[coord_piesa[0]][coord_piesa[1]] != Joc.JMIN:
        return False
    if matr[coord_pozitie_noua[0]][coord_pozitie_noua[1]] != Joc.GOL:
        return False
    if coord_pozitie_noua not in mutari_posibile(Joc.JMIN, *coord_piesa):
        return False
    return True


def convert_coordinates_to_matrix_location(coord):
    # convertim coordonatele fizice la coordonatele din matricea jocului
    # trebuie sa aplicam operatia inversa pentru coordonate
    # iar coordonatele isi schimba ordinea (deoarece in GUI sunt de forma (coloana, linie))
    return [round((x - Joc.translatie)/Joc.scalare) for x in [coord[1], coord[0]]]


def print_algorithm_time_stats(time_array):
    print(f"Timp maxim = {max(time_array)} ms\nTimp minim = {min(time_array)} ms\n"
          f"Timp mediu = {statistics.mean(time_array)} ms\nMedina = {statistics.median(time_array)} ms\n")


def print_final_stats(game_start_time, total_nr_of_moves):
    game_end_time = int(round(time.time() * 1000))
    print(
        'Jocul a durat '
        + str(game_end_time - game_start_time)
        + " ms"
    )
    print(f'Numarul total de mutari = {total_nr_of_moves}')


### Classes for GUI Menu: ###
class Buton:
    def __init__(
            self,
            display=None,
            left=0,
            top=0,
            w=0,
            h=0,
            culoareFundal=(255, 255, 255),
            culoareFundalSel=(243, 62, 62),
            text="",
            font="arial",
            fontDimensiune=16,
            culoareText=(0, 0, 0),
            valoare="",
    ):
        self.display = display
        self.left = left
        self.top = top
        self.culoareFundal = culoareFundal
        self.culoareFundalSel = culoareFundalSel
        self.text = text
        self.font = font
        self.w = w
        self.h = h
        self.selectat = False
        self.fontDimensiune = fontDimensiune
        self.culoareText = culoareText
        fontObj = pygame.font.SysFont(self.font, self.fontDimensiune)
        self.textRandat = fontObj.render(self.text, True, self.culoareText)
        self.dreptunghi = pygame.Rect(left, top, w, h)
        self.dreptunghiText = self.textRandat.get_rect(center=self.dreptunghi.center)
        self.valoare = valoare

    def selecteaza(self, sel):
        self.selectat = sel
        self.deseneaza()

    def selecteazaDupacoord(self, coord):
        if self.dreptunghi.collidepoint(coord):
            self.selecteaza(True)
            return True
        return False

    def updateDreptunghi(self):
        self.dreptunghi.left = self.left
        self.dreptunghi.top = self.top
        self.dreptunghiText = self.textRandat.get_rect(center=self.dreptunghi.center)

    def deseneaza(self):
        culoareF = self.culoareFundalSel if self.selectat else self.culoareFundal
        pygame.draw.rect(self.display, culoareF, self.dreptunghi)
        self.display.blit(self.textRandat, self.dreptunghiText)


class GrupButoane:
    def __init__(
            self, listaButoane=[], indiceSelectat=0, spatiuButoane=10, left=0, top=0
    ):
        self.listaButoane = listaButoane
        self.indiceSelectat = indiceSelectat
        self.listaButoane[self.indiceSelectat].selectat = True
        self.top = top
        self.left = left
        leftCurent = self.left
        for b in self.listaButoane:
            b.top = self.top
            b.left = leftCurent
            b.updateDreptunghi()
            leftCurent += spatiuButoane + b.w

    def selecteazaDupacoord(self, coord):
        for ib, b in enumerate(self.listaButoane):
            if b.selecteazaDupacoord(coord) and ib != self.indiceSelectat:
                self.listaButoane[self.indiceSelectat].selecteaza(False)
                self.indiceSelectat = ib
                return True
        return False

    def deseneaza(self):
        # atentie, nu face wrap
        for b in self.listaButoane:
            b.deseneaza()

    def getValoare(self):
        return self.listaButoane[self.indiceSelectat].valoare


### GUI Menu: ###
def deseneaza_alegeri(display):
    display.fill((255, 255, 255))
    font = pygame.font.SysFont("arial", 16, bold=True)
    label_algo = font.render("Algorithm: ", True, (0, 0, 0))
    display.blit(label_algo, (20, 35))
    btn_alg = GrupButoane(
        top=30,
        left=100,
        listaButoane=[
            Buton(display=display, w=80, h=30, text="Minimax", valoare="minimax"),
            Buton(display=display, w=80, h=30, text="Alpha-Beta", valoare="alphabeta"),
        ],
        indiceSelectat=1,
    )
    label_player = font.render("Player: ", True, (0, 0, 0))
    display.blit(label_player, (30, 90))
    btn_juc = GrupButoane(
        top=85,
        left=100,
        listaButoane=[
            Buton(display=display, w=80, h=30, text="Hounds", valoare="hound"),
            Buton(display=display, w=80, h=30, text="Hare", valoare="hare"),
        ],
        indiceSelectat=0,
    )
    label_algo = font.render("Difficulty: ", True, (0, 0, 0))
    display.blit(label_algo, (20, 140))
    btn_dif = GrupButoane(
        top=135,
        left=100,
        listaButoane=[
            Buton(display=display, w=80, h=30, text="Easy", valoare="1"),
            Buton(display=display, w=80, h=30, text="Medium", valoare="3"),
            Buton(display=display, w=80, h=30, text="Hard", valoare="6")
        ],
        indiceSelectat=1,
    )
    ok = Buton(
        display=display,
        top=185,
        left=30,
        w=60,
        h=30,
        text="Play",
        culoareFundal=(243, 62, 62),
    )
    btn_alg.deseneaza()
    btn_juc.deseneaza()
    btn_dif.deseneaza()
    ok.deseneaza()
    while True:
        for ev in pygame.event.get():
            if ev.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif ev.type == pygame.MOUSEBUTTONDOWN:
                pos = pygame.mouse.get_pos()
                if not btn_alg.selecteazaDupacoord(pos):
                    if not btn_juc.selecteazaDupacoord(pos):
                        if not btn_dif.selecteazaDupacoord(pos):
                            if ok.selecteazaDupacoord(pos):
                                return btn_juc.getValoare(), btn_alg.getValoare(), btn_dif.getValoare()
        pygame.display.update()


def main():
    global ADANCIME_MAX
    global total_number_of_moves
    global game_start

    pygame.init()
    pygame.display.set_caption("Hare and Hounds - Petrescu Cosmin 243")
    display = pygame.display.set_mode(size=(450, 280))

    # Afisam meniul si setam alegerile (piesa si algoritmul)
    Joc.JMIN, tip_algoritm, adancime = deseneaza_alegeri(display)
    ADANCIME_MAX = int(adancime)  # setam dificultatea jocului (adancimea maxima, care initial e string)
    print(f"Piesa user = {Joc.JMIN}, Algoritm = {tip_algoritm}, Adancime Maxima = {ADANCIME_MAX}")
    Joc.JMAX = "hare" if Joc.JMIN == "hound" else "hound"

    # initializam GUI ul pentru gameplay
    Joc.initialize_GUI(display)

    # initializare tabla
    tabla_curenta = Joc()

    print("Tabla initiala")
    print(str(tabla_curenta))

    # creare stare initiala
    stare_curenta = Stare(tabla_curenta, "hound", ADANCIME_MAX)  # conform wikipedia, hounds move first.

    tabla_curenta.draw()  # desenam tabla initiala

    algorithm_time_array = []  # retinem timpul stat de algoritm la fiecare mutare
    start_counting = False  # helper pentru calcularea timpului de gandire al userului
    while True:
        if stare_curenta.j_curent == Joc.JMIN:
            # muta jucatorul

            if not start_counting:
                t_inainte = int(round(time.time() * 1000))
                start_counting = True

            for ev in pygame.event.get():
                if ev.type == pygame.QUIT:
                    print_algorithm_time_stats(algorithm_time_array)
                    print_final_stats(game_start, total_number_of_moves)
                    pygame.quit()
                    sys.exit()
                elif ev.type == pygame.MOUSEBUTTONDOWN:
                    pos = pygame.mouse.get_pos()  # pozitia eventului
                    for nod in Joc.coordonateNoduri:  # pentru fiecare nod din coordonate
                        # verificam daca eventul este in raza de actiune a nodului:
                        if distEuclid(pos, nod) <= Joc.razaPct:
                            # daca am gasit nodul asupra caruia s-a activat un event
                            # convertim coordonatele fizice la coordonatele din matricea jocului:
                            pos_matrice = convert_coordinates_to_matrix_location(nod)
                            # verificam daca la pozitia unde s-a activat eventul se afla piesa userului:
                            if stare_curenta.tabla_joc.matr[pos_matrice[0]][pos_matrice[1]] == Joc.JMIN:
                                # daca nu avem nimic selectat / avem selectat un nod diferit, actualizam nodul selectat
                                if Joc.nodPiesaSelectata is None or Joc.nodPiesaSelectata != nod:
                                    Joc.nodPiesaSelectata = nod
                                else:
                                    # daca am selectat nodul deja selectat => il deselectam
                                    Joc.nodPiesaSelectata = None
                            # verificam daca la pozitia unde s-a activat eventul se afla un nod gol si avem deja un
                            # nod selectat:
                            if stare_curenta.tabla_joc.matr[pos_matrice[0]][pos_matrice[1]] == Joc.GOL and \
                                    Joc.nodPiesaSelectata is not None:
                                # avem o piesa selectata si am dat click pe un nod gol
                                # obtinem coordonatele sursa din matricea jocului:
                                pos_sursa = convert_coordinates_to_matrix_location(Joc.nodPiesaSelectata)
                                # obtinem coordonatele destinatie din matricea jocului:
                                pos_dest = pos_matrice  # am redenumit pentru a urmari mai usor

                                # trebuie sa verificam inainte daca mutarea e valida
                                if mutare_valida(stare_curenta.tabla_joc.matr, pos_sursa, pos_dest):
                                    # eliberam pozitia sursa si punem piesa pe pozitia destinatie, in matricea jocului:
                                    stare_curenta.tabla_joc.matr[pos_sursa[0]][pos_sursa[1]] = Joc.GOL
                                    stare_curenta.tabla_joc.matr[pos_dest[0]][pos_dest[1]] = Joc.JMIN

                                    # TODO uncomment the following lines for the anti-stall rule:
                                    # # cazul mutarilor pe verticala:
                                    # if Joc.JMIN == "hound" and pos_sursa[1] == pos_dest[1]:
                                    #     stare_curenta.tabla_joc.mutari_verticale_consecutive += 1
                                    # elif Joc.JMIN == "hound":
                                    #     stare_curenta.tabla_joc.mutari_verticale_consecutive = 0

                                    # afisarea starii jocului in urma mutarii utilizatorului
                                    print("\nTabla dupa mutarea jucatorului")
                                    print(str(stare_curenta))

                                    # preiau timpul in milisecunde de dupa mutare
                                    t_dupa = int(round(time.time() * 1000))
                                    start_counting = False
                                    print(
                                        'Userul a gandit timp de '
                                        + str(t_dupa - t_inainte)
                                        + " milisecunde."
                                    )

                                    total_number_of_moves += 1

                                    # testam daca jocul a ajuns in stare finala:
                                    winner = afis_daca_final(stare_curenta)
                                    if winner:
                                        print_algorithm_time_stats(algorithm_time_array)
                                        stare_curenta.tabla_joc.draw_winner(winner)

                                    # JMIN a mutat, schimbam jucatorul:
                                    stare_curenta.j_curent = Joc.jucator_opus(stare_curenta.j_curent)

                                    Joc.nodPiesaSelectata = None  # deselectam

                                    break
                            stare_curenta.tabla_joc.draw()  # update GUI
                            break
                if stare_curenta.j_curent == Joc.JMAX:
                    # JMIN a terminat de mutat, putem sa iesim din listener
                    break

        # --------------------------------

        else:  # jucatorul e JMAX (calculatorul)
            # Mutare calculator

            print("Acum muta calculatorul cu", stare_curenta.j_curent)
            # preiau timpul in milisecunde de dinainte de mutare
            t_inainte = int(round(time.time() * 1000))

            # stare actualizata e starea mea curenta in care am setat stare_aleasa (mutarea urmatoare)
            if tip_algoritm == "minimax":
                stare_actualizata = min_max(stare_curenta)
            else:
                stare_actualizata = alpha_beta(-500, 500, stare_curenta)

            # aici se face de fapt mutarea !!!
            stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc

            print(f"Estimarea pentru radacina arborelui: {stare_curenta.estimare}")

            total_number_of_moves += 1

            print("Tabla dupa mutarea calculatorului")
            print(str(stare_curenta))

            # preiau timpul in milisecunde de dupa mutare
            t_dupa = int(round(time.time() * 1000))
            print(
                'Calculatorul a "gandit" timp de '
                + str(t_dupa - t_inainte)
                + " milisecunde."
            )
            algorithm_time_array.append(t_dupa - t_inainte)  # adaugam timpul corespunzator mutarii in array

            stare_curenta.tabla_joc.draw()  # update GUI

            winner = afis_daca_final(stare_curenta)
            if winner:
                print_algorithm_time_stats(algorithm_time_array)
                stare_curenta.tabla_joc.draw_winner(winner)
                break

            # S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = Joc.jucator_opus(stare_curenta.j_curent)


if __name__ == "__main__":

    total_number_of_moves = 0

    game_start = int(round(time.time() * 1000))

    main()

    print_final_stats(game_start, total_number_of_moves)

    # Listener pentru quit: (fara asta se inchide GUI ul cand castiga cineva)
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
