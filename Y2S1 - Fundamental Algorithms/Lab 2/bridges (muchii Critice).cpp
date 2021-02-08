//Muchii critice / Bridges
#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;

int n, m;

vector<int>* adj = NULL;

int* nivel; // nivel[i] = nivelul nodului i in arborele DF
int* niv_min; // niv_min[i] = nivelul minim la care se inchide un ciclu elementar
              // care contine varful i (printr-o muchie de intoarcere)
int* viz;

// *** o muchie de intoarcere nu poate sa fie critica *** 
// *** o muchie de avansare ij e critica <=> niv_min[j] > nivel[i] 
// (deci practic nu e inclusa intr-un ciclu inchis de o muchie de intoarcere) ***

void read()
{
    ifstream f("graf.in");
    f >> n >> m;
    adj = new vector<int>[n + 1];
    for (int i = 0; i < m; i++)
    {
        int x, y;
        f >> x >> y;
        adj[x].push_back(y);
        adj[y].push_back(x);
    }
    f.close();
}

void df(int i) {

    viz[i] = 1;
    niv_min[i] = nivel[i];

    for (int j : adj[i]) {
        if (viz[j] == 0) {
            //ij muchie de avansare
            nivel[j] = nivel[i] + 1;
            df(j);

            //actualizare niv_min[i]
            niv_min[i] = min(niv_min[i], niv_min[j]);

            //test ij e muchie critica
            if (niv_min[j] > nivel[i])
                cout << i << " " << j << endl;
        }
        else {
            if (nivel[j] < nivel[i] - 1) {
                //ij muchie de intoarcere

                //actualizare niv_min[i]
                niv_min[i] = min(niv_min[i], nivel[j]);
            }
        }
    }

}

int main()
{
    read();

    nivel = new int[n + 1];
    niv_min = new int[n + 1];
    viz = new int[n + 1];

    for (int i = 1; i <= n; i++) {
        nivel[i] = -1;
        niv_min[i] = -1;
        viz[i] = 0;
    }

    nivel[1] = 1;
    df(1);
}

