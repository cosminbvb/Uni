#include <iostream>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

int n;
int** c; //capacitate
//capacity will actually store the residual capacity of the network.
vector<int>* list; //graful e orientat dar lista de adiacenta e cea a grafului neorientay
				   //pentru ca avem nevoie de muchii inverse pt a ne intoarce
const int inf = 1000000;

int bfs(int s, int t, vector<int>& tata) {

	fill(tata.begin(), tata.end(), -1);
	tata[s] = -2;
	queue<pair<int, int>>q;
	q.push({ s, inf });

	while (!q.empty()) {
		int i = q.front().first;
		int flow = q.front().second;
		q.pop();

		for (int j : list[i]) {
			if (tata[j] == -1 && c[i][j]) {
				tata[j] = i;
				int new_flow = min(flow, c[i][j]);
				if (j == t)
					return new_flow;
				q.push({ j, new_flow });
			}
		}
	}

	return 0;
}

int maxFlow(int s, int t) {
	int flow = 0;
	vector<int>tata(2 * n + 3);
	int new_flow;

	while (new_flow = bfs(s, t, tata)) {
		flow += new_flow;
		int current = t;
		while (current != s) {
			int prev = tata[current];
			c[prev][current] -= new_flow;
			c[current][prev] += new_flow;
			current = prev;
		}
	}

	return flow;
}

int main()
{
	//trebuie sa modificam problema astfel incat sa putem aplica ford fulkerson
	//se da numarul de noduri n
	//vom construi un graf cu 2*n + 2 noduri (doua seturi de n noduri + s + t)
	//intre cele doua seturi muchiile au capacitatea 1 
	//intre s si primul set capacitatile sunt luate din vectorul de grade de iesire
	//intre al doilea set si t -//- intrare

	//spre exemplu pentru n = 3 si vectorii 2 1 1 si 1 1 2 avem:
	/*
	s = 7, t = 8
	nodurile 1 2 3 4 5 6, unde practic 1 = 4, 2 = 5 si 3 = 6;
	muchiile sunt:
	1-5, 1-6, (nu si 1-4 pt ca 1 = 4)
	2-4, 2-6, (nu si 2-5)
	3-4, 3-5, (nu si 3-6)
	*toate muchiile de sus au capacitatea 1
	s-1, s-2, s-3 (unde capacitatea muchiei s-i = iesire[i])
	4-t, 5-t, 6-t (unde capacitatea muchiei i-t = intrare[i-n])
	in plus, lista de adiacenta contine si muchiile inverse, deci este varianta
	neorientata a grafului descris mai sus
	*/

	//e un exemplu in 1 (***)

	ifstream f("secvente.in");
	int m, s, t;
	f >> n;
	s = 2 * n + 1; t = 2 * n + 2;
	c = new int* [2 * n + 3];
	for (int i = 1; i <= 2 * n + 2; i++)
		c[i] = new int[2 * n + 3];
	for (int i = 1; i <= 2 * n + 2; i++)
		for (int j = 1; j <= 2 * n + 2; j++)
			c[i][j] = 0;

	vector<int> intrare(n + 1);
	vector<int> iesire(n + 1);
	list = new vector<int>[2 * n + 3];

	for (int i = 1; i <= n; i++) {
		f >> intrare[i];
	}
	for (int i = 1; i <= n; i++) {
		f >> iesire[i];
	}

	for (int i = 1; i <= n; i++) {
		for (int j = 1; j <= n; j++)
			if (i != j) {
				list[i].push_back(j + n);
				list[j + n].push_back(i);
				c[i][j + n] = 1;
			}
	}

	for (int i = 1; i <= n; i++) {
		c[s][i] = iesire[i];
		list[s].push_back(i);
		list[i].push_back(s);
	}
	for (int i = n + 1; i <= 2 * n; i++) {
		c[i][t] = intrare[i - n];
		list[i].push_back(t);
		list[t].push_back(i);
	}

	int flow = maxFlow(s, t);

	for (int i = 1; i <= n; i++)
		for (int j = n + 1; j < 2 * n + 2; j++) {
			if (c[i][j] == 0 && i != j - n) //daca muchia dintre i si j a fost aleasa
				cout << i << " " << j - n << endl;
		}

	for (int i = 1; i <= 2 * n + 2; i++)
		delete[] c[i];
	delete[] c;

	return 0;
}
/*
3
2 1 1
1 1 2
=>
1 3
2 1
3 1
3 2
*/