#include <bits/stdc++.h>
#include "../include/global_vars.hpp" // Includes node.hpp
#include "../include/tac.hpp"
using namespace std;

quad::quad(string r, string a1, string o, string a2) : result(r), arg1(a1), op(o), arg2(a2) {}

void quad::make_code_from_binary(){
    code = "\t\t" + result + " = " + arg1 + " " + op + " " + arg2 + ";\n";
}

void quad::make_code_from_unary(){
    code = "\t\t" + result + " = " + op + "(" + arg1 + ");\n";
}

void quad::make_code_from_assignment(){
    code = "\t\t" + result + " = " + arg1 + ";\n";
}

void quad::make_code_from_cast(){
    code = "\t\t" + result + " = (" + op + ") " + arg1 + ";\n";
}

void quad::make_code_from_deref(){
    code = "\t\t" + result + " = *(" + arg1 + ");\n";
}

void quad::make_code_from_conditional(){
    jump = stoi(arg2.substr(1, arg2.size()-1));
    code = "\t\t" + op + " " + arg1 + " GOTO ";
}

void quad::make_code_from_func_call(){
    code = "\t\t" + op + " " + arg1 + ";\n";
}

void quad::make_code_from_goto(){
    jump = stoi(arg1.substr(1, arg1.size()-1));
    code = "\t\t" + op + " ";
}

void quad::make_code_from_param(){
    code = "\t\t" + op + " " + arg1 + ";\n";
}

void quad::check_jump(const int ins_line){
    if(jump){
        code += to_string(ins_line + jump) + ";\n"; 
    }
}

void quad::make_code_begin_func() {
    code = "\t\tbegin_func " + arg1 + "\n"; 
}

void quad::make_code_end_func() {
    code = "\t\tend_func\n";
}

void quad::make_code_from_return() {
    code = "\t\treturn " + arg1 + "\n";
}