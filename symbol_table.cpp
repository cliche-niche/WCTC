#ifndef SYMBOL_TABLE_CPP
#define SYMBOL_TABLE_CPP

#include <bits/stdc++.h>
typedef unsigned long long ull;
using namespace std;

extern ull num_scopes;

struct st_entry{
    // One entry of a symbol table
    // From assignment: Type, source file, line number, size, offset

    string name;
    string type;
    ull line_no;
    ull stmt_no;
    ull size;
    ull offset = 0; // what is this
    ull dimensions = 0;

    st_entry(){;}

    st_entry(string name, ull line_no, ull semicolon_no, string type = "int"){
        this->name = name;
        this->line_no = line_no;
        this->stmt_no = semicolon_no;
        this->type = type;
        // this->size = type_to_size[type];
    }

    st_entry(string name, st_entry (&other)){
        this->name = name;
        this->type = other.type;
        this->line_no = other.line_no;
        this->stmt_no = other.stmt_no;
        this->size = other.size;
    }

    void update_type(string type){
        this->type = type;
        // this->size = type_to_size[type];
    }
};

struct symbol_table {
    vector<st_entry*> entries;
    string scope, name;
    symbol_table* parent_st = NULL;
    int sub_scopes = 0;

    symbol_table(){
        // num_scopes++;
        // scope = to_string(num_scopes);
        name = scope;
    }

    symbol_table(symbol_table* parent){
        // In case the scope is nested
        parent->add_scope(this);
        name = scope;
    }

    void add_scope(symbol_table* st){
        this->sub_scopes++;
        st->scope = scope + "." + to_string(this->sub_scopes);
        st->parent_st = this;    // st is the child symbol table, this pointer gives the parent symbol table
    }

    void add_entry(st_entry* new_entry){
        for(const auto (&entry) : entries){
            if(new_entry->name == entry->name){
                cout << "Error: Variable " << new_entry->name << " is already declared at line number " << entry->line_no << " in the same scope.\n";
                exit(1);
            }
        }
        entries.push_back(new_entry);
    }

    void delete_entry(string name){
        for(auto ite = entries.begin(); ite != entries.end(); ite++){
            if((*ite) -> name == name){
                entries.erase(ite);
                return;
            }
        }

        cout<<"There is no entry with variable name " << name << " in scope " << scope << ".\n";
        cout<<"Returning without deleting...\n";
    }

    st_entry* look_up(string name){
        for(ull idx = 0; idx < entries.size(); idx++){
            if(entries[idx]->name == name)
                return entries[idx];
        }
        
        if(this->parent_st){
            return this->parent_st->look_up(name);
        }

        return NULL;
    }

    st_entry* look_up(string name, ull line_no){
        for(ull idx = 0; idx < entries.size(); idx++){
            if(entries[idx]->name == name && entries[idx]->line_no <= line_no){
                return entries[idx];
            }
        }

        if(this->parent_st){
            return this->parent_st->look_up(name, line_no);
        }

        return NULL;
    }

};

struct symbol_table_func : public symbol_table {
    // Additionally stores the types of parameters expected in the function
    // Along with other entries in a typical symbol table
    vector<st_entry* > params;
    string func_name;
    
    void add_entry(st_entry* new_entry) {
        for(const auto (&param) : params) {
            if(new_entry->name == param->name) {
                cout << "Error: Variable " << new_entry -> name << " is already declared at line number " << param->line_no << " as a formal parameter.\n";
                exit(1);
            }
        }

        for(const auto (&entry) : entries){
            if(new_entry -> name == entry -> name){
                cout << "Error: Variable " << new_entry -> name << " is already declared at line number " << entry -> line_no << " in the same scope.\n";
                exit(1);
            }
        }

        entries.push_back(new_entry);
    }

    symbol_table_func(symbol_table* parent_table, string func_name){
        this->parent_st = parent_table;
        this->name = func_name;
        parent_table->add_scope(this);       
    }

    bool operator == (const symbol_table_func& other){
        if(this->func_name == other.name){
            if((this->params).size() == other.params.size()){
                for(int idx = 0; idx < other.params.size(); idx++){
                    if((this->params)[idx]->type != other.params[idx]->type){
                        return false;
                    }
                }
                return true;
            }
        }
        return false;
    }
};

struct symbol_table_class : public symbol_table {
    // Stores member variables and a list of Function-Symbol tables for member functions 
    vector<symbol_table_func* > member_funcs;

};

#endif 