#include "AgentTom.h"
#include <vector>
#include <cmath>
#include <algorithm>
using namespace std;

pair<int,int> AgentTom::move(Map& map) {
	vector<vector<BaseAgent*>> fov = map.getProximity(this->position, this->range);
	pair<int, int>tomFovPosition = map.getProximityNewCentre(this->position, this->range); //his coordinates in fov
	int distJerry = range + 1;
	int distSpike = range + 1;
	int distAux = 0;
	int d1, d2;
	pair<int, int> Jerry(-1, -1); //closest Jerry
	pair<int, int> Spike(-1, -1); //closest Spike
	pair<int, int> newPosition;//in fov, not in the big map


	for (unsigned i = 0; i < fov.size(); i++) {
		for (unsigned j = 0; j < fov[i].size(); j++) {
			if (fov[i][j] != NULL){
				if (fov[i][j]->getDescription() == 'J') {
					d1 = max(abs(tomFovPosition.first-(int)i),abs(tomFovPosition.second-(int)j));
					if (d1 < distJerry) {
						distJerry = d1;
						Jerry.first = i;
						Jerry.second = j;
					}
				}
			}
			else if (fov[i][j] != NULL){
				if (fov[i][j]->getDescription() == 'S') {
					d2 = max(abs(tomFovPosition.first - (int)i), abs(tomFovPosition.second - (int)j));
					if (d2 < distSpike) {
						distSpike = d2;
						Spike.first = i;
						Spike.second = j;
					}
				}
			}
		}
	}
	//now Tom knows where the closest Spike and the closest Jerry are

	if (Jerry.first != -1 && Spike.first == -1) {
		//meaning that Tom only sees Jerry and will move towards him
		newPosition = Jerry;
	}

	if (Jerry.first != -1 && Spike.first != -1) {
		//if he can see both
		if (tomFovPosition.first == Jerry.first && Jerry.first == Spike.first) {
			//if they all are on the same line
			if (Spike.second<Jerry.second && Spike.second>tomFovPosition.second) {
				//meaning that Tom will meet Spike if he runs towards Jerry
				//he needs to run away
				for (unsigned i = 0; i < fov.size(); i++) {
					for (unsigned j = 0; j < fov[i].size(); j++) {
						d1 = max(abs(tomFovPosition.first - (int)i), abs(tomFovPosition.second - (int)j));
						if (d1 > distAux && fov[i][j]==NULL) {
							newPosition.first = i;
							newPosition.first = j;
						}
					}
				}
			}
		}
		else if (tomFovPosition.second == Jerry.first && Jerry.second == Spike.second) {
			//if they all are on the same column
			if (Spike.first<Jerry.first && Spike.first>tomFovPosition.first) {
				//meaning that Tom will meet Spike if he runs towards Jerry
				//he needs to run away around
				for (unsigned i = 0; i < fov.size(); i++) {
					for (unsigned j = 0; j < fov[i].size(); j++) {
						d1 = max(abs(tomFovPosition.first - (int)i), abs(tomFovPosition.second - (int)j));
						if (d1 > distAux && fov[i][j] == NULL) {
							newPosition.first = i;
							newPosition.first = j;
						}
					}
				}
			}
		}
		else if (abs(Jerry.first - Spike.first) == abs(Jerry.second - Spike.second) && abs(tomFovPosition.first - Spike.first) == abs(tomFovPosition.second - Spike.second)) {
			//if they all are on the same diagonal
			if (Spike.first<Jerry.first && Spike.first>tomFovPosition.first) {
				//meaning that Tom will meet Spike if he runs towards Jerry
				//he needs to run away
				for (unsigned i = 0; i < fov.size(); i++) {
					for (unsigned j = 0; j < fov[i].size(); j++) {
						d1 = max(abs(tomFovPosition.first - (int)i), abs(tomFovPosition.second - (int)j));
						if (d1 > distAux && fov[i][j] == NULL) {
							newPosition.first = i;
							newPosition.first = j;
						}
					}
				}
			}
		}
		else {
			//he will still go for Jerry
			newPosition = Jerry;
		}
	}

	if ((Spike.first != -1 && Jerry.first == -1)) {
		//if he only sees Spike, he runs
		for (unsigned i = 0; i < fov.size(); i++) {
			for (unsigned j = 0; j < fov[i].size(); j++) {
				d1 = max(abs(tomFovPosition.first - (int)i), abs(tomFovPosition.second - (int)j));
				if (d1 > distAux && fov[i][j] == NULL) {
					newPosition.first = i;
					newPosition.first = j;
				}
			}
		}
	}

	pair<int, int> returnPosition;
	returnPosition.first = this->position.first - (tomFovPosition.first - newPosition.first);
	returnPosition.second = this->position.second - (tomFovPosition.second - newPosition.second);
	cout << "Tom moved from " << this->position.first << ", " << this->position.second << " to " << returnPosition.first << ", " << returnPosition.second << endl;
	return returnPosition;
}
