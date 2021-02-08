//sortare topologica

//ordonare a varfurilor a.i daca uv apartine E atunci u se 
//afla inaintea lui v in ordonare

//propozitie: daca g e aciclic atunci g are o sortare topologica

#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <queue>

using namespace std;

void read(int& n, int& m, vector<int>*& list, vector<int>& grad) {
	ifstream f("graf.in");
	f >> n >> m;
	list = new vector<int>[n + 1];
	grad.resize(n + 1);
	int x, y;
	for (int i = 1; i <= m; i++) {
		f >> x >> y;
		list[x].push_back(y);
		grad[y]++; //cate muchii intra in y
	}
	f.close();
}

int main()
{
	int n, m;
	vector<int>* list = NULL; 
	vector<int> grad;
	vector<int> sortare;
	read(n, m, list, grad);

	queue<int>q;
	//introducem in q toate vf cu grad 0
	for (int i = 1; i <= n; i++)
		if (grad[i] == 0)
			q.push(i);
	while (!q.empty()) {
		//extragem un varf din coada
		int x = q.front();
		q.pop();
		sortare.push_back(x);
		for (int y : list[x]) {
			//il "eliminam din graf" (adica scadem gradele interne
			//ale vecinilor, nu il scoatem efectiv in graf)
			grad[y]--;
			if (grad[y] == 0) //adaugam in coada vecinii al caror grad intern devine 0
				q.push(y);
		}
	}
	cout << "Sortare topologica: \n";
	for (int i = 0; i < n; i++)
		cout << sortare[i] << " ";

	delete[] list;

	return 0;
}
/*
6 8
1 5
1 6
3 2
3 5
4 2
5 2
5 4
6 2
=> 1 3 6 5 4 2
*/

