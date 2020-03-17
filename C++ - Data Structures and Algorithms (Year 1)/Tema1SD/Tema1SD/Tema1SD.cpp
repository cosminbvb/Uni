#include <iostream>
using namespace std;

#pragma region 1-Stack
//rulat pe testul de pe site
struct stack {
	int info;
	stack* next;
}*top;
//->next duce in jos pe stiva
void push_stack(stack*& s, int x) {
	stack* a = new stack;
	//alocare spatiu
	a->info = x;
	a->next = s;
	s = a;
}

int pop_stack(stack*& s) {
	stack* bob = s;
	int a = -1;
	if (s != NULL) {
		s = s->next;
		a = bob->info;
		delete bob;
	}
	return a;
}

void print_stack(stack* s) {
	while (s != NULL) {
		cout << s->info << " ";
		s = s->next;
	}
}
#pragma endregion 

#pragma region 2-Dequeue

struct deq {
	int info;
	deq* prev, * next;
}*LEFT, *RIGHT;
//rulat cu testul de pe site
void push_left(int x) {
	if (LEFT == NULL && RIGHT == NULL) //niciun element
	{
		deq* a = new deq;
		a->prev = NULL;
		a->next = NULL;
		a->info = x;
		LEFT = RIGHT = a;
	}
	else if (LEFT == RIGHT) { //un element
		deq* a = new deq;
		a->prev = NULL;
		a->next = LEFT;
		a->info = x;
		LEFT->prev = a;
		RIGHT->prev = a;
		LEFT = a;
	}
	else { //mai multe
		deq* a = new deq;
		a->prev = NULL;
		a->next = LEFT;
		a->info = x;
		LEFT->prev = a;
		LEFT = a;
	}
}

int pop_left() {
	if (LEFT == NULL && RIGHT == NULL) return -999999;
	else if (LEFT == RIGHT) {
		deq* p = LEFT;
		int a = p->info;
		delete LEFT;
		LEFT = RIGHT = NULL;
		return a;
	}
	else {
		deq* p = LEFT;
		int a = p->info;
		p = p->next;
		p->prev = NULL;
		delete LEFT;
		LEFT = p;
		return a;
	}
}
void push_right(int x) {
	if (LEFT == NULL && RIGHT == NULL)
	{
		deq* a = new deq;
		a->prev = NULL;
		a->next = NULL;
		a->info = x;
		LEFT = RIGHT = a;
	}
	else if (LEFT == RIGHT) {
		deq* a = new deq;
		a->next = NULL;
		a->prev = RIGHT;
		a->info = x;
		RIGHT = a;
	}
	else {
		deq* a = new deq;
		a->prev = RIGHT;
		a->next = NULL;
		a->info = x;
		RIGHT->next = a;
		RIGHT = a;
	}
}

int pop_right() {
	if (LEFT == NULL && RIGHT == NULL) return -999999;
	else if (LEFT == RIGHT) {
		deq* p = LEFT;
		int a = p->info;
		delete LEFT;
		LEFT = RIGHT = NULL;
		return a;
	}
	else {
		deq* p = RIGHT;
		int a = p->info;
		p = p->prev;
		p->next = NULL;
		delete RIGHT;
		RIGHT = p;
		return a;
	}
}

void print_deq() {
	deq* p = LEFT;
	while (p != NULL) {
		cout << p->info << " ";
		p = p->next;
	}
}

#pragma endregion

#pragma region 3-Tarusi

void tarusi(int n,int v[]) {
	stack* s = NULL;
	int i = 0;
	while (i < n) {
		if (s) //daca stiva nu e goala
		{
			if (s->info == v[i]) {
				pop_stack(s);
			}
			else {
				push_stack(s, v[i]);
			}
		}
		else {
			push_stack(s, v[i]);
		}
		i++;		
	}
	if (s) {
		cout << "Configuratie invalida"<<endl;
	}
	else {
		cout << "Configuratie valida"<<endl;
	}

}
#pragma endregion

#pragma region 4-Imagine
/*
test with:
0 0 1 0 0 0 0
0 0 1 1 0 0 0
0 0 0 0 1 0 0
0 0 0 1 1 0 0
0 1 0 0 1 0 1
1 1 1 0 0 0 1
1 1 1 0 0 1 1 
*/

int a[10][10];
void imagine(int m,int M[][10]) {
	int i, j, culoare=2 ,new_i, new_j;
	deq* q = NULL;
	for (i = 0; i < m; i++) {
		for (j = 0; j < m; j++) {
			if (M[i][j] != 0) { //primul 1 din M
				push_left(i);
				push_left(j);
;				while (LEFT!=NULL && RIGHT!=NULL) { //cat timp q nu e empty
					new_i = pop_right();
					new_j = pop_right();
					M[new_i][new_j] = 0;
					a[new_i][new_j] = culoare;
					if (M[new_i-1][new_j] != 0 && a[new_i-1][new_j] == 0 && new_i-1 >= 0) //SUS
					{
						push_left(new_i-1);
						push_left(new_j);
					}
					if (M[new_i][new_j - 1] != 0 && a[new_i][new_j - 1] == 0 && new_j - 1 >= 0) //ST
					{
						push_left(new_i);
						push_left(new_j - 1);
					}
					if (M[new_i][new_j + 1] != 0 && a[new_i][new_j + 1] == 0 && new_j + 1 < m) //DR
					{
						push_left(new_i);
						push_left(new_j + 1);
					}
					if (M[new_i + 1][new_j] != 0 && a[new_i + 1][new_j] == 0 && new_i + 1 < m) //JOS
					{
						push_left(new_i + 1);
						push_left(new_j);
					}
				}
				culoare++;
			}
		}
	}
	for (i = 0; i < m; i++) {
		for (j = 0; j < m; j++) {
			cout << a[i][j] << " ";
		}
		cout << endl;
	}
}

#pragma endregion

#pragma region 5-Majority Voting Algorithm
//(Boyer-Moore's)
int v[100], n, c;
int candidat(int n, int v[]) {
	int nr = 1, indexMajoritar = 0, i;
	for (i = 1; i < n; i++) {
		if (v[indexMajoritar] == v[i])
			nr++;
		else
			nr--;
		if (nr == 0) {
			indexMajoritar = i;
			nr = 1;
		}
	}
	return v[indexMajoritar];
}
int Maj(int n, int v[]) {
	int nr = 0, i;
	c = candidat(n, v);
	for (i = 0; i < n; i++) {
		if (v[i] == c)
			nr++;
	}
	if (nr > n / 2) return 1;
	return 0;
}

#pragma endregion

int main()
{
	//test ex1
	stack* s = NULL;
	push_stack(s, 1);
	pop_stack(s);
	push_stack(s, 2);
	push_stack(s, 3);
	cout << "Stack test:" << endl;
	print_stack(s);
	cout << endl;

	//test ex2
	deq* test = NULL;
	push_left(1);
	push_right(2);
	pop_right();
	pop_left();
	push_right(3);
	cout << "Dequeue test:" << endl;
	print_deq();
	cout << endl;
	pop_right();

	//test ex3
	//test with n=8 v=1 2 2 1 3 3 4 4
	cout << "Test ex3:" << endl;
	cout << "Enter n " << endl;;
	int n, v[100];
	cin >> n;
	cout << "Enter v "<<endl;
	for (int i = 0; i < n; i++) {
		cin >> v[i];
	}
	tarusi(n, v);

	//test ex4
	int m,M[10][10],i,j;
	cout << "Enter length"<<endl;
	cin >> m;
	cout << "Enter matrix"<<endl;
	for (i = 0; i < m; i++) {
		for (j = 0; j < m; j++) {
			cin >> M[i][j];
		}
	}
	cout << endl;
	imagine(m, M);

	//test ex5
	cin >> n;
	for (i = 0; i < n; i++) {
		cin >> v[i];
	}
	if (Maj(n, v)) {
		cout <<"elementul majoritar este: "<<c;
	}
	else {
		cout << "nu exista";
	}

	return 0;
}
