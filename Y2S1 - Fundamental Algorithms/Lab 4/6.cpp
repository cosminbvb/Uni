//Bellman-Ford
//O(nm)

#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <queue>

using namespace std;

const int inf = 100000;

void read(int& n, int& m, vector<pair<int, int>>*& list) {
	ifstream f("grafpond.in");
	f >> n >> m;
	list = new vector<pair<int, int>>[n + 1];
	int x, y, p;
	for (int i = 1; i <= m; i++) {
		f >> x >> y >> p;
		list[x].push_back({ y, p });
	}
	f.close();
}

int main()
{
	int n, m;
	vector<pair<int, int>>* list = NULL; //lista de adiacenta cu forma nod : {nod, cost}

	read(n, m, list);

	int* d = new int[n + 1];
	int* t = new int[n + 1];

	//initializare:
	for (int i = 1; i <= n; i++) {
		d[i] = inf;
		t[i] = 0;
	}

	cout << "Start node: \n";
	int s; cin >> s; d[s] = 0;

	//facem n-1 iteraii
	//si la fiecare iteratie parcurgem toate muchiile
	//(pentru fiecare nod u muchiile lui)
	//=> n iteratii * m muchii in total
	for (int i = 1; i < n; i++) {
		for (int u = 1; u <= n; u++) {
			for (pair<int, int> muchie : list[u]) {
				int v = muchie.first;
				int cost = muchie.second;
				if (d[v] > d[u] + cost) {
					d[v] = d[u] + cost;
					t[v] = u;
				}
			}
		}
	}

	//Exista un circuit negativ in G (accesibil din s) <=>
	//algoritmul ar mai face o iteratie s-ar mai actualiza etichete
	//de distanta

	bool circuit_negativ = false;
	int nod_actualizat = -1;
	for (int u = 1; u <= n; u++) {
		for (pair<int, int> muchie : list[u]) {
			int v = muchie.first;
			int cost = muchie.second;
			if (d[v] > d[u] + cost) {
				circuit_negativ = true;
				nod_actualizat = v;
				break;
				d[v] = d[u] + cost;
				t[v] = u;
			}
		}
	}

	if (!circuit_negativ) {
		for(int i=1;i<=n;i++)
			if (i != s) {
				vector<int>drum;
				cout << s << " - " << i << ": ";
				int aux = i;
				while (aux != s) {
					drum.push_back(aux);
					aux = t[aux];
				}
				reverse(drum.begin(), drum.end());
				cout << s << " ";
				for (int nod : drum) cout << nod << " ";
				cout << endl;
			}
	}
	else {
		vector<int>cir;
		int aux = t[nod_actualizat];
		cir.push_back(nod_actualizat);
		while (aux != nod_actualizat) {
			cir.push_back(aux);
			aux = t[aux];
		}
		cir.push_back(nod_actualizat);
		reverse(cir.begin(), cir.end());
		cout << "Circuit negativ: ";
		for (int i : cir) cout << i << " ";
	}

	delete[] list;
	delete[] d;
	delete[] t;

	return 0;
}