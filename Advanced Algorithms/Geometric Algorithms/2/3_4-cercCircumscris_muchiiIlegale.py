import numpy as np


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y


def read():
    with open("data/3_in.txt") as f:
        triangle = [Point(float(line[0]), float(line[1])) for i in range(3) if (line := f.readline().split())]
        nrTests = int(f.readline())
        tests = [Point(float(line[0]), float(line[1])) for i in range(nrTests) if (line := f.readline().split())]
        return triangle, tests


def testOrientare(p, q, r):
    matrix = np.asarray([[1, 1, 1], [p.x, q.x, r.x], [p.y, q.y, r.y]])
    det = np.linalg.det(matrix)
    if -epsilon <= det <= epsilon:
        return "Coliniare"
    if det < -epsilon:
        return "Dreapta"
    return "Stanga"


if __name__ == "__main__":
    epsilon = 0.00001  # eroarea (o folosim si la testul de orientare si la formula de mai jos)
    triangle, tests = read()
    a, b, c = triangle
    if testOrientare(a, b, c) == "Dreapta":
        # pentru a aplica formula cu determinantul, ABC trebuie sa fie viraj la stanga
        # in cazul in care nu e, le inversam pe a si c
        a, c = c, a
    f = open("data/3_out.txt", "w+")
    g = open("data/4_out.txt", "w+")
    for d in tests:
        matrix = np.asarray([[a.x, b.x, c.x, d.x], [a.y, b.y, c.y, d.y],
                             [a.x**2 + a.y**2, b.x**2 + b.y**2, c.x**2 + c.y**2, d.x**2 + d.y**2],
                             [1, 1, 1, 1]])
        det = np.linalg.det(matrix)
        if -epsilon <= det <= epsilon:
            result1 = "pe cerc"
            result2 = "AC & BD legale"
        elif det > epsilon:
            result1 = "in interior"
            result2 = "AC ilegala"
        else:
            result1 = "in exterior"
            result2 = "BD ilegala"
        f.write(f"({d.x}, {d.y}) - {result1}\n")
        g.write(f"D = ({d.x}, {d.y}) - {result2}\n")
    f.close()
    g.close()
