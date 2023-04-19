#include <bits/stdc++.h>
#include "../include/global_vars.hpp" // Includes node.hpp
using namespace std;

node *root;

node::node(string name /*= ""*/, bool terminal /*= false*/, string type /* = "" */, node* parent /* = NULL */){
    this->parent = parent;
    this->name = name;
    this->terminal = terminal;
    this->type = type;
    this->line_no = yylineno;
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
        if(this->name != "Expression" && this->name != "VariableDeclarator" && this->name != "Assignment" && this->name != "Block" && this->name != "VariableDeclaratorId" && this->name != "ReturnStatement" && this->name != "ArrayCreationExpression" && this->name != "ForInit" && this->name != "ForUpdate"){
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

    {
        ofstream out(filename);
        out<<dot_code;
        out.close();
    }
}

void node::add_nodes(unsigned long long (&node_num), string (&dot_code)){
    node_num++;
    this->node_number = node_num;
    
    if(this->terminal){
        dot_code += "node" + to_string(this->node_number) + "[label = \"" + this->type + '\n' + this->name + " (L" + to_string(this->line_no) +  ")\", shape = rectangle, color = ";
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
        dot_code += "node" + to_string(this->node_number) + "[label = \"" + this->name + " (L" + to_string(this->line_no) + ")\"];\n";
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
    if(v->name == "#Name#" || (v->type == "ID" && v->terminal)){
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

// int node::calc_dims(node* v){
//     // to calculate memory needed for an array
//     if(v && v->name == "DimExprs"){
//         if(v->children.size()==1){

//         }
//     }
//     if(v){
//         if(v->name == "DimExpr"){
//             node* curr = v->children[1];
//             while(curr->children.size()){
//                 curr = curr->children[0];
//             }
//             return atoi(curr->name);
//         }
//     }
// }

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
    node* temp_node = this;
    
    while(temp_node && !(temp_node -> sym_tab)) {
        temp_node = temp_node->parent;
    }
    if(temp_node == NULL) {
        return NULL;
    }
    
    return temp_node -> sym_tab;
}

symbol_table* node::get_scope() {
    node* tmp = this;
    while(tmp && !tmp -> sym_tab) {
        tmp = tmp -> parent;
    }

    if(!tmp) {
        return NULL;
    }
    else {
        return tmp -> sym_tab;
    }
}

bool node::check_static() {
    symbol_table* scope = this -> get_scope();
    while(scope && scope -> parent_st && scope -> symbol_table_category != 'M') {
        scope = scope -> parent_st;
    }
    if(scope == main_table) {       // if we go to the global table, exit
        return false;
    }
    if(scope){
        return ((symbol_table_func*) scope)->modifier_bv[M_STATIC];
    }

    return false;
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
        cout << "Unknown error, symbol table not found! Aborting..." << endl;
        exit(1);
    }

    st_entry* tmp = cnt_table -> look_up(this -> name);
    return tmp;
}

st_entry* node::get_and_look_up_member_variable(string id, string cls) {
    symbol_table_class* cnt_class = main_table -> look_up_class(cls);

    st_entry* tmp = cnt_class -> look_up(id);
    return tmp;
}

st_entry* node::get_and_look_up(string id) {
    // Get symbol table entry corresponding to an ID
    symbol_table* cnt_table = this -> get_symbol_table();

    if(!cnt_table) {
        cout << id << endl;
        cout << "Unknown error, symbol table not found! Aborting..." << endl;
        exit(1);
    }

    st_entry* tmp = cnt_table -> look_up(id);
    return tmp;
}

string node::get_type_without_array(string type) {
    string type_without_array = "";

    for(int i = 0; i < type.size(); i++) {
        if(type[i] == '[') {
            break;
        }
        type_without_array += type[i];
    }

    return type_without_array;
}

// WALK 1

void node::create_scope_hierarchy() {
    if(this -> name == "FieldDeclaration") {
        symbol_table* tmp_st = this -> get_symbol_table();
        if(tmp_st -> symbol_table_category != 'C') {
            cout << "Unknown error! Scope of Field member is not class. Aborting...";
            exit(1);
        }
        for(auto &entry : this -> entry_list) {
            st_entry* tmp = tmp_st -> look_up(entry -> name);
            if(tmp) {
                cout << "ERROR: Field member " << entry -> name << " is already declared at line number: " << entry -> line_no << endl;
                exit(1);
            }
            else {
                tmp_st -> add_entry(entry);
            }
        }
        return;
    }
    if(this -> sym_tab && this -> parent) {
        symbol_table* temp_parent_st;
        node* temp_node = this -> parent;
        while(temp_node && !(temp_node -> sym_tab)) {
            temp_node = temp_node -> parent;
        }
        if(!temp_node) {
            temp_parent_st = NULL;
        }
        else {
            temp_parent_st = temp_node -> sym_tab;
        }
        if(temp_parent_st) {
            if(temp_parent_st -> symbol_table_category == 'G') { // if the parent is the global table, then the current table is a class table
                ((symbol_table_global*) temp_parent_st) -> add_entry((symbol_table_class *) this -> sym_tab);
            }
            else if(this -> name == "MethodDeclaration") { // if the current node is a method declaration, then the parent table is a class table
                if(this -> sym_tab_entry -> name == temp_parent_st -> name) {
                    cout << "ERROR: Constructor cannot have a return type. Found a return type at line number: " << this -> line_no << endl;
                    exit(1);
                }
                ((symbol_table_class*) temp_parent_st) -> add_func((symbol_table_func*) this -> sym_tab);
            }
            else if(this -> name == "ConstructorDeclaration") {
                if(this -> sym_tab_entry -> name != temp_parent_st -> name) {
                    cout << "ERROR: Constructor name does not match simple class name at line number: " << this -> line_no << endl;
                    exit(1);
                }

                ((symbol_table_class*) temp_parent_st) -> add_func((symbol_table_func*) this -> sym_tab);
            }

            if( temp_node -> name == "MethodDeclaration" || 
                temp_node -> name == "ConstructorDeclaration" ||
                temp_node -> name == "BasicForStatement" ||
                temp_node -> name == "EnhancedForStatement" ||
                temp_node -> name == "BasicForStatementNoShortIf" ||
                temp_node -> name == "EnhancedForStatementNoShortIf") {  
                this -> sym_tab = temp_parent_st;   // situations to merge the scope
            }
            else {
                this -> sym_tab -> parent_st = temp_parent_st;
                temp_parent_st -> children_st . push_back(this -> sym_tab);
                (temp_parent_st -> sub_scopes)++;
                this -> sym_tab -> scope = ((temp_parent_st->scope != "") ? temp_parent_st->scope + "/" : "") + (this->sym_tab->name) + "#" + to_string(temp_parent_st->sub_scopes);
                
                // cout << "Current scope: " << this -> sym_tab -> scope << endl;
                // cout << "Parent scope: " << temp_parent_st -> scope << endl; 
            }
        }
    }
    
    

    for(auto &child : this -> children) {
        child->create_scope_hierarchy();
    }
}

// BEFORE WALK 2 ADD DEFAULT CONSTRUCTORS TO ALL CLASSES AS NECESSARY
// BEFORE WALK 2 CALCULATE ALL THE CLASS SIZES FROM FIELD MEMBERS
void node::populate_default_constructors() {
    for(auto &cls : main_table -> classes) {
        bool flag = false;
        for(auto &func : cls -> member_funcs) {
            if(func -> name == cls -> name) {       // a user defined constructor already exists
                flag = true;
            }
        }
        
        if(flag) continue;                          // no need to add default constructor
        
        vector<string> empty_params;
        vector<st_entry*> empty_formal_params;
        if(!(cls -> look_up_function(cls->name, empty_params))) {
            cls -> add_func(new symbol_table_func(cls->name, empty_formal_params, cls->name));
        }
    }
}

void node::populate_class_sizes() {
    for(auto &cls : main_table -> classes) {
        int offset = 0;
        for(auto &entry : cls -> entries) {
            entry -> offset = offset;
            offset += entry -> size;
        }

        cls -> object_size = offset;
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
                // EXPERIMENTAL
                cout << "ERROR: Unknown method identifier " << this -> name << " at line number " << this -> line_no << endl;
                exit(1);
            }
        }
        else if(this -> parent && this -> parent -> name == "UnqualifiedClassInstanceCreationExpression") { // If the identifier is a constructor
            // // Verification of this will be done in the third walk (type checking walking)
            node *tmp1 = this -> parent, *tmp2;
            if(tmp1 -> parent && tmp1 -> parent -> name == "Expression" && tmp1 -> parent -> parent && tmp1 -> parent -> parent -> name == "="){
                tmp1 = tmp1 -> parent -> parent;
                if(tmp1 -> children.size() == 1){        //     constructor initialization with declaration
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
                else if(tmp1 -> children.size() == 2){      //  constructor initialization after declaration
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
                            // EXPERIMENTAL
                            cout << "Error: Conflicting types for the object \"" << tmp -> name << "\": " << tmp -> type << " (Line No. " << tmp -> line_no << ") & " << this -> name << "(Line No. " << this -> line_no << ")" << endl;
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
                    cout << "ERROR: Variable " << tmp -> name << " has not been initialized, but used at line number " << this -> line_no << endl;
                    exit(1);
                }
            }
        }
    }
    else if(this -> name == "#Name#") {
        this -> children[0] -> validate_expression();
        return;
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

        isField = (this -> get_symbol_table() -> symbol_table_category == 'C');

        bool flag = false;
        string type_without_array = get_type_without_array(this -> sym_tab_entry -> type);
        if(primitive_types.find(type_without_array) == primitive_types.end()) {
            symbol_table_class* tmp_class = main_table -> look_up_class(type_without_array);    // try to find object type
            
            if(!tmp_class) {
                cout << "ERROR: Unknown object type " << type_without_array << " at line number: " << this -> line_no << endl;
                exit(1);
            }
        }
        
        
        st_entry* tmp = cnt_table -> look_up(this -> sym_tab_entry -> name);
        if(tmp) {
            if(tmp -> table -> symbol_table_category == 'C' && !isField) {
                cnt_table -> add_entry(this -> sym_tab_entry);
            }
            else if(!isField){
                cout << "ERROR: Variable " << this -> sym_tab_entry -> name << " is already declared at line number: " << tmp -> line_no << endl;
                exit(1);
            }
            // else {
            //     cout << "ERROR: Field member " << this -> sym_tab_entry -> name << " is already declared at line number: " << tmp -> line_no << endl;
            //     exit(1);
            // }
        }
        else if(!isField){
            cnt_table -> add_entry(this -> sym_tab_entry);
        }

        for(auto &child : this -> children){
            if(child->name == "="){
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

// WALK 2.5 - Modifier Checking

void node::modifier_check() {
    // if(this -> name == "#Name#") {
    //     // @TODO
    //     return;    
    // }

    if(this -> type == "ID") {     // reference using this.x from a static function
        st_entry* tmp = this -> get_and_look_up(this -> name);

        if(tmp && tmp -> table -> symbol_table_category == 'C' && !(tmp -> modifier_bv[M_STATIC]) && this -> check_static() && !(this -> parent && this -> parent -> name == "#Name#")) {
            cout << "ERROR: Cannot reference field variable (" << this -> name << ") from static function. Line number " << this -> line_no << endl;  
            exit(1);
        }
    }

    else if(this -> name == "MethodInvocation") {
        vector<string> params = this -> children[(int)(this -> children.size()) - 1] -> get_function_parameters();
        symbol_table_class* cnt_class = this -> get_symbol_table_class();
        if(!cnt_class){
            cout << "Unknown error, symbol table not found! Aborting..." << endl;
            exit(1);
        }
        symbol_table_func* cnt_func = cnt_class -> look_up_function(this -> children[0] -> name, params);

        if(cnt_func && !(cnt_func -> modifier_bv[M_STATIC]) && this -> check_static()) {
            cout << "ERROR: Cannot reference non-static function (" << this -> children[0] -> name << ") from static function. Line number: " << this -> line_no << endl;  
            exit(1);
        }
    }

    for(auto &child : this -> children) {
        child -> modifier_check();
    }
}

// WALK 3 - TYPE-CHECKING

char node::get_datatype_category() {
    if(this -> datatype == "long" || this -> datatype == "int" || this -> datatype == "char" || this -> datatype == "short" || this -> datatype == "byte") {
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
    else {
        return 'R';     // REFERENCE TYPE (Arrays and Objects)
    }

    return 0;
}

char node::get_datatype_category(string dt) {
    if(dt == "long" || dt == "int" || dt == "char" || dt == "short" || dt == "byte") {
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
    else {
        return 'R';     // REFERENCE TYPE (Array and Objects)
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
    else if(dt1 == "int" || dt2 == "int") { 
        return "int";     
    }
    else if(dt1 == "char" || dt2 == "char") { 
        return "char";    
    }
    else if(dt1 == "short" || dt2 == "short") {
        return "short";
    }
    else if(dt1 == "byte" || dt2 == "byte") {
        return "byte";
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

    // if control reaches here, the expression must be constant
    this -> exp_is_constant = true;

    if(op == "+") {
        if(dt1 == "String" || dt2 == "String"){ 
            if(dt1 == "String"){
                this -> exp_str_val = child1 -> exp_str_val;
                if(dt2 == "String"){
                    this -> exp_str_val += child2 -> exp_str_val;  
                } 
                else if(C2 == 'D'){
                    this -> exp_str_val += to_string(child2 -> exp_dob_val);
                }
                else if(dt2 == "long" || dt2 == "int" || dt2 == "short" || dt2 == "byte"){
                    this -> exp_str_val += to_string(child2 -> exp_int_val);
                }
                else if(dt2 == "char"){
                    this -> exp_str_val += ((char) child2 -> exp_int_val);
                }
                else if(dt2 == "boolean"){
                    this -> exp_str_val += (child2 -> exp_bool_val ? "true" : "false");
                }
                else {
                    this -> datatype = "ERROR";
                    cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
                    exit(1);
                }
            }
            else if(dt2 == "String"){
                if(dt1 == "String"){
                    this -> exp_str_val = child1 -> exp_str_val;  
                } 
                else if(C1 == 'D'){
                    this -> exp_str_val = to_string(child1 -> exp_dob_val);
                }
                else if(dt1 == "long" || dt1 == "int" || dt1 == "short" || dt1 == "byte"){
                    this -> exp_str_val = to_string(child1 -> exp_int_val);
                }
                else if(dt1 == "char"){
                    this -> exp_str_val = ((char) child1 -> exp_int_val);
                }
                else if(dt1 == "boolean"){
                    this -> exp_str_val = (child1 -> exp_bool_val ? "true" : "false");
                }
                else {
                    this -> datatype = "ERROR";
                    cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
                    exit(1);
                }
                this -> exp_str_val += child2 -> exp_str_val;
            }
            return;
        }

        if((C1 != 'D' && C1 != 'I') || (C2 != 'D' && C2 != 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
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
            if(C2 == 'D'){
                this -> exp_dob_val += child2 -> exp_dob_val;
            }
            else if(C2 == 'I'){
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
            if(C2 == 'D'){
                this -> exp_dob_val += child2 -> exp_dob_val;
            }
            else if(C2 == 'I'){
                this -> exp_dob_val += child2 -> exp_int_val;
            }
        }
        else {  // at this point we are sure that both children have integral types
            this -> exp_int_val = child1 -> exp_int_val + child2 -> exp_int_val;
            this -> datatype = get_maxtype(dt1, dt2);
        }
        
        return;
    }
    else if(op == "-") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
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
            if(C2 == 'D'){
                this -> exp_dob_val -= child2 -> exp_dob_val;
            }
            else if(C2 == 'I'){
                this -> exp_dob_val -= child2 -> exp_int_val;
            }
        }
        else if(dt1 == "float" || dt2 == "float") { 
            this -> datatype = "float";
            if(dt2 == "float"){
                flip = true;
                swap(dt1, dt2);
                node* tmp = child2;
                child2 = child1;
                child1 = tmp;                
            }

            this -> exp_dob_val = child1 -> exp_dob_val;
            if(C2 == 'D'){
                this -> exp_dob_val -= child2 -> exp_dob_val;
            }
            else if(C2 == 'I'){
                this -> exp_dob_val -= child2 -> exp_int_val;
            }
        }
        else {
            this -> exp_int_val = child1 -> exp_int_val - child2 -> exp_int_val;
            this -> datatype = this -> get_maxtype(dt1, dt2);
        }
        
        if(flip){
            this -> exp_dob_val = - (this -> exp_dob_val);
            this -> exp_int_val = - (this -> exp_int_val);
        }
        return;
    }
    else if(op == "*") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
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
            if(C2 == 'D'){
                this -> exp_dob_val *= child2 -> exp_dob_val;
            }
            else if(C2 == 'I'){
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
            if(C2 == 'D'){
                this -> exp_dob_val *= child2 -> exp_dob_val;
            }
            else if(C2 == 'I'){
                this -> exp_dob_val *= child2 -> exp_int_val;
            }
        }
        else {
            this -> exp_int_val = child1 -> exp_int_val * child2 -> exp_int_val;
            this -> datatype = this -> get_maxtype(dt1, dt2);
        }
        return;
    }
    else if(op == "/") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            // EXPERIMENTAL
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }

        if(C1 == 'D' || C2 == 'D') {
            this -> datatype = this -> get_maxtype(dt1, dt2);

            if(C1 == 'D'){
                this -> exp_dob_val = child1 -> exp_dob_val;
            }
            else if(C1 == 'I'){
                this -> exp_dob_val = child1 -> exp_int_val;
            }
            if(C2 == 'D'){
                this -> exp_dob_val /= child2 -> exp_dob_val;
            }
            else if(C2 == 'I'){
                this -> exp_dob_val /= child2 -> exp_int_val;
            }
        }
        else {
            this -> exp_int_val = child1 -> exp_int_val / child2 -> exp_int_val;
            this -> datatype = this -> get_maxtype(dt1, dt2);
        }
        return;
    }
    else if(op == "%") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }

        if(C1 == 'D' || C2 == 'D') {
            this -> datatype = this -> get_maxtype(dt1, dt2);

            if(C1 == 'D'){
                this -> exp_dob_val = child1 -> exp_dob_val;
            }
            else if(C1 == 'I'){
                this -> exp_dob_val = child1 -> exp_int_val;
            }
            if(C2 == 'D'){
                this -> exp_dob_val = fmod(this -> exp_dob_val, child2 -> exp_dob_val);
            }
            else if(C2 == 'I'){
                this -> exp_dob_val = fmod(this -> exp_dob_val, child2 -> exp_int_val);
            }
        }
        else {
            this -> exp_int_val = child1 -> exp_int_val % child2 -> exp_int_val;
            this -> datatype = this -> get_maxtype(dt1, dt2);
        }
        
        return;
    }
    else if(op == "++" || op == "--") {
        cout << "ERROR: Operator \'" << op << "\' cannot operate on Literal. Line No.: " << child1 -> line_no << endl;
        exit(1);
    }
    else if(op == "~") {
        if(C1 != 'I') {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data type (" << dt1 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = dt1;
        this -> exp_int_val = (~(child1 -> exp_int_val));
        return;
    }
    else if(op == "!") {
        if(dt1 != "boolean") {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data type (" << dt1 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }
        this -> datatype = "boolean";
        this -> exp_bool_val = (child1 -> exp_bool_val == true);
        return;
    }
    else if(op == "<<") {
        if((C1 != 'I') || (C2 != 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = dt1; // type is same as the left hand operand
        if(dt1 == "long"){
            this -> exp_int_val = ((child1 -> exp_int_val) << (child2 -> exp_int_val));
        }
        else if(dt1 == "int"){
            this -> exp_int_val = (((int) child1 -> exp_int_val) << (child2 -> exp_int_val));
        }
        else if(dt1 == "char"){
            this -> exp_int_val = (((short) child1 -> exp_int_val) << (child2 -> exp_int_val));
        }
        else if(dt1 == "short") {
            this -> exp_int_val = (((short) child1 -> exp_int_val) << (child2 -> exp_int_val));
        }
        else if(dt1 == "byte") {
            this -> exp_int_val = (((char) child1 -> exp_int_val) << (child2 -> exp_int_val));
        }
        return;
    }
    else if(op == ">>") {
        if((C1 != 'I') || (C2 != 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" << dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = dt1; // type is same as the left hand operand
        if(dt1 == "long"){
            this -> exp_int_val = ((child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "int"){
            this -> exp_int_val = (((int) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "char"){
            this -> exp_int_val = (((short) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "short") {
            this -> exp_int_val = (((short) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "byte") {
            this -> exp_int_val = (((char) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
    
        return;
    }
    else if(op == ">>>") {
        if((C1 != 'I') ||(C2 != 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
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
            this -> exp_int_val = (((unsigned short) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "short") {
            this -> exp_int_val = (((unsigned short) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        else if(dt1 == "byte") {
            this -> exp_int_val = (((unsigned char) child1 -> exp_int_val) >> (child2 -> exp_int_val));
        }
        return;
    }
    else if(op == ">") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        bool result;
        if(C1 == 'D'){
            if(C2 == 'D'){
                result = ((child1 -> exp_dob_val) > (child2 -> exp_dob_val));
            }else if(C2 == 'I'){
                result = ((child1 -> exp_dob_val) > (child2 -> exp_int_val));
            }
        }else if(C1 == 'I'){
            if(C2 == 'D'){
                result = ((child1 -> exp_int_val) > (child2 -> exp_dob_val));
            }else if(C2 == 'I'){
                result = ((child1 -> exp_int_val) > (child2 -> exp_int_val));
            }
        }
        this -> exp_bool_val = result;
        return;
    }
    else if(op == "<") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        bool result;
        if(C1 == 'D'){
            if(C2 == 'D'){
                result = ((child1 -> exp_dob_val) < (child2 -> exp_dob_val));
            }else if(C2 == 'I'){
                result = ((child1 -> exp_dob_val) < (child2 -> exp_int_val));
            }
        }else if(C1 == 'I'){
            if(C2 == 'D'){
                result = ((child1 -> exp_int_val) < (child2 -> exp_dob_val));
            }else if(C2 == 'I'){
                result = ((child1 -> exp_int_val) < (child2 -> exp_int_val));
            }
        }
        this -> exp_bool_val = result;
        return;
    }
    else if(op == ">=") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            // EXPERIMENTAL
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        bool result;
        if(C1 == 'D'){
            if(C2 == 'D'){
                result = ((child1 -> exp_dob_val) >= (child2 -> exp_dob_val));
            }else if(C2 == 'I'){
                result = ((child1 -> exp_dob_val) >= (child2 -> exp_int_val));
            }
        }else if(C1 == 'I'){
            if(C2 == 'D'){
                result = ((child1 -> exp_int_val) >= (child2 -> exp_dob_val));
            }else if(C2 == 'I'){
                result = ((child1 -> exp_int_val) >= (child2 -> exp_int_val));
            }
        }
        this -> exp_bool_val = result;
    }
    else if(op == "<=") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            // EXPERIMENTAL
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        bool result;
        if(C1 == 'D'){
            if(C2 == 'D'){
                result = ((child1 -> exp_dob_val) <= (child2 -> exp_dob_val));
            }else if(C2 == 'I'){
                result = ((child1 -> exp_dob_val) <= (child2 -> exp_int_val));
            }
        }else if(C1 == 'I'){
            if(C2 == 'D'){
                result = ((child1 -> exp_int_val) <= (child2 -> exp_dob_val));
            }else if(C2 == 'I'){
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
            if(C1 == 'N' || C2 == 'N'){
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
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
        }
    }
    else if(op == "==") {
        if((C1 == 'B' && C2 == 'B') || ((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) || (C1 == 'N' && C2 == 'N')) {
            this -> datatype = "boolean";
            bool result;
            if(C1 == 'N' || C2 == 'N'){
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
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
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
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
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
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
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
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
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
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
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
            cout << "ERROR: Operator \'" << op << "\' is not compatible with data types (" << dt1 << ") and (" <<dt2 << "). Line No.: " << child1 -> line_no << endl;
            exit(1);
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

        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            // REPORT ERROR HERE ONLY
            cout << "ERROR: Illegal use of '+' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
        this -> datatype = this -> get_maxtype(dt1, dt2);
        if(dt1 != this->datatype){
            child1 -> typecast_to = this -> datatype;
        }
        if(dt2 != this->datatype){
            child2 -> typecast_to = this -> datatype;
        }
        return;
    }
    else if(op == "-") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '-' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
        
        this -> datatype = this->get_maxtype(dt1, dt2);
        if(dt1 != this->datatype){
            child1 -> typecast_to = this -> datatype;
        }
        if(dt2 != this->datatype){
            child2 -> typecast_to = this -> datatype;
        }
        return;
    }
    else if(op == "*") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '*' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = this->get_maxtype(dt1, dt2);
        if(dt1 != this->datatype){
            child1 -> typecast_to = this -> datatype;
        }
        if(dt2 != this->datatype){
            child2 -> typecast_to = this -> datatype;
        }
        return;
    }
    else if(op == "/") {
        if(!((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D'))) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '/' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = this->get_maxtype(dt1, dt2);
        if(dt1 != this->datatype){
            child1 -> typecast_to = this -> datatype;
        }
        if(dt2 != this->datatype){
            child2 -> typecast_to = this -> datatype;
        }
        return;
    }
    else if(op == "%") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '%' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = this -> get_maxtype(dt1, dt2);
        if(dt1 != this->datatype){
            child1 -> typecast_to = this -> datatype;
        }
        if(dt2 != this->datatype){
            child2 -> typecast_to = this -> datatype;
        }
        return;
    }
    else if(op == "++" || op == "--") {
        if(!(C1 == 'I' || C1 == 'D')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '"<< op <<"' operator with operands " << dt1 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = child1 -> datatype;
        return;
    }
    else if(op == "~") {
        if(!(C1 == 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '~' operator with operands " << dt1 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = dt1;
        return;
    }
    else if(op == "!") {
        if(dt1 != "boolean") {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '!' operator with operands " << dt1 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
        this -> datatype = "boolean";
        return;
    }
    else if(op == "<<") {
        if(!(C1 == 'I') || !(C2 == 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '<<' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
        this -> datatype = dt1; // type is same as the left hand operand
        return;
    }
    else if(op == ">>") {
        if(!(C1 == 'I') || !(C2 == 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '>>' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = dt1; // type is same as the left hand operand
        return;
    }
    else if(op == ">>>") {
        if(!(C1 == 'I') || !(C2 == 'I')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '>>>' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = dt1; // type is same as the left hand operand
        return;
    }
    else if(op == ">") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '>' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        string tmp = get_maxtype(dt1, dt2);
        if(dt1 != tmp){
            child1 -> typecast_to = tmp;
        }
        if(dt2 != tmp){
            child2 -> typecast_to = tmp;
        }
        return;
    }
    else if(op == "<") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '<' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        string tmp = get_maxtype(dt1, dt2);
        if(dt1 != tmp){
            child1 -> typecast_to = tmp;
        }
        if(dt2 != tmp){
            child2 -> typecast_to = tmp;
        }
        return;
    }
    else if(op == ">=") {
        if((dt1 != "double" && dt1 != "float" && dt1 != "long" && dt1 != "int" && dt1 != "char") || (dt2 != "double" && dt2 != "float" && dt2 != "long" && dt2 != "int" && dt2 != "char")) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '>=' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        string tmp = get_maxtype(dt1, dt2);
        if(dt1 != tmp){
            child1 -> typecast_to = tmp;
        }
        if(dt2 != tmp){
            child2 -> typecast_to = tmp;
        }
        return;
    }
    else if(op == "<=") {
        if((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '<=' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }

        this -> datatype = "boolean";
        string tmp = get_maxtype(dt1, dt2);
        if(dt1 != tmp){
            child1 -> typecast_to = tmp;
        }
        if(dt2 != tmp){
            child2 -> typecast_to = tmp;
        }
        return;
    }
    else if(op == "==") {
        if(C1 == 'B' && C2 == 'B') {
            this -> datatype = "boolean";
            return;
        }
        else if(((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) || (C1 == 'N' && C2 == 'N')){
            this -> datatype = "boolean";
            string tmp = get_maxtype(dt1, dt2);
            if(dt1 != tmp){
                child1 -> typecast_to = tmp;
            }
            if(dt2 != tmp){
                child2 -> typecast_to = tmp;
            }
            return;
        }
        else {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '==' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
    }
    else if(op == "!=") {
        if(C1 == 'B' && C2 == 'B') {
            this -> datatype = "boolean";
            return;
        }
        else if(((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) || (C1 == 'N' && C2 == 'N')){
            this -> datatype = "boolean";
            string tmp = get_maxtype(dt1, dt2);
            if(dt1 != tmp){
                child1 -> typecast_to = tmp;
            }
            if(dt2 != tmp){
                child2 -> typecast_to = tmp;
            }
            return;
        }   
        else {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '!=' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
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
            if(dt1 != this -> datatype){
                child1 -> typecast_to = this -> datatype;
            }
            if(dt2 != this -> datatype){
                child2 -> typecast_to = this -> datatype;
            }
            return;
        }
        else {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '&' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
    }
    else if(op == "|") {
        if((C1 == 'B' && C2 == 'B')) {
            this -> datatype = "boolean";
            return;
        }
        else if ((C1 == 'I' && C2 == 'I')) {
            this -> datatype = this -> get_maxtype(dt1, dt2);
            if(dt1 != this -> datatype){
                child1 -> typecast_to = this -> datatype;
            }
            if(dt2 != this -> datatype){
                child2 -> typecast_to = this -> datatype;
            }
            return;
        }
        else {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '|' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
    }
    else if(op == "^") {
        if((C1 == 'B' && C2 == 'B')) {
            this -> datatype = "boolean";
            return;
        }
        else if ((C1 == 'I' && C2 == 'I')) {
            this -> datatype = this -> get_maxtype(dt1, dt2);
            if(dt1 != this -> datatype){
                child1 -> typecast_to = this -> datatype;
            }
            if(dt2 != this -> datatype){
                child2 -> typecast_to = this -> datatype;
            }
            return;
        }
        else {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '^' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
    }
    else if(op == "&&") {
        if(C1 == 'B' && C2 == 'B') {
            this -> datatype = "boolean";
            return;
        }
        else {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '&&' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
    }
    else if(op == "||") {
        if(C1 == 'B' && C2 == 'B') {
            this -> datatype = "boolean";
            return;
        }
        else {
            this -> datatype = "ERROR";
            cout << "ERROR: Illegal use of '||' operator with operands " << dt1 << " and " << dt2 << " at line number: " << child1 -> line_no << endl;
            exit(1);
        }
    }
    else if(op == "=") {
        if((C1 == 'I' || C1 == 'D') && (C2 == 'I' || C2 == 'D')) {
            if(get_maxtype(dt1, dt2) != dt1) {
                if(child2 -> exp_is_constant) {
                    if(overflow_check(dt1, child2)) {
                        cout << "ERROR: Lossy conversion from (" << dt2 << ") to (" << dt1 << ") at line number: " << this -> line_no << endl;
                        exit(1);
                    }
                }
                else {
                    cout << "ERROR: Lossy conversion from (" << dt2 << ") to (" << dt1 << ") at line number: " << this -> line_no << endl;
                    exit(1); 
                }
            }
            if(child1 -> datatype != child2 -> datatype) {
                child2 -> typecast_to = child1 -> datatype;
            }
        }
        else {
            if(dt1 != dt2) {
                cout << "ERROR: Invalid conversion from (" << dt2 << ") to (" << dt1 << ") at line number: " << this -> line_no << endl;
                exit(1);
            }
        }
    }
    else if(op == "+=") {
        this -> calc_datatype(child1, child2, "+");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
    else if(op == "-=") {
        this -> calc_datatype(child1, child2, "-");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
    else if(op == "*=") {
        this -> calc_datatype(child1, child2, "*");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
    else if(op == "/=") {
        this -> calc_datatype(child1, child2, "/");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
    else if(op == "%=") {
        this -> calc_datatype(child1, child2, "%");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
    else if(op == "<<=") {
        this -> calc_datatype(child1, child2, "<<");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
    else if(op == ">>=") {
        this -> calc_datatype(child1, child2, ">>");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
    else if(op == ">>>=") {
        this -> calc_datatype(child1, child2, ">>>");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }   
    else if(op == "&=") {
        this -> calc_datatype(child1, child2, "&");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
    else if(op == "^=") {
        this -> calc_datatype(child1, child2, "^");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
    else if(op == "|=") {
        this -> calc_datatype(child1, child2, "|");
        if(child1 -> datatype != child2 -> datatype) {
            child2 -> typecast_to = child1 -> datatype;
        }
    }
}

void node::obtain_function_parameters(vector<string> &params) {
    for(auto &child : this -> children) {
        if(this -> name == "Expression") {
            if(this -> typecast_to != "UNNEEDED"){
                params.push_back(this -> typecast_to);
            }else{
                params.push_back(this -> datatype);
            }
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
        if(child -> name == "Block" || child -> name == "ClassBody"){
            child -> type_check();
        }else{
            child -> chill_traversal();
        }
    }
}

bool node::overflow_check(string datatype, node* exp) {
    if(exp -> get_datatype_category() != 'I') {
        return true;
    }
    
    long long int val = exp -> exp_int_val; 
    if(datatype == "byte") {
        if(val < -128 || val > 127 ) return true;
    }
    else if(datatype == "short") {
        if(val < -32768 || val > 32767 ) return true;
    }
    else if(datatype == "char") {
        if(val < 0 || val > 65535 ) return true;   
    }
    else if(datatype == "int") {
        if(val < -2147483648 || val > 2147483647 ) return true;
    }
    
    return false;
} 

void node::type_check() {
    if(this -> type_checked){
        return;
    }
    this -> type_checked = true;

    // after execution of this function at a particular node, its datatype should be correctly populated
    for(auto &child : this -> children) {
        child -> type_check();
    }

    if(this -> type == "ID") {                     // setting identifier types (from the symbol table)
        st_entry* tmp = this -> get_and_look_up();

        if(tmp) {
            this -> datatype = tmp -> type;
        }
    }
    else if(this -> name == "#Name#") {
        symbol_table_class* cls = NULL;
        st_entry* entry = NULL;

        int idx = 0;

        cls = ((symbol_table_class*) this -> get_symbol_table());
        entry = cls -> look_up(this -> children[idx] -> name);
        if(!entry){
            cout << "ERROR: (" << this -> children[idx] -> name <<") was not declared in this scope." << endl;
            exit(1); 
        }
        string type_without_array = get_type_without_array(entry -> type);
        
        cls = main_table -> look_up_class(type_without_array);
        
        for(idx = 0; idx + 3 <= this -> children.size(); idx += 2){
            if(idx + 3 < this -> children.size()){
                entry = cls -> look_up(this -> children[idx + 2] -> name);
                if(!entry){
                    cout << "ERROR: (" << this -> children[idx] -> name << ") does not have (" << this -> children[idx + 2] -> name << ") as a member. Line number: " << this -> children[idx] -> line_no << endl;
                    exit(1);
                }
                type_without_array = get_type_without_array(entry -> type);
                cls = main_table -> look_up_class(type_without_array);
                if(!cls){
                    cout << "Unknown type error occurred due to ";
                    for(int i = 0; i <= idx + 2; i++){
                        cout << this -> children[i] -> name;
                    }
                    cout << " at line number " << this -> children[idx + 2] -> line_no << endl;
                    exit(1);
                }
                this -> children[idx + 2] -> datatype = entry -> type;
            }else{
                if(this -> parent -> name == "MethodInvocation"){
                    this -> parent -> children[1] -> type_check();
                    vector<string> func_params = this -> parent -> children[1] -> get_function_parameters();
                    string func_name = this -> children[this -> children.size() - 1] -> name;
                    symbol_table_func* sfunc = ((symbol_table_class* ) cls) -> look_up_function(this -> children[idx + 2] -> name, func_params);
                    
                    // FIRST CHECK FOR EXACT FUNCTION THEN CASTABLE MATCHING SHIFTED TO LOOK UP FUNC //
                    
                    if(!sfunc){
                        cout << "ERROR: (" << this -> children[idx] -> name << ") does not have (" << this -> children[idx + 2] -> name << ") as a member. Line number: " << this -> children[idx] -> line_no << endl;
                        exit(1);
                    }
                    this -> children[idx + 2] -> datatype = sfunc -> return_type;
                }
                else{
                    entry = cls -> look_up(this -> children[idx + 2] -> name);
                    if(!entry){
                        cout << "ERROR: (" << this -> children[idx] -> name << ") does not have (" << this -> children[idx + 2] -> name << ") as a member. Line number: " << this -> children[idx] -> line_no << endl;
                        exit(1);
                    }
                    this -> children[idx + 2] -> datatype = entry -> type;
                }
                break;
            }
        }

        this -> datatype = this -> children[idx + 2] -> datatype;
        return;
    }
    else if(this -> name == "FieldAccess") {        // invocations of the form this.var
        for(auto &child : this -> children) {
            if(child -> type == "ID") {              // get the field name
                symbol_table* cnt_table = this -> get_symbol_table();
                if(!cnt_table) {
                    cout << "Unknown Error! Symbol table does not exist for field access node..." << endl;
                    exit(1);
                }

                while(cnt_table && cnt_table -> symbol_table_category != 'C') {
                    cnt_table = cnt_table -> parent_st;
                }

                cnt_table = (symbol_table_class *) cnt_table;
                bool flag = false;
                for(auto &entry : cnt_table -> entries) {
                    if(entry -> name == child -> name) {
                        flag = true;
                        this -> datatype = entry -> type; 
                        break;
                    }
                } 

                if(!flag) {
                    cout << "ERROR: Unknown field access (" + child -> name + ") at line number " << child -> line_no << endl;
                    exit(1);
                }

            } 
        }
    }
    else if(this -> name == "ArrayAccess") {        // checking array accesses
        for(auto &child : this -> children) {
            if(child -> name == "Expression") {
                if(child -> get_datatype_category() != 'I' || child->datatype == "long") {
                    cout << "ERROR: Array index expression should be of type (int), but found (" << child -> datatype << ") at line number " << child -> line_no << endl;
                    exit(1);                    
                }
            }
        }

        string tmp = this -> children[0] -> datatype;
        if(tmp[(int)(tmp.size()) - 1] != ']') {
            // EXPERIMENTAL
            cout << "ERROR: Array required but " << tmp << " found. Possibly accessing more dimensions than permissible at line number: " << this -> children[0] -> line_no << endl;
            exit(1);
        }
        else {
            this -> datatype = tmp.substr(0, tmp.size() - 2);
        }
    }
    else if(this -> name == "ArrayCreationExpression") {
        if(this -> children[1]) {
            this -> datatype = this -> children[1] -> name;
        }
        else {
            cout << "Unknown error, ArrayCreationExpression child not found!" << endl;
            exit(1);
        }

        for(int i = 0; i < this -> sym_tab_entry -> dimensions; i++) {
            this -> datatype += "[]";
        }
    }
    else if(this -> name == "DimExpr") {
        if(!this -> children[1]) {
            cout << "Unknown error, DimExpr child not found!" << endl;
            exit(1);
        }
        if(get_datatype_category(this -> children[1] -> datatype) != 'I') {
            cout << "ERROR: Array index expression should be of type (int), but found (" << this -> children[1] -> datatype << ") at line number " << this -> line_no << endl;
            exit(1);
        }
        else {
            if(this -> get_maxtype(this -> children[1] -> datatype, "int") != "int") {
                cout << "ERROR: Array index expression should be of type (int), but found (" << this -> children[1] -> datatype << ") at line number " << this -> line_no << endl;
                exit(1);
            }
        }

        if(this -> children[1] -> datatype != "int") {
            this -> children[1] -> typecast_to = "int";
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
                cout << "ERROR: Non-void function returns nothing at line number: " << this -> children[0] -> line_no << endl;
                exit(1);
            }
        }else if(this -> children.size() == 2){
            if(return_type != this -> children[1] -> datatype){
                cout << "ERROR: Function (" << tmp->name << ") returns (" << this -> children[1] -> datatype << ") type at line number (" << this -> children[1] -> line_no << "), but expected (" << return_type << ")" << endl;
                exit(1);
            }
        }
    }
    else if(this -> name == "PreIncrementExpression" || this -> name == "PreDecrementExpression") {
        if(!(this -> children[1] -> type == "ID" || this -> children[1] -> name == "#Name#")) {
            cout << "ERROR: '"<< this -> children[0] -> name <<"' can only operate on variables at line number: " << this -> children[0] -> line_no << endl;
            exit(1);
        }

        this -> calc_datatype(this -> children[1], NULL, this -> children[0] -> name);
        this -> type = "LITERAL";
    }
    else if(this -> name == "PostIncrementExpression" || this -> name == "PostDecrementExpression") {
        if(!(this -> children[0] -> type == "ID" || this -> children[0] -> name == "#Name#")) {
            cout << "ERROR: '"<< this -> children[1] -> name <<"' can only operate on variables at line number: " << this -> children[0] -> line_no << endl;
            exit(1);
        }
        
        this -> calc_datatype(this -> children[0], NULL, this -> children[1] -> name);
        this -> type = "LITERAL";
    }
    else if(this -> name == "CastExpression"){
        string dt1 = this -> children[1] -> name, dt2 = this -> children[3] -> datatype;
        if(!(this -> find_cast(dt1, dt2))){
            cout << "ERROR: Cannot cast " << dt2 << " into " << dt1 << ". Line number: " << this -> children[1] -> line_no << endl;
            exit(1);
        }

        this -> datatype = dt1;     // propagate the datatype upwards
        this -> type = "LITERAL";   // Casted expression becomes a literal
    }
    else if(this -> name == "MethodInvocation") {   // method invocation parameter checking
        // only tackling Identifier BracketArgumentList for now
        vector<string> func_params;
        string func_name;
        symbol_table_class* class_table;
        
        for(auto &child : this -> children) {
            if(child -> name == "BracketArgumentList") {
                func_params = child -> get_function_parameters();
            }
            else if(child -> name == "#Name#") {
                // Assuming that it is valid, just need to get the function's return type

                class_table = main_table -> look_up_class(child -> children[0] -> datatype);

                if(class_table == NULL){
                    cout << "ERROR: Unknown Error occurred at line number: " << child -> children[0] -> line_no << endl;
                    exit(1);
                }

                int idx;
                for(idx = 0; idx + 3 < child -> children.size(); idx += 2){
                    st_entry* found_entry = class_table -> look_up(child -> children[idx + 2] -> name);

                    if(found_entry == NULL){
                        cout << "ERROR: Could not find (" << child -> children[idx + 2] -> name << ") in (" << child -> children[idx] -> name << ")'s members. Line number: " << child -> children[idx] -> line_no << endl;
                        exit(1);
                    }else{
                        string type_without_array = get_type_without_array(found_entry -> type);
                        class_table = main_table -> look_up_class(type_without_array);
                        if(class_table == NULL){
                            cout << "ERROR: Unknown Error occurred at line number: " << child -> children[idx] -> line_no << endl;
                            exit(1);
                        }
                    }
                }
                func_name = child -> children[idx + 2] -> name;
            }
            else if(child -> type == "ID") {
                func_name = child -> name;
                class_table = this -> get_symbol_table_class();
            }
        }

        if(!class_table -> look_up_function(func_name, func_params)) {
            cout << "ERROR: Unknown method invocation of (" << func_name << ") with arg-types (";
            {
                bool first = true;
                for(const auto (&param) : func_params){
                    if(first){
                        cout << param;
                        first = false;
                    }
                    else{
                        cout << ", " << param;
                    }
                }
            }
            cout <<") at line number: " << this->line_no << endl; // ! Tanwar print parameters
            exit(1);
        }

        // FIRST CHECK FOR EXACT FUNCTION THEN CASTABLE MATCHING SHIFTED TO LOOK UP FUNC //
    }
    else if (this -> name == "UnqualifiedClassInstanceCreationExpression") {
        vector<string> constructor_params;
        string class_name;
        symbol_table_class* class_table;
        
        for(auto &child : this -> children) {
            if(child -> name == "BracketArgumentList") {
                constructor_params = child -> get_function_parameters();
            }
            else if(child -> name == "#Name#") {
                // @TODO Tanwar
            }
            else if(child -> type == "ID") {
                class_name = child -> name;  // should be class name for constructor
                class_table = main_table -> look_up_class(class_name);
                if(!class_table) {
                    cout << "ERROR: Unknown call to constructor at line number: " << child -> line_no << endl;
                    exit(1);
                }
            }
        }

        bool match_found = false;
        for(auto &func : class_table -> member_funcs) {
            bool flag = true;
            if(class_name == func -> name && constructor_params.size() == func -> params.size()) {
                flag = false;
                for(int idx = 0; idx < constructor_params.size(); idx++) {
                    if((this -> get_datatype_category(constructor_params[idx]) == 'I' || this -> get_datatype_category(constructor_params[idx]) == 'D') && (this -> get_datatype_category(func -> params[idx] -> type) == 'I' || this -> get_datatype_category(func -> params[idx] -> type) == 'D')) {
                        if(this -> get_maxtype(constructor_params[idx], func -> params[idx] -> type) != func -> params[idx] -> type) {
                            flag = true;
                            break;
                        }
                    }
                    else {
                        if(constructor_params[idx] != func -> params[idx] -> type) {
                            flag = true;
                            break;
                        }
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
            cout << "ERROR: Unknown constructor invocation of class (" << class_name << ") with arg-types (";
            {
                bool first = true;
                for(const auto (&param) : constructor_params){
                    if(first){
                        cout << param;
                        first = false;
                    }
                    else{
                        cout << ", " << param;
                    }
                }
            }
            cout <<") at line number: " << this->line_no << endl;
            exit(1);
        }
    }
    else if (this -> name == "VariableDeclarator") {        // Variable declaration and initialization
        if(this -> children[1] && this -> children[1] -> name == "=") {     // Declaration and initialization
            if((get_datatype_category(this -> sym_tab_entry -> type) == 'I' || get_datatype_category(this -> sym_tab_entry -> type) == 'D') && (get_datatype_category(this -> children[1] -> datatype) == 'I' || get_datatype_category(this -> children[1] -> datatype) == 'D')) {
                if(get_maxtype(this -> sym_tab_entry -> type, this -> children[1] -> datatype) != this -> sym_tab_entry -> type) {
                    if(this -> children[1] -> children[0] && this -> children[1] -> children[0] -> name == "Expression" && this -> children[1] -> children[0] -> exp_is_constant) {  // perform overflow checks if the LHS is constant
                        if(this -> overflow_check(this -> sym_tab_entry -> type, this -> children[1] -> children[0])) {
                            cout << "ERROR: Lossy conversion between " << this -> sym_tab_entry -> type << " and " << this -> children[1] -> datatype << " at line number: " << this -> line_no << endl;
                            exit(1);
                        }
                    }
                    else {
                        cout << "ERROR: Lossy conversion between " << this -> sym_tab_entry -> type << " and " << this -> children[1] -> datatype << " at line number: " << this -> line_no << endl;
                        exit(1);
                    }
                }
            }
            else if(this -> sym_tab_entry -> type != this -> children[1] -> datatype) {
                cout << "ERROR: Type mismatch between " << this -> sym_tab_entry -> type << " and " << this -> children[1] -> datatype << " at line number: " << this -> line_no << endl;
                exit(1);
            } 
        }
    }
    else if(this -> type == "OPERATOR") {
        if(this -> children.size() == 1){
            if(this -> name == "="|| this -> name == "+" || this -> name == "-") {     // unary operations
                this -> datatype = this -> children[0] -> datatype;
            }
            else {
                this -> calc_datatype(this -> children[0]);
            }
        }
        else if(this -> children.size() == 2){
            this -> calc_datatype(this -> children[0], this -> children[1], this -> name);
        }
        else if(this -> children.size() == 3){
            // @TODO TERNARY TO BE DEALT WITH
            this -> calc_datatype(this -> children[1], this -> children[2], "+");
        }
    }
    else if(this -> name == "IfThenStatement" || this -> name == "IfThenElseStatement" || this -> name == "IfThenElseStatementNoShortIf") {
        if(this -> children[2] && this -> children[2] -> datatype != "boolean") {
            cout << "ERROR: Expression inside if statement should be boolean but received " << this -> children[2] -> datatype << " instead. Line number: " << this -> children[2] -> line_no << endl;
            exit(1);
        }
    }
    else if(this -> name == "BasicForStatement" || this -> name == "BasicForStatementNoShortIf") {
        for(const auto &child : this -> children) {
            if(child -> name == "Expression" || child -> name == "qExpression") {
                if(child -> datatype != "boolean") {
                    cout << "ERROR: Expression inside updation of for statement should be boolean but received " << this -> children[2] -> datatype << " instead. Line number: " << this -> children[2] -> line_no << endl;
                    exit(1);
                }
            }
        }
    }
    else if(this -> name == "EnhancedForStatement" || this -> name == "EnhancedForStatementNoShortIf") {
        this -> calc_datatype(this -> children[2], this -> children[4], "=");
        // First Side Effect : this -> children[4] now possibly has typecast_to field set
        this -> datatype = "UNDEFINED";     // Second Side Effect
    }
    else if(this -> name == "WhileStatement" || this -> name == "WhileStatementNoShortIf") {
        if(this -> children[2] -> datatype != "boolean"){
            cout << "ERROR: Expression inside updation of while statement should be boolean but received " << this -> children[2] -> datatype << " instead. Line number: " << this -> children[2] -> line_no << endl;
            exit(1);
        }
    }
    else if(this -> name == "DoStatement") {
        if(this -> children[4] -> datatype != "boolean"){
            cout << "ERROR: Expression inside updation of do-while statement should be boolean but received " << this -> children[2] -> datatype << " instead. Line number: " << this -> children[2] -> line_no << endl;
            exit(1);
        }
    }
    else {
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
}

int node::get_access_depth(string dt) {
    int depth = 0;
    for(char ch : dt) {
        depth += (ch == '[');
    }

    return depth;
}

// WALK 4 : GENERATE 3AC

string node::get_var_from_node(){
    /*
    if(this -> name == "#Name#"){
        string s = "";
        for(auto (&child) : this -> children){
            s += child -> name;
        }
        return s;
    }
    else*/ if(this -> type == "ID" || (this -> type == "LITERAL" && this -> children.size() == 0)){
        return this -> name;
    }
    
    return "##t" + to_string(this -> node_number);
}

void node::append_tac(vector<quad> (&tacs)){
    for(auto (&tac) : tacs){
        this -> ta_codes.push_back(tac);
    }
    tacs.clear();
}

void node::append_tac(node* v){
    for(auto (&tac) : v -> ta_codes){
        this -> ta_codes.push_back(tac);
    }
    v -> ta_codes.clear();
}

vector<string> node::get_func_args_tac(){
    vector<string> args;
    if(this -> name == "Expression"){
        args.push_back(this -> get_var_from_node());
        return args;
    }
    for(auto (&child) : this -> children){
        vector<string> temp = child -> get_func_args_tac();
        for(const auto (&s) : temp){
            args.push_back(s);
        }
    }
    return args;
}

st_entry* node::get_and_look_up_from_name() {
    if(this -> name != "#Name#") {
        cout << "Error! Calling lookup name from a non-name node. Aborting...";
        exit(1); 
    }

    symbol_table_class* prev_class = NULL;
    symbol_table_class* cnt_class = NULL;
    st_entry *nxt_obj = NULL;
    
    for(int cur = 0; cur + 2 < this -> children.size(); cur += 2){
        int nxt = cur + 2;

        st_entry* cur_obj;
        if(!prev_class) {
            cur_obj = this -> get_and_look_up(this -> children[cur] -> name);
        }
        else {
            cur_obj = prev_class -> look_up(this -> children[cur] -> name);    
        }
        cnt_class = main_table -> look_up_class(cur_obj -> type);
        nxt_obj = cnt_class -> look_up(this -> children[nxt] -> name);

        prev_class = cnt_class;
    }

    return nxt_obj;
}

string node::get_mangled_name() {
    if(this -> name != "UnqualifiedClassInstanceCreationExpression" && this -> name != "MethodInvocation" && this -> name != "MethodDeclaration" && this -> name != "ConstructorDeclaration") {
        cout << "Unknown error! Mangled name called from unknown node. Aborting...";
        exit(1);
    }

    string mangled_name = "";
    if(this -> name == "UnqualifiedClassInstanceCreationExpression" || this -> name == "MethodInvocation") {
        vector<string> func_params;
        string func_name;
        string class_name;

        for(auto &child : this -> children) {
            if(child -> name == "BracketArgumentList") {
                func_params = child -> get_function_parameters();
            }
            else if(child -> type == "ID") {
                func_name = child -> name;
                class_name = this -> get_symbol_table_class() -> name;
            }
            else if(child -> name == "#Name#") {
                func_name = child -> children[child -> children.size() - 1] -> name;        // last child of name is the function name
                class_name = child -> children[child -> children.size() - 3] -> datatype;
            }
        }

        symbol_table_func* func = main_table -> look_up_class(class_name) -> look_up_function(func_name, func_params);

        for(int i = func -> params.size() - 1; i >= 0; i--) {
            mangled_name = "@" + (func -> params[i] -> type) + mangled_name; 
        }
        mangled_name = func_name + mangled_name;
        mangled_name = class_name + "?" + mangled_name;
    }
    else {
        for(int i = this -> entry_list.size() - 1; i >= 0; i--) {
            mangled_name = "@" + this -> entry_list[i] -> type + mangled_name;
        }
        mangled_name = this -> sym_tab_entry -> name + mangled_name;

        mangled_name = this -> sym_tab -> parent_st -> name + "?" + mangled_name;
    }

    return mangled_name;
}

void node::get_dimension_dfs(st_entry *arr) {
    if(this -> name == "DimExpr") {
        arr -> dim_sizes . push_back(this -> get_var_from_node());
        return;
    }

    for(auto &child : this -> children) {
        child -> get_dimension_dfs(arr);
    }
}

void node::get_dimension_variables(st_entry *arr) {
    if(this -> name != "ArrayCreationExpression") {
        cout << "Error! Get Dimension variable called from unknown node. Aborting...";
        exit(1);
    }

    arr -> dim_sizes . clear();     // for redclarations of array, remove all the previous dimension variables
    for(auto &child : this -> children) {
        child -> get_dimension_dfs(arr);
    }
}

void node::generate_tac(){
    for(auto (&child) : this -> children){
        child -> generate_tac();
    }


    // cout << this -> name << " " << " tick" << endl;
    if(this -> type == "ID" || (this -> type == "LITERAL" && this -> children.size() == 0)) {        
        // Add typecast if need be
        if(this -> typecast_to != "UNNEEDED" && this -> typecast_to != ""){
            string op = this -> typecast_to;
            string result = this -> get_var_from_node();
            string arg1 = this -> get_var_from_node();
            quad q(result, arg1, op, "");
            q.make_code_from_cast();
            this -> ta_codes.push_back(q);
        }
        return;
    }
    else if(this -> name == "#Name#"){
        quad q("", "", "", "");
        int isMethodInvocation = 0;

        // Check if this is a method invocation, if so, skip the last access
        if(this -> parent -> name == "MethodInvocation") isMethodInvocation = 1;

        // Assign address of first object
        q.result = this -> get_var_from_node();
        q.arg1 = this -> children[0] -> get_var_from_node();
        q.op = "=";
        q.make_code_from_assignment();
        this -> ta_codes.push_back(q);

        symbol_table_class* prev_class = NULL;
        symbol_table_class* cnt_class = NULL;
        
        for(int cur = 0; cur + 2 < this -> children.size() - isMethodInvocation; cur += 2){
            int nxt = cur + 2;

            st_entry* cur_obj;
            if(!prev_class) {
                cur_obj = this -> get_and_look_up(this -> children[cur] -> name);
            }
            else {
                cur_obj = prev_class -> look_up(this -> children[cur] -> name);    
            }
            cnt_class = main_table -> look_up_class(cur_obj -> type);
            st_entry *nxt_obj = cnt_class -> look_up(this -> children[nxt] -> name);

            // Add offset of next object in current object
            q.arg1 = q.result;
            q.arg2 = to_string(nxt_obj -> offset);
            q.op = "*()";
            q.make_code_from_load();
            this -> ta_codes.push_back(q);
            
            // q.op = "+";
            // q.make_code_from_binary();
            // this -> ta_codes.push_back(q);

            // // De-reference to get address of next object
            // q.arg2 = "";
            // q.op = "*()";
            // q.make_code_from_load();
            // this -> ta_codes.push_back(q);

            prev_class = cnt_class;
        }

        // De-reference to obtain value of last object
        q.arg2 = "";
        q.make_code_from_load();
        this -> ta_codes.push_back(q);
        
        if(this -> typecast_to != "UNNEEDED" && this -> typecast_to != ""){
            string op = this -> typecast_to;
            string result = this -> get_var_from_node();
            string arg1 = this -> get_var_from_node();
            quad q(result, arg1, op, "");
            q.make_code_from_cast();
            this -> ta_codes.push_back(q);
        }
    }
    else if(this -> name == "continue" && this -> type == "KEYWORD") {
        string op = "goto";
        string arg1 = "CONTINUE";
        quad q("", arg1, op, "");

        q.code = "\t\tgoto CONTINUE;\n";
        q.made_from = quad::GOTO;

        this -> ta_codes.push_back(q);
    }
    else if(this -> name == "break" && this -> type == "KEYWORD") {
        string op = "goto";
        string arg1 = "BREAK";
        quad q("", arg1, op, "");

        q.code = "\t\tgoto BREAK;\n";
        q.made_from = quad::GOTO;

        this -> ta_codes.push_back(q);
    }
    else if(this -> name == "Expression") {
        string op = "=";
        string result = this -> get_var_from_node();
        string arg1 = this -> children[0] -> get_var_from_node();
        quad q(result, arg1, op, "");
        q.make_code_from_assignment();

        this -> append_tac(this -> children[0]);
        this -> ta_codes.push_back(q);

        if(this -> typecast_to != "UNNEEDED" && this -> typecast_to != ""){
            string op = this -> typecast_to;
            string result = this -> get_var_from_node();
            string arg1 = this -> get_var_from_node();
            quad q(result, arg1, op, "");
            q.make_code_from_cast();
            this -> ta_codes.push_back(q);
        }
        return;
    }
    else if(this -> name == "PrimaryNoNewArray") {
        if(this -> children.size() == 1 && this -> children[0] -> type == "LITERAL"){
            string op = "=";
            string result = this -> get_var_from_node();
            string arg1 = this -> children[0] -> get_var_from_node();
            quad q(result, arg1, op, "");
            q.make_code_from_assignment();
            this -> ta_codes.push_back(q);
        }
        else if(this -> children.size() == 3 && this -> children[1] -> name == "Expression"){
            this -> append_tac(this -> children[1]);

            string op = "=";
            string result = this -> get_var_from_node();
            string arg1 = this -> children[1] -> get_var_from_node();
            quad q(result, arg1, op, "");
            q.make_code_from_assignment();
            this -> ta_codes.push_back(q);
        }
    }
    else if(this -> name == "IfThenStatement"){
        this -> append_tac(this -> children[2]);

        string op = "if_false";
        string arg1 = this -> children[2] -> get_var_from_node();
        string arg2 = "J+" + to_string(this -> children[4] -> ta_codes.size() + 1);
        quad q("", arg1, op, arg2);
        q.make_code_from_conditional();

        this -> ta_codes.push_back(q);      // add the jump statement
        this -> append_tac(this -> children[4]);
    }
    else if(this -> name == "IfThenElseStatement" || this -> name == "IfThenElseStatementNoShortIf") {
        this -> append_tac(this -> children[2]);

        string op = "if_false";
        string arg1 = this -> children[2] -> get_var_from_node();
        string arg2 = "J+" + to_string(this -> children[4] -> ta_codes.size() + 2);
        quad q("", arg1, op, arg2);
        q.make_code_from_conditional();

        this -> ta_codes.push_back(q);
        this -> append_tac(this -> children[4]);

        op = "goto";
        arg1 = "J+" + to_string(this -> children[6] -> ta_codes.size() + 1);
        quad q2("", arg1, op, "");
        q2.make_code_from_goto();

        this -> ta_codes.push_back(q2);
        this -> append_tac(this -> children[6]); 
    }
    else if(this -> name == "WhileStatement" || this -> name == "WhileStatementNoShortIf") {
        int exp_size = this -> children[2] -> ta_codes.size();
        int stat_size = this -> children[4] -> ta_codes.size();

        this -> append_tac(this -> children[2]);

        string op = "if_false";
        string arg1 = this -> children[2] -> get_var_from_node();
        string arg2 = "J+" + to_string(stat_size + 2);
        quad q("", arg1, op, arg2);
        q.make_code_from_conditional();

        this -> ta_codes.push_back(q);

        for(int i = 0; i < this -> children[4] -> ta_codes.size(); i++){
            auto (&tac) = this -> children[4] -> ta_codes[i];
            if(tac.code == "\t\tgoto CONTINUE;\n"){
                int rel_jump = (i + this -> ta_codes.size());
                tac = quad("", "J-" + to_string(rel_jump), "goto", "");     // res, arg1, op, arg2
                tac.make_code_from_goto();
            }
            else if(tac.code == "\t\tgoto BREAK;\n") {
                int rel_jump = (this -> children[4] -> ta_codes.size() - i) + 1;
                tac = quad("", "J+" + to_string(rel_jump), "goto", "");     // res, arg1, op, arg2
                tac.make_code_from_goto();
            }
        }
        this -> append_tac(this -> children[4]);

        op = "goto";
        arg1 = "J-" + to_string(stat_size + exp_size + 1);
        quad q2("", arg1, op, "");
        q2.make_code_from_goto();

        this -> ta_codes.push_back(q2);
    }
    else if(this -> name == "DoStatement") {
        int exp_size = this -> children[4] -> ta_codes.size();
        int stat_size = this -> children[1] -> ta_codes.size();

        for(int i = 0; i < stat_size; i++){
            auto (&tac) = this -> children[1] -> ta_codes[i];
            if(tac.code == "\t\tgoto CONTINUE;\n"){
                int rel_jump = (stat_size - i);
                tac = quad("", "J+" + to_string(rel_jump), "goto", "");     // res, arg1, op, arg2
                tac.make_code_from_goto();
            }
            else if(tac.code == "\t\tgoto BREAK;\n"){
                int rel_jump = (stat_size - i) + (exp_size) + 2;
                tac = quad("", "J+" + to_string(rel_jump), "goto", "");     // res, arg1, op, arg2
                tac.make_code_from_goto();
            }
        }
        this -> append_tac(this -> children[1]);
        
        this -> append_tac(this -> children[4]);

        string op = "if_true";
        string arg1 = this -> children[4] -> get_var_from_node();
        string arg2 = "J-" + to_string(stat_size + exp_size + 1);
        quad q("", arg1, op, arg2);
        q.make_code_from_conditional();

        this -> ta_codes.push_back(q);
    }
    else if(this -> name == "BasicForStatement" || this -> name == "BasicForStatementNoShortIf"){
        int init_size = 0;
        int exp_size = 0;
        int updt_size = 0;
        
        int last_child = (int)(this -> children.size()) - 1;
        int stmt_size = this -> children[last_child] -> ta_codes . size();
        
        string op = "";
        string arg1 = "", arg2 = "";

        for(auto &(child) : this -> children){
            if(child -> name == "ForInit"){
                init_size = child -> ta_codes . size();
                this -> append_tac(child -> ta_codes);
            }
            else if(child -> name == "Expression") {
                exp_size = child -> ta_codes . size();
            }
            else if(child -> name == "ForUpdate") {
                updt_size = child -> ta_codes . size();
            }
        }

        for(auto &(child) : this -> children){
            if(child -> name == "Expression"){
                exp_size = child -> ta_codes . size();
                this -> append_tac(child -> ta_codes);
                op = "if_false";
                arg1 = child -> get_var_from_node();
                arg2 = "J+" + to_string(updt_size + stmt_size + 2);
                quad q("", arg1, op, arg2);
                q.make_code_from_conditional();

                this -> ta_codes . push_back(q);
            }
        }
        
        for(int i = 0; i < this -> children[last_child] -> ta_codes.size(); i++){
            auto (&tac) = this -> children[last_child] -> ta_codes[i];
            if(tac.code == "\t\tgoto CONTINUE;\n"){
                int rel_jump = (this -> children[last_child] -> ta_codes.size() - i);
                tac = quad("", "J+" + to_string(rel_jump), "goto", "");     // res, arg1, op, arg2
                tac.make_code_from_goto();
            }
            else if(tac.code == "\t\tgoto BREAK;\n") {
                int rel_jump = (this -> children[last_child] -> ta_codes.size() - i) + (updt_size) + 1;
                tac = quad("", "J+" + to_string(rel_jump), "goto", "");     // res, arg1, op, arg2
                tac.make_code_from_goto();
            }
        }

        this -> append_tac(this -> children[last_child] -> ta_codes);

        for(auto &(child) : this -> children){
            if(child -> name == "ForUpdate"){
                // updt_size = child -> ta_codes . size();
                this -> append_tac(child -> ta_codes);
                op = "goto";
                arg1 = "J-" + to_string(updt_size + stmt_size + exp_size + 1);
                quad q("", arg1, op, "");
                q.make_code_from_goto();
                
                this -> ta_codes.push_back(q);
            }
        }
        return;
    }
    else if(this -> name == "FieldAccess") {        // this.var type expressions
        quad q("", "", "", "");
        q.result = this -> get_var_from_node();
        q.arg1 = "this";
        q.op = "=";
        q.make_code_from_assignment();
        this -> ta_codes.push_back(q);

        string id;
        for(auto &child : this -> children) {
            if(child -> type == "ID") {
                id = child -> name;
            }
        }
        symbol_table_class* cnt_class = this -> get_symbol_table_class();
        st_entry* cnt_entry = cnt_class -> look_up(id);
        
        q.arg1 = q.result;
        q.arg2 = to_string(cnt_entry -> offset);
        q.op = "+";
        q.make_code_from_binary();
        this -> ta_codes.push_back(q);

        q.arg2 = "";
        q.op = "*()";
        q.make_code_from_load();
        this -> ta_codes.push_back(q);
    }
    else if(this -> name == "DimExpr") {
        quad q("", "", "", "");

        q.result = this -> get_var_from_node();
        q.arg1 = this->children[1]->get_var_from_node();
        q.op = "=";
        q.make_code_from_assignment();

        this -> append_tac(this -> children[1]);
        this -> ta_codes.push_back(q);

    }
    else if(this -> name == "DimExprs"){
        if(this -> children.size() == 1){
            quad q("", "", "", "");

            q.result = this -> get_var_from_node();
            q.arg1 = this->children[0]->get_var_from_node();
            q.op = "=";
            q.make_code_from_assignment();

            this -> append_tac(this -> children[0]);
            this -> ta_codes.push_back(q);
        }
        else if(this -> children.size() == 2){
            quad q("", "", "", "");

            q.result = this -> get_var_from_node();
            q.arg1 = this->children[0]->get_var_from_node();
            q.arg2 = this->children[1]->get_var_from_node();
            q.op = "*";
            q.make_code_from_binary();

            this -> append_tac(this -> children[0]);
            this -> append_tac(this -> children[1]);
            this -> ta_codes.push_back(q);            
        }
    }
    else if(this -> name == "ArrayCreationExpression") {
        if(this -> children.size() == 4) {
            cout << "Error: Cannot allocate memory. Specify all dimensions, without array initializers please. To be supported later." << endl;
            exit(1);
        }
        
        quad q("", "", "", "");

        this -> append_tac(this -> children[this -> children.size() - 1]);      // Code of DimExprs
        
        // get the symbol table entry
        node* cnt = this;
        st_entry* arr = NULL;
        bool needs_this = true;

        if(cnt -> parent && cnt -> parent -> parent) {
            cnt = cnt -> parent -> parent;
        }
        if(cnt -> children.size() == 1) {
            cnt = cnt -> parent;
            arr = cnt -> sym_tab_entry;
        }
        else {
            cnt = cnt -> children[0];
            if(cnt -> type == "ID") {
                arr = this -> get_and_look_up(cnt -> name);

                if(!arr) {
                    arr = this -> get_and_look_up_member_variable(cnt -> name, this -> get_symbol_table_class() -> name);

                    if(!arr) {
                        cout << "Unknown error! Array not found. Aborting" << endl;
                        exit(1);
                    }   
                }

            }
            else {
                // @TODO
                // Deal with names

                cout << "Arrays as field members not supported. Sorry..." << endl;
                exit(1);

                // this -> append_tac(cnt);    // add the code for #Name# node
                // needs_this = false;
                // arr = cnt -> get_and_look_up_from_name();
            }
        }

        needs_this = needs_this && (arr -> table -> symbol_table_category == 'C');

        this -> get_dimension_variables(arr);

        int datatype_size = 0;
        if(primitive_types.find(this -> children[1] -> name) != primitive_types.end()) {
            datatype_size = type_to_size[this -> children[1] -> name];
        }
        else {
            datatype_size = address_size;
        }

        q = quad(this -> get_var_from_node(), this -> children[this -> children.size() - 1] -> get_var_from_node(), "*", to_string(datatype_size));        // size of array
        q.make_code_from_binary();
        this -> ta_codes.push_back(q);

        // add the auxilliary dimension data in the array
        int dimension_data = (arr -> dim_sizes . size() + 1) * type_to_size["int"];
        q = quad(this -> get_var_from_node(), this -> get_var_from_node(), "+", to_string(dimension_data));
        q.make_code_from_binary();
        this -> ta_codes.push_back(q);
        
        // allocate memory here
        q = quad("", this -> get_var_from_node(), "push_param", "");        // size of array
        q.make_code_push_param();
        this -> ta_codes.push_back(q);

        q = quad("", "allocmem", "callfunc", "");
        q.make_code_from_func_call();
        this -> ta_codes.push_back(q);

        q = quad(this -> children[0] -> get_var_from_node(), "", "pop_param", ""); // use the new keyword node for obtaining extra temporary
        q.make_code_pop_param();
        this -> ta_codes.push_back(q);

        if(needs_this) {
            q = quad(this -> get_var_from_node(), "this", "*()", to_string(arr -> offset));
            q.make_code_from_load();
            this -> ta_codes.push_back(q);
        }
        else {
            q = quad(this -> get_var_from_node(), this -> children[0] -> get_var_from_node(), "=", "");
            q.make_code_from_assignment();
            this -> ta_codes.push_back(q);
        }

        // store the dimension data at offsets
        q = quad(this -> get_var_from_node(), to_string(arr -> dim_sizes.size()), "", "");
        q.make_code_from_store();
        this -> ta_codes.push_back(q);

        for(int i = arr -> dim_sizes.size() - 1; i >= 0; i--) {
            q = quad(this -> get_var_from_node(), this -> get_var_from_node(), "+", to_string(type_to_size["int"]));
            q.make_code_from_binary();
            this -> ta_codes.push_back(q);

            q = quad(this -> get_var_from_node(), arr -> dim_sizes[i], "", "");
            q.make_code_from_store();
            this -> ta_codes.push_back(q);
        }
    }
    else if(this -> name == "UnqualifiedClassInstanceCreationExpression") {
        quad q("", "", "", "");

        string cls_name = "";
        for(auto &child : this -> children) {
            if(child -> type == "ID") {
                cls_name = child -> name;
                break;
            }
        }

        symbol_table_class* cnt_class = main_table -> look_up_class(cls_name);
        
        q = quad("", to_string(cnt_class -> object_size), "push_param", "");
        q.make_code_push_param();
        this -> ta_codes.push_back(q);

        q = quad("", "allocmem", "callfunc", "");
        q.make_code_from_func_call();
        this -> ta_codes.push_back(q);

        q = quad(this -> get_var_from_node(), "", "pop_param", "");
        q.make_code_pop_param();
        this -> ta_codes.push_back(q);

        vector<string> args = this -> children[2] -> get_func_args_tac();
        this -> append_tac(this -> children[2]);
        
        for(auto arg : args){                                           // pushing the other parameters
            q = quad("", arg, "push_param", "");
            q.make_code_push_param();
            this -> ta_codes.push_back(q);
        }

        q = quad("", this -> get_var_from_node(), "push_param", "");    // pushing the this pointer into the constructor
        q.make_code_push_param();
        this -> ta_codes.push_back(q);

        string mangled_name = this -> get_mangled_name();

        q = quad("", mangled_name, "call_func", "");
        q.make_code_from_func_call();
        this -> ta_codes.push_back(q);
    }
    else if(this -> name == "ArrayAccess"){
        for(auto (&child) : this -> children){
            this -> append_tac(child);
        }

        node* cnt_node = this;
        st_entry* arr = NULL;
        bool needs_this = true;
        
        while(cnt_node -> type != "ID" && cnt_node -> name != "#Name#") {
            cnt_node = cnt_node -> children[0];
        }

        if(cnt_node -> type == "ID") {
            arr = this -> get_and_look_up(cnt_node -> name);

            if(!arr) {
                arr = this -> get_and_look_up_member_variable(cnt_node -> name, this -> get_symbol_table_class() -> name);
                if(!arr) {
                    cout << "Unknown Error! Could not find class. Aborting...";
                    exit(1);
                }
            }
        }
        else {
            cout << "Arrays as field members not supported. Sorry..." << endl;
            exit(1);
            // deal with names
            // @TODO
            // probably wont be supported

            // needs_this = false;
            // arr = cnt_node -> get_and_look_up_from_name();
        }

        needs_this &= (arr -> table ->symbol_table_category == 'C');

        quad q("", "", "", "");

        if(needs_this) {    // calculate dimension size by offsetting from this
            q = quad(this -> get_var_from_node(), "this", "*()", to_string(arr -> offset));
            q.make_code_from_load();
            this -> ta_codes.push_back(q);
        }
        else {                      // otherwise store the identifier name as base address
            q = quad(this -> get_var_from_node(), arr -> name, "=", "");
            q.make_code_from_assignment();
            this -> ta_codes.push_back(q);
        }

        // get the dimension size (x_i) only if depth is not 0
        int depth = this -> get_access_depth(this -> datatype);
        if(depth != 0) {
            // q = quad(this -> get_var_from_node(), this -> get_var_from_node(), "+", to_string(depth*type_to_size["int"]));
            // q.make_code_from_binary();
            // this -> ta_codes.push_back(q);

            q = quad(this -> get_var_from_node(), this -> get_var_from_node(), "*()", to_string(depth * type_to_size["int"]));
            q.make_code_from_load();
            this -> ta_codes.push_back(q);
        }

        if(this -> children[0] -> name != "ArrayAccess") {  // leftmost access
            q = quad(this -> get_var_from_node(), this -> get_var_from_node(), "*", this -> children[2] -> get_var_from_node());
            q.make_code_from_binary();
            this -> ta_codes.push_back(q);
        }
        else {
            // bnx(n-1) + b(n-1)
            q = quad(this -> children[2] -> get_var_from_node(), this -> children[0] -> get_var_from_node(), "+", this -> children[2] -> get_var_from_node());
            q.make_code_from_binary();
            this -> ta_codes.push_back(q);

            if(depth == 0) {       // rightmost access
                int datatype_size = 0;
                if(primitive_types.find(this -> datatype) != primitive_types.end()) {
                    datatype_size = type_to_size[this -> datatype];
                }
                else {
                    datatype_size = address_size;
                }

                q = quad(this -> children[2] -> get_var_from_node(), this -> children[2] -> get_var_from_node(), "*", to_string(datatype_size));
                q.make_code_from_binary();
                this -> ta_codes.push_back(q);

                q = quad(this -> get_var_from_node(), this -> get_var_from_node(), "+", this -> children[2] -> get_var_from_node());
                q.make_code_from_binary();
                this -> ta_codes.push_back(q);

                // now add the meta data offset
                int offset = (arr -> dim_sizes . size() + 1) * type_to_size["int"];
                
                // q = quad(this -> get_var_from_node(), this -> get_var_from_node(), "+", to_string(offset));
                // q.make_code_from_binary();
                // this -> ta_codes.push_back(q);

                // dereference to get the value - further processing in "="
                q = quad(this -> get_var_from_node(), this -> get_var_from_node(), "*()", to_string(offset));
                q.make_code_from_load();
                this -> ta_codes.push_back(q);
            }
            else {
                // (bnx(n-1) + b(n-1))x(n-2)
                q = quad(this -> get_var_from_node(), this -> get_var_from_node(), "*", this -> children[2] -> get_var_from_node());
                q.make_code_from_binary();
                this -> ta_codes.push_back(q);
            }
        }

        // string res = this -> get_var_from_node();
        // string arg1 = this -> children[2] -> get_var_from_node();
        // string op = "*";
        // string arg2;
        
        // quad q("", "", "", "");

        // //get the array access datatype
        // int datatype_size = 0;
        // if(primitive_types.find(this -> datatype) != primitive_types.end()) {
        //     datatype_size = type_to_size[this -> datatype];
        // }
        // else {
        //     datatype_size = address_size;
        // }
        
        // q = quad(res, arg1, op, to_string(datatype_size));
        // q.make_code_from_binary();
        // this -> ta_codes.push_back(q);
        
        // arg1 = this -> children[0] -> get_var_from_node();
        // arg2 = res;
        // op = "+";
        // q = quad(res, arg1, op, arg2);
        // q.make_code_from_binary();
        // this -> ta_codes.push_back(q);

        // if(this -> parent -> name != "ArrayAccess") {       // this is the last array access
        //     if(this -> parent -> name != "=") {
        //         arg1 = res;
        //         op = "*()";
        //         q = quad(res, arg1, op, "");
        //         q.make_code_from_load();
        //         this -> ta_codes.push_back(q);
        //     }
        // }

        return;
    }
    else if(this -> name == "MethodInvocation") {
        vector<string> args = this -> children[this -> children.size() - 1] -> get_func_args_tac();
        this -> append_tac(this -> children[this -> children.size() - 1]);
        quad q("", "", "", "");
        

        for(auto arg : args){
            q = quad("", arg, "push_param", "");
            q.make_code_push_param();
            this -> ta_codes.push_back(q);
        }

        vector<string> func_params;
        string func_name;
        symbol_table_class* class_table;

        bool qualified_function_call = false;
        
        for(auto &child : this -> children) {
            if(child -> name == "BracketArgumentList") {
                func_params = child -> get_function_parameters();
            }
            else if(child -> type == "ID") {
                func_name = child -> name;
                class_table = this -> get_symbol_table_class();
            }
            else if(child -> name == "#Name#") {
                func_name = child -> children[child -> children.size() - 1] -> name;        // last child of name is the function name

                // get class type of the second last child in the qualified name                
                class_table = main_table -> look_up_class(child -> children[child -> children.size() - 3] -> datatype);

                qualified_function_call = true;
            }
        }

        symbol_table_func* func_table = class_table -> look_up_function(func_name, func_params);
        if(!func_table) {
            cout << "Unknown error! Function not found while generating 3AC in MethodInvocation. Aborting..." << endl;
            exit(1); 
        }

        if(!func_table -> modifier_bv[M_STATIC]) {
            if(!qualified_function_call) {
                q = quad("", "this", "push_param", "");
            }
            else {
                this -> append_tac(this -> children[0]);
                this -> ta_codes.pop_back();
                q  = quad("", this -> children[0] -> get_var_from_node(), "push_param", "");
            }
            q.make_code_push_param();
            this -> ta_codes.push_back(q);
        }

        int old_pointer_space = address_size;
        string return_type = func_table -> return_type;
        
        int datatype_size = 0;
        if(primitive_types.find(this -> children[1] -> name) != primitive_types.end()) {
            datatype_size = type_to_size[this -> children[1] -> name];
        }
        else {
            datatype_size = address_size;
        }
        
        int return_type_space = address_size + datatype_size; 
        int total_frame_space = old_pointer_space + return_type_space + (func_table -> get_localspace_size());
        
        q = quad("", "-" + to_string(total_frame_space), "", "");
        q.make_code_shift_pointer();
        this -> ta_codes.push_back(q);

        string arg = this -> get_mangled_name();
        q = quad("", arg, "call_func", "");
        q.make_code_from_func_call();
        this -> ta_codes.push_back(q);

        q = quad("", "+" + to_string(total_frame_space), "", "");
        q.make_code_shift_pointer();
        this -> ta_codes.push_back(q);
    }    
    else if(this -> name == "MethodDeclaration" || this -> name == "ConstructorDeclaration") {   

        string mangled_name = this -> get_mangled_name();
        quad q("", mangled_name, "", "");
        q.make_code_begin_func();
        this -> ta_codes.push_back(q);
        
        // popping the this keyword if the function is non static
        if(!this -> sym_tab_entry -> modifier_bv[M_STATIC]) {
            q = quad("this", "", "pop_param", "");
            q.make_code_pop_param();
            this -> ta_codes.push_back(q);
        }

        // get the formal parameters
        symbol_table_func* func = (symbol_table_func*) this -> sym_tab;                                           
        
        for(int idx = func -> params . size() - 1; idx >= 0; idx--){
            q = quad(func -> params[idx] -> name, "", "pop_param", "");
            q.make_code_pop_param();
            this -> ta_codes.push_back(q);
        }

        this -> append_tac(this -> children[(int)this -> children.size() - 1]);
        
        q.make_code_end_func();
        this -> ta_codes.push_back(q);
    }
    else if(this -> name == "VariableDeclarator") {
        if(this -> children.size() == 2) {
            this -> append_tac(this -> children[1]);
            quad q(this -> sym_tab_entry -> name, this -> children[1] -> get_var_from_node(), "=", "");
            q.make_code_from_assignment();
            this -> ta_codes.push_back(q);
        }
        else{
            for(auto &(child) : this -> children){
                this -> append_tac(child);
            }
        }
    }
    else if(this -> name == "CastExpression") {
        string op = this -> children[1] -> name;
        string result = this -> get_var_from_node();
        string arg1 = this -> children[3] -> get_var_from_node();
        quad q(result, arg1, op, "");
        q.make_code_from_cast();
        this -> ta_codes.push_back(q);
        return; 
    }
    else if(this -> name == "ReturnStatement") {
        string arg1 = "", op = "return";

        for(auto &child : this -> children) {
            if(child -> name == "Expression") {
                arg1 = child -> get_var_from_node();
                this -> append_tac(child);
            }
        }

        if(this -> children .size() == 1){
            quad q("", "", op, "");
            q.make_code_from_return();
            this -> ta_codes.push_back(q);
        }
        else{
            arg1 = this -> children[1] -> get_var_from_node();
            quad q("", arg1, op, "");
            q.make_code_from_return();
            this -> ta_codes.push_back(q);
        }
    }
    else if(this -> name == "PreIncrementExpression" || this -> name == "PreDecrementExpression" || this -> name == "PostIncrementExpression" || this -> name == "PostDecrementExpression") {
        string result = this -> get_var_from_node();
        string arg1, op;
        quad q("", "", "", "");

        if(this -> name[1] == 'r'){     //Pre has r
            arg1 = this -> children[1] -> get_var_from_node();
            if(this -> name[3] == 'I'){     //Increment has I
                op = "+";
            }
            else if(this -> name[3] == 'D'){    //Decrement has D
                op = "-";
            }

            q = quad(arg1, arg1, op, "1");
            q.make_code_from_binary();
            this -> ta_codes.push_back(q);

            q = quad(result, arg1, "=", "");
            q.make_code_from_assignment();
            this -> ta_codes.push_back(q);
        }
        else if(this -> name[1] == 'o'){   //Post has o
            arg1 = this -> children[0] -> get_var_from_node();
            if(this -> name[4] == 'I'){     //Increment has I
                op = "+";
            }
            else if(this -> name[4] == 'D'){    //Decrement has D
                op = "-";
            }

            q = quad(result, arg1, "=", "");
            q.make_code_from_assignment();
            this -> ta_codes.push_back(q);
            
            q = quad(arg1, arg1, op, "1");
            q.make_code_from_binary();
            this -> ta_codes.push_back(q);
        }

        if(this -> typecast_to != "UNNEEDED" && this -> typecast_to != ""){
            string op = this -> typecast_to;
            string result = this -> get_var_from_node();
            string arg1 = this -> get_var_from_node();
            quad q(result, arg1, op, "");
            q.make_code_from_cast();
            this -> ta_codes.push_back(q);
        }
        return;
    }
    else if(this -> type == "OPERATOR") {
        string op = this -> name;
        if(op == "+" || op == "-" || op == "*" || op == "/" || op == "%" || op == "<<" || op == ">>" || op == ">>>" || op == ">" || op == "<" || op == ">=" || op == "<=" || op == "==" || op == "!=" || op == "&" || op == "|" || op == "^" || op == "&&" || op == "||") {
            string result = this -> get_var_from_node();
            string arg1, arg2;

            if(this -> children.size() > 1){
                arg1 = this -> children[0] -> get_var_from_node();
                arg2 = this -> children[1] -> get_var_from_node();
            }else{
                arg1 = "0";
                arg2 = this -> children[0] -> get_var_from_node();
            }

            quad q(result, arg1, op, arg2);
            q.make_code_from_binary();
    
            this -> append_tac(this -> children[0]);
            this -> append_tac(this -> children[1]);
            this -> ta_codes.push_back(q);
        }
        else if(op == "++" || op == "--") {     // Don't need to handle these
            // dealt at the parent level
        }
        else if(op == "~" || op == "!") {
            string result = this -> get_var_from_node();
            string arg1 = this -> children[0] -> get_var_from_node();
            quad q(result, arg1, op, "");
            q.make_code_from_unary();
    
            this -> append_tac(this -> children[0]);
            this -> ta_codes.push_back(q);
        }
        else if(op == "=") {
            if(this -> children.size() == 2) {
                quad q("", "", "", "");

                string result = this -> children[0] -> get_var_from_node();
                string arg1 = this -> children[1] -> get_var_from_node();
        
                q = quad(result, arg1, "=", "");
                if(this -> children[0] -> name == "ArrayAccess" || this -> children[0] -> name == "FieldAccess" || this -> children[0] -> name == "#Name#"){
                    q.make_code_from_store();
                    this -> children[0] -> ta_codes.pop_back();
                }
                else{
                    q.make_code_from_assignment();
                }
                
                this -> append_tac(this -> children[0]);
                this -> append_tac(this -> children[1]);
                this -> ta_codes.push_back(q);
            }
            else if(this -> children.size() == 1) {
                this -> append_tac(this -> children[0]);
                quad q(this->get_var_from_node(), this ->children[0]->get_var_from_node(), "=", "");
                q.make_code_from_assignment();
                this -> ta_codes.push_back(q);
            }
        }
        else if(op == "+=" || op == "-=" || op == "*=" || op == "/=" || op == "%=" || op == "<<=" || op == ">>=" || op == ">>>=" || op == "&=" || op == "^=" || op == "|=") {
            string result = this -> get_var_from_node();
            string arg1 = this -> children[0] -> get_var_from_node();
            string arg2 = this -> children[1] -> get_var_from_node();
            op = op.substr(0, op.size() - 1);
    
            this -> append_tac(this -> children[0]);
            this -> append_tac(this -> children[1]);
            {
                quad q(arg1, arg1, op, arg2);
                q.make_code_from_binary();
                this -> ta_codes.push_back(q);
            }
            {
                quad q(result, arg1, "=", "");
                q.make_code_from_assignment();
                this -> ta_codes.push_back(q);
            }
        }
        else if(op == "?:"){
            // @TODO TERNARY
            string result, arg1, arg2, ope;
            quad q("", "", "", "");
            
            this -> append_tac(this -> children[0]);


            op = "if_false";
            arg1 = this -> children[0] -> get_var_from_node();
            arg2 = "J+" + to_string(this -> children[1] -> ta_codes.size() + 3);
            q = quad("", arg1, op, arg2);
            q.make_code_from_conditional();
            this -> ta_codes.push_back(q);  // Conditional
            
            this -> append_tac(this -> children[1]);
            op = "=";
            arg1 = this -> children[1] -> get_var_from_node();
            result = this -> get_var_from_node();
            q = quad(result, arg1, op, "");
            q.make_code_from_assignment();  
            this -> ta_codes.push_back(q);  // First option
            
            op = "goto";
            arg1 = "J+" + to_string(this -> children[2] -> ta_codes.size() + 2);
            q = quad("", arg1, op, "");
            q.make_code_from_goto();
            this -> ta_codes.push_back(q);

            this -> append_tac(this -> children[2]);
            op = "=";
            arg1 = this -> children[2] -> get_var_from_node();
            result = this -> get_var_from_node();
            q = quad(result, arg1, op, "");
            q.make_code_from_assignment();  
            this -> ta_codes.push_back(q);  // Second option
        }

        if(this -> typecast_to != "UNNEEDED" && this -> typecast_to != ""){
            string op = this -> typecast_to;
            string result = this -> get_var_from_node();
            string arg1 = this -> get_var_from_node();
            quad q(result, arg1, op, "");
            q.make_code_from_cast();
            this -> ta_codes.push_back(q);
        }
    }else{
        for(auto &(child) : this -> children){
            this -> append_tac(child);
        }
    }


    // cout << this -> name << " " << " tock" << endl;
}

char node::calculate_type(string n){
    // N for None
    // b for boolean, D for Decimal, f for float, H for hexadecimal, F for hexadecimal float, B for binary, O for octal

    if(n == ""){
        return 'N';
    }
    // n.size() > 0
    if(n == "true" || n == "false"){
        return 'b';
    }
    if(n[0] != '-' && n[0] != '+' && n[0] < '0' && n[0] > '9'){
        return 'N';
    }
    // Probably a number at this point
    
    // Check for binary
    {
        if(n.size() > 2 && n[0] == '0' && (n[1] == 'b' || n[1] == 'B')){
            return 'B';
        }
    }
    // Check for octal
    {
        bool octal = (n[0] == '0');
        if(octal){
            for(const auto c : n){
                if((c < '0' || c > '7') && (c != 'l' && c != 'L' && c != '_')){
                    octal = false;
                    break;
                }
            }

            if(octal){
                return 'O';
            }
        }
    }
    // Check for decimal
    {
        bool decimal = true;
        for(const auto c : n){
            if((c < '0' || c > '9') && (c != '_' && c != 'l' && c != 'L')){
                decimal = false;
                break;
            }
        }

        if(decimal){
            return 'D';
        }
    }
    // Check for hexadecimal
    {
        bool hexd = (n.size() > 2 && n[0] == '0' && (n[1] == 'x' || n[1] == 'X'));
        if(hexd){
            for(int i = 2; i < n.size(); i++){
                if((n[i] < '0' || n[i] > '9') && (n[i] < 'a' || n[i] > 'f') && (n[i] < 'A' || n[i] > 'F')){
                    if(n[i] != 'l' && n[i] != 'L'){
                        hexd = false;
                        break;
                    }
                }
            }
        }
        if(hexd){
            return 'H';
        }
    }
    // @TODO
    // Check for decimal float
    {

    }
    // Check for hexadecimal Float
    {

    }

    return 'N';
}

string node::convert_to_decimal(string n){
    char t = calculate_type(n);

    if(t == 'N'){
        return "";
    }
    else if(t == 'b'){
        return n;
    }
    else if(t == 'D'){
        long long temp = 0;
        for(int i = 0; i < n.size(); i++){
            if(n[i] >= '0' && n[i] <= '9'){
                temp = temp * 10 + (n[i] -'0');
            }
        }
        return to_string(temp) + ((n[n.size() - 1] == 'l' || n[n.size() - 1] == 'L') ? "l" : "");
    }
    else if(t == 'H'){
        long long temp = 0;
        for(int i = 2; i < n.size(); i++){
            if((n[i] >= '0' && n[i] <= '9')){
                temp = temp * 16 + (n[i] - '0');
            }
            if(n[i] >= 'a' && n[i] <= 'f'){
                temp = temp * 16 + (n[0] - 'a') + 10;
            }
            if(n[i] >= 'A' && n[i] <= 'F'){
                temp = temp * 16 + (n[0] - 'A') + 10;
            }
        }
        return to_string(temp) + ((n[n.size() - 1] == 'l' || n[n.size() - 1] == 'L') ? "l" : "");
    }
    else if(t == 'B'){
        long long temp = 0;
        for(int i = 2; i < n.size(); i++){
            if(n[i] == '0' || n[i] == '1'){
                temp = temp * 2 + (n[i] -'0');
            }
        }
        return to_string(temp) + ((n[n.size() - 1] == 'l' || n[n.size() - 1] == 'L') ? "l" : "");
    }
    else if(t == 'O'){
        long long temp = 0;
        for(int i = 1; i < n.size(); i++){
            if(n[i] >= '0' && n[i] <= '7'){
                temp = temp * 8 + (n[i] -'0');
            }
        }
        return to_string(temp) + ((n[n.size() - 1] == 'l' || n[n.size() - 1] == 'L') ? "l" : "");
    }
    // @TODO
    else if(t == 'f'){

    }
    else if(t == 'F'){

    }
    return "";
}

void node::convert_to_decimal(){
    string temp;
    for(auto (&q) : this -> ta_codes){
        temp = convert_to_decimal(q.arg1);
        if(temp != ""){
            q.arg1 = temp;
        }

        temp = convert_to_decimal(q.arg2);
        if(temp != ""){
            q.arg2 = temp;
        }
    }
}

void node::remove_empty_tac(){
    vector<quad> refined_tacs;

    for(auto q : this -> ta_codes){
        if(q.code != ""){
            refined_tacs.push_back(q);
        }
    }

    this -> ta_codes = refined_tacs;
    return;
}

void node::update_tac_jump_vals(){
    int ins_count = 1;
    map<int, int> new_ins_count;
    for(auto (&q) : this -> ta_codes){      // Update q's ins_line
        if(q.code != ""){
            new_ins_count[q.ins_line] = ins_count;
            q.ins_line = ins_count;     // q.ins_line = ins_count 
            ins_count++;
        }
    }

    ins_count = 1;
    for(auto (&q) : this -> ta_codes){      // Update q's abs_jump
        if(q.code != ""){
            if(q.rel_jump){
                // TESTING
                // Lower bound used because we need the next instruction to jump onto
                q.abs_jump = (*(new_ins_count.lower_bound(q.abs_jump))).second;
                // q.abs_jump = new_ins_count[q.abs_jump];
                
                q.make_code();
                q.rel_jump = q.abs_jump - q.ins_line;
            }
            ins_count++;
        }
    }
}

void node::rename_temporaries(){
    map<string, int> order_of_appearance;
    int temporaries_seen = 0;
    for(auto (&q) : this -> ta_codes){
        if(q.code != ""){
            if(q.result.size() > 2 && q.result[0] == '#' && q.result[1] == '#'){
                if(order_of_appearance[q.result] == 0){
                    temporaries_seen++;
                    order_of_appearance[q.result] = temporaries_seen;
                }
                q.result = "##t" + to_string(order_of_appearance[q.result]);
            }
            if(q.arg1.size() > 2 && q.arg1[0] == '#' && q.arg1[1] == '#'){
                if(order_of_appearance[q.arg1] == 0){
                    temporaries_seen++;
                    order_of_appearance[q.arg1] = temporaries_seen;
                }
                q.arg1 = "##t" + to_string(order_of_appearance[q.arg1]);
            }
            if(q.arg2.size() > 2 && q.arg2[0] == '#' && q.arg2[1] == '#'){
                if(order_of_appearance[q.arg2] == 0){
                    temporaries_seen++;
                    order_of_appearance[q.arg2] = temporaries_seen;
                }
                q.arg2 = "##t" + to_string(order_of_appearance[q.arg2]);
            }
            q.make_code();   
        }
    }
}

bool node::optimize_tac_RED_TEMPS(){
    map<string, set<int> > lhs_apps, rhs_apps;
    set<int> jumped_to;

    int ins_count = 1;
    for(auto (&q) : this -> ta_codes){
        if(q.code != ""){
            q.check_jump(ins_count);        // Sets ins_line and abs_jump of q

            lhs_apps[q.result].insert(ins_count);
            rhs_apps[q.arg1].insert(ins_count);
            rhs_apps[q.arg2].insert(ins_count);
            jumped_to.insert(q.abs_jump);

            ins_count++;
        }
    }

    bool any_optimization = false;
    // Remove redundant temporaries (only those that have been made by us) using Copy Propagation
    {
        bool optimizing = true;
        while(optimizing){
            optimizing = false;
            for(int i = 0; i < (this -> ta_codes).size(); i++){
                quad (&q) = this -> ta_codes[i];
                if(q.code != ""){
                    // TESTING
                    if(/* jumped_to.find(q.ins_line) == jumped_to.end() && */ lhs_apps[q.result].size() == 1 && q.result.size() > 2 && q.result[0] == '#' && q.result[1] == '#'){

                        if(q.made_from == quad::ASSIGNMENT){    
                            // Copy Propagation
                            /*
                                Looking for cases like
                                    t1 = a1;
                                    t2 = t1 + t3;
                                    ...

                                This is replaced by
                                    t2 = a1 + t3;
                                    ...
                            */ 

                            bool green_light = false;
                            set<int> tmp = rhs_apps[q.result];
                            for(int j = i + 1; j < (this -> ta_codes).size(); j++){
                                quad (&p) = this -> ta_codes[j];
                                if(tmp.find(p.ins_line) == tmp.end() && jumped_to.find(p.ins_line) == jumped_to.end()){
                                    green_light = (tmp.size() == 0);
                                    break;
                                }
                                if(p.arg1 == q.result || p.arg2 == q.result){
                                    tmp.erase(p.ins_line);
                                }
                            }
                            
                            if(green_light){
                                optimizing = true;
                                q.code = "";
                                for(int j = i + 1; j < (this -> ta_codes).size(); j++){
                                    if(rhs_apps[q.result].size() == 0){
                                        break;
                                    }
                                    quad (&p) = this -> ta_codes[j];
                                    if(p.arg1 == q.result || p.arg2 == q.result){
                                        q.code = "";    
                                        if(p.arg1 == q.result){
                                            p.arg1 = q.arg1;
                                        }
                                        if(p.arg2 == q.result){
                                            p.arg2 = q.arg1;
                                        }
                                        rhs_apps[q.arg1].insert(p.ins_line);
                                        rhs_apps[q.result].erase(p.ins_line);
                                        p.make_code();
                                    }
                                }       
                            }
                        }
                        else if(q.made_from == quad::BINARY || q.made_from == quad::UNARY || q.made_from == quad::LOAD || q.made_from == quad::CAST){
                            // (Inverse?) Copy Propagation
                            /*
                                Looking for cases like
                                    t1 = a1 + a2;
                                    t2 = t1;
                                    ...
                                
                                This is replaced by
                                    t2 = a1 + a2;
                                    ...
                            */

                            bool green_light = false;
                            set<int> tmp = rhs_apps[q.result];
                            for(int j = i + 1; j < (this -> ta_codes).size(); j++){
                                quad (&p) = this -> ta_codes[j];
                                if(tmp.find(p.ins_line) == tmp.end() || jumped_to.find(p.ins_line) != jumped_to.end()){
                                    green_light = (tmp.size() == 0);
                                    break;
                                }
                                if(p.made_from == quad::ASSIGNMENT && (p.arg1 == q.result || p.arg2 == q.result)){
                                    tmp.erase(p.ins_line);
                                }
                            }

                            green_light = (green_light && (rhs_apps[q.result].size() == 1));
                            if(green_light){
                                optimizing = true;
                                q.code = "";
                                for(int j = i + 1; j < (this -> ta_codes).size(); j++){
                                    quad (&p) = this -> ta_codes[j];
                                    if(rhs_apps[q.result].size() == 0){
                                        break;
                                    }
                                    if(p.made_from == quad::ASSIGNMENT && (p.arg1 == q.result || p.arg2 == q.result)){
                                        p.op = q.op;
                                        p.arg1 = q.arg1;
                                        p.arg2 = q.arg2;
                                        p.made_from = q.made_from;
                                        rhs_apps[q.arg1].insert(p.ins_line);
                                        rhs_apps[q.arg2].insert(p.ins_line);
                                        rhs_apps[q.result].erase(p.ins_line);
                                        p.make_code();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            any_optimization = (any_optimization || optimizing);
        }
    }

    this -> remove_empty_tac();
    this -> update_tac_jump_vals();
    return any_optimization;
}

bool node::optimize_tac_CONST_and_STR_RED(){

    map<string, set<int> > lhs_apps, rhs_apps;
    set<int> jumped_to;

    int ins_count = 1;
    for(auto (&q) : this -> ta_codes){
        if(q.code != ""){
            q.check_jump(ins_count);        // Sets ins_line and abs_jump of q

            lhs_apps[q.result].insert(ins_count);
            rhs_apps[q.arg1].insert(ins_count);
            rhs_apps[q.arg2].insert(ins_count);
            jumped_to.insert(q.abs_jump);

            ins_count++;
        }
    }

    bool any_optimization = false;
    int opt_count = -1;                             // Number of instructions optimized
    set<int> const_optimized, stred_optimized;      // Set of instructions optimized from constant folding/ propagation, and strength reduction
    while(opt_count != const_optimized.size() + stred_optimized.size()){
        opt_count = const_optimized.size() + stred_optimized.size();

        // Constant Folding + Constant Propagation
        for(int i = 0; i < this -> ta_codes.size(); i++){
            // @TODO Support for non-decimals
            quad (&q) = this -> ta_codes[i];
            if(q.code == "" || const_optimized.find(q.ins_line) != const_optimized.end()){
                continue;
            }

            if(this -> convert_to_decimal(q.arg1) == q.arg1 && this -> convert_to_decimal(q.arg2) == q.arg2){ // RHS args are constant
                if(q.made_from == quad::BINARY){ // Constant Folding
                    const_optimized.insert(q.ins_line);
                    any_optimization = true;

                    string op = q.op;
                    if(op == "+"){
                        q.arg1 = to_string(stoll(q.arg1) + stoll(q.arg2));
                    }
                    else if(op == "-"){
                        q.arg1 = to_string(stoll(q.arg1) - stoll(q.arg2));
                    }
                    else if(op == "*"){
                        q.arg1 = to_string(stoll(q.arg1) * stoll(q.arg2));
                    }
                    else if(op == "/"){
                        q.arg1 = to_string(stoll(q.arg1) / stoll(q.arg2));
                    }
                    else if(op == "%"){
                        q.arg1 = to_string(stoll(q.arg1) % stoll(q.arg2));
                    }
                    else if(op == "<<"){
                        q.arg1 = to_string(stoll(q.arg1) << stoll(q.arg2));
                    }
                    else if(op == ">>"){
                        q.arg1 = to_string(stoll(q.arg1) >> stoll(q.arg2));
                    }
                    else if(op == ">>>"){
                        q.arg1 = to_string((unsigned long long) stoll(q.arg1) >> stoll(q.arg2));
                    }
                    else if(op == ">"){
                        q.arg1 = (stoll(q.arg1) > stoll(q.arg2) ? "true" : "false");
                    }
                    else if(op == "<"){
                        q.arg1 = (stoll(q.arg1) < stoll(q.arg2) ? "true" : "false");
                    }
                    else if(op == ">="){
                        q.arg1 = (stoll(q.arg1) >= stoll(q.arg2) ? "true" : "false");
                    }
                    else if(op == "<="){
                        q.arg1 = (stoll(q.arg1) <= stoll(q.arg2) ? "true" : "false");
                    }
                    else if(op == "=="){
                        q.arg1 = (stoll(q.arg1) == stoll(q.arg2) ? "true" : "false");
                    }
                    else if(op == "!="){
                        q.arg1 = (stoll(q.arg1) != stoll(q.arg2) ? "true" : "false");
                    }
                    else if(op == "&"){
                        q.arg1 = to_string(stoll(q.arg1) & stoll(q.arg2));
                    }
                    else if(op == "|"){
                        q.arg1 = to_string(stoll(q.arg1) | stoll(q.arg2));
                    }
                    else if(op == "^"){
                        q.arg1 = to_string(stoll(q.arg1) ^ stoll(q.arg2));
                    }
                    else if(op == "&&"){
                        q.arg1 = ((q.arg1 == "true" && q.arg2 == "true") ? "true" : "false");
                    }
                    else if(op == "||"){
                        q.arg1 = ((q.arg1 == "true" || q.arg2 == "true") ? "true" : "false");
                    }

                    q.op = "=";
                    q.arg2 = "";
                    q.make_code_from_assignment();
                }
                else if(q.made_from == quad::UNARY){    // Constant Folding
                    const_optimized.insert(q.ins_line);
                    any_optimization = true;
                    
                    string op = q.op;
                    if(op == "~"){
                        q.arg1 = to_string(~stoll(q.arg1));
                        q.op = "=";
                        q.arg2 = "";
                        q.make_code_from_assignment();
                    }
                    else if(op == "!"){
                        q.arg1 = (q.arg1 == "true" ? "false" : "true");
                        q.op = "=";
                        q.arg2 = "";
                        q.make_code_from_assignment();
                    }
                }
                
                if(q.made_from == quad::ASSIGNMENT){    // Constant Propagation
                    const_optimized.insert(q.ins_line);
                    
                    for(int j = i + 1; j < this -> ta_codes.size(); j++){
                        quad (&p) = this -> ta_codes[j];

                        if(p.code == ""){
                            continue;
                        }
                        if(jumped_to.find(p.ins_line) != jumped_to.end() || rhs_apps[q.result].size() == 0){
                            break;
                        }
                        if(!(p.made_from == quad::ASSIGNMENT || p.made_from == quad::BINARY || p.made_from == quad::UNARY || p.made_from == quad::CAST || p.made_from == quad::PUSH_PARAM || p.made_from == quad::RETURN)){
                            break;
                        }

                        if(p.arg1 == q.result || p.arg2 == q.result){
                            rhs_apps[q.result].erase(p.ins_line);
                            any_optimization = true;

                            if(p.arg1 == q.result){
                                p.arg1 = q.arg1;
                            }
                            if(p.arg2 == q.result){
                                p.arg2 = q.arg1;
                            }

                            p.make_code();
                        }
                        
                        if(p.result == q.result){
                            q.code = "";
                            break;
                        }
                    }

                    if(rhs_apps[q.result].size() == 0 && q.result.size() > 2 && q.result[0] == '#' && q.result[1] == '#'){
                        q.code = "";
                    }
                }
            }
        }

        // Strength Reduction (Algebraic Reduction)
        for(int i = 0; i < this -> ta_codes.size(); i++){
            quad (&q) = this -> ta_codes[i];

            if(q.code == "" || stred_optimized.find(q.ins_line) != stred_optimized.end()){
                continue;
            }

            string op = q.op;
            bool reduced = false;
            if(q.arg2 == "0"){
                // + - * / << >> >>> & | ^
                if(op == "+"){
                    reduced = true;
                    q.arg2 = "";
                }
                else if(op == "-"){
                    reduced = true;
                    q.arg2 = "";
                }
                else if(op == "*"){
                    reduced = true;
                    q.arg2 = "";
                    q.arg1 = "0";
                }
                else if(op == "/"){
                    cout << "ERROR: Zero Division detected... Exiting" << endl;
                    exit(1);
                }
                else if(op == "<<"){
                    reduced = true;
                    q.arg2 = "";
                }
                else if(op == ">>"){
                    reduced = true;
                    q.arg2 = "";
                }
                else if(op == ">>>"){
                    reduced = true;
                    q.arg2 = "";
                }
                else if(op == "&"){
                    reduced = true;
                    q.arg2 = "";
                    q.arg1 = "0";
                }
                else if(op == "|"){
                    reduced = true;
                    q.arg2 = "";
                }
                else if(op == "^"){
                    reduced = true;
                    q.arg2 = "";
                }

                if(reduced){
                    q.op = "=";
                    q.make_code_from_assignment();
                }
            }
            else if(q.arg1 == "0"){
                // + * / << >> >>> & | ^
                if(op == "+"){
                    reduced = true;
                    q.arg1 = q.arg2;
                }
                else if(op == "*"){
                    reduced = true;
                }
                else if(op == "/"){
                    reduced = true;
                }
                else if(op == "<<"){
                    reduced = true;
                }
                else if(op == ">>"){
                    reduced = true;
                }
                else if(op == ">>>"){
                    reduced = true;
                }
                else if(op == "&"){
                    reduced = true;
                }
                else if(op == "|"){
                    reduced = true;
                    q.arg1 = q.arg2;
                }
                else if(op == "^"){
                    reduced = true;
                    q.arg1 = q.arg2;
                }

                if(reduced){
                    q.op = "=";
                    q.arg2 = "";
                    q.make_code_from_assignment();
                }
            }
            else if(q.arg2 == "1"){
                // * /
                if(op == "*"){
                    reduced = true;
                }
                else if(op == "/"){
                    reduced = true;
                }

                if(reduced){
                    q.op = "=";
                    q.arg2 = "";
                    q.make_code_from_assignment();
                }
            }
            else if(q.arg1 == "1"){
                // *
                if(op == "*"){
                    reduced = true;
                    q.arg1 = q.arg2;
                }

                if(reduced){
                    q.op = "=";
                    q.arg2 = "";
                    q.make_code_from_assignment();
                }
            }
            else if(q.arg1 == "true" || q.arg2 == "true" || q.arg1 == "false" || q.arg2 == "false"){
                // && ||
                if(op == "&&"){
                    reduced = true;
                    if(q.arg1 == "true" && q.arg2 == "true"){
                        q.arg1 = "true";
                    }
                    else{
                        q.arg1 = "false";
                    }
                }
                else if(op == "||"){
                    reduced = true;
                    if(q.arg1 == "true" || q.arg2 == "true"){
                        q.arg1 = "true";
                    }
                    else{
                        q.arg1 = "false";
                    }
                }

                if(reduced){
                    q.arg2 = "";
                    q.op = "=";
                    q.make_code_from_assignment();
                }
            }
            else{
                // Check if arg1 or arg2 is a perfect power of two
                // Check if arg1 == arg2 for - / ^ & |
                // if_false false goto x; -> goto x; similarly, if_true true goto x;
            }
            any_optimization = (any_optimization || reduced);
        }
    }

    this -> remove_empty_tac();
    this -> update_tac_jump_vals();
    return any_optimization;
}

void node::print_tac(string filename){
    ofstream out(filename);

    int ins_count = 1;
    for(auto (&q) : this -> ta_codes) {
        if(q.code != "") {
            q.check_jump(ins_count);    // Also sets q's ins_line

            if(filename == "") {
                cout << ins_count << (ins_count >= 100 ? ":" : ":\t") << q.code;
            }
            else {
                out << ins_count << (ins_count >= 100 ? ":" : ":\t") << q.code;
            }
            ins_count++;
        }
    }

    out.close();
}