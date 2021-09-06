// Algoritm CYK
#include <iostream>
#include <map>
#include <set>
#include <string>

using namespace std;

map<string, set<string>> P;
set<string> N;
set<string> Sigma;
string S;

void configGrammar()
{
	P["S"].insert("AB"); P["S"].insert("BC");
	P["A"].insert("AB"); P["A"].insert("a");
	P["B"].insert("CC"); P["B"].insert("b");
	P["C"].insert("AB"); P["C"].insert("a");
	N.insert("S"); N.insert("A"); N.insert("B"); N.insert("C");
	Sigma.insert("a"); Sigma.insert("b");
	S = "S";
}

set<string> cartesianProduct(set<string> set1, set<string> set2)
{
	set<string> result;
	for (auto str1 : set1)
	{
		for (auto str2 : set2)
		{
			result.insert(str1 + str2);
		}
	}
	return result;
}

set<string> productionGeneratedBy(string prod)
{
	set<string> result;
	for (auto n : N)
	{
		for (auto p : P[n])
		{
			if (p == prod)
			{
				result.insert(n);
			}
		}
	}
	return result;
}

set<string> replaceProductionWithGenerators(set<string> productions)
{
	set<string> result;
	for (auto prod : productions)
	{
		set<string> generatedBy = productionGeneratedBy(prod);
		for (auto gb : generatedBy)
		{
			result.insert(gb);
		}
	}
	return result;
}

bool CYK(string word)
{
	set<string> V[25][25];
	int n = word.length();

	for (int i = 1; i <= n; ++i)
	{
		V[i][1] = productionGeneratedBy(word.substr(i - 1, 1));
	}

	// Vij = U (0 < k < j) din Vik x V(i+k)(j-k)

	for (int j = 2; j <= n; ++j)
	{
		for (int i = 1; i <= n - j + 1; ++i)
		{
			set<string> Vij;
			for (int k = 1; k < j; ++k)
			{
				set<string> cartProd = cartesianProduct(V[i][k], V[i + k][j - k]);
				set<string> generatedBy = replaceProductionWithGenerators(cartProd);
				for (auto gb : generatedBy)
				{
					Vij.insert(gb);
				}
			}
			V[i][j] = Vij;
		}
	}

	for (auto generated : V[1][n])
	{
		if (generated == S)
		{
			return true;
		}
	}

	return false;
}


int main()
{
	configGrammar();
	if (CYK("bab")) // "aaab" acceptat si el
	{
		cout << "Cuvant acceptat";
	}
	else
	{
		cout << "Cuvant respins";
	}
	return 0;
}