#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <queue>
#include <stack>

using namespace std;

//in varianta asta, se afiseaza toate ciclurile de lungime minima

void bfs(int node, int* viz, int* parent, vector<int>* list) {

    queue<int> q;
    q.push(node);
    viz[node] = 1;
    parent[node] = 0;
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        for (int v : list[u]) {
            if (viz[v] == 0) {
                q.push(v);
                viz[v] = 1;
                parent[v] = u;
            }
        }
    }

}

int main()
{
    ifstream f("graf.in");
    ofstream g("graf.out");
    int n, m, x, y;
    f >> n >> m;
    vector<int>* list = new vector<int>[n + 1];
    for (int i = 0; i < m; i++) {
        f >> x >> y;
        list[x].push_back(y);
        list[y].push_back(x);
    }
    f.close();

    int* viz = new int[n + 1];
    int* parent = new int[n + 1];
    for (int i = 1; i <= n; i++) {
        viz[i] = 0;
        parent[i] = -1;
    }

    for (int i = 1; i <= n; i++) {
        if (viz[i] == 0) {
            //in cazul in care graful nu e conex
            bfs(i, viz, parent, list);
        }
    }
    //am calculat un arbore partial pt fiecare componenta conexa
    for (int i = 1; i <= n; i++) {
        for (int j : list[i]) {
            if (parent[i] != j && parent[j] != i) {
                //muchia i j inchide un ciclu
                //acum sa gasim ciclul
                int r = i;
                stack<int> s;
                while (r != 0) {
                    s.push(r);
                    r = parent[r];
                }
                while (!s.empty()) {
                    g << s.top() << " ";
                    s.pop();
                }
                r = j;
                while (r != 0) {
                    g << r << " ";
                    r = parent[r];
                }
                g << endl;

            }
        }
    }

    //todo - dezalocari

    return 0;
}