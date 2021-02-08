#include <iostream>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

int n, m;
vector<int>* list;
vector<int> ciclu;

void euler(int v, vector<int>& gradIn, vector<int>& gradEx) {
	while (gradEx[v] > 0) {
		if (list[v].size() > 0) {
			int w = list[v][0];

			//sterge muchia vw din lista de adiacenta:
			vector<int>nou;
			for (int i : list[v]) {
				if (i != w)
					nou.push_back(i);
			}
			list[v] = nou;

			//mai trebuie sa micsoram si gradele
			gradEx[v]--; gradIn[w]--;

			euler(w, gradIn, gradEx);
		}
	}
	ciclu.push_back(v);
}

int main()
{
	ifstream f("graf.in");

	int x, y;
	f >> n >> m;

	vector<int> gradIn(n + 2, 0);
	vector<int> gradEx(n + 2, 0);
	list = new vector<int>[n + 2]; //+2 pt ca vom adauga un nod daca vrem drumul

	for (int i = 1; i <= m; i++)
	{
		f >> x >> y;
		list[x].push_back(y);
		gradIn[y]++;
		gradEx[x]++;
	}

	bool areDrum;

	//G are drum eulerian <=> 
	//		cel mult un nod are gradIn - gradEx = 1
	//      cel mult un nod are gradEx - gradIn = 1
	//      toate celelalte vf au gradIn = gradEx
	//      toate varfurile cu grad != 0 apartin unei singure componente conexe

	int a, b; //nodurile care intra pe cazul 1 si 2
	int nr1 = 0, nr2 = 0, nr3 = 0; //numaram cele 3 cazuri
	for (int i = 1; i <= n; i++) {
		if (gradIn[i] - gradEx[i] == 1) {
			nr1++;
			a = i;
		}
		else if (gradEx[i] - gradIn[i] == 1) {
			nr2++;
			b = i;
		}
		else if (gradIn[i] == gradEx[i])
			nr3++;
		//mai trebuie verificat si cazul 4 cu o parcurgere sau ceva
		//dar presupunem ca graful dat e conex
	}
	if (nr1 <= 1 && nr2 <= 1 && nr1 + nr2 + nr3 == n)
		areDrum = true;
	else
		areDrum = false;

	if (areDrum) {
		cout << "drum eulerian:\n";
		//adaugam un nod auxiliar care sa inchida ciclul
		//apelam euler
		//afisam ciclul fara capete

		//trebuie sa facem gradIn = gradEx pt a si b
		list[n + 1].push_back(b);
		list[a].push_back(n + 1);
		gradIn[b]++;
		gradEx[a]++;
		gradIn[n + 1] = 1;
		gradEx[n + 1] = 1;
		euler(1, gradIn, gradEx); //presupunem ca e conex. daca nu era, apelam euler de primul nod care are grad
		reverse(ciclu.begin(), ciclu.end());
		for (int i = 0; i < ciclu.size() - 2; i++)
			cout << ciclu[i] << " ";
	}
	else {
		cout << "nu are drum eulerian\n";
	}
	return 0;
}
/*
5 5
1 2
2 3
3 5
5 4
4 3
=> 1 2 3 5 4 3
*/

