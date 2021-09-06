#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <queue>

using namespace std;

void distManhattan(const string fisierIn, const string fisierOut) {

    //bfs in matrice

    ifstream f(fisierIn);
    ofstream g(fisierOut);
    int n, m;
    f >> n >> m;
    int** matrice = new int* [n];
    for (int i = 0; i < n; i++) {
        matrice[i] = new int[m];
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            f >> matrice[i][j];
        }
    }

    int x, y;
    vector <pair<int, int>> M;
    while (f >> x >> y) {
        x--; y--; //indexarea din fisier se face de la 1
        M.push_back({ x,y });
    }

    vector<pair<pair<int, int>, int>> rezultat;

    int** copie = new int* [n];
    for (int i = 0; i < n; i++) {
        copie[i] = new int[m];
    }

    for (auto q : M) {
        //pentru fiecare q 
        //avem nev de o copie a matricei
        //in copie[i][j] retinem -(distanta pana la q)
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                copie[i][j] = matrice[i][j];
            }
        }
        queue<pair<int, int>> queue;
        queue.push(q);
        //presupunem ca punctul de plecare are valoarea 0
        //qx si qy sunt coordonatele punctului de plecare q
        int qx = q.first;
        int qy = q.second;
        while (queue.size() > 0) {
            int x = queue.front().first;
            int y = queue.front().second;
            queue.pop();
            //pentru fiecare vecin verificam daca:
            //se afla in matrice
            //daca are valoarea 1, am gasit cel mai apropiat 1
            //daca are valoarea 0, n-a fost vizitat deci il adaugam in coada
            if (y - 1 >= 0) {
                if (copie[x][y - 1] == 1) {
                    pair<pair<int, int>, int> rez;
                    rez.first = { x, y - 1 };
                    rez.second = -copie[x][y] + 1;
                    rezultat.push_back(rez);
                    break;
                }
                if (copie[x][y - 1] == 0 && (x != qx || (y - 1) != qy)) {
                    queue.push({ x, y - 1 });
                    copie[x][y - 1] = copie[x][y] - 1;
                }
            }
            if (x - 1 >= 0) {
                if (copie[x - 1][y] == 1) {
                    pair<pair<int, int>, int> rez;
                    rez.first = { x - 1, y };
                    rez.second = -copie[x][y] + 1;
                    rezultat.push_back(rez);
                    break;
                }
                if (copie[x - 1][y] == 0 && ((x - 1) != qx || y != qy)) {
                    queue.push({ x - 1, y });
                    copie[x - 1][y] = copie[x][y] - 1;
                }
            }
            if (y + 1 <= m - 1) {
                if (copie[x][y + 1] == 1) {
                    pair<pair<int, int>, int> rez;
                    rez.first = { x, y + 1 };
                    rez.second = -copie[x][y] + 1;
                    rezultat.push_back(rez);
                    break;
                }
                if (copie[x][y + 1] == 0 && (x != qx || (y + 1) != qy)) {
                    queue.push({ x, y + 1 });
                    copie[x][y + 1] = copie[x][y] - 1;
                }
            }
            if (x + 1 <= n - 1) {
                if (copie[x + 1][y] == 1) {
                    pair<pair<int, int>, int> rez;
                    rez.first = { x + 1, y };
                    rez.second = -copie[x][y] + 1;
                    rezultat.push_back(rez);
                    break;
                }
                if (copie[x + 1][y] == 0 && ((x + 1) != qx || y != qy)) {
                    queue.push({ x + 1, y });
                    copie[x + 1][y] = copie[x][y] - 1;
                }
            }
        }
        //trebuie sa curatam queue-ul daca s-a iesit cu break din bfs
        while (queue.size() > 0) {
            queue.pop();
        }
    }
    for (auto i : rezultat) {
        g << i.second << " " << "[" << i.first.first + 1 << ", " << i.first.second + 1 << "]" << endl;
    }
    for (int i = 0; i < n; i++) {
        delete[] matrice[i];
    }
    delete[] matrice;
    for (int i = 0; i < n; i++) {
        delete[] copie[i];
    }
    delete[] copie;
}


int main()
{
    distManhattan("graf.in", "graf.out");

    return 0;
}