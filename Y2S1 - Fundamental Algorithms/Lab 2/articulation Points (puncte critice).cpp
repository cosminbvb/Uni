//Puncte critice / Articulation Points
#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <set>
using namespace std;

int n, m;

vector<int>* adj = NULL;

int* nivel; // nivel[i] = nivelul nodului i in arborele DF
int* niv_min; // niv_min[i] = nivelul minim la care se inchide un ciclu elementar
              // care contine varful i (printr-o muchie de intoarcere)
int* viz;
int* tata;

int start;
set<int> puncte; // am folosit set pt ca daca un varf v e sters
                 // si sparge graful in mai mult de 2 componente conexe
                 // va aparea de (nr de comp conexe - 1 ori) cred
                 // si noi pt problema asta vrem doar sa afisam punct

// un varf v e critic <=> exista doua varfuri x,y != v a.i.
// v apartine oricarui x,y-lant

// in arborele DF, radacina s e punct critic <=> are cel putin 2 fii
// in arborele DF, un alt varf i din arbore e critic <=>
// are cel putin un fiu j cu niv_min[j] >= nivel[i]

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
            tata[j] = i;
            df(j);

            //actualizare niv_min[i]
            niv_min[i] = min(niv_min[i], niv_min[j]);

            //test i punct critic
            if (niv_min[j] >= nivel[i]) {
                if (i == start) {
                    //cazul cu radacina
                    int nr = 0;
                    for (int i = 1; i <= n; i++)
                    {
                        if (tata[i] == start)
                            nr++;
                    }
                    if (nr >= 2) {
                        puncte.insert(i);
                    }
                }
                else
                    puncte.insert(i);
            }
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
    tata = new int[n + 1];

    for (int i = 1; i <= n; i++) {
        nivel[i] = -1;
        niv_min[i] = -1;
        viz[i] = 0;
        tata[i] = -1;
    }

    //luam nodul de start ca fiind 1
    //daca avem mai multe componente conexe putem aplica
    //df pe nodurile nevizitate cu un for dar in cazul asta
    //pp ca graful e conex
    start = 1;
    nivel[start] = 1;
    df(start);

    for (int i : puncte) cout << i << " ";

}
/*
10 13
1 5
1 10
3 5
5 6
5 9
5 10
3 6
3 7
6 7
2 4
2 6
2 8
4 8
=> 2 5 6
*/