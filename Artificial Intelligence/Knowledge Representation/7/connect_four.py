import time
import copy
import pygame
import sys


ADANCIME_MAX = 4


def elem_identice(lista):
    if len(set(lista)) == 1:
        return lista[0] if lista[0] != Joc.GOL else False
    return False


class Joc:
    """
    Clasa care defineste jocul. Se va schimba de la un joc la altul.
    """

    JMIN = None
    JMAX = None
    GOL = "#"
    NR_LINII = None
    NR_COLOANE = None
    scor_maxim = 0

    def __init__(self, matr=None):
        # creez proprietatea ultima_mutare # (l,c)
        self.ultima_mutare = None

        if matr:
            # e data tabla, deci suntem in timpul jocului
            self.matr = matr
        else:
            # nu e data tabla deci suntem la initializare
            self.matr = [
                [self.__class__.GOL] * self.__class__.NR_COLOANE
                for i in range(self.__class__.NR_LINII)
            ]

    def deseneaza_grid(self, coloana_marcaj=None):

        for linie in range(self.__class__.NR_LINII):
            for coloana in range(self.__class__.NR_COLOANE):
                if coloana == coloana_marcaj:
                    # daca am o patratica selectata, o desenez cu rosu
                    culoare = (255, 255, 0)
                else:
                    # altfel o desenez cu alb
                    culoare = (255, 255, 255)
                pygame.draw.rect(
                    self.__class__.display,
                    culoare,
                    self.__class__.celuleGrid[
                        linie * self.__class__.NR_COLOANE + coloana
                    ],
                )  # alb = (255,255,255)
                if self.matr[linie][coloana] == "x":
                    self.__class__.display.blit(
                        self.__class__.x_img,
                        (
                            coloana * (self.__class__.dim_celula + 1),
                            linie * (self.__class__.dim_celula + 1),
                        ),
                    )
                elif self.matr[linie][coloana] == "0":
                    self.__class__.display.blit(
                        self.__class__.zero_img,
                        (
                            coloana * (self.__class__.dim_celula + 1),
                            linie * (self.__class__.dim_celula + 1),
                        ),
                    )
        pygame.display.update()

    @classmethod
    def jucator_opus(cls, jucator):
        return cls.JMAX if jucator == cls.JMIN else cls.JMIN

    @classmethod
    def initializeaza(cls, display, NR_LINII=6, NR_COLOANE=7, dim_celula=100):
        cls.NR_LINII = NR_LINII
        cls.NR_COLOANE = NR_COLOANE

        ######## calculare scor maxim ###########
        sc_randuri = (cls.NR_COLOANE - 3) * cls.NR_LINII
        sc_coloane = (cls.NR_LINII - 3) * cls.NR_COLOANE
        sc_diagonale = (cls.NR_LINII - 3) * (cls.NR_COLOANE - 3) * 2
        cls.scor_maxim = sc_randuri + sc_coloane + sc_diagonale

        cls.display = display
        cls.dim_celula = dim_celula
        cls.x_img = pygame.image.load("ics.png")
        cls.x_img = pygame.transform.scale(cls.x_img, (dim_celula, dim_celula))
        cls.zero_img = pygame.image.load("zero.png")
        cls.zero_img = pygame.transform.scale(cls.zero_img, (dim_celula, dim_celula))
        cls.celuleGrid = []  # este lista cu patratelele din grid
        for linie in range(NR_LINII):
            for coloana in range(NR_COLOANE):
                patr = pygame.Rect(
                    coloana * (dim_celula + 1),
                    linie * (dim_celula + 1),
                    dim_celula,
                    dim_celula,
                )
                cls.celuleGrid.append(patr)

    def parcurgere(self, directie):
        um = self.ultima_mutare  # (l,c)
        culoare = self.matr[um[0]][um[1]]
        nr_mutari = 0
        while True:
            um = (um[0] + directie[0], um[1] + directie[1])
            if (
                not 0 <= um[0] < self.__class__.NR_LINII
                or not 0 <= um[1] < self.__class__.NR_COLOANE
            ):
                break
            if self.matr[um[0]][um[1]] != culoare:
                break
            nr_mutari += 1
        return nr_mutari

    def final(self):
        if not self.ultima_mutare:  # daca e inainte de prima mutare
            return False
        directii = [
            [(0, 1), (0, -1)],
            [(1, 1), (-1, -1)],
            [(1, -1), (-1, 1)],
            [(1, 0), (-1, 0)],
        ]
        um = self.ultima_mutare
        rez = False
        for per_dir in directii:
            len_culoare = (
                self.parcurgere(per_dir[0]) + self.parcurgere(per_dir[1]) + 1
            )  # +1 pt chiar ultima mutare
            if len_culoare >= 4:
                rez = self.matr[um[0]][um[1]]

        if rez:
            return rez
        elif all(self.__class__.GOL not in x for x in self.matr):
            return "remiza"
        else:
            return False

    def mutari(self, jucator):
        l_mutari = []
        for j in range(self.__class__.NR_COLOANE):
            last_poz = None
            if self.matr[0][j] != self.__class__.GOL:
                continue
            for i in range(self.__class__.NR_LINII):
                if self.matr[i][j] != self.__class__.GOL:
                    last_poz = (i - 1, j)
                    break
            if last_poz is None:
                last_poz = (self.__class__.NR_LINII - 1, j)
            matr_tabla_noua = copy.deepcopy(self.matr)
            matr_tabla_noua[last_poz[0]][last_poz[1]] = jucator
            jn = Joc(matr_tabla_noua)
            jn.ultima_mutare = (last_poz[0], last_poz[1])
            l_mutari.append(jn)
        return l_mutari

    # linie deschisa inseamna linie pe care jucatorul mai poate forma o configuratie castigatoare
    # practic e o linie fara simboluri ale jucatorului opus
    def linie_deschisa(self, lista, jucator):
        jo = self.jucator_opus(jucator)
        # verific daca pe linia data nu am simbolul jucatorului opus
        if not jo in lista:
            # return 1
            return lista.count(jucator)
        return 0

    def linii_deschise(self, jucator):

        linii = 0
        for i in range(self.__class__.NR_LINII):
            for j in range(self.__class__.NR_COLOANE - 3):
                linii += self.linie_deschisa(self.matr[i][j : j + 4], jucator)

        for j in range(self.__class__.NR_COLOANE):
            for i in range(self.__class__.NR_LINII - 3):
                linii += self.linie_deschisa(
                    [self.matr[k][j] for k in range(i, i + 4)], jucator
                )

        # \
        for i in range(self.__class__.NR_LINII - 3):
            for j in range(self.__class__.NR_COLOANE - 3):
                linii += self.linie_deschisa(
                    [self.matr[i + k][j + k] for k in range(0, 4)], jucator
                )

        # /
        for i in range(self.__class__.NR_LINII - 3):
            for j in range(3, self.__class__.NR_COLOANE):
                linii += self.linie_deschisa(
                    [self.matr[i + k][j - k] for k in range(0, 4)], jucator
                )

        return linii

    def estimeaza_scor(self, adancime):
        t_final = self.final()
        # if (adancime==0):
        if t_final == self.__class__.JMAX:
            return self.__class__.scor_maxim + adancime
        elif t_final == self.__class__.JMIN:
            return -self.__class__.scor_maxim - adancime
        elif t_final == "remiza":
            return 0
        else:
            return self.linii_deschise(self.__class__.JMAX) - self.linii_deschise(
                self.__class__.JMIN
            )

    def sirAfisare(self):
        sir = "  |"
        sir += " ".join([str(i) for i in range(self.NR_COLOANE)]) + "\n"
        sir += "-" * (self.NR_COLOANE + 1) * 2 + "\n"
        sir += "\n".join(
            [
                str(i) + " |" + " ".join([str(x) for x in self.matr[i]])
                for i in range(len(self.matr))
            ]
        )
        return sir

    def __str__(self):
        return self.sirAfisare()

    def __repr__(self):
        return self.sirAfisare()


class Stare:
    """
    Clasa folosita de algoritmii minimax si alpha-beta
    Are ca proprietate tabla de joc
    Functioneaza cu conditia ca in cadrul clasei Joc sa fie definiti JMIN si JMAX (cei doi jucatori posibili)
    De asemenea cere ca in clasa Joc sa fie definita si o metoda numita mutari() care ofera lista cu configuratiile posibile in urma mutarii unui jucator
    """

    def __init__(self, tabla_joc, j_curent, adancime, parinte=None, scor=None):
        self.tabla_joc = tabla_joc
        self.j_curent = j_curent

        # adancimea in arborele de stari
        self.adancime = adancime

        # scorul starii (daca e finala) sau al celei mai bune stari-fiice (pentru jucatorul curent)
        self.scor = scor

        # lista de mutari posibile din starea curenta
        self.mutari_posibile = []

        # cea mai buna mutare din lista de mutari posibile pentru jucatorul curent
        self.stare_aleasa = None

    def mutari(self):
        l_mutari = self.tabla_joc.mutari(self.j_curent)
        juc_opus = Joc.jucator_opus(self.j_curent)
        l_stari_mutari = [
            Stare(mutare, juc_opus, self.adancime - 1, parinte=self)
            for mutare in l_mutari
        ]

        return l_stari_mutari

    def __str__(self):
        sir = str(self.tabla_joc) + "(Juc curent:" + self.j_curent + ")\n"
        return sir

    def __repr__(self):
        sir = str(self.tabla_joc) + "(Juc curent:" + self.j_curent + ")\n"
        return sir


""" Algoritmul MinMax """


def min_max(stare):

    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.scor = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    # calculez toate mutarile posibile din starea curenta
    stare.mutari_posibile = stare.mutari()

    # aplic algoritmul minimax pe toate mutarile posibile (calculand astfel subarborii lor)
    mutari_scor = [min_max(mutare) for mutare in stare.mutari_posibile]

    if stare.j_curent == Joc.JMAX:
        # daca jucatorul e JMAX aleg starea-fiica cu scorul maxim
        stare.stare_aleasa = max(mutari_scor, key=lambda x: x.scor)
    else:
        # daca jucatorul e JMIN aleg starea-fiica cu scorul minim
        stare.stare_aleasa = min(mutari_scor, key=lambda x: x.scor)
    stare.scor = stare.stare_aleasa.scor
    return stare


def alpha_beta(alpha, beta, stare):
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.scor = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    if alpha > beta:
        return stare  # este intr-un interval invalid deci nu o mai procesez

    stare.mutari_posibile = stare.mutari()

    if stare.j_curent == Joc.JMAX:
        scor_curent = float("-inf")

        for mutare in stare.mutari_posibile:
            # calculeaza scorul
            stare_noua = alpha_beta(alpha, beta, mutare)

            if scor_curent < stare_noua.scor:
                stare.stare_aleasa = stare_noua
                scor_curent = stare_noua.scor
            if alpha < stare_noua.scor:
                alpha = stare_noua.scor
                if alpha >= beta:
                    break

    elif stare.j_curent == Joc.JMIN:
        scor_curent = float("inf")

        for mutare in stare.mutari_posibile:

            stare_noua = alpha_beta(alpha, beta, mutare)

            if scor_curent > stare_noua.scor:
                stare.stare_aleasa = stare_noua
                scor_curent = stare_noua.scor

            if beta > stare_noua.scor:
                beta = stare_noua.scor
                if alpha >= beta:
                    break
    stare.scor = stare.stare_aleasa.scor

    return stare


def afis_daca_final(stare_curenta):
    final = stare_curenta.tabla_joc.final()
    if final:
        if final == "remiza":
            print("Remiza!")
        else:
            print("A castigat " + final)

        return True

    return False


class Buton:
    def __init__(
        self,
        display=None,
        left=0,
        top=0,
        w=0,
        h=0,
        culoareFundal=(53, 80, 115),
        culoareFundalSel=(89, 134, 194),
        text="",
        font="arial",
        fontDimensiune=16,
        culoareText=(255, 255, 255),
        valoare="",
    ):
        self.display = display
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
            if b.selecteazaDupacoord(coord):
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


############# ecran initial ########################
def deseneaza_alegeri(display, tabla_curenta):
    btn_alg = GrupButoane(
        top=30,
        left=30,
        listaButoane=[
            Buton(display=display, w=80, h=30, text="minimax", valoare="minimax"),
            Buton(display=display, w=80, h=30, text="alphabeta", valoare="alphabeta"),
        ],
        indiceSelectat=1,
    )
    btn_juc = GrupButoane(
        top=100,
        left=30,
        listaButoane=[
            Buton(display=display, w=35, h=30, text="x", valoare="x"),
            Buton(display=display, w=35, h=30, text="zero", valoare="0"),
        ],
        indiceSelectat=0,
    )
    ok = Buton(
        display=display,
        top=170,
        left=30,
        w=40,
        h=30,
        text="ok",
        culoareFundal=(155, 0, 55),
    )
    btn_alg.deseneaza()
    btn_juc.deseneaza()
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
                        if ok.selecteazaDupacoord(pos):
                            tabla_curenta.deseneaza_grid()
                            return btn_juc.getValoare(), btn_alg.getValoare()
        pygame.display.update()


def main():

    # setari interf grafica
    pygame.init()
    pygame.display.set_caption("4 in line")
    # dimensiunea ferestrei in pixeli
    nl = 6
    nc = 7
    w = 50
    ecran = pygame.display.set_mode(
        size=(nc * (w + 1) - 1, nl * (w + 1) - 1)
    )  # N *100+ N-1= N*(100+1)-1
    Joc.initializeaza(ecran, NR_LINII=nl, NR_COLOANE=nc, dim_celula=w)

    # initializare tabla
    tabla_curenta = Joc()
    Joc.JMIN, tip_algoritm = deseneaza_alegeri(ecran, tabla_curenta)
    print(Joc.JMIN, tip_algoritm)

    Joc.JMAX = "0" if Joc.JMIN == "x" else "x"

    print("Tabla initiala")
    print(str(tabla_curenta))

    # creare stare initiala
    stare_curenta = Stare(tabla_curenta, "x", ADANCIME_MAX)

    tabla_curenta.deseneaza_grid()
    while True:
        if stare_curenta.j_curent == Joc.JMIN:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    pygame.quit()
                    sys.exit()
                elif event.type == pygame.MOUSEMOTION:
                    pos = pygame.mouse.get_pos()  # coordonatele cursorului
                    for np in range(len(Joc.celuleGrid)):
                        if Joc.celuleGrid[np].collidepoint(pos):

                            stare_curenta.tabla_joc.deseneaza_grid(
                                coloana_marcaj=np % Joc.NR_COLOANE
                            )
                            break
                elif event.type == pygame.MOUSEBUTTONDOWN:
                    pos = pygame.mouse.get_pos()  # coordonatele cursorului

                    for np in range(len(Joc.celuleGrid)):
                        if Joc.celuleGrid[np].collidepoint(pos):
                            coloana = np % Joc.NR_COLOANE
                            if stare_curenta.tabla_joc.matr[0][coloana] == Joc.GOL:
                                niv = 0
                                while True:
                                    if (
                                        niv == Joc.NR_LINII
                                        or stare_curenta.tabla_joc.matr[niv][coloana]
                                        != Joc.GOL
                                    ):
                                        stare_curenta.tabla_joc.matr[niv - 1][
                                            coloana
                                        ] = Joc.JMIN
                                        stare_curenta.tabla_joc.ultima_mutare = (
                                            niv - 1,
                                            coloana,
                                        )
                                        break
                                    niv += 1

                                # afisarea starii jocului in urma mutarii utilizatorului
                                print("\nTabla dupa mutarea jucatorului")
                                print(str(stare_curenta))

                                stare_curenta.tabla_joc.deseneaza_grid(
                                    coloana_marcaj=coloana
                                )
                                # testez daca jocul a ajuns intr-o stare finala
                                # si afisez un mesaj corespunzator in caz ca da
                                if afis_daca_final(stare_curenta):
                                    break

                                # S-a realizat o mutare. Schimb jucatorul cu cel opus
                                stare_curenta.j_curent = Joc.jucator_opus(
                                    stare_curenta.j_curent
                                )

        # --------------------------------
        else:  # jucatorul e JMAX (calculatorul)
            # Mutare calculator

            # preiau timpul in milisecunde de dinainte de mutare
            t_inainte = int(round(time.time() * 1000))
            if tip_algoritm == "minimax":
                stare_actualizata = min_max(stare_curenta)
            else:  # tip_algoritm=="alphabeta"
                stare_actualizata = alpha_beta(-500, 500, stare_curenta)
            stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc

            print("Tabla dupa mutarea calculatorului\n" + str(stare_curenta))

            # preiau timpul in milisecunde de dupa mutare
            t_dupa = int(round(time.time() * 1000))
            print(
                'Calculatorul a "gandit" timp de '
                + str(t_dupa - t_inainte)
                + " milisecunde."
            )

            stare_curenta.tabla_joc.deseneaza_grid()
            if afis_daca_final(stare_curenta):
                break

            # S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = Joc.jucator_opus(stare_curenta.j_curent)


if __name__ == "__main__":
    main()
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
