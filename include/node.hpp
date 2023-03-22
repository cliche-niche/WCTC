#ifndef NODE_HPP
#define NODE_HPP

#include "symbol_table.hpp"
#include <bits/stdc++.h>
using namespace std;

struct node{
    string name = "";   // stores the lexeme if terminal or the name of the non terminal otherwise
    bool terminal = false;
    bool exp_applicable = false;
    string type = ""; // * To be used only if node is a terminal, empty otherwise. stores the token
    unsigned long long node_number = 0;     // For disambiguity in AST code
    node* parent = NULL;

    symbol_table* sym_tab; // symbol table to which the node belongs
    st_entry* sym_tab_entry;
    vector<st_entry* > entry_list;

    vector< node* > children;

    node(string name = "", bool terminal = false, string type = "", node* parent = NULL);

    void add_child(node* child);    // add child

    void print_tree(int tab);   // print parse tree

    void clean_tree();  // applies various policies to convert parse tree to AST

    void copy(const node other); 

    void remove_lexeme_policy(string lex);
    node* one_child_policy(int idx);
    void kill_parent(int idx, int child_idx = 0);
    void expression_policy();

    void make_dot(string filename = "tree.gv");                             // used to 
    void add_nodes(unsigned long long (&node_num), string (&dot_code));     // generate
    void add_edges(string (&dot_code));                                     // dot code
    
    string get_name(node* v);   // used for
    int get_dims(node* v);      // semantic actions

    symbol_table* get_symbol_table();
    void create_scope_hierarchy();

    void validate_expression();
    void populate_and_check();
};

#endif