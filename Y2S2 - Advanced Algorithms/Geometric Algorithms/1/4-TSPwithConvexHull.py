import math
import numpy as np
import matplotlib.pyplot as plt


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __lt__(self, other):
        if self.x < other.x:
            return True
        if self.x == other.x and self.y < other.y:
            return True
        return False

    def __str__(self):
        return f"{self.x} {self.y}\n"


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


def read():
    with open("4.in") as f:
        n = int(f.readline())
        points = [Point(float(line.split()[0]), float(line.split()[1])) for line in f.readlines()]
    return points


def orientation(p, q, r):
    matrix = np.asarray([[1, 1, 1], [p.x, q.x, r.x], [p.y, q.y, r.y]])
    det = np.linalg.det(matrix)
    if det == 0:
        return 0
    if det < 0:
        return -1  # dreapta
    if det > 0:
        return 1  # stanga


def convexHull(points):
    points.sort()
    copy = points.copy()
    frontieraInferioara = frontier(copy)
    copy.reverse()
    frontieraSuperioara = frontier(copy)
    return frontieraInferioara + frontieraSuperioara[1:len(frontieraSuperioara)-1]


def frontier(points):
    front = [points[0], points[1]]
    i = 2
    while i < len(points):
        front.append(points[i])
        while len(front) >= 3 and orientation(front[-3], front[-2], front[-1]) != 1:
            # daca virajul nu este la stanga, eliminam varful anterior
            front.pop(-2)
        i += 1
    return front


def distance(a , b):
    return math.sqrt((b.x - a.x)**2 + (b.y - a.y)**2)


def computeRatio(a, b, r):  # (C ir + C rj) / C ij
    return (distance(a, r) + distance(r, b))/distance(a, b)


def computeDistance(a, b, r):  # C ir + C rj - C ij
    return distance(a, r) + distance(r, b) - distance(a, b)


points = read()
# step 1:
subTour = convexHull(points)  # the initial sub-tour is the convex hull
hull = subTour.copy()  # for the final figure
inside = set([i for i in points if i not in subTour])  # the points not in the hull - set so it s easier to remove

# step 5:
while len(subTour) != len(points):
    # step 2:
    dict = {}  # r -> (i,j)
    for r in inside:
        minDist = float("inf")
        bestPair = (0, 0)  # (i, j)
        for i in range(len(subTour)):
            j = (i+1) % len(subTour)
            dist = computeDistance(subTour[i], subTour[j], r)  # C ir + C rj - C ij
            if dist < minDist:
                minDist = dist
                bestPair = (i, j)  # perechea (i,j) pentru care C ir + C rj - C ij e minima
        dict[r] = bestPair
    # step 3:
    minRatio = float('inf')
    rStar = None  # r*
    bestPair = (0, 0)  # (i*, j*)
    for r in dict.keys():
        pair = dict[r]  # (i,j)
        ratio = computeRatio(subTour[pair[0]], subTour[pair[1]], r)
        if ratio < minRatio:
            minRatio = ratio
            rStar = r
            bestPair = pair
    # step 4:
    subTour.insert(bestPair[0] + 1, rStar)
    inside.remove(rStar)

showFigure(subTour, hull)

with open("4.out", "w") as f:
    for point in subTour:
        f.write(str(point))