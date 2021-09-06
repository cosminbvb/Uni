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
	cout << "n: ";
	int n; cin >> n;
	if (n % 2 != 0)
	{
		cout << "trebuie ca n sa fie par\n";
		return 0;
	}
	vector<int>grad(n + 1, n + 2); //d(i) = n+2
	list = new vector<int>[n + 1];
	for (int i = 0; i <= n; i++) {
		for (int j = 0; j <= n; j++) {
			list[i].push_back(j);
		}
	}
	euler(0, grad);
	reverse(ciclu.begin(), ciclu.end());
	for (int i = 0; i < ciclu.size() - 1; i++) {
		cout << ciclu[i] << " " << ciclu[i + 1] << endl;
	}
	return 0;
}


