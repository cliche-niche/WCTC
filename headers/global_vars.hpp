#ifndef GLOBAL_VARS_HPP
#define GLOBAL_VARS_HPP

#include <bits/stdc++.h>
#include "symbol_table.hpp"
#include "node.hpp"

extern unsigned long long int num_scopes;
extern vector<symbol_table_class> main_table;

extern map<string, int> type_to_size; /*= {
        {"byte", 1},
        {"short", 2},
        {"int", 4},
        {"long", 8},
        {"float", 4},
        {"double", 8},
        {"boolean", 1},
        {"char", 2}
};*/

extern node* root;     // contains the root node of the parse tree

#endif