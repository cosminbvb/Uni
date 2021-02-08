#include <iostream>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

int n;
int** c; //capacitate
//capacity will actually store the residual capacity of the network.
vector<int>* list; //graful e orientat dar lista de adiacenta e cea a grafului neorientay
				   //pentru ca avem nevoie de muchii inverse pt a ne intoarce
const int inf = 1000000;

int bfs(int s, int t, vector<int>& tata) {

	fill(tata.begin(), tata.end(), -1);
	tata[s] = -2;
	queue<pair<int, int>>q;
	q.push({ s, inf });

	while (!q.empty()) {
		int i = q.front().first;
		int flow = q.front().second;
		q.pop();

		for (int j : list[i]) {
			if (tata[j] == -1 && c[i][j]) {
				tata[j] = i;
				int new_flow = min(flow, c[i][j]);
				if (j == t)
					return new_flow;
				q.push({ j, new_flow });
			}
		}
	}

	return 0;
}

int maxFlow(int s, int t) {
	int flow = 0;
	vector<int>tata(n + 3);
	int new_flow;

	while (new_flow = bfs(s, t, tata)) {
		flow += new_flow;
		int current = t;
		while (current != s) {
			int prev = tata[current];
			c[prev][current] -= new_flow;
			c[current][prev] += new_flow;
			current = prev;
		}
	}

	return flow;
}

int main()
{
	ifstream f("graf.in");
	int m, s, t;
	f >> n >> m;
	c = new int* [n + 3];
	for (int i = 1; i <= n + 2; i++)
		c[i] = new int[n + 3];
	for (int i = 1; i <= n + 2; i++)
		for (int j = 1; j <= n + 2; j++)
			c[i][j] = 0;

	list = new vector<int>[n + 3]; //lista de adiacenta a grafului neorientat pentru ford fulkerson
	int x, y;
	for (int i = 1; i <= m; i++) {
		f >> x >> y;
		list[x].push_back(y);
		list[y].push_back(x);
	}

	int* color = new int[n + 1]; //0 daca nu au culoare, 1/-1 altfel
	int* tata = new int[n + 1];
	for (int i = 1; i <= n; i++) {
		color[i] = 0;
		tata[i] = 0;
	}
	bool bipartit = true;
	int final;
	queue<int> q;
	q.push(1);
	color[1] = 1;
	tata[1] = -1;
	while (!q.empty() && bipartit == true) {
		int u = q.front();
		q.pop();
		for (int v : list[u]) {
			if (tata[v] == 0) {
				color[v] = -color[u];
				tata[v] = u;
				q.push(v);
			}
			if (color[v] == color[u]) {
				bipartit = false;
				tata[v] = u;
				final = v;
				break;
			}

		}
	}

	if (!bipartit) {
		cout << "Graful nu e bipartit\n";
		cout << "Ciclu impar: \n";
		while (final != -1) {
			cout << final << " ";
			final = tata[final];
		}
	}
	else {
		s = n + 1;
		t = n + 2;
		for (int i = 1; i <= n; i++) {
			if (color[i] == 1) {
				list[s].push_back(i);
				list[i].push_back(s);
				c[s][i] = 1;
				for (int j : list[i]) {
					c[i][j] = 1;
				}
			}
			if (color[i] == -1) {
				list[t].push_back(i);
				list[i].push_back(t);
				c[i][t] = 1;
			}
		}
		int flow = maxFlow(s, t);
		for (int i = 1; i <= n; i++) {
			if (color[i] == 1) {
				for (int j : list[i]) {
					if (c[i][j] == 0) {
						cout << i << " " << j << endl;
					}
				}
			}
		}
	}
	for (int i = 1; i <= n + 2; i++)
		delete[] c[i];
	delete[] c;
	delete[] list;
	delete[] color;
	delete[] tata;
	return 0;
}

/*
graf bip:
8 9
1 2
1 3
2 4
3 4
2 5
3 5
3 7
6 7
7 8
=>
1 2
4 3
7 6


graf non bip:
5 5
1 2
1 4
2 3
3 5
4 5
*/