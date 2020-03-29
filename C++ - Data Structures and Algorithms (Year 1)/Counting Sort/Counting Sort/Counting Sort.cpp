// Counting Sort.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
using namespace std;

/*
An important property of counting sort is that it is stable: numbers with the same value appear in the output array
in the same order as they do in the input array. That is, it breaks ties between two numbers by the rule that whichever
number appears ﬁrst in the input array appears ﬁrst in the output array. Normally, the property of stability is important
only when satellite data are carried around with the element being sorted. Counting sort’s stability is important for another
reason: counting sort is often used as a subroutine in radixort.
*/
void CountingSort(int* a, int size) {
	int i;
	int min = a[0], max = a[0];
	for (i = 1; i < size; i++) {
		if (a[i] < min)min = a[i];
		if (a[i] > max)max = a[i];
	}
	int k = max - min;
	int* b = new int[size]; //auxiliary array
	int* c = new int[k+1]; //frequency array
	for (i = 0; i <= k; i++) 
		c[i] = 0;
	for (i = 0; i < size; i++)
		c[a[i]-min]++;
	for (i = 1; i <= k; i++)
		c[i] = c[i] + c[i - 1];
	for (i = size - 1; i >= 0; i--) {
		b[c[a[i]-min]-1] = a[i];
		c[a[i]-min]--;
	}
	for (i = 0; i < size; i++) //overwrite
		a[i] = b[i];
	delete[]b;
	delete[]c;
}

int main()
{
	int n;
	cin >> n;
	int* a = new int[n];
	for (int i = 0; i < n; i++) cin >> a[i];
	CountingSort(a, n);
	for (int i = 0; i < n; i++) cout << a[i] << " ";
	delete[]a;

	return 0;
}

