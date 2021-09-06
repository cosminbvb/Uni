#include <iostream>
#include <fstream>
#include <vector>
#include <list>
#include <queue>

//Prim - O(m logn) cu priority queue (heap)

using namespace std;

void read(int& n, int& m, vector<pair<int, int>>*& list) {
	ifstream f("graf.in");
	f >> n >> m;
	list = new vector<pair<int, int>>[n + 1];
	int x, y, p;
	for (int i = 1; i <= m; i++) {
		f >> x >> y >> p;
		list[x].push_back({ y,p });
		list[y].push_back({ x,p });
	}
	f.close();
}

void prim(int n, int m, vector<pair<int, int>>* list) {
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
	cout << "Apcm / Minimum spanning tree: \n";
	for (int i = 1; i <= n; i++)
		if (tata[i] != 0) //fara legatura dintre nodul de start si 0
			cout << tata[i] << " " << i << endl;
	cout << endl;

	delete[] d;
	delete[] tata;
	delete[] viz;
}

int main()
{
	int n, m;
	vector<pair<int, int>>* list = NULL; //lista de adiacenta cu forma nod : {nod, cost}
	read(n, m, list);
	prim(n, m, list);

	delete[] list;

	return 0;
}

