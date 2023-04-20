#include <bits/stdc++.h>
#include "../include/global_vars.hpp"

using namespace std;

const int stack_offset = 8;

instruction::instruction(){;}

instruction::instruction(string op, string a1, string a2, string a3, string it) : op(op), arg1(a1), arg2(a2), arg3(a3), ins_type(it) {
    if(it == "ins") {           // default instructions
        if(arg3 == "") {
            code = "\t\t" + op;
            if(arg1 != ""){
                code += "\t" + arg1;
            } 
            if(arg2 != ""){
                code += ",\t" + arg2;
            }

            code += '\n';
        }
        else {

        }
    }
    else if(it == "segment") {  // text segment, global segment
        code = "\t\t" + op + "\n";
    }
    else if(it == "label") {    // jump labels and subroutine labels
        code = arg1 + ":\n";
    }
    else {                      // other instruction types if used

    }
}

void instruction::gen_code(){
    if(ins_type == "ins") {           // default instructions
        if(arg3 == "") {
            code = "\t\t" + op + "\t" + arg1 + ",\t" + arg2 + '\n';
        }
        else {

        }
    }
    else if(ins_type == "segment") {  // text segment, global segment
        code = "\t\t" + op + "\n";
    }
    else if(ins_type == "label") {    // jump labels and subroutine labels
        code = arg1 + ":\n";
    }
    else {                      // other instruction types if used

    }
}

bool codegen::isVariable(string s) {   // if the first character is a digit/-/+, then it is a constant and not a variable
    return !(s[0] >= '0' && s[0] <= '9') && (s[0] != '-') && (s[0] != '+');
}

bool codegen::isMainFunction(string s) {
    string sub = "";
    for(int i = s.length() - 1; i >= 0; i--) {
        if(s[i] == '.' && i > 0 && s[i-1] == '.') {
            break;
        }
        else {
            sub += s[i];
        }
    }

    return sub == "][gnirtS.niam";
}

vector<instruction> codegen::make_x86_code(quad q, int x, int y, int z){
    vector<instruction> insts;
    instruction ins;

    if(q.is_target) {   // if this is a target, a label needs to be added
        ins = instruction("", "L." + to_string(q.ins_line), "", "", "label");
        insts.push_back(ins);
    }
    if(q.made_from == quad::BINARY){            // c(z) = a(x) op b(y)
        // Load value of a into %rax

        if(q.op == "+"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("add", "$" + q.arg2, "%rdx");
            }
            else{
                ins = instruction("add", to_string(y) + "(%rbp)", "%rdx");
            }
        }
        else if(q.op == "-"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("sub", "$" + q.arg2, "%rdx");
            }
            else{
                ins = instruction("sub", to_string(y) + "(%rbp)", "%rdx");
            }
        }
        else if(q.op == "*"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("imul", "$" + q.arg2, "%rdx");
            }
            else{
                ins = instruction("imul", to_string(y) + "(%rbp)", "%rdx");
            }
        }
        else if(q.op == "/"){
            if(!isVariable(q.arg1)){   // arg1 is a literal
                ins = instruction("mov", "$" + q.arg1, "%rdx");
                insts.push_back(ins);
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
                insts.push_back(ins);                
            }
            ins = instruction("cqto");
            insts.push_back(ins);

            if(!isVariable(q.arg2)){  // arg2 is a literal
                ins = instruction("mov", "$" + q.arg2, "%rbx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rbx");
            }
            ins = instruction("idiv", "%rbx", "");
            insts.push_back(ins);
            ins = instruction("mov", "%rax", "%rdx");
        }
        else if(q.op == "%"){
            if(!isVariable(q.arg1)){   // arg1 is a literal
                ins = instruction("mov", "$" + q.arg1, "%rdx");
                insts.push_back(ins);
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
                insts.push_back(ins);                
            }
            ins = instruction("cqto");
            insts.push_back(ins);

            if(!isVariable(q.arg2)){  // arg2 is a literal
                ins = instruction("mov", "$" + q.arg2, "%rbx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rbx");
            }
            ins = instruction("idiv", "%rbx", "");
        }
        else if(q.op == "<<"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rcx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rcx");
            }
            insts.push_back(ins);
            ins = instruction("sal", "%cl", "%rdx");
        }
        else if(q.op == ">>"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rcx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rcx");
            }
            insts.push_back(ins);
            ins = instruction("sar", "%cl", "%rdx");
        }
        else if(q.op == ">>>"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rcx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rcx");
            }
            insts.push_back(ins);
            ins = instruction("shr", "%cl", "%rdx");
        }
        else if(q.op == ">"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);

            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rcx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rcx");
            }
            insts.push_back(ins);
            ins = instruction("cmp", "%rdx", "%rcx");
            insts.push_back(ins);
            ins = instruction("jg", "1f");  // true
            insts.push_back(ins);
            ins = instruction("mov", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f"); // false
            insts.push_back(ins);
            ins = instruction("", "1", "", "", "label");
            insts.push_back(ins);
            ins = instruction("mov", "$1", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f");
            insts.push_back(ins);
            ins = instruction("", "2", "", "", "label");
        }
        else if(q.op == "<"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);

            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rcx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rcx");
            }
            insts.push_back(ins);
            ins = instruction("cmp", "%rdx", "%rcx");
            insts.push_back(ins);
            ins = instruction("jl", "1f");  // true
            insts.push_back(ins);
            ins = instruction("mov", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f"); // false
            insts.push_back(ins);
            ins = instruction("", "1", "", "", "label");
            insts.push_back(ins);
            ins = instruction("mov", "$1", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f");
            insts.push_back(ins);
            ins = instruction("", "2", "", "", "label");
        }
        else if(q.op == ">="){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);

            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rcx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rcx");
            }
            insts.push_back(ins);
            ins = instruction("cmp", "%rdx", "%rcx");
            insts.push_back(ins);
            ins = instruction("jge", "1f");  // true
            insts.push_back(ins);
            ins = instruction("mov", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f"); // false
            insts.push_back(ins);
            ins = instruction("", "1", "", "", "label");
            insts.push_back(ins);
            ins = instruction("mov", "$1", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f");
            insts.push_back(ins);
            ins = instruction("", "2", "", "", "label");
        }
        else if(q.op == "<="){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);

            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rcx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rcx");
            }
            insts.push_back(ins);
            ins = instruction("cmp", "%rdx", "%rcx");
            insts.push_back(ins);
            ins = instruction("jle", "1f");  // true
            insts.push_back(ins);
            ins = instruction("mov", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f"); // false
            insts.push_back(ins);
            ins = instruction("", "1", "", "", "label");
            insts.push_back(ins);
            ins = instruction("mov", "$1", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f");
            insts.push_back(ins);
            ins = instruction("", "2", "", "", "label");
        }
        else if(q.op == "=="){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);

            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rcx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rcx");
            }
            insts.push_back(ins);
            ins = instruction("cmp", "%rdx", "%rcx");
            insts.push_back(ins);
            ins = instruction("je", "1f");  // true
            insts.push_back(ins);
            ins = instruction("mov", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f"); // false
            insts.push_back(ins);
            ins = instruction("", "1", "", "", "label");
            insts.push_back(ins);
            ins = instruction("mov", "$1", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f");
            insts.push_back(ins);
            ins = instruction("", "2", "", "", "label");
        }
        else if(q.op == "!="){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);

            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rcx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rcx");
            }
            insts.push_back(ins);
            ins = instruction("cmp", "%rdx", "%rcx");
            insts.push_back(ins);
            ins = instruction("jne", "1f");  // true
            insts.push_back(ins);
            ins = instruction("mov", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f"); // false
            insts.push_back(ins);
            ins = instruction("", "1", "", "", "label");
            insts.push_back(ins);
            ins = instruction("mov", "$1", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f");
            insts.push_back(ins);
            ins = instruction("", "2", "", "", "label");
        }
        else if(q.op == "&"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("and", "$" + q.arg2, "%rdx");
            }
            else{
                ins = instruction("and", to_string(y) + "(%rbp)", "%rdx");
            }     
        }
        else if(q.op == "|"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("or", "$" + q.arg2, "%rdx");
            }
            else{
                ins = instruction("or", to_string(y) + "(%rbp)", "%rdx");
            }     
        }
        else if(q.op == "^"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("xor", "$" + q.arg2, "%rdx");
            }
            else{
                ins = instruction("xor", to_string(y) + "(%rbp)", "%rdx");
            }
        }
        else if(q.op == "&&"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            ins = instruction("cmp", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("je", "1f");
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rdx");
            }
            ins = instruction("cmp", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("je", "1f");
            insts.push_back(ins);
            ins = instruction("mov", "$1", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f");
            insts.push_back(ins);
            ins = instruction("", "1", "", "", "label");
            insts.push_back(ins);
            ins = instruction("mov", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("", "2", "", "", "label");
        }
        else if(q.op == "||"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            ins = instruction("cmp", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("jne", "1f");     // true
            insts.push_back(ins);
            if(!isVariable(q.arg2)){
                ins = instruction("mov", "$" + q.arg2, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(y) + "(%rbp)", "%rdx");
            }
            ins = instruction("cmp", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("jne", "1f");     // true
            insts.push_back(ins);
            ins = instruction("mov", "$0", "%rdx");
            insts.push_back(ins);
            ins = instruction("jmp", "2f");     // false
            insts.push_back(ins);
            ins = instruction("", "1", "", "", "label");
            insts.push_back(ins);
            ins = instruction("mov", "$1", "%rdx");
            insts.push_back(ins);
            ins = instruction("", "2", "", "", "label");
        }
        insts.push_back(ins);
        
        ins = instruction("mov", "%rdx", to_string(z) + "(%rbp)");
        insts.push_back(ins);
    }
    else if(q.made_from == quad::UNARY){        // b(y) = op a(x)
        if(q.op == "~"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            ins = instruction("neg", "%rdx", "");
        }
        else if(q.op == "!"){
            if(!isVariable(q.arg1)){
                ins = instruction("mov", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            }
            insts.push_back(ins);
            ins = instruction("not", "%rdx", "");
        }
        else if(q.op == "-"){
            ins = instruction("xor", "%rdx", "%rdx");
            insts.push_back(ins);
            if(!isVariable(q.arg1)){
                ins = instruction("sub", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("sub", to_string(x) + "(%rbp)", "%rdx");
            }
        }
        else if(q.op == "+"){
            ins = instruction("xor", "%rdx", "%rdx");
            insts.push_back(ins);
            if(!isVariable(q.arg1)){
                ins = instruction("add", "$" + q.arg1, "%rdx");
            }
            else{
                ins = instruction("add", to_string(x) + "(%rbp)", "%rdx");
            }
        }
        insts.push_back(ins);
        
        ins = instruction("mov", "%rdx", to_string(y) + "(%rbp)");
        insts.push_back(ins);
    }
    else if(q.made_from == quad::ASSIGNMENT){   // b(y) = a(x)
        if(!isVariable(q.arg1)){
            ins = instruction("mov", "$" + q.arg1, to_string(y) + "(%rbp)");
            insts.push_back(ins);
        }
        else{
            ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
            ins = instruction("mov", "%rdx", to_string(y) + "(%rbp)");
            insts.push_back(ins);
        }
    }
    else if(q.made_from == quad::CONDITIONAL){  // if_false/if_true(op) a(x) goto y
        if(!isVariable(q.arg1)){
            ins = instruction("mov", "$" + q.arg1, "%rdx");
        }
        else{
            ins = instruction("mov", to_string(x) + "(%rbp)", "%rdx");
        }
        ins = instruction("cmp", "$0", "%rdx");
        insts.push_back(ins);
        
        if(q.op == "if_false"){
            ins = instruction("je", "L." + to_string(y));
        }
        else if(q.op == "if_true"){
            ins = instruction("jne", "L." + to_string(y));
        }
        insts.push_back(ins);
    } 
    else if(q.made_from == quad::GOTO){         // goto (x)
        ins = instruction("jmp", "L." + to_string(x));
        insts.push_back(ins);
    }
    else if(q.made_from == quad::STORE){        // *(r)(y) = a1(x)
        if(!isVariable(q.arg1)){
            ins = instruction("mov", "$" + q.arg1, "%rax");
        }
        else{
            ins = instruction("mov", to_string(x) + "(%rbp)", "%rax");
        }
        insts.push_back(ins);
        ins = instruction("mov", to_string(y) + "(%rbp)", "%rdx");
        insts.push_back(ins);
        ins = instruction("mov", "%rax", "(%rdx)");
        insts.push_back(ins);
    }
    else if(q.made_from == quad::BEGIN_FUNC) {  // perform callee duties

        if(y == 1) {        // make start label if it is the main function
            ins = instruction("", "_start", "", "", "label");
            insts.push_back(ins);
        }

        ins = instruction("", q.arg1, "", "", "label");     // add label
        insts.push_back(ins);
        ins = instruction("pushq", "%rbp");      // old base pointer
        insts.push_back(ins);
        ins = instruction("lea", "8(%rsp)", "%rbp");    // shift base pointer to the base of the new activation frame
        insts.push_back(ins);
        ins = instruction("pushq", "%rbx");
        insts.push_back(ins);
        ins = instruction("pushq", "%rdi");
        insts.push_back(ins);
        ins = instruction("pushq", "%rsi");
        insts.push_back(ins);
        ins = instruction("pushq", "%r12");
        insts.push_back(ins);
        ins = instruction("pushq", "%r13");
        insts.push_back(ins);
        ins = instruction("pushq", "%r14");
        insts.push_back(ins);
        ins = instruction("pushq", "%r15");
        insts.push_back(ins);

        // shift stack pointer to make space for locals and temporaries
        ins = instruction("sub", "$" + to_string(x), "%rsp");
        insts.push_back(ins);
    }
    else if(q.made_from == quad::RETURN) {    // clean up activation record
        ins = instruction("add", "$" + to_string(x), "%rsp");   // delete all local and temporary variables
        insts.push_back(ins);
        
        ins = instruction("popq", "%r15");      // restore old register values
        insts.push_back(ins);
        ins = instruction("popq", "%r14");
        insts.push_back(ins);
        ins = instruction("popq", "%r13");
        insts.push_back(ins);
        ins = instruction("popq", "%r12");
        insts.push_back(ins);
        ins = instruction("popq", "%rsi");
        insts.push_back(ins);
        ins = instruction("popq", "%rdi");
        insts.push_back(ins);
        ins = instruction("popq", "%rbx");
        insts.push_back(ins);
        ins = instruction("popq", "%rbp");
        insts.push_back(ins);
        
        // rsp returned to original position, time to store return value and call ret
        if(q.arg1 != "") {
            if(!isVariable(q.arg1)) {
                ins = instruction("mov", "$" + q.arg1, "%rax");
            }
            else {
                ins = instruction("mov", to_string(y) + "(%rbp)", "rax");
            }
            insts.push_back(ins);
        }

        ins = instruction("ret");
        insts.push_back(ins);
    }
    else if(q.made_from == quad::END_FUNC) {
        if(x == 1) {        // if main function
            ins = instruction("mov", "$60", "%rax");
            insts.push_back(ins);
            ins = instruction("xor", "%rdi", "%rdi");
            insts.push_back(ins);
            ins = instruction("syscall");
            insts.push_back(ins);
        }
    }
    else if(q.made_from == quad::SHIFT_POINTER) {
        // no need to do anything really
    }
    else if(q.made_from == quad::FUNC_CALL) {
        if(x == 0) {        // if function is called without any parameters, we have yet to perform caller responsibilities
            ins = instruction("pushq", "%rax");
            insts.push_back(ins);
            ins = instruction("pushq", "%rcx");
            insts.push_back(ins);
            ins = instruction("pushq", "%rdx");
            insts.push_back(ins);
            ins = instruction("pushq", "%r8");
            insts.push_back(ins);
            ins = instruction("pushq", "%r9");
            insts.push_back(ins);
            ins = instruction("pushq", "%r10");
            insts.push_back(ins);
            ins = instruction("pushq", "%r11");
            insts.push_back(ins);
        }
        ins = instruction("call", q.arg1);      // call the function
        insts.push_back(ins);
        
        if(x > 0) {                             // pop the parameters
            ins = instruction("add", "$" + to_string(x*stack_offset), "%rsp");
        }
    }
    else if(q.made_from == quad::RETURN_VAL) {
        // move the return value stored in %rax to the required location
        if(q.arg1 != "") {      // if the function returns a value
            ins = instruction("mov", "%rax", to_string(x) + "%(rbp)");
            insts.push_back(ins);
        }

        // restore original state of registers
        ins = instruction("popq", "%r11");
        insts.push_back(ins);
        ins = instruction("popq", "%r10");
        insts.push_back(ins);
        ins = instruction("popq", "%r9");
        insts.push_back(ins);
        ins = instruction("popq", "%r8");
        insts.push_back(ins);
        ins = instruction("popq", "%rdx");
        insts.push_back(ins);
        ins = instruction("popq", "%rcx");
        insts.push_back(ins);
        ins = instruction("popq", "%rax");
        insts.push_back(ins);
    }
    // CAST,
    // STORE,
    // LOAD,
    else if(q.made_from == quad::PUSH_PARAM){   // pushq a(x) || pushq const
        if(y == 1) {        // first parameter, perform caller saved registers
            ins = instruction("pushq", "%rax");
            insts.push_back(ins);
            ins = instruction("pushq", "%rcx");
            insts.push_back(ins);
            ins = instruction("pushq", "%rdx");
            insts.push_back(ins);
            ins = instruction("pushq", "%r8");
            insts.push_back(ins);
            ins = instruction("pushq", "%r9");
            insts.push_back(ins);
            ins = instruction("pushq", "%r10");
            insts.push_back(ins);
            ins = instruction("pushq", "%r11");
            insts.push_back(ins);
        }
        if(!isVariable(q.arg1)) {  // it is just a constant
            ins = instruction("pushq", "$" + q.arg1, "");
            insts.push_back(ins);
        } 
        else {
            ins = instruction("pushq", to_string(x) + "(%rbp)"); // load rbp + x
            insts.push_back(ins);    
        }
    }

    return insts;
}

codegen::codegen() {        // initialize the data members
    code.clear();
    subroutines.clear();
}

void codegen::append_ins(instruction ins) {
    this -> code . push_back(ins);
}

void codegen::get_tac_subroutines() {
    vector<quad> subroutine;

    for(quad q : root -> ta_codes) {
        subroutine.push_back(q);
        if(q.made_from == quad::END_FUNC) {
            this -> subroutines.push_back(subroutine);

            subroutine.clear();
        }
    }
}

void codegen::gen_global() {
    // @TODO
    instruction ins;
    ins = instruction(".global", "", "", "", "segment");
    this -> code.push_back(ins);

    ins = instruction("", "_start", "");
    this -> code.push_back(ins);
}

void codegen::gen_basic_block(vector<quad> BB, subroutine_table* sub_table) {
    for(quad q : BB) {
        vector<instruction> insts;
        if(q.made_from == quad::CONDITIONAL){
            int x = sub_table -> lookup_table[q.arg1].offset;
            int y = q.abs_jump;
            insts = this -> make_x86_code(q, x, y);
        }
        else if(q.made_from == quad::GOTO){
            insts = this -> make_x86_code(q, q.abs_jump);
        }
        else if(q.made_from == quad::BINARY){
            int z = sub_table -> lookup_table[q.result].offset;
            int x = sub_table -> lookup_table[q.arg1].offset;
            int y = sub_table -> lookup_table[q.arg2].offset;
            insts = this -> make_x86_code(q, x, y, z);            
        }
        else if(q.made_from == quad::UNARY){    // b(y) = op a(x)
            int y = sub_table -> lookup_table[q.result].offset;
            int x = sub_table -> lookup_table[q.arg1].offset;
            insts = this -> make_x86_code(q, x, y);           
        }
        else if(q.made_from == quad::ASSIGNMENT){   // b(y) = a(x)
            int y = sub_table -> lookup_table[q.result].offset;
            int x = sub_table -> lookup_table[q.arg1].offset;
            insts = this -> make_x86_code(q, x, y);                
        }
        else if(q.made_from == quad::STORE){
            int x = sub_table -> lookup_table[q.arg1].offset;
            int y = sub_table -> lookup_table[q.result].offset;
            insts = this -> make_x86_code(q, x, y);
        }
        /*
        CAST,
        STORE,
        LOAD,
        POP PARAM
        */
        else if(q.made_from == quad::PUSH_PARAM){   // push_param a1(x)
            int x = sub_table -> lookup_table[q.arg1].offset;
            sub_table -> number_of_params++;
            insts = this -> make_x86_code(q, x, sub_table -> number_of_params);
        }
        else if(q.made_from == quad::POP_PARAM){   // r(x) = pop_param
            // no need to do anything really

            insts = this -> make_x86_code(q);
        }
        else if(q.made_from == quad::FUNC_CALL) {
            insts = this -> make_x86_code(q, sub_table -> number_of_params);
            sub_table -> number_of_params = 0;          // reset variable
        }
        else if(q.made_from == quad::RETURN_VAL) {
            insts = this -> make_x86_code(q, sub_table -> lookup_table[q.arg1].offset);
        }
        else if(q.made_from == quad::BEGIN_FUNC) {  // manage callee saved registers
            if(isMainFunction(q.arg1)) {
                sub_table -> is_main_function = true;
            }
            insts = this -> make_x86_code(q, sub_table -> total_space - 9*stack_offset, sub_table -> is_main_function);        // space of 9 registers is not considered
        }
        else if(q.made_from == quad::END_FUNC) {    // no need to do anything really
            insts = this -> make_x86_code(q, 1);
        }
        else if(q.made_from == quad::SHIFT_POINTER) {       // no need to do anything really
            insts = this -> make_x86_code(q);
        }
        else if(q.made_from == quad::RETURN) {     // clean up activation record
            insts = this -> make_x86_code(q, sub_table -> total_space - 9*stack_offset, sub_table -> lookup_table[q.arg1].offset);
        }
        else{
            insts = this -> make_x86_code(q);
        }

        // append all the instructions finally
        for(instruction ins : insts) {
            this -> append_ins(ins);
        }
    }
}

void codegen::gen_tac_basic_block(vector<quad> subroutine, subroutine_table* sub_table) {    // generates basic blocks from subroutines
    set<int> leaders;
    vector<quad > BB;

    int base_offset = subroutine[0].ins_line;
    leaders.insert(base_offset);

    for(quad q : subroutine) {
        if(q.made_from == quad::CONDITIONAL || q.made_from == quad::GOTO) {
            leaders.insert(q.abs_jump);
            leaders.insert(q.ins_line + 1);
        }
        else if(q.made_from == quad::FUNC_CALL) {
            leaders.insert(q.ins_line);
            leaders.insert(q.ins_line + 1); // call func is made of a singular basic block
        }
    }

    vector<int> ascending_leaders;
    for(int leader : leaders) { 
        ascending_leaders.push_back(leader); 
    }
    
    int prev_leader = ascending_leaders[0];
    for(int i = 1; i < ascending_leaders.size(); i++) {
        BB.clear();
        
        for(int j = prev_leader; j < ascending_leaders[i]; j++) {
            BB.push_back(subroutine[j - base_offset]);
        }
        prev_leader = ascending_leaders[i];

        this -> gen_basic_block(BB, sub_table);
    }

    BB.clear();
    int final_leader = ascending_leaders[ascending_leaders.size() - 1];
    for(int i = final_leader; i - base_offset < subroutine.size(); i++) {
        BB.push_back(subroutine[i - base_offset]);
    }

    this -> gen_basic_block(BB, sub_table);
}

void codegen::gen_text() {
    this -> get_tac_subroutines();      // get the subroutines from entire TAC
    instruction ins(".text", "", "", "", "segment");
    this -> code.push_back(ins);

    for(auto subroutine : this -> subroutines) {
        subroutine_table* sub_table = new subroutine_table();
        sub_table -> construct_subroutine_table(subroutine);

        this -> sub_tables .push_back(sub_table);

        // for(auto i : sub_table -> lookup_table){
        //     cout << i.first << ' ' << i.second.name << " " << i.second.offset << endl;
        // }
        // cout << endl;

        this -> gen_tac_basic_block(subroutine, sub_table);
    }
}

void codegen::print_code() {
    for(auto ins : this -> code) {
        cout << ins.code;
    }
}

subroutine_entry::subroutine_entry(){;}

subroutine_entry::subroutine_entry(string name, int offset) {
    this -> name = name;
    this -> offset = offset;
}

subroutine_table::subroutine_table(){;}

bool subroutine_table::isVariable(string s) {   // if the first character is a digit/-/+, then it is a constant and not a variable
    return !(s[0] >= '0' && s[0] <= '9') && (s[0] != '-') && (s[0] != '+');
}

void subroutine_table::construct_subroutine_table(vector<quad> subroutine_ins) {
    int pop_cnt = 2;         // 1 8 byte space for the return address + old base pointer
    int local_offset = 9;    // 8 callee saved registers hence, 8 spaces kept free, rsp shall automatically be restored
    
    for(quad q : subroutine_ins) {
        if(q.made_from == quad::BEGIN_FUNC || q.made_from == quad::SHIFT_POINTER || q.made_from == quad::FUNC_CALL) {   // No nested procedures
            continue; 
        }
         
        if(q.made_from == quad::POP_PARAM) {
            this -> lookup_table[q.result] = subroutine_entry(q.result, stack_offset*pop_cnt);
            pop_cnt++;
        }
        else {
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

    this -> total_space = stack_offset * local_offset;   // total space occupied by callee saved registers + locals + temporaries
}