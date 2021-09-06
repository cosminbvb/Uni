import matplotlib.pyplot as plt


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.next = None

    def setNext(self, point):
        self.next = point


def read():
    with open("data/2_in.txt") as f:
        nrTests = int(f.readline())
        tests = []
        for i in range(nrTests):
            n = int(f.readline())
            points = [Point(float(line[0]), float(line[1])) for i in range(n) if (line := f.readline().split())]
            # am citit punctele, le-am construit si stocat in lista points
            # acum, pentru ca o sa fie mai usoara problema, sau cel putin asa mi-am imaginat,
            # construim poligonul atribuind fiecarui punct referinta punctului urmator
            # o sa avem practic o lista inlantuita circulara de puncte care de fapt reprezinta poligonul
            for j in range(n-1):
                points[j].setNext(points[j+1])
            points[-1].setNext(points[0])
            tests.append(points)
        return tests


def showFigure(poligon, title):
    names = [f"P{i+1}" for i in range(len(poligon))]
    x = [i.x for i in poligon]
    y = [i.y for i in poligon]
    fig, ax = plt.subplots()
    ax.scatter(x, y)
    for i, txt in enumerate(names):
        ax.annotate(txt, (x[i], y[i]))
    ax.plot(x+[x[0]], y+[y[0]], color='blue')
    ax.set_title(title)
    plt.show()


def xMonoton(poligon):
    # calculam punctul minim (cel mai din stanga-jos) si cel maxim (cel mai din dreapta-jos)
    min, max = poligon[0], poligon[0]
    for i, point in enumerate(poligon):
        if point.x < min.x or point.x == min.x and point.y < min.y:
            min = point
        if point.x > max.x or point.x == max.x and point.y < max.y:
            max = point

    # parcurgem poligonul de la punctul minim la cel maxim
    # si verificam daca se respecta x-monotonia:
    p1 = min
    while p1 != max:
        p2 = p1.next
        if p2.x <= p1.x:
            return "nu este x-monoton"
        p1 = p2
    # analog, in sens invers:
    p1 = max
    while p1 != min:
        p2 = p1.next
        if p2.x >= p1.x:
            return "nu este x-monoton"
        p1 = p2

    return "este x-monoton"


def yMonoton(poligon):
    # calculam punctul minim (cel mai de jos-dreapta) si cel maxim (cel mai de sus-dreapta)
    min, max = poligon[0], poligon[0]
    for i, point in enumerate(poligon):
        if point.y < min.y or point.y == min.y and point.x > min.x:
            min = point
        if point.y > max.y or point.y == max.y and point.x > max.x:
            max = point

    p1 = min
    while p1 != max:
        p2 = p1.next
        if p2.y <= p1.y:
            return "nu este y-monoton"
        p1 = p2

    p1 = max
    while p1 != min:
        p2 = p1.next
        if p2.y >= p1.y:
            return "nu este y-monoton"
        p1 = p2

    return "este y-monoton"


if __name__ == "__main__":
    tests = read()
    f = open("data/2_out.txt", "w+")
    for i, test in enumerate(tests):
        result = xMonoton(test) + "\n" + yMonoton(test)
        f.write(f"Poligonul {i+1}:\n" + result + "\n")
        showFigure(test, result)
    f.close()