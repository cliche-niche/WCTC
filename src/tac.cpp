#include <bits/stdc++.h>
#include "../include/global_vars.hpp" // Includes node.hpp
#include "../include/tac.hpp"
using namespace std;

quad::quad(string r, string a1, string o, string a2, string l) : result(r), arg1(a1), op(o), arg2(a2), label(l) {}

void quad::make_code_from_binary(){
    if(label != ""){
        code += label + ":\n";
    }
    code += "\t\t" + result + " = " + arg1 + " " + op + " " + arg2 + ";\n";
}

void quad::make_code_from_unary(){
    if(label != ""){
        code += label + ":\n";
    }
    code += "\t\t" + result + " = " + op + "(" + arg1 + ");\n";
}

void quad::make_code_from_assignment(){
    if(label != ""){
        code += label + ":\n";
    }
    code += "\t\t" + result + " = " + arg1 + ";\n";
}

void quad::make_code_from_ifelse(){
    if(label != ""){
        code += label + ":\n";
    }
    code += "\t\t" + op + " " + arg1 + " GOTO " + arg2 + ";\n";
}

void quad::make_code_from_goto(){
    if(label != ""){
        code += label + ":\n";
    }
    code += "\t\t" + op + " " + arg1 + ";\n";
}