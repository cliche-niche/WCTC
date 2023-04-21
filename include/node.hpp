#ifndef NODE_HPP
#define NODE_HPP

#include <bits/stdc++.h>
#include "symbol_table.hpp"
#include "tac.hpp"
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
    int line_no = 0;                    // Stores where the node body **ENDS**, i.e., where the production rule is completed
    vector<quad> ta_codes;
    bool type_checked = false;          // Tracks if type_checked is called or not

    long long int exp_int_val = 0;
    double exp_dob_val = 0.0;
    string exp_str_val = ""; 
    bool exp_bool_val = false;
    bool exp_is_constant = false;       // set to true if the expression holds a constant value

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

    symbol_table* get_scope();
    bool check_static();        // Checks if function is static or not
    symbol_table* get_symbol_table();
    symbol_table_class* get_symbol_table_class();
    st_entry* get_and_look_up();
    st_entry* get_and_look_up(string id);
    st_entry* get_and_look_up_member_variable(string id, string cls);
    void create_scope_hierarchy();

    void populate_default_constructors();
    void populate_class_sizes();

    string get_type_without_array(string type);

    void validate_expression();
    void populate_and_check();

    void modifier_check();

    bool overflow_check(string datatype, node *exp);
    void type_check();
    void chill_traversal();                                         // just a temporary function for type checking
    vector<string> get_function_parameters();                       // returns function parameters and should only be called from BracketArgumentList node 
    void get_dimension_variables(st_entry *arr);                       // called only from ArrayCreationExpression
    void get_dimension_dfs(st_entry *arr);                                     // dfs called by the get_dimension_variables wrapper
    void obtain_function_parameters(vector<string> &params);        // helper function

    int get_access_depth(string dt);                                // returns access depth
    st_entry* get_and_look_up_from_name();                          // for performing look ups from qualified names
    string get_var_from_node();
    string get_next_label();                                          // Useful for IfThenStatement, WhileStatement, ForStatement, etc.
    void append_tac(vector<quad> (&tacs));
    void append_tac(node* v);
    vector<string> get_func_args_tac();
    string get_mangled_name();
    void generate_tac();


    char calculate_type(string n);              // Tells if the string is an integer/float/boolean
    string convert_to_decimal(string);          // Convert bin/hex/oct to Decimal
    void convert_to_decimal();                  // Convert bin/hex/oct to Decimal in the whole 3AC
    void remove_empty_tac();                    // Remove those Quads which have empty 3AC
    void update_tac_jump_vals();                // Update ins_line's and abs_jump's
    void rename_temporaries();                  // Rename temporaries starting from 1
    bool optimize_tac_RED_TEMPS();              // Remove redundant temporaries and rename them using Copy Propagation and its variant
    bool optimize_tac_CONST_and_STR_RED();      // Constant Folding and Constant Propagation, and 
    bool optimize_tac_COPY_PROP();              // Copy Propagation
    bool optimize_tac_DC_ELIM();                // Dead Code Elimination -- DCE (of temporaries)
    void change_bool_to_int(quad &);            // Convert all bool instances to int
    
    void generate_tac_for_default_constructors();   // Generates the 3AC for the default 

    void print_tac(string filename);            // Print 3AC into the file ``filename''
};

#endif