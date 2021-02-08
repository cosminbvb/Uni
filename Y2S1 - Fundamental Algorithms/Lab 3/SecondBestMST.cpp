#include <iostream>
#include <fstream>
#include <vector>
#include <list>
#include <queue>

using namespace std;

//Second best MST(apcm) - O(n^2)
//DISCLAIMER: cred ca m am complicat foarte tare, dar macar merge
//explicatia e in seminarul 3

int** costuri; //pt ca se pierd dupa prim
bool** inApcm; //inApcm[i][j] = daca ij se afla in apcm

void read(int& n, int& m, vector<pair<int, int>>*& list) {
	ifstream f("graf.in");
	f >> n >> m;
	list = new vector<pair<int, int>>[n + 1];
	costuri = new int* [n + 1];
	inApcm = new bool* [n + 1];
	for (int i = 0; i <= n; i++) {
		costuri[i] = new int[n + 1];
		inApcm[i] = new bool[n + 1];
	}
	for (int i = 0; i <= n; i++)
		for (int j = 0; j <= n; j++) {
			costuri[i][j] = 0;
			inApcm[i][j] = false;
		}
	int x, y, p;
	for (int i = 1; i <= m; i++) {
		f >> x >> y >> p;
		list[x].push_back({ y,p });
		list[y].push_back({ x,p });
		costuri[x][y] = p;
		costuri[y][x] = p;
	}
	f.close();
}

vector<pair<int, int>> prim(int n, int m, vector<pair<int, int>>* list) {
	int* d = new int[n + 1];
	int* tata = new int[n + 1];
	bool* viz = new bool[n + 1];
	for (int i = 0; i <= n; i++) {
		d[i] = INT_MAX;
		tata[i] = 0;
		viz[i] = false;
	}
	cout << "Enter starting node: \n";
	int s; cin >> s;
	d[s] = 0; viz[s] = true;
	priority_queue<pair<int, int>>q;
	q.push({ -d[s],s }); //punem dist cu - pentru ca e facut cu max heap parca
	while (!q.empty()) {
		int u = q.top().second; //extragem primul nod
		q.pop();
		viz[u] = true;
		//parcurgem toti vecinii lui u
		for (auto pereche : list[u]) {
			int v = pereche.first;
			int cost = pereche.second; //costul de la u la v 
			if (!viz[v] && d[v] > cost) { //conditia a doua nu e necesara dar asigura ca nu bagam in coada elemente care sigur nu se folosesc
				//daca v nu a fost vizitat si d[v] > cost(u,v)
				d[v] = cost;
				tata[v] = u;
				q.push({ -d[v], v });
			}
		}
	}
	vector<pair<int, int>> apcm;
	for (int i = 1; i <= n; i++)
		if (tata[i] != 0) //fara legatura dintre nodul de start si 0
			apcm.push_back({ tata[i],i });

	delete[] d;
	delete[] tata;
	delete[] viz;

	return apcm;
}

int main()
{
	int n, m;

	vector<pair<int, int>>* list = NULL; //lista de adiacenta cu forma nod : {nod, cost}

	read(n, m, list);

	vector<pair<int, int>> apcm = prim(n, m, list);

	//trebuie sa formam lista de adiacenta a apcm
	vector<pair<int, int>>* list2 = new vector<pair<int, int>>[n + 1];
	for (auto p : apcm) {
		int i = p.first;
		int j = p.second;
		int p = costuri[i][j];
		list2[i].push_back({ j,p });
		list2[j].push_back({ i,p });
		inApcm[i][j] = true;
		inApcm[j][i] = true;
	}

	vector<vector<pair<int, int>>> max(n + 1); //max[x][y]=muchiia maxima din lantul de la x la y din apcm
	for (int i = 0; i <= n; i++)
		max[i].resize(n + 1);
	for (int i = 0; i <= n; i++)
		for (int j = 0; j <= n; j++)
			max[i][j] = { 0,0 };

	//construim max:
	for (int i = 1; i <= n; i++) {
		//bfs(i) pe apcm
		vector<bool> viz(n + 1, false);
		queue<int>q;
		q.push(i);
		viz[i] = true;
		while (!q.empty()) {
			int u = q.front();
			q.pop();
			for (auto pereche : list2[u]) {
				int v = pereche.first;
				int p = pereche.second;
				if (viz[v] == false) {
					viz[v] = true;
					q.push(v);
					if (p > costuri[max[i][u].first][max[i][u].second]) {
						max[i][v] = { u,v };
					}
					else {
						max[i][v] = max[i][u];
					}
				}
			}
		}
	}

	//det o muchie xy care nu e in apcm (dar e in graf, evident)
	//cu w(x,y)-w(max[x][y]) minim
	int min = 9999999;
	pair<int, int>xy;
	for (int i = 1; i <= n; i++) {
		for (auto pair : list[i]) {
			int j = pair.first;
			if (!inApcm[i][j]) {
				if (costuri[i][j] - costuri[max[i][j].first][max[i][j].second] < min) {
					min = costuri[i][j] - costuri[max[i][j].first][max[i][j].second];
					xy = { i,j };
				}
			}
		}
	}

	vector<pair<int, int>>secondBest;
	secondBest.push_back(xy);
	for (auto p : apcm) {
		if (p != max[xy.first][xy.second])
			secondBest.push_back(p);
	}

	for (auto p : secondBest)
		cout << p.first << " " << p.second << endl;

	delete[] list;
	delete[] list2;
	//todo: dezaloca max, costuri, inApcm

	return 0;
}
/*
8 10
1 2 12
1 4 2
1 5 13
1 7 1
1 8 6
2 4 4
2 6 10
3 4 11
3 5 7
6 7 3
=>
Enter starting node:
1
1 5
4 2
1 4
3 5
7 6
1 7
1 8
*/