#ifndef X86_HPP
#define X86_HPP

#include <bits/stdc++.h>
#include "tac.hpp"

using namespace std;

struct conversion{
    string op   = "";
    string arg1 = "";
    string arg2 = "";
    string code = "";

    conversion();
    conversion(string, string, string);
    void process_subroutines();
    vector<conversion> make_x86_code(quad, int, int, int);      // quad, offset of arg1, offset of arg2, offset of res
};

struct subroutine_table{
    string subroutine_name;
    map<string, subroutine_entry> lookup_table;

    void construct_subroutine_table(vector<quad> subroutine_ins);
    bool isVariable(string s);
};

struct subroutine_entry{
    string name;
    int offset;         // offset from the base pointer in subroutine

    subroutine_entry(string, int);
    // other entries may be added later
};

#endif