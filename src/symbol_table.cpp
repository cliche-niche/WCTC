#include <bits/stdc++.h>
#include "../include/global_vars.hpp"
#include "../include/symbol_table.hpp"

typedef unsigned long long ull;
using namespace std;

ull num_scopes = 0;
symbol_table_global *main_table = new symbol_table_global();

map<string, int> type_to_size = {
        {"byte", 1},
        {"short", 2},
        {"int", 8},
        {"long", 8},
        {"float", 4},
        {"double", 8},
        {"boolean", 1},
        {"char", 2},
        {"String", 4}
};

set<string> primitive_types = {
    "byte", "short", "int", "long", "float", "double", "boolean", "char", "String", "null"
};

const int address_size = 4;

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
    if(this -> size == 0) {
        this -> size = address_size;       // otherwise it's a reference and hence address_size bytes
    }
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

symbol_table::symbol_table(string name) {
    this -> scope = "";
    this -> name = name;
    this -> symbol_table_category = 'B';
}

void symbol_table::add_scope(symbol_table* st){
    this->sub_scopes++;
    st->scope = scope + "." + to_string(this->sub_scopes);
    st->parent_st = this;    // st is the child symbol table, this pointer gives the parent symbol table
}

void symbol_table::add_entry(st_entry* new_entry){
    for(int i = 0; i < new_entry -> dimensions; i++) {
        new_entry -> type += "[]";
    }
    new_entry -> update_type(new_entry -> type);

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

int symbol_table::get_localspace_size() {
    int space = 0;

    for(auto &entry : this -> entries) {
        space += entry -> size;
    }

    return space;
}

st_entry* symbol_table::look_up(string name){
    //! populate the global symbol table entry list with class names so that lookup here is possible !//
    if(this -> symbol_table_category == 'G') {
        return NULL;  // use main_table -> look_up_class() for these   
    }

    if(this -> symbol_table_category == 'M') {
        symbol_table_func* tmp = (symbol_table_func *) this;
        for(ull idx = 0; idx < tmp -> params.size(); idx++) {
            if(tmp -> params[idx]-> name == name) {
                return tmp -> params[idx];
            }
        } 
    }
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

    for(auto &param : params) {
        for(int i = 0; i < param -> dimensions; i++) {
            param -> type += "[]";
        }

        param -> update_type(param -> type); 
        param -> table = this;
    }

    this->params = params;
    this->return_type = return_type;
    this->symbol_table_category = 'M';  
}

void symbol_table_func::add_entry(st_entry* new_entry) {
    for(int i = 0; i < new_entry -> dimensions; i++) {
        new_entry -> type += "[]";
    }
    new_entry -> update_type(new_entry -> type);

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

void symbol_table_class::add_func(symbol_table_func* new_func){
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
            cout << ") already exists at line number: " << new_func -> scope_start_line_no << "\n";
            exit(1);
        }
    }
    this->member_funcs.push_back(new_func);
}

symbol_table_func* symbol_table_class::look_up_function(string &name, vector<string> &params) {
    bool flag = true;
    bool match_found = false;

    // first check for exact argument types
    for(auto &func : this -> member_funcs) {
        bool flag = true;
        if(func -> name == name && params.size() == func -> params.size()) {
            flag = false;
            for(int idx = 0; idx < params.size(); idx++) {
                if(params[idx] != func -> params[idx] -> type) {
                    flag = true;
                    break;
                }
            }
        }
        if(!flag) {
            match_found = true;
            return func;
        }
    }

    // now check for castable matching
    match_found = false;
    for(auto &func : this -> member_funcs) {
        bool flag = true;
        if(func -> name == name && params.size() == func -> params.size()) {
            flag = false;
            for(int idx = 0; idx < params.size(); idx++) {
                if((root -> get_datatype_category(params[idx]) == 'I' || root -> get_datatype_category(params[idx]) == 'D') && (root -> get_datatype_category(func -> params[idx] -> type) == 'I' || root -> get_datatype_category(func -> params[idx] -> type) == 'D')) {
                    if(root -> get_maxtype(params[idx], func -> params[idx] -> type) != func -> params[idx] -> type) {
                        flag = true;
                        break;
                    }
                }
                else {
                    if(params[idx] != func -> params[idx] -> type) {
                        flag = true;
                        break;
                    }
                }
            }
        }
        if(!flag) {
            match_found = true;
            return func;
        }
    }

    return NULL;    // if no match
}

int symbol_table_func::get_localspace_size() {
    int space = 0;
    for(auto &entry : this -> entries) {
        space += entry -> size;
    }

    for(auto &subscopes : this -> children_st) {
        space += subscopes -> get_localspace_size();
    }

    return space;
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

symbol_table_class* symbol_table_global::look_up_class(string cls_name) {
    for(auto &cls : this -> classes) {
        if(cls -> name == cls_name) {
            return cls;
        }
    }

    return NULL;
}

void symbol_table::make_csv(string filename) {
    ofstream out(filename, ios::app);
    
    out << "Scope, Name, Type, Line Number\n";
    for(auto &entry : this -> entries) {
        out << this -> scope << ", " <<  entry -> name << ", " << entry -> type << ", " << entry -> line_no << '\n'; 
    }

    out.close();
}

void symbol_table_func::make_csv(string filename) {
    ofstream out(filename, ios::app);
    
    out << "Scope, Formal Parameter Name, Formal Parameter Type, Line Number\n";
    for(auto &param : this -> params) {
        out << this -> scope << ", " << param -> name << ", " << param -> type << ", " << param -> line_no << '\n';
    }

    out << "Scope, Name, Type, Line Number\n";
    for(auto &entry : this -> entries) {
        out << this -> scope << ", " <<  entry -> name << ", " << entry -> type << ", " << entry -> line_no << '\n'; 
    }

    out.close();
}

void symbol_table_class::make_csv(string filename) {
    ofstream out(filename, ios::app);
    
    out << "Scope, Function Name, Return Type, Line Number\n";
    for(auto &func: this -> member_funcs) {
        string func_name = func -> name;
        func_name += "(";

        bool first = true;
        for(auto &param : func -> params) {
            func_name += (first ? "" : ", ");
            func_name += param -> type;
            first = false;
        }
        
        func_name += ")";

        out << this -> scope << ", " << func_name << ", " << func -> return_type << ", " << this -> scope_start_line_no << "\n";
    }

    out << "Scope, Field Name, Field Type, Line Number\n";
    for(auto &entry: this -> entries) {
        out << this -> scope << ", " <<  entry -> name << ", " << entry -> type << ", " << entry -> line_no << '\n';
    }

    out.close();
}

void symbol_table_global::make_csv(string filename) {
    ofstream out(filename, ios::app);

    out << "Scope, Class Name, Size, Line Number\n";
    for(auto &cls : this -> classes) {
        out << "Global, " << cls -> name << ", " << cls -> object_size << ", " << this -> scope_start_line_no << "\n";  
    }

    out.close();
}

void symbol_table::make_csv_wrapper(string filename) {
    string child_file;
    switch(this -> symbol_table_category) {
        case 'G': ((symbol_table_global *) this) -> make_csv(filename);
        break;
        case 'C': ((symbol_table_class *) this) -> make_csv(filename);
        break;
        case 'M': ((symbol_table_func *) this) -> make_csv(filename);
        break;
        case 'B': 
        default: ((symbol_table *) this) -> make_csv(filename);
        break;
    }

    for(auto &child : children_st) {
        child_file = filename.substr(0, filename.size()-4) + "_" + child -> name + ".csv";
        if(child -> symbol_table_category == 'G' || child -> symbol_table_category == 'C' || child -> symbol_table_category == 'M'){
            child -> make_csv_wrapper(child_file);
        }
        else{
            child -> make_csv_wrapper(filename);
        }
    }
}

void symbol_table_global::add_SysOutPln(){
    // MAKE PrintStream CLASS
    symbol_table_class *prnt;
    symbol_table_func *pln;
    prnt = new symbol_table_class("PrintStream");

    vector<st_entry *> empty_params;
    vector<st_entry *> only_string;
    only_string.push_back(new st_entry("message", -1, -1, "String"));
  
    pln = new symbol_table_func("println", empty_params, "void");
    prnt->add_func(pln);

    pln = new symbol_table_func("println", only_string, "void");
    prnt->add_func(pln);
        
    pln = new symbol_table_func("print", empty_params, "void");
    prnt->add_func(pln);

    pln = new symbol_table_func("print", only_string, "void");
    prnt->add_func(pln);

    // END PrintStream class
    
    // MAKE System class
    symbol_table_class *syst;
    st_entry *out;
    syst = new symbol_table_class("System");
    out = new st_entry("out", -1, -1, "PrintStream");
    syst -> entries.push_back(out);
    // END System class

    // ADD Dummy to simulate System
    symbol_table_class *sup;
    st_entry* dum;
    sup = new symbol_table_class("__SUPER__SYSTEM__");
    dum = new st_entry("System", -1, -1, "System");
    sup -> entries.push_back(dum);

    // ADD to Global Table
    main_table -> add_entry(syst);
    main_table -> add_entry(prnt);
    main_table -> add_entry(sup);
}