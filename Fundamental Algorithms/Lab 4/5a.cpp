//cu Floyd-Warhsall
#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <queue>

using namespace std;

const int inf = 100000;

int main()
{
	int n, m;
	int x, y, cost;

	ifstream f("grafpond.in");

	f >> n >> m;

	int** d = new int* [n + 1]; //matricea distantelor
	int** p = new int* [n + 1]; //matricea predecesorilor
	for (int i = 0; i < n + 1; i++) {
		d[i] = new int[n + 1];
		p[i] = new int[n + 1];
	}

	for (int i = 1; i <= n; i++)
		for (int j = 1; j <= n; j++) {
			if (i != j)
				d[i][j] = inf; //initial distanta intre oricare 2 noduri e infinit
			else
				d[i][j] = 0; //pe diagonala principala (dist de la i la i) avem 0
			p[i][j] = 0;
		}

	for (int i = 1; i <= m; i++) {
		f >> x >> y >> cost;
		d[x][y] = cost;
		p[x][y] = x;
	}
	f.close();

	for (int k = 1; k <= n; k++) { //varfuri intermediare
		for (int i = 1; i <= n; i++) {
			for (int j = 1; j <= n; j++) {
				if (d[i][j] > d[i][k] + d[k][j]) {
					d[i][j] = d[i][k] + d[k][j];
					p[i][j] = p[k][j];
				}
			}
		}
	}

	bool circuit_negativ = false;
	int nod = -1;
	for (int i = 1; i <= n; i++)
		if (d[i][i] != 0) {
			circuit_negativ = true;
			nod = i;
			break;
		}
	if (!circuit_negativ) {
		cout << "Matricea distantelor: \n";
		for (int i = 1; i <= n; i++) {
			for (int j = 1; j <= n; j++)
				if (d[i][j] > 1000) cout << "INF" << " ";
				else cout << d[i][j] << " ";
			cout << endl;
		}
	}
	else {
		vector<int>cir;
		int aux = p[nod][nod];
		cir.push_back(nod);
		while (aux != nod) {
			cir.push_back(aux);
			aux = p[nod][aux];
		}
		cir.push_back(nod);
		reverse(cir.begin(), cir.end());
		cout << "Circuit negativ: ";
		for (int i : cir) cout << i << " ";
	}

	for (int i = 0; i < n + 1; i++) {
		delete[] d[i];
		delete[] p[i];
	}
	delete[]d;
	delete[]p;

	return 0;
}
/*
5 7
1 4 1
1 3 5
1 2 10
2 3 2
4 2 6
4 5 12
5 2 11

graf cu circuit negativ:
4 5
1 3 2
1 4 5
2 4 -4
3 2 1
4 3 2
*/