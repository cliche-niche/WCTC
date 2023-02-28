%{
    #include <cstdio> 
    #include <cstring>
    #include <iostream>
    #include <vector>
    #include <stdio.h>
    #include "node.cpp"

    using namespace std;

    extern "C" int yylex();
    extern "C" int yylineno;
    void yyerror(const char* s);
    void add_child(node* parent, node* child);

    node* root;
%}
%define parse.error verbose

%union{
    long numval;
    long double realval;
    int boolval;
    char charval;
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
%precedence PREC_reduce_Modifiers
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

%type<treenode> IntegralType FloatingPointType PrimitiveType NumericType ArrayType Dims qDims Name Modifiers CompilationUnit OrdinaryCompilationUnit Modifier sCommaName NameList AdditionalBound pAdditionalBound ArrayInitializer qComma sCommaVariableInitializer VariableInitializerList qVariableInitializerList sImportDeclaration ImportDeclaration importName  PackageDeclaration sTopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclaration ClassExtends qClassExtends ClassImplements qClassImplements Block qBlockStatements BlockStatements BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration LocalVariableType Statement StatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement LabeledStatementNoShortIf ExpressionStatement StatementExpression IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement WhileStatement WhileStatementNoShortIf ForStatement ForStatementNoShortIf BasicForStatement BasicForStatementNoShortIf qForInit qForUpdate ForInit ForUpdate StatementExpressionList sCommaStatementExpression EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement qIdentifier YieldStatement ContinueStatement ReturnStatement qExpression ThrowStatement SynchronizedStatement TryStatement qCatches pCatches Catches CatchClause CatchFormalParameter CatchType sOrName Finally TryWithResourcesStatement qFinally ResourceSpecification qSemicolon ResourceList ssemicolonResource Resource VariableAccess Pattern TypePattern NormalClassDeclaration ClassPermits qClassPermits ClassBody qClassBody ClassBodyDeclaration sClassBodyDeclaration ClassMemberDeclaration FieldDeclaration VariableDeclaratorList sCommaVariableDeclarator VariableDeclarator VariableDeclaratorId qEqualVariableInitializer VariableInitializer UnannType MethodDeclaration MethodHeader MethodDeclarator ReceiverParameterComma ReceiverParameter IdentifierDot qIdentifierDot FormalParameterList qFormalParameterList FormalParameter sCommaFormalParameter VariableArityParameter pVariableModifier Throws qThrows MethodBody InstanceInitializer StaticInitializer ConstructorDeclaration ConstructorDeclarator ConstructorBody ExplicitConstructorInvocation BracketArgumentList UnaryExpression PreIncrementExpression UnaryExpressionNotPlusMinus PostfixExpression Primary PrimaryNoNewArray Literal ClassLiteral ClassInstanceCreationExpression UnqualifiedClassInstanceCreationExpression qArgumentList ArgumentList sCommaExpression FieldAccess ArrayAccess MethodInvocation MethodReference ArrayCreationExpression DimExprs DimExpr PostIncrementExpression PostDecrementExpression CastExpression InstanceofExpression Assignment LeftHandSide Expression AssignmentExpression ConditionalExpression ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression ShiftExpression AdditiveExpression MultiplicativeExpression PreDecrementExpression 

%start CompilationUnit

%%
    /****************** TYPES, VALUES AND VARIABLES  ******************/
    IntegralType:
        KEYWORD_byte                                                    {
                                                                            $$ = new node("byte", true, "KEYWORD");
                                                                        }
        | KEYWORD_short                                                 {
                                                                            $$ = new node("short", true, "KEYWORD");
                                                                        }
        | KEYWORD_int                                                   {
                                                                            $$ = new node("int", true, "KEYWORD");
                                                                        }
        | KEYWORD_long                                                  {
                                                                            $$ = new node("long", true, "KEYWORD");
                                                                        }
        | KEYWORD_char                                                  {
                                                                            $$ = new node("char", true, "KEYWORD");
                                                                        }
        ;
    FloatingPointType:
        KEYWORD_float                                                   {
                                                                            $$ = new node("float", true, "KEYWORD");
                                                                        }
        | KEYWORD_double                                                {
                                                                            $$ = new node("double", true, "KEYWORD");
                                                                        }
        ;
    // ! sAnnotation and Annotation removed 
    // sAnnotation: | sAnnotation Annotation ;
    // ! sAnnotation removed
    PrimitiveType:
        NumericType                                                     {
                                                                            $$ = new node("PrimitiveType", false);
                                                                            add_child($$, $1);
                                                                        }
        | KEYWORD_boolean                                               {
                                                                            $$ = new node("boolean", true, "KEYWORD");
                                                                        }
        ;
    NumericType :
        IntegralType                                                    {
                                                                            $$ = new node("NumericType", false);
                                                                            add_child($$, $1);
                                                                        }
        | FloatingPointType                                             {
                                                                            $$ = new node("NumericType", false);
                                                                            add_child($$, $1);
                                                                        }
        ;
    // ReferenceType: ArrayType ; // ClassOrInterfaceType is same as ClassType
    // ClassOrInterfaceType: ClassType | InterfaceType
    //! sAnnotation removed
    // ClassType: Identifier | Name DELIM_period Identifier | ClassType DELIM_period Identifier // We ignore TypeArguments and replace ClassType with Name everywhere
    // InterfaceType: ClassType
    // TypeIdentifier: Identifier // Replaced by Identifier
    // ! sAnnotation
    // TypeVariable: TypeIdentifier ; // TypeIdentifier is same as Identifier, therefore TypeVariable just replaced by Identifier
    ArrayType:
        Name Dims                                                       {
                                                                            $$ = new node("ArrayType", false);
                                                                            add_child($$, $1);
                                                                            add_child($$, $2);
                                                                        }
        ; // Java style array declarations ignored
    // ! sAnnotation
    Dims:
        DELIM_lsq DELIM_rsq       %prec PREC_reduce_Dims                {
                                                                            $$ = new node("Dims", false);
                                                                            node* temp_node = new node("[", true, "DELIMITER");
                                                                            add_child($$, temp_node);
                                                                            temp_node = new node("]", true, "DELIMITER");
                                                                            add_child($$, temp_node);
                                                                        }
        | DELIM_lsq DELIM_rsq Dims  %prec PREC_shift_Dims               {
                                                                            $$ = new node("Dims", false);
                                                                            node* temp_node = new node("[", true, "DELIMITER");
                                                                            add_child($$, temp_node);
                                                                            temp_node = new node("]", true, "DELIMITER");
                                                                            add_child($$, temp_node);
                                                                            add_child($$, $3);
                                                                        }
        ;
    qDims:                                                              {
                                                                            $$ = NULL;                                                                    
                                                                        }
        | Dims                                                          {
                                                                            $$ = new node("qDims", false);
                                                                            add_child($$, $1);
                                                                        }
        ;
    
    // TypeParameter: sAnnotation TypeIdentifier qTypeBound ;
    // TypeParameterModifier: Annotation //TypeParameterModifier is same as Annotation
    // TypeBound: KEYWORD_extends TypeVariable | KEYWORD_extends ClassType sAdditionalBound ; // useless symbol
    // qTypeBound: | TypeBound ; // useless symbol
    AdditionalBound:
        OPERATOR_bitwiseand Name                                        { 
                                                                            $$ = new node("AdditionalBound", false);
                                                                            node* temp_node = new node("&", true, "OPERATOR");
                                                                            add_child($$, temp_node);
                                                                            add_child($$, $2);        
                                                                        }                                      
        ;
    pAdditionalBound:
        AdditionalBound                                                  { 
                                                                            $$ = new node("AdditionalBound+", false);
                                                                            add_child($$, $1);
                                                                         }
        | pAdditionalBound AdditionalBound                               {  
                                                                            $$ = new node("AdditionalBound+", false);
                                                                            add_child($$, $1);
                                                                            add_child($$, $2);
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
        Name DELIM_period Identifier                                    {
                                                                            $$ = new node("Name", false);
                                                                            add_child($$, $1);
                                                                            node* temp_node = new node(".", true, "DELIMITER");
                                                                            add_child($$, temp_node);
                                                                            string s($3);
                                                                            temp_node = new node(s, true, "ID");
                                                                            add_child($$, temp_node);
                                                                        }
        | Identifier                                                    {
                                                                            string s($1);
                                                                            $$ = new node(s, true, "ID");                                                                    
                                                                        }
        ;
    sCommaName:                                                         {
                                                                            $$ = NULL;
                                                                        }
        | sCommaName DELIM_comma Name                                   {
                                                                            $$ = new node("CommaName*", false);
                                                                            add_child($$, $1);
                                                                            node* temp_node = new node(",", true, "DELIMITER");
                                                                            add_child($$, temp_node);
                                                                            add_child($$, $3);
                                                                        }
        ;
    NameList:
        Name sCommaName                                                 {
                                                                            $$ = new node("NameList", false);
                                                                            add_child($$, $1);
                                                                            add_child($$, $2);
                                                                        }
        ;

    /****************** PACKAGES and MODULES  ******************/
    CompilationUnit:
            OrdinaryCompilationUnit                                     { 
                                                                            $$ = new node("CompilationUnit", false);
                                                                            add_child($$, $1);

                                                                            root = $$;
                                                                        }
            ; // used to be OrdinaryCompilationUnit | ModularCompilationUnit;
    OrdinaryCompilationUnit:
        sImportDeclaration sTopLevelClassOrInterfaceDeclaration         {
                                                                            $$ = new node("OrdinaryCompilationUnit", false);
                                                                            add_child($$, $1);
                                                                            add_child($$, $2);
                                                                        }
        | PackageDeclaration sImportDeclaration sTopLevelClassOrInterfaceDeclaration    {
                                                                                            $$ = new node("OrdinaryCompilationUnit", false);
                                                                                            add_child($$, $1);
                                                                                            add_child($$, $2);
                                                                                            add_child($$, $3);
                                                                                        }
        ;
    
    sImportDeclaration:
                                                                    {
                                                                        $$ = NULL;
                                                                    }
        |  sImportDeclaration ImportDeclaration                     {
                                                                        $$ = new node("ImportDeclaration*", false);
                                                                        add_child($$, $1);
                                                                        add_child($$, $2);
                                                                    }
        ;
    ImportDeclaration:  KEYWORD_import importName DELIM_semicolon   {
                                                                        $$ = new node("ImportDeclaration", false);
                                                                        node* temp_node = new node("import", true, "KEYWORD");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);
                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                        add_child($$, temp_node);
                                                                    }
                     ;
    importName: KEYWORD_static Name                                 {
                                                                        $$ = new node("importName", false);
                                                                        node* temp_node = new node("static", true, "KEYWORD");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);
                                                                    }
              | KEYWORD_static Name DELIM_period OPERATOR_multiply  {
                                                                        $$ = new node("importName", false);
                                                                        node* temp_node = new node("static", true, "KEYWORD");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);
                                                                        temp_node = new node(".", true, "DELIMITER");
                                                                        add_child($$, temp_node);
                                                                        temp_node = new node("*", true, "REGEX");
                                                                        add_child($$, temp_node);
                                                                    }
              | Name DELIM_period OPERATOR_multiply                 {
                                                                        $$ = new node("importName", false);
                                                                        add_child($$, $1);
                                                                        node* temp_node = new node(".", true, "DELIMITER");
                                                                        add_child($$, temp_node);
                                                                        temp_node = new node("*", true, "REGEX");
                                                                        add_child($$, temp_node);
                                                                    }
              | Name                                                {
                                                                        $$ = new node("importName", false);
                                                                        add_child($$, $1);
                                                                    }
              ;                
    
    PackageDeclaration:
        KEYWORD_package Name DELIM_semicolon                        {
                                                                        $$ = new node("PackageDeclaration", false);
                                                                        node* temp_node = new node("package", true, "KEYWORD");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);
                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                        add_child($$, temp_node);
                                                                    }
        ;
    
    sTopLevelClassOrInterfaceDeclaration:                                                   {
                                                                                                $$ = NULL;
                                                                                            }
        | sTopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclaration          {
                                                                                                $$ = new node("TopLevelClassOrInterfaceDeclaration*", false);
                                                                                                add_child($$, $1);
                                                                                                add_child($$, $2);
                                                                                            }
        ;
    TopLevelClassOrInterfaceDeclaration:
        NormalClassDeclaration                                                              {
                                                                                                $$ = new node("TopLevelClassOrInterfaceDeclaration", false);
                                                                                                add_child($$, $1);
                                                                                            }
        | DELIM_semicolon                                                                   {   
                                                                                                $$ = new node(";", true, "DELIMITER");
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
    // provides TypeName with TypeName {, TypeName} ;
    // RequiresModifier:
    // (one of)
    // transitive static
    
    /****************** CLASSES  ******************/
    // ClassDeclaration: NormalClassDeclaration | EnumDeclaration | RecordDeclaration we only implement Normal Class Declaration

    Modifiers:
        Modifier                                                                                {
                                                                                                    $$ = new node("Modifiers", false);
                                                                                                    add_child($$, $1);
                                                                                                }
        | Modifiers Modifier                                                                    { 
                                                                                                    $$ = new node("Modifiers", false);
                                                                                                    add_child($$, $1);
                                                                                                    add_child($$, $2);
                                                                                                }
        | Modifiers pVariableModifier     %prec PREC_reduce_Modifiers                           {
                                                                                                    $$ = new node("Modifiers", false);
                                                                                                    add_child($$, $1);
                                                                                                    add_child($$, $2);
                                                                                                }
            
        ;
    Modifier:
        KEYWORD_public                                                                          {
                                                                                                   $$ = new node("public", true, "KEYWORD");
                                                                                                }
        | KEYWORD_private                                                                       {
                                                                                                   $$ = new node("private", true, "KEYWORD"); 
                                                                                                }
        | KEYWORD_protected                                                                     {
                                                                                                   $$ = new node("protected", true, "KEYWORD"); 
                                                                                                }
        | KEYWORD_static                                                                        {
                                                                                                   $$ = new node("static", true, "KEYWORD"); 
                                                                                                }
        | KEYWORD_abstract                                                                      {
                                                                                                   $$ = new node("abstract", true, "KEYWORD"); 
                                                                                                }
        | KEYWORD_native                                                                        {
                                                                                                   $$ = new node("native", true, "KEYWORD"); 
                                                                                                }
        | KEYWORD_synchronized                                                                  {
                                                                                                   $$ = new node("synchronized", true, "KEYWORD"); 
                                                                                                }
        | KEYWORD_transient                                                                     {
                                                                                                   $$ = new node("transient", true, "KEYWORD"); 
                                                                                                }
        | KEYWORD_volatile                                                                      {
                                                                                                   $$ = new node("volatile", true, "KEYWORD"); 
                                                                                                }
        ;

    NormalClassDeclaration:
        Modifiers KEYWORD_class Identifier qClassExtends qClassImplements qClassPermits ClassBody   {
                                                                                                        $$ = new node("NormalClassDeclaration", false);
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("class", true, "KEYWORD");
                                                                                                        add_child($$, temp_node);
                                                                                                        string s($3);
                                                                                                        temp_node = new node(s, true, "ID");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $4);
                                                                                                        add_child($$, $5);
                                                                                                        add_child($$, $6);
                                                                                                        add_child($$, $7);
                                                                                                    }
        | KEYWORD_class Identifier qClassExtends qClassImplements qClassPermits ClassBody           {
                                                                                                        $$ = new node("NormalClassDeclaration", false);
                                                                                                        node* temp_node = new node("class", true, "KEYWORD");
                                                                                                        add_child($$, temp_node);
                                                                                                        string s($2);
                                                                                                        temp_node = new node(s, true, "ID");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                        add_child($$, $4);
                                                                                                        add_child($$, $5);
                                                                                                        add_child($$, $6);
                                                                                                    }
        
        ;

    // ClassModifier: KEYWORD_public | KEYWORD_private | KEYWORD_abstract | KEYWORD_static | KEYWORD_final | KEYWORD_sealed | KEYWORD_nonsealed | KEYWORD_strictfp ;
    // sClassModifier: | sClassModifier ClassModifier ;

    ClassExtends:
        KEYWORD_extends Name                                                                        {
                                                                                                        $$ = new node("ClassExtends");
                                                                                                        node* temp_node = new node("extends", true, "KEYWORD");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);
                                                                                                    }
        ;
    qClassExtends:                                                                                  {
                                                                                                        $$ = NULL;                                                                                                         
                                                                                                    }
    | ClassExtends                                                                                  {
                                                                                                        $$ = new node("ClassExtends?");
                                                                                                        add_child($$, $1);
                                                                                                    }
    ;
    ClassImplements:
        KEYWORD_implements NameList                                                                 {
                                                                                                        $$ = new node("ClassImplements");
                                                                                                        node* temp_node = new node("implements", true, "KEYWORD");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);
                                                                                                    }
        ;
    qClassImplements:                                                                               {
                                                                                                        $$ = NULL;
                                                                                                    }
        | ClassImplements                                                                           {
                                                                                                        $$ = new node("ClassImplements?");
                                                                                                        add_child($$, $1);
                                                                                                    }
        ;
    // InterfaceTypeList: Name sCommaName ; // replaced by NameList
    ClassPermits:
        KEYWORD_permits Name sCommaName                                                             {
                                                                                                        $$ = new node("ClassPermits");
                                                                                                        node* temp_node = new node("permits", true, "KEYWORD");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    qClassPermits:                                                                                  {
                                                                                                        $$ = NULL;
                                                                                                    }
        | ClassPermits                                                                              {
                                                                                                        $$ = new node("ClassPermits?");
                                                                                                        add_child($$, $1);
                                                                                                    }
        ;
    ClassBody:
        DELIM_lcurl sClassBodyDeclaration DELIM_rcurl                                               {
                                                                                                        $$ = new node("ClassBody");
                                                                                                        node* temp_node = new node("{", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);
                                                                                                        temp_node = new node("}", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);                                                                                                        
                                                                                                    }
        ;
    qClassBody: 
                                                                                                    {
                                                                                                        $$ = NULL;
                                                                                                    }
              | ClassBody                                                                             {
                                                                                                        $$ = new node("ClassBody?");
                                                                                                        add_child($$, $1);
                                                                                                    }
              ;
    ClassBodyDeclaration: ClassMemberDeclaration                                                    {
                                                                                                        $$ = new node("ClassBodyDeclaration");
                                                                                                        add_child($$, $1);
                                                                                                    }
                         | InstanceInitializer                                                      {
                                                                                                        $$ = new node("ClassBodyDeclaration");
                                                                                                        add_child($$, $1);
                                                                                                    }
                         | StaticInitializer                                                        {
                                                                                                        $$ = new node("ClassBodyDeclaration");
                                                                                                        add_child($$, $1);
                                                                                                    }
                         | ConstructorDeclaration                                                   {
                                                                                                        $$ = new node("ClassBodyDeclaration");
                                                                                                        add_child($$, $1);
                                                                                                    }
                         ;
    sClassBodyDeclaration:                                                                          {
                                                                                                        $$ = NULL;
                                                                                                    }
                         | sClassBodyDeclaration ClassBodyDeclaration                               {
                                                                                                        $$ = new node("ClassBodyDeclaration*");
                                                                                                        add_child($$, $1);
                                                                                                        add_child($$, $2);
                                                                                                    }
                         ;
    
    ClassMemberDeclaration: FieldDeclaration                                                        {
                                                                                                        $$ = new node("ClassMemberDeclaration");
                                                                                                        add_child($$, $1);
                                                                                                    }
                          | MethodDeclaration                                                       {
                                                                                                        $$ = new node("ClassMemberDeclaration");
                                                                                                        add_child($$, $1);
                                                                                                    }
                          | NormalClassDeclaration                                                  {
                                                                                                        $$ = new node("ClassMemberDeclaration");
                                                                                                        add_child($$, $1);
                                                                                                    }
                          | DELIM_semicolon                                                         {
                                                                                                        $$ = new node("ClassMemberDeclaration");
                                                                                                        node* temp_node = new node(";", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                    }
                          ; // ClassDeclaration is the same as NormalClassDeclaration, removed InterfaceDeclaration

    FieldDeclaration: Modifiers UnannType VariableDeclaratorList DELIM_semicolon                    {
                                                                                                        $$ = new node("FieldDeclaration");
                                                                                                        add_child($$, $1);
                                                                                                        add_child($$, $2);
                                                                                                        add_child($$, $3);
                                                                                                        node* temp_node = new node(";", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                    }
                    | UnannType VariableDeclaratorList DELIM_semicolon                              {
                                                                                                        $$ = new node("FieldDeclaration");
                                                                                                        add_child($$, $1);
                                                                                                        add_child($$, $2);
                                                                                                        node* temp_node = new node(";", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                    }
    // ! Annotation removed
    // FieldModifier: KEYWORD_public | KEYWORD_private | KEYWORD_static | KEYWORD_final | KEYWORD_transient | KEYWORD_volatile ; 
    // sFieldModifier: | sFieldModifier FieldModifier ;
    
    VariableDeclaratorList: VariableDeclarator sCommaVariableDeclarator        %prec PREC_reduce_VariableDeclaratorList     {
                                                                                                                                $$ = new node("VariableDeclaratorList");
                                                                                                                                add_child($$, $1);
                                                                                                                                add_child($$, $2);
                                                                                                                            }
                          ;
    sCommaVariableDeclarator:                                                                                              {
                                                                                                                                $$ = NULL;
                                                                                                                            }
                             | sCommaVariableDeclarator DELIM_comma VariableDeclarator    %prec DELIM_comma                 {
                                                                                                                                $$ = new node("CommaVariableDeclarator*");
                                                                                                                                add_child($$, $1);
                                                                                                                                node* temp_node = new node(",", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $3);
                                                                                                                            }
                             ;
    VariableDeclarator: VariableDeclaratorId qEqualVariableInitializer                                                      {
                                                                                                                                $$ = new node("VariableDeclarator");
                                                                                                                                add_child($$, $1);
                                                                                                                                add_child($$, $2);
                                                                                                                            }
                      ;
    VariableDeclaratorId: Identifier qDims                                                                                  {
                                                                                                                                $$ = new node("VariableDeclaratorId");
                                                                                                                                string s($1);
                                                                                                                                node* temp_node = new node(s, true, "ID");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $2); 
                                                                                                                            }
                        ;
    qEqualVariableInitializer:                                                                                              {
                                                                                                                                $$ = NULL;  
                                                                                                                            }
                             | OPERATOR_equal VariableInitializer                                                           {
                                                                                                                                $$ = new node("EqualVariableInitializer?");
                                                                                                                                node* temp_node = new node("=", true, "OPERATOR");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $2);
                                                                                                                            }
                             ;
    VariableInitializer: Expression                                                                                         {
                                                                                                                                $$ = new node("VariableInitializer");
                                                                                                                                add_child($$, $1);
                                                                                                                            }
                       | ArrayInitializer                                                                                   {
                                                                                                                                $$ = new node("VariableInitializer");
                                                                                                                                add_child($$, $1);   
                                                                                                                            }
                       ;

    UnannType: PrimitiveType                                                                                                {
                                                                                                                                $$ = new node("UnannType");
                                                                                                                                add_child($$, $1);
                                                                                                                            } 
             | Name qDims                                                                                                   {
                                                                                                                                $$ = new node("UnannType");
                                                                                                                                add_child($$, $1);
                                                                                                                                add_child($$, $2);  
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

    MethodDeclaration: Modifiers MethodHeader MethodBody                        {
                                                                                    $$ = new node("MethodDeclaration");
                                                                                    add_child($$, $1);
                                                                                    add_child($$, $2);
                                                                                    add_child($$, $3);  
                                                                                }
                     | MethodHeader MethodBody                                  {
                                                                                    $$ = new node("MethodDeclaration");
                                                                                    add_child($$, $1);
                                                                                    add_child($$, $2);  
                                                                                }
                     
                     ;

    // ! Annotation removed
    // MethodModifier: KEYWORD_public | KEYWORD_private | KEYWORD_abstract | KEYWORD_static | KEYWORD_final | KEYWORD_synchronized | KEYWORD_native | KEYWORD_strictfp ;
    // sMethodModifier: | sMethodModifier MethodModifier ;

    //  ! Removing this rule: | TypeParameters sAnnotation Result MethodDeclarator qThrows
    MethodHeader: UnannType MethodDeclarator qThrows                                                                        {
                                                                                                                                $$ = new node("MethodHeader");
                                                                                                                                add_child($$, $1);
                                                                                                                                add_child($$, $2);
                                                                                                                                add_child($$, $3);
                                                                                                                            }
                | KEYWORD_void MethodDeclarator qThrows                                                                     {
                                                                                                                                $$ = new node("MethodHeader");
                                                                                                                                node* temp_node = new node("void", true, "KEYWORD");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $2);
                                                                                                                                add_child($$, $3);
                                                                                                                            }
                ;

    // Result: UnannType | KEYWORD_void;
    MethodDeclarator: Identifier DELIM_lpar qFormalParameterList DELIM_rpar qDims                                           {
                                                                                                                                $$ = new node("MethodDeclarator");
                                                                                                                                string s($1);
                                                                                                                                node* temp_node = new node(s, true, "ID");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                temp_node = new node("(", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $3);
                                                                                                                                temp_node = new node(")", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $5);
                                                                                                                            }   
                    | Identifier DELIM_lpar ReceiverParameterComma qFormalParameterList DELIM_rpar qDims                    {
                                                                                                                                $$ = new node("MethodDeclarator");
                                                                                                                                string s($1);
                                                                                                                                node* temp_node = new node(s, true, "ID");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                temp_node = new node("(", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $3);
                                                                                                                                add_child($$, $4);
                                                                                                                                temp_node = new node(")", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $6);
                                                                                                                            } 
                    ; // qreceiverparametercomma was here
    ReceiverParameterComma: ReceiverParameter DELIM_comma                                                                   {
                                                                                                                                $$ = new node("ReceiverParameterComma");
                                                                                                                                add_child($$, $1);
                                                                                                                                node* temp_node = new node(",", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                            }
                          ;
    // ! sAnnotation
    ReceiverParameter: UnannType qIdentifierDot KEYWORD_this                                                                {
                                                                                                                                $$ = new node("ReceiverParameter");
                                                                                                                                add_child($$, $1);
                                                                                                                                add_child($$, $2);
                                                                                                                                node* temp_node = new node("this", true, "KEYWORD");
                                                                                                                                add_child($$, temp_node);
                                                                                                                            }
                     ;
    // qReceiverParameterComma: | ReceiverParameterComma ;
    IdentifierDot: Identifier DELIM_period                                                                                  {
                                                                                                                                $$ = new node("IdentifierDot");
                                                                                                                                string s($1);
                                                                                                                                node* temp_node = new node(s, true, "ID");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                temp_node = new node(".", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                            }
                 ;
    qIdentifierDot:                                                                                                         {
                                                                                                                                $$ = NULL; 
                                                                                                                            }
                  | IdentifierDot                                                                                           {
                                                                                                                                $$ = new node("IdentifierDot?");
                                                                                                                                add_child($$, $1); 
                                                                                                                            }
                  ;

    FormalParameterList: FormalParameter sCommaFormalParameter                                                              {
                                                                                                                                $$ = new node("FormalParameterList");
                                                                                                                                add_child($$, $1);
                                                                                                                                add_child($$, $2);
                                                                                                                            }
                    ;
    qFormalParameterList:                                                                                                   {
                                                                                                                                $$ = NULL;
                                                                                                                            }
                    | FormalParameterList                                                                                   {
                                                                                                                                $$ = new node("FormalParameterList?");
                                                                                                                                add_child($$, $1);
                                                                                                                            }
                    ;
    FormalParameter: pVariableModifier UnannType VariableDeclaratorId                                                       {
                                                                                                                                $$ = new node("FormalParameter");
                                                                                                                                add_child($$, $1);
                                                                                                                                add_child($$, $2);
                                                                                                                                add_child($$, $3);
                                                                                                                            }
                   | VariableArityParameter                                                                                 {
                                                                                                                                $$ = new node("FormalParameter");
                                                                                                                                add_child($$, $1);    
                                                                                                                            } 
                   | UnannType VariableDeclaratorId                                                                         {
                                                                                                                                $$ = new node("FormalParameter");
                                                                                                                                add_child($$, $1);
                                                                                                                                add_child($$, $2);    
                                                                                                                            }         
                   ;
    sCommaFormalParameter:                                                                                                  {
                                                                                                                                $$ = NULL;
                                                                                                                            }
                        | sCommaFormalParameter DELIM_comma FormalParameter                                                 {
                                                                                                                                $$ = new node("CommaFormalParameter*");
                                                                                                                                add_child($$, $1);
                                                                                                                                node* temp_node = new node(",", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $3);   
                                                                                                                            }
                        ;
    // ! sAnnotation and Annotation removed
    VariableArityParameter: pVariableModifier UnannType DELIM_ellipsis Identifier                                           {
                                                                                                                                $$ = new node("VariableArityParameter");
                                                                                                                                add_child($$, $1);
                                                                                                                                add_child($$, $2);
                                                                                                                                node* temp_node = new node("...", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                string s($4);
                                                                                                                                temp_node = new node(s, true, "ID");
                                                                                                                                add_child($$, temp_node);
                                                                                                                            }
                          | UnannType DELIM_ellipsis Identifier                                                             {
                                                                                                                                $$ = new node("VariableArityParameter");
                                                                                                                                add_child($$, $1);
                                                                                                                                node* temp_node = new node("...", true, "DELIMITER");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                string s($3);
                                                                                                                                temp_node = new node(s, true, "ID");
                                                                                                                                add_child($$, temp_node);
                                                                                                                            }
                          ;
    // VariableModifier: KEYWORD_final ;
    // sVariableModifier: | sVariableModifier KEYWORD_final ;
    pVariableModifier: KEYWORD_final                                                                                       {
                                                                                                                                $$ = new node("final", true, "ID"); 
                                                                                                                           }
                     | pVariableModifier KEYWORD_final      %prec KEYWORD_final                                            {
                                                                                                                                $$ = new node("VariableModifier+");
                                                                                                                                add_child($$, $1);
                                                                                                                                node* temp_node = new node("final", true, "KEYWORD");
                                                                                                                                add_child($$, temp_node);
                                                                                                                           }
                     ;
 
    Throws: KEYWORD_throws NameList                                                         {
                                                                                                $$ = new node("Throws");
                                                                                                node* temp_node = new node("throws", true, "KEYWORD");
                                                                                                add_child($$, temp_node);
                                                                                                add_child($$, $2);  
                                                                                            }
          ;
    qThrows:                                                                                {
                                                                                                $$ = NULL;   
                                                                                            }
           |  Throws                                                                        {
                                                                                                $$ = new node("Throws?");
                                                                                                add_child($$, $1);     
                                                                                            }
           ;
    // ExceptionTypeList: Name sCommaName ; // Replaced by NameList
    
    MethodBody: Block                                                                       {
                                                                                                $$ = new node("MethodBody");
                                                                                                add_child($$, $1);
                                                                                            }
              | DELIM_semicolon                                                             {
                                                                                                $$ = new node(";", true, "DELIMITER");
                                                                                            }
              ;

    InstanceInitializer: Block                                                              {
                                                                                                $$ = new node("InstanceInitializer");
                                                                                                add_child($$, $1);
                                                                                            }
                       ;
    StaticInitializer: KEYWORD_static Block                                                 {
                                                                                                $$ = new node("StaticInitializer");
                                                                                                node* temp_node = new node("static", true, "KEYWORD");
                                                                                                add_child($$, temp_node);
                                                                                                add_child($$, $2);
                                                                                            }
                     ;

    ConstructorDeclaration: Modifiers ConstructorDeclarator qThrows ConstructorBody        {
                                                                                                $$ = new node("ConstructorDeclaration");
                                                                                                add_child($$, $1);
                                                                                                add_child($$, $2);
                                                                                                add_child($$, $3);
                                                                                                add_child($$, $4);
                                                                                           }
                            | ConstructorDeclarator qThrows ConstructorBody                 {
                                                                                                $$ = new node("ConstructorDeclaration");
                                                                                                add_child($$, $1);
                                                                                                add_child($$, $2);
                                                                                                add_child($$, $3);
                                                                                           }
                          ;
    // ! Annotation removed
    // ConstructorModifier: KEYWORD_public | KEYWORD_private ;
    // sConstructorModifier: | sConstructorModifier ConstructorModifier ;

    ConstructorDeclarator: Name DELIM_lpar qFormalParameterList DELIM_rpar                          {
                                                                                                        $$ = new node("ConstructorDeclarator");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("(", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                        temp_node = new node(")", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                   }
                        |   Name DELIM_lpar ReceiverParameterComma qFormalParameterList DELIM_rpar {
                                                                                                        $$ = new node("ConstructorDeclarator");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("(", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                        add_child($$, $4);
                                                                                                        temp_node = new node(")", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                   }
                        ;

    ConstructorBody: DELIM_lcurl qBlockStatements DELIM_rcurl                                       {
                                                                                                        $$ = new node("ConstructorBody");
                                                                                                        node* temp_node = new node("{", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);
                                                                                                        temp_node = new node("}", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                    }                                                                                                    
                    | DELIM_lcurl ExplicitConstructorInvocation qBlockStatements DELIM_rcurl        {
                                                                                                        $$ = new node("ConstructorBody");
                                                                                                        node* temp_node = new node("{", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);
                                                                                                        add_child($$, $3);
                                                                                                        temp_node = new node("}", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                    }
                    ;
                    
    ExplicitConstructorInvocation: KEYWORD_this BracketArgumentList DELIM_semicolon                 {
                                                                                                        $$ = new node("ExplicitConstructorInvocation");
                                                                                                        node* temp_node = new node("this", true, "KEYWORD");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);
                                                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                    }
                                 | KEYWORD_super BracketArgumentList DELIM_semicolon                {
                                                                                                        $$ = new node("ExplicitConstructorInvocation");
                                                                                                        node* temp_node = new node("super", true, "KEYWORD");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);
                                                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                    }
                                 | Name DELIM_period KEYWORD_super BracketArgumentList DELIM_semicolon      {
                                                                                                                $$ = new node("ExplicitConstructorInvocation");
                                                                                                                add_child($$, $1);
                                                                                                                node* temp_node = new node(".", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                                temp_node = new node("super", true, "KEYWORD");
                                                                                                                add_child($$, temp_node);
                                                                                                                add_child($$, $4);
                                                                                                                temp_node = new node(";", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                            }
                                 | Primary DELIM_period KEYWORD_super BracketArgumentList DELIM_semicolon   {
                                                                                                                $$ = new node("ExplicitConstructorInvocation");
                                                                                                                add_child($$, $1);
                                                                                                                node* temp_node = new node(".", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                                temp_node = new node("super", true, "KEYWORD");
                                                                                                                add_child($$, temp_node);
                                                                                                                add_child($$, $4);
                                                                                                                temp_node = new node(";", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                            }
                                 ;
    // qExplicitConstructorInvocation: | ExplicitConstructorInvocation ;
    BracketArgumentList: DELIM_lpar qArgumentList DELIM_rpar                                        {
                                                                                                        $$ = new node("BracketArgumentList");
                                                                                                        node* temp_node = new node("(", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);
                                                                                                        temp_node = new node(")", true, "DELIMITER");
                                                                                                        add_child($$, temp_node);
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
    ArrayInitializer: DELIM_lcurl qVariableInitializerList qComma DELIM_rcurl               {
                                                                                                $$ = new node("ArrayInitializer");
                                                                                                node *temp_node = new node("{", true, "DELIMITER");
                                                                                                add_child($$, temp_node);
                                                                                                add_child($$, $2);
                                                                                                add_child($$, $3);
                                                                                                temp_node = new node("}", true, "DELIMITER");
                                                                                                add_child($$, temp_node);
                                                                                            }
                    ;
    qComma:                                                                                 { $$ = NULL; }
            | DELIM_comma                                                                   {
                                                                                                $$ = new node("Comma?");
                                                                                                node *temp_node = new node(",", true, "DELIMITER");
                                                                                                add_child($$, temp_node);
                                                                                            }
            ;
    sCommaVariableInitializer:                                                                                  { $$ = NULL; }
                            | sCommaVariableInitializer DELIM_comma VariableInitializer %prec DELIM_comma       {
                                                                                                                    $$ = new node("CommaVariableInitializer*");
                                                                                                                    add_child($$, $1);
                                                                                                                    node *temp_node = new node(",", true, "DELIMITER");
                                                                                                                    add_child($$, temp_node);
                                                                                                                    add_child($$, $3);
                                                                                                                }
                            ;
    VariableInitializerList: VariableInitializer sCommaVariableInitializer %prec PREC_reduce_VariableInitializerList    {
                                                                                                                            $$ = new node("VariableInitializerList");
                                                                                                                            add_child($$, $1);
                                                                                                                            add_child($$, $2);
                                                                                                                        }
                            ;
    qVariableInitializerList:                                                                                   { $$ = NULL; }                          
                            | VariableInitializerList                                                           {
                                                                                                                    $$ = new node("VariableInitializerList?");
                                                                                                                    add_child($$, $1);
                                                                                                                }
                            ;

    /************** BLOCKS ******************/
    Block:
        DELIM_lcurl qBlockStatements DELIM_rcurl                                                { 
                                                                                                    $$ = new node("Block", false);
                                                                                                    node* temp_node = new node("{", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $2);
                                                                                                    temp_node = new node("}", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                }
        ;
    qBlockStatements:                                                                           { $$ = NULL; }
        |   BlockStatements                                                                     { 
                                                                                                    $$ = new node("BlockStatements?", false);
                                                                                                    add_child($$, $1); 
                                                                                                }
        ;
    BlockStatements:
        BlockStatement                                                                          { 
                                                                                                    $$ = new node("BlockStatements", false);
                                                                                                    add_child($$, $1); 
                                                                                                }
        |   BlockStatement BlockStatements                                                      { 
                                                                                                    $$ = new node("BlockStatements", false);
                                                                                                    add_child($$, $1);  
                                                                                                    add_child($$, $2);
                                                                                                }
        ;
    BlockStatement:
            LocalClassOrInterfaceDeclaration                                                    { 
                                                                                                    $$ = new node("BlockStatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   LocalVariableDeclarationStatement                                                   { 
                                                                                                    $$ = new node("BlockStatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   Statement                                                                           {  
                                                                                                    $$ = new node("BlockStatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        ;
    LocalClassOrInterfaceDeclaration:
            NormalClassDeclaration                                                              {  
                                                                                                    $$ = new node("LocalClassOrInterfaceDeclaration");
                                                                                                    add_child($$, $1);
                                                                                                }
        ; // NormalInterfaceDeclaration was removed
    LocalVariableDeclarationStatement:
        LocalVariableDeclaration DELIM_semicolon                                                { 
                                                                                                    $$ = new node("LocalVariableDeclarationStatement");
                                                                                                    add_child($$, $1);
                                                                                                    node* temp_node = new node(";", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                }
        ;
    LocalVariableDeclaration:
        pVariableModifier LocalVariableType VariableDeclaratorList                              { 
                                                                                                    $$ = new node("LocalVariableDeclaration");
                                                                                                    add_child($$, $1);
                                                                                                    add_child($$, $2);
                                                                                                    add_child($$, $3);    
                                                                                                }
        | LocalVariableType VariableDeclaratorList                                              { 
                                                                                                    $$ = new node("LocalVariableDeclaration");
                                                                                                    add_child($$, $1);
                                                                                                    add_child($$, $2);
                                                                                                }
        ;
    LocalVariableType:
            UnannType                                                                           { 
                                                                                                    $$ = new node("LocalVariableType");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   KEYWORD_var                                                                         { 
                                                                                                    $$ = new node("LocalVariableType");
                                                                                                    node *temp_node = new node("var", true, "KEYWORD");
                                                                                                    add_child($$, temp_node);
                                                                                                }
        ;
    Statement:
            StatementWithoutTrailingSubstatement                                                { 
                                                                                                    $$ = new node("Statement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   LabeledStatement                                                                    { 
                                                                                                    $$ = new node("Statement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   IfThenStatement                                                                     { 
                                                                                                    $$ = new node("Statement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   IfThenElseStatement                                                                 { 
                                                                                                    $$ = new node("Statement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   WhileStatement                                                                      { 
                                                                                                    $$ = new node("Statement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   ForStatement                                                                        {   $$ = new node("Statement");
                                                                                                    add_child($$, $1);
                                                                                                }
        ;
    StatementNoShortIf:
            StatementWithoutTrailingSubstatement                                                { 
                                                                                                    $$ = new node("StatementNoShortIf");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   LabeledStatementNoShortIf                                                           {
                                                                                                    $$ = new node("StatementNoShortIf");
                                                                                                    add_child($$, $1);  
                                                                                                }
        |   IfThenElseStatementNoShortIf                                                        { 
                                                                                                    $$ = new node("StatementNoShortIf");
                                                                                                    add_child($$, $1); 
                                                                                                }
        |   WhileStatementNoShortIf                                                             { 
                                                                                                    $$ = new node("StatementNoShortIf");
                                                                                                    add_child($$, $1); 
                                                                                                }
        |   ForStatementNoShortIf                                                               { 
                                                                                                    $$ = new node("StatementNoShortIf");
                                                                                                    add_child($$, $1);
                                                                                                }
        ;
    StatementWithoutTrailingSubstatement:
            Block                                                                               { 
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   EmptyStatement                                                                      { 
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   ExpressionStatement                                                                 { 
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   AssertStatement                                                                     { 
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   BreakStatement                                                                      { 
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   ContinueStatement                                                                   {  
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   ReturnStatement                                                                     {  
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   SynchronizedStatement                                                               {  
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   ThrowStatement                                                                      {  
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   TryStatement                                                                        {   
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1);  
                                                                                                }
        |   YieldStatement                                                                      {   
                                                                                                    $$ = new node("StatementWithoutTrailingSubstatement");
                                                                                                    add_child($$, $1); 
                                                                                                }
        ;
    EmptyStatement:
        DELIM_semicolon                                                                         {  
                                                                                                    $$ = new node(";", true, "DELIMITER");
                                                                                                }
        ;
    LabeledStatement:
        Identifier OPERATOR_ternarycolon Statement                                              {  
                                                                                                    $$ = new node("LabeledStatement");
                                                                                                    string s($1);
                                                                                                    node *temp_node = new node(s, true, "ID");
                                                                                                    add_child($$, temp_node);
                                                                                                    temp_node = new node(":", true, "OPERATOR");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $3);
                                                                                                }
        ;
    LabeledStatementNoShortIf:
        Identifier OPERATOR_ternarycolon StatementNoShortIf                                     { 
                                                                                                    $$ = new node("LabeledStatementNoShortIf");
                                                                                                    string s($1);
                                                                                                    node *temp_node = new node(s, true, "ID");
                                                                                                    add_child($$, temp_node);
                                                                                                    temp_node = new node(":", true, "OPERATOR");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $3);
                                                                                                }
        ;
    ExpressionStatement:
        StatementExpression DELIM_semicolon                                                     {  
                                                                                                    $$ = new node("ExpressionStatement");
                                                                                                    add_child($$, $1);
                                                                                                    node *temp_node = new node(";", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                }
        ;
    StatementExpression:
            Assignment                                                                          { 
                                                                                                    $$ = new node("StatementExpression");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   PreIncrementExpression                                                              { 
                                                                                                    $$ = new node("StatementExpression");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   PreDecrementExpression                                                              {  
                                                                                                    $$ = new node("StatementExpression");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   PostIncrementExpression                                                             { 
                                                                                                    $$ = new node("StatementExpression");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   PostDecrementExpression                                                             { 
                                                                                                    $$ = new node("StatementExpression");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   MethodInvocation                                                                    { 
                                                                                                    $$ = new node("StatementExpression");
                                                                                                    add_child($$, $1);
                                                                                                }
        |   ClassInstanceCreationExpression                                                     { 
                                                                                                    $$ = new node("StatementExpression");
                                                                                                    add_child($$, $1);
                                                                                                }
        ;
    IfThenStatement:
        KEYWORD_if DELIM_lpar Expression DELIM_rpar Statement                                   { 
                                                                                                    $$ = new node("IfThenStatement");
                                                                                                    node *temp_node = new node("if", true, "KEYWORD");
                                                                                                    add_child($$, temp_node);
                                                                                                    temp_node = new node("(", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $3);
                                                                                                    temp_node = new node(")", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $5);
                                                                                                }
        ;
    IfThenElseStatement:
        KEYWORD_if DELIM_lpar Expression DELIM_rpar StatementNoShortIf KEYWORD_else Statement   { 
                                                                                                    $$ = new node("IfThenElseStatement");
                                                                                                    node *temp_node = new node("if", true, "KEYWORD");
                                                                                                    add_child($$, temp_node);
                                                                                                    temp_node = new node("(", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $3);
                                                                                                    temp_node = new node(")", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $5);
                                                                                                    temp_node = new node("else", true, "KEYWORD");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $7);
                                                                                                }
        ;
    IfThenElseStatementNoShortIf:
        KEYWORD_if DELIM_lpar Expression DELIM_rpar StatementNoShortIf KEYWORD_else StatementNoShortIf  { 
                                                                                                            $$ = new node("IfThenElseStatementNoShortIf");
                                                                                                            node *temp_node = new node("if", true, "KEYWORD");
                                                                                                            add_child($$, temp_node);
                                                                                                            temp_node = new node("(", true, "DELIMITER");
                                                                                                            add_child($$, temp_node);
                                                                                                            add_child($$, $3);
                                                                                                            temp_node = new node(")", true, "DELIMITER");
                                                                                                            add_child($$, temp_node);
                                                                                                            add_child($$, $5);
                                                                                                            temp_node = new node("else", true, "KEYWORD");
                                                                                                            add_child($$, temp_node);
                                                                                                            add_child($$, $7);
                                                                                                        }
        ;
    AssertStatement:
            KEYWORD_assert Expression DELIM_semicolon                                                       { 
                                                                                                                $$ = new node("AssertStatement");
                                                                                                                node *temp_node = new node("assert", true, "KEYWORD");
                                                                                                                add_child($$, temp_node);
                                                                                                                add_child($$, $2);
                                                                                                                temp_node = new node(";", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                            }
        |   KEYWORD_assert Expression OPERATOR_ternarycolon Expression DELIM_semicolon                      { 
                                                                                                                $$ = new node("AssertStatement");
                                                                                                                node *temp_node = new node("assert", true, "KEYWORD");
                                                                                                                add_child($$, temp_node);
                                                                                                                add_child($$, $2);
                                                                                                                temp_node = new node(":", true, "OPERATOR");
                                                                                                                add_child($$, temp_node);
                                                                                                                add_child($$, $4);
                                                                                                                temp_node = new node(";", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                            }
        ;
    // CaseConstant: ConditionalExpression ; // useless symbol
    WhileStatement:
        KEYWORD_while DELIM_lpar Expression DELIM_rpar Statement                                            { 
                                                                                                                $$ = new node("WhileStatement");
                                                                                                                node *temp_node = new node("while", true, "KEYWORD");
                                                                                                                add_child($$, temp_node);
                                                                                                                temp_node = new node("(", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                                add_child($$, $3);
                                                                                                                temp_node = new node(")", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                                add_child($$, $5);
                                                                                                            }
        ;
    WhileStatementNoShortIf:
        KEYWORD_while DELIM_lpar Expression DELIM_rpar StatementNoShortIf                                   { 
                                                                                                                $$ = new node("WhileStatementNoShortIf");
                                                                                                                node *temp_node = new node("while", true, "KEYWORD");
                                                                                                                add_child($$, temp_node);
                                                                                                                temp_node = new node("(", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                                add_child($$, $3);
                                                                                                                temp_node = new node(")", true, "DELIMITER");
                                                                                                                add_child($$, temp_node);
                                                                                                                add_child($$, $5);
                                                                                                            }
        ;
    ForStatement:
            BasicForStatement                                                                               {
                                                                                                                $$ = new node("ForStatement");
                                                                                                                add_child($$, $1);
                                                                                                            }
        |   EnhancedForStatement                                                                            { 
                                                                                                                $$ = new node("ForStatement");
                                                                                                                add_child($$, $1);
                                                                                                            }
        ;
    ForStatementNoShortIf:
            BasicForStatementNoShortIf                                                                      { 
                                                                                                                $$ = new node("ForStatementNoShortIf");
                                                                                                                add_child($$, $1);
                                                                                                            }
        |   EnhancedForStatementNoShortIf                                                                   { 
                                                                                                                $$ = new node("ForStatementNoShortIf");
                                                                                                                add_child($$, $1);
                                                                                                            }
        ;
    BasicForStatement:
        KEYWORD_for DELIM_lpar qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate DELIM_rpar Statement { 
                                                                                                                        $$ = new node("BasicForStatement");
                                                                                                                        node *temp_node = new node("for", true, "KEYWORD");
                                                                                                                        add_child($$, temp_node);
                                                                                                                        temp_node = new node("(", true, "DELIMITER");
                                                                                                                        add_child($$, temp_node);
                                                                                                                        add_child($$, $3);
                                                                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                                                                        add_child($$, temp_node);
                                                                                                                        add_child($$, $5);
                                                                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                                                                        add_child($$, temp_node);
                                                                                                                        add_child($$, $7);
                                                                                                                        temp_node = new node(")", true, "DELIMITER");
                                                                                                                        add_child($$, temp_node);
                                                                                                                        add_child($$, $9);
                                                                                                                    }
        ;
    BasicForStatementNoShortIf:
        KEYWORD_for DELIM_lpar qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate DELIM_rpar StatementNoShortIf    { 
                                                                                                                                    $$ = new node("BasicForStatementNoShortIf");
                                                                                                                                    node *temp_node = new node("for", true, "KEYWORD");
                                                                                                                                    add_child($$, temp_node);
                                                                                                                                    temp_node = new node("(", true, "DELIMITER");
                                                                                                                                    add_child($$, temp_node);
                                                                                                                                    add_child($$, $3);
                                                                                                                                    temp_node = new node(";", true, "DELIMITER");
                                                                                                                                    add_child($$, temp_node);
                                                                                                                                    add_child($$, $5);
                                                                                                                                    temp_node = new node(";", true, "DELIMITER");
                                                                                                                                    add_child($$, temp_node);
                                                                                                                                    add_child($$, $7);
                                                                                                                                    temp_node = new node(")", true, "DELIMITER");
                                                                                                                                    add_child($$, temp_node);
                                                                                                                                    add_child($$, $9);
                                                                                                                                }
        ;
    qForInit:                                                                           { 
                                                                                            $$ = NULL;
                                                                                        }
        |   ForInit                                                                     { 
                                                                                            $$ = new node("ForInit?");
                                                                                            add_child($$, $1);
                                                                                        }
        ;
    qForUpdate:                                                                         { $$ = NULL; }
        |   ForUpdate                                                                   { 
                                                                                            $$ = new node("ForUpdate?");
                                                                                            add_child($$, $1);
                                                                                        }
        ;
    ForInit:
            StatementExpressionList                                                     { 
                                                                                            $$ = new node("ForInit");
                                                                                            add_child($$, $1);
                                                                                        }
        |   LocalVariableDeclaration                                                    { 
                                                                                            $$ = new node("ForInit");
                                                                                            add_child($$, $1);
                                                                                        }
        ;
    ForUpdate:
        StatementExpressionList                                                         { 
                                                                                            $$ = new node("ForUpdate");
                                                                                            add_child($$, $1);
                                                                                        }
        ;
    StatementExpressionList:
        StatementExpression sCommaStatementExpression                                   { 
                                                                                            $$ = new node("StatementExpressionList");
                                                                                            add_child($$, $1);
                                                                                            add_child($$, $2);
                                                                                        }
        ;
    sCommaStatementExpression:                                                          { $$ = NULL; }
        |   sCommaStatementExpression DELIM_comma StatementExpression                   { 
                                                                                            $$ = new node("sCommaStatementExpression");
                                                                                            add_child($$, $1);
                                                                                            node *temp_node = new node(",", true, "DELIMITER");
                                                                                            add_child($$, temp_node);
                                                                                            add_child($$, $3);
                                                                                        }
        ;
    EnhancedForStatement:
        KEYWORD_for DELIM_lpar LocalVariableDeclaration OPERATOR_ternarycolon Expression DELIM_rpar Statement   { 
                                                                                                                    $$ = new node("EnhancedForStatement");
                                                                                                                    node *temp_node = new node("for", true, "KEYWORD");
                                                                                                                    add_child($$, temp_node);
                                                                                                                    temp_node = new node("(", true, "DELIMITER");
                                                                                                                    add_child($$, temp_node);
                                                                                                                    add_child($$, $3);
                                                                                                                    temp_node = new node(":", true, "OPERATOR");
                                                                                                                    add_child($$, temp_node);
                                                                                                                    add_child($$, $5);
                                                                                                                    temp_node = new node(")", true, "DELIMITER");
                                                                                                                    add_child($$, temp_node);
                                                                                                                    add_child($$, $7);
                                                                                                                }
        ;
    EnhancedForStatementNoShortIf:
        KEYWORD_for DELIM_lpar LocalVariableDeclaration OPERATOR_ternarycolon Expression DELIM_rpar StatementNoShortIf  { 
                                                                                                                            $$ = new node("EnhancedForStatementNoShortIf");
                                                                                                                            node *temp_node = new node("for", true, "KEYWORD");
                                                                                                                            add_child($$, temp_node);
                                                                                                                            temp_node = new node("(", true, "DELIMITER");
                                                                                                                            add_child($$, temp_node);
                                                                                                                            add_child($$, $3);
                                                                                                                            temp_node = new node(":", true, "OPERATOR");
                                                                                                                            add_child($$, temp_node);
                                                                                                                            add_child($$, $5);
                                                                                                                            temp_node = new node(")", true, "DELIMITER");
                                                                                                                            add_child($$, temp_node);
                                                                                                                            add_child($$, $7);
                                                                                                                        }
        ;
    BreakStatement:
        KEYWORD_break qIdentifier DELIM_semicolon                                   {
                                                                                        $$ = new node("BreakStatement");
                                                                                        node *temp_node = new node("break", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                    }
        ;
    qIdentifier:                                                                    { $$ = NULL; }
        |   Identifier                                                              { 
                                                                                        $$ = new node("Identifier?");
                                                                                        string s($1);
                                                                                        node* temp_node = new node(s, true, "ID");
                                                                                        add_child($$, temp_node);
                                                                                    }
        ;
    YieldStatement:
        KEYWORD_yield Expression DELIM_semicolon                                    { 
                                                                                        $$ = new node("YieldStatement");
                                                                                        node *temp_node = new node("yield", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                    }
        ;
    ContinueStatement:
        KEYWORD_continue qIdentifier DELIM_semicolon                                { 
                                                                                        $$ = new node("ContinueStatement");
                                                                                        node *temp_node = new node("continue", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                    }
        ;
    ReturnStatement:
        KEYWORD_return qExpression DELIM_semicolon                                  {
                                                                                        $$ = new node("ReturnStatement");
                                                                                        node *temp_node = new node("return", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                    }
        ;
    qExpression:                                                                    { $$ = NULL; }
        |   Expression                                                              { 
                                                                                        $$ = new node("Expression?");
                                                                                        add_child($$, $1);
                                                                                    }
        ;
    ThrowStatement:
        KEYWORD_throw Expression DELIM_semicolon                                    { 
                                                                                        $$ = new node("ThrowStatement");
                                                                                        node *temp_node = new node("throw", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                        temp_node = new node(";", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                    }
        ;
    SynchronizedStatement:
        KEYWORD_synchronized DELIM_lpar Expression DELIM_rpar Block                 { 
                                                                                        $$ = new node("SynchronizedStatement");
                                                                                        node *temp_node = new node("synchronized", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        temp_node = new node("(", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $3);
                                                                                        temp_node = new node(")", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $5);
                                                                                    }
        ;
    TryStatement:
            KEYWORD_try Block Catches                                               { 
                                                                                        $$ = new node("TryStatement");
                                                                                        node *temp_node = new node("try", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                        add_child($$, $3);
                                                                                    }
        |   KEYWORD_try Block qCatches Finally                                      { 
                                                                                        $$ = new node("TryStatement");
                                                                                        node *temp_node = new node("try", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                        add_child($$, $3);
                                                                                        add_child($$, $4);
                                                                                    }
        |   TryWithResourcesStatement                                               {
                                                                                        $$ = new node("TryStatement");
                                                                                        add_child($$, $1);
                                                                                    }
        ;
    qCatches:                                                                       { 
                                                                                        $$ = NULL;
                                                                                    }
        |   Catches                                                                 { 
                                                                                        $$ = new node("Catches?");
                                                                                        add_child($$, $1);
                                                                                    }
        ;
    pCatches:
            CatchClause                                                             { 
                                                                                        $$ = new node("Catches+");
                                                                                        add_child($$, $1);
                                                                                    }
        |   pCatches CatchClause                                                    { 
                                                                                        $$ = new node("Catches+");
                                                                                        add_child($$, $1);
                                                                                        add_child($$, $2);
                                                                                    }
        ;
    Catches:
        pCatches                                                                    { 
                                                                                        $$ = new node("Catches");
                                                                                        add_child($$, $1);
                                                                                    }
        ;
    CatchClause:
        KEYWORD_catch DELIM_lpar CatchFormalParameter DELIM_rpar Block              { 
                                                                                        $$ = new node("CatchClause");
                                                                                        node *temp_node = new node("catch", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        temp_node = new node("(", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $3);
                                                                                        temp_node = new node(")", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $5);
                                                                                    }
        ;
    CatchFormalParameter:
        pVariableModifier CatchType VariableDeclaratorId                            { 
                                                                                        $$ = new node("CatchFormalParameter");
                                                                                        add_child($$, $1);
                                                                                        add_child($$, $2);
                                                                                        add_child($$, $3);
                                                                                    }
        |   CatchType VariableDeclaratorId                                          { 
                                                                                        $$ = new node("CatchFormalParameter");
                                                                                        add_child($$, $1);
                                                                                        add_child($$, $2);
                                                                                    }
        ;
    CatchType:
        Name sOrName                                                                { 
                                                                                        $$ = new node("CatchType");
                                                                                        add_child($$, $1);
                                                                                        add_child($$, $2);
                                                                                    }
        ;
    // sorClasstype:
    //     |   sorClasstype OPERATOR_bitwiseor Name
    //     ;
    sOrName:                                                                        { $$ = NULL; }
           | sOrName OPERATOR_bitwiseor Name                                        { 
                                                                                        $$ = new node("sOrName");
                                                                                        add_child($$, $1);
                                                                                        node* temp_node = new node("|", true, "OPERATOR");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $3);
                                                                                    } 
           ;
    Finally:
        KEYWORD_finally Block                                                       { 
                                                                                        $$ = new node("Finally");
                                                                                        node* temp_node = new node("finally", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                    }
        ;
    TryWithResourcesStatement:
        KEYWORD_try ResourceSpecification Block qCatches qFinally                   { 
                                                                                        $$ = new node("TryWithResourcesStatement");
                                                                                        node* temp_node = new node("try", true, "KEYWORD");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                        add_child($$, $3);
                                                                                        add_child($$, $4);
                                                                                        add_child($$, $5);
                                                                                    }
        ;
    qFinally:                                                                       { $$ = NULL; }
        |   Finally                                                                 { 
                                                                                        $$ = new node("Finally");
                                                                                        add_child($$, $1);
                                                                                    }
        ;
    ResourceSpecification:
        DELIM_lpar ResourceList qSemicolon DELIM_rpar                               {
                                                                                        $$ = new node("ResourceSpecification");
                                                                                        node* temp_node = new node("(", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $2);
                                                                                        add_child($$, $3);
                                                                                        temp_node = new node(")", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                    }
    qSemicolon:                                                                     { $$ = NULL; }
        |   DELIM_semicolon                                                         {
                                                                                        $$ = new node("Semicolon?");
                                                                                        node* temp_node = new node(";", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                    }
        ;
    ResourceList:
        Resource ssemicolonResource     %prec PREC_reduce_ResourceList              {
                                                                                        $$ = new node("ResourceList");
                                                                                        add_child($$, $1);
                                                                                        add_child($$, $2);
                                                                                    }
        ;
    ssemicolonResource:                                                             { $$ = NULL; }
        |   ssemicolonResource DELIM_semicolon Resource     %prec DELIM_semicolon   {
                                                                                        $$ = new node("SemicolonResource*");
                                                                                        add_child($$, $1);
                                                                                        node* temp_node = new node(";", true, "DELIMITER");
                                                                                        add_child($$, temp_node);
                                                                                        add_child($$, $3);
                                                                                    } // shift over reduce
        ;
    Resource:
        LocalVariableDeclaration                                                    {
                                                                                        $$ = new node("Resource");
                                                                                        add_child($$, $1);
                                                                                    }
        |   VariableAccess                                                          {
                                                                                        $$ = new node("Resource");
                                                                                        add_child($$, $1);
                                                                                    }
        ;
    VariableAccess:
        Name                                                                        {
                                                                                        $$ = new node("VariableAccess");
                                                                                        add_child($$, $1);
                                                                                    }
        | FieldAccess                                                               {
                                                                                        $$ = new node("VariableAccess");
                                                                                        add_child($$, $1);
                                                                                    }
        ;
    Pattern:
        TypePattern                                                                 {
                                                                                        $$ = new node("Pattern");
                                                                                        add_child($$, $1);
                                                                                    }
        ;
    TypePattern:
        LocalVariableDeclaration                                                    {
                                                                                        $$ = new node("TypePattern");
                                                                                        add_child($$, $1);
                                                                                    }
        ;


    /****************** EXPRESSIONS (ASSIGNMENT) ******************/
    Expression:
        AssignmentExpression                                                {
                                                                                $$ = new node("Expression");
                                                                                add_child($$, $1);
                                                                            }
        ;
    AssignmentExpression:
        ConditionalExpression                                               {
                                                                                $$ = new node("AssignmentExpression");
                                                                                add_child($$, $1);
                                                                            }
        |   Assignment                                                      {
                                                                                $$ = new node("AssignmentExpression");
                                                                                add_child($$, $1);
                                                                            }
        ;
    ConditionalExpression:
        ConditionalOrExpression         %prec PREC_cond_to_condor           {
                                                                                $$ = new node("ConditionalExpression");
                                                                                add_child($$, $1);
                                                                            }
        |   ConditionalOrExpression OPERATOR_ternaryquestion Expression OPERATOR_ternarycolon ConditionalExpression         {
                                                                                                                                $$ = new node("ConditionalExpression");
                                                                                                                                add_child($$, $1);
                                                                                                                                node* temp_node = new node("?", true, "OPERATOR");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $3);
                                                                                                                                temp_node = new node(":", true, "OPERATOR");
                                                                                                                                add_child($$, temp_node);
                                                                                                                                add_child($$, $5);
                                                                                                                            }
        ;
    ConditionalOrExpression:
        ConditionalAndExpression        %prec PREC_condor_to_condand                                {
                                                                                                        $$ = new node("ConditionalOrExpression");
                                                                                                        add_child($$, $1);  
                                                                                                    }
        |   ConditionalOrExpression OPERATOR_logicalor ConditionalAndExpression                     {
                                                                                                        $$ = new node("ConditionalOrExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("||", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    ConditionalAndExpression:
        InclusiveOrExpression           %prec PREC_condand_to_incor                                 {
                                                                                                        $$ = new node("ConditionalAndExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   ConditionalAndExpression OPERATOR_logicaland InclusiveOrExpression                      {
                                                                                                        $$ = new node("ConditionalAndExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("&&", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    InclusiveOrExpression:
            ExclusiveOrExpression       %prec PREC_incor_to_excor                                   {
                                                                                                        $$ = new node("InclusiveOrExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   InclusiveOrExpression OPERATOR_bitwiseor ExclusiveOrExpression                          {
                                                                                                        $$ = new node("InclusiveOrExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("|", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    ExclusiveOrExpression:
            AndExpression               %prec PREC_excor_to_and                                     {
                                                                                                        $$ = new node("ExclusiveOrExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   ExclusiveOrExpression OPERATOR_xor AndExpression                                        {
                                                                                                        $$ = new node("ExclusiveOrExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("^", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    AndExpression:
            EqualityExpression          %prec PREC_and_to_equality                                  {
                                                                                                        $$ = new node("AndExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   AndExpression OPERATOR_bitwiseand EqualityExpression                                    {
                                                                                                        $$ = new node("AndExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("&", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    EqualityExpression: 
            RelationalExpression    %prec PREC_equality_to_relational                               { 
                                                                                                        $$ = new node("EqualityExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   EqualityExpression OPERATOR_logicalequal RelationalExpression                           {  
                                                                                                        $$ = new node("EqualityExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("==", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }    
        |   EqualityExpression OPERATOR_neq RelationalExpression                                    {
                                                                                                        $$ = new node("EqualityExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("!=", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    RelationalExpression:
            ShiftExpression                                                                         { 
                                                                                                        $$ = new node("RelationalExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   RelationalExpression OPERATOR_lt ShiftExpression                                        {
                                                                                                        $$ = new node("RelationalExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("<", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }   
        |   RelationalExpression OPERATOR_gt ShiftExpression                                        {
                                                                                                        $$ = new node("RelationalExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node(">", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        |   RelationalExpression OPERATOR_leq ShiftExpression                                       {
                                                                                                        $$ = new node("RelationalExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("<=", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        |   RelationalExpression OPERATOR_geq ShiftExpression                                       {
                                                                                                        $$ = new node("RelationalExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node(">=", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        |   InstanceofExpression                                                                    {
                                                                                                        $$ = new node("RelationalExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        ;
    ShiftExpression:
            AdditiveExpression                                                                      { 
                                                                                                        $$ = new node("ShiftExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   ShiftExpression OPERATOR_leftshift AdditiveExpression                                   {
                                                                                                        $$ = new node("ShiftExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("<<", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        |   ShiftExpression OPERATOR_rightshift AdditiveExpression                                  {
                                                                                                        $$ = new node("ShiftExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node(">>", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        |   ShiftExpression OPERATOR_unsignedrightshift AdditiveExpression                          {
                                                                                                        $$ = new node("ShiftExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node(">>>", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    AdditiveExpression:
            MultiplicativeExpression                                                                {
                                                                                                        $$ = new node("AdditiveExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   AdditiveExpression OPERATOR_plus MultiplicativeExpression                               {
                                                                                                        $$ = new node("AdditiveExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("+", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        |   AdditiveExpression OPERATOR_minus MultiplicativeExpression                              {
                                                                                                        $$ = new node("AdditiveExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("-", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    MultiplicativeExpression:
            UnaryExpression                                                                         {
                                                                                                        $$ = new node("MultiplicativeExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   MultiplicativeExpression OPERATOR_multiply UnaryExpression                              {
                                                                                                        $$ = new node("MultiplicativeExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("*", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        |   MultiplicativeExpression OPERATOR_divide UnaryExpression                                {
                                                                                                        $$ = new node("MultiplicativeExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("/", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        |   MultiplicativeExpression OPERATOR_mod UnaryExpression                                   {
                                                                                                        $$ = new node("MultiplicativeExpression");
                                                                                                        add_child($$, $1);
                                                                                                        node* temp_node = new node("%", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $3);
                                                                                                    }
        ;
    UnaryExpression:
            PreIncrementExpression                                                                  {
                                                                                                        $$ = new node("UnaryExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   PreDecrementExpression                                                                  {
                                                                                                        $$ = new node("UnaryExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        |   OPERATOR_plus UnaryExpression       %prec UNARY_plus                                    {
                                                                                                        $$ = new node("UnaryExpression");
                                                                                                        node* temp_node = new node("+", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);    
                                                                                                    }
        |   OPERATOR_minus UnaryExpression      %prec UNARY_minus                                   {
                                                                                                        $$ = new node("UnaryExpression");
                                                                                                        node* temp_node = new node("-", true, "OPERATOR");
                                                                                                        add_child($$, temp_node);
                                                                                                        add_child($$, $2);    
                                                                                                    }
        |   UnaryExpressionNotPlusMinus                                                             {
                                                                                                        $$ = new node("UnaryExpression");
                                                                                                        add_child($$, $1);
                                                                                                    }
        ;
    PreIncrementExpression:
        OPERATOR_increment UnaryExpression                          {
                                                                        $$ = new node("PreIncrementExpression");
                                                                        node* temp_node = new node("++", true, "OPERATOR");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);    
                                                                    }
        ;
    PreDecrementExpression:
        OPERATOR_decrement UnaryExpression                          {
                                                                        $$ = new node("PreDecrementExpression");
                                                                        node* temp_node = new node("--", true, "OPERATOR");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);    
                                                                    }
        ;
    UnaryExpressionNotPlusMinus:
            Name                                                    {
                                                                        $$ = new node("UnaryExpressionNotPlusMinus");
                                                                        add_child($$, $1);    
                                                                    }
        |   PostfixExpression                                       {
                                                                        $$ = new node("UnaryExpressionNotPlusMinus");
                                                                        add_child($$, $1);    
                                                                    }
        |   OPERATOR_bitwisecomp UnaryExpression                    {
                                                                        $$ = new node("UnaryExpressionNotPlusMinus");
                                                                        node* temp_node = new node("~", true, "OPERATOR");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);    
                                                                    }
        |   OPERATOR_not UnaryExpression                            {
                                                                        $$ = new node("UnaryExpressionNotPlusMinus");
                                                                        node* temp_node = new node("!", true, "OPERATOR");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);    
                                                                    }
        |   CastExpression                                          {
                                                                        $$ = new node("UnaryExpressionNotPlusMinus");
                                                                        add_child($$, $1);    
                                                                    }
        ;   // can also include SwitchExpression
    PostfixExpression:
            Primary                                                 {
                                                                        $$ = new node("PostfixExpression");
                                                                        add_child($$, $1);    
                                                                    }
        |   PostIncrementExpression                                 {
                                                                        $$ = new node("PostfixExpression");
                                                                        add_child($$, $1);    
                                                                    }
        |   PostDecrementExpression                                 {
                                                                        $$ = new node("PostfixExpression");
                                                                        add_child($$, $1);    
                                                                    }
        ;
    Primary:
            PrimaryNoNewArray                                       {
                                                                        $$ = new node("Primary");
                                                                        add_child($$, $1);
                                                                    }
        |   ArrayCreationExpression                                 {
                                                                        $$ = new node("Primary");
                                                                        add_child($$, $1);
                                                                    }
        ;
    PrimaryNoNewArray:
            Literal                                                 {
                                                                        $$ = new node("PrimaryNoNewArray");
                                                                        add_child($$, $1);
                                                                    }
        |   ClassLiteral                                            {
                                                                        $$ = new node("PrimaryNoNewArray");
                                                                        add_child($$, $1);
                                                                    }
        |   KEYWORD_this                                            {
                                                                        $$ = new node("this", true, "KEYWORD");
                                                                    }
        |   Name DELIM_period KEYWORD_this                          {
                                                                        $$ = new node("PrimaryNoNewArray");
                                                                        add_child($$, $1);
                                                                        node* temp_node = new node(".", true, "DELIMITER");
                                                                        add_child($$, temp_node);
                                                                        temp_node = new node("this", true, "KEYWORD");
                                                                        add_child($$, temp_node);

                                                                    }
        |   DELIM_lpar Expression DELIM_rpar                        {
                                                                        $$ = new node("PrimaryNoNewArray");
                                                                        node* temp_node = new node("(", true, "DELIMITER");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);
                                                                        temp_node = new node(")", true, "DELIMITER");
                                                                        add_child($$, temp_node);
                                                                    }
        |   ClassInstanceCreationExpression                         {
                                                                        $$ = new node("PrimaryNoNewArray");
                                                                        add_child($$, $1);
                                                                    }
        |   FieldAccess                                             {
                                                                        $$ = new node("PrimaryNoNewArray");
                                                                        add_child($$, $1);
                                                                    }
        |   ArrayAccess                                             {
                                                                        $$ = new node("PrimaryNoNewArray");
                                                                        add_child($$, $1);
                                                                    }
        |   MethodInvocation                                        {
                                                                        $$ = new node("PrimaryNoNewArray");
                                                                        add_child($$, $1);
                                                                    }
        |   MethodReference                                         {
                                                                        $$ = new node("PrimaryNoNewArray");
                                                                        add_child($$, $1);
                                                                    }
        ;
    Literal : LITERAL_integer                               { string s($1); $$ = new node(s, true, "LITERAL"); }
            | LITERAL_floatingpoint                         { string s($1); $$ = new node(s, true, "LITERAL"); }
            | LITERAL_boolean                               { string s($1); $$ = new node(s, true, "LITERAL"); }
            | LITERAL_char                                  { string s($1); $$ = new node(s, true, "LITERAL"); } 
            | LITERAL_string                                { string s($1); $$ = new node(s, true, "LITERAL"); }
            | LITERAL_textblock                             { string s($1); $$ = new node(s, true, "LITERAL"); }
            | LITERAL_null                                  { $$ = new node("NULL", true, "LITERAL"); }
            ;
    ClassLiteral:
            Name DELIM_period KEYWORD_class                                 {
                                                                                $$ = new node("ClassLiteral");
                                                                                add_child($$, $1);
                                                                                node* temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node("class", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                            }
        |   Name Dims qDims DELIM_period KEYWORD_class                      {
                                                                                $$ = new node("ClassLiteral");
                                                                                add_child($$, $1);
                                                                                add_child($$, $2);
                                                                                add_child($$, $3);
                                                                                node* temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node("class", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                            }
        |   NumericType qDims DELIM_period KEYWORD_class                    {
                                                                                $$ = new node("ClassLiteral");
                                                                                add_child($$, $1);
                                                                                add_child($$, $2);
                                                                                node* temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node("class", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                            }
        |   KEYWORD_boolean qDims DELIM_period KEYWORD_class                {
                                                                                $$ = new node("ClassLiteral");
                                                                                node* temp_node = new node("boolean", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                                add_child($$, $2);
                                                                                temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node("class", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                            }
        |   KEYWORD_void DELIM_period KEYWORD_class                         {
                                                                                $$ = new node("ClassLiteral");
                                                                                node* temp_node = new node("void", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node("class", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                            }
        ; 
    ClassInstanceCreationExpression:
            UnqualifiedClassInstanceCreationExpression                                  {
                                                                                            $$ = new node("ClassInstanceCreationExpression");
                                                                                            add_child($$, $1);
                                                                                        }
        |   Name DELIM_period UnqualifiedClassInstanceCreationExpression                {
                                                                                            $$ = new node("ClassInstanceCreationExpression");
                                                                                            add_child($$, $1);
                                                                                            node* temp_node = new node(".", true, "DELIMITER");
                                                                                            add_child($$, temp_node);
                                                                                            add_child($$, $3);
                                                                                        }
        |   Primary DELIM_period UnqualifiedClassInstanceCreationExpression             {
                                                                                            $$ = new node("ClassInstanceCreationExpression");
                                                                                            add_child($$, $1);
                                                                                            node* temp_node = new node(".", true, "DELIMITER");
                                                                                            add_child($$, temp_node);
                                                                                            add_child($$, $3);
                                                                                        }
        ;
    UnqualifiedClassInstanceCreationExpression:
        KEYWORD_new Name BracketArgumentList qClassBody             {
                                                                        $$ = new node("UnqualifiedClassInstanceCreationExpression");
                                                                        node* temp_node = new node("new", true, "KEYWORD");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);
                                                                        add_child($$, $3);
                                                                        add_child($$, $4);
                                                                    }
        ;
        
    // ! sAnnotation
    // ClassOrInterfaceTypeToInstantiate: Name ;
    //     Identifier sDotIdentifier;
    // sDotIdentifier: | sDotIdentifier DELIM_period Identifier;
    qArgumentList:                                                  {
                                                                        $$ = NULL;    
                                                                    } 
                    | ArgumentList                                  {
                                                                        $$ = new node("ArgumentList?");
                                                                        add_child($$, $1);
                                                                    }
                    ;
    ArgumentList: Expression sCommaExpression                       {
                                                                        $$ = new node("ArgumentList");
                                                                        add_child($$, $1);
                                                                        add_child($$, $2);
                                                                    }
                    ;
    sCommaExpression:                                               {
                                                                        $$ = NULL;
                                                                    }
                    | DELIM_comma Expression sCommaExpression       {
                                                                        $$ = new node("CommaExpression*");
                                                                        node* temp_node = new node(",", true, "DELIMITER");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $2);
                                                                        add_child($$, $3);
                                                                    } 
                    ;
    FieldAccess:
        Primary DELIM_period Identifier                                     {
                                                                                $$ = new node("FieldAccess");
                                                                                add_child($$, $1);
                                                                                node* temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);        
                                                                                string s($3);
                                                                                temp_node = new node(s, true, "ID");
                                                                                add_child($$, temp_node);        
                                                                            }
        |   KEYWORD_super DELIM_period Identifier                           {
                                                                                $$ = new node("FieldAccess");
                                                                                node* temp_node = new node("super", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);        
                                                                                string s($3);
                                                                                temp_node = new node(s, true, "ID");
                                                                                add_child($$, temp_node);
                                                                            }
        |   Name DELIM_period KEYWORD_super DELIM_period Identifier         {
                                                                                $$ = new node("FieldAccess");
                                                                                add_child($$, $1);
                                                                                node* temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node("super", true, "KEYWORD");
                                                                                add_child($$, temp_node);        
                                                                                temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);        
                                                                                string s($5);
                                                                                temp_node = new node(s, true, "ID");
                                                                                add_child($$, temp_node);
                                                                            }
        ;
    ArrayAccess:
        Name DELIM_lsq Expression DELIM_rsq                                 {
                                                                                $$ = new node("ArrayAccess");
                                                                                add_child($$, $1);
                                                                                node* temp_node = new node("[", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                add_child($$, $3);
                                                                                temp_node = new node("]", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                            }
        |   PrimaryNoNewArray DELIM_lsq Expression DELIM_rsq                {
                                                                                $$ = new node("ArrayAccess");
                                                                                add_child($$, $1);
                                                                                node* temp_node = new node("[", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                add_child($$, $3);
                                                                                temp_node = new node("]", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                            }
        ;
    MethodInvocation:
        Name BracketArgumentList                                            {
                                                                                $$ = new node("MethodInvocation");
                                                                                add_child($$, $1);
                                                                                add_child($$, $2);
                                                                            }
        |   Primary DELIM_period Identifier BracketArgumentList             {
                                                                                $$ = new node("MethodInvocation");
                                                                                add_child($$, $1);
                                                                                node* temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                string s($3);
                                                                                temp_node = new node(s, true, "ID");
                                                                                add_child($$, temp_node);
                                                                                add_child($$, $4);
                                                                            }
        |   KEYWORD_super DELIM_period  Identifier BracketArgumentList      {
                                                                                $$ = new node("MethodInvocation");
                                                                                node* temp_node = new node("super", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                string s($3);
                                                                                temp_node = new node(s, true, "ID");
                                                                                add_child($$, temp_node);
                                                                                add_child($$, $4);
                                                                            }
        |   Name DELIM_period KEYWORD_super DELIM_period  Identifier BracketArgumentList                                                {
                                                                                $$ = new node("MethodInvocation");
                                                                                add_child($$, $1);
                                                                                node* temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node("super", true, "KEYWORD");
                                                                                add_child($$, temp_node);
                                                                                temp_node = new node(".", true, "DELIMITER");
                                                                                add_child($$, temp_node);
                                                                                string s($5);
                                                                                temp_node = new node(s, true, "ID");
                                                                                add_child($$, temp_node);
                                                                                add_child($$, $6);
                                                                            }
        ; 
    MethodReference:
        Name DELIM_proportion  Identifier                                       {
                                                                                    $$ = new node("MethodReference");
                                                                                    add_child($$, $1);
                                                                                    node* temp_node = new node("::", true, "DELIMITER");
                                                                                    add_child($$, temp_node);
                                                                                    string s($3);
                                                                                    temp_node = new node(s, true, "ID");
                                                                                    add_child($$, temp_node);
                                                                                }
        |   Primary DELIM_proportion  Identifier                                {
                                                                                    $$ = new node("MethodReference");
                                                                                    add_child($$, $1);
                                                                                    node* temp_node = new node("::", true, "DELIMITER");
                                                                                    add_child($$, temp_node);
                                                                                    string s($3);
                                                                                    temp_node = new node(s, true, "ID");
                                                                                    add_child($$, temp_node);
                                                                                }
        |   ArrayType DELIM_proportion  Identifier                              {
                                                                                    $$ = new node("MethodReference");
                                                                                    add_child($$, $1);
                                                                                    node* temp_node = new node("::", true, "DELIMITER");
                                                                                    add_child($$, temp_node);
                                                                                    string s($3);
                                                                                    temp_node = new node(s, true, "ID");
                                                                                    add_child($$, temp_node);
                                                                                }
        |   KEYWORD_super DELIM_proportion  Identifier                          {
                                                                                    $$ = new node("MethodReference");
                                                                                    node* temp_node = new node("super", true, "KEYWORD");
                                                                                    add_child($$, temp_node);
                                                                                    temp_node = new node("::", true, "DELIMITER");
                                                                                    add_child($$, temp_node);
                                                                                    string s($3);
                                                                                    temp_node = new node(s, true, "ID");
                                                                                    add_child($$, temp_node);
                                                                                }
        |   Name DELIM_period KEYWORD_super DELIM_proportion Identifier         {
                                                                                    $$ = new node("MethodReference");
                                                                                    add_child($$, $1);
                                                                                    node* temp_node = new node(".", true, "DELIMITER");
                                                                                    add_child($$, temp_node);
                                                                                    temp_node = new node("super", true, "KEYWORD");
                                                                                    add_child($$, temp_node);
                                                                                    temp_node = new node("::", true, "DELIMITER");
                                                                                    add_child($$, temp_node);
                                                                                    string s($5);
                                                                                    temp_node = new node(s, true, "ID");
                                                                                    add_child($$, temp_node);
                                                                                }
        |   Name DELIM_proportion  KEYWORD_new                                  {
                                                                                    $$ = new node("MethodReference");
                                                                                    add_child($$, $1);
                                                                                    node* temp_node = new node("::", true, "DELIMITER");
                                                                                    add_child($$, temp_node);
                                                                                    temp_node = new node("new", true, "KEYWORD");
                                                                                    add_child($$, temp_node);
                                                                                }
        |   ArrayType DELIM_proportion KEYWORD_new                              {
                                                                                    $$ = new node("MethodReference");
                                                                                    add_child($$, $1);
                                                                                    node* temp_node = new node("::", true, "DELIMITER");
                                                                                    add_child($$, temp_node);
                                                                                    temp_node = new node("new", true, "KEYWORD");
                                                                                    add_child($$, temp_node);
                                                                                }
        ;
    ArrayCreationExpression:
        KEYWORD_new PrimitiveType DimExprs qDims                        {
                                                                            $$ = new node("ArrayCreationExpression");
                                                                            node* temp_node = new node("new", true, "KEYWORD");
                                                                            add_child($$, temp_node);
                                                                            add_child($$, $2);
                                                                            add_child($$, $3);
                                                                            add_child($$, $4);
                                                                        }
        |   KEYWORD_new Name DimExprs qDims                             {
                                                                            $$ = new node("ArrayCreationExpression");
                                                                            node* temp_node = new node("new", true, "KEYWORD");
                                                                            add_child($$, temp_node);
                                                                            add_child($$, $2);
                                                                            add_child($$, $3);
                                                                            add_child($$, $4);
                                                                        }
        |   KEYWORD_new PrimitiveType Dims ArrayInitializer             {
                                                                            $$ = new node("ArrayCreationExpression");
                                                                            node* temp_node = new node("new", true, "KEYWORD");
                                                                            add_child($$, temp_node);
                                                                            add_child($$, $2);
                                                                            add_child($$, $3);
                                                                            add_child($$, $4);
                                                                        }
        |   KEYWORD_new Name Dims ArrayInitializer                      {
                                                                            $$ = new node("ArrayCreationExpression");
                                                                            node* temp_node = new node("new", true, "KEYWORD");
                                                                            add_child($$, temp_node);
                                                                            add_child($$, $2);
                                                                            add_child($$, $3);
                                                                            add_child($$, $4);
                                                                        }
        ; // ClassOrInterfaceType is same as ClassType
    DimExprs: DimExpr                                                   {
                                                                            $$ = new node("DimExprs");
                                                                            add_child($$, $1);
                                                                        } // DimExprs is equivalent to pDimExpr
        | DimExprs DimExpr                                              {
                                                                            $$ = new node("DimExprs");
                                                                            add_child($$, $1);
                                                                            add_child($$, $2);
                                                                        }
        ;
    // ! sAnnotation
    DimExpr: DELIM_lsq Expression DELIM_rsq                             {
                                                                            $$ = new node("DimExpr");
                                                                            node* temp_node = new node("[", true, "DELIMITER");
                                                                            add_child($$, temp_node);
                                                                            add_child($$, $2);
                                                                            temp_node = new node("]", true, "DELIMITER");
                                                                            add_child($$, temp_node);
                                                                        } 
    ;
    PostIncrementExpression: Name OPERATOR_increment                    {
                                                                            $$ = new node("PostIncrementExpression");
                                                                            add_child($$, $1);
                                                                            node* temp_node = new node("++", true, "OPERATOR");
                                                                            add_child($$, temp_node);                    
                                                                        } 
                            | PostfixExpression OPERATOR_increment      {
                                                                            $$ = new node("PostIncrementExpression");
                                                                            add_child($$, $1);
                                                                            node* temp_node = new node("++", true, "OPERATOR");
                                                                            add_child($$, temp_node);     
                                                                        } 
                            ;
    PostDecrementExpression: Name OPERATOR_decrement                    {
                                                                            $$ = new node("PostDecrementExpression");
                                                                            add_child($$, $1);
                                                                            node* temp_node = new node("--", true, "OPERATOR");
                                                                            add_child($$, temp_node);                    
                                                                        }                          
                           | PostfixExpression OPERATOR_decrement      {
                                                                            $$ = new node("PostDecrementExpression");
                                                                            add_child($$, $1);
                                                                            node* temp_node = new node("--", true, "OPERATOR");
                                                                            add_child($$, temp_node);     
                                                                        } 
                           ; 
    CastExpression:     // Partial implementation of casting. Cannot cast classes
        DELIM_lpar PrimitiveType DELIM_rpar UnaryExpression                                     {
                                                                                                    $$ = new node("CastExpression");
                                                                                                    node* temp_node = new node("(", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $2);
                                                                                                    temp_node = new node(")", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $4);
                                                                                                }
        |   DELIM_lpar ArrayType DELIM_rpar UnaryExpressionNotPlusMinus                         {
                                                                                                    $$ = new node("CastExpression");
                                                                                                    node* temp_node = new node("(", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $2);
                                                                                                    temp_node = new node(")", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $4);
                                                                                                }
        |   DELIM_lpar ArrayType pAdditionalBound DELIM_rpar UnaryExpressionNotPlusMinus        {
                                                                                                    $$ = new node("CastExpression");
                                                                                                    node* temp_node = new node("(", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $2);
                                                                                                    add_child($$, $3);
                                                                                                    temp_node = new node(")", true, "DELIMITER");
                                                                                                    add_child($$, temp_node);
                                                                                                    add_child($$, $5);
                                                                                                }
        // |   DELIM_lpar Name pAdditionalBound DELIM_rpar UnaryExpressionNotPlusMinus
        // |   DELIM_lpar Name DELIM_rpar UnaryExpressionNotPlusMinus
        ;
    // will have to define SwitchExpression: for bonus
    InstanceofExpression:
        RelationalExpression KEYWORD_instanceof ArrayType           { 
                                                                        $$ = new node("InstanceofExpression");
                                                                        add_child($$, $1);
                                                                        node* temp_node = new node("instanceof", true, "KEYWORD");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $3);
                                                                    }
        |   RelationalExpression KEYWORD_instanceof Name            { 
                                                                        $$ = new node("InstanceofExpression");
                                                                        add_child($$, $1);
                                                                        node* temp_node = new node("instanceof", true, "KEYWORD");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $3);
                                                                    }
        |   RelationalExpression KEYWORD_instanceof Pattern         { 
                                                                        $$ = new node("InstanceofExpression");
                                                                        add_child($$, $1);
                                                                        node* temp_node = new node("instanceof", true, "KEYWORD");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $3);
                                                                    }
        ;        
    Assignment:
        LeftHandSide OPERATOR_assignment Expression                 {
                                                                        $$ = new node("Assignment");
                                                                        add_child($$, $1);
                                                                        string s($2);
                                                                        node* temp_node = new node(s, true, "OP_ASSIGNMENT");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $3);
                                                                    }
        | LeftHandSide OPERATOR_equal Expression                    {
                                                                        $$ = new node("Assignment");
                                                                        add_child($$, $1);
                                                                        node* temp_node = new node("=", true, "OP_ASSIGNMENT");
                                                                        add_child($$, temp_node);
                                                                        add_child($$, $3);
                                                                    }
        ;
    LeftHandSide:
        Name                                                        { 
                                                                        $$ = new node("LeftHandSide");
                                                                        add_child($$, $1);
                                                                    }
        |   FieldAccess                                             { 
                                                                        $$ = new node("LeftHandSide");
                                                                        add_child($$, $1);
                                                                    }
        |   ArrayAccess                                             {
                                                                        $$ = new node("LeftHandSide");
                                                                        add_child($$, $1);                                                            
                                                                    }
        ;   
%%

void yyerror(const char *error)
{
    printf("Line Number:%d, Error:%s\n", yylineno, error);
    exit(0);
}

 void add_child(node* parent, node* child) {
        if(!child || !parent) return;
        child->parent = parent;
        parent->children.push_back(child);
        (parent->child_count)++;
}

int main(int argc, char* argv[]) {
    // if(argc != 2) {
    //     cout << "Usage: ./a.out <filename>" << endl;
    //     exit(0);
    // }

    // freopen(argv[1], "r", stdin);
    yyparse();
    // root->print_tree(0);
    root->make_dot();
}