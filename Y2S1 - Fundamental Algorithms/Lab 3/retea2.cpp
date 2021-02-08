#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <unordered_map>
#include <algorithm>
#include <cmath>

using namespace std;

struct nod {
    int x = -1, y = -1;
    string tip;
};

double dist(int x1, int y1, int x2, int y2) {
    return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
}

int find(int x, int* tata) {
    while (tata[x] != 0)
        x = tata[x];
    return x;
}

void Union(int x, int y, int* tata, int* inaltime) {
    int reprez1 = find(x, tata);
    int reprez2 = find(y, tata);
    if (inaltime[reprez1] > inaltime[reprez2]) {
        tata[reprez2] = reprez1;
    }
    else if (inaltime[reprez1] < inaltime[reprez2]) {
        tata[reprez1] = reprez2;
    }
    else {
        tata[reprez1] = reprez2;
        inaltime[reprez2]++;
    }
}

void kruskal(int n, vector<pair<double, pair<int, int>>>& muchii, unordered_map<int, nod>& noduri) {
    sort(muchii.begin(), muchii.end());
    double total = 0;
    list<pair<int, int>>apcm; //Arborele partial de cost minim
    int* tata = new int[n + 1];
    int* inaltime = new int[n + 1];
    for (int i = 1; i <= n; i++) {
        inaltime[i] = tata[i] = 0;
    }
    for (auto m : muchii) {
        int x = m.second.first;
        int y = m.second.second;
        //verificam daca sa le unim doar daca cel putin un nod e bloc
        //adica ignoram muchiile centrala - centrala
        if (find(x, tata) != find(y, tata)) {
            Union(x, y, tata, inaltime);
            apcm.push_back({ x,y });
            total += m.first;
        }

    }
    ofstream g("retea2.out");
    g << total << endl;
    for (auto m : apcm) {
        //nu afisam muchiile dintre centrale
        if (noduri[m.first].tip != "centrala" || noduri[m.second].tip != "centrala")
            g << m.first << " " << m.second << endl;
    }
    delete[] tata;
    delete[] inaltime;
}

int main()
{

    ifstream f("retea2.in");
    int n, m, e;
    //n nr centrale
    //m nr blocuri
    //e nr cladiri care pot fi conectate in mod direct
    f >> n >> m >> e;
    unordered_map<int, nod>noduri; // nr nod -> nodul efectiv
    vector<pair<double, pair<int, int>>>muchii; //dist nod1 nod2
    for (int i = 1; i <= n + m; i++) {
        nod nodLocal;
        f >> nodLocal.x >> nodLocal.y;
        if (i <= n) {
            nodLocal.tip = "centrala";
        }
        else {
            nodLocal.tip = "bloc";
        }
        noduri[i] = nodLocal;
    }
    for (int i = 0; i < e; i++) {
        int x, y;
        f >> x >> y;
        double d = dist(noduri[x].x, noduri[x].y, noduri[y].x, noduri[y].y);
        if (noduri[x].tip == "centrala" && noduri[y].tip == "centrala") {
            d = 0;
            //muchiile dintre centrale le facem 0
            //dar le ignoram la printare
            //asta ne permite sa avem o componenta conexa pt fiecare centrala
        }
        muchii.push_back({ d, {x,y} });
    }
    kruskal(n + m, muchii, noduri);
    return 0;
}

