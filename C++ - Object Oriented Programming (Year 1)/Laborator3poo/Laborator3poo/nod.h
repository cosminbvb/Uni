#ifndef NOD_H
#define NOD_H

class Nod {
	int info;
	Nod* next;
public:
	Nod();
	Nod(int, Nod*);
	~Nod();
	void setInfo(int);
	int getInfo();
	void setNext(Nod*);
	Nod* getNext();
};

#endif

