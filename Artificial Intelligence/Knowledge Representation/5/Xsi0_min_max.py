import time
import copy

ADANCIME_MAX = 6


def elem_identice(lista):
    if len(set(lista)) == 1:
        castigator = lista[0]
        if castigator != Joc.GOL:
            return castigator
    return False


class Joc:
    """
    Clasa care defineste jocul. Se va schimba de la un joc la altul.
    """

    NR_COLOANE = 3
    JMIN = None
    JMAX = None
    GOL = "#"

    def __init__(self, tabla=None):  # Joc()
        if tabla is not None:
            self.matr = tabla
        else:
            self.matr = [Joc.GOL] * self.NR_COLOANE ** 2
            print(self.matr)

    @classmethod
    def jucator_opus(cls, jucator):
        if jucator == cls.JMIN:
            return cls.JMAX
        else:
            return cls.JMIN

    def final(self):  # [0,1,2,3,4,5,6,7,8]
        """
        012
        345
        678
        """
        # TODO: returneaza "0" sau "x" sau "remiza" in functie de castigator
        #       daca este stare finala, altfel returneaza False
        rez = (
            elem_identice(self.matr[0:3])
            or elem_identice(self.matr[3:6])
            or elem_identice(self.matr[6:9])
            or elem_identice(self.matr[0:7:3])
            or elem_identice(self.matr[1:8:3])
            or elem_identice(self.matr[2:9:3])
            or elem_identice(self.matr[0:9:4])
            or elem_identice(self.matr[2:7:2])
        )
        if rez:
            return rez
        elif Joc.GOL not in self.matr:
            return "remiza"
        else:
            return False        

    def mutari(self, jucator):  # jucator = simbolul jucatorului care muta
        l_mutari = []
        for i in range(len(self.matr)):
            if self.matr[i] == Joc.GOL:
                copie_matr = copy.deepcopy(self.matr)
                copie_matr[i] = jucator
                l_mutari.append(Joc(copie_matr))
        return l_mutari

    # linie deschisa inseamna linie pe care jucatorul mai poate forma o configuratie castigatoare
    def linie_deschisa(self, lista, jucator):
        # obtin multimea simbolurilor de pe linie
        jo = self.jucator_opus(jucator)
        # verific daca pe linia data nu am simbolul jucatorului opus
        if jo not in lista:
            return 1
        return 0

    def linii_deschise(self, jucator):
        return (
            self.linie_deschisa(self.matr[0:3], jucator)
            + self.linie_deschisa(self.matr[3:6], jucator)
            + self.linie_deschisa(self.matr[6:9], jucator)
            + self.linie_deschisa(self.matr[0:9:3], jucator)
            + self.linie_deschisa(self.matr[1:9:3], jucator)
            + self.linie_deschisa(self.matr[2:9:3], jucator)
            + self.linie_deschisa(self.matr[0:9:4], jucator)
            + self.linie_deschisa(self.matr[2:7:2], jucator)
        )

    def estimeaza_scor(self, adancime):
        # TODO: estimeaza scorul in functie de nr. de linii deschise
        t_final = self.final()
        if t_final == Joc.JMAX:
            return 99 + adancime  # adancimea e cu cat mai mica cu cat cobori in arbore
        elif t_final == Joc.JMIN:
            return -99 - adancime
        elif t_final == "remiza":
            return 0
        else:
            return self.linii_deschise(self.JMAX) - self.linii_deschise(self.JMIN)

    def __str__(self):
        sir = "  |"
        for i in range(self.NR_COLOANE):
            sir += str(i) + " "
        sir += "\n"
        sir += "-" * (self.NR_COLOANE + 1) * 2 + "\n"
        for i in range(self.NR_COLOANE):  # itereaza prin linii
            sir += (
                str(i)
                + " |"
                + " ".join(
                    [
                        str(x)
                        for x in self.matr[
                            self.NR_COLOANE * i : self.NR_COLOANE * (i + 1)
                        ]
                    ]
                )
                + "\n"
            )
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
        # TODO: returneaza lista de stari-fiice
        l_mutari = self.tabla_joc.mutari(self.j_curent)
        j_opus = Joc.jucator_opus(self.j_curent)

        l_stari_fiice = [
            Stare(mutare, j_opus, self.adancime - 1, parinte=self)
            for mutare in l_mutari
        ]

        return l_stari_fiice

    def __str__(self):
        sir = str(self.tabla_joc) + "(Juc curent:" + self.j_curent + ")\n"
        return sir


""" Algoritmul MinMax """


def min_max(stare):
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare
    
    stare.mutari_posibile = stare.mutari()
    stari_cu_estimare = [
        min_max(x) for x in stare.mutari_posibile
    ]

    if stare.j_curent == Joc.JMAX:
        stare.stare_aleasa = max(stari_cu_estimare, key=lambda x: x.estimare)
    else:
        stare.stare_aleasa = min(stari_cu_estimare, key=lambda x: x.estimare)
    
    stare.estimare = stare.stare_aleasa.estimare
    return stare


def alpha_beta(stare, alpha, beta):
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    if alpha > beta:  # nu ar trebui sa se intample
        return stare

    stare.mutari_posibile = stare.mutari()

    if stare.j_curent == Joc.JMAX:
        estimare_curenta = float("-inf")
        for mutare in stare.mutari_posibile:
            stare_actualizata = alpha_beta(mutare, alpha, beta)
            if stare_actualizata.estimare > estimare_curenta:
                estimare_curenta = stare_actualizata.estimare
                stare.stare_aleasa = stare_actualizata
            if stare_actualizata.estimare > alpha:
                alpha = stare_actualizata.estimare
                if alpha >= beta:
                    break
    else:
        estimare_curenta = float("inf")
        for mutare in stare.mutari_posibile:
            stare_actualizata = alpha_beta(mutare, alpha, beta)
            if stare_actualizata.estimare < estimare_curenta:
                estimare_curenta = stare_actualizata.estimare
                stare.stare_aleasa = stare_actualizata
            if stare_actualizata.estimare < beta:
                beta = stare_actualizata.estimare
                if alpha >= beta:
                    break

    stare.estimare = stare.stare_aleasa.estimare
    return stare


def afis_daca_final(stare_curenta):
    # metoda final() returneaza "remiza" sau castigatorul ("x" sau "0") sau False daca nu e stare finala
    final = stare_curenta.tabla_joc.final()
    if final:
        if final == "remiza":
            print("Remiza!")
        else:
            print("A castigat " + final)

        return True

    return False


def main():
    # initializare algoritm
    raspuns_valid = False

    while not raspuns_valid:
        tip_algoritm = input(
            "Algoritmul folosit? (raspundeti cu 1 sau 2)\n 1.Minimax\n 2.Alpha-beta\n "
        )
        if tip_algoritm in ["1", "2"]:
            raspuns_valid = True
        else:
            print("Nu ati ales o varianta corecta.")
    # initializare jucatori
    raspuns_valid = False
    while not raspuns_valid:
        Joc.JMIN = input("Doriti sa jucati cu x sau cu 0? ").lower()
        if Joc.JMIN in ["x", "0"]:
            raspuns_valid = True
        else:
            print("Raspunsul trebuie sa fie x sau 0.")
    Joc.JMAX = "0" if Joc.JMIN == "x" else "x"
    # expresie= val_true if conditie else val_false  (conditie? val_true: val_false)

    # initializare tabla
    tabla_curenta = Joc()
    # apelam constructorul
    print("Tabla initiala")
    print(str(tabla_curenta))

    # creare stare initiala
    stare_curenta = Stare(tabla_curenta, "x", ADANCIME_MAX)

    while True:
        if stare_curenta.j_curent == Joc.JMIN:
            # muta jucatorul
            print("Acum muta utilizatorul cu simbolul", stare_curenta.j_curent)
            raspuns_valid = False
            while not raspuns_valid:
                try:
                    linie = int(input("linie="))
                    coloana = int(input("coloana="))

                    if linie in range(Joc.NR_COLOANE) and coloana in range(
                        Joc.NR_COLOANE
                    ):
                        if (
                            stare_curenta.tabla_joc.matr[
                                linie * Joc.NR_COLOANE + coloana
                            ]
                            == Joc.GOL
                        ):
                            raspuns_valid = True
                        else:
                            print("Exista deja un simbol in pozitia ceruta.")
                    else:
                        print(
                            "Linie sau coloana invalida (trebuie sa fie unul dintre numerele 0,1,2)."
                        )

                except ValueError:
                    print("Linia si coloana trebuie sa fie numere intregi")

            # dupa iesirea din while sigur am valide atat linia cat si coloana
            # deci pot plasa simbolul pe "tabla de joc"
            stare_curenta.tabla_joc.matr[linie * Joc.NR_COLOANE + coloana] = Joc.JMIN

            # afisarea starii jocului in urma mutarii utilizatorului
            print("\nTabla dupa mutarea jucatorului")
            print(str(stare_curenta))
            # testez daca jocul a ajuns intr-o stare finala
            # si afisez un mesaj corespunzator in caz ca da
            if afis_daca_final(stare_curenta):
                break

            # S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = Joc.jucator_opus(stare_curenta.j_curent)

        # --------------------------------
        else:  # jucatorul e JMAX (calculatorul)
            # Mutare calculator

            print("Acum muta calculatorul cu simbolul", stare_curenta.j_curent)
            # preiau timpul in milisecunde de dinainte de mutare
            t_inainte = int(round(time.time() * 1000))

            # stare actualizata e starea mea curenta in care am setat stare_aleasa (mutarea urmatoare)
            if tip_algoritm == "1":
                stare_actualizata = min_max(stare_curenta)
            else:  # tip_algoritm==2
                stare_actualizata = alpha_beta(stare_curenta, -500, 500)

            # aici se face de fapt mutarea !!!
            stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc

            print("Tabla dupa mutarea calculatorului")
            print(str(stare_curenta))

            # preiau timpul in milisecunde de dupa mutare
            t_dupa = int(round(time.time() * 1000))
            print(
                'Calculatorul a "gandit" timp de '
                + str(t_dupa - t_inainte)
                + " milisecunde."
            )
            if afis_daca_final(stare_curenta):
                break

            # S-a realizat o mutare.  jucatorul cu cel opus
            stare_curenta.j_curent = Joc.jucator_opus(stare_curenta.j_curent)


if __name__ == "__main__":
    main()
