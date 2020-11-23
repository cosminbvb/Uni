#include "nod.h"
#include<iostream>

using namespace std;

Nod::Nod() {
	info = 0;
	next = NULL;
}
Nod::Nod(int info, Nod* next) {
	this->info = info;
	this->next = next;
}
Nod::~Nod() { //nu este nevoie de destructor
	cout << "Nod distrus" << endl;
}
void Nod::setInfo(int info) {
	this->info = info;
}
int Nod::getInfo() {
	return info;
}
void Nod::setNext(Nod* next) {
	this->next = next;
}
Nod* Nod::getNext() {
	return next;
}
