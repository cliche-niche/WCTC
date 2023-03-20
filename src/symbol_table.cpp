#include <bits/stdc++.h>
#include "../headers/global_vars.hpp"
#include "../headers/symbol_table.hpp"

typedef unsigned long long ull;
using namespace std;

ull num_scopes = 0;
map<string, int> type_to_size = {
        {"byte", 1},
        {"short", 2},
        {"int", 4},
        {"long", 8},
        {"float", 4},
        {"double", 8},
        {"boolean", 1},
        {"char", 2}
};

st_entry::st_entry(){;}

st_entry::st_entry(string name, ull line_no, ull semicolon_no, string type /*= "int"*/){
    this->name = name;
    this->line_no = line_no;
    this->stmt_no = semicolon_no;
    this->type = type;
    // this->size = type_to_size[type];
}

st_entry::st_entry(string name, st_entry (&other)){
    this->name = name;
    this->type = other.type;
    this->line_no = other.line_no;
    this->stmt_no = other.stmt_no;
    this->size = other.size;
}

void st_entry::update_type(string type){
    this->type = type;
    // this->size = type_to_size[type];
}

symbol_table::symbol_table(){
    // num_scopes++;
    // scope = to_string(num_scopes);
    name = scope;
}

symbol_table::symbol_table(symbol_table* parent){
    // In case the scope is nested
    parent->add_scope(this);
    name = scope;
}

void symbol_table::add_scope(symbol_table* st){
    this->sub_scopes++;
    st->scope = scope + "." + to_string(this->sub_scopes);
    st->parent_st = this;    // st is the child symbol table, this pointer gives the parent symbol table
}

void symbol_table::add_entry(st_entry* new_entry){
    for(const auto (&entry) : entries){
        if(new_entry->name == entry->name){
            cout << "Error: Variable " << new_entry->name << " is already declared at line number " << entry->line_no << " in the same scope.\n";
            exit(1);
        }
    }
    entries.push_back(new_entry);
}

void symbol_table::delete_entry(string name){
    for(auto ite = entries.begin(); ite != entries.end(); ite++){
        if((*ite) -> name == name){
            entries.erase(ite);
            return;
        }
    }

    cout<<"There is no entry with variable name " << name << " in scope " << scope << ".\n";
    cout<<"Returning without deleting...\n";
}

st_entry* symbol_table::look_up(string name){
    for(ull idx = 0; idx < entries.size(); idx++){
        if(entries[idx]->name == name)
            return entries[idx];
    }
    
    if(this->parent_st){
        return this->parent_st->look_up(name);
    }

    return NULL;
}

st_entry* symbol_table::look_up(string name, ull line_no){
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

symbol_table_func::symbol_table_func(symbol_table* parent_table, string func_name){
    this->parent_st = parent_table;
    this->name = func_name;
    parent_table->add_scope(this);       
}

void symbol_table_func::add_entry(st_entry* new_entry) {
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

bool symbol_table_func::operator == (const symbol_table_func& other){
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