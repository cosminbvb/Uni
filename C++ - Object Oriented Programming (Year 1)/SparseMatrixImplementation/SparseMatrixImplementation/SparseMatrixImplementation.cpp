// SparseMatrixImplementation.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
#include "SparseMatrix.h"
#include <iostream>
#include <fstream>
#include <cassert>
using namespace std;

void Tests() {
	ifstream f("input.txt");
	ifstream g("input2.txt");
	SparseMatrix m1, m2, m1plus2, m1minus2, m1power5, m4, m5, m45, m4mul8, m6;
	f >> m1 >> m2 >> m1plus2 >> m1minus2 >> m1power5;
	g >> m4 >> m5 >> m45>> m4mul8;
	m6 = m1;
	assert(m1 == m6);
	assert((m1 + m2) == m1plus2);
	assert((m1 - m2) == m1minus2);
	assert(m4 * m5 == m45);
	assert(m4 * 8 == m4mul8);
	assert((m1 ^ 5) == m1power5);
	double* line1;
	line1 = m1[2];
	double* line2 = new double[5]{ 5, 0, 0, 0, 1 };
	for (int i = 0; i < 5; i++) {
		assert(line1[i] == line2[i]);
	}
	delete[]line1;
	delete[]line2;
	assert(m45.getNumberOfLines() == 2 && m45.getNumberOfColumns() == 2);
}

int main()
{
	Tests();

	return 0;
	
}



