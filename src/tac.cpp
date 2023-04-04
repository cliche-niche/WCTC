#include <bits/stdc++.h>
#include "../include/global_vars.hpp" // Includes node.hpp
#include "../include/tac.hpp"
using namespace std;

quad::quad() {}
quad::quad(string r, string a1, string o, string a2) : result(r), arg1(a1), op(o), arg2(a2) {}

void quad::make_code_from_binary(){
    made_from = BINARY;
    code = "\t\t" + result + " = " + arg1 + " " + op + " " + arg2 + ";\n";
}

void quad::make_code_from_unary(){
    made_from = UNARY;
    code = "\t\t" + result + " = " + op + "(" + arg1 + ");\n";
}

void quad::make_code_from_assignment(){
    made_from = ASSIGNMENT;
    code = "\t\t" + result + " = " + arg1 + ";\n";
}

void quad::make_code_from_cast(){
    made_from = CAST;
    code = "\t\t" + result + " = (" + op + ") " + arg1 + ";\n";
}

void quad::make_code_from_store(){
    made_from = STORE;
    code = "\t\t*(" + result + ") = " + arg1 + ";\n";
}

void quad::make_code_from_load(){
    made_from = LOAD;
    code = "\t\t" + result + " = *(" + arg1 + ");\n";
}

void quad::make_code_from_conditional(){
    made_from = CONDITIONAL;
    rel_jump = stoi(arg2.substr(1, arg2.size()-1));
    code = "\t\t" + op + " " + arg1 + " goto ";
}

void quad::make_code_from_func_call(){
    made_from = FUNC_CALL;
    code = "\t\t" + op + " " + arg1 + ";\n";
}

void quad::make_code_from_goto(){
    made_from = GOTO;
    rel_jump = stoi(arg1.substr(1, arg1.size()-1));
    code = "\t\t" + op + " ";       // op is "GOTO"
}

void quad::make_code_from_param(){
    made_from = PARAM;
    code = "\t\t" + op + " " + arg1 + ";\n";
}

void quad::check_jump(const int ins_line){
    this->ins_line = ins_line;
    if(rel_jump){
        abs_jump = ins_line + rel_jump;
        code += to_string(abs_jump) + ";\n";
    }
}
    
void quad::make_code_begin_func() {
    made_from = BEGIN_FUNC;
    code = "\t\tbegin_func " + arg1 + "\n";
}

void quad::make_code_end_func() {
    made_from = END_FUNC;
    code = "\t\tend_func\n";
}

void quad::make_code_from_return() {
    made_from = RETURN;
    code = "\t\t" + op + " " + arg1 + ";\n"; // op is "return"
}

void quad::make_code_shift_pointer() {
    made_from = SHIFT_POINTER;
    code = "\t\tshift_pointer" + arg1 + "\n";
}
void quad::make_code_pop_param() {
    made_from = POP_PARAM;
    code = "\t\t" + arg1 + " = pop_param;\n";
}

void quad::make_code(){
    if(this -> made_from == BINARY){
        this -> make_code_from_binary();
    }
    else if(this -> made_from == UNARY){
        this -> make_code_from_unary();
    }
    else if(this -> made_from == ASSIGNMENT){
        this -> make_code_from_assignment();
    }
    else if(this -> made_from == CONDITIONAL){
        this -> make_code_from_conditional();
    }
    else if(this -> made_from == CAST){
        this -> make_code_from_cast();
    }
    else if(this -> made_from == STORE){
        this -> make_code_from_store();
    }
    else if(this -> made_from == LOAD){
        this -> make_code_from_load();
    }
    else if(this -> made_from == FUNC_CALL){
        this -> make_code_from_func_call();
    }
    else if(this -> made_from == GOTO){
        this -> make_code_from_goto();
    }
    else if(this -> made_from == PARAM){
        this -> make_code_from_param();
    }
    else if(this -> made_from == BEGIN_FUNC){
        this -> make_code_begin_func();
    }
    else if(this -> made_from == END_FUNC){
        this -> make_code_end_func();
    }
    else if(this -> made_from == RETURN){
        this -> make_code_from_return();
    }
    else if(this -> made_from == SHIFT_POINTER){
        this -> make_code_shift_pointer();
    }
    else if(this -> made_from == POP_PARAM) {
        this -> make_code_pop_param();
    }
}