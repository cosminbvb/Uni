#include "AgentSpike.h"
#include <vector>
#include <cmath>
#include <algorithm>
using namespace std;

pair<int, int> AgentSpike::move(Map& map) {
	vector<vector<BaseAgent*>> fov = map.getProximity(this->position, this->range);
	pair<int, int>spikeFovPosition = map.getProximityNewCentre(this->position, this->range); //his coordinates in fov
	int distJerry = range + 1;
	int distTom = range + 1;
	int distAux = 0;
	int d1;
	pair<int, int> Jerry(-1, -1); //closest Jerry
	pair<int, int> Tom(-1, -1); //closest Tom
	pair<int, int> newPosition; //in fov, not in the big map
	for (unsigned i = 0; i < fov.size(); i++) {
		for (unsigned j = 0; j < fov[i].size(); j++) {
			if (fov[i][j] != NULL) {
				if (fov[i][j]->getDescription() == 'T') {
					d1 = max(abs(spikeFovPosition.first - (int)i), abs(spikeFovPosition.second - (int)j));
					if (d1 < distTom) {
						distTom = d1;
						Tom.first = i;
						Tom.second = j;
					}
				}
			}
		}
	}
	pair<int, int> returnPosition;
	if (Tom.first != -1) {
		newPosition = Tom;
		returnPosition.first = this->position.first - (spikeFovPosition.first - newPosition.first);
		returnPosition.second = this->position.second - (spikeFovPosition.second - newPosition.second);
	}
	else {
		returnPosition.first = this->position.first - (spikeFovPosition.first - newPosition.first);
		returnPosition.second = this->position.second - (spikeFovPosition.second - newPosition.second);
	}
	
	cout << "Spike moved from " << this->position.first << ", " << this->position.second << " to " << returnPosition.first << ", " << returnPosition.second << endl;

	return returnPosition;
}