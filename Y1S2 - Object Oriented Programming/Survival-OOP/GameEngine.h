#pragma once
#include "Map.h"
#include "BaseAgent.h"
#include "AgentTom.h"
#include "AgentJerry.h"
#include "AgentSpike.h"
#include<iostream>
using namespace std;

class GameEngine
{
	Map *harta;
	int agents;
public:
	GameEngine();
	~GameEngine();
	void runRounds();
	void moveEveryone();
	void spawnAgents();
	void play();
};

