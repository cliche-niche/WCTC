%{

    #include <cstdio> 
    #include <cstring>
    #include <iostream>
    #include <vector>
    #include <stdio.h>
    #include "node.cpp"
    #include "symbol_table.cpp"

    using namespace std;

    extern "C" int yylex();
    extern "C" int yylineno;
    ull num_scopes;
    unsigned long long int count_semicolon;
    void yyerror(const char* s);
    void add_child(node* parent, node* child);

    node* root;     // contains the root node of the parse tree
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

%token KEYWORD_class KEYWORD_extends KEYWORD_super KEYWORD_package KEYWORD_public KEYWORD_private KEYWORD_abstract KEYWORD_static KEYWORD_final KEYWORD_sealed KEYWORD_nonsealed KEYWORD_strictfp KEYWORD_implements KEYWORD_import KEYWORD_permits KEYWORD_transient KEYWORD_volatile KEYWORD_synchronized KEYWORD_native KEYWORD_void KEYWORD_this KEYWORD_enum KEYWORD_if KEYWORD_else KEYWORD_assert KEYWORD_while KEYWORD_for KEYWORD_break KEYWORD_yield KEYWORD_continue KEYWORD_return KEYWORD_throw KEYWORD_try KEYWORD_catch KEYWORD_finally KEYWORD_boolean KEYWORD_new KEYWORD_var KEYWORD_byte KEYWORD_short KEYWORD_int KEYWORD_long KEYWORD_char KEYWORD_float KEYWORD_double KEYWORD_protected KEYWORD_throws
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

%type<treenode> IntegralType FloatingPointType PrimitiveType NumericType ArrayType Dims qDims Name Modifiers CompilationUnit OrdinaryCompilationUnit Modifier sCommaName NameList AdditionalBound pAdditionalBound ArrayInitializer qComma sCommaVariableInitializer VariableInitializerList qVariableInitializerList sImportDeclaration ImportDeclaration importName  PackageDeclaration sTopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclaration ClassExtends qClassExtends ClassImplements qClassImplements Block qBlockStatements BlockStatements BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration LocalVariableType Statement StatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement LabeledStatementNoShortIf ExpressionStatement StatementExpression IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement WhileStatement WhileStatementNoShortIf ForStatement ForStatementNoShortIf BasicForStatement BasicForStatementNoShortIf qForInit qForUpdate ForInit ForUpdate StatementExpressionList sCommaStatementExpression EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement qIdentifier YieldStatement ContinueStatement ReturnStatement qExpression ThrowStatement SynchronizedStatement TryStatement qCatches pCatches Catches CatchClause CatchFormalParameter CatchType sOrName Finally TryWithResourcesStatement qFinally ResourceSpecification qSemicolon ResourceList ssemicolonResource Resource VariableAccess Pattern TypePattern NormalClassDeclaration ClassPermits qClassPermits ClassBody qClassBody ClassBodyDeclaration sClassBodyDeclaration ClassMemberDeclaration FieldDeclaration VariableDeclaratorList sCommaVariableDeclarator VariableDeclarator VariableDeclaratorId qEqualVariableInitializer VariableInitializer UnannType MethodDeclaration MethodHeader MethodDeclarator ReceiverParameterComma ReceiverParameter IdentifierDot qIdentifierDot FormalParameterList qFormalParameterList FormalParameter sCommaFormalParameter VariableArityParameter Throws qThrows MethodBody InstanceInitializer StaticInitializer ConstructorDeclaration ConstructorDeclarator ConstructorBody ExplicitConstructorInvocation BracketArgumentList UnaryExpression PreIncrementExpression UnaryExpressionNotPlusMinus PostfixExpression Primary PrimaryNoNewArray Literal ClassLiteral ClassInstanceCreationExpression UnqualifiedClassInstanceCreationExpression qArgumentList ArgumentList sCommaExpression FieldAccess ArrayAccess MethodInvocation MethodReference ArrayCreationExpression DimExprs DimExpr PostIncrementExpression PostDecrementExpression CastExpression InstanceofExpression Assignment LeftHandSide Expression AssignmentExpression ConditionalExpression ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression ShiftExpression AdditiveExpression MultiplicativeExpression PreDecrementExpression BooleanDims NumericTypeDims 

%start CompilationUnit

%%
    /****************** TYPES, VALUES AND VARIABLES  ******************/
    IntegralType:
		KEYWORD_byte {
			node *temp_node;
			$$ = new node("byte",true,"KEYWORD");
 }
        | KEYWORD_short {
			node *temp_node;
			$$ = new node("short",true,"KEYWORD");
 }
        | KEYWORD_int {
			node *temp_node;
			$$ = new node("int",true,"KEYWORD");
 }
        | KEYWORD_long {
			node *temp_node;
			$$ = new node("long",true,"KEYWORD");
 }
        | KEYWORD_char {
			node *temp_node;
			$$ = new node("char",true,"KEYWORD");
 }
        ;
    FloatingPointType:
		KEYWORD_float {
			node *temp_node;
			$$ = new node("float",true,"KEYWORD");
 }
        | KEYWORD_double {
			node *temp_node;
			$$ = new node("double",true,"KEYWORD");
 }
        ;
    // ! sAnnotation and Annotation removed 
    // sAnnotation: | sAnnotation Annotation ;
    // ! sAnnotation removed
    PrimitiveType:
		NumericType {
			node *temp_node;
			$$ = new node("PrimitiveType");
			$$->add_child($1);
 }
        | KEYWORD_boolean {
			node *temp_node;
			$$ = new node("boolean",true,"KEYWORD");
 }
        ;
    
    // Non terminal for Java style array declaration support
    NumericTypeDims:
		NumericType Dims {
			node *temp_node;
			$$ = new node("NumericTypeDims");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    // Non terminal for Java style array declaration support
    BooleanDims:
		KEYWORD_boolean Dims {
			node *temp_node;
			$$ = new node("BooleanDims");
			temp_node = new node("boolean",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
 }
        ;
    
    NumericType :
		IntegralType {
			node *temp_node;
			$$ = new node("NumericType");
			$$->add_child($1);
 }
        | FloatingPointType {
			node *temp_node;
			$$ = new node("NumericType");
			$$->add_child($1);
 }
        ;
    // ReferenceType: ArrayType ; // ClassOrInterfaceType is same as ClassType
    // ClassOrInterfaceType: ClassType | InterfaceType
    // ! sAnnotation removed
    // ClassType: Identifier | Name DELIM_period Identifier | ClassType DELIM_period Identifier // We ignore TypeArguments and replace ClassType with Name everywhere
    // InterfaceType: ClassType
    // TypeIdentifier: Identifier // Replaced by Identifier
    // ! sAnnotation
    // TypeVariable: TypeIdentifier ; // TypeIdentifier is same as Identifier, therefore TypeVariable just replaced by Identifier
    ArrayType:
		Name Dims {
			node *temp_node;
			$$ = new node("ArrayType");
			$$->add_child($1);
			$$->add_child($2);
 }
        ; // Java style array declarations ignored
    // ! sAnnotation
    Dims:
		DELIM_lsq DELIM_rsq %prec PREC_reduce_Dims {
			node *temp_node;
			$$ = new node("Dims");
			temp_node = new node("[",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("]",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        | DELIM_lsq DELIM_rsq Dims %prec PREC_shift_Dims {
			node *temp_node;
			$$ = new node("Dims");
			temp_node = new node("[",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("]",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        ;
    qDims:
		{
			$$ = NULL;
 }
        | Dims {
			node *temp_node;
			$$ = new node("qDims");
			$$->add_child($1);
 }
        ;
    
    // TypeParameter: sAnnotation TypeIdentifier qTypeBound ;
    // TypeParameterModifier: Annotation //TypeParameterModifier is same as Annotation
    // TypeBound: KEYWORD_extends TypeVariable | KEYWORD_extends ClassType sAdditionalBound ; // useless symbol
    // qTypeBound: | TypeBound ; // useless symbol
    AdditionalBound:
		OPERATOR_bitwiseand Name {
			node *temp_node;
			$$ = new node("AdditionalBound");
			temp_node = new node("&",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($2);
 }                                      
        ;
    pAdditionalBound:
		AdditionalBound {
			node *temp_node;
			$$ = new node("pAdditionalBound");
			$$->add_child($1);
 }
        | pAdditionalBound AdditionalBound {
			node *temp_node;
			$$ = new node("pAdditionalBound");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    // TypeArgumentList: TypeArgument sCommaTypeArgument ; // useless symbol
    // sCommaTypeArgument: | sCommaTypeArgument DELIM_comma TypeArgument ; // useless symbol
    // TypeArgument: ReferenceType | Wildcard ; // useless symbol
    // ! sAnnotation
    // Wildcard: OPERATOR_ternaryquestion qWildcardBounds ; // useless symbol
    // WildcardBounds: KEYWORD_extends ReferenceType | KEYWORD_super ReferenceType ; // useless symbol
    // qWildcardBounds: | WildcardBounds; // useless symbol

    /****************** NAMES  ******************/
    Name:
		Name DELIM_period Identifier {
			node *temp_node;
			$$ = new node("Name");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        | Identifier {
			node *temp_node;
			string s($1);
			$$ = new node(s,true,"ID");
 }
        ;
    sCommaName:
		{
			$$ = NULL;
 }
        | sCommaName DELIM_comma Name {
			node *temp_node;
			$$ = new node("sCommaName");
			$$->add_child($1);
			temp_node = new node(",",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        ;
    NameList:
		Name sCommaName {
			node *temp_node;
			$$ = new node("NameList");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;

    /****************** PACKAGES and MODULES  ******************/
    CompilationUnit:
		OrdinaryCompilationUnit {
			node *temp_node;
			$$ = new node("CompilationUnit");
			$$->add_child($1);
 
            root = $$;
        }
        ; // used to be OrdinaryCompilationUnit | ModularCompilationUnit;
    OrdinaryCompilationUnit:
		sImportDeclaration sTopLevelClassOrInterfaceDeclaration {
			node *temp_node;
			$$ = new node("OrdinaryCompilationUnit");
			$$->add_child($1);
			$$->add_child($2);
 }
        | PackageDeclaration sImportDeclaration sTopLevelClassOrInterfaceDeclaration {
			node *temp_node;
			$$ = new node("OrdinaryCompilationUnit");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
 }
        ;
    
    sImportDeclaration:
		{
			$$ = NULL;
 }
        | sImportDeclaration ImportDeclaration {
			node *temp_node;
			$$ = new node("sImportDeclaration");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    ImportDeclaration:
		KEYWORD_import importName DELIM_semicolon {
			node *temp_node;
			$$ = new node("ImportDeclaration");
			temp_node = new node("import",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    importName:
		KEYWORD_static Name {
			node *temp_node;
			$$ = new node("importName");
			temp_node = new node("static",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
 }
        | KEYWORD_static Name DELIM_period OPERATOR_multiply {
			node *temp_node;
			$$ = new node("importName");
			temp_node = new node("static",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("*",true,"OPERATOR");
			$$->add_child(temp_node);
 }
        | Name DELIM_period OPERATOR_multiply {
			node *temp_node;
			$$ = new node("importName");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("*",true,"OPERATOR");
			$$->add_child(temp_node);
 }
        | Name {
			node *temp_node;
			$$ = new node("importName");
			$$->add_child($1);
 }
        ;                
    
    PackageDeclaration:
		KEYWORD_package Name DELIM_semicolon {
			node *temp_node;
			$$ = new node("PackageDeclaration");
			temp_node = new node("package",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    
    sTopLevelClassOrInterfaceDeclaration:
		{
			$$ = NULL;
 }
        | sTopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclaration {
			node *temp_node;
			$$ = new node("sTopLevelClassOrInterfaceDeclaration");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    TopLevelClassOrInterfaceDeclaration:
		NormalClassDeclaration {
			node *temp_node;
			$$ = new node("TopLevelClassOrInterfaceDeclaration");
			$$->add_child($1);
 }
        | DELIM_semicolon {
			node *temp_node;
			$$ = new node(";",true,"DELIMITER");
 
            count_semicolon++;
        }
        ; // ClassDeclaration is the same as NormalClassDeclaration
   
    // ModularCompilationUnit: ModuleDeclaration;
    // ModuleDeclaration: sAnnotation qopen KEYWORD_module Identifier sDotIdentifier DELIM_lcurl sModuleDirective DELIM_rcurl ;
    // qopen: KEYWORD_open | ;
    // sDotIdentifier: | sDotIdentifier DELIM_period Identifier;
    // sModuleDirective: | sModuleDirective ModuleDirective;
    // ModuleDirective:
        // KEYWORD_requires sRequiresModifier ModuleName ";"
        // | KEYWORD_exports PackageName qVeryWeirdThing ";"
        // | KEYWORD_opens PackageName qVeryWeirdThing ";"
        // | KEYWORD_uses TypeName;
    // provides TypeName with TypeName { } ;
    // RequiresModifier:
    // (one of)
    // transitive static
    
    /****************** CLASSES  ******************/
    // ClassDeclaration: NormalClassDeclaration | EnumDeclaration | RecordDeclaration we only implement Normal Class Declaration

    Modifiers:
		Modifier {
			node *temp_node;
			$$ = new node("Modifiers");
			$$->add_child($1);
 
            $$ -> entry_list.push_back($1 -> sym_tab_entry);
        }
        | Modifiers Modifier {
			node *temp_node;
			$$ = new node("Modifiers");
			$$->add_child($1);
			$$->add_child($2);

            $$ -> entry_list = $1 -> entry_list;
            $$ -> entry_list.push_back($2 -> sym_tab_entry);
        } 
        ;
    Modifier:
		KEYWORD_public {
			node *temp_node;
			$$ = new node("public",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("public", 0, 0);
        }
        | KEYWORD_private {
			node *temp_node;
			$$ = new node("private",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("private", 0, 0);
        }
        | KEYWORD_protected {
			node *temp_node;
			$$ = new node("protected",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("protected", 0, 0);
        }
        | KEYWORD_static {
			node *temp_node;
			$$ = new node("static",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("static", 0, 0);
        }
        | KEYWORD_abstract {
			node *temp_node;
			$$ = new node("abstract",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("abstract", 0, 0);
        }
        | KEYWORD_native {
			node *temp_node;
			$$ = new node("native",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("native", 0, 0);
        }
        | KEYWORD_synchronized {
			node *temp_node;
			$$ = new node("synchronized",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("synchronized", 0, 0);
        }
        | KEYWORD_transient {
			node *temp_node;
			$$ = new node("transient",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("transient", 0, 0);
        }
        | KEYWORD_volatile {
			node *temp_node;
			$$ = new node("volatile",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("volatile", 0, 0);
        }
        | KEYWORD_final {
			node *temp_node;
			$$ = new node("final",true,"KEYWORD");
 
            $$ -> sym_tab_entry = new st_entry("final", 0, 0);
        }
        ;

    NormalClassDeclaration:
		Modifiers KEYWORD_class Identifier qClassExtends qClassImplements qClassPermits ClassBody {
			node *temp_node;
			$$ = new node("NormalClassDeclaration");
			$$->add_child($1);
			temp_node = new node("class",true,"KEYWORD");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			$$->add_child($4);
			$$->add_child($5);
			$$->add_child($6);
			$$->add_child($7);
 
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
        }
        | KEYWORD_class Identifier qClassExtends qClassImplements qClassPermits ClassBody {
			node *temp_node;
			$$ = new node("NormalClassDeclaration");
			temp_node = new node("class",true,"KEYWORD");
			$$->add_child(temp_node);
			string s($2);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			$$->add_child($3);
			$$->add_child($4);
			$$->add_child($5);
			$$->add_child($6);
 }
        ;

    // ClassModifier: KEYWORD_public | KEYWORD_private | KEYWORD_abstract | KEYWORD_static | KEYWORD_final | KEYWORD_sealed | KEYWORD_nonsealed | KEYWORD_strictfp ;
    // sClassModifier: | sClassModifier ClassModifier ;

    ClassExtends:
		KEYWORD_extends Name {
			node *temp_node;
			$$ = new node("ClassExtends");
			temp_node = new node("extends",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
 }
        ;
    qClassExtends:
		{
			$$ = NULL;
 }
    | ClassExtends {
			node *temp_node;
			$$ = new node("qClassExtends");
			$$->add_child($1);
 }
    ;
    ClassImplements:
		KEYWORD_implements NameList {
			node *temp_node;
			$$ = new node("ClassImplements");
			temp_node = new node("implements",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
 }
        ;
    qClassImplements:
		{
			$$ = NULL;
 }
        | ClassImplements {
			node *temp_node;
			$$ = new node("qClassImplements");
			$$->add_child($1);
 }
        ;
    // InterfaceTypeList: Name sCommaName ; // replaced by NameList
    ClassPermits:
		KEYWORD_permits Name sCommaName {
			node *temp_node;
			$$ = new node("ClassPermits");
			temp_node = new node("permits",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
 }
        ;
    qClassPermits:
		{
			$$ = NULL;
 }
        | ClassPermits {
			node *temp_node;
			$$ = new node("qClassPermits");
			$$->add_child($1);
 }
        ;
    ClassBody:
		DELIM_lcurl sClassBodyDeclaration DELIM_rcurl {
			node *temp_node;
			$$ = new node("ClassBody");
			temp_node = new node("{",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node("}",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        ;
    qClassBody:
		{
			$$ = NULL;
 }
        | ClassBody {
			node *temp_node;
			$$ = new node("qClassBody");
			$$->add_child($1);
 }
        ;
    ClassBodyDeclaration:
		ClassMemberDeclaration {
			node *temp_node;
			$$ = new node("ClassBodyDeclaration");
			$$->add_child($1);
 }
        | InstanceInitializer {
			node *temp_node;
			$$ = new node("ClassBodyDeclaration");
			$$->add_child($1);
 }
        | StaticInitializer {
			node *temp_node;
			$$ = new node("ClassBodyDeclaration");
			$$->add_child($1);
 }
        | ConstructorDeclaration {
			node *temp_node;
			$$ = new node("ClassBodyDeclaration");
			$$->add_child($1);
 }
        ;
    sClassBodyDeclaration:
		{
			$$ = NULL;
 }
        | sClassBodyDeclaration ClassBodyDeclaration {
			node *temp_node;
			$$ = new node("sClassBodyDeclaration");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    
    ClassMemberDeclaration:
		FieldDeclaration {
			node *temp_node;
			$$ = new node("ClassMemberDeclaration");
			$$->add_child($1);
 }
        | MethodDeclaration {
			node *temp_node;
			$$ = new node("ClassMemberDeclaration");
			$$->add_child($1);
 }
        | NormalClassDeclaration {
			node *temp_node;
			$$ = new node("ClassMemberDeclaration");
			$$->add_child($1);
 }
        | DELIM_semicolon {
			node *temp_node;
			$$ = new node(";",true,"DELIMITER");
 
            count_semicolon++;
        }
        ; // ClassDeclaration is the same as NormalClassDeclaration, removed InterfaceDeclaration

    FieldDeclaration:
		Modifiers UnannType VariableDeclaratorList DELIM_semicolon {
			node *temp_node;
			$$ = new node("FieldDeclaration");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
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

                cout << entry -> name << " " << entry -> line_no << " " << entry -> stmt_no << " " << entry -> type << " " << entry -> dimensions << '\n'; 
            }

            count_semicolon++;
        }
        | UnannType VariableDeclaratorList DELIM_semicolon {
			node *temp_node;
			$$ = new node("FieldDeclaration");
			$$->add_child($1);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);


            $$ -> entry_list = $2 -> entry_list;
            $2 -> entry_list . clear();
            string type = $$ -> get_name($1);
            for(auto (&entry) : $$ -> entry_list) {
                entry -> update_type(type);
                entry -> dimensions = $1 -> sym_tab_entry -> dimensions;

                cout << entry -> name << " " << entry -> line_no << " " << entry -> stmt_no << " " << entry -> type << " " << entry -> dimensions << '\n'; 
            }

            count_semicolon++;
        }
    // ! Annotation removed
    // FieldModifier: KEYWORD_public | KEYWORD_private | KEYWORD_static | KEYWORD_final | KEYWORD_transient | KEYWORD_volatile ; 
    // sFieldModifier: | sFieldModifier FieldModifier ;
    
    VariableDeclaratorList:
		VariableDeclarator sCommaVariableDeclarator %prec PREC_reduce_VariableDeclaratorList {
			node *temp_node;
			$$ = new node("VariableDeclaratorList");
			$$->add_child($1);
			$$->add_child($2);

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
    sCommaVariableDeclarator:
		{
			$$ = NULL;
 }
        | sCommaVariableDeclarator DELIM_comma VariableDeclarator %prec DELIM_comma {
			node *temp_node;
			$$ = new node("sCommaVariableDeclarator");
			$$->add_child($1);
			temp_node = new node(",",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            if($1 != NULL){
                $$ -> entry_list = $1 -> entry_list;
                $1 -> entry_list . clear();
            }
            $$ -> entry_list.push_back($3 -> sym_tab_entry);    
        }
        ;
    VariableDeclarator:
		VariableDeclaratorId qEqualVariableInitializer {
			node *temp_node;
			$$ = new node("VariableDeclarator");
			$$->add_child($1);
			$$->add_child($2);
 
            $$ -> sym_tab_entry = $1 -> sym_tab_entry;
        }
        ;
    VariableDeclaratorId:
		Identifier qDims {
			node *temp_node;
			$$ = new node("VariableDeclaratorId");
			string s($1);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			$$->add_child($2);
 
            $$ -> sym_tab_entry = new st_entry($1, yylineno, count_semicolon);
            $$ -> sym_tab_entry -> dimensions = $$ -> get_dims($2);
        }
        ;
    qEqualVariableInitializer:
		{
			$$ = NULL;
 }
        | OPERATOR_equal VariableInitializer {
			node *temp_node;
			$$ = new node("qEqualVariableInitializer");
			temp_node = new node("=",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($2);
 
            $$->exp_applicable = true;
        }
        ;
    VariableInitializer:
		Expression {
			node *temp_node;
			$$ = new node("VariableInitializer");
			$$->add_child($1);
 }
        | ArrayInitializer {
			node *temp_node;
			$$ = new node("VariableInitializer");
			$$->add_child($1);
 }
        ;

    UnannType:
		PrimitiveType {
			node *temp_node;
			$$ = new node("UnannType");
			$$->add_child($1);
 
            string primitive_name = $$ -> get_name($1);
            $$ -> sym_tab_entry = new st_entry(primitive_name, yylineno, count_semicolon);
        } 
        | NumericTypeDims {
			node *temp_node;
			$$ = new node("UnannType");
			$$->add_child($1);
 
            string primitive_name = $$ -> get_name($1 -> children[0]);
            $$ -> sym_tab_entry = new st_entry(primitive_name, yylineno, count_semicolon);
            $$ -> sym_tab_entry -> dimensions = $$ -> get_dims($1 -> children[1]);
        }
        | BooleanDims {
			node *temp_node;
			$$ = new node("UnannType");
			$$->add_child($1);
 
            string primitive_name = $$ -> get_name($1 -> children[0]);
            $$ -> sym_tab_entry = new st_entry(primitive_name, yylineno, count_semicolon);
            $$ -> sym_tab_entry -> dimensions = $$ -> get_dims($1 -> children[1]);
        }
        | Name qDims {
			node *temp_node;
			$$ = new node("UnannType");
			$$->add_child($1);
			$$->add_child($2);
 
            string qualified_name = $$ -> get_name($1);
            $$ -> sym_tab_entry = new st_entry(qualified_name, yylineno, count_semicolon);
            $$ -> sym_tab_entry -> dimensions = $$ -> get_dims($2);
        }
        ;   
    
    // UnannPrimitiveType: NumericType | KEYWORD_boolean ; // ? literal
    // UnannReferenceType: Name | ArrayType ; //UnannInterfaceType is same as UnannClassType
    // UnannClassOrInterfaceType: UnannClassType | UnannIn  erfaceType ;
    
    // ! sAnnotation
    // UnannClassType: Identifier | Name DELIM_period Identifier | UnannClassType DELIM_period Identifier ; // Replaced by Name
    // UnannInterfaceType: UnannClassType
    // UnannTypeVariable: Identifier // ? Do we remove this? ################## // Replaced by Identifier everywhere
    // UnannArrayType: PrimitiveType Dims | Name Dims

    MethodDeclaration:
		Modifiers MethodHeader MethodBody {
			node *temp_node;
			$$ = new node("MethodDeclaration");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
 
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
            $$ -> entry_list = $2 -> entry_list;

            cout << "Method identifier: " << $$ -> sym_tab_entry -> name << endl;
            cout << "Method return type: " << $$ -> sym_tab_entry -> type << endl;
            cout << "Method return type dimensions: " << $$ -> sym_tab_entry -> dimensions << endl;
            for(auto &entry : $$ -> entry_list) {
                cout << "Formal Parameter identifier: " << entry -> name << endl;
                cout << "Formal Parameter type: " << entry -> type << endl;
                cout << "Formal Parameter dimension: " << entry -> dimensions << endl;
            }
        }
        | MethodHeader MethodBody {
			node *temp_node;
			$$ = new node("MethodDeclaration");
			$$->add_child($1);
			$$->add_child($2);
 
            $$ -> sym_tab_entry = $1 -> sym_tab_entry;
            $$ -> entry_list = $1 -> entry_list;

            cout << "Method identifier: " << $$ -> sym_tab_entry -> name << endl;
            cout << "Method return type: " << $$ -> sym_tab_entry -> type << endl;
            cout << "Method return type dimensions: " << $$ -> sym_tab_entry -> dimensions << endl;
            for(auto &entry : $$ -> entry_list) {
                cout << "Formal Parameter identifier: " << entry -> name << endl;
                cout << "Formal Parameter type: " << entry -> type << endl;
                cout << "Formal Parameter dimension: " << entry -> dimensions << endl;
            }
        }
        ;

    // ! Annotation removed
    // MethodModifier: KEYWORD_public | KEYWORD_private | KEYWORD_abstract | KEYWORD_static | KEYWORD_final | KEYWORD_synchronized | KEYWORD_native | KEYWORD_strictfp ;
    // sMethodModifier: | sMethodModifier MethodModifier ;

    //  ! Removing this rule: | TypeParameters sAnnotation Result MethodDeclarator qThrows
    MethodHeader:
		UnannType MethodDeclarator qThrows {
			node *temp_node;
			$$ = new node("MethodHeader");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
 
            $$ -> sym_tab_entry = $2 -> sym_tab_entry;
            $$ -> entry_list = $2 -> entry_list;
            $$ -> sym_tab_entry -> update_type($1 -> sym_tab_entry -> name);
            $$ -> sym_tab_entry -> dimensions = $1 -> sym_tab_entry -> dimensions;
        }
        | KEYWORD_void MethodDeclarator qThrows {
			node *temp_node;
			$$ = new node("MethodHeader");
			temp_node = new node("void",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);

            $$ -> sym_tab_entry = $2 -> sym_tab_entry;
            $$ -> entry_list = $2 -> entry_list;
            $$ -> sym_tab_entry -> update_type("void");
        }
        ;

    MethodDeclarator:
		Identifier DELIM_lpar qFormalParameterList DELIM_rpar qDims {
			node *temp_node;
			$$ = new node("MethodDeclarator");
			string s($1);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
 
            $$ -> sym_tab_entry = new st_entry($1, yylineno, count_semicolon);
            if($3) {
                $$ -> entry_list = $3 -> entry_list;
            }
        }   
        | Identifier DELIM_lpar ReceiverParameterComma qFormalParameterList DELIM_rpar qDims {
			node *temp_node;
			$$ = new node("MethodDeclarator");
			string s($1);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			$$->add_child($4);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($6);
  

        } 
        ; // qreceiverparametercomma was here
    ReceiverParameterComma:
		ReceiverParameter DELIM_comma {
			node *temp_node;
			$$ = new node("ReceiverParameterComma");
			$$->add_child($1);
			temp_node = new node(",",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        ;
    // ! sAnnotation
    ReceiverParameter:
		UnannType qIdentifierDot KEYWORD_this {
			node *temp_node;
			$$ = new node("ReceiverParameter");
			$$->add_child($1);
			$$->add_child($2);
			temp_node = new node("this",true,"KEYWORD");
			$$->add_child(temp_node);
 }
        ;
    // qReceiverParameterComma: | ReceiverParameterComma ;
    IdentifierDot:
		Identifier DELIM_period {
			node *temp_node;
			$$ = new node("IdentifierDot");
			string s($1);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);

        }
        ;
    qIdentifierDot:
		{
			$$ = NULL;
 }
        | IdentifierDot {
			node *temp_node;
			$$ = new node("qIdentifierDot");
			$$->add_child($1);
 }
        ;

    FormalParameterList:
		FormalParameter sCommaFormalParameter {
			node *temp_node;
			$$ = new node("FormalParameterList");
			$$->add_child($1);
			$$->add_child($2);
 
            $$ -> entry_list.push_back($1 -> sym_tab_entry);
            if($2) {
                for(auto (&entry) : $2 -> entry_list){
                    $$ -> entry_list.push_back(entry);
                }
            }
        }
        ;
    qFormalParameterList:
		{
			$$ = NULL;
 }
        | FormalParameterList {
			node *temp_node;
			$$ = new node("qFormalParameterList");
			$$->add_child($1);
 
            $$ -> entry_list = $1 -> entry_list;
        }
        ;
    FormalParameter:
		Modifiers UnannType VariableDeclaratorId {
			node *temp_node;
			$$ = new node("FormalParameter");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
 
            if($1 -> entry_list.size() != 1 || ($1 -> entry_list)[0] -> name != "final"){
                cout<<"ERROR in line " << yylineno << ": FormalParameter Modifier list must contain only final.\n";
                exit(1);
            }
            $$ -> sym_tab_entry = $3 -> sym_tab_entry;
            $$ -> sym_tab_entry -> update_type($2 -> sym_tab_entry -> name);
            $$ -> sym_tab_entry -> dimensions = $2 -> sym_tab_entry -> dimensions + $3 -> sym_tab_entry -> dimensions;
        }
        | UnannType VariableDeclaratorId {
			node *temp_node;
			$$ = new node("FormalParameter");
			$$->add_child($1);
			$$->add_child($2);
 
            $$ -> sym_tab_entry = $2 -> sym_tab_entry;
            $$ -> sym_tab_entry -> update_type($1 -> sym_tab_entry -> name);
            $$ -> sym_tab_entry -> dimensions = $1 -> sym_tab_entry -> dimensions + $2 -> sym_tab_entry -> dimensions;
        }         
        | VariableArityParameter {
			node *temp_node;
			$$ = new node("FormalParameter");
			$$->add_child($1);
 } 
        ;
    sCommaFormalParameter:
		{
			$$ = NULL;
 }
        | sCommaFormalParameter DELIM_comma FormalParameter {
			node *temp_node;
			$$ = new node("sCommaFormalParameter");
			$$->add_child($1);
			temp_node = new node(",",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);

            if($1) {
                $$ -> entry_list = $1 -> entry_list;
            }
            $$ -> entry_list.push_back($3 -> sym_tab_entry);
    ;
        }
    // ! sAnnotation and Annotation removed
    VariableArityParameter:
		Modifiers UnannType DELIM_ellipsis Identifier {
			node *temp_node;
			$$ = new node("VariableArityParameter");
			$$->add_child($1);
			$$->add_child($2);
			temp_node = new node("...",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($4);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 
            if($1 -> entry_list.size() != 1 || ($1 -> entry_list)[0] -> name != "final"){
                cout<<"ERROR in line " << yylineno << ": VariableArityParameter Modifier list must contain only final.\n";
                exit(1);
            }
        }
        | UnannType DELIM_ellipsis Identifier {
			node *temp_node;
			$$ = new node("VariableArityParameter");
			$$->add_child($1);
			temp_node = new node("...",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        ;

    Throws:
		KEYWORD_throws NameList {
			node *temp_node;
			$$ = new node("Throws");
			temp_node = new node("throws",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
 }
        ;
    qThrows:
		{
			$$ = NULL;
 }
        | Throws {
			node *temp_node;
			$$ = new node("qThrows");
			$$->add_child($1);
 }
        ;
    // ExceptionTypeList: Name sCommaName ; // Replaced by NameList
    
    MethodBody:
		Block {
			node *temp_node;
			$$ = new node("MethodBody");
			$$->add_child($1);
 }
        | DELIM_semicolon {
			node *temp_node;
			$$ = new node(";",true,"DELIMITER");
 
            count_semicolon++;
        }
        ;

    InstanceInitializer:
		Block {
			node *temp_node;
			$$ = new node("InstanceInitializer");
			$$->add_child($1);
 }
        ;
    StaticInitializer:
		KEYWORD_static Block {
			node *temp_node;
			$$ = new node("StaticInitializer");
			temp_node = new node("static",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
 }
        ;

    ConstructorDeclaration:
		Modifiers ConstructorDeclarator qThrows ConstructorBody {
			node *temp_node;
			$$ = new node("ConstructorDeclaration");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
			$$->add_child($4);
 
            if($1 -> entry_list.size() != 1 || (($1 -> entry_list)[0] -> name != "public" && ($1 -> entry_list)[0] -> name != "private" && ($1 -> entry_list)[0] -> name != "protected")){
                cout<<"ERROR in line " << yylineno << ": Constructor Declaration Modifier list must only contain one of pubilc OR private OR protected.\n";
                exit(1);
            }
        }
        | ConstructorDeclarator qThrows ConstructorBody {
			node *temp_node;
			$$ = new node("ConstructorDeclaration");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
 }
        ;
    // ! Annotation removed
    // ConstructorModifier: KEYWORD_public | KEYWORD_private ;
    // sConstructorModifier: | sConstructorModifier ConstructorModifier ;

    ConstructorDeclarator:
		Name DELIM_lpar qFormalParameterList DELIM_rpar {
			node *temp_node;
			$$ = new node("ConstructorDeclarator");
			$$->add_child($1);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        | Name DELIM_lpar ReceiverParameterComma qFormalParameterList DELIM_rpar {
			node *temp_node;
			$$ = new node("ConstructorDeclarator");
			$$->add_child($1);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			$$->add_child($4);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        ;

    ConstructorBody:
		DELIM_lcurl qBlockStatements DELIM_rcurl {
			node *temp_node;
			$$ = new node("ConstructorBody");
			temp_node = new node("{",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node("}",true,"DELIMITER");
			$$->add_child(temp_node);
 }                                                                                                    
        | DELIM_lcurl ExplicitConstructorInvocation qBlockStatements DELIM_rcurl {
			node *temp_node;
			$$ = new node("ConstructorBody");
			temp_node = new node("{",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			temp_node = new node("}",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        ;
                    
    ExplicitConstructorInvocation:
		KEYWORD_this BracketArgumentList DELIM_semicolon {
			node *temp_node;
			$$ = new node("ExplicitConstructorInvocation");
			temp_node = new node("this",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        | KEYWORD_super BracketArgumentList DELIM_semicolon {
			node *temp_node;
			$$ = new node("ExplicitConstructorInvocation");
			temp_node = new node("super",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        | Name DELIM_period KEYWORD_super BracketArgumentList DELIM_semicolon {
			node *temp_node;
			$$ = new node("ExplicitConstructorInvocation");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("super",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($4);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        | Primary DELIM_period KEYWORD_super BracketArgumentList DELIM_semicolon {
			node *temp_node;
			$$ = new node("ExplicitConstructorInvocation");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("super",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($4);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    // qExplicitConstructorInvocation: | ExplicitConstructorInvocation ;
    BracketArgumentList:
		DELIM_lpar qArgumentList DELIM_rpar {
			node *temp_node;
			$$ = new node("BracketArgumentList");
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        ;
    // qBracketArgumentList: | BracketArgumentList ; // useless symbol

    // EnumDeclaration: sClassModifier KEYWORD_enum TypeIdentifier qClassImplements EnumBody ; // useless symbol
    // EnumBody: DELIM_lcurl qEnumConstantList qComma qEnumBodyDeclarations DELIM_rcurl ; // useless symbol

    // EnumConstantList: EnumConstant sCommaEnumConstant ; // useless symbol
    // qEnumConstantList: | EnumConstantList ; // useless symbol

    // EnumConstant: Identifier qBracketArgumentList qClassBody ; // useless symbol
    // CommaEnumConstant: DELIM_comma EnumConstant ; // useless symbol
    // sCommaEnumConstant: | sCommaEnumConstant CommaEnumConstant ; // useless symbol


    // EnumBodyDeclarations: DELIM_semicolon sClassBodyDeclaration ; // useless symbol
    // qEnumBodyDeclarations: | EnumBodyDeclarations ; // useless symbol

    //CompactConstructorDeclaration: sConstructorModifier SimpleTypeName ConstructorBody ;  @TODO

    /************** ARRAYS  ******************/
    ArrayInitializer:
		DELIM_lcurl qVariableInitializerList qComma DELIM_rcurl {
			node *temp_node;
			$$ = new node("ArrayInitializer");
			temp_node = new node("{",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			temp_node = new node("}",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        ;
    qComma:
		{
			$$ = NULL;
 }
        | DELIM_comma {
			node *temp_node;
			$$ = new node(",",true,"DELIMITER");
 }
        ;
    sCommaVariableInitializer:
		{
			$$ = NULL;
 }
        | sCommaVariableInitializer DELIM_comma VariableInitializer %prec DELIM_comma {
			node *temp_node;
			$$ = new node("sCommaVariableInitializer");
			$$->add_child($1);
			temp_node = new node(",",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        ;
    VariableInitializerList:
		VariableInitializer sCommaVariableInitializer %prec PREC_reduce_VariableInitializerList {
			node *temp_node;
			$$ = new node("VariableInitializerList");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    qVariableInitializerList:
		{
			$$ = NULL;
 }                          
        | VariableInitializerList {
			node *temp_node;
			$$ = new node("qVariableInitializerList");
			$$->add_child($1);
 }
        ;

    /************** BLOCKS ******************/
    Block:
		DELIM_lcurl qBlockStatements DELIM_rcurl {
			node *temp_node;
			$$ = new node("Block");
			temp_node = new node("{",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node("}",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        ;
    qBlockStatements:
		{
			$$ = NULL;
 }
        | BlockStatements {
			node *temp_node;
			$$ = new node("qBlockStatements");
			$$->add_child($1);
 }
        ;
    BlockStatements:
		BlockStatement {
			node *temp_node;
			$$ = new node("BlockStatements");
			$$->add_child($1);
 }
        | BlockStatement BlockStatements {
			node *temp_node;
			$$ = new node("BlockStatements");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    BlockStatement:
		LocalClassOrInterfaceDeclaration {
			node *temp_node;
			$$ = new node("BlockStatement");
			$$->add_child($1);
 }
        | LocalVariableDeclarationStatement {
			node *temp_node;
			$$ = new node("BlockStatement");
			$$->add_child($1);
 }
        | Statement {
			node *temp_node;
			$$ = new node("BlockStatement");
			$$->add_child($1);
 }
        ;
    LocalClassOrInterfaceDeclaration:
		NormalClassDeclaration {
			node *temp_node;
			$$ = new node("LocalClassOrInterfaceDeclaration");
			$$->add_child($1);
 }
        ; // NormalInterfaceDeclaration was removed
    LocalVariableDeclarationStatement:
		LocalVariableDeclaration DELIM_semicolon {
			node *temp_node;
			$$ = new node("LocalVariableDeclarationStatement");
			$$->add_child($1);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);


            count_semicolon++;  // declaration statement, hence statement count increased
        }
        ;
    LocalVariableDeclaration:
		Modifiers LocalVariableType VariableDeclaratorList {
			node *temp_node;
			$$ = new node("LocalVariableDeclaration");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
 
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

                cout << entry -> name << " " << entry -> line_no << " " << entry -> stmt_no << " " << entry -> type << " " << entry -> dimensions << '\n'; 
            }
        }
        | LocalVariableType VariableDeclaratorList {
			node *temp_node;
			$$ = new node("LocalVariableDeclaration");
			$$->add_child($1);
			$$->add_child($2);
 
            $$ -> entry_list = $2 -> entry_list;
            $2 -> entry_list . clear();
            string type = $$ -> get_name($1);
            for(auto (&entry) : $$ -> entry_list) {
                entry -> update_type(type);
                entry -> dimensions = ($1 -> sym_tab_entry ? $1 -> sym_tab_entry -> dimensions : 0);

                cout << entry -> name << " " << entry -> line_no << " " << entry -> stmt_no << " " << entry -> type << " " << entry -> dimensions << '\n'; 
            }
        }
        ;
    LocalVariableType:
		UnannType {
			node *temp_node;
			$$ = new node("LocalVariableType");
			$$->add_child($1);

            $$ -> sym_tab_entry = $1 -> sym_tab_entry;
        }
        | KEYWORD_var {
			node *temp_node;
			$$ = new node("var",true,"KEYWORD");

            
        }
        ;
    Statement:
		StatementWithoutTrailingSubstatement {
			node *temp_node;
			$$ = new node("Statement");
			$$->add_child($1);
 }
        | LabeledStatement {
			node *temp_node;
			$$ = new node("Statement");
			$$->add_child($1);
 }
        | IfThenStatement {
			node *temp_node;
			$$ = new node("Statement");
			$$->add_child($1);
 }
        | IfThenElseStatement {
			node *temp_node;
			$$ = new node("Statement");
			$$->add_child($1);
 }
        | WhileStatement {
			node *temp_node;
			$$ = new node("Statement");
			$$->add_child($1);
 }
        | ForStatement {
			node *temp_node;
			$$ = new node("Statement");
			$$->add_child($1);
 }
        ;
    StatementNoShortIf:
		StatementWithoutTrailingSubstatement {
			node *temp_node;
			$$ = new node("StatementNoShortIf");
			$$->add_child($1);
 }
        | LabeledStatementNoShortIf {
			node *temp_node;
			$$ = new node("StatementNoShortIf");
			$$->add_child($1);
 }
        | IfThenElseStatementNoShortIf {
			node *temp_node;
			$$ = new node("StatementNoShortIf");
			$$->add_child($1);
 }
        | WhileStatementNoShortIf {
			node *temp_node;
			$$ = new node("StatementNoShortIf");
			$$->add_child($1);
 }
        | ForStatementNoShortIf {
			node *temp_node;
			$$ = new node("StatementNoShortIf");
			$$->add_child($1);
 }
        ;
    StatementWithoutTrailingSubstatement:
		Block {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | EmptyStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | ExpressionStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | AssertStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | BreakStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | ContinueStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | ReturnStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | SynchronizedStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | ThrowStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | TryStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        | YieldStatement {
			node *temp_node;
			$$ = new node("StatementWithoutTrailingSubstatement");
			$$->add_child($1);
 }
        ;
    EmptyStatement:
		DELIM_semicolon {
			node *temp_node;
			$$ = new node(";",true,"DELIMITER");
 
            count_semicolon++;
        }
        ;
    LabeledStatement:
		Identifier OPERATOR_ternarycolon Statement {
			node *temp_node;
			$$ = new node("LabeledStatement");
			string s($1);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			temp_node = new node(":",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        ;
    LabeledStatementNoShortIf:
		Identifier OPERATOR_ternarycolon StatementNoShortIf {
			node *temp_node;
			$$ = new node("LabeledStatementNoShortIf");
			string s($1);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			temp_node = new node(":",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        ;
    ExpressionStatement:
		StatementExpression DELIM_semicolon {
			node *temp_node;
			$$ = new node("ExpressionStatement");
			$$->add_child($1);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    StatementExpression:
		Assignment {
			node *temp_node;
			$$ = new node("StatementExpression");
			$$->add_child($1);
 }
        | PreIncrementExpression {
			node *temp_node;
			$$ = new node("StatementExpression");
			$$->add_child($1);
 }
        | PreDecrementExpression {
			node *temp_node;
			$$ = new node("StatementExpression");
			$$->add_child($1);
 }
        | PostIncrementExpression {
			node *temp_node;
			$$ = new node("StatementExpression");
			$$->add_child($1);
 }
        | PostDecrementExpression {
			node *temp_node;
			$$ = new node("StatementExpression");
			$$->add_child($1);
 }
        | MethodInvocation {
			node *temp_node;
			$$ = new node("StatementExpression");
			$$->add_child($1);
 }
        | ClassInstanceCreationExpression {
			node *temp_node;
			$$ = new node("StatementExpression");
			$$->add_child($1);
 }
        ;
    IfThenStatement:
		KEYWORD_if DELIM_lpar Expression DELIM_rpar Statement {
			node *temp_node;
			$$ = new node("IfThenStatement");
			temp_node = new node("if",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
 }
        ;
    IfThenElseStatement:
		KEYWORD_if DELIM_lpar Expression DELIM_rpar StatementNoShortIf KEYWORD_else Statement {
			node *temp_node;
			$$ = new node("IfThenElseStatement");
			temp_node = new node("if",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
			temp_node = new node("else",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($7);
 }
        ;
    IfThenElseStatementNoShortIf:
		KEYWORD_if DELIM_lpar Expression DELIM_rpar StatementNoShortIf KEYWORD_else StatementNoShortIf {
			node *temp_node;
			$$ = new node("IfThenElseStatementNoShortIf");
			temp_node = new node("if",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
			temp_node = new node("else",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($7);
 }
        ;
    AssertStatement:
		KEYWORD_assert Expression DELIM_semicolon {
			node *temp_node;
			$$ = new node("AssertStatement");
			temp_node = new node("assert",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        | KEYWORD_assert Expression OPERATOR_ternarycolon Expression DELIM_semicolon {
			node *temp_node;
			$$ = new node("AssertStatement");
			temp_node = new node("assert",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(":",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($4);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    // CaseConstant: ConditionalExpression ; // useless symbol
    WhileStatement:
		KEYWORD_while DELIM_lpar Expression DELIM_rpar Statement {
			node *temp_node;
			$$ = new node("WhileStatement");
			temp_node = new node("while",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
 }
        ;
    WhileStatementNoShortIf:
		KEYWORD_while DELIM_lpar Expression DELIM_rpar StatementNoShortIf {
			node *temp_node;
			$$ = new node("WhileStatementNoShortIf");
			temp_node = new node("while",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
 }
        ;
    ForStatement:
		BasicForStatement {
			node *temp_node;
			$$ = new node("ForStatement");
			$$->add_child($1);
 }
        | EnhancedForStatement {
			node *temp_node;
			$$ = new node("ForStatement");
			$$->add_child($1);
 }
        ;
    ForStatementNoShortIf:
		BasicForStatementNoShortIf {
			node *temp_node;
			$$ = new node("ForStatementNoShortIf");
			$$->add_child($1);
 }
        | EnhancedForStatementNoShortIf {
			node *temp_node;
			$$ = new node("ForStatementNoShortIf");
			$$->add_child($1);
 }
        ;
    BasicForStatement:
		KEYWORD_for DELIM_lpar qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate DELIM_rpar Statement {
			node *temp_node;
			$$ = new node("BasicForStatement");
			temp_node = new node("for",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($7);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($9);
 }
        ;
    BasicForStatementNoShortIf:
		KEYWORD_for DELIM_lpar qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate DELIM_rpar StatementNoShortIf {
			node *temp_node;
			$$ = new node("BasicForStatementNoShortIf");
			temp_node = new node("for",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($7);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($9);
 }
        ;
    qForInit:
		{
			$$ = NULL;
 }
        | ForInit {
			node *temp_node;
			$$ = new node("qForInit");
			$$->add_child($1);
 }
        ;
    qForUpdate:
		{
			$$ = NULL;
 }
        | ForUpdate {
			node *temp_node;
			$$ = new node("qForUpdate");
			$$->add_child($1);
 }
        ;
    ForInit:
		StatementExpressionList {
			node *temp_node;
			$$ = new node("ForInit");
			$$->add_child($1);
 }
        | LocalVariableDeclaration {
			node *temp_node;
			$$ = new node("ForInit");
			$$->add_child($1);
 }
        ;
    ForUpdate:
		StatementExpressionList {
			node *temp_node;
			$$ = new node("ForUpdate");
			$$->add_child($1);
 }
        ;
    StatementExpressionList:
		StatementExpression sCommaStatementExpression {
			node *temp_node;
			$$ = new node("StatementExpressionList");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    sCommaStatementExpression:
		{
			$$ = NULL;
 }
        | sCommaStatementExpression DELIM_comma StatementExpression {
			node *temp_node;
			$$ = new node("sCommaStatementExpression");
			$$->add_child($1);
			temp_node = new node(",",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        ;
    EnhancedForStatement:
		KEYWORD_for DELIM_lpar LocalVariableDeclaration OPERATOR_ternarycolon Expression DELIM_rpar Statement {
			node *temp_node;
			$$ = new node("EnhancedForStatement");
			temp_node = new node("for",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(":",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($5);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($7);
 }
        ;
    EnhancedForStatementNoShortIf:
		KEYWORD_for DELIM_lpar LocalVariableDeclaration OPERATOR_ternarycolon Expression DELIM_rpar StatementNoShortIf {
			node *temp_node;
			$$ = new node("EnhancedForStatementNoShortIf");
			temp_node = new node("for",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(":",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($5);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($7);
 }
        ;
    BreakStatement:
		KEYWORD_break qIdentifier DELIM_semicolon {
			node *temp_node;
			$$ = new node("BreakStatement");
			temp_node = new node("break",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    qIdentifier:
		{
			$$ = NULL;
 }
        | Identifier {
			node *temp_node;
			string s($1);
			$$ = new node(s,true,"ID");
 }
        ;
    YieldStatement:
		KEYWORD_yield Expression DELIM_semicolon {
			node *temp_node;
			$$ = new node("YieldStatement");
			temp_node = new node("yield",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    ContinueStatement:
		KEYWORD_continue qIdentifier DELIM_semicolon {
			node *temp_node;
			$$ = new node("ContinueStatement");
			temp_node = new node("continue",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    ReturnStatement:
		KEYWORD_return qExpression DELIM_semicolon {
			node *temp_node;
			$$ = new node("ReturnStatement");
			temp_node = new node("return",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    qExpression:
		{
			$$ = NULL;
 }
        | Expression {
			node *temp_node;
			$$ = new node("qExpression");
			$$->add_child($1);
 }
        ;
    ThrowStatement:
		KEYWORD_throw Expression DELIM_semicolon {
			node *temp_node;
			$$ = new node("ThrowStatement");
			temp_node = new node("throw",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
 
            count_semicolon++;
        }
        ;
    SynchronizedStatement:
		KEYWORD_synchronized DELIM_lpar Expression DELIM_rpar Block {
			node *temp_node;
			$$ = new node("SynchronizedStatement");
			temp_node = new node("synchronized",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
 }
        ;
    TryStatement:
		KEYWORD_try Block Catches {
			node *temp_node;
			$$ = new node("TryStatement");
			temp_node = new node("try",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
 }
        | KEYWORD_try Block qCatches Finally {
			node *temp_node;
			$$ = new node("TryStatement");
			temp_node = new node("try",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			$$->add_child($4);
 }
        | TryWithResourcesStatement {
			node *temp_node;
			$$ = new node("TryStatement");
			$$->add_child($1);
 }
        ;
    qCatches:
		{
			$$ = NULL;
 }
        | Catches {
			node *temp_node;
			$$ = new node("qCatches");
			$$->add_child($1);
 }
        ;
    pCatches:
		CatchClause {
			node *temp_node;
			$$ = new node("pCatches");
			$$->add_child($1);
 }
        | pCatches CatchClause {
			node *temp_node;
			$$ = new node("pCatches");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    Catches:
		pCatches {
			node *temp_node;
			$$ = new node("Catches");
			$$->add_child($1);
 }
        ;
    CatchClause:
		KEYWORD_catch DELIM_lpar CatchFormalParameter DELIM_rpar Block {
			node *temp_node;
			$$ = new node("CatchClause");
			temp_node = new node("catch",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
 }
        ;
    CatchFormalParameter:
		Modifiers CatchType VariableDeclaratorId {
			node *temp_node;
			$$ = new node("CatchFormalParameter");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
 
            if($1 -> entry_list.size() != 1 || ($1 -> entry_list)[0] -> name != "final"){
                cout<<"ERROR in line " << yylineno << ": CatchFormalParameter Modifier list must contain only final.\n";
                exit(1);
            }
        }    
        | CatchType VariableDeclaratorId {
			node *temp_node;
			$$ = new node("CatchFormalParameter");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    CatchType:
		Name sOrName {
			node *temp_node;
			$$ = new node("CatchType");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    // sorClasstype:
    //     |   sorClasstype OPERATOR_bitwiseor Name
    //     ;
    sOrName:
		{
			$$ = NULL;
 }
        | sOrName OPERATOR_bitwiseor Name {
			node *temp_node;
			$$ = new node("sOrName");
			$$->add_child($1);
			temp_node = new node("|",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 } 
        ;
    Finally:
		KEYWORD_finally Block {
			node *temp_node;
			$$ = new node("Finally");
			temp_node = new node("finally",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
 }
        ;
    TryWithResourcesStatement:
		KEYWORD_try ResourceSpecification Block qCatches qFinally {
			node *temp_node;
			$$ = new node("TryWithResourcesStatement");
			temp_node = new node("try",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			$$->add_child($4);
			$$->add_child($5);
 }
        ;
    qFinally:
		{
			$$ = NULL;
 }
        | Finally {
			node *temp_node;
			$$ = new node("qFinally");
			$$->add_child($1);
 }
        ;
    ResourceSpecification:
		DELIM_lpar ResourceList qSemicolon DELIM_rpar {
			node *temp_node;
			$$ = new node("ResourceSpecification");
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        ;
    qSemicolon:
		{
			$$ = NULL;
 }
        | DELIM_semicolon {
			node *temp_node;
			$$ = new node(";",true,"DELIMITER");
 
            count_semicolon++;
        }
        ;
    ResourceList:
		Resource ssemicolonResource %prec PREC_reduce_ResourceList {
			node *temp_node;
			$$ = new node("ResourceList");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    ssemicolonResource:
		{
			$$ = NULL;
 }
        | ssemicolonResource DELIM_semicolon Resource %prec DELIM_semicolon {
			node *temp_node;
			$$ = new node("ssemicolonResource");
			$$->add_child($1);
			temp_node = new node(";",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            count_semicolon++;
        } // shift over reduce
        ;
    Resource:
		LocalVariableDeclaration {
			node *temp_node;
			$$ = new node("Resource");
			$$->add_child($1);
 }
        | VariableAccess {
			node *temp_node;
			$$ = new node("Resource");
			$$->add_child($1);
 }
        ;
    VariableAccess:
		Name {
			node *temp_node;
			$$ = new node("VariableAccess");
			$$->add_child($1);
 }
        | FieldAccess {
			node *temp_node;
			$$ = new node("VariableAccess");
			$$->add_child($1);
 }
        ;
    Pattern:
		TypePattern {
			node *temp_node;
			$$ = new node("Pattern");
			$$->add_child($1);
 }
        ;
    TypePattern:
		LocalVariableDeclaration {
			node *temp_node;
			$$ = new node("TypePattern");
			$$->add_child($1);
 }
        ;


    /****************** EXPRESSIONS (ASSIGNMENT) ******************/
    Expression:
		AssignmentExpression {
			node *temp_node;
			$$ = new node("Expression");
			$$->add_child($1);
 }
        ;
    AssignmentExpression:
		ConditionalExpression {
			node *temp_node;
			$$ = new node("AssignmentExpression");
			$$->add_child($1);
 }
        | Assignment {
			node *temp_node;
			$$ = new node("AssignmentExpression");
			$$->add_child($1);
 }
        ;
    ConditionalExpression:
		ConditionalOrExpression %prec PREC_cond_to_condor {
			node *temp_node;
			$$ = new node("ConditionalExpression");
			$$->add_child($1);
 }
        | ConditionalOrExpression OPERATOR_ternaryquestion Expression OPERATOR_ternarycolon ConditionalExpression {
			node *temp_node;
			$$ = new node("ConditionalExpression");
			$$->add_child($1);
			temp_node = new node("?",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node(":",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($5);
 
            $$->exp_applicable = true;
        }
        ;
    ConditionalOrExpression:
		ConditionalAndExpression %prec PREC_condor_to_condand {
			node *temp_node;
			$$ = new node("ConditionalOrExpression");
			$$->add_child($1);
 }
        | ConditionalOrExpression OPERATOR_logicalor ConditionalAndExpression {
			node *temp_node;
			$$ = new node("ConditionalOrExpression");
			$$->add_child($1);
			temp_node = new node("||",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    ConditionalAndExpression:
		InclusiveOrExpression %prec PREC_condand_to_incor {
			node *temp_node;
			$$ = new node("ConditionalAndExpression");
			$$->add_child($1);
 }
        | ConditionalAndExpression OPERATOR_logicaland InclusiveOrExpression {
			node *temp_node;
			$$ = new node("ConditionalAndExpression");
			$$->add_child($1);
			temp_node = new node("&&",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    InclusiveOrExpression:
		ExclusiveOrExpression %prec PREC_incor_to_excor {
			node *temp_node;
			$$ = new node("InclusiveOrExpression");
			$$->add_child($1);
 }
        | InclusiveOrExpression OPERATOR_bitwiseor ExclusiveOrExpression {
			node *temp_node;
			$$ = new node("InclusiveOrExpression");
			$$->add_child($1);
			temp_node = new node("|",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    ExclusiveOrExpression:
		AndExpression %prec PREC_excor_to_and {
			node *temp_node;
			$$ = new node("ExclusiveOrExpression");
			$$->add_child($1);
 }
        | ExclusiveOrExpression OPERATOR_xor AndExpression {
			node *temp_node;
			$$ = new node("ExclusiveOrExpression");
			$$->add_child($1);
			temp_node = new node("^",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    AndExpression:
		EqualityExpression %prec PREC_and_to_equality {
			node *temp_node;
			$$ = new node("AndExpression");
			$$->add_child($1);
 }
        | AndExpression OPERATOR_bitwiseand EqualityExpression {
			node *temp_node;
			$$ = new node("AndExpression");
			$$->add_child($1);
			temp_node = new node("&",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    EqualityExpression:
		RelationalExpression %prec PREC_equality_to_relational {
			node *temp_node;
			$$ = new node("EqualityExpression");
			$$->add_child($1);
 }
        | EqualityExpression OPERATOR_logicalequal RelationalExpression {
			node *temp_node;
			$$ = new node("EqualityExpression");
			$$->add_child($1);
			temp_node = new node("==",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }    
        | EqualityExpression OPERATOR_neq RelationalExpression {
			node *temp_node;
			$$ = new node("EqualityExpression");
			$$->add_child($1);
			temp_node = new node("!=",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    RelationalExpression:
		ShiftExpression {
			node *temp_node;
			$$ = new node("RelationalExpression");
			$$->add_child($1);
 }
        | RelationalExpression OPERATOR_lt ShiftExpression {
			node *temp_node;
			$$ = new node("RelationalExpression");
			$$->add_child($1);
			temp_node = new node("<",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }   
        | RelationalExpression OPERATOR_gt ShiftExpression {
			node *temp_node;
			$$ = new node("RelationalExpression");
			$$->add_child($1);
			temp_node = new node(">",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        | RelationalExpression OPERATOR_leq ShiftExpression {
			node *temp_node;
			$$ = new node("RelationalExpression");
			$$->add_child($1);
			temp_node = new node("<=",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        | RelationalExpression OPERATOR_geq ShiftExpression {
			node *temp_node;
			$$ = new node("RelationalExpression");
			$$->add_child($1);
			temp_node = new node(">=",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        | InstanceofExpression {
			node *temp_node;
			$$ = new node("RelationalExpression");
			$$->add_child($1);
 }
        ;
    ShiftExpression:
		AdditiveExpression {
			node *temp_node;
			$$ = new node("ShiftExpression");
			$$->add_child($1);
 }
        | ShiftExpression OPERATOR_leftshift AdditiveExpression {
			node *temp_node;
			$$ = new node("ShiftExpression");
			$$->add_child($1);
			temp_node = new node("<<",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        | ShiftExpression OPERATOR_rightshift AdditiveExpression {
			node *temp_node;
			$$ = new node("ShiftExpression");
			$$->add_child($1);
			temp_node = new node(">>",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        | ShiftExpression OPERATOR_unsignedrightshift AdditiveExpression {
			node *temp_node;
			$$ = new node("ShiftExpression");
			$$->add_child($1);
			temp_node = new node(">>>",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    AdditiveExpression:
		MultiplicativeExpression {
			node *temp_node;
			$$ = new node("AdditiveExpression");
			$$->add_child($1);
 }
        | AdditiveExpression OPERATOR_plus MultiplicativeExpression {
			node *temp_node;
			$$ = new node("AdditiveExpression");
			$$->add_child($1);
			temp_node = new node("+",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        | AdditiveExpression OPERATOR_minus MultiplicativeExpression {
			node *temp_node;
			$$ = new node("AdditiveExpression");
			$$->add_child($1);
			temp_node = new node("-",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    MultiplicativeExpression:
		UnaryExpression {
			node *temp_node;
			$$ = new node("MultiplicativeExpression");
			$$->add_child($1);
 }
        | MultiplicativeExpression OPERATOR_multiply UnaryExpression {
			node *temp_node;
			$$ = new node("MultiplicativeExpression");
			$$->add_child($1);
			temp_node = new node("*",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        | MultiplicativeExpression OPERATOR_divide UnaryExpression {
			node *temp_node;
			$$ = new node("MultiplicativeExpression");
			$$->add_child($1);
			temp_node = new node("/",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        | MultiplicativeExpression OPERATOR_mod UnaryExpression {
			node *temp_node;
			$$ = new node("MultiplicativeExpression");
			$$->add_child($1);
			temp_node = new node("%",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    UnaryExpression:
		PreIncrementExpression {
			node *temp_node;
			$$ = new node("UnaryExpression");
			$$->add_child($1);
 }
        | PreDecrementExpression {
			node *temp_node;
			$$ = new node("UnaryExpression");
			$$->add_child($1);
 }
        | OPERATOR_plus UnaryExpression %prec UNARY_plus {
			node *temp_node;
			$$ = new node("UnaryExpression");
			temp_node = new node("+",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($2);
 
            $$->exp_applicable = true;
        }
        | OPERATOR_minus UnaryExpression %prec UNARY_minus {
			node *temp_node;
			$$ = new node("UnaryExpression");
			temp_node = new node("-",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($2);
 
            $$->exp_applicable = true;
        }
        | UnaryExpressionNotPlusMinus {
			node *temp_node;
			$$ = new node("UnaryExpression");
			$$->add_child($1);
 }
        ;
    PreIncrementExpression:
		OPERATOR_increment UnaryExpression {
			node *temp_node;
			$$ = new node("PreIncrementExpression");
			temp_node = new node("++",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($2);
 }
        ;
    PreDecrementExpression:
		OPERATOR_decrement UnaryExpression {
			node *temp_node;
			$$ = new node("PreDecrementExpression");
			temp_node = new node("--",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($2);
 }
        ;
    UnaryExpressionNotPlusMinus:
		Name {
			node *temp_node;
			$$ = new node("UnaryExpressionNotPlusMinus");
			$$->add_child($1);
 }
        | PostfixExpression {
			node *temp_node;
			$$ = new node("UnaryExpressionNotPlusMinus");
			$$->add_child($1);
 }
        | OPERATOR_bitwisecomp UnaryExpression {
			node *temp_node;
			$$ = new node("UnaryExpressionNotPlusMinus");
			temp_node = new node("~",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($2);
 
            $$->exp_applicable = true;
        }
        | OPERATOR_not UnaryExpression {
			node *temp_node;
			$$ = new node("UnaryExpressionNotPlusMinus");
			temp_node = new node("!",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($2);
 
            $$->exp_applicable = true;
        }
        | CastExpression {
			node *temp_node;
			$$ = new node("UnaryExpressionNotPlusMinus");
			$$->add_child($1);
 }
        ;   // can also include SwitchExpression
    PostfixExpression:
		Primary {
			node *temp_node;
			$$ = new node("PostfixExpression");
			$$->add_child($1);
 }
        | PostIncrementExpression {
			node *temp_node;
			$$ = new node("PostfixExpression");
			$$->add_child($1);
 }
        | PostDecrementExpression {
			node *temp_node;
			$$ = new node("PostfixExpression");
			$$->add_child($1);
 }
        ;
    Primary:
		PrimaryNoNewArray {
			node *temp_node;
			$$ = new node("Primary");
			$$->add_child($1);
 }
        | ArrayCreationExpression {
			node *temp_node;
			$$ = new node("Primary");
			$$->add_child($1);
 }
        ;
    PrimaryNoNewArray:
		Literal {
			node *temp_node;
			$$ = new node("PrimaryNoNewArray");
			$$->add_child($1);
 }
        | ClassLiteral {
			node *temp_node;
			$$ = new node("PrimaryNoNewArray");
			$$->add_child($1);
 }
        | KEYWORD_this {
			node *temp_node;
			$$ = new node("this",true,"KEYWORD");
 }
        | Name DELIM_period KEYWORD_this {
			node *temp_node;
			$$ = new node("PrimaryNoNewArray");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("this",true,"KEYWORD");
			$$->add_child(temp_node);
 }
        | DELIM_lpar Expression DELIM_rpar {
			node *temp_node;
			$$ = new node("PrimaryNoNewArray");
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        | ClassInstanceCreationExpression {
			node *temp_node;
			$$ = new node("PrimaryNoNewArray");
			$$->add_child($1);
 }
        | FieldAccess {
			node *temp_node;
			$$ = new node("PrimaryNoNewArray");
			$$->add_child($1);
 }
        | ArrayAccess {
			node *temp_node;
			$$ = new node("PrimaryNoNewArray");
			$$->add_child($1);
 }
        | MethodInvocation {
			node *temp_node;
			$$ = new node("PrimaryNoNewArray");
			$$->add_child($1);
 }
        | MethodReference {
			node *temp_node;
			$$ = new node("PrimaryNoNewArray");
			$$->add_child($1);
 }
        ;
    Literal :
		LITERAL_integer {
			node *temp_node;
			string s($1);
			$$ = new node(s,true,"LITERAL");
 }
        | LITERAL_floatingpoint {
			node *temp_node;
			string s($1);
			$$ = new node(s,true,"LITERAL");
 }
        | LITERAL_boolean {
			node *temp_node;
			string s($1);
			$$ = new node(s,true,"LITERAL");
 }
        | LITERAL_char {
			node *temp_node;
			string s($1);
			$$ = new node(s,true,"LITERAL");
 } 
        | LITERAL_string {
			node *temp_node;
			string s($1);
			$$ = new node(s,true,"LITERAL");
 }
        | LITERAL_textblock {
			node *temp_node;
			string s($1);
			$$ = new node(s,true,"LITERAL");
 }
        | LITERAL_null {
			node *temp_node;
			$$ = new node("NULL",true,"LITERAL");
 }
        ;
    ClassLiteral:
		Name DELIM_period KEYWORD_class {
			node *temp_node;
			$$ = new node("ClassLiteral");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("class",true,"KEYWORD");
			$$->add_child(temp_node);
 }
        | Name Dims qDims DELIM_period KEYWORD_class {
			node *temp_node;
			$$ = new node("ClassLiteral");
			$$->add_child($1);
			$$->add_child($2);
			$$->add_child($3);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("class",true,"KEYWORD");
			$$->add_child(temp_node);
 }
        | NumericType qDims DELIM_period KEYWORD_class {
			node *temp_node;
			$$ = new node("ClassLiteral");
			$$->add_child($1);
			$$->add_child($2);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("class",true,"KEYWORD");
			$$->add_child(temp_node);
 }
        | KEYWORD_boolean qDims DELIM_period KEYWORD_class {
			node *temp_node;
			$$ = new node("ClassLiteral");
			temp_node = new node("boolean",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("class",true,"KEYWORD");
			$$->add_child(temp_node);
 }
        | KEYWORD_void DELIM_period KEYWORD_class {
			node *temp_node;
			$$ = new node("ClassLiteral");
			temp_node = new node("void",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("class",true,"KEYWORD");
			$$->add_child(temp_node);
 }
        ;
    ClassInstanceCreationExpression:
		UnqualifiedClassInstanceCreationExpression {
			node *temp_node;
			$$ = new node("ClassInstanceCreationExpression");
			$$->add_child($1);
 }
        | Name DELIM_period UnqualifiedClassInstanceCreationExpression {
			node *temp_node;
			$$ = new node("ClassInstanceCreationExpression");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        | Primary DELIM_period UnqualifiedClassInstanceCreationExpression {
			node *temp_node;
			$$ = new node("ClassInstanceCreationExpression");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        ;
    UnqualifiedClassInstanceCreationExpression:
		KEYWORD_new Name BracketArgumentList qClassBody {
			node *temp_node;
			$$ = new node("UnqualifiedClassInstanceCreationExpression");
			temp_node = new node("new",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			$$->add_child($4);
 }
        ;
        
    // ! sAnnotation
    // ClassOrInterfaceTypeToInstantiate: Name ;
    //     Identifier sDotIdentifier;
    // sDotIdentifier: | sDotIdentifier DELIM_period Identifier;
    qArgumentList:
		{
			$$ = NULL;
 } 
        | ArgumentList {
			node *temp_node;
			$$ = new node("qArgumentList");
			$$->add_child($1);
 }
        ;
    ArgumentList:
		Expression sCommaExpression {
			node *temp_node;
			$$ = new node("ArgumentList");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    sCommaExpression:
		{
			$$ = NULL;
 }
        | DELIM_comma Expression sCommaExpression {
			node *temp_node;
			$$ = new node("sCommaExpression");
			temp_node = new node(",",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
 } 
        ;
    FieldAccess:
		Primary DELIM_period Identifier {
			node *temp_node;
			$$ = new node("FieldAccess");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        | KEYWORD_super DELIM_period Identifier {
			node *temp_node;
			$$ = new node("FieldAccess");
			temp_node = new node("super",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        | Name DELIM_period KEYWORD_super DELIM_period Identifier {
			node *temp_node;
			$$ = new node("FieldAccess");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("super",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($5);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        ;
    ArrayAccess:
		Name DELIM_lsq Expression DELIM_rsq {
			node *temp_node;
			$$ = new node("ArrayAccess");
			$$->add_child($1);
			temp_node = new node("[",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node("]",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        | PrimaryNoNewArray DELIM_lsq Expression DELIM_rsq {
			node *temp_node;
			$$ = new node("ArrayAccess");
			$$->add_child($1);
			temp_node = new node("[",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($3);
			temp_node = new node("]",true,"DELIMITER");
			$$->add_child(temp_node);
 }
        ;
    MethodInvocation:
		Name BracketArgumentList {
			node *temp_node;
			$$ = new node("MethodInvocation");
			$$->add_child($1);
			$$->add_child($2);
 }
        | Primary DELIM_period Identifier BracketArgumentList {
			node *temp_node;
			$$ = new node("MethodInvocation");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			$$->add_child($4);
 }
        | KEYWORD_super DELIM_period Identifier BracketArgumentList {
			node *temp_node;
			$$ = new node("MethodInvocation");
			temp_node = new node("super",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			$$->add_child($4);
 }
        | Name DELIM_period KEYWORD_super DELIM_period Identifier BracketArgumentList {
			node *temp_node;
			$$ = new node("MethodInvocation");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("super",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($5);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
			$$->add_child($6);
 }
        ; 
    MethodReference:
		Name DELIM_proportion Identifier {
			node *temp_node;
			$$ = new node("MethodReference");
			$$->add_child($1);
			temp_node = new node("::",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        | Primary DELIM_proportion Identifier {
			node *temp_node;
			$$ = new node("MethodReference");
			$$->add_child($1);
			temp_node = new node("::",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        | ArrayType DELIM_proportion Identifier {
			node *temp_node;
			$$ = new node("MethodReference");
			$$->add_child($1);
			temp_node = new node("::",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        | KEYWORD_super DELIM_proportion Identifier {
			node *temp_node;
			$$ = new node("MethodReference");
			temp_node = new node("super",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("::",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($3);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        | Name DELIM_period KEYWORD_super DELIM_proportion Identifier {
			node *temp_node;
			$$ = new node("MethodReference");
			$$->add_child($1);
			temp_node = new node(".",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("super",true,"KEYWORD");
			$$->add_child(temp_node);
			temp_node = new node("::",true,"DELIMITER");
			$$->add_child(temp_node);
			string s($5);
			temp_node = new node(s,true,"ID");
			$$->add_child(temp_node);
 }
        | Name DELIM_proportion KEYWORD_new {
			node *temp_node;
			$$ = new node("MethodReference");
			$$->add_child($1);
			temp_node = new node("::",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("new",true,"KEYWORD");
			$$->add_child(temp_node);
 }
        | ArrayType DELIM_proportion KEYWORD_new {
			node *temp_node;
			$$ = new node("MethodReference");
			$$->add_child($1);
			temp_node = new node("::",true,"DELIMITER");
			$$->add_child(temp_node);
			temp_node = new node("new",true,"KEYWORD");
			$$->add_child(temp_node);
 }
        ;
    ArrayCreationExpression:
		KEYWORD_new PrimitiveType DimExprs qDims {
			node *temp_node;
			$$ = new node("ArrayCreationExpression");
			temp_node = new node("new",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			$$->add_child($4);
 }
        | KEYWORD_new Name DimExprs qDims {
			node *temp_node;
			$$ = new node("ArrayCreationExpression");
			temp_node = new node("new",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			$$->add_child($4);
 }
        | KEYWORD_new PrimitiveType Dims ArrayInitializer {
			node *temp_node;
			$$ = new node("ArrayCreationExpression");
			temp_node = new node("new",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			$$->add_child($4);
 }
        | KEYWORD_new Name Dims ArrayInitializer {
			node *temp_node;
			$$ = new node("ArrayCreationExpression");
			temp_node = new node("new",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			$$->add_child($4);
 }
        ; // ClassOrInterfaceType is same as ClassType
    DimExprs:
		DimExpr {
			node *temp_node;
			$$ = new node("DimExprs");
			$$->add_child($1);
 } // DimExprs is equivalent to pDimExpr
        | DimExprs DimExpr {
			node *temp_node;
			$$ = new node("DimExprs");
			$$->add_child($1);
			$$->add_child($2);
 }
        ;
    // ! sAnnotation
    DimExpr:
		DELIM_lsq Expression DELIM_rsq {
			node *temp_node;
			$$ = new node("DimExpr");
			temp_node = new node("[",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node("]",true,"DELIMITER");
			$$->add_child(temp_node);
 } 
        ;
    PostIncrementExpression:
		Name OPERATOR_increment {
			node *temp_node;
			$$ = new node("PostIncrementExpression");
			$$->add_child($1);
			temp_node = new node("++",true,"OPERATOR");
			$$->add_child(temp_node);
 } 
        | PostfixExpression OPERATOR_increment {
			node *temp_node;
			$$ = new node("PostIncrementExpression");
			$$->add_child($1);
			temp_node = new node("++",true,"OPERATOR");
			$$->add_child(temp_node);
 } 
            ;
    PostDecrementExpression:
		Name OPERATOR_decrement {
			node *temp_node;
			$$ = new node("PostDecrementExpression");
			$$->add_child($1);
			temp_node = new node("--",true,"OPERATOR");
			$$->add_child(temp_node);
 }                          
        | PostfixExpression OPERATOR_decrement {
			node *temp_node;
			$$ = new node("PostDecrementExpression");
			$$->add_child($1);
			temp_node = new node("--",true,"OPERATOR");
			$$->add_child(temp_node);
 } 
        ; 
    // Partial implementation of casting. Cannot cast classes
    CastExpression:
		DELIM_lpar PrimitiveType DELIM_rpar UnaryExpression {
			node *temp_node;
			$$ = new node("CastExpression");
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($4);
 }
        | DELIM_lpar ArrayType DELIM_rpar UnaryExpressionNotPlusMinus {
			node *temp_node;
			$$ = new node("CastExpression");
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($4);
 }
        | DELIM_lpar ArrayType pAdditionalBound DELIM_rpar UnaryExpressionNotPlusMinus {
			node *temp_node;
			$$ = new node("CastExpression");
			temp_node = new node("(",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($2);
			$$->add_child($3);
			temp_node = new node(")",true,"DELIMITER");
			$$->add_child(temp_node);
			$$->add_child($5);
 }
        // |   DELIM_lpar Name pAdditionalBound DELIM_rpar UnaryExpressionNotPlusMinus
        // |   DELIM_lpar Name DELIM_rpar UnaryExpressionNotPlusMinus
        ;
    // will have to define SwitchExpression: for bonus
    InstanceofExpression:
		RelationalExpression KEYWORD_instanceof ArrayType {
			node *temp_node;
			$$ = new node("InstanceofExpression");
			$$->add_child($1);
			temp_node = new node("instanceof",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        | RelationalExpression KEYWORD_instanceof Name {
			node *temp_node;
			$$ = new node("InstanceofExpression");
			$$->add_child($1);
			temp_node = new node("instanceof",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        | RelationalExpression KEYWORD_instanceof Pattern {
			node *temp_node;
			$$ = new node("InstanceofExpression");
			$$->add_child($1);
			temp_node = new node("instanceof",true,"KEYWORD");
			$$->add_child(temp_node);
			$$->add_child($3);
 }
        ;        
    Assignment:
		LeftHandSide OPERATOR_assignment Expression {
			node *temp_node;
			$$ = new node("Assignment");
			$$->add_child($1);
			string s($2);
			temp_node = new node(s,true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        | LeftHandSide OPERATOR_equal Expression {
			node *temp_node;
			$$ = new node("Assignment");
			$$->add_child($1);
			temp_node = new node("=",true,"OPERATOR");
			$$->add_child(temp_node);
			$$->add_child($3);
 
            $$->exp_applicable = true;
        }
        ;
    LeftHandSide:
		Name {
			node *temp_node;
			$$ = new node("LeftHandSide");
			$$->add_child($1);
 }
        | FieldAccess {
			node *temp_node;
			$$ = new node("LeftHandSide");
			$$->add_child($1);
 }
        | ArrayAccess {
			node *temp_node;
			$$ = new node("LeftHandSide");
			$$->add_child($1);
 }
        ;   
%%


void yyerror(const char *error)
{
    printf("Line Number:%d, Error:%s\n", yylineno, error);
    exit(0);
}
