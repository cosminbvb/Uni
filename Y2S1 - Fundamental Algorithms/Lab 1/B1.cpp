#include <iostream>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

bool isTower(vector<int> towers, int node) {
    for (int i : towers)
        if (i == node)
            return true;
    return false;
}

void controlTowers(int n, int m, vector<int>* list, int start, vector<int>towers) {

    bool* viz = new bool[n + 1];
    //int* d = new int[n + 1]; //d[i] = lungimea drumului de la start la i
    int* tata = new int[n + 1];
    for (int i = 1; i <= n; i++) {
        viz[i] = false;
        tata[i] = -1;
        //d[i] = -1;
    }
    queue<int> c;
    c.push(start); //punem nodul de start in coada
    viz[start] = true; //il vizitam
    //d[start] = 0; //drumul de la start pana la start e 0
    while (c.size() > 0) { //cat timp coada nu e vida
        int x = c.front();
        c.pop(); //scoatem primul element
        for (unsigned i = 0; i < list[x].size(); i++) { //parcurgem toti vecinii lui
            int y = list[x][i]; //y = vecinul lui x
            if (isTower(towers, y)) {
                //am gasit cel mai apropiat turn / punct de control
                //ne mai trebuie lantul
                vector<int>lant; lant.push_back(y);
                while (x != -1) {
                    lant.push_back(x);
                    x = tata[x];
                }
                reverse(lant.begin(), lant.end());
                for (int i : lant) cout << i << " ";
                exit(1);
            }
            else if (viz[y] == false) { //daca y nu a fost vizitat 
                c.push(y);
                viz[y] = true;
                tata[y] = x;
                //d[y] = d[x] + 1;
            }
        }
    }

    delete[] viz;
    delete[] tata;
    //delete[] d;

}

int main()
{
    ifstream f("graf.in");
    int n, m; f >> n >> m;

    vector<int>* list = new vector<int>[n + 1];

    int x, y;
    for (int i = 0; i < m; i++) {
        f >> x >> y;
        list[x].push_back(y);
        list[y].push_back(x);
    }

    vector<int> towers;
    while (f >> x) {
        towers.push_back(x);
    }

    f.close();

    int start;
    cout << "nodul de start: "; cin >> start;

    controlTowers(n, m, list, start, towers);

    delete[] list;

    return 0;
}