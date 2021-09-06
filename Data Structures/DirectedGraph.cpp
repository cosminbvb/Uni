#include <iostream>
#include <unordered_map>
#include <list>
#include <queue>
#include <stack>
#include <unordered_set>
using namespace std;

class directedGraph {
    
    vector<list<int>> adjacencyList;
    
public:

    directedGraph(int nodes = 0){
        adjacencyList.resize(nodes);
    }

    void addNode(int);
    void addEdge(int, int);
    bool hasEdge(int, int);
    void BFS(int);
    void DFS(int);
    int twoCycles();

    void printList();

protected:
    //helper
    void DFShelper(int, unordered_set<int>);
};

void directedGraph::addNode(int node) {
    if (node >= adjacencyList.size()) {
        adjacencyList.resize(node + 1);
    }
}

void directedGraph::addEdge(int source, int target) {
    adjacencyList[source].push_back(target);
}

bool directedGraph::hasEdge(int source, int target) {
    for (int node : adjacencyList[source]) {
        if (node == target) {
            return true;
        }
    }
    return false;
}

void directedGraph::BFS(int startNode) {

    queue<int> q;
    unordered_set<int> visited;
    q.push(startNode);
    visited.insert(startNode);
    while (q.size()) {
        int current = q.front();
        q.pop();
        cout << current <<" ";
        for (int neighbour : adjacencyList[current]) {
            if (visited.find(neighbour) == visited.end()) {
                //if the neighbour hasn t been visited we add him into the queue
                q.push(neighbour);
                //and mark him as visited
                visited.insert(neighbour);
            }
        }

    }
    cout << endl;
}

void directedGraph::DFShelper(int startNode, unordered_set<int> v) {
    if (v.find(startNode) == v.end()) {
        //if it hasn t been visited
        cout << startNode << " ";
        v.insert(startNode);
        for (int i : adjacencyList[startNode]) {
            DFShelper(i, v);
        }
    }
}

void directedGraph::DFS(int startNode) {
    unordered_set<int>visited;
    DFShelper(startNode, visited);
    cout << endl;
}

int directedGraph::twoCycles() {
    int nr = 0;
    for (int i = 0; i < adjacencyList.size(); i++) {
        //for each node
        for (int j : adjacencyList[i]) {
            //for each neighbour
            //we check if the connection is mutual
            if (this->hasEdge(j, i)) {
                nr++;
            }
        }
    }
    return nr / 2; //we counted each cycle twice
}

void directedGraph::printList() {
    for (int i = 0; i < adjacencyList.size(); i++) {
        if (adjacencyList.size() != 0) {
            cout << i << ": ";
        }
        for (auto j : adjacencyList[i]) {
            cout << j << " ";
        }
        cout << endl;
    }
}

int main()
{
    directedGraph g(3);
    g.addEdge(0, 1);
    g.addEdge(1, 0);
    g.addEdge(1, 2);
    g.addEdge(2, 3);
    g.addNode(4);
    g.addEdge(2, 4);
    g.addEdge(3, 1);
    g.addEdge(4, 2);
    cout << "BFS(2): ";
    g.BFS(2);
    cout << "DFS(2): ";
    g.DFS(2);
    cout << "Two Cycles: " << g.twoCycles();
}

