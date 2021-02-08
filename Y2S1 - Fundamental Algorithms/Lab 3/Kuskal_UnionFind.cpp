#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <list>
using namespace std;

//Kruskal cu Union/Find => O(m logn)

void read(int& n, int& m, vector<pair<int, pair<int, int>>>& muchii) {
    ifstream f("grafpond.in");
    f >> n >> m;
    muchii.resize(m);
    int x, y, p;
    for (int i = 0; i < m; i++) {
        f >> x >> y >> p;
        muchii[i] = { p,{x,y} };
    }
    f.close();
}

int find(int x, int* tata) {
    while (tata[x] != 0)
        x = tata[x];
    return x;
}

void Union(int x, int y, int* tata, int* inaltime) {  //Unim 2 arbori
    //Arborele cu h mai mica devine subarbore pt celalalt
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

void kruskal(int n, int m, vector<pair<int, pair<int, int>>>& muchii) {
    sort(muchii.begin(), muchii.end()); //sortam muchiile dupa pondere
    list<pair<int, int>>apcm; //Arborele partial de cost minim
    int* tata = new int[n + 1];
    int* inaltime = new int[n + 1];
    for (int i = 1; i <= n; i++) {
        inaltime[i] = tata[i] = 0;
    }
    for (auto m : muchii) {
        int x = m.second.first;
        int y = m.second.second;
        if (find(x, tata) != find(y, tata)) { //x si y sunt din 2 componente conexe diferite (
            Union(x, y, tata, inaltime);
            apcm.push_back({ x,y });
        }
    }
    for (auto m : apcm) {
        cout << m.first << " " << m.second << endl;
    }
    delete[] tata;
    delete[] inaltime;
}

int main()
{
    int n, m;
    vector<pair<int, pair<int, int>>> muchii; //(pondere,(x,y)), unde (x,y) = muchie
    read(n, m, muchii);
    kruskal(n, m, muchii);
    return 0;

}

