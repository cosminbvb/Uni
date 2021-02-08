#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <queue>

using namespace std;

void readMatrix(int& n, int& m, int**& adiacenta, bool orientat, string fisier) {

    ifstream f(fisier);
    f >> n >> m;
    adiacenta = new int* [n + 1];
    for (int i = 1; i <= n; i++) {
        adiacenta[i] = new int[n + 1];
    }
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            adiacenta[i][j] = 0;
        }
    }
    int x, y;
    for (int i = 1; i <= m; i++) {
        f >> x >> y;
        if (orientat) {
            adiacenta[x][y] = 1;
        }
        else {
            adiacenta[x][y] = adiacenta[y][x] = 1;
        }
    }
    f.close();
}

void printMatrix(int n, int** adiacenta) {
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            cout << adiacenta[i][j] << " ";
        }
        cout << endl;
    }
}

void readList(int& n, int& m, vector<int>*& list, bool orientat, string fisier) {

    ifstream f(fisier);
    int x, y;
    f >> n >> m;
    list = new vector<int>[n + 1];
    for (int i = 1; i <= m; i++) {
        f >> x >> y;
        if (orientat) {
            list[x].push_back(y);
        }
        else {
            list[x].push_back(y);
            list[y].push_back(x);
        }
    }
    f.close();
}

void printList(int n, vector<int>* list) {
    for (int i = 1; i <= n; i++) {
        cout << i << ": ";
        for (unsigned j = 0; j < list[i].size(); j++) {
            cout << list[i][j] << " ";
        }
        cout << endl;
    }
}

void listToMatrix(int n, int m, vector<int>* list, int**& adiacenta, bool orientat) {

    adiacenta = new int* [n + 1];
    for (int i = 1; i <= n; i++) {
        adiacenta[i] = new int[n + 1];
    }
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            adiacenta[i][j] = 0;
        }
    }
    for (int i = 1; i <= n; i++) {
        for (unsigned j = 0; j < list[i].size(); j++) {
            if (orientat) {
                adiacenta[i][list[i][j]] = 1;
            }
            else {
                adiacenta[i][list[i][j]] = 1;
                adiacenta[list[i][j]][i] = 1;
            }
        }
    }
}

int main()
{
    string fisier = "graf.in";
    int** adiacenta = NULL;
    int n = 0, m = 0;

    //A.1 + A.3
    readMatrix(n, m, adiacenta, false, fisier);
    printMatrix(n, adiacenta);

    cout << endl;

    vector<int>* lista = NULL;

    //A.2 + A.3
    readList(n, m, lista, false, fisier);
    printList(n, lista);

    cout << endl;

    //A.4
    int** adiacenta2 = NULL;
    listToMatrix(n, m, lista, adiacenta2, false);
    printMatrix(n, adiacenta2);

    //todo - dezalocare pt adiacenta, adiacenta2 si lista

    return 0;
}