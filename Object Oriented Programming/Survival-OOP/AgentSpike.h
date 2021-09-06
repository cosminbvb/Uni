#pragma once
#include "BaseAgent.h"
class AgentSpike : public BaseAgent
{
	//always wins agains Tom
	//always looses agains Jerry
public:
	AgentSpike() : BaseAgent(150, 3, 'S') {};
	pair<int, int> move(Map&);
};

