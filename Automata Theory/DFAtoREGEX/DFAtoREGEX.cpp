// DFAtoREGEX.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <fstream>
#include <map>
#include <string>
#include <set>
#include <algorithm> 
using namespace std;

ifstream f("dfa.txt");
ofstream g("regex.txt");

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

int findMax(set<int> my_set)
{
	int max_element;
	if (!my_set.empty())
	{
		max_element = *(my_set.rbegin());
		return max_element;
	}
	return 0;
}

int findMin(set<int> my_set)
{
	int min_element;
	if (!my_set.empty()) {
		min_element = *my_set.begin();
		return min_element;
	}
	return 0;
}

void readDFA(int& nrStates, set<int>& Q, int& nrLetters, set<char>& Sigma, int& nrTransitions, map<pair<int, string>, int>& delta, int& q0, int& nrFinalStates, set<int>& F) {
	f >> nrStates;
	for (int i = 0; i < nrStates; ++i)
	{
		int q;
		f >> q;
		Q.insert(q);
	}

	f >> nrLetters;
	for (int i = 0; i < nrLetters; ++i)
	{
		char ch;
		f >> ch;
		Sigma.insert(ch);
	}

	f >> nrTransitions;
	for (int i = 0; i < nrTransitions; ++i)
	{
		int s, d;
		string ch;
		f >> s >> ch >> d;
		delta[{s, ch}] = d;
	}

	f >> q0;

	f >> nrFinalStates;
	for (int i = 0; i < nrFinalStates; ++i)
	{
		int q;
		f >> q;
		F.insert(q);
	}
}

void printDFA(int& nrStates, set<int>& Q, int& nrLetters, set<char>& Sigma, int& nrTransitions, map<pair<int, string>, int>& delta, int& q0, int& nrFinalStates, set<int>& F) {
	g << nrStates << endl;
	for (int stare : Q)
		g << stare << " ";
	g << endl;
	g << nrLetters << endl;
	for (char litera : Sigma)
		g << litera << " ";
	g << endl;
	g << nrTransitions << endl;
	map<pair<int, string>, int>::iterator it = delta.begin();
	while (it != delta.end()) {
		pair<int, string> cheie = it->first;
		int stare1 = cheie.first;
		string litera = cheie.second;
		int stare2 = it->second;
		g << stare1 << " " << litera << " " << stare2 << endl;
		it++;
	}
	g << q0 << endl;
	g << nrFinalStates << endl;
	for (int final : F)
		g << final << " ";
	g << endl;
}

void modifyInitialState(int& nrStates, set<int>& Q, int& nrLetters, set<char>& Sigma, int& nrTransitions, map<pair<int, string>, int>& delta, int& q0) {

	//daca exista tranzitii care intra in starea initiala, se adauga o noua stare
	//initiala qi si o lambda-tranzitie de la qi la vechea stare initiala

	//if there is any transition that ends in q0 (the given initial state), we make another state which becomes
	//the new initial state and we add the transition delta(old q0, lambda) = new q0
	map<pair<int, string>, int>::iterator it = delta.begin();
	while (it != delta.end()) {
		pair<int, string> cheie = it->first;
		int stare1 = cheie.first;
		string litera = cheie.second;
		int stare2 = it->second;
		if (stare2 == q0) {
			int minim = findMin(Q);
			Q.insert(minim - 1);
			delta[{minim - 1, "."}] = q0;
			Sigma.insert('.');
			nrTransitions++;
			nrStates++;
			nrLetters++;
			q0 = minim - 1;
			break;
		}
		it++;
	}
}

void modifyFinalState(int& nrStates, set<int>& Q, int& nrLetters, set<char>& Sigma, int& nrTransitions, map<pair<int, string>, int>& delta, int& nrFinalStates, set<int>& F) {

	// verificam daca exista vreo tranzitie care pleaca dintr-o stare finala
	// verifying if there is any transition starting from any final state
	int nuexista = 1; // presupunem ca nu exsita
	map<pair<int, string>, int>::iterator it = delta.begin();
	while (it != delta.end()) {
		int destinatie = it->second;
		if (F.find(destinatie) != F.end()) { // daca destinatie e stare finala
			nuexista = 0; // deci exista tranzitie catre o stare finala
			break;
		}
		it++;
	}

	// daca sunt mai multe stari finale sau exista tranzitii care pleaca dintr-o 
	// stare finala, facem o noua stare si o legam de vechile stari finale prin 
	// lambda tranzitii

	// if we have more than one final state or we have any transition starting from 
	// a final state, we make a new final state and add lambda-transitions from each
	// old final state to the new one
	if (nrFinalStates > 1 || nuexista == 0) {
		nrStates++;
		int maxim = findMax(Q);
		Q.insert(maxim + 1);
		for (int final : F) {
			delta[{final, "."}] = maxim + 1;
			nrTransitions++;
			if (Sigma.find('.') == Sigma.end()) { // daca nu exista lambda in sigma
				nrLetters++;
				Sigma.insert('.');
			}
		}
		F.clear();
		F.insert(maxim + 1);
		nrFinalStates = 1;
	}
}

string isTransition(int a, int b, map<pair<int, string>, int>& delta) {

	map<pair<int, string>, int>::iterator it = delta.begin();
	string temp="";
	while (it != delta.end()) {
		if (it->first.first == a && it->second == b)
			if (temp == "") temp = it->first.second;
			else temp += "+" + it->first.second;
		it++;
	}
	return temp;
}

void removeState(int stare, int& nrStates, set<int>& Q, int& nrTransitions, map<pair<int, string>, int>& delta) {
	string expresie;
	set<int> in, out;
	map<pair<int, string>, int>::iterator it = delta.begin();
	while (it != delta.end()) {
		pair<int, string> cheie = it->first;
		int stare1 = cheie.first;
		int stare2 = it->second;
		if (stare1 == stare && stare2 != stare) out.insert(stare2);
		if (stare2 == stare && stare1 != stare) in.insert(stare1);
		it++;
	}
	for (int intrare : in) {
		for (int iesire : out) {
			//produs cartezian
			/*
			Presupunem că vrem să eliminăm starea qk şi că există etichetele (qi,qk), (qk,qj) şi eventual bucla
			(qk, qk).Atunci obţinem noua etichetă între stările qi şi qj reunind[(fosta etichetă directă de la qi la
			qj), sau nimic(∅) dacă nu există drum direct] cu[(eticheta de la qi la qk) concatenată cu(stelarea
			etichetei buclei de la qk la qk, sau λ dacă bucla nu există) concatenată cu(eticheta de la qk la qj)].
			*/
			if (isTransition(intrare, iesire, delta) != "") {
				string expresie = "(" + isTransition(intrare, iesire, delta) + "+";
				string a = isTransition(intrare, stare, delta);
				string b = isTransition(stare, stare, delta);
				string c = isTransition(stare, iesire, delta);
				if (a == ".")
					if (b == "" && c == ".")
						expresie += a;
					else {
						if (b != "") {
							if (b.length() == 1) b += "*";
							else b = "(" + b + ")*";
							expresie += b;
							if (c != ".") expresie += c;
						}
						else expresie += c;
					}
				else {
					expresie += a;
					if (b != "") {
						if (b.length() == 1) b += "*";
						else b = "(" + b + ")*";
						expresie += b;
					}
					if (c != ".") expresie += c;
				}
				expresie += ")";

				for (map<pair<int, string>, int>::iterator it2 = delta.begin(); it2 != delta.end();) {
					if (it2->first.first == intrare && it2->second == iesire)
					{
						//stergem toate tranzitiile intrare->iesire pentru a o adauga pe cea noua
						it2 = delta.erase(it2);
						nrTransitions--;
					}
					else it2++;
				}
				delta[{intrare, expresie}] = iesire;
				nrTransitions++;
			}
			else {
				string a = isTransition(intrare, stare, delta);
				string b = isTransition(stare, stare, delta);
				string c = isTransition(stare, iesire, delta);
				if (a == ".") {
					if (b == "" && c == ".") expresie = a;
					else {
						if (b != "") {
							if (b.length() == 1) b += "*";
							else b = "(" + b + ")*";
							expresie = b;
							if (c != ".") expresie += c;
						}
						else
							expresie = c;
					}
				}
				else {
					expresie = a;
					if (b != "") {
						if (b.length() == 1) b += "*";
						else b = "(" + b + ")*";
						expresie += b;
					}
					if (c != ".") expresie += c;
				}
				delta[{intrare, expresie}] = iesire;
				nrTransitions++;
			}
		}
	}
	for (map<pair<int, string>, int>::iterator it2 = delta.begin(); it2 != delta.end();) {
		if (it2->first.first == stare || it2->second == stare)
		{
			//stergem toate tranzitiile care contin starea
			it2 = delta.erase(it2);
			nrTransitions--;
		}
		else it2++;
	}
}

void removeStates(int& nrStates, set<int>& Q, int& nrTransitions, map<pair<int, string>, int>& delta) {
	//removing each state except from the initial and final 
	int initial = findMin(Q);
	int final = findMax(Q);
	for (int i : Q) {
		if (i > initial && i < final) removeState(i, nrStates, Q, nrTransitions, delta);
	}
	for (auto it = Q.begin(); it != Q.end(); ) {
		if (*it > initial && *it < final) {
			Q.erase(it++);
			nrStates--;
		}
		else {
			++it;
		}
	}
}

void replaceAll(std::string& str, const std::string& from, const std::string& to) {
	if (from.empty())
		return;
	size_t start_pos = 0;
	while ((start_pos = str.find(from, start_pos)) != std::string::npos) {
		str.replace(start_pos, from.length(), to);
		start_pos += to.length();
	}
}

void DFAtoREGEX(int& nrStates, set<int>& Q, int& nrLetters, set<char>& Sigma, int& nrTransitions, map<pair<int, string>, int>& delta, int& q0, int& nrFinalStates, set<int>& F) {
	
	modifyInitialState(nrStates, Q, nrLetters, Sigma, nrTransitions, delta, q0);

	modifyFinalState(nrStates, Q, nrLetters, Sigma, nrTransitions, delta, nrFinalStates, F);

	g << "Regular expression:" << endl;

	removeStates(nrStates, Q, nrTransitions, delta);

	string final = delta.begin()->first.second;

	replaceAll(final, ".", "lambda");

	g << final;
}

int main()
{
	// M = (Q,Σ,δ,q0,F)
	// ! the symbol for lambda is . 

#pragma region declars

	set<int> Q, F;
	set<char> Sigma;
	int q0;
	map<pair<int, string>, int> delta;

	int noOfStates;
	int noOfLetters;
	int noOfTransitions;
	int noOfFinalStates;

#pragma endregion

	readDFA(noOfStates, Q, noOfLetters, Sigma, noOfTransitions, delta, q0, noOfFinalStates, F);

	DFAtoREGEX(noOfStates, Q, noOfLetters, Sigma, noOfTransitions, delta, q0, noOfFinalStates, F);

	return 0;
}
