#include <iostream>
#include <vector>
#include <string>
#include <set>
#include <map>
using namespace std;

class CFG {

private:

    // G = (N,T,S,P)
    map<string, set<vector<string>>>P; //productions
    set<string>N; //non-terminals
    set<string>T; //terminals
    string S; //start symbol

public:

    CFG() = default;
    CFG(map<string, set<vector<string>>>P, set<string>N, set<string>T, string S) :P(P), N(N), T(T), S(S) {};
    CFG(const CFG&); //copy constructor used in step2()
    void printGrammar();
    void toCNF();

    //METHODS FOR TESTING:

    friend void config1(CFG&); //used a custom CFG for testing
    friend void config2(CFG&); //used a custom CFG for testing
    friend void config3(CFG&); //used a custom CFG for testing

protected:

    //METHODS FOR CFG->CNF conversion:

    void step1(); //removes unusable and inaccesible non-terminals and productions
    void step2(); //removing lambda-productions
    void step3(); //eliminating N->N productions
    //step1() needs to be called once again after step3() is done
    void step4(); //replacing terminals that are part of a word with len>=2 with new non-terminals
    void step5(); //step4 turned some of the productions into productions of type N->T so we need to turn the remaining into N->NN

protected:

    //HELPER METHODS:

    set<string> usableN(); //returns the usable non-terminals
    void removeUnusable(); //removes unusable non-terminals and productions
    void removeInaccessible(); //removes inaccessbile non-terminals and productions
    bool hasLambda();

};

