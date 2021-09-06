#pragma once

#include <functional>

using namespace std;

template<class K>
class KeyHash {

	size_t tableSize;

public:

	KeyHash(const size_t& size = 1013) : tableSize(size) {};

	size_t operator() (const K& key) {
		return hash<K>()(key) % tableSize;
	}

};