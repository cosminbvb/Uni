#include<iostream>
using namespace std;

#pragma once

class SparseMatrix
{

	int nrLines, nrColumns;
	int nrElements;//number of elements != 0
	double* elements; //array of the elements !=0 
	int* lines, * cols; //arrays for coordinates

    //Obs:
	//decided to use 3 arrays instead of a matrix with 3 lines because if we want to store double elements, an element would require int*2+double=16 bytes
	//instead of double*3=24 bytes (with the matrix approach) even if it is not really user friendly.

	public:
		SparseMatrix();
		SparseMatrix(int, int, double*, int*, int*);//constructor for M(n*n)
		SparseMatrix(int, int, int, double*,int*,int*);//constructor for M(n*m)
		SparseMatrix(const SparseMatrix&); //copy constructor
		~SparseMatrix();//destructor

		//Operator Overloading 
		friend SparseMatrix operator+(const SparseMatrix&, const SparseMatrix&); // SparseMatrix + SparseMatrix
		friend SparseMatrix operator-(const SparseMatrix&, const SparseMatrix&); // SparseMatrix - SparseMatrix
		friend SparseMatrix operator*(const SparseMatrix&, const SparseMatrix&); // SparseMatrix * SparseMatrix
		friend SparseMatrix operator*(const SparseMatrix&, double); // SparseMatrix * value
		friend SparseMatrix operator^(const SparseMatrix&, int); // (SparseMatrix)^power
		friend istream& operator>>(istream&, SparseMatrix&);
		friend ostream& operator<<(ostream&, const SparseMatrix&);
	    double* operator[](int) const;
		SparseMatrix operator=(const SparseMatrix&);
		bool operator==(const SparseMatrix&);

		//getters
		int getNumberOfLines();
		int getNumberOfColumns();
	
	protected:
		//Helper Methods
		static int comparePositions(int, int, int, int);
		static int nrOverlapsPlus(const SparseMatrix&, const SparseMatrix&);
		static int nrOverlapsMinus(const SparseMatrix&, const SparseMatrix&);
		SparseMatrix transpose() const;

		
};

