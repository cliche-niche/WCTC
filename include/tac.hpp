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
    int jump = 0;

    quad();
    quad(string r, string a1, string o, string a2);     // res = arg1 op arg2
    void make_code_from_binary();                       // r = a1 op a2;
    void make_code_from_unary();                        // r = op a1;
    void make_code_from_assignment();                   // r = a1;
    void make_code_from_conditional();                  // IFTRUE/FALSE a1 GOTO a2;
    void make_code_from_cast();                         // r = (a2) a1;
    void make_code_from_deref();                        // r = *(a1);
    void make_code_from_func_call();                    // push/popparam a1;
    void make_code_from_goto();                         // GOTO a1;
    void make_code_from_param();                        // push/popparam a1;
    void make_code_begin_func();                        // begin_func x;
    void make_code_end_func();                          // end_func;
    void make_code_from_return();                       // return a1;
    void check_jump(const int);
};


#endif