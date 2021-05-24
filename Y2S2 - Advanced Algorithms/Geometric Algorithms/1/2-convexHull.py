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
    with open("2.in") as f:
        n = int(f.readline())
        points = [Point(float(line.split()[0]), float(line.split()[1])) for line in f.readlines()]
    return points


def showFigure(points, hull):
    names = [f"P{i+1}" for i in range(len(points))]
    # x, y = vectorii coordonatelor tuturor punctelor
    # xh, yh = -//-                 punctelor de pe acoperire
    x = [i.x for i in points]
    y = [i.y for i in points]
    xh = [i.x for i in hull]
    yh = [i.y for i in hull]
    fig, ax = plt.subplots()
    ax.scatter(x, y)  # afisam toate punctele
    for i, txt in enumerate(names):
        ax.annotate(txt, (x[i], y[i]))  # le numerotam
    ax.plot(x+[x[0]], y+[y[0]], color='blue', lw=3.0)
    ax.plot(xh+[xh[0]], yh+[yh[0]], color='red', lw=1.0)  # trasam acoperirea convexa
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


def convexHull():
    # OBS: P1, P2 . . . Pn reprezinta un poligon parcurs ın sens trigonometric =>
    # nu mai avem nevoie sa ordonam punctele
    # si fiind date in sens trigonometric, nu mai trebuie sa calculam separat frontiera inferioara si superioara
    # In mod normal, la Graham Scan punctele se dau in mod aleator si avem nevoie de o sortare care ne da complexitatea
    # algoritmului (O(nlogn)). Deci putem aplica restul algoritmului (putin diferit), care are o complexitate liniara
    points = read()
    first = np.argmin(points)  # punctul din stanga-jos
    pointsCopy = points.copy()  # pentru a avea in desen numerotarea initiala
    points = points[first:] + points[:first]  # reordonam lista punctelor a.i. sa inceapa cu first
    hull = [points[0], points[1]]
    i = 2
    while i < len(points):
        hull.append(points[i])
        while len(hull) >= 3 and orientation(hull[-3], hull[-2], hull[-1]) != 1:
            # daca virajul nu este la stanga, eliminam varful anterior
            hull.pop(-2)
        i += 1

    showFigure(pointsCopy, hull)

    with open("2.out", "w") as f:
        for point in hull:
            f.write(str(point))


convexHull()

