#include <bits/stdc++.h>
#include "../include/global_vars.hpp" // Includes node.hpp
using namespace std;

node *root;

node::node(string name /*= ""*/, bool terminal /*= false*/, string type /* = "" */, node* parent /* = NULL */){
    this->parent = parent;
    this->name = name;
    this->terminal = terminal;
    this->type = type;
}

void node::print_tree(int tab){
    for(int i=0; i<tab; i++){
        cout<<'\t';
    }
    cout<<(this->name)<<"-> ";
    for(auto i: (this->children)){
        cout<<(i->name)<<' ';
    }
    cout<<'\n';
    tab++;
    for(auto i: (this->children)){
        i->print_tree(tab);
    }
}

void node::clean_tree(){  

    // Removing semicolon (and other?) delimiters
    this->remove_lexeme_policy(";");

    // * Cleans the Parse tree to make an AST; Should necessarily be called from the root.
    // * Removing Nodes with a single child; Replaces them with the child
    node* v = NULL;
    for(int x = 0; x < (this->children).size(); x++){
        v = ((this->children)[x])->one_child_policy(x);
        if(v){
            delete v;
            x--;
        }
    }
    
    // * Bring operators above
    this->expression_policy();
}

void node::remove_lexeme_policy(string lex) {
    for(int x = 0; x < (this->children).size(); x++) {
        node *tmp = (this -> children)[x];
        if(tmp->name == lex) {
            (this->children).erase((this->children).begin() + x, (this->children).begin() + x + 1);  
            delete tmp;
            x--;
        }
        else {
            tmp->remove_lexeme_policy(lex);
        }
    }
}

node* node::one_child_policy(int idx){     
    // Ensures that each Node in the AST with one child is replaced by the child; deletes the parent afterwards
    // idx is the index of the current node in its parent's list. The node's child shall occupy this index after killing its parent
    if(this->parent == NULL) {
        cout << "ERROR: Only call one_child_policy from root! Aborting..." << endl;
        exit(1);
    }
    if((this->children).size() == 1){
        if(this->name != "Expression" && this->name != "VariableDeclarator" && this->name != "Assignment"){
            this->kill_parent(idx);
            return this;
        }else{
            node* v = NULL;
            while((this->children).size() == 1){
                v = (this->children)[0]->one_child_policy(0);
                if(v){
                    delete v;
                }else{
                    break;
                }
            }
        }
    }else{
        node* v = NULL;
        for(int x = 0; x < (this->children).size(); x++){
            v = ((this->children)[x])->one_child_policy(x);
            if(v){
                delete v;
                x--;
            }
        }
    }
    return NULL;
}

void node::kill_parent(int idx, int child_idx /*= 0*/){
    node* child = this->children[child_idx];
    child->parent = this->parent;
    ((child->parent)->children)[idx] = child;
}

void node::expression_policy(){
    if(this->exp_applicable){            
        if((this->children).size() == 2) {
            node* child = (this->children)[0];
            if(this->name == "Expression" || this->name == "Assignment"){
                child->add_child((this->children)[1]);
                this->children.clear();
                this->add_child(child);
            }else{
                this->copy(*child);
                (this->children).erase((this->children).begin() + 0, (this->children).begin() + 1);  
                delete child;
            }
            
            // this->name = child->name;
            // this->type = child->type;
            // this->terminal = child->terminal;
            // this->exp_applicable = child->exp_applicable;
            // (this->children).erase((this->children).begin(), (this->children).begin() + 1);  
        } else if((this->children).size() == 3){
            node* child = (this->children)[1];
            if(this->name == "Expression" || this->name == "Assignment"){
                child->add_child((this->children)[0]);
                child->add_child((this->children)[2]);
                this->children.clear();
                this->add_child(child);
            }else{
                this->copy(*child);
                (this->children).erase((this->children).begin() + 1, (this->children).begin() + 2);  
                delete child;
            }
            // this->name = child->name;
            // this->type = child->type;
            // this->terminal = child->terminal;
            // this->exp_applicable = child->exp_applicable;
            // (this->children).erase((this->children).begin() + 1, (this->children).begin() + 2);  
            // delete child;
        } else if((this->children).size() == 5){
            if(this->name == "Expression" || this->name == "Assignment"){
                node* child = new node("?:", true, "OPERATOR");
                child->add_child(this->children[0]);
                child->add_child(this->children[2]);
                child->add_child(this->children[4]);
                delete this->children[1];
                delete this->children[3];
                this->children.clear();
                this->add_child(child);
            }else{
                node* child;
                child = (this->children)[1];
                this->name = "?:";
                this->type = "OPERATOR";
                this->terminal = child->terminal;
                this->exp_applicable = child->exp_applicable;
                child = (this->children)[3];
                (this->children).erase((this->children).begin() + 3, (this->children).begin() + 4);  
                delete child;
                child = (this->children)[1];
                (this->children).erase((this->children).begin() + 1, (this->children).begin() + 2);  
                delete child;
            }
        }
    }

    for(int x = 0; x < (this->children).size(); x++) {
        (this->children)[x] -> expression_policy();
    }
}

void node::make_dot(string filename /*= "tree.gv"*/){
    unsigned long long node_num = 0;

    string dot_code = "digraph ast {\n";
    this->add_nodes(node_num, dot_code);
    dot_code += '\n';
    this->add_edges(dot_code);
    dot_code += "}";

    ofstream out(filename);
    out<<dot_code;
    out.close();
}

void node::add_nodes(unsigned long long (&node_num), string (&dot_code)){
    node_num++;
    this->node_number = node_num;
    
    if(this->terminal){
        dot_code += "node" + to_string(this->node_number) + "[label = \"" + this->type + '\n' + this->name + "\", shape = rectangle, color = ";
        if(this->type == "ID"){
            dot_code += "purple";
        }else if(this->type == "OPERATOR" || this->type == "OP_ASSIGNMENT"){
            dot_code += "green";
        }else if(this->type == "KEYWORD"){
            dot_code += "blue";
        }else if(this->type == "DELIMITER"){
            dot_code += "red";
        }else{
            dot_code += "red";
        }
        dot_code += "];\n";
    }else{
        dot_code += "node" + to_string(this->node_number) + "[label = \"" + this->name + "\"];\n";
    }

    for(auto child : (this->children)){
        child->add_nodes(node_num, dot_code);
    }
}

void node::add_edges(string (&dot_code)){
    for(auto child : (this->children)){
        dot_code += "node" + to_string(this->node_number) + " -> " + "node" + to_string(child->node_number) + ";\n";
        child->add_edges(dot_code);
    }
}

void node::add_child(node* child) {
    if(!child) return;
    child->parent = this;
    this->children.push_back(child);
}

string node::get_name(node* v){
    // Only for UnannType-like nodes
    if(v->name == "Name" || (v->type == "ID" && v->terminal)){
        // For Name-like nodes
        if(v->children.size() == 3){
            return get_name(v->children[0]) + "." + (v->children[2]->name);
        }else if(v->children.size() == 0){
            return (v->name);
        }
    }else if(v->terminal || v->children.size() == 1){
        // For PrimitiveType-like nodes
        while(v->terminal == false){
            v = v->children[0];
        }
        return (v->name);
    }
    return "ERROR.\n";
}

int node::get_dims(node* v){
    // Only for qDims-like nodes
    if(v){
        if(v->name == "qDims"){
            return get_dims(v->children[0]);
        }else if(v->name == "Dims"){
            if(v->children.size() == 2){
                return 1;
            }else if(v->children.size() == 3){
                return 1 + get_dims(v->children[2]);
            }
        }
        else if(v->name == "DimExprs"){
            if(v->children.size()==1){
                return get_dims(v->children[0]);
            }
            else{
                return get_dims(v->children[0]) + get_dims(v->children[1]);
            }
        }
        else if(v->name == "DimExpr"){
            return 1;
        }

    }
    return 0;
}

symbol_table* node::get_symbol_table() {
    node* temp_node = this -> parent;
    while(temp_node && !(temp_node -> sym_tab)){
        temp_node = temp_node->parent;
    }
    if(temp_node == NULL) {
        return NULL;
    }
    if(temp_node -> sym_tab -> symbol_table_category == 'G') {  // if it is a global symbol table, it must have been called from a symbol_table_class
        ((symbol_table_global *) temp_node -> sym_tab) -> add_entry((symbol_table_class*) this -> sym_tab);
    }
    if(this -> name == "MethodDeclaration") {
        if(this -> sym_tab_entry -> name == temp_node -> sym_tab -> name) {
            cout << "ERROR: Constructor cannot have a return type at line number: " << this -> sym_tab_entry -> line_no << endl;
            exit(1);
        }
        ((symbol_table_class*) temp_node -> sym_tab) -> add_entry((symbol_table_func*) this -> sym_tab);
    }
    else if(this -> name == "ConstructorDeclaration") {
        if(!(this -> sym_tab_entry -> name == temp_node -> sym_tab -> name)) {
            cout << "ERROR: Constructor name does not match simple class name at line number: " << this -> sym_tab_entry -> line_no << endl;
            exit(1);
        }

        ((symbol_table_class*) temp_node -> sym_tab) -> add_entry((symbol_table_func*) this -> sym_tab);
    }
    if (/*temp_node -> name == "BasicForStatement" ||
        temp_node -> name == "BasicForStatementNoShortIf" || 
        temp_node -> name == "EnhancedForStatement" || 
        temp_node -> name == "EnhancedForStatementNoShortIf" ||*/
        temp_node -> name == "MethodDeclaration" ) {
        this -> sym_tab = temp_node -> sym_tab;
        return NULL;    
    }
    return (temp_node -> sym_tab);
}

// WALK 1
void node::create_scope_hierarchy() {
    if(this -> sym_tab) {
        symbol_table* temp_st = this -> get_symbol_table();
        if(temp_st) { 
            this -> sym_tab -> parent_st = temp_st;
            temp_st -> children_st . push_back(this -> sym_tab);
            (temp_st -> sub_scopes)++;
            this->sym_tab->scope = ((temp_st->scope != "") ? temp_st->scope + "/" : "") + (this->sym_tab->name) + "#" + to_string(temp_st->sub_scopes);
            
            // cout << "Current scope: " << this -> sym_tab -> scope << endl;
            // cout << "Parent scope: " << temp_st -> scope << endl; 
        }    
    }

    for(auto &child : this -> children) {
        child->create_scope_hierarchy();
    }
}

// WALK 2

void node::validate_expression() {
    if(this->type == "ID"){
        symbol_table *cnt_table = this -> get_symbol_table();
        if(!cnt_table) {
            cout << "Unknown error, symbol table not found! Aborting..." << endl;
            exit(1);
        }

        if(this -> parent && this -> parent -> name == "MethodInvocation") {    // If the identifier is a method
            while(cnt_table -> symbol_table_category != 'C') {
                cnt_table = cnt_table -> parent_st;
            }

            bool flag = false;
            for(auto &funcs : ((symbol_table_class *) cnt_table) -> member_funcs) {
                if(funcs -> name == this -> name) {
                    flag = true;
                    break;
                }
            }

            if(!flag) {
                cout << "ERROR: Unknown method identifier " << this -> name << " at line number " << endl;
                exit(1);
            }
        }
        else if(this -> parent && this -> parent -> name == "UnqualifiedClassInstanceCreationExpression") { // If the identifier is a constructor
            // // Verification of this will be done in the third walk (type checking walking)
            node *tmp1 = this -> parent, *tmp2;
            if(tmp1 -> parent && tmp1 -> parent -> name == "Expression" && tmp1 -> parent -> parent && tmp1 -> parent -> parent -> name == "="){
                tmp1 = tmp1 -> parent -> parent;
                if(tmp1 -> children.size() == 1){
                    if(tmp1 -> parent && tmp1 -> parent -> name == "VariableDeclarator"){
                        tmp1 = tmp1 -> parent;
                        if(tmp1 -> sym_tab_entry -> type == this -> name){
                            tmp1 -> sym_tab_entry -> initialized = true;
                        }else{
                            cout<<"Error: Conflicting types for object \"" << tmp1 -> sym_tab_entry -> name <<"\": " << tmp1 -> sym_tab_entry -> type << " & " << this -> name << " at line number " << tmp1 -> sym_tab_entry -> line_no << endl;
                            exit(1);
                        }
                    }
                }
                else if(tmp1 -> children.size() == 2){
                    tmp2 = tmp1 -> children[0];
                    symbol_table *cnt_table = this -> get_symbol_table();
                    if(!cnt_table) {
                        cout << "Unknown error, symbol table not found! Aborting..." << endl;
                        exit(1);
                    }
                    
                    st_entry* tmp = cnt_table -> look_up(tmp2 -> name); // look up the identifier in the symbol table

                    if(!tmp) {
                        cout << "ERROR: Unknown identifier " << tmp2 -> name << " at line number " << endl;
                        exit(1);
                    }
                    else{
                        if(this -> name == tmp -> type){
                            tmp -> initialized = true;
                        }else{
                            cout << "Error: Conflicting types for the object \"" << tmp -> name << "\": " << tmp -> type << " (Line No. " << tmp -> line_no << ") & " << this -> name << endl;
                            exit(1);
                        }  
                    }
                }
            }
        }
        else {    // Identifier is a variable
            st_entry* tmp = cnt_table -> look_up(this -> name); // look up the identifier in the symbol table
            if(!tmp) {
                cout << "ERROR: Unknown identifier " << this -> name << " at line number " << endl;
                exit(1);
            }
            else {
                if(!(tmp -> initialized)) {
                    cout << "ERROR: Variable " << tmp -> name << " has not been initialized at line number " << tmp -> line_no << endl;
                    exit(1);
                }
            }
        }
    }
    else if(this -> name == "=" && this -> children.size() >= 1 && this -> children[0] -> type == "ID") { // initialization expression inside expressions 
        bool first_child = true;

        for(auto &child : this -> children){
            if(first_child){
                first_child = false;
            }else{
                child -> validate_expression();
            }
        }

        symbol_table *cnt_table = this -> get_symbol_table();
        if(!cnt_table) {
            cout << "Unknown error, symbol table not found! Aborting..." << endl;
            exit(1);
        }
        
        st_entry* tmp = cnt_table -> look_up(this -> children[0] -> name); // look up the identifier in the symbol table

        if(!tmp) {
            cout << "ERROR: Unknown identifier " << this -> children[0] -> name << " at line number " << endl;
            exit(1);
        }
        else {
            tmp -> initialized = true;
            return;     // validate_expression already called on the second child of "=" hence need not be called     
        }
    }
    
    if(this -> name == "Expression" && this -> children[0] -> name == "ArrayCreationExpression" && this -> parent -> children.size() > 1){
        auto array = this -> parent -> children[0];
        if(array){
            symbol_table* cnt_table = this -> get_symbol_table();
            if(!cnt_table) {
                cout << "Unknown error, symbol table not found! Aborting..." << endl;
                exit(1);
            }

            st_entry* tmp = cnt_table -> look_up(array -> name);
            if(!tmp) {
                cout << "Unknown array identifier " << array -> name << " found at line number " << endl; 
            }
            else {
                if(tmp -> dimensions == this -> children[0] -> sym_tab_entry -> dimensions){
                    tmp -> initialized = true;
                }
                else{
                    cout << "ERROR: Dimensions do not match for array " << tmp -> name << " declared at line number " << tmp -> line_no << '\n'; 
                    exit(1);
                }
            }
        }else{
            cout << "Unknown error occurred...\n";
            exit(1);
        }
    }

    if(this -> type == "OPERATOR" && this -> name == "="){
        if(this -> children.size() && this -> children[0] -> name == "Expression"){
            node* tmp1 = this -> children[0];
            if(tmp1 -> children.size() == 1 && tmp1 -> children[0] -> name == "ArrayCreationExpression"){
                tmp1 = tmp1 -> children[0];
                node* tmp2 = this;
                if(tmp2 -> parent -> name == "VariableDeclarator"){
                    tmp2 = tmp2 -> parent;
                    if(tmp2 -> children.size() > 1 && tmp2 -> children[tmp2 -> children.size()-2] -> name == "VariableDeclaratorId"){
                        tmp2 = tmp2 -> children[tmp2 -> children.size()-2];
                        if(tmp2 -> children[0] -> type == "ID"){
                            tmp2 = tmp2 -> children[0];
                            
                            symbol_table* cnt_table = this -> get_symbol_table();
                            if(!cnt_table) {
                                cout << "Unknown error, symbol table not found! Aborting..." << endl;
                                exit(1);
                            }

                            st_entry* tmp = cnt_table -> look_up(tmp2->name);
                            if(!tmp) {
                                cout << "Unknown array identifier " << tmp2 -> name << " found at line number " << endl; 
                            }
                            else {
                                if(tmp -> dimensions == tmp1 -> sym_tab_entry -> dimensions){
                                    tmp -> initialized = true;
                                }
                                else{
                                    cout << "ERROR: Dimensions do not match for array " << tmp -> name << " declared at line number " << tmp -> line_no << '\n'; 
                                    exit(1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    for(auto &child : this -> children) {
        child -> validate_expression();
    }
}

// void node::validate_array(){
//     if(this->parent && this->parent->children.size() && this->children.size() && this->children[0]->children.size()){
//         symbol_table *cnt_table = this -> get_symbol_table();
//         if(!cnt_table) {
//             cout << "Unknown error, symbol table not found! Aborting..." << endl;
//             exit(1);
//         }

//         st_entry* tmp = cnt_table -> look_up(this -> parent -> children[0] -> name); // look up the array name in the symbol table

//         if(!tmp){
//             cout << "ERROR: Unknown identifier " << this -> parent -> children[0] -> name << " at line number " << endl;
//             exit(1);
//         }
//         else {
//             if(tmp -> dimensions == this -> children[0] -> children[this->children[0]->children.size()-1] -> dimensions)
//             tmp -> initialized = true;
//             return;     // validate_expression already called on the second child of "=" hence need not be called     
//         }
//     }
// }


void node::populate_and_check() {
    if(this -> name == "VariableDeclarator") {
        symbol_table *cnt_table = this -> get_symbol_table();
        bool isField = false;

        if(!cnt_table) {
            cout << "Unknown error, symbol table not found! Aborting..." << endl;
            exit(1);
        }
        
        isField = (this -> parent) && (this -> parent -> name == "FieldDeclaration");   // check if the current variable is a field declaration

        st_entry* tmp = cnt_table -> look_up(this -> sym_tab_entry -> name);
        if(tmp) {
            if(tmp -> table -> symbol_table_category == 'C' && !isField) {
                cnt_table -> add_entry(this -> sym_tab_entry);
            }
            else if(!isField){
                cout << "ERROR: Variable " << this -> sym_tab_entry -> name << " is already declared at line number: " << tmp -> line_no << endl;
                exit(1);
            }
            else {
                cout << "ERROR: Field member " << this -> sym_tab_entry -> name << " is already declared at line number: " << tmp -> line_no << endl;
                exit(1);
            }
        }
        else {
            // cout << "Variable " << this -> sym_tab_entry -> name << " added to scope " << cnt_table -> scope << endl;

            cnt_table -> add_entry(this -> sym_tab_entry);
        }

        for(auto &child : this -> children){
            if(child->name == "="){
                child->validate_expression();

                this -> sym_tab_entry -> initialized = true;
                return;     // validate_expression already called on the child, and all population and checks are done simultaneously
            }
            else if(child->type == "OPERATOR" && child->name[child->name.size()-1] == '='){
                child->validate_expression();

                this -> sym_tab_entry -> initialized = true;
                return;     // validate_expression already called on the child, and all population and checks are done simultaneously
            }
        }
    }
    else if(this->name == "Expression" || this->name == "Assignment") {
        this -> validate_expression();
        return;     // validate_expression already walked the subtree
    }

    for(auto &child : this -> children) {
        child -> populate_and_check();
    }
}

// WALK 3 - TYPE-CHECKING



void node::copy(const node other){
    this -> name = other.name;
    this -> terminal = other.terminal;
    this -> exp_applicable = other.exp_applicable;
    this -> type = other.type;
    
    // this -> sym_tab = other -> sym_tab;
    // this -> sym_tab_entry = other -> sym_tab_entry;
    // this -> entry_list = other -> entry_list;

    // parent and children set manually
}