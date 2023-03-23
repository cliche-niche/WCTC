#include <bits/stdc++.h>
#include "../include/global_vars.hpp" // Includes node.hpp
using namespace std;

int n_terms;

void quad::build_tac(node* v){
    if(v -> sym_tab_entry -> name == "Expression" && v -> children[0] -> type == "OPERATOR"){
        node* tmp = v -> children[0];
        string arg1 = tmp -> children[0] -> name, arg2 = tmp -> children[1] -> name;
        string op = tmp -> name, res = "t" + n_terms;
        n_terms++;
        tacodes.push_back(quad(tmp->line_no, arg1, arg2, op, res));
    }

    for(auto &child : v -> children) {
        build_tac(child);
    }
}