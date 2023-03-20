#ifndef SYMBOL_TABLE_HPP
#define SYMBOL_TABLE_HPP

#include <bits/stdc++.h>
typedef unsigned long long ull;
using namespace std;

struct symbol_table;

struct st_entry{
    // One entry of a symbol table
    // From assignment: Type, source file, line number, size, offset

    string name;
    string type;
    symbol_table* table;
    ull line_no;
    ull stmt_no;
    ull size;
    ull offset = 0; // what is this
    ull dimensions = 0;

    st_entry();
    st_entry(string name, ull line_no, ull semicolon_no, string type = "int");
    st_entry(string name, st_entry (&other));

    void update_type(string type);
};

struct symbol_table {
    vector<st_entry*> entries;
    string scope, name;
    symbol_table* parent_st = NULL;
    int sub_scopes = 0;

    symbol_table();
    symbol_table(string name);

    void add_scope(symbol_table* st);

    void add_entry(st_entry* new_entry);
    void delete_entry(string name);

    st_entry* look_up(string name);
    st_entry* look_up(string name, ull line_no);
};

struct symbol_table_func : public symbol_table {
    // Additionally stores the types of parameters expected in the function
    // Along with other entries in a typical symbol table
    vector<st_entry* > params;
    string func_name;
    
    symbol_table_func(string func_name, vector<st_entry* > (&params));

    void add_entry(st_entry* new_entry);

    bool operator == (const symbol_table_func& other);
};

struct symbol_table_class : public symbol_table {
    // Stores member variables and a list of Function-Symbol tables for member functions 
    vector<symbol_table_func* > member_funcs;
    vector<st_entry*> member_fields; 

    symbol_table_class(string class_name);

    void add_entry(symbol_table_func* func);
};

#endif 