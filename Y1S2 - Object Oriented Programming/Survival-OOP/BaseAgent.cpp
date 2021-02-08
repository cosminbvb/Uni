#include "BaseAgent.h"

void BaseAgent::setHp(int hp) {
	this->hp = hp;
}
void BaseAgent::setPosition(pair<int, int> position) {
	this->position = position;
}
int BaseAgent::getHp() {
	return hp;
}
pair<int, int> BaseAgent::getPosition() {
	return position;
}
char BaseAgent::getDescription() {
	return description;
}
BaseAgent* BaseAgent::oneVone(BaseAgent* a1, BaseAgent* a2) {
	if (a1->getDescription() == 'J') {
		if (a2->getDescription() == 'S') {
			//Jerry vs Spike => Jerry bc he is smarter
			int local = a1->getHp()/2;
			a1->setHp(local);
			cout <<"Jerry took " << local << " damage."<<endl;
			cout <<"Jerry fought Spike for position (" << a1->getPosition().first << ", " << a1->getPosition().second << ") and won." << endl;
			return a1;
		}
		else if(a2->getDescription()=='T'){
			//Jerry vs Tom => whoever has more hp
			if (a1->getHp() >= a2->getHp()) {
				int local = a1->getHp() / 2;
				a1->setHp(local);
				cout <<"Jerry took " << local << " damage."<<endl;
				cout <<"Jerry fought Tom for position (" << a1->getPosition().first << ", " << a1->getPosition().second << ") and won." << endl;
				return a1;
			}
			else {
				int local = a2->getHp() / 2;
				a2->setHp(local);
				cout <<"Tom took " << local << " damage." << endl;
				cout <<"Tom fought Jerry for position (" << a1->getPosition().first << ", " << a1->getPosition().second << ") and won." << endl;
				return a2;
			}
		}
	}
	if (a1->getDescription() == 'T') {
		if (a2->getDescription() == 'S') {
			//Tom vs Spike => Spike
			int local = a2->getHp() / 2;
			a2->setHp(local);
			cout <<"Spike took " << local << " damage." << endl;
			cout <<"Spike fought Tom for position (" << a1->getPosition().first << ", " << a1->getPosition().second << ") and won." << endl;
			return a2;
		}
		else if (a2->getDescription() == 'J') {
			//Tom vs Jerry => whoever has more hp
			if (a1->getHp() > a2->getHp()) {
				int local = a1->getHp() / 2;
				a1->setHp(local);
				cout <<"Tom took " << local << " damage." << endl;
				cout <<"Tom fought Jerry for position (" << a1->getPosition().first << ", " << a1->getPosition().second << ") and won." << endl;
				return a1;
			}
			else {
				int local = a2->getHp() / 2;
				a2->setHp(local);
				cout <<"Jerry took " << local << " damage." << endl;
				cout <<"Jerry fought Tom for position (" << a1->getPosition().first << ", " << a1->getPosition().second << ") and won." << endl;
				return a2;
			}
		}
	}
	if (a1->getDescription() == 'S') {
		if (a2->getDescription() == 'T') {
			//Spike vs Tom => Spike
			int local = a1->getHp() / 2;
			a1->setHp(local);
			cout <<"Spike took " << local << " damage." << endl;
			cout <<"Spike fought Tom for position (" << a1->getPosition().first << ", " << a1->getPosition().second << ") and won." << endl;
			return a1;
		}
		else if (a2->getDescription() == 'J') {
			//Spike vs Jerry => Jerry
			int local = a2->getHp() / 2;
			a2->setHp(local);
			cout <<"Jerry took " << local << " damage." << endl;
			cout <<"Jerry fought Spike for position (" << a1->getPosition().first << ", " << a1->getPosition().second << ") and won." << endl;
			return a2;
		}
	}
	if (a1->getDescription() == a2->getDescription()) {
		//they merge
		a1->setHp(a1->getHp() + a2->getHp());
		if (a1->getDescription() == 'T') {
			cout << "Two Toms have merged, now Tom from (" << a1->getPosition().first << " ," << a1->getPosition().second << ") has " << a1->getHp() << " hp." << endl;
		}
		else if (a1->getDescription() == 'J') {
			cout << "Two Jerrys have merged, now Jerry from (" << a1->getPosition().first << " ," << a1->getPosition().second << ") has " << a1->getHp() << " hp." << endl;
		}
		else {
			cout << "Two Spikes have merged, now Spike from (" << a1->getPosition().first << " ," << a1->getPosition().second << ") has " << a1->getHp() << " hp." << endl;
		}
		return a1;
	}
}