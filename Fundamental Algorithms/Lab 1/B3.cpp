#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <queue>

using namespace std;

void rj() {

    ifstream f("rj.in");
    ofstream g("rj.out");

    int n, m;

    f >> n >> m;

    int** matrix = new int* [n];
    int** ro = new int* [n]; //matricea distantelor pentru Romeo
    int** ju = new int* [n]; //matricea distantelor pentru Julieta

    pair<int, int>locatieRo, locatieJu;

    for (int i = 0; i < n; i++) {
        matrix[i] = new int[m];
        ro[i] = new int[m];
        ju[i] = new int[m];
    }

    string s;
    getline(f, s);
    for (int i = 0; i < n; i++) {
        getline(f, s);
        int nr = 0;
        for (int j = 0; j < s.size(); j++) {
            switch (s[j]) {
            case 'R':
                nr = -2;
                locatieRo.first = i;
                locatieRo.second = j;
                break;
            case 'J':
                nr = -3;
                locatieJu.first = i;
                locatieJu.second = j;
                break;
            case 'X':
                nr = -1;
                break;
            case ' ':
                nr = 0;
                break;
            }
            matrix[i][j] = nr;
            ro[i][j] = nr;
            ju[i][j] = nr;
        }
    }

    //acum avem matricea cu 
    //R=-2; J=-3; X=-1; ' '=0

    //pornind de la r si de la j (pe rand)
    //calculam distanta pana la fiecare punct = ' '
    //ex ro[i][j]=distanta de la r la (i,j) daca ro[i][j]==' '

    //pornim de la Romeo:

    queue<pair<int, int>> q;
    q.push(locatieRo);
    while (q.size() > 0) {
        int x = q.front().first;
        int y = q.front().second;
        q.pop();
        int currentDist = ro[x][y];
        if (currentDist == -2) {
            currentDist = 0;
            //daca suntem in primul pas, distanta pana la r e 0
        }
        //verificam cele 8 pozitii viitoare:
        if (x - 1 >= 0 && y - 1 >= 0 && ro[x - 1][y - 1] == 0) {
            //1
            q.push({ x - 1, y - 1 });
            ro[x - 1][y - 1] = currentDist + 1;
        }
        if (x - 1 >= 0 && ro[x - 1][y] == 0) {
            //2
            q.push({ x - 1,y });
            ro[x - 1][y] = currentDist + 1;
        }
        if (x - 1 >= 0 && y + 1 < m && ro[x - 1][y + 1] == 0) {
            //3
            q.push({ x - 1,y + 1 });
            ro[x - 1][y + 1] = currentDist + 1;
        }
        if (y + 1 < m && ro[x][y + 1] == 0) {
            //4
            q.push({ x, y + 1 });
            ro[x][y + 1] = currentDist + 1;
        }
        if (x + 1 < n && y + 1 < m && ro[x + 1][y + 1] == 0) {
            //5
            q.push({ x + 1,y + 1 });
            ro[x + 1][y + 1] = currentDist + 1;        
        }
        if (x + 1 < n && ro[x + 1][y] == 0) {
            //6
            q.push({ x + 1,y });
            ro[x + 1][y] = currentDist + 1;           
        }
        if (x + 1 < n && y - 1 >= 0 && ro[x + 1][y - 1] == 0) {
            //7
            q.push({ x + 1,y - 1 });
            ro[x + 1][y - 1] = currentDist + 1;
        }
        if (y - 1 >= 0 && ro[x][y - 1] == 0) {
            //8
            q.push({ x, y - 1 });
            ro[x][y - 1] = currentDist + 1;
        }
    }

    //acum pt Julieta:

    q.push(locatieJu);
    while (q.size() > 0) {
        int x = q.front().first;
        int y = q.front().second;
        q.pop();
        int currentDist = ju[x][y];
        if (currentDist == -3) {
            currentDist = 0;
            //daca suntem in primul pas, distanta pana la j e 0
        }
        //verificam cele 8 pozitii viitoare:
        if (x - 1 >= 0 && y - 1 >= 0 && ju[x - 1][y - 1] == 0) {
            q.push({ x - 1,y - 1 });
            ju[x - 1][y - 1] = currentDist + 1;
        }
        if (x - 1 >= 0 && ju[x - 1][y] == 0) {
            q.push({ x - 1, y });
            ju[x - 1][y] = currentDist + 1;
        }
        if (x - 1 >= 0 && y + 1 < m && ju[x - 1][y + 1] == 0) {
            q.push({ x - 1,y + 1 });
            ju[x - 1][y + 1] = currentDist + 1;
        }
        if (y + 1 < m && ju[x][y + 1] == 0) {
            q.push({ x, y + 1 });
            ju[x][y + 1] = currentDist + 1;
        }
        if (x + 1 < n && y + 1 < m && ju[x + 1][y + 1] == 0) {
            q.push({ x + 1,y + 1 });
            ju[x + 1][y + 1] = currentDist + 1;
        }
        if (x + 1 < n && ju[x + 1][y] == 0) {
            q.push({ x + 1, y });
            ju[x + 1][y] = currentDist + 1;
        }
        if (x + 1 < n && y - 1 >= 0 && ju[x + 1][y - 1] == 0) {
            q.push({ x + 1, y - 1 });
            ju[x + 1][y - 1] = currentDist + 1;
        }
        if (y - 1 >= 0 && ju[x][y - 1] == 0) {
            q.push({ x, y - 1 });
            ju[x][y - 1] = currentDist + 1;
        }
    }

    pair<int, int> best;
    int distMin = max(n, m);
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            if (ro[i][j] == ju[i][j] && ro[i][j] > 0) {
                if (ro[i][j] < distMin) {
                    distMin = ro[i][j];
                    best.first = i;
                    best.second = j;
                }
                if (ro[i][j] == distMin && i < best.first) {
                    best.first = i;
                    best.second = j;
                }
                if (ro[i][j] == distMin && i == best.first && j < best.second) {
                    best.first = i;
                    best.second = j;
                }
            }
        }
    }
    g << distMin + 1 << " " << best.first + 1 << " " << best.second + 1;

    for (int i = 0; i < n; i++) {
        delete[] matrix[i];
    }
    delete[] matrix;

    for (int i = 0; i < n; i++) {
        delete[] ro[i];
    }
    delete[] ro;

    for (int i = 0; i < n; i++) {
        delete[] ju[i];
    }
    delete[] ju;
}

int main()
{
    rj();

    return 0;
}