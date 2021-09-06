import numpy as np
import matplotlib.pyplot as plt


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y


def read():
    with open("1.in") as f:
        nrTests = int(f.readline())
        tests = []
        for i in range(nrTests):
            points = []
            for j in range(3):
                line = f.readline().split()
                x = float(line[0])
                y = float(line[1])
                points.append(Point(x, y))
            tests.append(points)
    return tests


def testOrientare(p, q, r):
    matrix = np.asarray([[1, 1, 1], [p.x, q.x, r.x], [p.y, q.y, r.y]])
    det = np.linalg.det(matrix)
    if det == 0:
        return "Coliniare"
    if det < 0:
        return "Dreapta"
    if det > 0:
        return "Stanga"


def printTest(test, orientation):
    names = ["P", "Q", "R"]
    x = [i.x for i in test]
    y = [i.y for i in test]
    fig, ax = plt.subplots()
    ax.scatter(x, y)  # punctele
    for i, txt in enumerate(names):
        ax.annotate(txt, (x[i], y[i]))  # le dam nume
    ax.plot([x[0], x[1]], [y[0], y[1]])  # segmentul PQ
    ax.set_title(orientation)  # rezultatul testului de orientare
    plt.show()


tests = read()
g = open("1.out", "w")

for test in tests:
    orientation = testOrientare(*test)
    printTest(test, orientation)
    g.write(orientation + "\n")
g.close()
