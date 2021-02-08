#include "GameEngine.h"
#include <ctime>
#include <map>

GameEngine::GameEngine() {
	cout << "Welcome to TOM & JERRY Survival Simulation" << endl;
	cout << endl;
	cout << "Let's see who wins the kitchen battle..." << endl;
	cout << endl;
	cout << "Enter map dimensions (minimum 15x15): ";
	int row, col;
	cin >> row >> col;
	if (row < 15 || col < 15) exit(1);
	harta = new Map(row, col);
	cout << "Enter the number of agents: ";
	int nrAgents;
	cin >> nrAgents;
	this->agents = nrAgents;
	if (nrAgents > row * col) {
		cout << "Too many agents";
		exit(1);
	}
}

GameEngine::~GameEngine() {
	delete harta;
}

void GameEngine::moveEveryone(){
	int newNrOfAgents = 0;
	map<pair<int, int>, vector<BaseAgent*>>dict;
	for (int i = 0; i < harta->getNrRows(); i++) {
		for (int j = 0; j < harta->getNrCols(); j++) {
			BaseAgent* current = harta->getItem(i, j);
			if (current != NULL) {
				pair<int, int>nextMove = current->move(*harta);
				current->setPosition(nextMove);
				harta->setItem(i, j, NULL);//remove the agent from current position
				dict[nextMove].push_back(current);
			}
		}
	}

	map<pair<int, int>, vector<BaseAgent*>>::iterator it = dict.begin();
	while (it != dict.end()) {
		BaseAgent* winner = it->second[0];
		for (unsigned i = 1; i < it->second.size(); i++) {
			winner = BaseAgent::oneVone(winner, it->second[i]);
		}
		harta->setItem(it->first.first, it->first.second, winner);
		newNrOfAgents++;
		it++;
	}
	agents = newNrOfAgents;
	dict.clear();
}

void GameEngine::spawnAgents() {
	//randomly placing agents
	srand(time(NULL));
	int i = 0;
	vector<pair<int, int>>takenPositions;
	while (i < agents) {
		pair<int, int>position;
		bool taken = true;
		while (taken == true) {
			position.first = rand() % harta->getNrRows();
			position.second = rand() % harta->getNrCols();
			bool found = false;
			for (auto p : takenPositions) {
				if (p == position) {
					found = true;
					break;
				}
			}
			if (found == false) {
				//the position is not taken
				taken = false;
				takenPositions.push_back(position);
			}
		}
		BaseAgent* toAdd = NULL;
		if (i % 3 == 0) {
			//generate AgentTom
			toAdd = new AgentTom;
		}
		if (i % 3 == 1) {
			//generate AgentJerry
			toAdd = new AgentJerry;
		}
		if (i % 3 == 2) {
			//generate AgentSpike
			toAdd = new AgentSpike;
		}
		harta->setItem(position.first, position.second, toAdd);
		toAdd->setPosition(position);
		i++;
	}
	cout << *harta << endl;
}

void GameEngine::runRounds() {
	bool response = true;
	char cont;
	while (response) {
		moveEveryone();
		cout << *harta << endl;
		if (agents == 1) {
			for (unsigned i = 0; i < harta->getNrRows(); i++) {
				for (unsigned j = 0; j < harta->getNrCols(); j++) {
					BaseAgent* survivor = harta->getItem(i, j);
					if (survivor) {
						cout << "Simulation over: " << endl;
						if (survivor->getDescription() == 'J') {
							cout << "Jerry is the last survivor, with a total hp of " << survivor->getHp();
						}
						else if (survivor->getDescription() == 'T') {
							cout << "Tom is the last survivor, with a total hp of " << survivor->getHp();
						}
						else {
							cout << "Spike is the last survivor, with a total hp of " << survivor->getHp();
						}
						cout << endl << endl;
						exit(1);
					}
				}
			}
		}
		cout << "Do you want to continue the simulation? [Y/N]" << endl;
		cin >> cont;
		if (cont == 'N'){
			response = false;
		}
		if (cont != 'Y' && cont != 'N') {
			cout << "Invalid command" << endl;
			cin >> cont;
			while (cont != 'Y' && cont != 'N') {
				cout << "Invalid command" << endl;
				cin >> cont;
			}
		}
	}
}

void GameEngine::play() {
	spawnAgents();
	runRounds();
}