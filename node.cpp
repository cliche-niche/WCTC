#ifndef NODE_CPP
#define NODE_CPP

#include <bits/stdc++.h>
using namespace std;

struct node{
    string name = "";   // stores the lexeme if terminal or the name of the non terminal otherwise
    bool terminal = false;
    bool exp_applicable = false;
    string type = ""; // * To be used only if node is a terminal, empty otherwise. stores the token
    unsigned long long node_number = 0;     // For disambiguity in AST code
    node* parent = NULL;
    vector< node* > children;

    node(string name = "", bool terminal = false, string type = "", node* parent = NULL){
        this->parent = parent;
        this->name = name;
        this->terminal = terminal;
        this->type = type;
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

        // Removing semicolon (and other?) delimiters
        this->remove_lexeme_policy(";");

        // * Cleans the Parse tree to make an AST; Should necessarily be called from the root.
        // * Removing Nodes with a single child; Replaces them with the child
        node* v = NULL;
        for(int x = 0; x < (this->children).size(); x++){
            v = ((this->children)[x])->one_child_policy(x);
            if(v){
                delete v;
                x--;
            }
        }
        
        // * Bring operators above
        this->expression_policy();
    }

    void remove_lexeme_policy(string lex) {
        for(int x = 0; x < (this->children).size(); x++) {
            node *tmp = (this -> children)[x];
            if(tmp->name == lex) {
                (this->children).erase((this->children).begin() + x, (this->children).begin() + x + 1);  
                delete tmp;
                x--;
            }
            else {
                tmp->remove_lexeme_policy(lex);
            }
        }
    }

    node* one_child_policy(int idx){     
        // Ensures that each Node in the AST with one child is replaced by the child; deletes the parent afterwards
        // idx is the index of the current node in its parent's list. The node's child shall occupy this index after killing its parent
        assert(this->parent != NULL);
        if((this->children).size() == 1){
            this->kill_parent(idx);
            return this;
        }else{
            node* v = NULL;
            for(int x = 0; x < (this->children).size(); x++){
                v = ((this->children)[x])->one_child_policy(x);
                if(v){
                    delete v;
                    x--;
                }
            }
            return NULL;
        }
    }

    void kill_parent(int idx, int child_idx = 0){
        node* child = this->children[child_idx];
        child->parent = this->parent;
        ((child->parent)->children)[idx] = child;
    }

    void expression_policy(){
        if(this->exp_applicable){            
            if((this->children).size() == 2) {
                node* child = (this->children)[0];
                this->name = child->name;
                this->type = child->type;
                this->terminal = child->terminal;
                this->exp_applicable = child->exp_applicable;
                (this->children).erase((this->children).begin(), (this->children).begin() + 1);  
                delete child;
            } else if((this->children).size() == 3){
                node* child = (this->children)[1];
                this->name = child->name;
                this->type = child->type;
                this->terminal = child->terminal;
                this->exp_applicable = child->exp_applicable;
                (this->children).erase((this->children).begin() + 1, (this->children).begin() + 2);  
                delete child;
            } else if((this->children).size() == 5){
                node* child = (this->children)[1];
                this->name = "?:";
                this->type = "OPERATOR";
                this->terminal = child->terminal;
                this->exp_applicable = child->exp_applicable;
                child = (this->children)[3];
                (this->children).erase((this->children).begin() + 3, (this->children).begin() + 4);  
                delete child;
                child = (this->children)[1];
                (this->children).erase((this->children).begin() + 1, (this->children).begin() + 2);  
                delete child;
            }
        }

        for(int x = 0; x < (this->children).size(); x++) {
            (this->children)[x] -> expression_policy();
        }
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
        
        if(this->terminal){
            dot_code += "node" + to_string(this->node_number) + "[label = \"" + this->type + '\n' + this->name + "\", shape = rectangle, color = ";
            if(this->type == "ID"){
                dot_code += "purple";
            }else if(this->type == "OPERATOR"){
                dot_code += "green";
            }else if(this->type == "KEYWORD"){
                dot_code += "blue";
            }else if(this->type == "DELIMITER"){
                dot_code += "red";
            }else{
                dot_code += "red";
            }
            dot_code += "];\n";
        }else{
            dot_code += "node" + to_string(this->node_number) + "[label = \"" + this->name + "\"];\n";
        }

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

    void add_child(node* child) {
        if(!child) return;
        child->parent = this;
        this->children.push_back(child);
    }
};

#endif