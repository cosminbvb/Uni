#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <queue>

using namespace std;

//probabilitatea unui drum este produsul probabilitatilor muchiilor
//deci probabilitatea va fi de forma 2^-(x1+x2+...+xn) iar ca aceasta
//probabilitate sa fie cat mai mare, suma x1+x2+...+xn trebuie sa fie minima
//=> daca pe toate muchiile in loc de 2^p vom avea costul -p, problema se reduce
//la drumul minim de la s la t si pentru ca p<=0 => -p>=0 => putem folosi Dijkstra

void read(int& n, int& m, int& s, int& t, vector<pair<int, int>>*& list) {
	ifstream f("graf.in");
	f >> n >> m;
	list = new vector<pair<int, int>>[n + 1];
	int x, y, p;
	for (int i = 1; i <= m; i++) {
		f >> x >> y >> p;   //p e exponentul lui 2, p<=0
		list[x].push_back({ y,-p });
	}
	f.close();
	cout << "Enter s and t: \n";
	cin >> s >> t;
}

void Dijkstra(int n, int m, int s, int t, vector<pair<int, int>>* list) {
	int* d = new int[n + 1];
	int* tata = new int[n + 1];
	for (int i = 0; i <= n; i++) {
		d[i] = INT_MAX;
		tata[i] = 0;
	}

	d[s] = 0;
	set<pair<int, int>>q;

	q.insert({ d[s],s });
	while (q.size() > 0) {
		int u = q.begin()->second; //extragem primul nod
		q.erase(q.begin());
		//parcurgem toti vecinii lui u
		for (auto pereche : list[u]) {
			int v = pereche.first;
			int cost = pereche.second; //costul de la u la v 
			if (d[v] > d[u] + cost) {
				q.erase({ d[v],v });
				d[v] = d[u] + cost;
				tata[v] = u;
				q.insert({ d[v], v });
			}
		}
	}

	//Drumul de siguranta maxima: 

	vector<int>drum;
	while (t != 0) {
		drum.push_back(t);
		t = tata[t];
	}
	reverse(drum.begin(), drum.end());

	cout << "Drum de siguranta maxima: \n";
	for (int i : drum) cout << i << " ";
	
	delete[] d;
	delete[] tata;
}

int main()
{
	int n, m, s, t;
	vector<pair<int, int>>* list = NULL; //lista de adiacenta cu forma nod : {nod, cost}
	read(n, m, s, t, list);
	Dijkstra(n, m, s, t, list);

	delete[] list;

	return 0;
}
/*
7 11
1 3 -3
1 4 -2
2 5 -3
2 6 -1
3 2 -2
3 5 -6
4 2 -6
4 3 -2
4 6 -5
5 7 -2
6 7 -1
si s = 1, t = 7
=> 1 3 2 6 7
*/