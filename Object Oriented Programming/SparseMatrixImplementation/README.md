# Sparse-Matrix Class
 Sparse Matrix Class Implementation C++
 (This is made as a Uni assignment)
 
 ## Class Description:
 
**Member variables:** 
- Number of lines (int)
- Number of columns (int)
- Number of nonzero elements (int)
- Dynamically allocated array for the nonzero elements (double*)
- Dynamically allocated array for the line index (int*)
- Dynamically allocated array for the column index (int*)

**Public member methods:**
- `SparseMatrix();`
- `SparseMatrix(int, int, double*, int*, int*);` (constructor for M(n*n))
- `SparseMatrix(int, int, int, double*,int*,int*);` (constructor for M(n*m))
- `SparseMatrix(const SparseMatrix&);` (copy constructor)
- `~SparseMatrix();` (destructor)
- `double* operator[](int) const;` ( [] overload ( m[i] returns the full i line, inluding zeros))
- `SparseMatrix operator=(const SparseMatrix&);` ( = overload )
- `bool operator==(const SparseMatrix&);` ( == overload )
- `int getNumberOfLines();` 
- `int getNumberOfColumns();` 
		
**Friend functions:**
- `friend SparseMatrix operator+(const SparseMatrix&, const SparseMatrix&);`
	(+ overload => SparseMatrix + SparseMatrix)
- `friend SparseMatrix operator-(const SparseMatrix&, const SparseMatrix&);`
	(- overload => SparseMatrix - SparseMatrix)
- `friend SparseMatrix operator*(const SparseMatrix&, const SparseMatrix&);`
	(* overload => SparseMatrix * SparseMatrix)
- `friend SparseMatrix operator*(const SparseMatrix&, double);`
	(* overload => SparseMatrix * double)
- `friend SparseMatrix operator^(const SparseMatrix&, int);`
	(^ overload => SparseMatrix^power)
- `friend istream& operator>>(istream&, SparseMatrix&); `
	(>> overload)
- `friend ostream& operator<<(ostream&, const SparseMatrix&); `
	(>>overload)
		
**Protected member methods (Helper Methods):**
- `static int comparePositions(int i1, int j1, int i2, int j2);`  (returns 1 if the position (i1,j1) is before (i2,j2) in the matrix, 0 if they overlap, -1 if (i1,j1) is after (i2,j2) )
- `static int nrOverlapsPlus(const SparseMatrix&, const SparseMatrix&);` (this function is made to help determine the number of extra elements of the matrix m3=m1+m2 ; used in + overload)                                                                               
- `static int nrOverlapsMinus(const SparseMatrix&, const SparseMatrix&);` (same as above but for m3=m1-m2; used in - overload)
- `SparseMatrix transpose() const;` (returns transposed matrix; used in * overload)
	
