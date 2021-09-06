def read():
    f = open("data/2_in.txt", "r")
    nrTests = int(f.readline())
    tests = []
    for i in range(nrTests):
        line = f.readline().split()
        punct = [float(line[0]), float(line[1])]
        coefSemiplane = []
        nrSemip = int(f.readline())
        for j in range(nrSemip):
            semiplan = [float(x) for x in f.readline().split()]
            # pastram doar semiplanele care contin punctul
            if continePunct(punct, semiplan):
                coefSemiplane.append(semiplan)
        tests.append(coefSemiplane)
    f.close()
    return tests


def intersectie(semiplane):
    # False - intersectie vida / nemarginita
    # arie dreptunghi, altfel
    minX = minY = float('-inf')
    maxX = maxY = float('inf')

    for semiplan in semiplane:
        a, b, c = semiplan
        if a == 0:
            if b > 0:
                maxY = min(maxY, -c/b)
            else:
                minY = max(minY, -c/b)
        else:
            # b = 0 (conform ipotezei planurile sunt orizontale/verticale)
            if a > 0:
                maxX = min(maxX, -c/a)
            else:
                minX = max(minX, -c/a)

    if minX > maxX or minY > maxY:
        return False
    elif minX == float('-inf') or maxX == float('inf') or minY == float('-inf') or maxY == float('inf'):
        return False
    else:
        return (maxX-minX)*(maxY-minY)


def continePunct(punct, semiplan):
    # True daca semiplanul contine punctul dat, altfel False
    x, y = punct
    a, b, c = semiplan
    if a == 0:
        if b > 0 and y <= -c/b:
            return True
        elif y >= -c/b:  # b < 0:
            return True
    else:  # b == 0
        if a > 0 and x <= -c/a:
            return True
        elif x >= -c/a:  # a < 0
            return True


if __name__ == "__main__":
    f = open("data/2_out.txt", "w+")
    tests = read()
    for i, test in enumerate(tests):
        f.write(f"exemplul {i+1}:\n")
        rezultat = intersectie(test)
        if rezultat:
            f.write(f"(a) exista un dreptunghi cu proprietatea ceruta\n"
                    f"(b) aria minima este {rezultat}\n\n")
        else:
            f.write("(a) nu exista un dreptunghi cu proprietatea ceruta\n\n")
    f.close()
