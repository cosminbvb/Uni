#pragma once
#include "BaseAgent.h"
#include "Map.h"

class AgentJerry : public BaseAgent
{
	//will run away from Tom
	//will win a 1v1 vs Tom if Jerry has more hp
	//will win a 1v1 vs Spike regardless
	//has a movement range of 1 block
public:
	AgentJerry() : BaseAgent(50, 1, 'J') {};
	pair<int,int> move(Map&);
};

