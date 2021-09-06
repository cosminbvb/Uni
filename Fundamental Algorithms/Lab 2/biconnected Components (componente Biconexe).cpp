#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <set>
#include <stack>
using namespace std;

int n, m;

vector<int>* adj = NULL;

int* nivel; // nivel[i] = nivelul nodului i in arborele DF
int* niv_min; // niv_min[i] = nivelul minim la care se inchide un ciclu elementar
              // care contine varful i (printr-o muchie de intoarcere)
int* viz;

int start;

stack<pair<int, int>>s;

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
            s.push({ i, j });
            df(j);

            //actualizare niv_min[i]
            niv_min[i] = min(niv_min[i], niv_min[j]);

            //test punct critic
            if (niv_min[j] >= nivel[i]) {
                //elimina din S toate muchiile pana la ij
                pair<int, int> pair = { i,j };
                while (s.top() != pair) {
                    cout << s.top().first << " " << s.top().second << " " << endl;
                    s.pop();
                }
                cout << s.top().first << " " << s.top().second << " " << endl;
                s.pop();
                cout << endl;
            }
        }
        else {
            if (nivel[j] < nivel[i] - 1) {
                //ij muchie de intoarcere

                //actualizare niv_min[i]
                niv_min[i] = min(niv_min[i], nivel[j]);
                s.push({ i,j });
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

    //luam nodul de start ca fiind 1
    //daca avem mai multe componente conexe putem aplica
    //df pe nodurile nevizitate cu un for dar in cazul asta
    //pp ca graful e conex
    start = 1;
    nivel[start] = 1;
    cout << "componente biconexe: \n";
    df(start);

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
=> 
componente biconexe:
5 6
5 3
4 5
3 4
6 3

2 6

7 8

7 1
2 7
1 2
*/