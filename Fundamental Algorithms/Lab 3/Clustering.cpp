#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <unordered_map>
#include <algorithm>

using namespace std;

string tail(string& source) {
	return source.substr(1, source.length() - 1);
}

//Levenshtein dustance
//https://en.wikipedia.org/wiki/Levenshtein_distance
int lev(string a, string b) {

	if (b.length() == 0)
		return a.length();
	else if (a.length() == 0)
		return b.length();
	else if (a[0] == b[0])
		return lev(tail(a), tail(b));
	else {
		int min_aux = min(lev(tail(a), b), lev(a, tail(b)));
		return 1 + min(min_aux, lev(tail(a), tail(b)));
	}
}

string find(string x, unordered_map<string, string>& tata) {

	while (tata[x] != "")
		x = tata[x];
	return x;
}

void Union(string x, string y, unordered_map<string, string>& tata, unordered_map<string, int>& inaltime) {

	string reprez1 = find(x, tata);
	string reprez2 = find(y, tata);
	if (inaltime[reprez1] > inaltime[reprez2]) {
		tata[reprez2] = reprez1;
	}
	else if (inaltime[reprez1] < inaltime[reprez2]) {
		tata[reprez1] = reprez2;
	}
	else {
		tata[reprez1] = reprez2;
		inaltime[reprez2]++;
	}
}

void kruskal(int n, int k, vector<string>& cuv, vector<pair<int, pair<string, string>>>& dist) {

	unordered_map<string, string> tata;
	unordered_map<string, int> inaltime;
	unordered_map<string, vector<string>>groups;
	for (int i = 0; i < n; i++) {
		inaltime[cuv[i]] = 0;
		tata[cuv[i]] = "";
	}
	int muchii = 0;
	int grad = INT_MAX;
	for (auto elem : dist) {
		if (muchii == n - k) {
			grad = elem.first;
			break;
		}
		int d = elem.first;
		string a = elem.second.first;
		string b = elem.second.second;
		if (find(a, tata) != find(b, tata)) {
			Union(a, b, tata, inaltime);
			muchii++;
		}
	}
	for (auto x : tata) {
		groups[find(x.first, tata)].push_back(x.first);
	}
	for (auto group : groups) {
		for (auto str : group.second) {
			cout << str << " ";
		}
		cout << endl;
	}
	cout << grad;
}

int main()
{

	ifstream f("cuvinte.in"); //aici sunt doar cuvinte separate prin spatiu
	vector<string>cuv;
	string s;
	while (f >> s) {
		cuv.push_back(s);
	}

	vector<pair<int, pair<string, string>>>dist; //{dist {word1, word2}}
	for (int i = 0; i < cuv.size(); i++) {
		for (int j = i + 1; j < cuv.size(); j++) {
			int d = lev(cuv[i], cuv[j]);
			dist.push_back({ d, {cuv[i], cuv[j]} });
		}
	}

	sort(dist.begin(), dist.end());
	int k;
	cout << "k: ";  cin >> k;

	kruskal(cuv.size(), k, cuv, dist);

	return 0;
}

