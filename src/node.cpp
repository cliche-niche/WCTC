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
            if(this->name == "Expression" || this->name == "Assignment" || this->name == "Block"){
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
        (((symbol_table_func*) this -> sym_tab)-> return_type) = temp_node -> sym_tab -> name;  // setting the return type of the constructor as the class name  
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

symbol_table_class* node::get_symbol_table_class() {
    symbol_table* cnt = this -> get_symbol_table();

    while(cnt && cnt -> symbol_table_category != 'C') {
        cnt = cnt -> parent_st;
    }

    if(!cnt) {
        cout << "Class symbol table not found! Aborting..." << endl;
        exit(1);
    }

    return (symbol_table_class *)cnt;
}

st_entry* node::get_and_look_up() {
    // Get symbol table entry corresponding to an ID
    symbol_table* cnt_table = this -> get_symbol_table();

    if(!cnt_table) {
        cout << this -> name << endl;
        cout << "Unknown error, symbol table not found f! Aborting..." << endl;
        exit(1);
    }

    st_entry* tmp = cnt_table -> look_up(this -> name);
    return tmp;
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
            // while(cnt_table -> symbol_table_category != 'C') {
            //     cnt_table = cnt_table -> parent_st;
            // }
            symbol_table_class *class_table = this -> get_symbol_table_class();

            bool flag = false;
            for(auto &funcs : class_table -> member_funcs) {
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
                        cout << "ERROR: Unknown identifier " << tmp2 -> name << " at line number " << tmp2->sym_tab_entry->line_no << endl;
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
                cout << "ERROR: Unknown identifier " << this -> name << " at line number " << this -> sym_tab_entry -> line_no << endl;
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
            cout << "ERROR: Unknown identifier " << this -> children[0] -> name << " at line number " << this -> children[0] -> sym_tab_entry -> line_no << endl;
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
                cout << "Unknown array identifier " << array -> name << " found at line number " << array -> sym_tab_entry -> line_no << endl; 
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
                                cout << "Unknown array identifier " << tmp2 -> name << " found at line number " << tmp2 -> sym_tab_entry -> line_no << endl; 
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

char node::get_datatype_category() {
    if(this -> datatype == "long" || this -> datatype == "int" || this -> datatype == "char") {
        return 'I';
    }
    else if(this -> datatype == "boolean") {
        return 'B';
    }
    else if(this -> datatype == "double" || this -> datatype == "float") {
        return 'D';
    }
    else if(this -> datatype == "null") {
        return 'N';
    }
    else if(this -> datatype == "string") {
        return 'S';
    }
    else if(this -> datatype == "UNDEFINED") {
        return 'U';
    }

    return 0;
}

char node::get_datatype_category(string dt) {
    if(dt == "long" || dt == "int" || dt == "char") {
        return 'I';
    }
    else if(dt == "boolean") {
        return 'B';
    }
    else if(dt == "double" || dt == "float") {
        return 'D';
    }
    else if(dt == "null") {
        return 'N';
    }
    else if(dt == "string") {
        return 'S';
    }
    else if(dt == "UNDEFINED") {
        return 'U';
    }

    return 0;
}

string node::get_maxtype(string dt1, string dt2) {  // numeric type promotions (and string) 
    if(dt1 == "String" || dt2 == "String"){ 
        return "String";
    }
    else if(dt1 == "double" || dt2 == "double") { 
        return "double";
    }
    else if(dt1 == "float" || dt2 == "float") { 
        return "float";
    }
    else if(dt1 == "long" || dt2 == "long") { 
        return "long"; 
    }
    else if(dt1 == "int" || dt2 == "int"){ 
        return "int";     
    }
    else if(dt1 == "char" || dt2 == "char"){ 
        return "char";    
    }
    else {
        return "ERROR";
    }
}

bool node::find_cast(string dt1, string dt2){
    char c1 = this -> get_datatype_category(dt1), c2 = this -> get_datatype_category(dt2);
    if(c1 == 'B'){
        if(c2 == 'B'){
            this -> datatype = dt1;
            this -> type = "LITERAL";
            return true;
        }
        return false;
    }
    if(c1 == 'C'){
        if(c2 == 'C'){
            this -> datatype = dt1;
            this -> type = "LITERAL";
            return true;
        }
        return false;
    }
    if(c1 == 'D' || c1 == 'I'){
        if(c2 == 'D' || c2 == 'I'){
            this -> datatype = dt1;
            this -> type = "LITERAL";
            return true;
        }
        return false;
    }

    return false;
}

void node::set_datatype(node* child1, node* child2, string op){
    string dt1 = child1 -> datatype, dt2;
    char C1 = child1 -> get_datatype_category(), C2;
    if(child2){
        dt2 = child2 -> datatype;
        C2 = child2 -> get_datatype_category();
    }
    
    if(dt1 == "UNDEFINED" || dt2 == "UNDEFINED"){
        this->datatype = "UNDEFINED";
        return;
    }
    if(op == "+") {
        if(dt1 == "String" || dt2 == "String"){ 
            this -> datatype = "String";
            if(dt2 == "String"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;
            }

            if(dt1 == "String"){
                this -> exp_str_val = child1 -> exp_str_val;
                if(dt2 == "String"){
                    this -> exp_str_val += child2 -> exp_str_val;  
                } 
                else if(dt2 == "double" || dt2 == "float"){
                    this -> exp_str_val += to_string(child2 -> exp_dob_val);
                }
                else if(dt2 == "long" || dt2 == "int"){
                    this -> exp_str_val += to_string(child2 -> exp_int_val);
                }
                else if(dt2 == "char"){
                    this -> exp_str_val += ((char) child2 -> exp_int_val);
                }
                else if(dt2 == "boolean"){
                    this -> exp_str_val += (child2 -> exp_bool_val ? "true" : "false");
                }
            }
            else if(dt2 == "String"){
                if(dt1 == "String"){
                    this -> exp_str_val = child2 -> exp_str_val;  
                } 
                else if(dt1 == "double" || dt1 == "float"){
                    this -> exp_str_val = to_string(child1 -> exp_dob_val);
                }
                else if(dt1 == "long" || dt1 == "int"){
                    this -> exp_str_val = to_string(child1 -> exp_int_val);
                }
                else if(dt1 == "char"){
                    this -> exp_str_val = ((char) child1 -> exp_int_val);
                }
                else if(dt1 == "boolean"){
                    this -> exp_str_val = (child1 -> exp_bool_val ? "true" : "false");
                }
                this -> exp_str_val += child2 -> exp_str_val;
            }
            return;
        }

        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char" && dt1 != "String") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char" && dt2 != "String")) {
            this -> datatype = "ERROR";
            return;
        }

        if(dt1 == "String" || dt2 == "String"){ 
            this -> datatype = "String";
            if(dt2 == "String"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;
            }

            this -> exp_str_val = child1 -> exp_str_val;
            if(dt2 == "String"){
                this -> exp_str_val += child2 -> exp_str_val;  
            } 
            else if(dt2 == "double" || dt2 == "float"){
                this -> exp_str_val += to_string(child2 -> exp_dob_val);
            }
            else if(dt2 == "long" || dt2 == "int"){
                this -> exp_str_val += to_string(child2 -> exp_int_val);
            }
            else if(dt2 == "char"){
                this -> exp_str_val += ((char) child2 -> exp_int_val);
            }
            return;
        }
        else if(dt1 == "double" || dt2 == "double") { 
            this -> datatype = "double";
            if(dt2 == "double"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_dob_val = child1 -> exp_dob_val;
            if(dt2 == "double" || dt2 == "float"){
                this -> exp_dob_val += child2 -> exp_dob_val;
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val += child2 -> exp_int_val;
            }
        }
        else if(dt1 == "float" || dt2 == "float") { 
            this -> datatype = "float";
            if(dt2 == "float"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_dob_val = child1 -> exp_dob_val;
            if(dt2 == "float"){
                this -> exp_dob_val += child2 -> exp_dob_val;
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val += child2 -> exp_int_val;
            }
        }
        else if(dt1 == "long" || dt2 == "long") { 
            this -> datatype = "long";
            if(dt2 == "long"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_int_val = child1 -> exp_int_val;
            if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_int_val += child2 -> exp_int_val;
            }
        }
        else if(dt1 == "int" || dt2 == "int"){ 
            this -> datatype = "int";    
            if(dt2 == "int"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_int_val = child1 -> exp_int_val;
            if(dt2 == "int" || dt2 == "char"){
                this -> exp_int_val += child2 -> exp_int_val;
            }
        }
        else if(dt1 == "char" || dt2 == "char"){ 
            this -> datatype = "char";
            this -> exp_int_val = child1 -> exp_int_val + child2 -> exp_int_val;  
        }
        
        return;
    }
    else if(op == "-") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        bool flip = false;
        if(dt1 == "double" || dt2 == "double") { 
            this -> datatype = "double";
            if(dt2 == "double"){
                flip = true;
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_dob_val = child1 -> exp_dob_val;
            if(dt2 == "double" || dt2 == "float"){
                this -> exp_dob_val -= child2 -> exp_dob_val;
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val -= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "float" || dt2 == "float") { 
            this -> datatype = "float";
            if(dt2 == "float"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_dob_val = child1 -> exp_dob_val;
            if(dt2 == "float"){
                this -> exp_dob_val -= child2 -> exp_dob_val;
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val -= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "long" || dt2 == "long") { 
            this -> datatype = "long";
            if(dt2 == "long"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_int_val = child1 -> exp_int_val;
            if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_int_val -= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "int" || dt2 == "int"){ 
            this -> datatype = "int";    
            if(dt2 == "int"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_int_val = child1 -> exp_int_val;
            if(dt2 == "int" || dt2 == "char"){
                this -> exp_int_val -= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "char" || dt2 == "char"){ 
            this -> datatype = "char";
            this -> exp_int_val = child1 -> exp_int_val - child2 -> exp_int_val;  
        }
        
        if(flip){
            this -> exp_dob_val = - (this -> exp_dob_val);
            this -> exp_int_val = - (this -> exp_int_val);
        }
        return;
    }
    else if(op == "*") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        if(dt1 == "double" || dt2 == "double") { 
            this -> datatype = "double";
            if(dt2 == "double"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_dob_val = child1 -> exp_dob_val;
            if(dt2 == "double" || dt2 == "float"){
                this -> exp_dob_val *= child2 -> exp_dob_val;
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val *= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "float" || dt2 == "float") { 
            this -> datatype = "float";
            if(dt2 == "float"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_dob_val = child1 -> exp_dob_val;
            if(dt2 == "float"){
                this -> exp_dob_val *= child2 -> exp_dob_val;
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val *= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "long" || dt2 == "long") { 
            this -> datatype = "long";
            if(dt2 == "long"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_int_val = child1 -> exp_int_val;
            if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_int_val *= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "int" || dt2 == "int"){ 
            this -> datatype = "int";    
            if(dt2 == "int"){
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_int_val = child1 -> exp_int_val;
            if(dt2 == "int" || dt2 == "char"){
                this -> exp_int_val *= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "char" || dt2 == "char"){ 
            this -> datatype = "char";
            this -> exp_int_val = child1 -> exp_int_val * child2 -> exp_int_val;  
        }
        return;
    }
    else if(op == "/") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        if(dt1 == "double" || dt2 == "double") { 
            this -> datatype = "double";

            if(dt1 == "double" || dt1 == "float"){
                this -> exp_dob_val = child1 -> exp_dob_val;
            }
            else if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
                this -> exp_dob_val = child1 -> exp_int_val;
            }
            if(dt2 == "double" || dt2 == "float"){
                this -> exp_dob_val /= child2 -> exp_dob_val;
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val /= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "float" || dt2 == "float") { 
            this -> datatype = "float";

            if(dt1 == "float"){
                this -> exp_dob_val = child1 -> exp_dob_val;
            }
            else if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
                this -> exp_dob_val = child1 -> exp_int_val;
            }
            if(dt2 == "float"){
                this -> exp_dob_val /= child2 -> exp_dob_val;
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val /= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "long" || dt2 == "long") { 
            this -> datatype = "long";

            if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
                this -> exp_int_val = child1 -> exp_int_val;
            }
            if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_int_val /= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "int" || dt2 == "int"){ 
            this -> datatype = "int";

            if(dt1 == "int" || dt1 == "char"){
                this -> exp_int_val = child1 -> exp_int_val;
            }
            if(dt2 == "int" || dt2 == "char"){
                this -> exp_int_val /= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "char" || dt2 == "char"){ 
            this -> datatype = "char";
            this -> exp_int_val = child1 -> exp_int_val / child2 -> exp_int_val;  
        }
        return;
    }
    else if(op == "%") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        if(dt1 == "double" || dt2 == "double") { 
            this -> datatype = "double";

            if(dt1 == "double" || dt1 == "float"){
                this -> exp_dob_val = child1 -> exp_dob_val;
            }
            else if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
                this -> exp_dob_val = child1 -> exp_int_val;
            }
            if(dt2 == "double" || dt2 == "float"){
                this -> exp_dob_val = fmod(this -> exp_dob_val, child2 -> exp_dob_val);
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val = fmod(this -> exp_dob_val, child2 -> exp_int_val);
            }
        }
        else if(dt1 == "float" || dt2 == "float") { 
            this -> datatype = "float";

            if(dt1 == "float"){
                this -> exp_dob_val = child1 -> exp_dob_val;
            }
            else if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
                this -> exp_dob_val = child1 -> exp_int_val;
            }
            if(dt2 == "float"){
                this -> exp_dob_val = fmod(this -> exp_dob_val, child2 -> exp_dob_val);
            }
            else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_dob_val = fmod(this -> exp_dob_val, child2 -> exp_int_val);
            }
        }
        else if(dt1 == "long" || dt2 == "long") { 
            this -> datatype = "long";

            if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
                this -> exp_int_val = child1 -> exp_int_val;
            }
            if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                this -> exp_int_val = fmod(this -> exp_dob_val, child2 -> exp_int_val);
            }
        }
        else if(dt1 == "int" || dt2 == "int"){ 
            this -> datatype = "int";

            if(dt1 == "int" || dt1 == "char"){
                this -> exp_int_val = child1 -> exp_int_val;
            }
            if(dt2 == "int" || dt2 == "char"){
                this -> exp_int_val = fmod(this -> exp_dob_val, child2 -> exp_int_val);
            }
        }
        else if(dt1 == "char" || dt2 == "char"){ 
            this -> datatype = "char";
            this -> exp_int_val = child1 -> exp_int_val % child2 -> exp_int_val;  
        }
        return;
    }
    else if(op == "++" || op == "--") {
        
    }
    else if(op == "~") {
        if(dt1 != "long" && dt1 != "int" && dt1 != "char") {
            this -> datatype = "ERROR";
            return;
        }

        this -> datatype = dt1;
        this -> exp_int_val = (~(child1 -> exp_int_val));
        return;
    }
    else if(op == "!") {
        if(dt1 != "boolean") {
            this -> datatype = "ERROR";
            return;
        }
        this -> datatype = "boolean";
        this -> exp_bool_val = (child1 -> exp_bool_val == true);
        return;
    }
    else if(op == "<<") {
        if((dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        this -> datatype = dt1; // type is same as the left hand operand
        if(dt1 == "long"){
            this -> exp_int_val = ((child1 -> exp_int_val) << (child2 -> exp_int_val));
        }
        else if(dt1 == "int"){
            this -> exp_int_val = (((int) child1 -> exp_int_val) << (child2 -> exp_int_val));
        }
        else if(dt1 == "char"){
            this -> exp_int_val = (((char) child1 -> exp_int_val) << (child2 -> exp_int_val));
        }
        return;
    }
    else if(op == ">>") {
        if((dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        this -> datatype = dt1; // type is same as the left hand operand
        if(dt1 == "long"){
            this -> exp_int_val = ((child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "int"){
            this -> exp_int_val = (((int) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "char"){
            this -> exp_int_val = (((char) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        return;
    }
    else if(op == ">>>") {
        if((dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        this -> datatype = dt1; // type is same as the left hand operand
        if(dt1 == "long"){
            this -> exp_int_val = (((unsigned long long int) (child1 -> exp_int_val)) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "int"){
            this -> exp_int_val = (((unsigned int) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "char"){
            this -> exp_int_val = (((unsigned char) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        return;
    }
    else if(op == ">") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }
        this -> datatype = "boolean";
        bool result;
        if(dt1 == "double" || dt1 == "float"){
            if(dt2 == "double" || dt2 == "float"){
                result = ((child1 -> exp_dob_val) > (child2 -> exp_dob_val));
            }else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                result = ((child1 -> exp_dob_val) > (child2 -> exp_int_val));
            }
        }else if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
            if(dt2 == "double" || dt2 == "float"){
                result = ((child1 -> exp_int_val) > (child2 -> exp_dob_val));
            }else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                result = ((child1 -> exp_int_val) > (child2 -> exp_int_val));
            }
        }
        this -> exp_bool_val = result;
        return;
    }
    else if(op == "<") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        this -> datatype = "boolean";
        bool result;
        if(dt1 == "double" || dt1 == "float"){
            if(dt2 == "double" || dt2 == "float"){
                result = ((child1 -> exp_dob_val) < (child2 -> exp_dob_val));
            }else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                result = ((child1 -> exp_dob_val) < (child2 -> exp_int_val));
            }
        }else if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
            if(dt2 == "double" || dt2 == "float"){
                result = ((child1 -> exp_int_val) < (child2 -> exp_dob_val));
            }else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                result = ((child1 -> exp_int_val) < (child2 -> exp_int_val));
            }
        }
        this -> exp_bool_val = result;
        return;
    }
    else if(op == ">=") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        this -> datatype = "boolean";
        bool result;
        if(dt1 == "double" || dt1 == "float"){
            if(dt2 == "double" || dt2 == "float"){
                result = ((child1 -> exp_dob_val) >= (child2 -> exp_dob_val));
            }else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                result = ((child1 -> exp_dob_val) >= (child2 -> exp_int_val));
            }
        }else if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
            if(dt2 == "double" || dt2 == "float"){
                result = ((child1 -> exp_int_val) >= (child2 -> exp_dob_val));
            }else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                result = ((child1 -> exp_int_val) >= (child2 -> exp_int_val));
            }
        }
        this -> exp_bool_val = result;
    }
    else if(op == "<=") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            return;
        }

        this -> datatype = "boolean";
        bool result;
        if(dt1 == "double" || dt1 == "float"){
            if(dt2 == "double" || dt2 == "float"){
                result = ((child1 -> exp_dob_val) <= (child2 -> exp_dob_val));
            }else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                result = ((child1 -> exp_dob_val) <= (child2 -> exp_int_val));
            }
        }else if(dt1 == "long" || dt1 == "int" || dt1 == "char"){
            if(dt2 == "double" || dt2 == "float"){
                result = ((child1 -> exp_int_val) <= (child2 -> exp_dob_val));
            }else if(dt2 == "long" || dt2 == "int" || dt2 == "char"){
                result = ((child1 -> exp_int_val) <= (child2 -> exp_int_val));
            }
        }
        this -> exp_bool_val = result;
        return;
    }
    else if(op == "!=") {
        if((C1 == 'B' && C2 == 'B') || ((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) || (C1 == 'N' && C2 == 'N')) {
            this -> datatype = "boolean";
            bool result;
            if(C1 == 'N'){
                result = false;
            }
            else if(C1 == 'B'){
                result = ((child1 -> exp_bool_val) != (child2 -> exp_bool_val));
            }
            else if(C1 == 'D'){
                if(C2 == 'D'){
                    result = ((child1 -> exp_dob_val) != (child2 -> exp_dob_val));
                }
                else if(C2 == 'I'){
                    result = ((child1 -> exp_dob_val) != (child2 -> exp_int_val));
                }
            }
            else if(C1 == 'I'){
                if(C2 == 'D'){
                    result = ((child1 -> exp_int_val) != (child2 -> exp_dob_val));
                }
                else if(C2 == 'I'){
                    result = ((child1 -> exp_int_val) != (child2 -> exp_int_val));
                }
            }
            this -> exp_bool_val = result;
            return;
        }   
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "==") {
        if((C1 == 'B' && C2 == 'B') || ((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) || (C1 == 'N' && C2 == 'N')) {
            this -> datatype = "boolean";
            bool result;
            if(C1 == 'N'){
                result = true;
            }
            else if(C1 == 'B'){
                result = ((child1 -> exp_bool_val) == (child2 -> exp_bool_val));
            }
            else if(C1 == 'D'){
                if(C2 == 'D'){
                    result = ((child1 -> exp_dob_val) == (child2 -> exp_dob_val));
                }
                else if(C2 == 'I'){
                    result = ((child1 -> exp_dob_val) == (child2 -> exp_int_val));
                }
            }
            else if(C1 == 'I'){
                if(C2 == 'D'){
                    result = ((child1 -> exp_int_val) == (child2 -> exp_dob_val));
                }
                else if(C2 == 'I'){
                    result = ((child1 -> exp_int_val) == (child2 -> exp_int_val));
                }
            }
            this -> exp_bool_val = result;
            return;
        }   
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "!=") {
        if((C1 == 'B' && C2 == 'B') || ((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) || (C1 == 'N' && C2 == 'N')) {
            this -> datatype = "boolean";
            bool result;
            if(C1 == 'N'){
                result = false;
            }
            else if(C1 == 'B'){
                result = ((child1 -> exp_bool_val) != (child2 -> exp_bool_val));
            }
            else if(C1 == 'D'){
                if(C2 == 'D'){
                    result = ((child1 -> exp_dob_val) != (child2 -> exp_dob_val));
                }
                else if(C2 == 'I'){
                    result = ((child1 -> exp_dob_val) != (child2 -> exp_int_val));
                }
            }
            else if(C1 == 'I'){
                if(C2 == 'D'){
                    result = ((child1 -> exp_int_val) != (child2 -> exp_dob_val));
                }
                else if(C2 == 'I'){
                    result = ((child1 -> exp_int_val) != (child2 -> exp_int_val));
                }
            }
            this -> exp_bool_val = result;
            return;
        }   
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "&") {
        if((C1 == 'B' && C2 == 'B')) {
            this -> datatype = "boolean";
            this -> exp_bool_val = ((child1 -> exp_bool_val) & (child2 -> exp_bool_val));
            return;
        }
        else if ((C1 == 'I' && C2 == 'I')) {
            this -> datatype = this -> get_maxtype(dt1, dt2);
            this -> exp_int_val = ((child1 -> exp_int_val) & (child2 -> exp_int_val));
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "|") {
        if((C1 == 'B' && C2 == 'B')) {
            this -> datatype = "boolean";
            this -> exp_bool_val = ((child1 -> exp_bool_val) | (child2 -> exp_bool_val));
            return;
        }
        else if ((C1 == 'I' && C2 == 'I')) {
            this -> datatype = this -> get_maxtype(dt1, dt2);
            this -> exp_int_val = ((child1 -> exp_int_val) | (child2 -> exp_int_val));
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "^") {
        if((C1 == 'B' && C2 == 'B')) {
            this -> datatype = "boolean";
            this -> exp_bool_val = ((child1 -> exp_bool_val) ^ (child2 -> exp_bool_val));
            return;
        }
        else if ((C1 == 'I' && C2 == 'I')) {
            this -> datatype = this -> get_maxtype(dt1, dt2);
            this -> exp_int_val = ((child1 -> exp_int_val) ^ (child2 -> exp_int_val));
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "&&") {
        if(C1 == 'B' && C2 == 'B') {
            this -> datatype = "boolean";
            this -> exp_bool_val = ((child1 -> exp_bool_val) && (child2 -> exp_bool_val));
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "||") {
        if(C1 == 'B' && C2 == 'B') {
            this -> datatype = "boolean";
            this -> exp_bool_val = ((child1 -> exp_bool_val) || (child2 -> exp_bool_val));
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
}

void node::calc_datatype(node* child1, node* child2, string op){
    string dt1 = child1 -> datatype, dt2;
    char C1 = child1 -> get_datatype_category(), C2;
    if(child2){
        dt2 = child2 -> datatype;
        C2 = child2 -> get_datatype_category();
    }
    
    if(dt1 == "UNDEFINED" || dt2 == "UNDEFINED"){
        this->datatype = "UNDEFINED";
        return;
    }
    if(op == "+") {
        if(dt1 == "String" || dt2 == "String"){ 
            this -> datatype = "String";
            return;
        }

        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char" && dt1 != "String") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char" && dt2 != "String")) {
            this -> datatype = "ERROR";
            // REPORT ERROR HERE ONLY
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '+' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = this->get_maxtype(dt1, dt2);
        return;
    }
    else if(op == "-") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '-' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }
        
        this -> datatype = this->get_maxtype(dt1, dt2);
        return;
    }
    else if(op == "*") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '*' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = this->get_maxtype(dt1, dt2);
        return;
    }
    else if(op == "/") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '/' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = this->get_maxtype(dt1, dt2);
        return;
    }
    else if(op == "%") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '%' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = this -> get_maxtype(dt1, dt2);
        return;
    }
    else if(op == "++" || op == "--") {
        if(!(C1 == 'I' || C1 == 'D')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '"<< op <<"' operator with operands " << dt1 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = child1 -> datatype;
        return;
    }
    else if(op == "~") {
        if(!(C1 == 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '~' operator with operands " << dt1 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = dt1;
        return;
    }
    else if(op == "!") {
        if(dt1 != "boolean") {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '!' operator with operands " << dt1 << " at line number: " << endl;
            exit(1);
        }
        this -> datatype = "boolean";
        return;
    }
    else if(op == "<<") {
        if(!(C1 == 'I') || !(C2 == 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '<<' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }
        this -> datatype = dt1; // type is same as the left hand operand
        return;
    }
    else if(op == ">>") {
        if(!(C1 == 'I') || !(C2 == 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '>>' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = dt1; // type is same as the left hand operand
        return;
    }
    else if(op == ">>>") {
        if(!(C1 == 'I') || !(C2 == 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '>>>' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = dt1; // type is same as the left hand operand
        return;
    }
    else if(op == ">") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '>' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }
        this -> datatype = "boolean";
        return;
    }
    else if(op == "<") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '<' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        return;
    }
    else if(op == ">=") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '>=' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        return;
    }
    else if(op == "<=") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '<=' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        return;
    }
    else if(op == "==") {
        if((C1 == 'B' && C2 == 'B') || ((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) || (C1 == 'N' && C2 == 'N')) {
            this -> datatype = "boolean";
            return;
        }   
        else {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '==' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }
    }
    else if(op == "!=") {
        if((C1 == 'B' && C2 == 'B') || ((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) || (C1 == 'N' && C2 == 'N')) {
            this -> datatype = "boolean";
            return;
        }   
        else {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '%' operator with operands " << dt1 << " and " << dt2 << " at line number: " << endl;
            exit(1);
        }
    }
    else if(op == "&") {
        if((C1 == 'B' && C2 == 'B')) {
            this -> datatype = "boolean";
            return;
        }
        else if ((C1 == 'I' && C2 == 'I')) {
            this -> datatype = this -> get_maxtype(dt1, dt2);
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "|") {
        if((C1 == 'B' && C2 == 'B')) {
            this -> datatype = "boolean";
            return;
        }
        else if ((C1 == 'I' && C2 == 'I')) {
            this -> datatype = this -> get_maxtype(dt1, dt2);
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "^") {
        if((C1 == 'B' && C2 == 'B')) {
            this -> datatype = "boolean";
            return;
        }
        else if ((C1 == 'I' && C2 == 'I')) {
            this -> datatype = this -> get_maxtype(dt1, dt2);
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "&&") {
        if(C1 == 'B' && C2 == 'B') {
            this -> datatype = "boolean";
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
    else if(op == "||") {
        if(C1 == 'B' && C2 == 'B') {
            this -> datatype = "boolean";
            return;
        }
        else {
            this -> datatype = "ERROR";
            return;
        }
    }
}

void node::obtain_function_parameters(vector<string> &params) {
    for(auto &child : this -> children) {
        if(this -> name == "Expression") {
            params.push_back(this -> datatype);
            return;
        }
        else {
            child -> obtain_function_parameters(params);
        }
    }
}

vector<string> node::get_function_parameters() {  // should only be called from BracketArgumentList
    if(this -> name != "BracketArgumentList") {
        cout << "Error, get_function_parameters() invoked from illegal node. Aborting..." << endl;
        exit(1);
    }

    vector<string> params;
    this -> obtain_function_parameters(params);
    return params;
}

void node::chill_traversal(){
    for(auto (&child) : this -> children){
        if(child -> name == "Block"){
            child -> type_check();
        }else{
            child -> chill_traversal();
        }
    }
}

void node::type_check() {
    // after execution of this function at a particular node, its datatype should be correctly populated
    for(auto &child : this -> children) {
        child -> type_check();
    }


    if(this -> type == "ID") {                     // setting identifier types (from the symbol table)
        st_entry* tmp = this -> get_and_look_up();

        if(tmp) {
            this -> datatype = tmp -> type;
            for(int i = 0; i < tmp -> dimensions; i++) {
                this -> datatype += "[]";
            }
        }
    }
    else if(this -> name == "ArrayAccess") {        // checking array accesses
        for(auto &child : this -> children) {
            if(child -> name == "Expression") {
                if(child -> get_datatype_category() != 'I') {
                    cout << "ERROR: Expected integer type in array access, received " << child -> datatype << " instead." << endl;
                    exit(1);                    
                }
            }
        }

        string tmp = this -> children[0] -> datatype;
        if(tmp[(int)(tmp.size()) - 1] != ']') {
            cout << "ERROR: Array required but " << tmp << " found. Possibly accessing more dimensions than permissible." << endl;
            exit(1);
        }
        else {
            this -> datatype = tmp.substr(0, tmp.size() - 2);
        }
    }
    else if(this -> name == "ReturnStatement") {   // keyword_return
        symbol_table* tmp = this -> get_symbol_table();
        while(tmp && tmp -> symbol_table_category != 'M') {
            tmp = tmp -> parent_st;
        }
        if(!tmp) {
            cout << "Unknown error with return statement! Aborting..." << endl;
            exit(1);
        }
        
        string return_type = ((symbol_table_func* )tmp) -> return_type;
        
        if(this -> children.size() == 1){
            if(return_type != "void") {
                cout << "ERROR: Non-void function " << return_type ;
            }
        }else if(this -> children.size() == 2){
            if(return_type != this -> children[1] -> datatype){
                cout << "ERROR: Function (" << tmp->name << ") returns (" << return_type << ") type, but expected (" << this -> children[1] -> datatype << ")." << endl;
                exit(1);
            }
        }
    }
    else if(this -> type == "OPERATOR") {
        if(this -> children.size() == 1){
            this -> calc_datatype(this -> children[0]);
        }
        else if(this -> children.size() == 2){
            this -> calc_datatype(this -> children[0], this -> children[1], this -> name);
        }
        else if(this -> children.size() == 3){
            // TERNARY TO BE DEALT WITH
        }
    }
    else if(this -> name == "PreIncrementExpression" || this -> name == "PreDecrementExpression") {
        if(!(this -> children[1] -> type == "ID" || this -> children[1] -> name == "Name")) {
            cout << "ERROR: '"<< this -> children[0] -> name <<"' can only operate on variables at line number: " << endl;
            exit(1);
        }

        this -> calc_datatype(this -> children[1], NULL, this -> children[0] -> name);
        this -> type = "LITERAL";
    }
    else if(this -> name == "PostIncrementExpression" || this -> name == "PostDecrementExpression") {
        if(!(this -> children[0] -> type == "ID" || this -> children[0] -> name == "Name")) {
            cout << "ERROR: '"<< this -> children[1] -> name <<"' can only operate on variables at line number: " << endl;
            exit(1);
        }
        
        this -> calc_datatype(this -> children[0], NULL, this -> children[1] -> name);
        this -> type = "LITERAL";
    }
    else if(this -> name == "CastExpression"){
        string dt1 = this -> children[1] -> name, dt2 = this -> children[3] -> datatype;
        if(!(this -> find_cast(dt1, dt2))){
            cout << "ERROR: Cannot cast " << dt2 << " into " << dt1 << "." << endl;
            exit(1);
        }

        this -> datatype = dt1;     // propagate the datatype upwards
        this -> type = "LITERAL";   // Casted expression becomes a literal
    }
    else if(this -> name == "MethodInvocation") {   // method invocation parameter checking
        // only tackling Identifier BracketArgumentList for now

        string func_name = this -> children[0] -> name;
        vector<string> params = this -> children[1] -> get_function_parameters();

        symbol_table_class* class_table = this -> get_symbol_table_class();
        bool match_found = false;
        for(auto &func : class_table -> member_funcs) {
            bool flag = true;
            if(func -> name == func_name && params.size() == func -> params.size()) {
                flag = false;
                for(int idx = 0; idx < params.size(); idx++) {
                    if(params[idx] != func -> params[idx] -> type) {
                        flag = true;
                        break;
                    }
                }
            }
            if(!flag) {
                match_found = true;
                this -> datatype = func -> return_type;
                break;
            }
        }

        if(!match_found) {
            cout << "ERROR: Unknown method invocation " << endl; // ! Tanwar print parameters
            exit(1);
        }
    }
    else {
        // Handle default nodes @TODO Come up with a strategy to decide on the datatype of current node based on datatypes of children 
        for(auto (&child) : this -> children){
            if(child -> datatype != "UNDEFINED"){
                this -> datatype = child -> datatype;
                return;
            }
        }
    }
}

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