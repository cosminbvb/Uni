#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;

// nu stiu cum se face in O(n+m)
// cu o ordonare worst case iese
// nr de culori <= max {min(d(vi)+1, i) | i=1,..,n}
// si pentru fiecare nod(deci n) trebuie parcurs vectorul
// culori de marime nr pana gasim true (culoare disponibila)
// cred ca se poate scapa si de fill ul ala dar n am incercat
// o alternativa cred ca e cu un hashmap de int si vector<int> (culoare -> noduri cu acea culoare)

void colorare(int n, int m, vector<int>* list, vector<int>ordonare, vector<int>& col) {

	vector<int>v;
	for (int i = 1; i <= n; i++)
		v.push_back(min((int)list[i].size(), i));
	int max = *max_element(v.begin(), v.end());

	vector<bool>culori(max + 1, true); //culorile disponibile

	for (int i : ordonare) {
		for (int j : list[i]) {
			if (col[j] != -1)
				culori[col[j]] = false; //e luata
		}
		int c;
		for (c = 1; c <= max; c++) {
			if (culori[c] == true) //e disponibila
				break;
		}
		col[i] = c;
		fill(culori.begin(), culori.end(), true);
	}

}
int main() {

	ifstream f("graf.in");

	int n, m; f >> n >> m;

	vector<int>* list = new vector<int>[n + 1];

	int x, y;
	for (int i = 1; i <= m; i++) {
		f >> x >> y;
		list[x].push_back(y);
		list[y].push_back(x);
	}

	vector<int>ordonare;
	for (int i = 1; i <= n; i++) {
		f >> x;
		ordonare.push_back(x);
	}

	vector<int> col(n + 1, -1);
	colorare(n, m, list, ordonare, col);
	for (int i = 1; i <= n; i++) cout << col[i] << " ";

}