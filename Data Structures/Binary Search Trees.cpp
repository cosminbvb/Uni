// Binary Search Trees.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
using namespace std;

struct BST {
    int info;
    BST* left, * right, * parent;
}*root;

void inorderWalk(BST* root) {
    //Θ(n) (n=nr of nodes)
    if (root != NULL) {
        inorderWalk(root->left);
        cout << root->info <<" ";
        inorderWalk(root->right);
    }
} 

void preorderWalk(BST* root) {
    //Θ(n)
    if (root != NULL) {
        cout << root->info <<" ";
        preorderWalk(root->left);
        preorderWalk(root->right);
    }
}

bool recursiveSearch(BST* root, int x) {
    //O(h)
    if (root == NULL)
        return 0;
    if (x == root->info)
        return 1;
    if (x < root->info)
        return recursiveSearch(root->left, x);
    else
        return recursiveSearch(root->right, x);
}

bool iterativeSearch(BST* root, int x) {
    //O(h)
    while (root != NULL) {
        if (root->info == x) return 1;
        if (x < root->info) root = root->left;
        else root = root->right;
    }
    return 0;
}

BST* minimum(BST* root) {
    //O(h)
    while (root->left != NULL)
        root = root->left;
    return root;
}

BST* maximum(BST* root) {
    //O(h)
    while (root->right != NULL)
        root = root->right;
    return root;
}

void insert(BST*& root, int value) {
    //O(h)
    BST* y = NULL;
    BST* x = root;
    BST* z = new BST;
    z->info = value;
    z->left = z->right = z->parent = NULL;
    while (x != NULL) {
        y = x;
        if (value < x->info)
            x = x->left;
        else
            x = x->right;
    }
    z->parent = y;
    if (y == NULL) root = z; //the tree was empty
    else if (value < y->info)
        y->left = z;
    else
        y->right = z;
}

void transplant(BST*& root, BST*& u, BST*& v) {
    //replaces the subtree rooted at node u with the subtree
    //rooted at node v
    //u and v are subtrees of the tree rooted at node "root"
    if (u->parent == NULL)
        //which means u is the root of the main tree
        root = v;
    else if (u == u->parent->left)
        //which means u is a left child
        u->parent->left = v;
    else
        u->parent->right = v;
    if (v != NULL) v->parent = u->parent;
    //we allow v to be NULL. If it is not null, we update v's parent.
}

void del(BST*& root, int value) {
    //deletes first appearance of value and keeps a bst
    BST* temp = root;
    int found = 0;
    while (temp != NULL && found == 0) {
        if (temp->info == value) found = 1;
        else if (value < temp->info) temp = temp->left;
        else temp = temp->right;
    }
    if (found) {
        if (temp->left == NULL) {
            //the case in which node temp has no left chil
            transplant(root, temp, temp->right);
        }
        else if (temp->right == NULL) {
            //the case in which node temp has no right child
            transplant(root, temp, temp->left);
        }
        else {
            BST* sc = minimum(temp->right); //sc is now the successor of temp
            if (sc->parent != temp) {
                //if sc is not the right chil of temp
                transplant(root, sc, sc->right);
                sc->right = temp->right;
                sc->right->parent = sc;
            }
            transplant(root, temp, sc);
            sc->left = temp->left;
            sc->left->parent = sc;
        }
    }
}

void keysInRange(BST* root, int k1, int k2) {
    //prints keys in range (k1, k2)
    if (root == NULL) 
        return;
    if (root->info > k1)
        keysInRange(root->left, k1, k2);
    if (root->info > k1 && root->info < k2)
        cout << root->info << " ";
    if (root->info < k2)
        keysInRange(root->right, k1, k2);
}

int main()
{
    insert(root, 6);
    insert(root, 4);
    insert(root, 9);
    insert(root, 2);
    insert(root, 1);
    insert(root, 5);
    insert(root, 3);
    insert(root, 7);
    insert(root, 8);
    cout << "Inorder Walk: ";
    inorderWalk(root);
    cout << endl;
    cout << "Preorder Walk: ";
    preorderWalk(root);
    cout << endl;
    del(root, 4);
    cout << "After removing 4: ";
    inorderWalk(root);
    cout << endl;
    cout << "Keys in range (4,8): ";
    keysInRange(root, 4, 8);
    return 0;
}

