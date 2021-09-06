import numpy as np
import matplotlib.pyplot as plt
from shapely.geometry import LineString


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __gt__(self, other):  # pentru argmax
        if self.x > other.x:
            return True
        return False

    def getPair(self):
        return self.x, self.y


def read():
    with open("data/1_in.txt") as f:
        n = int(f.readline())
        points = [Point(float(line[0]), float(line[1])) for i in range(n) if (line := f.readline().split())]
        m = int(f.readline())
        testPoints = [Point(float(line[0]), float(line[1])) for i in range(m) if (line := f.readline().split())]
    return points, testPoints


def showFigure(points, Q, R, result):
    names = [f"P{i + 1}" for i in range(len(points))]
    x = [i.x for i in points]
    y = [i.y for i in points]
    fig, ax = plt.subplots()
    ax.scatter(x, y)  # afisam toate punctele
    for i, txt in enumerate(names):
        ax.annotate(txt, (x[i], y[i]))  # le numerotam
    ax.plot(x + [x[0]], y + [y[0]], color='blue')
    ax.scatter(Q.x, Q.y, color="red")
    ax.annotate("Q", (Q.x, Q.y))
    ax.scatter(R.x, R.y, color="red")
    ax.annotate("R", (R.x, R.y))
    ax.plot([Q.x, R.x], [Q.y, R.y], color='red')
    ax.set_title(result)
    plt.show()


def testOrientare(p, q, r):
    matrix = np.asarray([[1, 1, 1], [p.x, q.x, r.x], [p.y, q.y, r.y]])
    det = np.linalg.det(matrix)
    if -epsilon <= det <= epsilon:
        return "Coliniare"
    if det < -epsilon:
        return "Dreapta"
    return "Stanga"


def pozitieRelativa(polygon, Q):
    # formam segmentul QR, paralel cu Ox, unde R are coordonata x
    # egala cu maximul dintre:
    #   coordonata x a celui mai din dreapta punct + 1
    #   coordonata x a lui Q + 1
    x, y = max(polygon).getPair()
    R = Point(max(x + 1, Q.x + 1), Q.y)
    QR = LineString([Q.getPair(), R.getPair()])

    intersectii = 0
    # parcurgem toate muchiile din poligon
    for i in range(len(polygon)):
        A = polygon[i]
        j = (i + 1) % len(polygon)
        B = polygon[j]

        # daca A, B, Q coliniare si Q e pe AB => pe poligon
        if testOrientare(A, Q, B) == "Coliniare" and min(A.x, B.x) <= Q.x <= max(A.x, B.x) and \
                min(A.y, B.y) <= Q.y <= max(A.y, B.y):
            return "se afla pe poligon", R

        # daca Q, A, B, R coliniare si AB se afla pe QR, nu se numara
        elif testOrientare(Q, A, B) == testOrientare(A, B, R) == "Coliniare" and \
                Q.x <= A.x <= R.x and Q.x <= B.x <= R.x:
            continue

        # daca Q, A, R coliniare si punctele adiacente cu A sunt mai jos decat A, nu se numara
        elif testOrientare(Q, A, R) == "Coliniare":
            # luam punctele adiacente
            p1 = polygon[i-1]  # ar trebui sa mearga si pe cazul in care A = polygon[0], deci p1 = polygon[-1]
            p2 = B
            if A.y > p1.y and A.y > p2.y:
                continue
            else:
                intersectii += 1

        else:
            AB = LineString([A.getPair(), B.getPair()])
            if not AB.intersection(QR).is_empty:  # daca AB si QR se intersecteaza
                intersectii += 1

    if intersectii % 2 == 0:
        return "se afla in exteriorul poligonului", R
    return "se afla in interiorul poligonului", R


if __name__ == "__main__":
    polygon, testPoints = read()
    epsilon = 0.00001  # eroarea
    f = open("data/1_out.txt", "w+")
    for point in testPoints:
        result, R = pozitieRelativa(polygon, point)
        showFigure(polygon, point, R, "Q " + result)
        f.write(f"({point.x}, {point.y}) - {result}\n")
    f.close()