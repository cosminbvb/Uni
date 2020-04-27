#include <iostream>
#include <string>
using namespace std;

struct BST {
    string info;
    BST* left, * right, * parent;
};

void inorderWalk(BST* root) {
    //Θ(n) (n=nr of nodes)
    if (root != NULL) {
        inorderWalk(root->left);
        cout << root->info << " ";
        inorderWalk(root->right);
    }
}

void insert(BST*& root, string str) {
    //O(h)
    BST* y = NULL;
    BST* x = root;
    BST* z = new BST;
    z->info = str;
    z->left = z->right = z->parent = NULL;
    while (x != NULL) {
        y = x;
        if (str < x->info)
            x = x->left;
        else
            x = x->right;
    }
    z->parent = y;
    if (y == NULL) root = z; //the tree was empty
    else if (str < y->info)
        y->left = z;
    else
        y->right = z;
}

int main() {

    string a;
    BST* root=NULL;
    int n;
    cout << "number of words: "<<endl;
    cin >> n; //nr of words
    for (int i = 0; i < n; i++) {
        cin >> a;
        insert(root, a);
    }
    cout << "After sorting: " << endl;
    inorderWalk(root);

    return 0;
}