#include <iostream>
using namespace std;

void swap(int& a, int& b) {
	int aux;
	aux = a;
	a = b;
	b = aux;
}

void keepProperty(int* elements, int size, int i) {
	int l = 2 * i + 1;
	int r = 2 * i + 2;
	int smallest;
	if (elements[l] < elements[i] && l < size) smallest = l;
	else smallest = i;
	if (elements[r] < elements[smallest] && r < size) smallest = r;
	if (smallest != i) {
		swap(elements[i], elements[smallest]);
		keepProperty(elements, size, smallest);
	}
}

void heapify(int* elements, int size) {
	for (int i = (size - 1) / 2; i >= 0; i--) {
		keepProperty(elements, size, i);
	}
} // which runs in linear time, produces a min heap from an unordered input array

int extractMin(int* elements, int& size) {
	if (size < 1) {
		cout << "heap underflow";
		exit(1);
	}
	int min = elements[0];
	elements[0] = elements[size - 1];
	size--;
	keepProperty(elements, size, 0);
	return min;
}

void insertValue(int* elements, int& size, int value) {
	int i = size;
	elements[size] = value;
	size++;
	while (i > 0 && elements[(i - 1) / 2] > elements[i]) {
		swap(elements[i], elements[(i - 1) / 2]);
		i = (i - 1) / 2;
	}
}

void print(int* elements, int size) {
	for (int i = 0; i < size; i++) cout << elements[i] << " ";
	cout << endl;
}

void heapSort(int* elements, int size) {
	heapify(elements, size);
	int length = size;
	for (int i = length - 1; i >= 0; i--) {
		swap(elements[0], elements[i]);
		length--;
		keepProperty(elements, length, 0);
	}
	for (int i = 0; i < size / 2; i++)
		swap(elements[i], elements[size - i - 1]);
}

int main()
{
	/*
	10
	4 1 3 2 16 9 10 14 8 7
	*/
	int a[1000], n;
	cin >> n;
	for (int i = 0; i < n; i++) cin >> a[i];
	heapify(a, n);
	print(a, n);
	extractMin(a, n);
	print(a, n);
	insertValue(a, n, 6);
	print(a, n);
	heapSort(a, n);
	print(a, n);

	return 0;
}

