#ifndef NODE_CPP
#define NODE_CPP

#include <bits/stdc++.h>
using namespace std;

struct node{
    string name = "";   // stores the lexeme if terminal or the name of the non terminal otherwise
    bool terminal = false;
    string type = ""; // * To be used only if node is a terminal, empty otherwise. stores the token
    int child_count = 0;
    node* parent = NULL;
    vector< node* > children;

    node(string name = "", bool terminal = false, string type = "", node* parent = NULL){
        this->parent = parent;
        this->name = name;
        this->terminal = terminal;
        this->type = type;
        this->child_count = 0;
    }
};

// void add_child(node* parent, node* child){
//     if(!child || !parent) return;
//     child->parent = parent;
//     parent->children.push_back(child);
//     (parent->child_count)++;
// }



// void reparent(node* parent){
//     // * To be written
// }

#endif