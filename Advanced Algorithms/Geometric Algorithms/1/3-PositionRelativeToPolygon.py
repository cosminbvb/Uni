# find the position of a point relative to a convex polygon

import numpy as np
import matplotlib.pyplot as plt


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __lt__(self, other):  # pentru argmin
        if self.x < other.x:
            return True
        if self.x == other.x and self.y < other.y:
            return True
        return False

    def __str__(self):
        return f"{self.x} {self.y}\n"


def read():
    with open("3.in") as f:
        n = int(f.readline())
        points = [Point(float(line[0]), float(line[1])) for i in range(n) if (line := f.readline().split())]
        m = int(f.readline())
        testPoints = [Point(float(line[0]), float(line[1])) for i in range(m) if (line := f.readline().split())]
    return points, testPoints


def showFigure(points, point):
    names = [f"P{i}" for i in range(len(points))]
    x = [i.x for i in points]
    y = [i.y for i in points]
    fig, ax = plt.subplots()
    ax.scatter(x, y)  # afisam toate punctele
    ax.scatter(point.x, point.y, color="red")
    for i, txt in enumerate(names):
        ax.annotate(txt, (x[i], y[i]))  # le numerotam
    ax.plot(x+[x[0]], y+[y[0]], color='blue')
    plt.show()


def orientation(p, q, r):
    matrix = np.asarray([[1, 1, 1], [p.x, q.x, r.x], [p.y, q.y, r.y]])
    det = np.linalg.det(matrix)
    if det == 0:
        return 0
    if det < 0:
        return -1  # dreapta
    if det > 0:
        return 1  # stanga

# Varianta in timp liniar este efectuarea testului de orientare dintre fiecare muchie a poligonului
# (parcurs in sens trigonometric) si punctul dat.


# Varianta in timp O(logn)
def position(polygon, point):
    if len(polygon) == 3:
        # ne aflam intr-un triunghi
        # trebuie sa determinam daca ne aflam in interiorul triunghiului, pe el sau in exterior
        return positionRelativeToTriangle(polygon[0], polygon[1], polygon[2], point)

    mid = polygon[len(polygon)//2]
    orientare = orientation(polygon[0], mid, point)
    if orientare == 0:
        # punctul se afla pe dreapta dintre polygon[0] si mid
        # trebuie sa verificam daca se afla pe segment sau nu
        if not (max(polygon[0], mid) >= point.x >= min(polygon[0], mid)):
            # daca se afla in afara poligonului
            return -1
    elif orientare == 1:
        # punctul se afla la stanga diagonalei
        # trebuie sa reconstruim poligonul, cu punctele polygon[0], mid si toate celelalte care prin viraje la stanga
        # duc de la mid la polygon[0]
        newPolygon = [polygon[0]] + polygon[len(polygon)//2:]
        return position(newPolygon, point)
    else:
        # trebuie sa reconstruim poligonul, cu punctele polygon[0], mid si toate celelalte care prin viraje la dreapta
        # duc de la mid la polygon[0]
        newPolygon = polygon[:len(polygon)//2+1]
        return position(newPolygon, point)


def positionRelativeToTriangle(p1, p2, p3, x):
    o1 = orientation(p1, p2, x)
    o2 = orientation(p2, p3, x)
    o3 = orientation(p3, p1, x)
    if o1 == 0 or o2 == 0 or o3 == 0:  # daca x e pe una din laturi
        return 0
    elif o1 == o2 == o3 == 1:  # daca se afla la stanga tuturor (in parcurgere trig) => in interiorul triunghiului
        return 1
    return -1  # in exterior


polygon, testPoints = read()
f = open("3.out", "w")
for point in testPoints:
    showFigure(polygon, point)
    pos = position(polygon, point)
    if pos == 0:
        f.write("on edge\n")
    elif pos == 1:
        f.write("inside\n")
    else:
        f.write("outside\n")

