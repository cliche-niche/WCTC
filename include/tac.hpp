#ifndef TAC_HPP
#define TAC_HPP

#include <bits/stdc++.h>
#include "symbol_table.hpp"
#include "node.hpp"

using namespace std;

extern symbol_table_global *main_table;

struct quad{
    int line_no;
    string op;
    string arg1;
    string arg2;
    string result;
    string stmt = to_string(line_no);

    quad();
    quad(int line_no, string op, string arg1, string arg2, string result);  // res = arg1 op arg2

    void build_tac(node *v);
};


#endif