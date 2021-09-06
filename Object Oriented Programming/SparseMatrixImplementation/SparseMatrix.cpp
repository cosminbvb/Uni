#include "SparseMatrix.h"
using namespace std;

#pragma region Constructors and Destructor

SparseMatrix::SparseMatrix(): nrLines(1), nrColumns(1), nrElements(1), elements(new double[1]), lines(new int[1]), cols(new int[1]){}

SparseMatrix::SparseMatrix(int nrLines,int nrElements, double* elements, int* lines, int* cols) {
	this->nrLines = nrLines;
	this->nrColumns = nrLines;
	this->nrElements = nrElements;
	try {
		this->elements = new double[nrElements];
		this->lines = new int[nrElements];
		this->cols = new int[nrElements];
	}
	catch (bad_alloc e) {
		cout << "Allocation Failure\n";
		exit(1);
	}
	for (int i = 0; i < nrElements; i++) {
		this->elements[i] = elements[i];
		this->lines[i] = lines[i];
		this->cols[i] = cols[i];
	}
}

SparseMatrix::SparseMatrix(int nrLines, int nrColumns, int nrElements, double* elements, int* lines, int* cols) {
	this->nrLines = nrLines;
	this->nrColumns = nrColumns;
	this->nrElements = nrElements;
	try {
		this->elements = new double[nrElements];
		this->lines = new int[nrElements];
		this->cols = new int[nrElements];
	}
	catch (bad_alloc e) {
		cout << "Allocation Failure\n";
		exit(1);
	}
	for (int i = 0; i < nrElements; i++) {
		this->elements[i] = elements[i];
		this->lines[i] = lines[i];
		this->cols[i] = cols[i];
	}
}

SparseMatrix::SparseMatrix(const SparseMatrix& m) {
	this->nrLines = m.nrLines;
	this->nrColumns = m.nrColumns;
	this->nrElements = m.nrElements;
	try {
		this->elements = new double[nrElements];
		this->lines = new int[nrElements];
		this->cols = new int[nrElements];
	}
	catch (bad_alloc e) {
		cout << "Allocation Failure\n";
		exit(1);
	}
	for (int i = 0; i < m.nrElements; i++) {
		this->elements[i] = m.elements[i];
		this->lines[i] = m.lines[i];
		this->cols[i] = m.cols[i];
	}
}

SparseMatrix::~SparseMatrix() {
	delete[]elements;
	delete[]lines;
	delete[]cols;
}

#pragma endregion

#pragma region Operator Overloading

SparseMatrix operator+(const SparseMatrix& m1, const SparseMatrix& m2) {
	if (m1.nrLines != m2.nrLines || m1.nrColumns != m2.nrColumns) {
		cout<<"Can't add up matrixes of different sizes";
		exit(1);
	}
	else {
		int i = 0, j = 0, k = 0, cmp;
		int new_nrElements = m1.nrElements + m2.nrElements - SparseMatrix::nrOverlapsPlus(m1, m2);
		int* new_lines;
		int* new_cols;
		double* new_elements;
		try {
			new_lines = new int[new_nrElements];
			new_cols = new int[new_nrElements];
			new_elements = new double[new_nrElements];
		}
		catch (bad_alloc e) {
			cout << "Allocation Failure\n";
			exit(1);
		}
		while (i < m1.nrElements && j < m2.nrElements) {
			cmp = SparseMatrix::comparePositions(m1.lines[i], m1.cols[i], m2.lines[j], m2.cols[j]);
			if (cmp == 1) { 
				new_elements[k] = m1.elements[i];
				new_lines[k] = m1.lines[i];
				new_cols[k] = m1.cols[i];
				i++;
			}
			else {
				if (cmp == -1) {
					new_elements[k] = m2.elements[j];
					new_lines[k] = m2.lines[j];
					new_cols[k] = m2.cols[j];
					j++;
				}
				else {
					double localsum = m1.elements[i] + m2.elements[j];
					if (localsum != 0) {
						new_elements[k] = localsum;
						new_lines[k] = m2.lines[j];
						new_cols[k] = m2.cols[j];
						i++;
						j++;
					}
					else { //if sum is 0 ignore both elements
						i++;
						j++;
					}
				}
			}
			k++;
		}
		while (i < m1.nrElements) {
			new_elements[k] = m1.elements[i];
			new_lines[k] = m1.lines[i];
			new_cols[k] = m1.cols[i];
			i++;
			k++;
		}
		while (j < m2.nrElements) {
			new_elements[k] = m2.elements[j];
			new_lines[k] = m2.lines[j];
			new_cols[k] = m2.cols[j];
			j++;
			k++;
		}
		SparseMatrix result(m1.nrLines, m1.nrColumns, new_nrElements, new_elements, new_lines, new_cols);
		delete[]new_elements;
		delete[]new_lines;
		delete[]new_cols;
		return result;
	}

}

SparseMatrix operator-(const SparseMatrix& m1, const SparseMatrix& m2) {
	if (m1.nrLines != m2.nrLines || m1.nrColumns != m2.nrColumns) {
		cout << "Can't subtract matrixes of different sizes";
		exit(1);
	}
	else {
		int i = 0, j = 0, k = 0, cmp;
		int new_nrElements = m1.nrElements + m2.nrElements - SparseMatrix::nrOverlapsMinus(m1, m2);
		int* new_lines;
		int* new_cols;
		double* new_elements;
		try {
			new_lines = new int[new_nrElements];
			new_cols = new int[new_nrElements];
			new_elements = new double[new_nrElements];
		}
		catch (bad_alloc e) {
			cout << "Allocation Failure\n";
			exit(1);
		}
		while (i < m1.nrElements && j < m2.nrElements) {
			cmp = SparseMatrix::comparePositions(m1.lines[i], m1.cols[i], m2.lines[j], m2.cols[j]);
			if (cmp == 1) {
				new_elements[k] = m1.elements[i];
				new_lines[k] = m1.lines[i];
				new_cols[k] = m1.cols[i];
				i++;
			}
			else {
				if (cmp == -1) {
					new_elements[k] = 0-m2.elements[j];
					new_lines[k] = m2.lines[j];
					new_cols[k] = m2.cols[j];
					j++;
				}
				else {
					double localdif = m1.elements[i] - m2.elements[j];
					if (localdif != 0) {
						new_elements[k] = localdif;
						new_lines[k] = m2.lines[j];
						new_cols[k] = m2.cols[j];
						i++;
						j++;
					}
					else { //if sum is 0 ignore both elements
						i++;
						j++;
					}
				}
			}
			k++;
		}
		while (i < m1.nrElements) {
			new_elements[k] = m1.elements[i];
			new_lines[k] = m1.lines[i];
			new_cols[k] = m1.cols[i];
			i++;
			k++;
		}
		while (j < m2.nrElements) {
			new_elements[k] = 0-m2.elements[j];
			new_lines[k] = m2.lines[j];
			new_cols[k] = m2.cols[j];
			j++;
			k++;
		}
		SparseMatrix result(m1.nrLines, m1.nrColumns, new_nrElements, new_elements, new_lines, new_cols);
		delete[]new_elements;
		delete[]new_lines;
		delete[]new_cols;
		return result;
	}

}

SparseMatrix operator*(const SparseMatrix& m1,const SparseMatrix& m2) {
	if (m1.nrColumns != m2.nrLines) {
		cout << "Can't multiply, dimensions don't match";
		exit(1);
	}
	else {
		SparseMatrix m2t = m2.transpose();
		int result_nrLines = m1.nrLines;
		int result_nrColumns = m2.nrColumns;
		int result_nrElements = 0;
		double* fullLine1 = NULL;
		double* fullLine2 = NULL;
		double localSum = 0;
		int i, j, k;
		for (i = 0; i < result_nrLines; i++) {
			fullLine1 = m1[i];
			for (j = 0; j < result_nrColumns; j++) {
				fullLine2 = m2t[j];
				localSum = 0;
				for (k = 0; k < m1.nrColumns; k++) {
					localSum += fullLine1[k] * fullLine2[k];
				}
				if (localSum != 0) result_nrElements++;
			}
		}
		double* result_elements;
		int* result_lines;
		int* result_columns;
		try {
			result_elements = new double[result_nrElements];
			result_lines = new int[result_nrElements];
			result_columns = new int[result_nrElements];
		}
		catch (bad_alloc e) {
			cout << "Allocation Failure\n";
			exit(1);
		}
		int poz = 0;
		for (i = 0; i < result_nrLines; i++) {
			fullLine1 = m1[i];
			for (j = 0; j < result_nrColumns; j++) {
				fullLine2 = m2t[j];
				localSum = 0;
				for ( k = 0; k < m1.nrColumns; k++) {
					localSum += fullLine1[k] * fullLine2[k];
				}
				if (localSum != 0) {
					result_elements[poz] = localSum;
					result_lines[poz] = i;
					result_columns[poz] = j;
					poz++;
				}
			}
		}
		delete[]fullLine1;
		delete[]fullLine2;
		SparseMatrix result(result_nrLines, result_nrColumns, result_nrElements, result_elements, result_lines, result_columns);
		delete[]result_elements;
		delete[]result_lines;
		delete[]result_columns;
		return result;
	}
}

SparseMatrix operator*(const SparseMatrix& m, double value) {
	double* result_elements;
	try {
		result_elements = new double[m.nrElements];
	}
	catch (bad_alloc a) {
		cout << "Allocation Failure\n";
		exit(1);
	}
	for (int i = 0; i < m.nrElements; i++) {
		result_elements[i] = m.elements[i] * value;
	}
	SparseMatrix result(m.nrLines, m.nrColumns, m.nrElements, result_elements, m.lines, m.cols);
	delete[]result_elements;
	return result;
}

SparseMatrix operator^(const SparseMatrix& m, int power) {
	SparseMatrix result = m;
	for (int i = 1; i < power; i++) {
		result = result * m;
	}
	return result;
}

double* SparseMatrix::operator[](int line) const {
	double* returnLine;
	try{
		returnLine = new double[nrColumns];
	}
	catch (bad_alloc a) {
		cout << "Allocation Failure\n";
		exit(1);
	}
	for (int i = 0; i < nrColumns; i++) returnLine[i] = 0;
	for (int i = 0; i < nrElements; i++) {
		if (lines[i] == line) {
			returnLine[cols[i]] = elements[i];
		}
	}
	return returnLine;
}

SparseMatrix SparseMatrix::operator=(const SparseMatrix& m) {
	nrLines = m.nrLines;
	nrColumns = m.nrColumns;
	nrElements = m.nrElements;
	delete[]elements;
	delete[]lines;
	delete[]cols;
	try {
		elements = new double[nrElements];
		lines = new int[nrElements];
		cols = new int[nrElements];
	}
	catch (bad_alloc a) {
		cout << "Allocation Failure\n";
		exit(1);
	}
	for (int i = 0; i < nrElements; i++) {
		elements[i] = m.elements[i];
		lines[i] = m.lines[i];
		cols[i] = m.cols[i];
	}
	return *this;
}

bool SparseMatrix::operator==(const SparseMatrix& m) {
	if (nrLines == m.nrLines && nrColumns == m.nrColumns && nrElements == m.nrElements) {
		for (int i = 0; i < nrElements; i++) {
			/*if (elements[i] != m.elements[i] || lines[i] != m.lines[i] || cols[i] != m.cols[i]) {
				return 0;
			}*/
			if (elements[i] != m.elements[i]) return elements[i];
			if (lines[i] != m.lines[i]) return lines[i];
			if (cols[i] != m.cols[i]) return cols[i];
		}
		return 1;
	}
	return 0;
}

ostream& operator<<(ostream& out, const SparseMatrix& m) {
	int i, j, k = 0;
	for (i = 0; i < m.nrLines; i++) {
		for (j = 0; j < m.nrColumns; j++) {
			if (m.lines[k] == i && m.cols[k] == j) {
				out << m.elements[k] << " ";
				k++;
			}
			else {
				out << 0 << " ";
			}
		}
		out << endl;
	}
	return out;
}

istream& operator>>(istream& in, SparseMatrix& m) {
	delete[]m.elements;
	delete[]m.lines;
	delete[]m.cols;
	in >> m.nrLines >> m.nrColumns >> m.nrElements;
	try{
		m.elements = new double[m.nrElements];
		m.lines = new int[m.nrElements];
		m.cols = new int[m.nrElements];
	}
	catch (bad_alloc a) {
		cout << "Allocation Failure\n";
		exit(1);
	}
	for (int i = 0; i < m.nrElements; i++) {
		in >> m.elements[i];
	}
	for (int i = 0; i < m.nrElements; i++) {
		in >> m.lines[i];
	}
	for (int i = 0; i < m.nrElements; i++) {
		in >> m.cols[i];
	}
	return in;

}

#pragma endregion

#pragma region Getters
	
int SparseMatrix::getNumberOfLines() {
	return nrLines;
}

int SparseMatrix::getNumberOfColumns() {
	return nrColumns;
}

#pragma endregion

#pragma region Helper Methods

int SparseMatrix::comparePositions(int i1, int j1, int i2, int j2) {
	//returns 1 if [i1][j1] is before [i2][j2] in the matrix
	//0 if they are overlaping
	//-1 if [i1][j1] is after [i2][j2] in the matrix
	if (i1 < i2) return 1;
	else {
		if (i1 == i2) {
			if (j1 < j2) return 1;
			else {
				if (j1 == j2) return 0;
				else return -1;
			}
		}
		else return -1;
	}
}

int SparseMatrix::nrOverlapsPlus(const SparseMatrix& m1, const SparseMatrix& m2) {
	//this method calculates the number of overlapping elements of the two matrixes
	//and the number of overlapping elements that result in a 0 when added up
	//this function is made to help determine the number of extra elements of the matrix m3=m1+m2; 
	int i = 0, j = 0, cmp, nr = 0, nrOfZeros = 0;
	while (i < m1.nrElements && j < m2.nrElements) {
		cmp = comparePositions(m1.lines[i], m1.cols[i], m2.lines[j], m2.cols[j]);
		if (cmp == 1) i++;
		else {
			if (cmp == -1) j++;
			else {
				if (m1.elements[i] + m2.elements[j] == 0) {//number of overlaps that result in a 0
					nrOfZeros++; 
				}
				else {
					nr++; //number of overlaps that do not result in a 0
				}
				i++;
				j++;
			}
		}
	}
	return nr+2*nrOfZeros; //2*nrOfZeros because the element from each matrix will be ignored
}

int SparseMatrix::nrOverlapsMinus(const SparseMatrix& m1, const SparseMatrix& m2) {
	//this method calculates the number of overlapping elements of the two matrixes
	//and the number of overlapping elements that result in a 0 when substracted
	//this function is made to help determine the number of extra elements of the matrix m3=m1-m2; 
	int i = 0, j = 0, cmp, nr = 0, nrOfZeros = 0;
	while (i < m1.nrElements && j < m2.nrElements) {
		cmp = comparePositions(m1.lines[i], m1.cols[i], m2.lines[j], m2.cols[j]);
		if (cmp == 1) i++;
		else {
			if (cmp == -1) j++;
			else {
				if (m1.elements[i] - m2.elements[j] == 0) {//number of overlaps that result in a 0
					nrOfZeros++;
				}
				else {
					nr++; //number of overlaps that do not result in a 0
				}
				i++;
				j++;
			}
		}
	}
	return nr + 2 * nrOfZeros; //2*nrOfZeros because the element from each matrix will be ignored
}

SparseMatrix SparseMatrix::transpose() const {
	double* new_elements = new double[nrElements];
	int* new_lines = new int[nrElements];
	int* new_cols = new int[nrElements];
	int i, j,k=0;
	for (i = 0; i < nrColumns; i++) {
		for (j = 0; j < nrElements; j++) {
			if (i == cols[j]) {
				new_lines[k] = i;
				new_cols[k] = lines[j];
				new_elements[k] = elements[j];
				k++;
			}
		}
	}
	SparseMatrix t(nrColumns, nrLines, nrElements, new_elements, new_lines, new_cols);
	delete[]new_elements;
	delete[]new_lines;
	delete[]new_cols;
	return t;
}

#pragma endregion