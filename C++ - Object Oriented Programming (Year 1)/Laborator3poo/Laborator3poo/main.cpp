#include "lista.h"
#include "nod.h"
#include <iostream>
using namespace std;


void f(Lista *l, int x) { //afiseaza lista l si insereaza la sfarsitul ei valoarea x
	for (int i = 0; i < l->length(); i++) {
		cout << l->get(i) << " ";
	}
	l->insert(x);
}

int main()
{
	Lista l(3);
	l.insert(5);
	l.insert(7);
	f(&l, 9);
	cout << endl;
	f(&l, 10);
	cout << endl;
	f(&l, 10);
	//(observatie ex7) se afiseaza de fiecare data 3 5 7
	l.reverse();
	cout << endl;
	f(&l, 99);
	cout << endl;
	cout << "-----";
	cout << endl;
	Lista l2(5);
	l2.insert(9);
	l2.insert(3);
	l2.removeFirst();
	f(&l2, 99);
	cout << endl;
	l2.removeLast();
	f(&l2, 99);
	cout << endl;
	Lista l3(5);
	l3.insert(9);
	l3.insert(3);
	l3.insert(9);
	cout << l3.hasDuplicates() << " (are duplicate)" << endl;
	l3.removeLast();
	cout << l3.hasDuplicates() << " (nu are duplicate)" << endl;
	cout << l3.has(5) << " (il contine pe 5)" << endl;
	cout << l3.has(8) << " (nu il contine pe 8)" << endl;
	cout << l3.isEmpty() << " (nu e empty)" << endl;
	Lista l4(5);
	l4.removeFirst();
	cout << l4.isEmpty() << " (e empty)" << endl;
	int x;
	cin >> x;
	return 0;
}

