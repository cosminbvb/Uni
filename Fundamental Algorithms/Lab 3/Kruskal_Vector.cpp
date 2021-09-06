#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <list>
using namespace std;

//Kruskal cu vector de reprezentanti => O(n^2 + mlogn) 
//n^2 pentru ca se aplica op de reuniune de n-1 ori si are O(n)
//mlogn sortare

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

void kruskal(int n, int m, vector<pair<int, pair<int, int>>>& muchii) {
    sort(muchii.begin(), muchii.end());
    list<pair<int, int>>apcm; //Arborele partial de cost minim
    int* reprez = new int[n + 1];
    for (int i = 1; i <= n; i++) {
        reprez[i] = i;
    }
    for (auto m : muchii) {
        int x = m.second.first;
        int y = m.second.second;
        if (reprez[x] != reprez[y]) { //x si y sunt din 2 componente conexe diferite
            int aux = reprez[x];
            for (int i = 1; i <= n; i++) {
                if (reprez[i] == aux) {
                    reprez[i] = reprez[y];
                }
            }
            apcm.push_back({ x,y });
        }
    }
    for (auto m : apcm) {
        cout << m.first << " " << m.second << endl;
    }
    delete[] reprez;
}

int main()
{
    int n, m;
    vector<pair<int, pair<int, int>>> muchii; //(pondere,(x,y)), unde (x,y) = muchie
    read(n, m, muchii);
    kruskal(n, m, muchii);
    return 0;

}

