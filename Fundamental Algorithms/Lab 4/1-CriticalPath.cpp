#include <iostream>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

const int inf = 100000;

int main()
{
	#pragma region Read

	ifstream f("activitati.in");
	int n, m;
	f >> n;
	vector<int> durata(n+1);
	vector<int> grad(n + 1, 1); //pt sortarea topologica avem nev de grad
	//toate sunt la inceput 1 pentru ca am adaugat nodul auxiliar 0 in graf
	//care are muchii catre toate nodurile
	for (int i = 1; i <= n; i++)
		f >> durata[i];
	f >> m;
	vector<pair<int, int>> dependente(m);
	for (int i = 0; i < m; i++) {
		int x, y;
		f >> x >> y;
		dependente[i] = { x,y };
		grad[y]++;
	}

	#pragma endregion

	#pragma region Construire Graf
	//trebuie sa facem o lista de adiacenta in care sa punem costul
	//nodurilor pe muchii

	vector<vector<pair<int, int>>> list(n + 2);
	for (auto pereche : dependente) {
		int u, v, cost;
		u = pereche.first;
		v = pereche.second;
		cost = durata[v];
		list[u].push_back({ v, -cost });
		//pentru muchia i j (din vectorul de dependente)
		//costul va fi cel al nodului j dar cu semn schimbat
		//dc cu semn schimbat? pt ca problema cere un drum maxim in 
		//graf si schimband semnul => cautam drum minim
	}
	//mai trebuie sa adaugam muchii intre 0 si toate nodurile
	for (int i = 1; i <= n; i++)
		list[0].push_back({ i, -durata[i] });

	#pragma endregion

	//graful e aciclic, deci putem aplica algoritmul pt DAG

	#pragma region DAG
	//sortare topologica:
	vector<int> sortare;
	queue<int>q;
	q.push(0); //doar nodul 0 are gradul de intrare 0
	while (!q.empty()) {
		//extragem un varf din coada
		int x = q.front();
		q.pop();
		sortare.push_back(x);
		for (auto pereche : list[x]) {
			int y = pereche.first;
			grad[y]--;
			if (grad[y] == 0) //adaugam in coada vecinii al caror grad intern devine 0
				q.push(y);
		}
	}

	int* d = new int[n + 1];
	int* t = new int[n + 1];

	//initializare:
	for (int i = 0; i <= n; i++) {
		d[i] = inf;
		t[i] = 0;
	}

	d[0] = 0; //0 e nodul de start

	for (int u : sortare) {
		for (auto pereche : list[u]) {
			int v = pereche.first;
			int cost = pereche.second;
			if (d[v] > d[u] + cost) { //relaxam uv
				d[v] = d[u] + cost;
				t[v] = u;
			}
		}
	}
	#pragma endregion

	//a)

	cout << "Timp minim: " << -d[m] << endl;
	
	int x = m;
	vector<int>activitati;
	//in activitati punem drumul de la m (nodul final) pana la 0
	while (x != 0) {
		activitati.push_back(x);
		x = t[x];
	}
	//trebuie sa le afisam invers
	reverse(activitati.begin(), activitati.end());
	cout << "Activitati critice: ";
	for (int i : activitati) 
		cout << i << " ";
	cout << endl;

	//b)

	for (int i = 1; i <= n; i++) {
		cout << i << ": " << -d[i] - durata[i] << " " << -d[i] << endl;
	}

	delete[] d;
	delete[] t;

	return 0;
}
