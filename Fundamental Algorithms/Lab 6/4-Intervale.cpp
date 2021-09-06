#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;

// intervale

vector<pair<int, int>> intervale;

int cmp(int a, int b) {
	return intervale[a].first < intervale[b].first;
}

int main() {

	ifstream f("intervale.in");

	int n; f >> n; //nr intervale
	intervale.resize(n + 1);
	int a, b;
	for (int i = 1; i <= n; i++) {
		f >> a >> b;
		intervale[i] = { a,b };
	}

	// fiecare varf i - asociat unui interval [a,b]
	// muchii intre intervalele care se intersecteaza

	vector<int>* list = new vector<int>[n + 1];

	for (int i = 1; i <= n; i++) {
		for (int j = 1; j <= n; j++) {
			if (i != j) {
				bool inter = true;
				if (intervale[i].second <= intervale[j].first)
					inter = false;
				if (intervale[i].first >= intervale[j].second)
					inter = false;
				if (inter) {
					list[i].push_back(j);
				}
			}
		}
	}

	vector<int>col(n + 1, -1);

	//vector de noduri pe care il ordonam dupa capatul initial al intervalului corespunzator
	vector<int>ordonare(n + 1);
	for (int i = 1; i <= n; i++) ordonare[i] = i;
	sort(ordonare.begin(), ordonare.end(), cmp);

	vector<int>v;
	for (int i = 1; i <= n; i++)
		v.push_back(min((int)list[i].size(), i));
	int max = *max_element(v.begin(), v.end()); //nr max de culori

	vector<bool>culori(max + 1, true); //culorile disponibile

	for (int i = 1; i <= n; i++) {
		for (int j : list[ordonare[i]]) {
			if (col[j] != -1)
				culori[col[j]] = false; //e luata
		}
		int c;
		for (c = 1; c <= max; c++) {
			if (culori[c] == true) //e disponibila
				break;
		}
		col[ordonare[i]] = c;
		fill(culori.begin(), culori.end(), true);
	}

	for (int i = 1; i <= n; i++)
		cout << col[i] << " ";

}
/*
6
1 4
2 3
2 5
6 8
3 8
6 7
=>
1 2 3 1 2 3
*/