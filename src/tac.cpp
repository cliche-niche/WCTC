#include <bits/stdc++.h>
#include "../include/global_vars.hpp" // Includes node.hpp
#include "../include/tac.hpp"
using namespace std;

quad::quad(string r, string a1, string o, string a2) : result(r), arg1(a1), op(o), arg2(a2) {}

void quad::make_code_from_binary(){
    code += "\t\t" + result + " = " + arg1 + " " + op + " " + arg2 + ";\n";
}

void quad::make_code_from_unary(){
    code += "\t\t" + result + " = " + op + "(" + arg1 + ");\n";
}

void quad::make_code_from_assignment(){
    code += "\t\t" + result + " = " + arg1 + ";\n";
}

void quad::make_code_from_ifelse(){
    code += "\t\t" + op + " " + arg1 + " GOTO " + arg2 + ";\n";
}

void quad::make_code_from_goto(){
    code += "\t\t" + op + " " + arg1 + ";\n";
}