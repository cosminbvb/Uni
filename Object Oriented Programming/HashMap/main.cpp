// HashMap.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
#include "HashMap.h"
#include <iostream>
#include <cassert>
using namespace std;

void Tests() {
    HashMap<string, int> map;
    map.insert("Pisica", 3);
    map.insert("Iepure", 5);
    map.insert("Caine", 2);
    map.insert("Pisica", 7);
    //cout << map << endl;
    try {
    cout << map["Gandac"] << endl;
    assert(false);
    }
    catch (char const* e) {
        //cout << e << endl;
    }
    assert(map["Iepure"] == 5);
    assert(map.getValues("Pisica") == vector<int>({3,7}));
    assert(map.containsKey("Pisica") == true);
    assert(map.containsKey("Gandac") == false);
    assert(map.getDistinctKeys() == 3);
    map.remove("Pisica");
    //cout << map << endl;
    try {
        map.remove("Pisica");
        assert(false);
    }
    catch (char const* e) {
        //cout << e << endl;
    }
    HashMap<string, int> copy = map;
    assert(copy["Iepure"] == 5);
    assert(copy.containsKey("Pisica") == false);
    assert(copy.containsKey("Gandac") == false);
    assert(copy.getDistinctKeys() == 2);
    HashMap<string, int> copy2(map);
    assert(copy2["Iepure"] == 5);
    assert(copy2.containsKey("Gandac") == false);
    assert(copy2.getDistinctKeys() == 2);
}


int main()
{

    /*
    TO DO:
    maybe: resizing 
    */

    Tests();
    
    return 0;
}