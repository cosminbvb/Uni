// Radix Sort Bitwise.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
using namespace std;

void countSortBitwise(int* a, int size, int shamount) {
	int c[256]; // 255=11111111=2^0+2^1+..+2^8
	int i;
	for (i = 0; i < 256; i++) c[i] = 0;
	for (i = 0; i < size; i++) {
		c[a[i] >> shamount & 255]++;
	}
	for (i = 1; i < 256; i++) c[i] += c[i - 1];
	int* b = new int[size];
	for (i = size - 1; i >= 0; i--) {
		b[c[a[i] >> shamount & 255]-1] = a[i];
		c[a[i] >> shamount & 255]--;
	}
	for (i = 0; i < size; i++) a[i] = b[i];
	delete[]b;
}

void radixSortBitwise(int* a, int size) {
	for (int i = 0; i < sizeof(int); i++) {
		countSortBitwise(a, size, i*8);
	}
}

int main()
{
	int size = 8;
	cin >> size;
	int* a = new int[size];
	for (int i = 0; i < size; i++)
		cin >> a[i];
	radixSortBitwise(a, size);
	for (int i = 0; i < size; i++)
		cout << a[i] << " ";

	return 0;
}

