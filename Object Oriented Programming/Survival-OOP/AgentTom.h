#pragma once
#include "BaseAgent.h"
#include "Map.h"

class AgentTom : public BaseAgent
{
	//will look for the closest Jerry and will move towards him
	//runs away from Spike but is more focused on Jerry 
	//has a movement range of 2 blocks

	//always looses against Spike
	//will win a 1v1 vs Jerry if he has more hp
public:
	AgentTom() : BaseAgent(100, 2, 'T') {};
	pair<int,int> move(Map&);
};


