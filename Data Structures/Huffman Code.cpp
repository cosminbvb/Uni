#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <queue>
using namespace std;

class Node {
    char c;
    int freq;
    Node* left, * right;
    map<char, string> encoding;
public:
    Node(char c, int freq, Node* left = NULL, Node* right = NULL)
        :c(c), freq(freq), left(left), right(right) {};
    int getFreq() const { return freq; };
    void inorder(Node* root, string codeword) {
        if (root) {
            inorder(root->left, codeword + "0");
            if (root->c) {
                //cout << root->c;
                encoding[root->c] = codeword;
            }
            inorder(root->right, codeword + "1");
        }
    }
    map<char, string> getEncoding(Node* root) {
        inorder(root, "");
        return encoding;
    }
};

class Cmp {
    //comparison functor for the pq
public:
    bool operator()(const Node* n1, const Node* n2) {
        return n1->getFreq() >= n2->getFreq();
    }
};

int main()
{
    ifstream f("input.txt");
    map<char, int>freq;
    string line;
    while (getline(f, line)) {
        for (char c : line) {
            freq[c]++;
        }
    }
    priority_queue<Node*, vector<Node*>, Cmp>pq;
    for (auto pair : freq) {
        Node* node = new Node(pair.first, pair.second);
        pq.push(node);
    }
    int n = freq.size();
    for (int i = 1; i <= n - 1; i++) {
        Node* left = pq.top();
        pq.pop();
        Node* right = pq.top();
        pq.pop();
        int frequency = left->getFreq() + right->getFreq();
        Node* temp = new Node(0, frequency, left, right);
        pq.push(temp);
    }
    Node* root = pq.top(); //root
    map<char, string> enc = root->getEncoding(root);
    cout << "Huffman code for each character:" << endl;
    for (auto pair : enc) {
        cout << pair.first << ": " << pair.second << endl;
    }
}


