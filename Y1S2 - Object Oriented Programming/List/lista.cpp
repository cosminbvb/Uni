#include "lista.h"
#include "nod.h"
#include <iostream>
using namespace std;
Lista::Lista(int x) {
	size = 1;
	start = new Nod(x, NULL);
	end = start;
}
Lista::Lista(int x, int y) {
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
void Lista::insert(int x) { //inserare la sfarsit
	size++;
	Nod *p = new Nod(x, NULL);
	end->setNext(p);
	end = p;
}
void Lista::insertAt(int x, int i) {// inserare pe pozitia i; daca i>size se insereaza la sfarsit
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
int Lista::get(int i) { //intoarce elementul de pe pozitia i daca i este valid, MAX_INT altfel
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
int Lista::length() {
	return size;
}
void Lista::remove(int i) {
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
Lista::~Lista() {
	cout << "Lista distrusa" << endl;
}
void Lista::reverse() { //in cerinta era ceruta metoda de forma Lista reverse() dar nu e mai simplu asa?
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
void Lista::removeFirst() {
	Nod *p = start;
	start = start->getNext();
	p->~Nod(); //optional 
	size--;
}
void Lista::removeLast() {
	Nod *p = start;
	for (int i = 1; i < size - 2; i++) {
		p = p->getNext();
	}
	end = p;
	size--;
	p = p->getNext();
	p->~Nod();
}
bool Lista::hasDuplicates() {
	Nod *p = start;
	for (int i = 0; i < size - 1; i++) {
		for (int j = i + 1; j < size; j++) {
			if (get(i) == get(j)) {
				return true;
			}
		}
	}
	return false;
}
bool Lista::has(int x) {
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
bool Lista::isEmpty() {
	if (size == 0) {
		return true;
	}
	return false;
}
