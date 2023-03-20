#include <bits/stdc++.h>
#include "../headers/global_vars.hpp" // Includes node.hpp
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
    assert(this->parent != NULL);
    if((this->children).size() == 1){
        this->kill_parent(idx);
        return this;
    }else{
        node* v = NULL;
        for(int x = 0; x < (this->children).size(); x++){
            v = ((this->children)[x])->one_child_policy(x);
            if(v){
                delete v;
                x--;
            }
        }
        return NULL;
    }
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
            this->name = child->name;
            this->type = child->type;
            this->terminal = child->terminal;
            this->exp_applicable = child->exp_applicable;
            (this->children).erase((this->children).begin(), (this->children).begin() + 1);  
            delete child;
        } else if((this->children).size() == 3){
            node* child = (this->children)[1];
            this->name = child->name;
            this->type = child->type;
            this->terminal = child->terminal;
            this->exp_applicable = child->exp_applicable;
            (this->children).erase((this->children).begin() + 1, (this->children).begin() + 2);  
            delete child;
        } else if((this->children).size() == 5){
            node* child = (this->children)[1];
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
    if(this -> name == "MethodDeclaration") {
        if(this -> sym_tab_entry -> name == temp_node -> sym_tab -> name) {
            cout << "Error: Constructor cannot have a return type at line number: " << this -> sym_tab_entry -> line_no << endl;
            exit(1);
        }
        ((symbol_table_class*) temp_node -> sym_tab) -> add_entry((symbol_table_func*) this -> sym_tab);
    }
    else if(this -> name == "ConstructorDeclaration") {
        if(!(this -> sym_tab_entry -> name == temp_node -> sym_tab -> name)) {
            cout << "Error: Constructor name does not match simple class name at line number: " << this -> sym_tab_entry -> line_no << endl;
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
            (temp_st -> sub_scopes)++;
            this->sym_tab->scope = ((temp_st->scope != "") ? temp_st->scope + "/" : "") + (this->sym_tab->name) + "#" + to_string(temp_st->sub_scopes);
            cout << "Current scope: " << this -> sym_tab -> scope << endl;
            cout << "Parent scope: " << temp_st -> scope << endl; 
        }    
    }

    for(auto &child : this -> children) {
        child->create_scope_hierarchy();
    }
}

bool node::isClassScope(string scope) {
    for(const auto (&c) : scope){
        if(c == '/'){
            return false;
        }
    }
    return true;
}

// WALK 2
void node::populate_and_check() {
    if(this -> name == "LocalVariableDeclaration") {
        symbol_table *cnt_table = get_symbol_table();

        if(!cnt_table) {
            cout << "Unknown error! Aborting..." << endl;
            exit(1);
        }

        for(auto &entry : this -> entry_list) {
            st_entry* tmp = cnt_table -> look_up(entry -> name);
            if(tmp) {
                if(this -> isClassScope(tmp -> table -> scope)) { // add the entry if the variable is already declared AS A FIELD variable
                    cnt_table->add_entry(entry);
                }
                else {
                    cout << "Error: Variable " << entry -> name << " is already declared at line number: " << tmp -> line_no << endl;
                    exit(1);
                }
            }
            else {
                cnt_table->add_entry(entry);
            }
        }
    }

    // @TODO checking of expressions


    for(auto &child : this -> children) {
        child -> populate_and_check();
    }
}