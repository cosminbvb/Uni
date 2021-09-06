import sys
import os
import A_star  # contine algoritmii A*, A* optimizat, IDA* si structura de graf de cautare
import UCS  # contine algoritmul UCS si structura de graf de cautare


def read(file):
    with open(file, 'r') as f:
        matrix = []
        row = f.readline().strip().split()
        matrix.append(row)
        k = len(row) // 2  # number of columns
        for line in f:  # reading the rest of the class until hitting "suparati"
            if line.strip() == "suparati":
                break
            else:
                matrix.append(line.strip().split())
        mad = []
        for line in f:  # reading the bad pairs until hitting "ascultati:"
            if line.strip() == "ascultati:":
                break
            else:
                mad.append(line.strip().split())

        line = f.readline().strip().split()
        M = int(line[0])
        if len(line) != 1:
            ascultati = line[1:]
        else:
            ascultati = []
        mesaj = []
        for line in f:  # citim copiii ascultati pana intalnim mesaj
            if line.strip().startswith("mesaj"):
                msj = line.split("mesaj:")[1].strip().split("->")
                mesaj.append(msj[0].strip())  # sender
                mesaj.append(msj[1].strip())  # receiver
                break
            else:
                ascultati.append(line.strip())
        return matrix, k, mad, M, ascultati, mesaj


if __name__ == "__main__":
    # arg 0 - script
    # arg 1 - folder in
    # arg 2 - folder out
    # arg 3 - NSOL (solution number)
    # arg 4 - timeout
    # ex apelare: C:\fac\An2-Sem2\Lab AI\RC\Tema 1>py main.py input output 2 1
    inputFolder = sys.argv[1]
    outputFolder = sys.argv[2]
    nSol = int(sys.argv[3])
    timeout = int(sys.argv[4])  # in secunde

    inputFilesNames = [name for name in os.listdir(inputFolder) if os.path.isfile(os.path.join(inputFolder, name))]
    # lista numelor fisierelor de input (doar fisiere)

    for file in inputFilesNames:
        inputFile = os.path.join(inputFolder, file)  # calea fisierului de intrare
        fileInfo = read(inputFile)  # citim fisierul de intrare si construim graful cu acele informatii

        # pentru fiecare algoritm, construim graful si il apelam:

        """"""""" UCS """""""""
        outputFile = os.path.join(outputFolder, "ucs_" + file)  # calea fisierul de iesire
        g = open(outputFile, 'w+')
        graf = UCS.Graph(fileInfo, g)
        UCS.NodParcurgere.gr = graf
        timeResult = UCS.UCS(graf, nSol, timeout=timeout)
        if timeResult == "TLE":
            print(file + " - UCS : TLE")
            g.write("\nTLE\n")
        else:
            print(file + " - UCS : Success")
        g.close()

        """"""""" A* """""""""
        outputFile = os.path.join(outputFolder, "a_star_" + file)  # calea fisierul de iesire
        g = open(outputFile, 'w+')
        graf = A_star.Graph(fileInfo, g)
        A_star.NodParcurgere.gr = graf
        timeResult = A_star.a_star(graf, nrSolutiiCautate=nSol, tip_euristica="euristica admisibila 2",
                                   timeout=timeout)  # functia intoarce "TLE" daca nu a rezolvat problema in timp
        if timeResult == "TLE":
            print(file + " - A* : TLE")
            g.write("\nTLE\n")
        else:
            print(file + " - A* : Success")
        g.close()

        """"""""" A* optimizat """""""""
        outputFile = os.path.join(outputFolder, "a_star_opt_" + file)
        g = open(outputFile, 'w+')
        graf = A_star.Graph(fileInfo, g)
        A_star.NodParcurgere.gr = graf
        timeResult = A_star.a_star_optimizat(graf, tip_euristica="euristica admisibila 2", timeout=timeout)
        if timeResult == "TLE":
            print(file + " - A*OPT : TLE")
            g.write("\nTLE\n")
        else:
            print(file + " - A*OPT : Success")
        g.close()

        """"""""" IDA* """""""""
        outputFile = os.path.join(outputFolder, "ida_star_" + file)
        g = open(outputFile, 'w+')
        graf = A_star.Graph(fileInfo, g)
        A_star.NodParcurgere.gr = graf
        timeResult = A_star.ida_star(graf, nrSolutiiCautate=nSol, tip_euristica="euristica admisibila 2",
                                     timeout=timeout)
        if timeResult == "TLE":
            print(file + " - IDA* : TLE")
            g.write("\nTLE\n")
        else:
            print(file + " - IDA* : Success")
        g.close()
