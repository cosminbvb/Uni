#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <queue>

using namespace std;

void read(int& n, int& m, int& k, vector<pair<int, int>>*& list, vector<bool>& fort) {
	ifstream f("catun.in");
	f >> n >> m >> k;
	fort.resize(n+1, false);
	for (int i = 0; i < k; i++) {
		int x;
		f >> x;
		fort[x] = true;
	}
	list = new vector<pair<int, int>>[n + 1];
	int x, y, p;
	for (int i = 1; i <= m; i++) {
		f >> x >> y >> p;
		list[x].push_back({ y,p });
		list[y].push_back({ x,p });
	}
	f.close();
}

void Dijkstra(int n, int m, int k, vector<pair<int, int>>* list, vector<bool> fort) {
	//int* d = new int[n + 1];
	vector<pair<int, int>>d(n + 1); //{distanta, nodul care i a modificat distanta}
	//avem nevoie de asta pentru cazul special in care un catun este la dist egala
	//de doua fortarete si vrem sa retinem fortareata cu id minim
	int* tata = new int[n + 1];
	for (int i = 0; i <= n; i++) {
		d[i] = { 72001, 0 };
		tata[i] = 0;
	}

	set<pair<pair<int, int>, int>>q;
	//fortaretele sunt noduri de start
	for (int i = 1; i <= n;i++) {
		if (fort[i]) {
			d[i] = { 0,0 };
			q.insert({ d[i],i });
		}
	}

	while (q.size() > 0) {
		int u = q.begin()->second; //extragem primul nod
		q.erase(q.begin());
		//parcurgem toti vecinii lui u
		for (auto pereche : list[u]) {
			int v = pereche.first;
			int cost = pereche.second; //costul de la u la v 
			if ((d[v].first > d[u].first + cost) || (d[v].first == d[u].first + cost && u<d[v].second)) {
				q.erase({ d[v],v });
				d[v].first = d[u].first + cost;
				if (u < d[v].second)
					d[v].second = u;
				tata[v] = u;
				q.insert({ d[v], v });
			}
		}
	}

	ofstream g("catun.out");
	for (int i = 1; i <= n; i++) {
		if (!fort[i]) {
			int x = i;
			if (tata[x] == 0)  g << "0 "; //daca nu a fost vizitat
			else {
				while (tata[x] != 0) x = tata[x];
				g << x << " ";
			}
		}
		else
			g <<"0 "; //daca e fortareata
	}
	delete[] tata;
}

int main()
{
	int n, m, k;
	vector<bool> fort; 
	vector<pair<int, int>>* list = NULL; //lista de adiacenta cu forma nod : {nod, cost}
	read(n, m, k, list, fort);
	Dijkstra(n, m, k, list, fort);

	delete[] list;

	return 0;
}