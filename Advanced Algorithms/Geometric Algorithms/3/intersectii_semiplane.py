def read():
    f = open("data/1_in.txt", "r")
    nrTests = int(f.readline())
    tests = []
    for i in range(nrTests):
        coefSemiplane = []
        nrSemip = int(f.readline())
        for j in range(nrSemip):
            coefSemiplane.append([float(x) for x in f.readline().split()])
        tests.append(coefSemiplane)
    f.close()
    return tests


def intersectie(semiplane):
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
        return "intersectia vida\n"
    elif minX == float('-inf') or maxX == float('inf') or minY == float('-inf') or maxY == float('inf'):
        return "intersectia nevida, nemarginita\n"
    else:
        return "intersectia nevida, marginita\n"


if __name__ == "__main__":
    f = open("data/1_out.txt", "w+")
    tests = read()
    for test in tests:
        f.write(intersectie(test))
    f.close()
