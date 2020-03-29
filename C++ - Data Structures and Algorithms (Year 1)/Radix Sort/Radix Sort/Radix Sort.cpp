// Radix Sort.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>

/*
Given n d-digit numbers in which each digit can take on up to k possible values,
radix-sort correctly sors these numbers in θ(d(n+k)) time is the stable sort it 
uses takes θ(n+k) time.
*/

int getMax(int* a, int size) {
	int max = a[0];
	for (int i = 1; i < size; i++) {
		if (a[i] > max) max = a[i];
	}
	return max;
}

void countSort(int* a, int size, int exp) {
	int* b = new int[size]; //auxiliary array
	int* c = new int[10]; //frequency array
	int i;
	for (i = 0; i <= 9; i++) 
		c[i] = 0;
	for (i = 0; i < size; i++)
		c[(a[i] / exp) % 10]++;
	for (i = 1; i <= 9; i++)
		c[i] += c[i - 1];
	for (i = size - 1; i >= 0; i--) {
		b[c[(a[i] / exp) % 10] - 1] = a[i];
		c[(a[i] / exp) % 10]--;
	}
	for (i = 0; i < size; i++)
		a[i] = b[i];
	delete[]b;
	delete[]c;
}

void RadixSort(int* a, int size) {
	int max = getMax(a, size);
	//finds the biggest number to know the number of digits
	for (int exp = 1; max / exp > 0; exp *= 10) {
		countSort(a, size, exp);
	}
}

int main()
{
	int n;
	std::cin >> n;
	int* a = new int[n];
	for (int i = 0; i < n; i++)
		std::cin >> a[i];
	RadixSort(a, n);
	for (int i = 0; i < n; i++)
		std::cout << a[i] << " ";
	delete[]a;
}
