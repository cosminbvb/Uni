#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <queue>
#include <stack>

using namespace std;

ifstream f("graf.in");
ofstream g("graf.out");

void printCycle(stack<int>& s, int v) {

    stack<int> s2;
    s2.push(s.top());
    s.pop();
    while (s2.top() != v) {
        s2.push(s.top());
        s.pop();
    }
    while (!s2.empty()) {
        g << s2.top() << " ";
        s.push(s2.top());
        s2.pop();
    }

}

void dfs(vector<int>* list, stack<int>& s, bool* viz, bool* inStack) {

    for (int v : list[s.top()]) {
        if (inStack[v] == true)
            printCycle(s, v);
        else if (viz[v] == false) {
            s.push(v);
            inStack[v] = true;
            viz[v] = true;
            dfs(list, s, viz, inStack);
        }
    }
    inStack[s.top()] = false;
    s.pop();

}

int main()
{
    int n, m, x, y;
    f >> n >> m;
    vector<int>* list = new vector<int>[n + 1];
    vector<int> grad(n + 1, 0);
    for (int i = 0; i < m; i++) {
        f >> x >> y;
        list[x].push_back(y);
        grad[y]++;
    }
    f.close();

    //sortare topologica:
    queue<int> q;
    for (int i = 1; i <= n; i++)
        if (grad[i] == 0)
            q.push(i);
    while (!q.empty()) {
        int x = q.front();
        q.pop();
        for (int y : list[x]) {
            grad[y]--;
            if (grad[y] == 0)
                q.push(y);
        }
    }

    bool realizabil = true;
    for (int i = 1; i <= n; i++)
        if (grad[i] != 0) {
            realizabil = false;
        }

    if (realizabil) {
        g << "REALIZABIL\n";
    }
    else {
        // trebuie sa detectam ciclurile (putem sa dam exit(1) dupa primul daca nu le vrem pe toate)
        // https://www.baeldung.com/cs/detecting-cycles-in-directed-graph
        bool* viz = new bool[n + 1];
        bool* inStack = new bool[n + 1];
        for (int i = 1; i <= n; i++) {
            viz[i] = false;
            inStack[i] = false;
        }
        for (int i = 1; i <= n; i++) {
            if (viz[i] == false) {
                stack<int> s;
                s.push(i);
                viz[i] = true;
                inStack[i] = true;
                dfs(list, s, viz, inStack);
            }
        }

        delete[] viz;
        delete[] inStack;

    }

    delete[] list;

    return 0;
}