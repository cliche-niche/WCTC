%{
    #include <cstdio> 
    #include <cstring>
    #include <iostream>
    #include <vector>
    #include <stdio.h>
    #include "../headers/global_vars.hpp"

    using namespace std;

    extern "C" int yylex();
    extern "C" int yylineno;

    unsigned long long int count_semicolon;
    void yyerror(const char* s);
    void add_child(node* parent, node* child);
%}
%define parse.error verbose

%union{
    long numval;
    long double realval;
    int boolval;
    char* strval;
    struct node* treenode;
}

%token<strval> LITERAL_integer
%token<strval> LITERAL_floatingpoint
%token<strval> LITERAL_boolean
%token<strval> LITERAL_char
%token<strval> LITERAL_string
%token<strval> LITERAL_textblock
%token<strval> OPERATOR_assignment
%token LITERAL_null 

%token KEYWORD_class KEYWORD_extends KEYWORD_super KEYWORD_package KEYWORD_public KEYWORD_private KEYWORD_abstract KEYWORD_static KEYWORD_final KEYWORD_sealed KEYWORD_nonsealed KEYWORD_strictfp KEYWORD_implements KEYWORD_import KEYWORD_permits KEYWORD_transient KEYWORD_volatile KEYWORD_synchronized KEYWORD_native KEYWORD_void KEYWORD_this KEYWORD_enum KEYWORD_if KEYWORD_else KEYWORD_assert KEYWORD_while KEYWORD_for KEYWORD_break KEYWORD_yield KEYWORD_continue KEYWORD_return KEYWORD_throw KEYWORD_try KEYWORD_catch KEYWORD_finally KEYWORD_boolean KEYWORD_new KEYWORD_var KEYWORD_byte KEYWORD_short KEYWORD_int KEYWORD_long KEYWORD_char KEYWORD_float KEYWORD_double KEYWORD_protected KEYWORD_throws KEYWORD_do
%token<strval> Identifier
%token DELIM_semicolon DELIM_period DELIM_lpar DELIM_rpar DELIM_lsq DELIM_rsq DELIM_lcurl DELIM_rcurl DELIM_comma DELIM_ellipsis DELIM_proportion DELIM_attherate 

%precedence PREC_reduce_VariableDeclaratorList
%precedence PREC_reduce_VariableInitializerList
%precedence PREC_reduce_ResourceList
%precedence PREC_reduce_Dims
%precedence PREC_shift_Dims

%precedence DELIM_comma
%precedence DELIM_semicolon
%precedence KEYWORD_final

%precedence PREC_excor_to_and
%precedence PREC_incor_to_excor
%precedence PREC_condor_to_condand
%precedence PREC_condand_to_incor
%precedence PREC_cond_to_condor
%precedence PREC_and_to_equality
%precedence PREC_equality_to_relational

%right DELIM_lsq
%right OPERATOR_assignment OPERATOR_equal
%right OPERATOR_ternarycolon OPERATOR_ternaryquestion
%left OPERATOR_logicalor
%left OPERATOR_logicaland
%left OPERATOR_bitwiseor
%left OPERATOR_xor
%left OPERATOR_bitwiseand
%left OPERATOR_logicalequal OPERATOR_neq
%left OPERATOR_lt OPERATOR_gt OPERATOR_leq OPERATOR_geq KEYWORD_instanceof
%left OPERATOR_leftshift OPERATOR_rightshift OPERATOR_unsignedrightshift
%left OPERATOR_plus OPERATOR_minus
%left OPERATOR_multiply OPERATOR_divide OPERATOR_mod
%right UNARY_minus UNARY_plus OPERATOR_not OPERATOR_bitwisecomp
%nonassoc OPERATOR_increment OPERATOR_decrement

%type<treenode> DoStatement IntegralType FloatingPointType PrimitiveType NumericType ArrayType Dims qDims Name Modifiers CompilationUnit OrdinaryCompilationUnit Modifier sCommaName NameList AdditionalBound pAdditionalBound ArrayInitializer qComma sCommaVariableInitializer VariableInitializerList qVariableInitializerList sImportDeclaration ImportDeclaration importName  PackageDeclaration sTopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclaration ClassExtends qClassExtends ClassImplements qClassImplements Block qBlockStatements BlockStatements BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration LocalVariableType Statement StatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement LabeledStatementNoShortIf ExpressionStatement StatementExpression IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement WhileStatement WhileStatementNoShortIf ForStatement ForStatementNoShortIf BasicForStatement BasicForStatementNoShortIf qForInit qForUpdate ForInit ForUpdate StatementExpressionList sCommaStatementExpression EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement qIdentifier YieldStatement ContinueStatement ReturnStatement qExpression ThrowStatement SynchronizedStatement TryStatement qCatches pCatches Catches CatchClause CatchFormalParameter CatchType sOrName Finally TryWithResourcesStatement qFinally ResourceSpecification qSemicolon ResourceList ssemicolonResource Resource VariableAccess Pattern TypePattern NormalClassDeclaration ClassPermits qClassPermits ClassBody qClassBody ClassBodyDeclaration sClassBodyDeclaration ClassMemberDeclaration FieldDeclaration VariableDeclaratorList sCommaVariableDeclarator VariableDeclarator VariableDeclaratorId qEqualVariableInitializer VariableInitializer UnannType MethodDeclaration MethodHeader MethodDeclarator ReceiverParameterComma ReceiverParameter IdentifierDot qIdentifierDot FormalParameterList qFormalParameterList FormalParameter sCommaFormalParameter VariableArityParameter Throws qThrows MethodBody InstanceInitializer StaticInitializer ConstructorDeclaration ConstructorDeclarator ConstructorBody ExplicitConstructorInvocation BracketArgumentList UnaryExpression PreIncrementExpression UnaryExpressionNotPlusMinus PostfixExpression Primary PrimaryNoNewArray Literal ClassLiteral ClassInstanceCreationExpression UnqualifiedClassInstanceCreationExpression qArgumentList ArgumentList sCommaExpression FieldAccess ArrayAccess MethodInvocation MethodReference ArrayCreationExpression DimExprs DimExpr PostIncrementExpression PostDecrementExpression CastExpression InstanceofExpression Assignment LeftHandSide Expression AssignmentExpression ConditionalExpression ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression ShiftExpression AdditiveExpression MultiplicativeExpression PreDecrementExpression BooleanDims NumericTypeDims 

%start CompilationUnit

%%
    /****************** TYPES, VALUES AND VARIABLES  ******************/
    IntegralType:
        KEYWORD_byte { }
        | KEYWORD_short { }
        | KEYWORD_int { }
        | KEYWORD_long { }
        | KEYWORD_char { }
        ;
    
    FloatingPointType:
        KEYWORD_float { }
        | KEYWORD_double { }
        ;
    
    PrimitiveType:
        NumericType { }
        | KEYWORD_boolean { }
        ;
    
    // Non terminal for Java style array declaration support
    NumericTypeDims:
        NumericType Dims { }
        ;
    // Non terminal for Java style array declaration support
    BooleanDims:
        KEYWORD_boolean Dims { }
        ;
    
    NumericType :
        IntegralType { }
        | FloatingPointType { }
        ;
    
    ArrayType:
        Name Dims { }
        ;
    
    Dims:
        DELIM_lsq DELIM_rsq       %prec PREC_reduce_Dims { }
        | DELIM_lsq DELIM_rsq Dims  %prec PREC_shift_Dims { }
        ;
    
    qDims: { }
        | Dims { }
        ;
        
    AdditionalBound:
        OPERATOR_bitwiseand Name { }                                      
        ;
    
    pAdditionalBound:
        AdditionalBound { }
        | pAdditionalBound AdditionalBound { }
        ;

    /****************** NAMES  ******************/
    Name:
        Name DELIM_period Identifier { }
        | Identifier { }
        ;
    sCommaName: { }
        | sCommaName DELIM_comma Name { }
        ;
    NameList:
        Name sCommaName { }
        ;

    /****************** PACKAGES and MODULES  ******************/
    CompilationUnit:
        OrdinaryCompilationUnit { 
            root = $$;
            root -> sym_tab = main_table;

            for(auto &entry : $1 -> entry_list) {
                root -> sym_tab -> add_entry(entry);
            }
        }
        ;
    
    OrdinaryCompilationUnit:
        sImportDeclaration sTopLevelClassOrInterfaceDeclaration {
            // checking duplicate class names
            if($2) {
                map<string, int> count_class;
                for(auto &entry : $2 -> entry_list) {
                    count_class[entry -> name]++;
                    if(count_class[entry -> name] > 1) {
                        cout << "ERROR: Duplicate class " << entry -> name << " at line number " << entry -> line_no << endl;
                        exit(1);
                    }
                }
                $$ -> entry_list = $2 -> entry_list;
                $2 -> entry_list . clear();
            }

        }
        | PackageDeclaration sImportDeclaration sTopLevelClassOrInterfaceDeclaration { 

            if($3) {
                map<string, int> count_class;
                for(auto &entry : $3 -> entry_list) {
                    count_class[entry -> name]++;
                    if(count_class[entry -> name] > 1) {
                        cout << "ERROR: Duplicate class " << entry -> name << " at line number " << entry -> line_no << endl;
                        exit(1);
                    }
                }
                $$ -> entry_list = $3 -> entry_list;
                $3 -> entry_list . clear();
            }
        }
        ;
    
    sImportDeclaration: { }
        |  sImportDeclaration ImportDeclaration { }
        ;
    
    ImportDeclaration:  KEYWORD_import importName DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    importName: KEYWORD_static Name { }
        | KEYWORD_static Name DELIM_period OPERATOR_multiply { }
        | Name DELIM_period OPERATOR_multiply { }
        | Name { }
        ;                
    
    PackageDeclaration:
        KEYWORD_package Name DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    sTopLevelClassOrInterfaceDeclaration: { }
        | sTopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclaration { 
            if($1 && $1 -> entry_list . size() > 0) {
                $$ -> entry_list = $1 -> entry_list;
                $1 -> entry_list . clear();
            }

            $$ -> entry_list.push_back($2 -> sym_tab_entry);
        }
        ;
    
    TopLevelClassOrInterfaceDeclaration:
        NormalClassDeclaration { 
            $$ -> sym_tab_entry = $1 -> sym_tab_entry;
        }
        | DELIM_semicolon { 
            count_semicolon++;
        }
        ; 
    
    /****************** CLASSES  ******************/
    
    Modifiers:
        Modifier { 
            $$ -> entry_list.push_back($1 -> sym_tab_entry);
        }
        | Modifiers Modifier {
            $$ -> entry_list = $1 -> entry_list;
            $1 -> entry_list.clear();
            for(auto entry : $$ -> entry_list){
                if(entry->name == $2 -> sym_tab_entry -> name){
                    cout << "ERROR: The modifier " << entry->name << " has been used more than once in the same declaration." << endl;
                    exit(1);
                }
            }
            $$ -> entry_list.push_back($2 -> sym_tab_entry);
        } 
        ;
    Modifier:
        KEYWORD_public { 
            $$ -> sym_tab_entry = new st_entry("public", yylineno, 0);
        }
        | KEYWORD_private { 
            $$ -> sym_tab_entry = new st_entry("private", yylineno, 0);
        }
        | KEYWORD_protected { 
            $$ -> sym_tab_entry = new st_entry("protected", yylineno, 0);
        }
        | KEYWORD_static { 
            $$ -> sym_tab_entry = new st_entry("static", yylineno, 0);
        }
        | KEYWORD_abstract { 
            $$ -> sym_tab_entry = new st_entry("abstract", yylineno, 0);
        }
        | KEYWORD_native { 
            $$ -> sym_tab_entry = new st_entry("native", yylineno, 0);
        }
        | KEYWORD_synchronized { 
            $$ -> sym_tab_entry = new st_entry("synchronized", yylineno, 0);
        }
        | KEYWORD_transient { 
            $$ -> sym_tab_entry = new st_entry("transient", yylineno, 0);
        }
        | KEYWORD_volatile { 
            $$ -> sym_tab_entry = new st_entry("volatile", yylineno, 0);
        }
        | KEYWORD_final { 
            $$ -> sym_tab_entry = new st_entry("final", yylineno, 0);
        }
        ;

    NormalClassDeclaration:
        Modifiers KEYWORD_class Identifier qClassExtends qClassImplements qClassPermits ClassBody { 
            {
                int ppp_count = 0, snf_count = 0, af_count = 0;
                for(auto entry : $1 -> entry_list){
                    ppp_count += (entry->name == "public");
                    ppp_count += (entry->name == "private");
                    ppp_count += (entry->name == "protected");
                    snf_count += (entry->name == "sealed");
                    snf_count += (entry->name == "non-sealed");
                    snf_count += (entry->name == "final");
                    af_count += (entry->name == "final");
                    af_count += (entry->name == "abstract");
                    if(!(entry->name=="public"||entry->name=="private"||entry->name=="protected"||entry->name=="sealed"||entry->name=="non-sealed"||entry->name=="final"||entry->name=="static"||entry->name=="abstract")){
                        cout <<"ERROR: The Modifier " << entry->name << "is not allowed for ClassDeclaration.\n";
                        exit(1);
                    }
                }
                if(ppp_count > 1){
                    cout<<"ERROR in line " << yylineno << ": NormalClassDeclaration should be ONE of public, private, OR protected.\n";
                    exit(1);
                }
                if(snf_count > 1){
                    cout<<"ERROR in line " << yylineno << ": NormalClassDeclaration should be ONE of sealed, non-sealed, OR final.\n";
                    exit(1);
                }
                if(af_count > 1){
                    cout<<"ERROR in line " << yylineno << ": NormalClassDeclaration should be ONE of abstract, OR final.\n";
                    exit(1);
                }
            }
            // Need to check funcs from classbody whether they are abstract for an abstract class and final for a final class
            // Need to check qExtends: if non-sealed class has a sealed superclass
            // If superclass is non-sealed, then class must not be non-sealed
            // If superclass is sealed, then class snf_count must be at least (exactly) one

            $$ -> sym_tab = new symbol_table_class($3);     // Class symbol table created
            ((symbol_table_class*) $$ -> sym_tab) -> update_modifiers($1 -> entry_list);
            $$ -> sym_tab_entry = new st_entry($3, $1 -> entry_list[0] -> line_no, count_semicolon, $3);    // Symbol table entry for the global symbol table
            ($$ -> sym_tab_entry) -> update_modifiers($1 -> entry_list);
        }
        | KEYWORD_class Identifier qClassExtends qClassImplements qClassPermits ClassBody { 

            $$ -> sym_tab = new symbol_table_class($2);     // Class symbol table created
            $$ -> sym_tab_entry = new st_entry($2, yylineno, count_semicolon, $2);      // Symbol table entry for the global symbol table
        }
        ;

    ClassExtends:
        KEYWORD_extends Name { }
        ;
    
    qClassExtends: { }
        | ClassExtends { }
        ;
    
    ClassImplements:
        KEYWORD_implements NameList { }
        ;
    
    qClassImplements: { }
        | ClassImplements { }
        ;
        
    ClassPermits:
        KEYWORD_permits Name sCommaName { }
        ;
    
    qClassPermits: 
        { }
        | ClassPermits { }
        ;
    
    ClassBody:
        DELIM_lcurl sClassBodyDeclaration DELIM_rcurl { }
        ;
    
    qClassBody:
        { }
        | ClassBody { }
        ;
    
    ClassBodyDeclaration: 
        ClassMemberDeclaration { }
        | InstanceInitializer { }
        | StaticInitializer { }
        | ConstructorDeclaration { }
        ;
    
    sClassBodyDeclaration: { }
        | sClassBodyDeclaration ClassBodyDeclaration { }
        ;
    
    ClassMemberDeclaration: 
        FieldDeclaration { }
        | MethodDeclaration { }
        | NormalClassDeclaration { }
        | DELIM_semicolon { 
            count_semicolon++;
        }
        ;

    FieldDeclaration: 
        Modifiers UnannType VariableDeclaratorList DELIM_semicolon { 
            int ppp_count = 0, fv_count = 0;
            for(auto entry : $1 -> entry_list){
                ppp_count += (entry->name == "public");
                ppp_count += (entry->name == "private");
                ppp_count += (entry->name == "protected");
                fv_count += (entry->name == "final");
                fv_count += (entry->name == "volatile");
                
                if(!(entry->name=="public"||entry->name=="private"||entry->name=="protected"||entry->name=="final"||entry->name=="static"||entry->name=="transient"||entry->name=="volatile")){
                    cout <<"ERROR: The Modifier " << entry->name << "is not allowed for Field Declaration.\n";
                    exit(1);
                }
            }
            if(ppp_count > 1){
                cout<<"ERROR: FieldDeclaration modifier should be ONE of public, private, OR protected.\n";
                exit(1);
            }
            if(fv_count > 1){
                cout<<"ERROR: FieldDeclaration modifier should be ONE of final or volatile.\n";
                exit(1);
            }
            // Need to check assignment of final static/non-static fields

            $$ -> entry_list = $3 -> entry_list;
            $3 -> entry_list . clear();
            string type = $$ -> get_name($2);
            for(auto (&entry) : $$ -> entry_list) {
                entry -> update_type(type);
                entry -> dimensions = $2 -> sym_tab_entry -> dimensions;
                entry -> update_modifiers($1 -> entry_list);
                entry -> initialized = true;    // field variables are initialized with default values
            }

            count_semicolon++;
        }
        | UnannType VariableDeclaratorList DELIM_semicolon {

            $$ -> entry_list = $2 -> entry_list;
            $2 -> entry_list . clear();
            string type = $$ -> get_name($1);
            for(auto (&entry) : $$ -> entry_list) {
                entry -> update_type(type);
                entry -> dimensions = $1 -> sym_tab_entry -> dimensions;
                entry -> initialized = true;    // field variables are initialized with default values
                // cout << entry -> name << " " << entry -> line_no << " " << entry -> stmt_no << " " << entry -> type << " " << entry -> dimensions << '\n'; 
            }

            count_semicolon++;
        }
        ;
    
    VariableDeclaratorList: 
        VariableDeclarator sCommaVariableDeclarator        %prec PREC_reduce_VariableDeclaratorList {
            if($2 == NULL) {
                $$ -> entry_list.push_back($1 -> sym_tab_entry); 
            }
            else {
                $$ -> entry_list . push_back($1 -> sym_tab_entry);
                for(const auto (&entry) : $2 -> entry_list){
                    $$ -> entry_list . push_back(entry);
                }
                $2 -> entry_list . clear();
            }
        }
        ;
    
    sCommaVariableDeclarator: { }
        | sCommaVariableDeclarator DELIM_comma VariableDeclarator    %prec DELIM_comma { 
            if($1 != NULL){
                $$ -> entry_list = $1 -> entry_list;
                $1 -> entry_list . clear();
            }
            $$ -> entry_list.push_back($3 -> sym_tab_entry);    
        }
        ;
    
    VariableDeclarator: VariableDeclaratorId qEqualVariableInitializer { 
            $$ -> sym_tab_entry = $1 -> sym_tab_entry;
        }
        ;
    
    VariableDeclaratorId: Identifier qDims { 
            $$ -> sym_tab_entry = new st_entry($1, yylineno, count_semicolon);
            $$ -> sym_tab_entry -> dimensions = $$ -> get_dims($2);
        }
        ;
    
    qEqualVariableInitializer: { }
        | OPERATOR_equal VariableInitializer { 
            $$->exp_applicable = true;
        }
        ;
    
    VariableInitializer: 
        Expression { }
        | ArrayInitializer { }
        ;

    UnannType:
        PrimitiveType { 
            string primitive_name = $$ -> get_name($1);
            $$ -> sym_tab_entry = new st_entry(primitive_name, yylineno, count_semicolon);
        } 
        | NumericTypeDims { 
            string primitive_name = $$ -> get_name($1 -> children[0]);
            $$ -> sym_tab_entry = new st_entry(primitive_name, yylineno, count_semicolon);
            $$ -> sym_tab_entry -> dimensions = $$ -> get_dims($1 -> children[1]);
        }
        | BooleanDims { 
            string primitive_name = $$ -> get_name($1 -> children[0]);
            $$ -> sym_tab_entry = new st_entry(primitive_name, yylineno, count_semicolon);
            $$ -> sym_tab_entry -> dimensions = $$ -> get_dims($1 -> children[1]);
        }
        | Name qDims { 
            string qualified_name = $$ -> get_name($1);
            $$ -> sym_tab_entry = new st_entry(qualified_name, yylineno, count_semicolon);
            $$ -> sym_tab_entry -> dimensions = $$ -> get_dims($2);
        }
        ;   
    
    MethodDeclaration: 
        Modifiers MethodHeader MethodBody { 
            {
                // Modifiers check
                bool flag = false;
                
                for(auto (&entry) : ($1 -> entry_list)){
                    if(!(entry->name=="public" || entry->name=="private" || entry->name=="protected" || entry->name=="final" || entry->name=="static" || entry->name=="abstract" || entry->name=="synchronized" || entry->name=="native" || entry->name=="strictfp")){
                        cout <<"ERROR in line " << yylineno << ": The Modifier " << entry->name << "is not allowed for Field Declaration.\n";
                        exit(1);
                    }
                }
                flag = false;

                for(auto (&entry) : ($1 -> entry_list)){
                // Modifier can be one of public, protected, private
                    if(entry->name == "public" || entry->name == "private" || entry->name == "protected"){
                        if(flag){
                            cout<<"ERROR in line " << yylineno << ": MethodDeclaration should be ONE of public, private, OR protected.\n";
                            exit(1);
                        }
                        flag = true;
                    }
                }
                flag = false;

                // If modifier has abstract, it cannot have private, static, final, native, strictfp, or synchronized
                for(auto (&entry) : ($1 -> entry_list)){
                    flag |= (entry->name == "abstract");
                }
                if(flag){ // Modifier list has abstract
                    flag = false;
                    for(auto (&entry) : ($1 -> entry_list)){
                        if(entry->name == "private" || entry->name == "static" || entry->name == "final"){
                            cout<<"ERROR in line " << yylineno << ": Illegal Modifier " << entry->name << " used with abstract MethodDeclaration.\n";
                            exit(1);
                        }
                        if(entry->name == "native" || entry->name == "strictfp" || entry->name == "synchronized"){
                            cout<<"ERROR in line " << yylineno << ": Illegal Modifier " << entry->name << " used with abstract MethodDeclaration.\n";
                            exit(1);
                        }
                    }
                }else{
                    flag = false;
                    
                    // If modifier has native, cannot have strictfp
                    for(auto (&entry) : ($1 -> entry_list)){
                        flag |= (entry->name == "native");
                    }
                    if(flag){ // Modifier list has native
                        for(auto (&entry) : ($1 -> entry_list)){
                            if(entry->name == "strictfp"){
                                cout<<"ERROR in line " << yylineno << ": native MethodDeclaration cannot have strictfp modifier in list.\n";
                                exit(1);
                            }
                        }
                    }
                }
            }

            $$ -> sym_tab_entry = $2 -> sym_tab_entry;
            ($$ -> sym_tab_entry) -> update_modifiers($1 -> entry_list);
            $$ -> entry_list = $2 -> entry_list;
            $2 -> entry_list . clear();
            $$ -> sym_tab = new symbol_table_func($$ -> sym_tab_entry -> name, $$ -> entry_list);
            ((symbol_table_func*) $$ -> sym_tab) -> update_modifiers($1 -> entry_list);

            // cout << "Method identifier: " << $$ -> sym_tab_entry -> name << endl;
            // cout << "Method return type: " << $$ -> sym_tab_entry -> type << endl;
            // cout << "Method return type dimensions: " << $$ -> sym_tab_entry -> dimensions << endl;
            // for(auto &entry : $$ -> entry_list) {
            //     cout << "Formal Parameter identifier: " << entry -> name << endl;
            //     cout << "Formal Parameter type: " << entry -> type << endl;
            //     cout << "Formal Parameter dimension: " << entry -> dimensions << endl;
            // }
        }
        | MethodHeader MethodBody { 
            $$ -> sym_tab_entry = $1 -> sym_tab_entry;
            $$ -> entry_list = $1 -> entry_list;
            $1 -> entry_list . clear();
            $$ -> sym_tab = new symbol_table_func($$ -> sym_tab_entry -> name, $$ -> entry_list);

            // cout << "Method identifier: " << $$ -> sym_tab_entry -> name << endl;
            // cout << "Method return type: " << $$ -> sym_tab_entry -> type << endl;
            // cout << "Method return type dimensions: " << $$ -> sym_tab_entry -> dimensions << endl;
            // for(auto &entry : $$ -> entry_list) {
            //     cout << "Formal Parameter identifier: " << entry -> name << endl;
            //     cout << "Formal Parameter type: " << entry -> type << endl;
            //     cout << "Formal Parameter dimension: " << entry -> dimensions << endl;
            // }
        }
        ;

    MethodHeader: 
        UnannType MethodDeclarator qThrows { 
            $$ -> sym_tab_entry = $2 -> sym_tab_entry;
            $$ -> entry_list = $2 -> entry_list;
            $$ -> sym_tab_entry -> update_type($1 -> sym_tab_entry -> name);
            $$ -> sym_tab_entry -> dimensions = $1 -> sym_tab_entry -> dimensions;
        }
        | KEYWORD_void MethodDeclarator qThrows {
            $$ -> sym_tab_entry = $2 -> sym_tab_entry;
            $$ -> entry_list = $2 -> entry_list;
            $$ -> sym_tab_entry -> update_type("void");
        }
        ;

    MethodDeclarator: 
        Identifier DELIM_lpar qFormalParameterList DELIM_rpar qDims { 
            $$ -> sym_tab_entry = new st_entry($1, yylineno, count_semicolon);
            if($3) {
                $$ -> entry_list = $3 -> entry_list;
            }
        }   
        | Identifier DELIM_lpar ReceiverParameterComma qFormalParameterList DELIM_rpar qDims {  
            
        } 
        ;
    
    ReceiverParameterComma: 
        ReceiverParameter DELIM_comma { }
        ;
    
    ReceiverParameter: 
        UnannType qIdentifierDot KEYWORD_this { }
        ;
    
    IdentifierDot: 
        Identifier DELIM_period { }
        ;
    
    qIdentifierDot: { }
        | IdentifierDot { }
        ;

    FormalParameterList: 
        FormalParameter sCommaFormalParameter {
            $$ -> entry_list.push_back($1 -> sym_tab_entry);
            if($2) {
                for(auto (&entry) : $2 -> entry_list){
                    $$ -> entry_list.push_back(entry);
                    if($1 -> sym_tab_entry -> name == entry -> name) {
                        cout << "ERROR: Duplicate formal parameters " << entry -> name << " defined at line number: " << $1 -> sym_tab_entry -> line_no << endl;
                        exit(1);
                    }
                }
            }
        }
        ;
    
    qFormalParameterList: { }
        | FormalParameterList { 
            $$ -> entry_list = $1 -> entry_list;
        }
        ;
    
    FormalParameter:
        Modifiers UnannType VariableDeclaratorId { 
            if($1 -> entry_list.size() != 1 || ($1 -> entry_list)[0] -> name != "final"){
                cout<<"ERROR in line " << yylineno << ": FormalParameter Modifier list must contain only final.\n";
                exit(1);
            }
            $$ -> sym_tab_entry = $3 -> sym_tab_entry;
            $$ -> sym_tab_entry -> update_type($2 -> sym_tab_entry -> name);
            $$ -> sym_tab_entry -> dimensions = $2 -> sym_tab_entry -> dimensions + $3 -> sym_tab_entry -> dimensions;
            $$ -> sym_tab_entry -> update_modifiers($1 -> entry_list);
        }
        | UnannType VariableDeclaratorId { 
            $$ -> sym_tab_entry = $2 -> sym_tab_entry;
            $$ -> sym_tab_entry -> update_type($1 -> sym_tab_entry -> name);
            $$ -> sym_tab_entry -> dimensions = $1 -> sym_tab_entry -> dimensions + $2 -> sym_tab_entry -> dimensions;
        }         
        | VariableArityParameter { } 
        ;
    
    sCommaFormalParameter: { }
        | sCommaFormalParameter DELIM_comma FormalParameter {
            if($1) {
                $$ -> entry_list = $1 -> entry_list;
            }
            $$ -> entry_list.push_back($3 -> sym_tab_entry);
        }
        ;
    
    VariableArityParameter: 
        Modifiers UnannType DELIM_ellipsis Identifier { 
            if($1 -> entry_list.size() != 1 || ($1 -> entry_list)[0] -> name != "final"){
                cout<<"ERROR in line " << yylineno << ": VariableArityParameter Modifier list must contain only final.\n";
                exit(1);
            }
        }
        | UnannType DELIM_ellipsis Identifier { }
        ;

    Throws: 
        KEYWORD_throws NameList { }
        ;
    
    qThrows: 
        { }
        |  Throws  { }
        ;
    
    MethodBody: 
        Block { }
        | DELIM_semicolon { 
            count_semicolon++;
        }
        ;

    InstanceInitializer: 
        Block { }
        ;
    
    StaticInitializer: 
        KEYWORD_static Block { }
        ;

    ConstructorDeclaration: 
        Modifiers ConstructorDeclarator qThrows ConstructorBody { 
            if($1 -> entry_list.size() != 1 || (($1 -> entry_list)[0] -> name != "public" && ($1 -> entry_list)[0] -> name != "private" && ($1 -> entry_list)[0] -> name != "protected")){
                cout<<"ERROR in line " << yylineno << ": Constructor Declaration Modifier list must only contain one of pubilc OR private OR protected.\n";
                exit(1);
            }
            
            $$ -> sym_tab_entry = $2 -> sym_tab_entry;
            $$ -> sym_tab_entry -> update_modifiers($1 -> entry_list);
            $$ -> entry_list = $2 -> entry_list;
            $2 -> entry_list . clear();
            $$ -> sym_tab = new symbol_table_func($$ -> sym_tab_entry -> name, $$ -> entry_list);
            ((symbol_table_func*) $$ -> sym_tab) -> update_modifiers($1 -> entry_list);
        }
        | ConstructorDeclarator qThrows ConstructorBody { 
            $$ -> sym_tab_entry = $1 -> sym_tab_entry;
            $$ -> entry_list = $1 -> entry_list;
            $1 -> entry_list . clear();
            $$ -> sym_tab = new symbol_table_func($$ -> sym_tab_entry -> name, $$ -> entry_list);
        }
        ;

    ConstructorDeclarator: 
        Identifier DELIM_lpar qFormalParameterList DELIM_rpar { 
            $$ -> sym_tab_entry = new st_entry($1, yylineno, count_semicolon);
            if($3){
                $$ -> entry_list = $3 -> entry_list;
            }
        }
        |   Identifier DELIM_lpar ReceiverParameterComma qFormalParameterList DELIM_rpar { }
        ;

    ConstructorBody: 
        DELIM_lcurl qBlockStatements DELIM_rcurl { }                                                                                                    
        | DELIM_lcurl ExplicitConstructorInvocation qBlockStatements DELIM_rcurl { }
        ;
                    
    ExplicitConstructorInvocation: 
        KEYWORD_this BracketArgumentList DELIM_semicolon { 
            count_semicolon++;
        }
        | KEYWORD_super BracketArgumentList DELIM_semicolon { 
            count_semicolon++;
        }
        | Name DELIM_period KEYWORD_super BracketArgumentList DELIM_semicolon { 
            count_semicolon++;
        }
        | Primary DELIM_period KEYWORD_super BracketArgumentList DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    BracketArgumentList: DELIM_lpar qArgumentList DELIM_rpar { }
        ;

    /************** ARRAYS  ******************/

    ArrayInitializer: 
        DELIM_lcurl qVariableInitializerList qComma DELIM_rcurl { }
        ;
    
    qComma:
        { }
        | DELIM_comma { }
        ;
    
    sCommaVariableInitializer: 
        { }
        | sCommaVariableInitializer DELIM_comma VariableInitializer %prec DELIM_comma { }
        ;
    
    VariableInitializerList: 
        VariableInitializer sCommaVariableInitializer %prec PREC_reduce_VariableInitializerList { }
        ;
    
    qVariableInitializerList: 
        { }                          
        | VariableInitializerList { }
        ;

    /************** BLOCKS ******************/

    Block:
        DELIM_lcurl DELIM_rcurl { }
        | DELIM_lcurl BlockStatements DELIM_rcurl {
            $$ -> sym_tab = new symbol_table();
        }
        ;
    
    qBlockStatements: 
        { }
        |   BlockStatements { }
        ;
    
    BlockStatements:
        BlockStatement { }
        |   BlockStatement BlockStatements { }
        ;
    
    BlockStatement:
        LocalClassOrInterfaceDeclaration { }
        |   LocalVariableDeclarationStatement { }
        |   Statement { }
        ;
    
    LocalClassOrInterfaceDeclaration:
        NormalClassDeclaration { }
        ;
    
    LocalVariableDeclarationStatement:
        LocalVariableDeclaration DELIM_semicolon {
            count_semicolon++;  // declaration statement, hence statement count increased
        }
        ;
    
    LocalVariableDeclaration:
        Modifiers LocalVariableType VariableDeclaratorList { 
            if($1 -> entry_list.size() != 1 || ($1 -> entry_list)[0] -> name != "final"){
                cout<<"ERROR in line " << yylineno << ": LocalVariableDeclaration Modifier list must contain only final.\n";
                exit(1);
            }
            $$ -> entry_list = $2 -> entry_list;
            $2 -> entry_list . clear();
            string type = $$ -> get_name($1);
            for(auto (&entry) : $$ -> entry_list) {
                entry -> update_type(type);
                entry -> dimensions = ($1 -> sym_tab_entry ? $1 -> sym_tab_entry -> dimensions : 0);
                entry -> update_modifiers($1 -> entry_list);
                // cout << entry -> name << " " << entry -> line_no << " " << entry -> stmt_no << " " << entry -> type << " " << entry -> dimensions << '\n'; 
            }
        }
        | LocalVariableType VariableDeclaratorList { 
            $$ -> entry_list = $2 -> entry_list;
            $2 -> entry_list . clear();
            string type = $$ -> get_name($1);
            for(auto (&entry) : $$ -> entry_list) {
                entry -> update_type(type);
                entry -> dimensions = ($1 -> sym_tab_entry ? $1 -> sym_tab_entry -> dimensions : 0);

                // cout << entry -> name << " " << entry -> line_no << " " << entry -> stmt_no << " " << entry -> type << " " << entry -> dimensions << '\n'; 
            }
        }
        ;
    
    LocalVariableType:
        UnannType {
            $$ -> sym_tab_entry = $1 -> sym_tab_entry;
        }
        |   KEYWORD_var {
            
        }
        ;
    
    Statement:
        StatementWithoutTrailingSubstatement { }
        |   LabeledStatement { }
        |   IfThenStatement { }
        |   IfThenElseStatement { }
        |   WhileStatement { }
        |   ForStatement { }
        ;
    
    StatementNoShortIf:
        StatementWithoutTrailingSubstatement { }
        |   LabeledStatementNoShortIf { }
        |   IfThenElseStatementNoShortIf { }
        |   WhileStatementNoShortIf { }
        |   ForStatementNoShortIf { }
        ;
    
    StatementWithoutTrailingSubstatement:
        Block { }
        |   EmptyStatement { }
        |   ExpressionStatement { }
        |   AssertStatement { }
        |   DoStatement { }
        |   BreakStatement { }
        |   ContinueStatement { }
        |   ReturnStatement { }
        |   SynchronizedStatement { }
        |   ThrowStatement { }
        |   TryStatement { }
        |   YieldStatement { }
        ;
    
    EmptyStatement:
        DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    LabeledStatement:
        Identifier OPERATOR_ternarycolon Statement { }
        ;
    
    LabeledStatementNoShortIf:
        Identifier OPERATOR_ternarycolon StatementNoShortIf { }
        ;
    
    ExpressionStatement:
        StatementExpression DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    StatementExpression:
        Assignment { }
        |   PreIncrementExpression { }
        |   PreDecrementExpression { }
        |   PostIncrementExpression { }
        |   PostDecrementExpression { }
        |   MethodInvocation { }
        |   ClassInstanceCreationExpression { }
        ;
    
    IfThenStatement:
        KEYWORD_if DELIM_lpar Expression DELIM_rpar Statement { }
        ;
    
    IfThenElseStatement:
        KEYWORD_if DELIM_lpar Expression DELIM_rpar StatementNoShortIf KEYWORD_else Statement { }
        ;
    
    IfThenElseStatementNoShortIf:
        KEYWORD_if DELIM_lpar Expression DELIM_rpar StatementNoShortIf KEYWORD_else StatementNoShortIf { }
        ;
    
    AssertStatement:
        KEYWORD_assert Expression DELIM_semicolon { 
            count_semicolon++;
        }
        | KEYWORD_assert Expression OPERATOR_ternarycolon Expression DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    WhileStatement:
        KEYWORD_while DELIM_lpar Expression DELIM_rpar Statement { }
        ;
    
    WhileStatementNoShortIf:
        KEYWORD_while DELIM_lpar Expression DELIM_rpar StatementNoShortIf { }
        ;
    
    DoStatement:
        KEYWORD_do Statement KEYWORD_while DELIM_lpar Expression DELIM_rpar DELIM_semicolon { }
        ;
        
    ForStatement:
        BasicForStatement { }
        |   EnhancedForStatement { }
        ;
    
    ForStatementNoShortIf:
        BasicForStatementNoShortIf { }
        |   EnhancedForStatementNoShortIf { }
        ;
    
    BasicForStatement:
        KEYWORD_for DELIM_lpar qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate DELIM_rpar Statement { 
            $$ -> sym_tab = new symbol_table();
        }
        ;
    
    BasicForStatementNoShortIf:
        KEYWORD_for DELIM_lpar qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate DELIM_rpar StatementNoShortIf { 
            $$ -> sym_tab = new symbol_table();
        }
        ;
    
    qForInit:     
        { }
        |   ForInit { }
        ;
    
    qForUpdate:
        { }
        |   ForUpdate { }
        ;
    
    ForInit:
        StatementExpressionList { }
        |   LocalVariableDeclaration { }
        ;
    
    ForUpdate:
        StatementExpressionList { }
        ;
    
    StatementExpressionList:
        StatementExpression sCommaStatementExpression { }
        ;
    
    sCommaStatementExpression:
        { }
        |   sCommaStatementExpression DELIM_comma StatementExpression { }
        ;
    
    EnhancedForStatement:
        KEYWORD_for DELIM_lpar LocalVariableDeclaration OPERATOR_ternarycolon Expression DELIM_rpar Statement { 
            $$ -> sym_tab = new symbol_table();
        }
        ;
    
    EnhancedForStatementNoShortIf:
        KEYWORD_for DELIM_lpar LocalVariableDeclaration OPERATOR_ternarycolon Expression DELIM_rpar StatementNoShortIf {
            $$ -> sym_tab = new symbol_table();
         }
        ;
    
    BreakStatement:
        KEYWORD_break qIdentifier DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    qIdentifier:   
        { }
        |   Identifier { }
        ;
    
    YieldStatement:
        KEYWORD_yield Expression DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    ContinueStatement:
        KEYWORD_continue qIdentifier DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    ReturnStatement:
        KEYWORD_return qExpression DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    qExpression:   
        { }
        |   Expression { }
        ;
    
    ThrowStatement:
        KEYWORD_throw Expression DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    SynchronizedStatement:
        KEYWORD_synchronized DELIM_lpar Expression DELIM_rpar Block { }
        ;
    
    TryStatement:
        KEYWORD_try Block Catches { }
        |   KEYWORD_try Block qCatches Finally { }
        |   TryWithResourcesStatement { }
        ;
    
    qCatches: 
        { }
        |   Catches { }
        ;
    
    pCatches:
        CatchClause { }
        |   pCatches CatchClause { }
        ;
    
    Catches:
        pCatches { }
        ;
    
    CatchClause:
        KEYWORD_catch DELIM_lpar CatchFormalParameter DELIM_rpar Block { }
        ;
    
    CatchFormalParameter:
        Modifiers CatchType VariableDeclaratorId { 
            if($1 -> entry_list.size() != 1 || ($1 -> entry_list)[0] -> name != "final"){
                cout<<"ERROR in line " << yylineno << ": CatchFormalParameter Modifier list must contain only final.\n";
                exit(1);
            }
            $3 -> sym_tab_entry -> update_modifiers($1 -> entry_list);
        }    
        |   CatchType VariableDeclaratorId { }
        ;
    
    CatchType:
        Name sOrName { }
        ;
    
    sOrName:  
        { }
        | sOrName OPERATOR_bitwiseor Name { } 
        ;
    
    Finally:
        KEYWORD_finally Block { }
        ;
    
    TryWithResourcesStatement:
        KEYWORD_try ResourceSpecification Block qCatches qFinally { }
        ;
    
    qFinally: 
        { }
        |   Finally { }
        ;
    
    ResourceSpecification:
        DELIM_lpar ResourceList qSemicolon DELIM_rpar { }
        ;
    
    qSemicolon: 
        { }
        | DELIM_semicolon { 
            count_semicolon++;
        }
        ;
    
    ResourceList:
        Resource ssemicolonResource     %prec PREC_reduce_ResourceList { }
        ;
    
    ssemicolonResource:                                                             
        { }
        | ssemicolonResource DELIM_semicolon Resource     %prec DELIM_semicolon { 
            count_semicolon++;
        } // shift over reduce
        ;
    
    Resource:
        LocalVariableDeclaration { }
        |   VariableAccess { }
        ;
    
    VariableAccess:
        Name { }
        | FieldAccess { }
        ;
    
    Pattern:
        TypePattern { }
        ;
    
    TypePattern:
        LocalVariableDeclaration { }
        ;

    /****************** EXPRESSIONS (ASSIGNMENT) ******************/

    Expression:
        AssignmentExpression { }
        ;

    AssignmentExpression:
        ConditionalExpression { }
        |   Assignment { }
        ;
    
    ConditionalExpression:
        ConditionalOrExpression         %prec PREC_cond_to_condor { }
        |   ConditionalOrExpression OPERATOR_ternaryquestion Expression OPERATOR_ternarycolon ConditionalExpression { 
            $$->exp_applicable = true;
        }
        ;

    ConditionalOrExpression:
        ConditionalAndExpression        %prec PREC_condor_to_condand { }
        |   ConditionalOrExpression OPERATOR_logicalor ConditionalAndExpression { 
            $$->exp_applicable = true;
        }
        ;

    ConditionalAndExpression:
        InclusiveOrExpression           %prec PREC_condand_to_incor { }
        |   ConditionalAndExpression OPERATOR_logicaland InclusiveOrExpression { 
            $$->exp_applicable = true;
        }
        ;

    InclusiveOrExpression:
            ExclusiveOrExpression       %prec PREC_incor_to_excor { }
        |   InclusiveOrExpression OPERATOR_bitwiseor ExclusiveOrExpression { 
            $$->exp_applicable = true;
        }
        ;

    ExclusiveOrExpression:
        AndExpression               %prec PREC_excor_to_and { }
        |   ExclusiveOrExpression OPERATOR_xor AndExpression { 
            $$->exp_applicable = true;
        }
        ;

    AndExpression:
        EqualityExpression          %prec PREC_and_to_equality { }
        |   AndExpression OPERATOR_bitwiseand EqualityExpression { 
            $$->exp_applicable = true;
        }
        ;

    EqualityExpression: 
        RelationalExpression    %prec PREC_equality_to_relational { }
        |   EqualityExpression OPERATOR_logicalequal RelationalExpression { 
            $$->exp_applicable = true;
        }    
        |   EqualityExpression OPERATOR_neq RelationalExpression { 
            $$->exp_applicable = true;
        }
        ;

    RelationalExpression:
        ShiftExpression { }
        |   RelationalExpression OPERATOR_lt ShiftExpression { 
            $$->exp_applicable = true;
        }   
        |   RelationalExpression OPERATOR_gt ShiftExpression { 
            $$->exp_applicable = true;
        }
        |   RelationalExpression OPERATOR_leq ShiftExpression { 
            $$->exp_applicable = true;
        }
        |   RelationalExpression OPERATOR_geq ShiftExpression { 
            $$->exp_applicable = true;
        }
        |   InstanceofExpression { }
        ;

    ShiftExpression:
        AdditiveExpression { }
        |   ShiftExpression OPERATOR_leftshift AdditiveExpression { 
            $$->exp_applicable = true;
        }
        |   ShiftExpression OPERATOR_rightshift AdditiveExpression { 
            $$->exp_applicable = true;
        }
        |   ShiftExpression OPERATOR_unsignedrightshift AdditiveExpression { 
            $$->exp_applicable = true;
        }
        ;

    AdditiveExpression:
        MultiplicativeExpression { }
        |   AdditiveExpression OPERATOR_plus MultiplicativeExpression { 
            $$->exp_applicable = true;
        }
        |   AdditiveExpression OPERATOR_minus MultiplicativeExpression { 
            $$->exp_applicable = true;
        }
        ;

    MultiplicativeExpression:
        UnaryExpression { }
        |   MultiplicativeExpression OPERATOR_multiply UnaryExpression { 
            $$->exp_applicable = true;
        }
        |   MultiplicativeExpression OPERATOR_divide UnaryExpression { 
            $$->exp_applicable = true;
        }
        |   MultiplicativeExpression OPERATOR_mod UnaryExpression { 
            $$->exp_applicable = true;
        }
        ;

    UnaryExpression:
        PreIncrementExpression { }
        |   PreDecrementExpression { }
        |   OPERATOR_plus UnaryExpression       %prec UNARY_plus { 
            $$->exp_applicable = true;
        }
        |   OPERATOR_minus UnaryExpression      %prec UNARY_minus { 
            $$->exp_applicable = true;
        }
        |   UnaryExpressionNotPlusMinus { }
        ;

    PreIncrementExpression:
        OPERATOR_increment UnaryExpression { }
        ;

    PreDecrementExpression:
        OPERATOR_decrement UnaryExpression { }
        ;
    
    UnaryExpressionNotPlusMinus:
        Name { }
        |   PostfixExpression { }
        |   OPERATOR_bitwisecomp UnaryExpression { 
            $$->exp_applicable = true;
        }
        |   OPERATOR_not UnaryExpression { 
            $$->exp_applicable = true;
        }
        |   CastExpression { }
        ;
    
    PostfixExpression:
        Primary { }
        |   PostIncrementExpression { }
        |   PostDecrementExpression { }
        ;
    
    Primary:
        PrimaryNoNewArray { }
        |   ArrayCreationExpression { }
        ;
    
    PrimaryNoNewArray:
        Literal { }
        |   ClassLiteral { }
        |   KEYWORD_this { }
        |   Name DELIM_period KEYWORD_this { }
        |   DELIM_lpar Expression DELIM_rpar { }
        |   ClassInstanceCreationExpression { }
        |   FieldAccess { }
        |   ArrayAccess { }
        |   MethodInvocation { }
        |   MethodReference { }
        ;
    
    Literal : 
        LITERAL_integer { }
        | LITERAL_floatingpoint { }
        | LITERAL_boolean { }
        | LITERAL_char { } 
        | LITERAL_string { }
        | LITERAL_textblock { }
        | LITERAL_null { }
        ;
    
    ClassLiteral:
        Name DELIM_period KEYWORD_class { }
        |   Name Dims qDims DELIM_period KEYWORD_class { }
        |   NumericType qDims DELIM_period KEYWORD_class { }
        |   KEYWORD_boolean qDims DELIM_period KEYWORD_class { }
        |   KEYWORD_void DELIM_period KEYWORD_class { }
        ;
    
    ClassInstanceCreationExpression:
        UnqualifiedClassInstanceCreationExpression { }
        |   Name DELIM_period UnqualifiedClassInstanceCreationExpression { }
        |   Primary DELIM_period UnqualifiedClassInstanceCreationExpression { }
        ;
    
    UnqualifiedClassInstanceCreationExpression:
        KEYWORD_new Name BracketArgumentList qClassBody { }
        ;
    
    qArgumentList:
        { } 
        | ArgumentList { }
        ;
    
    ArgumentList: 
        Expression sCommaExpression { }
        ;
    
    sCommaExpression:                                               
        { }
        | DELIM_comma Expression sCommaExpression { } 
        ;
    
    FieldAccess:
        Primary DELIM_period Identifier { }
        |   KEYWORD_super DELIM_period Identifier { }
        |   Name DELIM_period KEYWORD_super DELIM_period Identifier { }
        ;
    
    ArrayAccess:
        Name DELIM_lsq Expression DELIM_rsq { }
        |   PrimaryNoNewArray DELIM_lsq Expression DELIM_rsq { }
        ;
    
    MethodInvocation:
        Name BracketArgumentList { }
        |   Primary DELIM_period Identifier BracketArgumentList { }
        |   KEYWORD_super DELIM_period  Identifier BracketArgumentList { }
        |   Name DELIM_period KEYWORD_super DELIM_period Identifier BracketArgumentList { }
        ; 
    
    MethodReference:
        Name DELIM_proportion Identifier { }
        |   Primary DELIM_proportion Identifier { }
        |   ArrayType DELIM_proportion Identifier { }
        |   KEYWORD_super DELIM_proportion Identifier { }
        |   Name DELIM_period KEYWORD_super DELIM_proportion Identifier { }
        |   Name DELIM_proportion KEYWORD_new { }
        |   ArrayType DELIM_proportion KEYWORD_new { }
        ;
    
    ArrayCreationExpression:
        KEYWORD_new PrimitiveType DimExprs qDims { }
        |   KEYWORD_new Name DimExprs qDims { }
        |   KEYWORD_new PrimitiveType Dims ArrayInitializer { }
        |   KEYWORD_new Name Dims ArrayInitializer { }
        ;
    
    DimExprs: 
        DimExpr { }
        | DimExprs DimExpr { }
        ;
    
    DimExpr: 
        DELIM_lsq Expression DELIM_rsq { } 
        ;
    
    PostIncrementExpression: 
        Name OPERATOR_increment { } 
        | PostfixExpression OPERATOR_increment { } 
        ;
    
    PostDecrementExpression: 
        Name OPERATOR_decrement { }                          
        | PostfixExpression OPERATOR_decrement { } 
        ; 
    
    // Partial implementation of casting. Cannot cast classes
    CastExpression:     
        DELIM_lpar PrimitiveType DELIM_rpar UnaryExpression { }
        |   DELIM_lpar ArrayType DELIM_rpar UnaryExpressionNotPlusMinus { }
        |   DELIM_lpar ArrayType pAdditionalBound DELIM_rpar UnaryExpressionNotPlusMinus { }
        ;
    
    InstanceofExpression:
        RelationalExpression KEYWORD_instanceof ArrayType { }
        |   RelationalExpression KEYWORD_instanceof Name { }
        |   RelationalExpression KEYWORD_instanceof Pattern { }
        ;
           
    Assignment:
        LeftHandSide OPERATOR_assignment Expression { 
            $$->exp_applicable = true;
        }
        | LeftHandSide OPERATOR_equal Expression { 
            $$->exp_applicable = true;
        }
        ;
    
    LeftHandSide:
        Name { }
        |   FieldAccess { }
        |   ArrayAccess { }
        ;   
%%

void yyerror(const char *error)
{
    printf("ERROR:%s in line number: %d\n", error, yylineno);
    exit(0);
}
