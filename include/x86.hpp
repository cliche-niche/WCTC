#ifndef X86_HPP
#define X86_HPP

#include <bits/stdc++.h>
#include "tac.hpp"

using namespace std;

struct instruction{
    string op = "";
    string arg1 = "";
    string arg2 = "";
    string arg3 = "";
    string code = "";
    string ins_type = "";

    string comment = "";

    instruction();
    instruction(string, string a1 = "", string a2 = "", string a3 = "", string it = "ins", string comment = "");
    // void gen_code();
};

struct subroutine_entry{
    string name = "";
    int offset = 0;         // offset from the base pointer in subroutine

    subroutine_entry();
    subroutine_entry(string, int);
    // other entries may be added later
};

struct subroutine_table{
    string subroutine_name;
    bool is_main_function = false;
    map<string, subroutine_entry> lookup_table;
    int total_space;
    int number_of_params = 0;

    subroutine_table();
    void construct_subroutine_table(vector<quad> subroutine_ins);
    bool isVariable(string s);
};

struct codegen {
    vector< vector<quad> > subroutines;
    vector<instruction> code;
    vector<subroutine_table* > sub_tables;
    // string code;
    
    codegen();
    void append_ins(instruction ins);
    void print_code(string asm_file = "asm.s");

    void get_tac_subroutines();                             // generates all the subroutines from the tac
    void gen_tac_basic_block(vector<quad>, subroutine_table*);      // generates all the basic blocks from subroutines
    
    bool isVariable(string s);
    bool isMainFunction(string s);
    string get_func_name(string s);          

    void gen_global();                                      // generates code for the global region
    void gen_text();                                        // generates code for the text region
    void gen_fixed_subroutines();                           // generates some fixed subroutines
    void gen_subroutine(vector<quad> subroutine);           // generates code for individual subroutines
    void gen_basic_block(vector<quad> BB, subroutine_table*);       // generates code for basic blocks
    vector<instruction> make_x86_code(quad, int x = 0, int y = 0, int z = 0);     // generates x86 for a single tac instruction
};


#endif