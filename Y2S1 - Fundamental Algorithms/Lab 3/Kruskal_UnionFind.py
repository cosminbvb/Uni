def read():
    f = open("grafpond.in", "r")
    line = f.readline().split()
    n, m = int(line[0]), int(line[1])
    muchii = []
    for i in range(m):
        line = f.readline().split()
        x, y, p = int(line[0]), int(line[1]), int(line[2])
        muchii.append((p, (x, y)))
    f.close()
    return n, m, muchii

def find(x, tata):
    while tata[x] != 0:
        x = tata[x]
    return x

def union(x, y, tata, inaltime):
    repr1 = find(x, tata)
    repr2 = find(y, tata)
    if inaltime[repr1] > inaltime[repr2]:
        tata[repr2] = repr1
    elif inaltime[repr1] < inaltime[repr2]:
        tata[repr1] = repr2
    else:
        tata[repr1] = repr2
        inaltime[repr2] += 1
    return tata, inaltime

def kruskal():
    apcm = []
    n, m, muchii = read()
    muchii.sort(key=lambda x: x[0])
    tata = [0]*(n+1)
    inaltime = [0]*(n+1)
    for muchie in muchii:
        x, y = muchie[1][0], muchie[1][1]
        if find(x, tata) != find(y, tata):
            tata, inaltime = union(x, y, tata, inaltime)
            apcm.append((x,y))
    print(apcm)

kruskal()

