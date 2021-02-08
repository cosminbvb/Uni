#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <set>

using namespace std;

int n;
int** c; //capacitate
int** fl; //fluxul pe fiecare muchie 
		  //la citire, fl[i][j] retine capacitatea muchiei
		  //dupa terminarea algoritmului, fl[i][j] = capacitatea (i,j) - capacitatea "neocupata" =
		  // = fl[i][j] - c[i][j]
		  //=> flux[i][j] = -1 daca nu exista muchie, altfel e fluxul
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

int maxFlow(int s, int t, int currentFlow) {
	int flow = currentFlow;
	vector<int>tata(n + 1);
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

	//algoritmul s-a terminat, mai avem de aflat flow ul pe fiecare muchie
	for (int i = 1; i <= n; i++)
		for (int j = 1; j <= n; j++) {
			if (fl[i][j] != -1) //daca e muchie intre i si j
				fl[i][j] -= c[i][j];
		}
	return flow;
}

int main()
{
	ifstream f("retea.in");
	int m, s, t;
	f >> n >> s >> t >> m;
	c = new int* [n + 1];
	fl = new int* [n + 1];
	for (int i = 1; i <= n; i++) {
		c[i] = new int[n + 1];
		fl[i] = new int[n + 1];
	}
	for (int i = 1; i <= n; i++)
		for (int j = 1; j <= n; j++) {
			c[i][j] = 0;
			fl[i][j] = -1;
		}
	list = new vector<int>[n + 1];
	int x, y, capacitate, flux;

	//a) - verificare
	vector<int>verif(n + 1);
	fill(verif.begin(), verif.end(), 0);
	bool corect = true;

	for (int i = 1; i <= m; i++) {
		f >> x >> y >> capacitate >> flux;

		if (flux > capacitate)
		{
			corect = false;
			break;
		}

		list[x].push_back(y);
		list[y].push_back(x);
		c[x][y] = capacitate - flux;
		c[y][x] = flux;

		verif[x] -= flux;
		verif[y] += flux;

		fl[x][y] = capacitate; //am explicat sus de ce
	}

	for (int i = 1; i <= n; i++) //daca intr-un nod (care nu e s sau t) cat intra != cat iese (adica verif[i] !=0) => incorect
		if (i != s && i != t && verif[i] != 0) {
			corect = false;
			break;
		}

	if (verif[s] != -verif[t]) //cat iese din s != cat intra in t => incorect
		corect = false;

	if (corect)
	{
		cout << "DA\n";
		int flow = maxFlow(s, t, verif[t]);
		cout << flow << endl;
		for (int i = 1; i <= n; i++)
			for (int j = 1; j <= n; j++) {
				if (fl[i][j] != -1) {
					cout << i << " " << j << " " << fl[i][j] << endl;
				}
			}
		cout << flow << endl; //din cate stiu capacitatea taieturii minime = fluxul maxim
		//de aceea am afisat direct (i might be wrong)

		//mai facem un bfs dupa ce algoritmul s-a terminat pentru a partitiona nodurile
		set<int> X, Y;
		vector<int>tata(n + 1);
		bfs(s, t, tata);
		for (int i = 1; i <= n; i++)
			if (tata[i] != -1)
				X.insert(i);
			else
				Y.insert(i);
		for (int i : X) {
			for (int j : Y) {
				if (fl[i][j] != -1) //daca exista muchie intre i si j
					cout << i << " " << j << endl;
			}
		}

	}
	else
		cout << "NU\n";

	for (int i = 1; i <= n; i++) {
		delete[] c[i];
		delete[] fl[i];
	}
	delete[] c;
	delete[] fl;
	delete[] list;

	return 0;
}
/*
6
1 6
8
1 3 6 3
1 5 8 2
3 2 5 0
3 4 3 3
5 4 4 2
2 6 7 0
4 6 5 5
3 5 1 0

=>

DA
10
1 3 6
1 5 4
2 6 5
3 2 5
3 4 1
3 5 0
4 6 5
5 4 4
10
1 3
5 4
*/