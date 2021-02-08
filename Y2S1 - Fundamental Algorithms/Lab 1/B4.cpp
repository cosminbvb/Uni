#include <iostream>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

void bfs(vector<int>* parent, vector<int>* list, int n, int start) {

    //diferenta intre bfs-ul normal si acesta e ca
    //nu verificam daca un nod v a fost vizitat
    //verificam daca se poate ajunge la el intr-un mod mai rapid
    //daca da, stergem vechii parinti si adaugam ca parinte nodul u,
    //adica cel prin care s-a ajuns la v
    
    //daca putem ajunge prin alt mod la fel de rapid la un nod v, inseamna
    //am mai gasit o varianta, deci il adaugam pe u la parintii lui v

    //deci in final, fiecare nod va avea un vector de parinti si pe baza 
    //acestora construim toate lanturile posibile de la s la t

    int* d = new int[n + 1]; //d[i] = dist de la start la nodul i 

    for (int i = 1; i <= n; ++i) {
        d[i] = n + 1;
    }

    queue<int>q;
    q.push(start);
    d[start] = 0;
    parent[start] = { -1 };
    //adaugam nodul de start in queue, ii setam distanta 0 si tatal -1
    while (q.size() > 0) {
        int first = q.front();
        q.pop();
        //extragem primul element din coada si il stergem
        for (int vecin : list[first]) {
            //pt fiecare vecin
            //daca se poate ajunge la el intr-un mod mai rapid
            //ii actualizam distanta, il adaugam in coada
            //ii stergem vechii parinti si adaugam noul parinte
            if (d[vecin] > d[first] + 1) {
                d[vecin] = d[first] + 1;
                q.push(vecin);
                parent[vecin].clear();
                parent[vecin].push_back(first);
            }
            //daca se poate ajunge la el la fel de rapid
            //dar prin alta cale, adaugam nodul first ca parinte
            else if (d[vecin] == d[first] + 1) {
                parent[vecin].push_back(first);
            }
        }
    }
    delete[]d;
}

void getPaths(vector<vector<int>>& paths, vector<int>& path, vector<int>* parent, int n, int end) {
    if (end == -1) {
        paths.push_back(path);
        return;
    }
    for (int p : parent[end]) {
        path.push_back(end);
        getPaths(paths, path, parent, n, p);
        path.pop_back();
    }
}

void graf() {

    ofstream g("graf.out");
    ifstream f("graf.in");

    int n, m, start, finish;

    f >> n >> m >> start >> finish;

    vector<int>* list = new vector<int>[n + 1];
    vector<int>* parent = new vector<int>[n + 1];

    for (int i = 1; i <= m; ++i) {
        int a, b;
        f >> a >> b;
        list[a].push_back(b);
        list[b].push_back(a);
    }
    f.close();

    bfs(parent, list, n, start);
    //dupa executia lui bfs avem vectorul de vector de tati conform parcurgerii bfs:
    //pe ex dat avem : -1 | 1 | 1 | 5 | 2,3,6 | 1
    //de aici trebuie doar sa parcurgem de la nodul de finish
    //(4 in ex) vectorul de vector de tati si sa formam lanturile 

    vector<vector<int>>paths;
    vector<int> path;
    getPaths(paths, path, parent, n, finish);

    int* aparitii = new int[n + 1];
    for (int i = 1; i <= n; ++i) {
        aparitii[i] = 0;
    }
    for (auto path : paths) {
        for (int nod : path) {
            aparitii[nod]++;
        }
    }
    int lanturi = paths.size();
    int comune = 0;
    for (int i = 1; i <= n; ++i) {
        if (aparitii[i] == lanturi) {
            comune++;
        }
    }
    g << comune << endl;
    for (int i = 1; i <= n; ++i) {
        if (aparitii[i] == lanturi) {
            g << i << " ";
        }
    }
    delete[]aparitii;
}


int main()
{

    graf();

    return 0;
}

