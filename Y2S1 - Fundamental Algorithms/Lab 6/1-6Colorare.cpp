#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;

//aloritm recursiv:
/*
colorare(G)
	daca |V(G)| <= 6 atunci coloreaza vf cu culori distincte din 1-6
	altfel
		alege x cu d(x) <= 5
		colorare(G-x)
		coloreaza x cu o culoare din 1-6 diferita de culorile vecinilor
*/


//algoritm iterativ:

vector<int>* list;

int grad(int x);

int cmp(int x, int y);

//O(n+m)
void colorare(int n, int m, vector<int>& col) {

	if (n <= 6) {
		for (int i = 1; i <= n; i++)
			col[i] = i;
	}
	else {

		vector<bool>culori(7, true); //culori disponibile

		vector<int>ordine; //ordinea de colorare
		for (int i = 1; i <= n; i++) ordine.push_back(i);
		sort(ordine.begin(), ordine.end(), cmp);

		for (int i : ordine) {
			//coloreaza i cu prima culoare disponibila (care nu e folosita de vecini)
			for (int j : list[i]) {
				//daca vecinul j a fost colorat
				if (col[j] != -1) {
					culori[col[j]] = false; //culoarea lui j nu mai e disponibila
				}
			}
			int c;
			for (c = 1; c <= 6; c++) //constant
				if (culori[c] == true) {
					break;
				}
			col[i] = c;

			fill(culori.begin(), culori.end(), true); //constant
		}
	}

}

int grad(int x) {
	//gradul lui x in subgraful format din nodurile 1, 2, ...x
	int g = 0;
	for (int y : list[x]) {
		if (y < x) {
			g++;
		}
	}
	return g;
}

int cmp(int x, int y) {
	return grad(x) < grad(y);
}

int main() {

	ifstream f("grafColorare6.in");

	int n, m; f >> n >> m;

	list = new vector<int>[n + 1];

	int x;
	for (int i = 1; i <= n; i++) {
		for (int j = 1; j <= m; j++) {
			f >> x;
			if (x == 1) {
				list[i].push_back(j);
			}
		}
	}
	/*
	int x, y;
	for (int i=1; i <= m; i++) {
		f >> x >> y;
		list[x].push_back(y);
		list[y].push_back(x);
	}
	*/
	vector<int> col(n + 1, -1);
	colorare(n, m, col);
	for (int i = 1; i <= n; i++) cout << col[i] << " ";

}