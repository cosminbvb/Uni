#include <iostream>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

int n, m;
vector<int>* list;
vector<int> ciclu;

void euler(int v, vector<int>& grad) {
	while (grad[v] > 0) {
		if (list[v].size() > 0) {
			int w = list[v][0];

			//sterge muchia vw din lista de adiacenta:
			vector<int>nou;
			for (int i : list[v]) {
				if (i != w)
					nou.push_back(i);
			}
			list[v] = nou;
			nou.clear();
			for (int i : list[w]) {
				if (i != v)
					nou.push_back(i);
			}
			list[w] = nou;

			//mai trebuie sa micsoram si gradele
			grad[v]--; grad[w]--;

			euler(w, grad);
		}
	}
	ciclu.push_back(v);
}

int main()
{
	ifstream f("graf.in");

	int x, y;
	f >> n >> m;

	vector<int> grad(n + 1, 0);
	list = new vector<int>[n + 1];

	for (int i = 1; i <= m; i++)
	{
		f >> x >> y;
		list[x].push_back(y);
		list[y].push_back(x);
		grad[x]++;
		grad[y]++;
	}

	bool eulerian = true;

	// verificam daca toate gradele sunt pare (T.Euler)
	for (int i = 1; i <= n; i++) {
		if (grad[i] % 2 == 1) {
			eulerian = false;
			break;
		}
	}

	// e eulerian si daca nu e conex, dar trebuie ca celelalte componente conexe
	// sa fie doar varfuri izolate

	if (eulerian) {
		vector<bool>viz(n + 1, false);
		vector<int>tata(n + 1, -1);
		bool once = false; //avem voie sa facem bfs o singura data
		for (int i = 1; i <= n; i++) {
			if (viz[i] == false) {
				if (grad[i] == 0) //e vf izolat
					viz[i] = true;
				else if (once == false) {
					queue<int> q;
					q.push(i);
					viz[i] = true;
					while (!q.empty()) {
						int u = q.front();
						q.pop();
						for (int v : list[u])
							if (viz[v] == false) {
								viz[v] = true;
								q.push(v);
								tata[v] = u;
							}
					}
					once = true;
				}
			}
		}

		for (int i = 1; i <= n; i++) {
			if (viz[i] == false)
			{
				eulerian = false;
				break;
			}
		}
	}

	if (eulerian) {
		cout << "ciclu eulerian:\n";
		//pornim constructia din primul varf cu grad!=0
		int i;
		for (i = 1; i <= n; i++)
			if (grad[i] != 0) break;
		euler(i, grad);
		for (int i : ciclu)cout << i << " ";
	}
	else {
		cout << "Nu e eulerian\n";
	}

	return 0;
}


