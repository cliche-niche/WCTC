#ifndef NODE_HPP
#define NODE_HPP

#include "symbol_table.hpp"
#include <bits/stdc++.h>
using namespace std;

struct node{
    string name = "";                   // stores the lexeme if terminal or the name of the non terminal otherwise
    bool terminal = false;
    bool exp_applicable = false;
    string type = "";                   // To be used only if node is a terminal, empty otherwise. stores the token
    unsigned long long node_number = 0; // For disambiguity in AST code
    node* parent = NULL;
    string datatype = "UNDEFINED";      // Used for typechecking
    string typecast_to = "UNNEEDED";    // If the node needs to be type-casted,

    long long int exp_int_val = 0;
    double exp_dob_val = 0.0;
    string exp_str_val = ""; 
    bool exp_bool_val = false;

    symbol_table* sym_tab;              // symbol table to which the node belongs
    st_entry* sym_tab_entry;
    vector<st_entry* > entry_list;

    vector< node* > children;

    node(string name = "", bool terminal = false, string type = "", node* parent = NULL);

    void add_child(node* child);                                // add child

    void set_datatype(node* child1, node* child2 = NULL, string op="");       // Finds datatype from given chlidren nodes for static expressions
    char get_datatype_category();                               // Returns datatype of node, values can be
                                                                // B, I, N, D, S, U (boolean, int, null, double, string, undefined)
    char get_datatype_category(string dt);                      // 
    string get_maxtype(string dt1, string dt2 = "");
    void calc_datatype(node* child1, node* child2 = NULL, string op="");    // Finds datatype from children nodes for all nodes
    bool find_cast(string dt1, string dt2);

    void print_tree(int tab);                                   // print parse tree
    void copy(const node other); 

    void clean_tree();                  // applies various policies to convert parse tree to AST
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
    symbol_table_class* get_symbol_table_class();
    st_entry* get_and_look_up();
    void create_scope_hierarchy();

    void validate_expression();
    void populate_and_check();
    void type_check();
    void chill_traversal(); // just a temporary function for type checking
    vector<string> get_function_parameters();   // returns function parameters and should only be called from BracketArgumentList node 
    void obtain_function_parameters(vector<string> &params);      // helper function
};

#endif