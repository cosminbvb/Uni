#include "pch.h"
#include <iostream>
#include <map>
#include <string>
#include <set>
#include <fstream>
using namespace std;
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

class NFA
{
	// M = (Q,Σ,δ,q0,F) 
	set<int>Q,F;
	set<char>Sigma;
	set<int>q0;
	map<pair<int, char>, set<int>>delta;

public:
	NFA() { this->q0.insert(0); }
	NFA(set<int> Q, set<char> Sigma, map<pair<int, char>, set<int>> delta, set<int> q0, set<int> F)
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

	friend istream& operator >> (istream&, NFA&);

	bool hasFinalState(set<int>);
	set<int> deltaStar(set<int>, string);
};

bool NFA::hasFinalState(set<int>q)
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

set<int> NFA::deltaStar(set<int> s, string w)
{
	int n = w.length();
	set<int> localFinalStates;
	//din prima stare in care suntem
	//(pentru ca suntem intr-un set<int> s)
	//adaugam in localFinalStates
	//toate tranzitiile cu prima litera din w
	int firstelement = *s.begin();
	for (int j : delta[{firstelement,w[0]}])
	{
		localFinalStates.insert(j);
	}
	// am efectuat o tranzitie, micsorez n-ul
	n--;
	//daca n=0=0, inseamna ca returnez starile finale adaugate
	if (n == 0) {
		return localFinalStates;
	}
	int contor = 0;
	//altfel, cat timp n!=0
	while (n) {
		set<int> aux;
		//ma mut in starile finale in care am ajuns efectuand o tranzitie
		//i.e. daca din din 0 cu a a am ajuns in 1 3 4 5 acum iterez {1,3,4,5}
		//pentru a face tranzitii cu urmatoarea litera si stochez starile in auxiliar
		for (int i : localFinalStates) {
			for (int j : delta[{i, w[contor + 1]}]) {
				aux.insert(j);
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

istream& operator >> (istream& f, NFA& M)
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
	f >> noOfInitialStates ;
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

int main()
{
	NFA M;

	ifstream fin("nfa.txt");
	fin >> M;
	fin.close();
	char s[100];
	cout << "Enter word\n";
	cin >> s;
	set<int> lastStates = M.deltaStar(M.getInitialStates(), s);
	// example of accepted words for the input given in nfa.txt : b, aab, aabb;
	// example of denied words -//- : a, aa, aaba;
	if (M.hasFinalState(lastStates))
	{
		cout << "Cuvant acceptat (Word Accepted)";
	}
	else
	{
		cout << "Cuvant respins (Word Denied)";
	}

	return 0;
}