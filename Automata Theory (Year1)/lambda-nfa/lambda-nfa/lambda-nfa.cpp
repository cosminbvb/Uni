#include <iostream>
#include <map>
#include <string>
#include <set>
#include <queue>
#include <fstream>
using namespace std;
//the used symbol for reading Lambda is '#'
// structure of input file:
/*
number of states
states (Q)
number of characters
each character (Σ or Sigma)
number of transitions
transitions (state character numberofstates states) (δ or delta)
nr of initial states
initial states (q0)
number of final states
final states (F)
*/

class LNFA
{
	// M = (Q,Σ,δ,q0,F) 
	set<int>Q, F;
	set<char>Sigma;
	set<int>q0;
	map<pair<int, char>, set<int>>delta;

public:
	LNFA() { this->q0.insert(0); }
	LNFA(set<int> Q, set<char> Sigma, map<pair<int, char>, set<int>> delta, set<int> q0, set<int> F)
	{
		this->Q = Q;
		this->Sigma = Sigma;
		this->delta = delta;
		this->q0 = q0;
		this->F = F;
	}

	set<int> getQ() const { return this->Q; }
	set<int> getF() const { return this->F; }
	set<char> getSigma() const { return this->Sigma; }
	set<int> getInitialStates() const { return this->q0; }
	map<pair<int, char>, set<int>> getDelta() const { return this->delta; }

	friend istream& operator >> (istream&, LNFA&);

	bool hasFinalState(set<int>);
	set<int> deltaStar(set<int>, string);
	set<int> lambdaInchidere(int); 
};

bool LNFA::hasFinalState(set<int>q)
{
	for (int i : q) {
		for (int j : F) {
			if (i == j) {
				return true;
			}
		}
	}
	return false;
}

set<int> LNFA::deltaStar(set<int> s, string w)
{
	int n = w.length();
	set<int> localFinalStates;
	set<int> s2;
	s2 = lambdaInchidere(*s.begin()); //lambda inchiderea primei stari din s
	for (int i : s2) 
	{
		for (int j : delta[{i, w[0]}]) 
		{
			//tranzitiile cu prima litera ale fiecarei stari din lambda inchiderea primei stari din s
			localFinalStates.insert(j);
		}
	}
	// am efectuat o tranzitie, micsorez n-ul
	n--;
	//daca n==0, inseamna ca returnez starile finale adaugate
	if (n == 0) {
		return localFinalStates;
	}
	int contor = 0;
	//altfel, cat timp n!=0
	while (n) {
		set<int> aux;
		//ma mut in starile finale in care am ajuns efectuand o tranzitie
		//i.e. daca din din 0 cu a am ajuns in 1 3 4 5 acum iterez {1,3,4,5}
		//pentru a face tranzitii cu urmatoarea litera si stochez starile in auxiliar
		for (int i : localFinalStates) {
			for (int stare : lambdaInchidere(i)) { //lambda inchiderea fiecarei stari din local
				for (int j : delta[{stare, w[contor + 1]}]) { //tranzitiile cu urmatoarea litera a fiecarei stari din lambda inchidere
					aux.insert(j);
				}
			}
		}
		n--;
		contor++;
		//golesc set-ul de localFinalStates
		localFinalStates.clear();
		//mut din aux in localFinalStates
		for (int i : aux) {
			localFinalStates.insert(i);
		}
		aux.clear();
	}
	return localFinalStates;
}

istream& operator >> (istream& f, LNFA& M)
{
	int noOfStates;
	f >> noOfStates;
	for (int i = 0; i < noOfStates; ++i)
	{
		int q;
		f >> q;
		M.Q.insert(q);
	}

	int noOfLetters;
	f >> noOfLetters;
	for (int i = 0; i < noOfLetters; ++i)
	{
		char ch;
		f >> ch;
		M.Sigma.insert(ch);
	}

	int noOfTransitions;
	f >> noOfTransitions;
	for (int i = 0; i < noOfTransitions; ++i)
	{
		int s, nr;
		set<int> states;
		char ch;
		f >> s >> ch >> nr;
		for (int j = 0; j < nr; j++)
		{
			int S;
			f >> S;
			states.insert(S);
		}
		M.delta[{s, ch}] = states;
	}
	int noOfInitialStates;
	f >> noOfInitialStates;
	for (int i = 0; i < noOfInitialStates; ++i)
	{
		int q;
		f >> q;
		M.q0.insert(q);
	}


	int noOfFinalStates;
	f >> noOfFinalStates;
	for (int i = 0; i < noOfFinalStates; ++i)
	{
		int q;
		f >> q;
		M.F.insert(q);
	}

	return f;
}

set<int> LNFA::lambdaInchidere(int q) {
	set<int> s = delta[{q,'#'}];
	s.insert(q);
	queue<int> coada;
	for (int i : s) {
		coada.push(i);
	}
	while (coada.size()) {
		int a = coada.front();
		for (int j : delta[{a, '#'}]) {
			bool exists = s.find(j) != s.end(); // 1 daca j exista in s, 0 altfel
			if (!exists) {
				coada.push(j);
				s.insert(j);
			}
		}
		coada.pop();
	}
	return s;

}

int main()
{
	LNFA M;
	// 2 given input files for testing;
	ifstream fin("lambda-nfa.txt");
	// example of accepted words for the input given in lambda-nfa.txt : a, aa, ba, aaba, aabaa, aba ;
	// example of denied words -//- : any word ending in b ;
	//------------------------------------
	//ifstream fin("lambda-nfa-test2.txt");
	// example of accepted words for the input given in lambda-nfa-test2.txt : a, aa, abaa, abab ;
	// example of denied words -//- : b,bb, bba, bbab ;
	fin >> M;
	fin.close();
	char s[100];
	cout << "Enter word\n";
	cin >> s;
	int ok = 0;
	set<int> lastStates = M.deltaStar(M.getInitialStates(), s); 
	for(int i:lastStates){
		if (M.hasFinalState(M.lambdaInchidere(i)))//facem lambdaInchidere pentru fiecare stare cu care am terminat si vedem daca inchiderea contine vreo stare finala
		{
			ok = 1;
		}
	}
	if (ok) { //daca a continut cel putin o stare finala => acceptat
		cout << "Cuvant acceptat (Word Accepted)";
	}
	else {
		cout << "Cuvant respins (Word Denied)";
	}
	return 0;
}