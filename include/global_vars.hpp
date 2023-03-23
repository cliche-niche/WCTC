#ifndef GLOBAL_VARS_HPP
#define GLOBAL_VARS_HPP

#include <bits/stdc++.h>
#include "symbol_table.hpp"
#include "node.hpp"
#include "tac.hpp"

extern unsigned long long int num_scopes;
extern "C" int yylineno;

extern symbol_table_global *main_table;

extern map<string, int> type_to_size;
extern set<string> primitive_types;

extern vector<quad> tacodes;

enum MODIFIER {
    M_PUBLIC,
    M_PRIVATE,
    M_PROTECTED,
    M_STATIC,
    M_ABSTRACT,
    M_NATIVE,
    M_SYNCHRONIZED,
    M_TRANSIENT,
    M_VOLATILE,
    M_FINAL,
    COUNT
};

extern node* root;     // contains the root node of the parse tree

#endif