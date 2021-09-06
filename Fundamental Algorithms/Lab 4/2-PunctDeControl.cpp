#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <queue>

using namespace std;

void read(int& n, int& m, vector<pair<int, int>>*& list, int& k, bool*& control, int& s) {
	ifstream f("grafpond.in");
	f >> n >> m;
	list = new vector<pair<int, int>>[n + 1];
	int x, y, p;
	for (int i = 1; i <= m; i++) {
		f >> x >> y >> p;
		list[x].push_back({ y,p });
	}
	control = new bool[n + 1];
	cin >> k;
	for (int i = 1; i <= n; i++)
		control[i] = false;
	for (int i = 1; i <= k; i++) {
		cin >> x;
		control[x] = true;
	}
	cin >> s;
	f.close();
}

void Dijkstra(int n, int m, vector<pair<int, int>>* list, int k, bool* control, int s) {
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
	//acum avem distantele minime de la s pana la restul nodurilor
	//si mai ramane sa aflam care e cel mai apropiat punct cu ajutorul
	//distantelor calculate
	int punct = -1;
	int minDist = INT_MAX;
	for (int i = 1; i <= n; i++) {
		if (control[i] && d[i] < minDist) {
			punct = i;
			minDist = d[i];
		}
	}

	vector<int> drum;
	cout << "Cel mai apropiat punct de control: " << punct << endl;
	cout << "Distanta: " << minDist << endl;
	cout << "Drum: ";
	while (punct != 0) {
		drum.push_back(punct);
		punct = tata[punct];
	}
	reverse(drum.begin(), drum.end());
	for (int i : drum) cout << i << " ";
	cout << endl;

	delete[] d;
	delete[] tata;
}

int main()
{
	int n, m;
	vector<pair<int, int>>* list = NULL; //lista de adiacenta cu forma nod : {nod, cost}
	int k;
	bool* control = NULL;
	int s;
	read(n, m, list, k, control, s);
	Dijkstra(n, m, list, k, control, s);
	
	delete[] list;
	delete[] control;

	return 0;
}