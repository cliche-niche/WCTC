#ifndef TAC_HPP
#define TAC_HPP

#include <bits/stdc++.h>

using namespace std;

struct quad{
    string op;
    string arg1;
    string arg2;
    string result;
    string code = "";        // Construct from each node

    quad();
    quad(string r, string a1, string o, string a2);  // res = arg1 op arg2
    void make_code_from_binary();           // r = a1 op a2;
    void make_code_from_unary();            // r = op a1;
    void make_code_from_assignment();       // r = a1;
    void make_code_from_ifelse();           // IFFALSE a1 GOTO a2
    void make_code_from_goto();             // GOTO a1
};


#endif