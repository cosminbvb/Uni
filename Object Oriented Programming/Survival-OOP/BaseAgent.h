#pragma once

#include <string>
#include "Map.h"
using namespace std;

class Map;

class BaseAgent
{
	//derivde classes: AgentTom, AgentJerry, AgentSpike. 
protected:
	int hp;
	pair<int, int>position;
	char description; 
	int range;
public:
	BaseAgent() : hp(100),range(0),description(' '){};
	BaseAgent(int hp,int range, char description) : hp(hp),range(range),description(description){};
	virtual ~BaseAgent() {};
	void setHp(int);
	int getHp();
	void setPosition(pair<int, int>);
	pair<int, int> getPosition();
	char getDescription();
	virtual pair<int,int> move(Map&) = 0; //return his next posititon
	static BaseAgent* oneVone(BaseAgent*, BaseAgent*);
};

