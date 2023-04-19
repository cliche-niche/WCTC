#include <bits/stdc++.h>
#include "../include/x86.hpp"
#include "../include/global_vars.hpp"

using namespace std;

const int stack_offset = 8;

conversion::conversion(){;}

conversion::conversion(string op, string a1, string a2) : op(op), arg1(a1), arg2(a2) {
    code = "\t\t" + op + "\t" + arg1 + ",\t" + arg2;
}

vector<conversion> conversion::make_x86_code(quad q, int x, int y, int z){
    vector<conversion> conversions;
    conversion c;

    if(q.made_from == quad::BINARY){    // c = a op b
        // Load value of a into %rax
        c = conversion("mov", to_string(x) + "(%rbp)", "%rdx");
        conversions.push_back(c);

        if(q.op == "+"){    
            c = conversion("add", "%rax", "%rdx");
        }
        else if(q.op == "-"){
            c = conversion("sub", "%rax", "%rdx");
        }
        else if(q.op == "*"){
            c = conversion("mul", "%rax", "%rdx");
            
        }
        else if(q.op == "/"){
            c = conversion("div", "%rax", "%rdx");
            
        }
        else if(op == "%" || op == "<<" || op == ">>" || op == ">>>" || op == ">" || op == "<" || op == ">=" || op == "<=" || op == "==" || op == "!=" || op == "&" || op == "|" || op == "^" || op == "&&" || op == "||"){

        }
        conversions.push_back(c);
        
        c = conversion("mov", "%rdx", to_string(z) + "(%rsp)");
        conversions.push_back(c);
    }
}

subroutine_entry::subroutine_entry(string name, int offset) {
    this -> name = name;
    this -> offset = offset;
}

void conversion::process_subroutines() {
    vector<quad> subroutine_ins;
    for(quad q : root -> ta_codes) {
        subroutine_ins.push_back(q);
        if(q.made_from == quad::END_FUNC) {
            subroutine_table st;

            st.construct_subroutine_table(subroutine_ins);
            subroutine_ins.clear();
        }   
    }
}

bool subroutine_table::isVariable(string s) {   // if the first character is a digit, then it is a constant and not a variable
    return !(s[0] >= '0' && s[0] <= '9');
}

void subroutine_table::construct_subroutine_table(vector<quad> subroutine_ins) {
    int pop_cnt = 1;         // 1 8 byte space for the return address
    int local_offset = 6;    // 6 callee saved registers hence, 6 spaces kept free
    bool first_pop = true;
    
    for(quad q : subroutine_ins) {
        if(q.made_from == quad::POP_PARAM && first_pop) {
            pop_cnt++;

            this -> lookup_table[q.result] = subroutine_entry(q.result, stack_offset*pop_cnt);
        }
        else {
            first_pop = false;
            if(q.made_from == quad::CONDITIONAL) {
                if(this -> lookup_table.find(q.arg1) == this -> lookup_table.end() && isVariable(q.arg1)) {
                    this -> lookup_table[q.arg1] = subroutine_entry(q.arg1, -stack_offset*local_offset);
                    local_offset++;
                }
            }
            else if(q.made_from == quad::GOTO){
                continue;
            }
            else {
                if(q.arg1 != "" && this -> lookup_table.find(q.arg1) == this -> lookup_table.end() && isVariable(q.arg1)) {
                    this -> lookup_table[q.arg1] = subroutine_entry(q.arg1, -stack_offset*local_offset);
                    local_offset++;
                }
                else if(q.arg2 != "" && this -> lookup_table.find(q.arg2) == this -> lookup_table.end() && isVariable(q.arg2)) {
                    this -> lookup_table[q.arg2] = subroutine_entry(q.arg2, -stack_offset*local_offset);
                    local_offset++;
                }
                else if(q.result != "" && this -> lookup_table.find(q.result) == this -> lookup_table.end() && isVariable(q.result)) {
                    this -> lookup_table[q.result] = subroutine_entry(q.result, -stack_offset*local_offset);
                    local_offset++;
                }
            }
        }
    }
}