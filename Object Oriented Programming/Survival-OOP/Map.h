#pragma once

#include <iostream>
#include <vector>
#include "BaseAgent.h"
using namespace std;

class BaseAgent;

class Map
{
	int rows, cols;
	vector<vector<BaseAgent*>> matrix;
public:
	Map(int, int);
	~Map();
	int getNrRows() { return this->rows; }
	int getNrCols() { return this->cols; }
	BaseAgent* getItem(int, int);
	void setItem(int, int, BaseAgent*);
	vector<vector<BaseAgent*>> getProximity(pair<int, int>, int);
	pair<int, int> getProximityNewCentre(pair<int, int>, int);
	friend ostream& operator<<(ostream& out, const Map&);

};

