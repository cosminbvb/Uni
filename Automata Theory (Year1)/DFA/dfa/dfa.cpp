﻿#include "pch.h"
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
transitions (state character state) (δ or delta)
initial state (q0)
number of final states 
final states (F)
*/
class DFA
{
	// M = (Q,Σ,δ,q0,F) 
	set<int> Q, F;
	set<char> Sigma;
	int q0;
	map<pair<int, char>, int> delta;

public:
	DFA() { this->q0 = 0; }
	DFA(set<int> Q, set<char> Sigma, map<pair<int, char>, int> delta, int q0, set<int> F)
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
	int getInitialState() const { return this->q0; }
	map<pair<int, char>, int> getDelta() const { return this->delta; }

	friend istream& operator >> (istream&, DFA&);

	bool isFinalState(int);
	int deltaStar(int, string);
};

bool DFA::isFinalState(int q)
{
	return F.find(q) != F.end();
}

int DFA::deltaStar(int q, string w)
{
	if (w.length() == 1)
	{
		return delta[{q, (char)w[0]}];
	}

	int new_q = delta[{q, (char)w[0]}];
	return deltaStar(new_q, w.substr(1, w.length() - 1));
}

istream& operator >> (istream& f, DFA& M)
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
		int s, d;
		char ch;
		f >> s >> ch >> d;
		M.delta[{s, ch}] = d;
	}

	f >> M.q0;

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
	DFA M;

	ifstream fin("dfa.txt");
	fin >> M;
	fin.close();
	//ab is an accepted word given the example input in dfa.txt;
	char s[100];
	cout << "Enter word\n";
	cin >> s;
	int lastState = M.deltaStar(M.getInitialState(), s);

	if (M.isFinalState(lastState))
	{
		cout << "Cuvant acceptat (Word Accepted)";
	}
	else
	{
		cout << "Cuvant respins (Word Denied)";
	}

	return 0;
}
