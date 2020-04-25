#include <iostream>
#include <map>
#include <string>
#include <set>
#include <vector>
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
	friend ostream& operator << (ostream&, DFA&);
	bool isFinalState(int);
	int deltaStar(int, string);
	void minimize();

protected: //helpers
	bool isTransition(int, char);
};

bool DFA::isTransition(int q, char c) {
	map<pair<int, char>, int>::iterator it = delta.begin();
	while (it != delta.end()) {
		if (it->first.first == q && it->first.second == c)
			return 1;
		it++;
	}
	return 0;
}

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

ostream& operator << (ostream& out, DFA& M) {
	out << M.Q.size()<<endl;
	for (auto i : M.Q)
		out << i << " ";
	out << endl;
	out << M.Sigma.size() << endl;
	for (auto i : M.Sigma)
		out << i << " ";
	out << endl;
	out << M.delta.size() << endl;
	map<pair<int, char>, int>::iterator it = M.delta.begin();
	while (it != M.delta.end())
	{
		out << it->first.first << " " << it->first.second << " " << it->second << endl;
		it++;
	}
	out << M.q0 << endl;
	out << M.F.size() << endl;
	for (auto i : M.F)
		out << i << " ";
	out << endl;
	
	return out;
}

void DFA::minimize() {

	//considering it is a complete dfa

	//building buckets for states that have the same behaviour
	//construim bucketuri pentru starile care se comporta la fel
	vector<int> temp; 
	map<vector<int>, vector<int>> buckets;
	for (int q : Q) {
		temp.clear(); 
		int exists = 0;
		for (char c : Sigma)
			//temp stores the states that result from delta(q, each character from Sigma)
			//in temp stocam starile care rezulta din delta(q, ficare char din Sigma)
			temp.push_back(delta[{q, c}]); //transition array for each state
		map<vector<int>, vector<int>>::iterator it = buckets.begin();
		while (it != buckets.end()) {
			//checking if temp is already a bucket
			//verificam daca temp este deja un bucket
			if (temp == it->first) {
				it->second.push_back(q); 
				// if it is, then put the current state in the matching bucket
				// daca exista, punem starea curenta in bucket
				exists = 1;
				break;
			}
			it++;
		}
		if (!exists) {
			//if the bucket doesn t exist yet, we create it
			//daca bucketul nu exista, il facem
			vector<int> states;
			states.push_back(q);
			buckets[temp] = states;
		}
		
	}

	//building new delta
	//construim noul delta
	map<pair<vector<int>, char>, vector<int>> newDelta;
	map<vector<int>, vector<int>>::iterator it = buckets.begin();
	map<vector<int>, vector<int>>::iterator it2;
	map<pair<vector<int>, char>, vector<int>>::iterator it3; //used later for newDelta 
	while (it != buckets.end()) {
		int nr = 0;
		for (char c : Sigma) {
			//for each bucket, we get the first state and search for the bucket
			//in which we find the state that results from delta(state, each character from Sigma)
			//newDelta will look like bucket+character->bucket

			int toFind = delta[{it->second[0], c}];
			bool found = false;
			it2 = buckets.begin();
			while (it2 != buckets.end()) {
				for(int j=0;j<it2->second.size();j++)
					if (it2->second[j] == toFind) {
						newDelta[{it->second, c}] = it2->second;
						found = true;
						it2 = buckets.end();
						break;
					}
				if (!found)it2++;
			}
		}
		it++;
	}

	//building new initial state (now it might be an array)
	//construim noua stare/stari initiale
	vector<int> newInitial;
	it = buckets.begin();
	while (it != buckets.end()) {
		bool found = false;
		for (int i = 0; i < it->second.size(); i++)
			if (it->second[i] == this->q0) {
				newInitial = it->second;
				found = true;
				it = buckets.end();
				break;
			}
		if (!found) it++;
	}

	//building new final states array
	//construim noile stari finale
	vector<vector<int>> newFinal;
	for (int i : F) {
		it = buckets.begin();
		bool found = false;
		while (it != buckets.end()) {
			for (int j = 0; j < it->second.size(); j++) {
				if (it->second[j] == i) {
					newFinal.push_back(it->second);
					it = buckets.end();
					found = true;
					break;
				}
			}
			if (!found) it++;
		}
	}

#pragma region Print Minimized DFA with given states
	//this region can be deleted, the purpose of it being just printing the minimized DFA
	//with the states given as input

	//regiune aceasta e facuta doar pentru a printa dfa-ul sub forma clasica (stari compuse)

	cout << "Minimized DFA:" << endl;
	cout << buckets.size() << endl; //printing number of states
	it = buckets.begin();
	while (it != buckets.end()) {
		//printing each state (each state now being an array of states)
		for (int i = 0; i < it->second.size(); i++) cout << it->second[i] << " ";
		cout << "| ";
		it++;
	}
	cout << endl;
	cout << Sigma.size() << endl;
	for (char c : Sigma)cout << c << " "; 
	cout << endl;
	cout << buckets.size() * Sigma.size() << endl;

	//print newDelta
	it3 = newDelta.begin();
	while (it3 != newDelta.end()) {
		for (int i = 0; i < it3->first.first.size(); i++) cout << it3->first.first[i] << " ";
		cout << it3->first.second << " ";
		for (int i = 0; i < it3->second.size(); i++) cout << it3->second[i] << " ";
		cout << endl;
		it3++;
	}
	if (newInitial.size() == 1) cout << newInitial[0];
	else {
		//printing initial state(which now might be an array of states)
		for (int i = 0; i < newInitial.size(); i++) cout << newInitial[i] << " | ";
	}
	cout << endl;
	cout << newFinal.size() << endl; //printing number of final states
	if (newFinal.size() == 1) cout << newFinal[0][0];
	else {
		//printing final states(which now might be an array of arrays)
		for (int i = 0; i < newFinal.size(); i++) {
			for (int j = 0; j < newFinal[i].size(); j++)
				cout << newFinal[i][j] << " ";
			cout << " | ";
		}
	}

#pragma endregion

#pragma region Modifying current DFA

	Q.clear();
	for (int i = 0; i < buckets.size(); i++) Q.insert(i); //we now have buckets.size states
	delta.clear();
	it = buckets.begin();
	map<vector<int>,int> tempMap; //tempMap maps an array of states (with the same behaviour) to a number which indicates a new state
	//for example, if states: 1, 2, 4 have the same behaviour, they will all form a state with index, let's say, 1
	int nrBucket = 0;
	while (it != buckets.end()) {
		tempMap[it->second] = nrBucket;
		nrBucket++;
		it++;
	}
	delta.clear();
	it3 = newDelta.begin();
	while (it3 != newDelta.end()) {
		//here, when we build the old delta, tempMap converts an array of states into a single state
		delta[{tempMap[it3->first.first], it3->first.second}] = tempMap[it3->second];
		it3++;
	}
	F.clear();
	for (int i = 0; i < newFinal.size(); i++) {
		F.insert(tempMap[newFinal[i]]);
	}
	q0 = tempMap[newInitial];

#pragma endregion
}

int main()
{
	DFA M;
	ifstream fin("dfa.txt");
	fin >> M;
	M.minimize();
	cout << endl;
	cout << endl;
	cout << M;
	fin.close();
	return 0;
}