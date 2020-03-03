#ifndef LISTA_H
#define LISTA_H
#include "nod.h"

class Lista {
	Nod *start, *end;//start=pointer catre primul element din lista, end=pointer catre ultimul element din lista
	unsigned int size; //nr elementelor din lista
public:
	Lista(int);
	Lista(int, int);
	void insert(int);
	void insertAt(int, int);
	int get(int);
	int length();
	void remove(int);
	~Lista();
	void reverse();
	void removeFirst();
	void removeLast();
	bool hasDuplicates();
	bool has(int x);
	bool isEmpty();
};

#endif


