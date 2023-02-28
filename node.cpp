#ifndef NODE_CPP
#define NODE_CPP

#include <bits/stdc++.h>
using namespace std;

struct node{
    string name = "";   // stores the lexeme if terminal or the name of the non terminal otherwise
    bool terminal = false;
    string type = ""; // * To be used only if node is a terminal, empty otherwise. stores the token
    int child_count = 0;
    unsigned long long node_number = 0;     // For disambiguity in AST code
    node* parent = NULL;
    vector< node* > children;

    node(string name = "", bool terminal = false, string type = "", node* parent = NULL){
        this->parent = parent;
        this->name = name;
        this->terminal = terminal;
        this->type = type;
        this->child_count = 0;
    }

    void print_tree(int tab){
        for(int i=0; i<tab; i++){
            cout<<'\t';
        }
        cout<<(this->name)<<"-> ";
        for(auto i: (this->children)){
            cout<<(i->name)<<' ';
        }
        cout<<'\n';
        tab++;
        for(auto i: (this->children)){
            i->print_tree(tab);
        }
    }

    void clean_tree(){
        // * To be written
    }

    void kill_parent(){
        // * To be written
    }

    void make_dot(string filename = "tree.gv"){
        unsigned long long node_num = 0;

        string dot_code = "digraph ast {\n";
        this->add_nodes(node_num, dot_code);
        dot_code += '\n';
        this->add_edges(dot_code);
        dot_code += "}";

        ofstream out(filename);
        out<<dot_code;
        out.close();
    }

    void add_nodes(unsigned long long (&node_num), string (&dot_code)){
        node_num++;
        this->node_number = node_num;
        dot_code += "node" + to_string(this->node_number) + "[label = \"" + this->name + "\"];\n";

        for(auto child : (this->children)){
            child->add_nodes(node_num, dot_code);
        }
    }

    void add_edges(string (&dot_code)){
        for(auto child : (this->children)){
            dot_code += "node" + to_string(this->node_number) + " -> " + "node" + to_string(child->node_number) + ";\n";
            child->add_edges(dot_code);
        }
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