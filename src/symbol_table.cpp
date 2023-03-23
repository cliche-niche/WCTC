#include <bits/stdc++.h>
#include "../include/global_vars.hpp"
#include "../include/symbol_table.hpp"

typedef unsigned long long ull;
using namespace std;

ull num_scopes = 0;
symbol_table_global *main_table = new symbol_table_global;
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

// enum MODIFIER {
//     M_PUBLIC,
//     M_PRIVATE,
//     M_PROTECTED,
//     M_STATIC,
//     M_ABSTRACT,
//     M_NATIVE,
//     M_SYNCHRONIZED,
//     M_TRANSIENT,
//     M_VOLATILE,
//     M_FINAL,
//     COUNT
// };

st_entry::st_entry(){;}

st_entry::st_entry(string name, ull line_no, ull semicolon_no, string type /*= "int"*/){
    this->name = name;
    this->line_no = line_no;
    this->stmt_no = semicolon_no;
    this->type = type;
    this->size = type_to_size[type];
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
    this->size = type_to_size[type];
}

void st_entry::update_modifiers(vector<st_entry*> modifiers){
    for(auto entry : modifiers){
        if(entry -> name == "public")       this -> modifier_bv [M_PUBLIC]          = true;
        if(entry -> name == "private")      this -> modifier_bv [M_PRIVATE]         = true;
        if(entry -> name == "protected")    this -> modifier_bv [M_PROTECTED]       = true;
        if(entry -> name == "static")       this -> modifier_bv [M_STATIC]          = true;
        if(entry -> name == "abstract")     this -> modifier_bv [M_ABSTRACT]        = true;
        if(entry -> name == "native")       this -> modifier_bv [M_NATIVE]          = true;
        if(entry -> name == "synchronized") this -> modifier_bv [M_SYNCHRONIZED]    = true;
        if(entry -> name == "transient")    this -> modifier_bv [M_TRANSIENT]       = true;
        if(entry -> name == "volatile")     this -> modifier_bv [M_VOLATILE]        = true;
        if(entry -> name == "final")        this -> modifier_bv [M_FINAL]           = true;
    }
}

symbol_table::symbol_table(){
    this -> scope = "";
    this -> name = "";
    this -> symbol_table_category = 'B';
}

void symbol_table::add_scope(symbol_table* st){
    this->sub_scopes++;
    st->scope = scope + "." + to_string(this->sub_scopes);
    st->parent_st = this;    // st is the child symbol table, this pointer gives the parent symbol table
}

void symbol_table::add_entry(st_entry* new_entry){
    for(auto (&entry) : entries){
        if(new_entry->name == entry->name){
            cout << "ERROR: Variable " << new_entry->name << " is already declared at line number " << entry->line_no << " in the same scope.\n";
            exit(1);
        }
    }
    entries.push_back(new_entry);
    new_entry -> table = this;
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
        if(entries[idx]->name == name){
            return entries[idx];
        }
    }
    
    if(this->parent_st){
        return this->parent_st->look_up(name);
    }

    return NULL;
}

symbol_table_func::symbol_table_func(string func_name, vector<st_entry* > (&params), string return_type){
    this->name = func_name;
    this->params = params;
    this->return_type = return_type;
    this->symbol_table_category = 'M';  
}

void symbol_table_func::add_entry(st_entry* new_entry) {
    for(const auto (&param) : params) {
        if(new_entry->name == param->name) {
            cout << "ERROR: Variable " << new_entry -> name << " is already declared at line number " << param->line_no << " as a formal parameter.\n";
            exit(1);
        }
    }

    for(const auto (&entry) : entries){
        if(new_entry -> name == entry -> name){
            cout << "ERROR: Variable " << new_entry -> name << " is already declared at line number " << entry -> line_no << " in the same scope.\n";
            exit(1);
        }
    }

    entries.push_back(new_entry);
    new_entry -> table = this;
}

void symbol_table_func::update_modifiers(vector<st_entry*> modifiers){
    for(auto entry : modifiers){
        if(entry -> name == "public")       this -> modifier_bv [M_PUBLIC]          = true;
        if(entry -> name == "private")      this -> modifier_bv [M_PRIVATE]         = true;
        if(entry -> name == "protected")    this -> modifier_bv [M_PROTECTED]       = true;
        if(entry -> name == "static")       this -> modifier_bv [M_STATIC]          = true;
        if(entry -> name == "abstract")     this -> modifier_bv [M_ABSTRACT]        = true;
        if(entry -> name == "native")       this -> modifier_bv [M_NATIVE]          = true;
        if(entry -> name == "synchronized") this -> modifier_bv [M_SYNCHRONIZED]    = true;
        if(entry -> name == "transient")    this -> modifier_bv [M_TRANSIENT]       = true;
        if(entry -> name == "volatile")     this -> modifier_bv [M_VOLATILE]        = true;
        if(entry -> name == "final")        this -> modifier_bv [M_FINAL]           = true;
    }
}

bool symbol_table_func::operator == (const symbol_table_func& other){
    if(this->name == other.name){
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

symbol_table_class::symbol_table_class(string class_name) {
    this -> name = class_name;
    this -> symbol_table_category = 'C';
}

void symbol_table_class::add_entry(symbol_table_func* new_func){
    for(auto (&func) : (this->member_funcs)){
        if((*func) == (*new_func)){
            cout << "ERROR: Function with name " << (new_func->name) << " and parameter tuple: (";
            for(int idx = 0; idx < new_func->params.size(); idx++){
                if(idx){
                    cout << ", " << (new_func->params)[idx]->type;
                }else{
                    cout << (new_func->params)[idx]->type;
                }
            }
            cout << ") already exists at line number: " << new_func -> params[0] -> line_no << "\n";
            exit(1);
        }
    }
    this->member_funcs.push_back(new_func);
}


// @TODO fix this function
symbol_table_func* symbol_table_class::look_up_function(string &name, vector<string> &params) {
    bool flag = false;
    for(ull idx = 0; idx < this -> member_funcs.size(); idx++) {
        if(name == member_funcs[idx] -> name && params.size() ) {
            flag = false;
            for(ull idx2 = 0; idx2 < params.size(); idx2++) {
                if(params[idx2] != member_funcs[idx] -> params[idx2] -> type) {
                    flag = true;
                    break;
                }
            }
        }

        if(!flag) {
            return member_funcs[idx];
        }
    }

    return NULL;
}

void symbol_table_class::update_modifiers(vector<st_entry*> modifiers){
    for(auto entry : modifiers){
        if(entry -> name == "public")       this -> modifier_bv [M_PUBLIC]          = true;
        if(entry -> name == "private")      this -> modifier_bv [M_PRIVATE]         = true;
        if(entry -> name == "protected")    this -> modifier_bv [M_PROTECTED]       = true;
        if(entry -> name == "static")       this -> modifier_bv [M_STATIC]          = true;
        if(entry -> name == "abstract")     this -> modifier_bv [M_ABSTRACT]        = true;
        if(entry -> name == "native")       this -> modifier_bv [M_NATIVE]          = true;
        if(entry -> name == "synchronized") this -> modifier_bv [M_SYNCHRONIZED]    = true;
        if(entry -> name == "transient")    this -> modifier_bv [M_TRANSIENT]       = true;
        if(entry -> name == "volatile")     this -> modifier_bv [M_VOLATILE]        = true;
        if(entry -> name == "final")        this -> modifier_bv [M_FINAL]           = true;
    }
}

symbol_table_global::symbol_table_global() {
    this -> name = "__GlobalSymbolTable__";
    this -> scope = "";
    this -> symbol_table_category = 'G';
    this -> parent_st = NULL;
}

void symbol_table_global::add_entry(symbol_table_class* new_cls) {
    for(auto &cls : this -> classes) {
        if(new_cls -> name == cls -> name) {
            cout << "ERROR: Duplicate class " << new_cls -> name << " at line number " << new_cls -> scope_start_line_no << endl;
            exit(1);
        }
    }

    this -> classes . push_back(new_cls);
}