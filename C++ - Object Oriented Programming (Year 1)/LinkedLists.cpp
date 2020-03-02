#include "pch.h"
#include <iostream>
using namespace std;
class Nod {
	int info;
	Nod* next;
public:
	Nod() {
		info = 0;
		next = NULL;
	}
	Nod(int info, Nod* next) {
		this->info = info;
		this->next = next;
	}
	~Nod() { //nu este nevoie de destructor
		cout << "Nod distrus" << endl;
	}
	void setInfo(int info) {
		this->info = info;
	}
	int getInfo() {
		return info;
	}
	void setNext(Nod* next) {
		this->next = next;
	}
	Nod* getNext() {
		return next;
	}
};

class Lista {
	Nod *start, *end;//start=pointer catre primul element din lista, end=pointer catre ultimul element din lista
	unsigned int size; //nr elementelor din lista
public:
	Lista(int x) {
		size = 1;
		start = new Nod(x, NULL);
		end = start;
	}
	Lista(int x, int y) {
		size = x;
		start = new Nod(y, NULL);
		end = start;
		Nod *p;
		for (int i = 0; i < x - 1; i++) {
			p = new Nod(y, NULL);
			end->setNext(p);
			end = p;
		}
	}
	void insert(int x) { //inserare la sfarsit
		size++;
		Nod *p = new Nod(x, NULL);
		end->setNext(p);
		end = p;
	}
	void insertAt(int x, int i) {// inserare pe pozitia i; daca i>size se insereaza la sfarsit
		if (i >= size) {
			insert(x);
			return;
		}
		else if (i == 0) { //inserare la inceput
			size++;
			Nod *p = new Nod(x, NULL);
			p->setNext(start);
			start = p;
		}
		else
		{
			size++;
			Nod *p = new Nod(x, NULL);
			Nod *q = start;
			for (int j = 1; j < i; j++) {
				q = q->getNext();
			}
			p->setNext(q->getNext());
			q->setNext(p);
		}
	}
	int get(int i) { //intoarce elementul de pe pozitia i daca i este valid, MAX_INT altfel
		if (i < size) {
			Nod *p = start;
			for (int j = 1; j <= i; j++) {
				p = p->getNext();
			}
			return p->getInfo();
		}
		else {
			return INT_MAX;
		}
	}
	int length() {
		return size;
	}
	void remove(int i) {
		if (i == 0) {
			size--;
			start = start->getNext();
		}
		else {
			size--;
			Nod *p = start;
			for (int j = 1; j < i; j++) {
				p = p->getNext();
			}
			p->setNext(p->getNext()->getNext());
		}
	}
	~Lista() {
		cout << "Lista distrusa"<<endl;
	}
	void reverse() { //in cerinta era ceruta metoda de forma Lista reverse() dar nu e mai simplu asa?
		Nod *p, *c, *n; //previous, current, next
		//pentru primul element
		p = NULL; 
		c = start;
		end = start;
		while (c != NULL) {
			n = c->getNext();
			c->setNext(p);
			p = c;
			c = n;
		}
		start = p; 
	}
	void removeFirst() {
		Nod *p = start;
		start = start->getNext();
		p->~Nod(); //optional 
		size--;
	}
	void removeLast() {
		Nod *p = start;
		for (int i = 1; i < size-2; i++) {
			p = p->getNext();
		}
		end = p;
		size--;
		p = p->getNext();
		p->~Nod();
	}
	bool hasDuplicates() {
		Nod *p = start;
		for (int i = 0; i < size - 1; i++) {
			for (int j = i+1; j < size; j++) {
				if (get(i) == get(j)) {
					return true;
				}
			}
		}
		return false;
	}
	bool has(int x) {
		Nod *p = start;
		if (p->getInfo() == x) {
			return true;
		}
		for (int i = 1; i <= size - 1; i++) {
			p = p->getNext();
			if (p->getInfo() == x) {
				return true;
			}
		}
		return false;
	}
	bool isEmpty() {
		if (size == 0) {
			return true;
		}
		return false;
	}
};

void f(Lista *l, int x) { //afiseaza lista l si insereaza la sfarsitul ei valoarea x
	for (int i = 0; i < l->length(); i++) {
		cout << l->get(i)<<" ";
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
	cout << l3.hasDuplicates() << " (are duplicate)"<<endl;
	l3.removeLast();
	cout << l3.hasDuplicates() << " (nu are duplicate)" << endl;
	cout << l3.has(5) << " (il contine pe 5)" << endl;
	cout << l3.has(8) << " (nu il contine pe 8)" << endl;
	cout << l3.isEmpty() << " (nu e empty)" << endl;
	Lista l4(5);
	l4.removeFirst();
	cout << l4.isEmpty() << " (e empty)" << endl;
	return 0;
}

