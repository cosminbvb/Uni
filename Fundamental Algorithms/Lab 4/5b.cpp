//cu Floyd-Warhsall
#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <queue>

using namespace std;

const int inf = 100000;

//banuiesc ca paranteza din cerinta e o greseala

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

	//presupunem ca 1000 e costul maxim al unei muchii 
	
	//avem matricea distantelor, mai trebuie doar sa facem niste cautari prin ea

	vector<int>excentricitate(n + 1);
	int raza = 1000;
	int diametru = 0;
	pair<int, int> nod_diam_opus = { -1,-1 };
	for (int i = 1; i <= n; i++) {
		int max = 0;
		int j_max = -1;
		for (int j = 1; j <= n; j++)
			if (d[i][j] > max && d[i][j] <= 1000) {
				max = d[i][j];
				j_max = j;
			}
		excentricitate[i] = max;
		if (max < raza) raza = max;
		if (max > diametru) {
			diametru = max;
			nod_diam_opus.first = i;
			nod_diam_opus.second = j_max;
		}
	}
	vector<int>centru;
	for (int i = 1; i <= n; i++)
		if (excentricitate[i] == raza)
			centru.push_back(i);
	
	cout << "r(G): " << raza << endl;
	cout << "diam(G): " << diametru << endl;
	cout << "c(G): ";
	for (int i : centru) cout << i << " ";
	cout << endl;
	cout << "Lant minim cu pondere = diam(G): ";

	vector<int>lant;
	int aux = p[nod_diam_opus.first][nod_diam_opus.second];
	while (aux != 0) {
		lant.push_back(aux);
		aux = p[nod_diam_opus.first][aux];
	}
	reverse(lant.begin(), lant.end());
	for (int i : lant) cout << i << " ";
	cout << nod_diam_opus.second << endl;
	
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
*/