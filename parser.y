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

%token<numval> LITERAL_integer
%token<realval> LITERAL_floatingpoint
%token<boolval> LITERAL_boolean
%token<charval> LITERAL_char
%token<strval> LITERAL_string
%token<strval> LITERAL_textblock
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

%type<treenode> IntegralType FloatingPointType PrimitiveType NumericType ArrayType Dims qDims Name

%start CompilationUnit

%%
    /****************** TYPES, VALUES AND VARIABLES  ******************/
    IntegralType:
        KEYWORD_byte                                                    {
                                                                            // $$ = new node("byte", true, "KEYWORD");
                                                                        }
        | KEYWORD_short                                                 {
                                                                            // $$ = new node("short", true, "KEYWORD");
                                                                        }
        | KEYWORD_int                                                   {
                                                                            // $$ = new node("int", true, "KEYWORD");
                                                                        }
        | KEYWORD_long                                                  {
                                                                            // $$ = new node("long", true, "KEYWORD");
                                                                        }
        | KEYWORD_char                                                  {
                                                                            // $$ = new node("char", true, "KEYWORD");
                                                                        }
        ;
    FloatingPointType:
        KEYWORD_float                                                   {
                                                                            // $$ = new node("float", true, "KEYWORD");
                                                                        }
        | KEYWORD_double                                                {
                                                                            // $$ = new node("double", true, "KEYWORD");
                                                                        }
        ;
    // ! sAnnotation and Annotation removed 
    // sAnnotation: | sAnnotation Annotation ;
    // ! sAnnotation removed
    PrimitiveType:
        NumericType                                                     {
                                                                            // $$ = new node("PrimitiveType", false);
                                                                            // add_child($$, $1);
                                                                        }
        | KEYWORD_boolean                                               {
                                                                            // $$ = new node("boolean", true, "KEYWORD");
                                                                        }
        ;
    NumericType :
        IntegralType                                                    {
                                                                            // $$ = new node("NumericType", false);
                                                                            // add_child($$, $1);
                                                                        }
        | FloatingPointType                                             {
                                                                            // $$ = new node("NumericType", false);
                                                                            // add_child($$, $1);
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
                                                                            // $$ = new node("ArrayType", false);
                                                                            // add_child($$, $1);
                                                                            // add_child($$, $2);
                                                                        }
        ; // Java style array declarations ignored
    // ! sAnnotation
    Dims:
        DELIM_lsq DELIM_rsq       %prec PREC_reduce_Dims                {
                                                                            // $$ = new node("Dims", false);
                                                                            // node* temp_node = new node("DELIMITER", true, "[");
                                                                            // add_child($$, temp_node);
                                                                            // temp_node = new node("DELIMITER", true, "]");
                                                                            // add_child($$, temp_node);
                                                                        }
        | DELIM_lsq DELIM_rsq Dims  %prec PREC_shift_Dims               {
                                                                            // $$ = new node("Dims", false);
                                                                            // node* temp_node = new node("DELIMITER", true, "[");
                                                                            // add_child($$, temp_node);
                                                                            // temp_node = new node("DELIMITER", true, "]");
                                                                            // add_child($$, temp_node);
                                                                            // add_child($$, $3);
                                                                        }
        ;
    qDims:                                                              {
                                                                            // $$ = NULL;                                                                    
                                                                        }
        | Dims                                                          {
                                                                            // $$ = new node("qDims", false);
                                                                            // add_child($$, $1);
                                                                        }
        ;
    
    // TypeParameter: sAnnotation TypeIdentifier qTypeBound ;
    // TypeParameterModifier: Annotation //TypeParameterModifier is same as Annotation
    // TypeBound: KEYWORD_extends TypeVariable | KEYWORD_extends ClassType sAdditionalBound ; // useless symbol
    // qTypeBound: | TypeBound ; // useless symbol
    AdditionalBound:
        OPERATOR_bitwiseand Name                                         {  }                                      
        ;
    pAdditionalBound:
        AdditionalBound                                                  {  }
        | pAdditionalBound AdditionalBound                               {  }
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
                                                                            // $$ = new node("Name", false);
                                                                            // // string s($3);
                                                                            // add_child($$, $1);
                                                                            // node* temp_node = new node("Separator", true, ".");
                                                                            // add_child($$, temp_node);
                                                                            // temp_node = new node("Identifier", true, "chutiya");
                                                                            // add_child($$, temp_node);
                                                                        }
        | Identifier                                                    {
                                                                            // string s($1);
                                                                            // s = "ID_" + s;
                                                                            // $$ = new node("Identifier", true, "chutiya");                                                                    
                                                                        }
        ;
    sCommaName:                                                         {
                                                                            
                                                                        }
        | sCommaName DELIM_comma Name                                   {
                                                                            
                                                                        }
        ;
    NameList:
        Name sCommaName                                                 {
                                                                            
                                                                        }
        ;

    /****************** PACKAGES and MODULES  ******************/
    CompilationUnit:
            OrdinaryCompilationUnit { cout << "mathced da!" << endl; }
            ; // used to be OrdinaryCompilationUnit | ModularCompilationUnit;
    OrdinaryCompilationUnit:
        sImportDeclaration sTopLevelClassOrInterfaceDeclaration         {}
        | PackageDeclaration sImportDeclaration sTopLevelClassOrInterfaceDeclaration    {}
        ;
    
    sImportDeclaration:
        |  sImportDeclaration ImportDeclaration                     {}
        ;
    ImportDeclaration:  KEYWORD_import importName DELIM_semicolon   {}
                     ;
    importName: KEYWORD_static Name                                 {}
              | KEYWORD_static Name DELIM_period OPERATOR_multiply  {}
              | Name DELIM_period OPERATOR_multiply                 {}
              | Name                                                {}
              ;                
    
    PackageDeclaration:
        KEYWORD_package Name DELIM_semicolon                        {}
        ;
    
    sTopLevelClassOrInterfaceDeclaration:                                                   {}
        | sTopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclaration          {}
        ;
    TopLevelClassOrInterfaceDeclaration:
        NormalClassDeclaration                                                              {}
        | DELIM_semicolon                                                                   {}
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
        Modifier                                                                                {}
        | Modifiers Modifier                                                                    {}
        | Modifiers pVariableModifier     %prec PREC_reduce_Modifiers                           {}
        ;
    Modifier:
        KEYWORD_public                                                                          {}
        | KEYWORD_private                                                                       {}
        | KEYWORD_protected                                                                     {}
        | KEYWORD_static                                                                        {}
        | KEYWORD_abstract                                                                      {}
        | KEYWORD_native                                                                        {}
        | KEYWORD_synchronized                                                                  {}
        | KEYWORD_transient                                                                     {}
        | KEYWORD_volatile                                                                      {}
        ;

    NormalClassDeclaration:
        Modifiers KEYWORD_class Identifier qClassExtends qClassImplements qClassPermits ClassBody   {}
        ;

    // ClassModifier: KEYWORD_public | KEYWORD_private | KEYWORD_abstract | KEYWORD_static | KEYWORD_final | KEYWORD_sealed | KEYWORD_nonsealed | KEYWORD_strictfp ;
    // sClassModifier: | sClassModifier ClassModifier ;

    ClassExtends:
        KEYWORD_extends Name                                                                        {}
        ;
    qClassExtends:                                                                                  {}
    | ClassExtends                                                                                  {}
    ;

    ClassImplements:
        KEYWORD_implements NameList                                                                 {}
        ;
    qClassImplements:                                                                               {}
        | ClassImplements                                                                           {}
        ;
    // InterfaceTypeList: Name sCommaName ; // replaced by NameList

    ClassPermits:
        KEYWORD_permits Name sCommaName                                                             {}
        ;
    qClassPermits:                                                                                  {}
        | ClassPermits                                                                              {}
        ;
    ClassBody:
        DELIM_lcurl sClassBodyDeclaration DELIM_rcurl                                               {}
        ;
    qClassBody: 
              |                                                                                     {}
              ClassBody                                                                             {}
              ;
    ClassBodyDeclaration: ClassMemberDeclaration                                                    {}
                         | InstanceInitializer                                                      {}
                         | StaticInitializer                                                        {}
                         | ConstructorDeclaration                                                   {}
                         ;
    sClassBodyDeclaration:                                                                          {}
                         | sClassBodyDeclaration ClassBodyDeclaration                               {}
                         ;
    
    ClassMemberDeclaration: FieldDeclaration                                                        {}
                          | MethodDeclaration                                                       {}
                          | NormalClassDeclaration                                                  {}
                          | DELIM_semicolon                                                         {}
                          ; // ClassDeclaration is the same as NormalClassDeclaration, removed InterfaceDeclaration

    FieldDeclaration: Modifiers UnannType VariableDeclaratorList DELIM_semicolon                    {}
                    ;     
    // ! Annotation removed
    // FieldModifier: KEYWORD_public | KEYWORD_private | KEYWORD_static | KEYWORD_final | KEYWORD_transient | KEYWORD_volatile ; 
    // sFieldModifier: | sFieldModifier FieldModifier ;
    
    VariableDeclaratorList: VariableDeclarator sCommaVariableDeclarator        %prec PREC_reduce_VariableDeclaratorList     {}
                          ;
    sCommaVariableDeclarator :                                                                                              {}
                             | sCommaVariableDeclarator DELIM_comma VariableDeclarator    %prec DELIM_comma                 {}
                             ;
    VariableDeclarator: VariableDeclaratorId qEqualVariableInitializer                                                      {}
                      ;
    VariableDeclaratorId: Identifier qDims                                                                                  {}
                        ;
    qEqualVariableInitializer:                                                                                              {}
                             | OPERATOR_equal VariableInitializer                                                           {}
                             ;
    VariableInitializer: Expression                                                                                         {}
                       | ArrayInitializer                                                                                   {}
                       ;

    UnannType: PrimitiveType                                                                                                {} 
             | Name qDims                                                                                                   {}
             ;
    // UnannPrimitiveType: NumericType | KEYWORD_boolean ; // ? literal
    // UnannReferenceType: Name | ArrayType ; //UnannInterfaceType is same as UnannClassType
    // UnannClassOrInterfaceType: UnannClassType | UnannIn  erfaceType ;
    
    // ! sAnnotation
    // UnannClassType: Identifier | Name DELIM_period Identifier | UnannClassType DELIM_period Identifier ; // Replaced by Name
    // UnannInterfaceType: UnannClassType
    // UnannTypeVariable: Identifier // ? Do we remove this? ################## // Replaced by Identifier everywhere
    // UnannArrayType: PrimitiveType Dims | Name Dims

    MethodDeclaration: Modifiers MethodHeader MethodBody                                                                    {}
                     ;

    // ! Annotation removed
    // MethodModifier: KEYWORD_public | KEYWORD_private | KEYWORD_abstract | KEYWORD_static | KEYWORD_final | KEYWORD_synchronized | KEYWORD_native | KEYWORD_strictfp ;
    // sMethodModifier: | sMethodModifier MethodModifier ;

    //  ! Removing this rule: | TypeParameters sAnnotation Result MethodDeclarator qThrows
    MethodHeader: UnannType MethodDeclarator qThrows                                                                        {}
                | KEYWORD_void MethodDeclarator qThrows                                                                     {}
                ;

    // Result: UnannType | KEYWORD_void;

    MethodDeclarator: Identifier DELIM_lpar qFormalParameterList DELIM_rpar qDims                                           {}       
                    | Identifier DELIM_lpar ReceiverParameterComma qFormalParameterList DELIM_rpar qDims                    {} 
                    ; // qreceiverparametercomma was here

    ReceiverParameterComma: ReceiverParameter DELIM_comma                                                                   {}
                          ;
    // ! sAnnotation
    ReceiverParameter: UnannType qIdentifierDot KEYWORD_this                                                                {}
                     ;
    // qReceiverParameterComma: | ReceiverParameterComma ;
    IdentifierDot: Identifier DELIM_period                                                                                  {}
                 ;
    qIdentifierDot:                                                                                                         {}
                  | IdentifierDot                                                                                           {}
                  ;

    FormalParameterList: FormalParameter sCommaFormalParameter                                                              {}
                    ;
    qFormalParameterList: {}
                        | FormalParameterList                                                                               {}
                        ;
    FormalParameter: pVariableModifier UnannType VariableDeclaratorId                                                       {} 
                   | VariableArityParameter                                                                                 {} 
                   | UnannType VariableDeclaratorId                                                                         {}         
                   ;
    sCommaFormalParameter:                                                                                                  {}
                        | sCommaFormalParameter DELIM_comma FormalParameter                                                 {}
                        ;
    
    // ! sAnnotation and Annotation removed
    VariableArityParameter: pVariableModifier UnannType DELIM_ellipsis Identifier                                             {}
                          | UnannType DELIM_ellipsis Identifier                                                               {}
                          ;
    // VariableModifier: KEYWORD_final ;
    // sVariableModifier: | sVariableModifier KEYWORD_final ;
    pVariableModifier: KEYWORD_final                                                                                          {}
                     | pVariableModifier KEYWORD_final      %prec KEYWORD_final                                               {}
                     ;
 
    Throws: KEYWORD_throws NameList 
          ;
    qThrows: 
           |  Throws
           ;
    // ExceptionTypeList: Name sCommaName ; // Replaced by NameList
    
    MethodBody: Block 
              | DELIM_semicolon 
              ;

    InstanceInitializer: Block 
                       ;

    StaticInitializer: KEYWORD_static Block 
                     ;

    ConstructorDeclaration: Modifiers ConstructorDeclarator qThrows ConstructorBody 
                          ;
    // ! Annotation removed
    // ConstructorModifier: KEYWORD_public | KEYWORD_private ;
    // sConstructorModifier: | sConstructorModifier ConstructorModifier ;

    ConstructorDeclarator: Name DELIM_lpar qFormalParameterList DELIM_rpar
                        |   Name DELIM_lpar ReceiverParameterComma qFormalParameterList DELIM_rpar 
                        ;

    ConstructorBody: DELIM_lcurl qBlockStatements DELIM_rcurl
                    | DELIM_lcurl ExplicitConstructorInvocation qBlockStatements DELIM_rcurl 
                    ;
                    
    ExplicitConstructorInvocation: KEYWORD_this BracketArgumentList DELIM_semicolon 
                                 | KEYWORD_super BracketArgumentList DELIM_semicolon
                                 | Name DELIM_period KEYWORD_super BracketArgumentList DELIM_semicolon
                                 | Primary DELIM_period KEYWORD_super BracketArgumentList DELIM_semicolon 
                                 ;
    // qExplicitConstructorInvocation: | ExplicitConstructorInvocation ;
    BracketArgumentList: DELIM_lpar qArgumentList DELIM_rpar 
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
    ArrayInitializer: DELIM_lcurl qVariableInitializerList qComma DELIM_rcurl
                    ;
    qComma: 
            | DELIM_comma
            ;
    sCommaVariableInitializer: 
                            | sCommaVariableInitializer DELIM_comma VariableInitializer %prec DELIM_comma
                            ;
    VariableInitializerList: VariableInitializer sCommaVariableInitializer %prec PREC_reduce_VariableInitializerList 
                            ;
    qVariableInitializerList: 
                            | VariableInitializerList
                            ;

    /****************** BLOCKS, STATEMENTS ******************/
    Block:
        DELIM_lcurl qBlockStatements DELIM_rcurl
        ;
    qBlockStatements:
        |   BlockStatements
        ;
    BlockStatements:
        BlockStatement 
        |   BlockStatement BlockStatements
        ;
    BlockStatement:
            LocalClassOrInterfaceDeclaration
        |   LocalVariableDeclarationStatement
        |   Statement
        ;
    LocalClassOrInterfaceDeclaration:
            NormalClassDeclaration 
        ; // NormalInterfaceDeclaration was removed
    LocalVariableDeclarationStatement:
        LocalVariableDeclaration DELIM_semicolon
        ;
    LocalVariableDeclaration:
        pVariableModifier LocalVariableType VariableDeclaratorList 
        | LocalVariableType VariableDeclaratorList
        ;
    LocalVariableType:
            UnannType
        |   KEYWORD_var
        ;
    Statement:
            StatementWithoutTrailingSubstatement
        |   LabeledStatement
        |   IfThenStatement
        |   IfThenElseStatement
        |   WhileStatement
        |   ForStatement
        ;
    StatementNoShortIf:
            StatementWithoutTrailingSubstatement
        |   LabeledStatementNoShortIf
        |   IfThenElseStatementNoShortIf
        |   WhileStatementNoShortIf
        |   ForStatementNoShortIf
        ;
    StatementWithoutTrailingSubstatement:
            Block
        |   EmptyStatement
        |   ExpressionStatement
        |   AssertStatement
        |   BreakStatement
        |   ContinueStatement
        |   ReturnStatement
        |   SynchronizedStatement
        |   ThrowStatement
        |   TryStatement
        |   YieldStatement
        ;
    EmptyStatement:
        DELIM_semicolon
        ;
    LabeledStatement:
        Identifier OPERATOR_ternarycolon Statement
        ;
    LabeledStatementNoShortIf:
        Identifier OPERATOR_ternarycolon StatementNoShortIf
        ;
    ExpressionStatement:
        StatementExpression DELIM_semicolon
        ;
    StatementExpression:
            Assignment
        |   PreIncrementExpression
        |   PreDecrementExpression
        |   PostIncrementExpression
        |   PostDecrementExpression
        |   MethodInvocation
        |   ClassInstanceCreationExpression
        ;
    IfThenStatement:
        KEYWORD_if DELIM_lpar Expression DELIM_rpar Statement
        ;
    IfThenElseStatement:
        KEYWORD_if DELIM_lpar Expression DELIM_rpar StatementNoShortIf KEYWORD_else Statement
        ;
    IfThenElseStatementNoShortIf:
        KEYWORD_if DELIM_lpar Expression DELIM_rpar StatementNoShortIf KEYWORD_else StatementNoShortIf
        ;
    AssertStatement:
            KEYWORD_assert Expression DELIM_semicolon
        |   KEYWORD_assert Expression OPERATOR_ternarycolon Expression DELIM_semicolon
        ;
    // CaseConstant: ConditionalExpression ; // useless symbol
    WhileStatement:
        KEYWORD_while DELIM_lpar Expression DELIM_rpar Statement
        ;
    WhileStatementNoShortIf:
        KEYWORD_while DELIM_lpar Expression DELIM_rpar StatementNoShortIf
        ;
    ForStatement:
            BasicForStatement
        |   EnhancedForStatement
        ;
    ForStatementNoShortIf:
            BasicForStatementNoShortIf
        |   EnhancedForStatementNoShortIf
        ;
    BasicForStatement:
        KEYWORD_for DELIM_lpar qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate DELIM_rpar Statement
        ;
    BasicForStatementNoShortIf:
        KEYWORD_for DELIM_lpar qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate DELIM_rpar StatementNoShortIf
        ;
    qForInit:
        |   ForInit
        ;
    qForUpdate:
        |   ForUpdate
        ;
    ForInit:
            StatementExpressionList
        |   LocalVariableDeclaration
        ;
    ForUpdate:
        StatementExpressionList
        ;
    StatementExpressionList:
        StatementExpression sCommaStatementExpression
        ;
    sCommaStatementExpression:
        |   sCommaStatementExpression DELIM_comma StatementExpression
        ;
    EnhancedForStatement:
        KEYWORD_for DELIM_lpar LocalVariableDeclaration OPERATOR_ternarycolon Expression DELIM_rpar Statement
        ;
    EnhancedForStatementNoShortIf:
        KEYWORD_for DELIM_lpar LocalVariableDeclaration OPERATOR_ternarycolon Expression DELIM_rpar StatementNoShortIf
        ;
    BreakStatement:
        KEYWORD_break qIdentifier DELIM_semicolon
        ;
    qIdentifier:
        |   Identifier
        ;
    YieldStatement:
        KEYWORD_yield Expression DELIM_semicolon
        ;
    ContinueStatement:
        KEYWORD_continue qIdentifier DELIM_semicolon
        ;
    ReturnStatement:
        KEYWORD_return qExpression DELIM_semicolon
        ;
    qExpression:
        |   Expression
        ;
    ThrowStatement:
        KEYWORD_throw Expression DELIM_semicolon
        ;
    SynchronizedStatement:
        KEYWORD_synchronized DELIM_lpar Expression DELIM_rpar Block
        ;
    TryStatement:
            KEYWORD_try Block Catches
        |   KEYWORD_try Block qCatches Finally
        |   TryWithResourcesStatement
        ;
    qCatches:
        |   Catches
        ;
    pCatches:
            CatchClause
        |   pCatches CatchClause
        ;
    Catches:
        pCatches;
    CatchClause:
        KEYWORD_catch DELIM_lpar CatchFormalParameter DELIM_rpar Block
        ;
    CatchFormalParameter:
        pVariableModifier CatchType VariableDeclaratorId
        |   CatchType VariableDeclaratorId
        ;
    CatchType:
        Name sOrName ;
        ;
    // sorClasstype:
    //     |   sorClasstype OPERATOR_bitwiseor Name
    //     ;
    sOrName:    | sOrName OPERATOR_bitwiseor Name ;
    Finally:
        KEYWORD_finally Block
        ;
    TryWithResourcesStatement:
        KEYWORD_try ResourceSpecification Block qCatches qFinally
        ;
    qFinally:
        |   Finally                                                {}
        ;
    ResourceSpecification:
        DELIM_lpar ResourceList qsemicolon DELIM_rpar                                                {}
    qsemicolon:                                                {}
        |   DELIM_semicolon                                                {}
        ;
    ResourceList:
        Resource ssemicolonResource     %prec PREC_reduce_ResourceList                                                {}
        ;
    ssemicolonResource:
        |   ssemicolonResource DELIM_semicolon Resource     %prec DELIM_semicolon                                                 {}// shift over reduce
        ;
    Resource:
        LocalVariableDeclaration                                                {}
        |   VariableAccess                                                {}
        ;
    VariableAccess:
        Name                                                {}
        | FieldAccess                                                {}
        ;
    Pattern:
        TypePattern                                                {}
        ;
    TypePattern:
        LocalVariableDeclaration                                                {}
        ;


    /****************** EXPRESSIONS (ASSIGNMENT) ******************/
    Expression:
        AssignmentExpression                                                {}
        ;
    AssignmentExpression:
        ConditionalExpression                                                {}
        |   Assignment                                                {}
        ;
    ConditionalExpression:
        ConditionalOrExpression         %prec PREC_cond_to_condor                                                {}
        |   ConditionalOrExpression OPERATOR_ternaryquestion Expression OPERATOR_ternarycolon ConditionalExpression                                                {}
        ;
    ConditionalOrExpression:
        ConditionalAndExpression        %prec PREC_condor_to_condand                                                {}
        |   ConditionalOrExpression OPERATOR_logicalor ConditionalAndExpression                                                {}
        ;
    ConditionalAndExpression:
        InclusiveOrExpression           %prec PREC_condand_to_incor                                                {}
        |   ConditionalAndExpression OPERATOR_logicaland InclusiveOrExpression                                                {}
        ;
    InclusiveOrExpression:
            ExclusiveOrExpression       %prec PREC_incor_to_excor                                                {}
        |   InclusiveOrExpression OPERATOR_bitwiseor ExclusiveOrExpression                                                {}
        ;
    ExclusiveOrExpression:
            AndExpression               %prec PREC_excor_to_and                                                {}
        |   ExclusiveOrExpression OPERATOR_xor AndExpression                                                {}
        ;
    AndExpression:
            EqualityExpression          %prec PREC_and_to_equality                                                {}
        |   AndExpression OPERATOR_bitwiseand EqualityExpression                                                {}
        ;
    EqualityExpression: 
            RelationalExpression    %prec PREC_equality_to_relational           {  }
        |   EqualityExpression OPERATOR_logicalequal RelationalExpression       {  }
        |   EqualityExpression OPERATOR_neq RelationalExpression                                                {}
        ;
    RelationalExpression:
            ShiftExpression          {  }
        |   RelationalExpression OPERATOR_lt ShiftExpression {  }
        |   RelationalExpression OPERATOR_gt ShiftExpression                                                {}
        |   RelationalExpression OPERATOR_leq ShiftExpression                                                {}
        |   RelationalExpression OPERATOR_geq ShiftExpression                                                {}
        |   InstanceofExpression                                                {}
        ;
    ShiftExpression:
            AdditiveExpression  {  }
        |   ShiftExpression OPERATOR_leftshift AdditiveExpression    {  }
        |   ShiftExpression OPERATOR_rightshift AdditiveExpression                                                 {}
        |   ShiftExpression OPERATOR_unsignedrightshift AdditiveExpression                                                {}
        ;
    AdditiveExpression:
            MultiplicativeExpression                                                {}
        |   AdditiveExpression OPERATOR_plus MultiplicativeExpression                                                {}
        |   AdditiveExpression OPERATOR_minus MultiplicativeExpression                                                {}
        ;
    MultiplicativeExpression:
            UnaryExpression                                                {}
        |   MultiplicativeExpression OPERATOR_multiply UnaryExpression                                                {}
        |   MultiplicativeExpression OPERATOR_divide UnaryExpression                                                {}
        |   MultiplicativeExpression OPERATOR_mod UnaryExpression                                                {}
        ;
    UnaryExpression:
            PreIncrementExpression                                                {}
        |   PreDecrementExpression                                                {}
        |   OPERATOR_plus UnaryExpression       %prec UNARY_plus                                                {}
        |   OPERATOR_minus UnaryExpression      %prec UNARY_minus                                                {}
        |   UnaryExpressionNotPlusMinus {  }
        ;
    PreIncrementExpression:
        OPERATOR_increment UnaryExpression                                                {}
        ;
    PreDecrementExpression:
        OPERATOR_decrement UnaryExpression                                                {}
        ;
    UnaryExpressionNotPlusMinus:
            Name                                                {}
        |   PostfixExpression                                                {}
        |   OPERATOR_bitwisecomp UnaryExpression                                                {}
        |   OPERATOR_not UnaryExpression                                                {}
        |   CastExpression                                                {}
        ;   // can also include SwitchExpression
    PostfixExpression:
            Primary                                                {}
        |   PostIncrementExpression                                                {}
        |   PostDecrementExpression                                                 {}
        ;
    Primary:
            PrimaryNoNewArray                                                {}
        |   ArrayCreationExpression                                                {}
        ;
    PrimaryNoNewArray:
            Literal                                                {}
        |   ClassLiteral                                                {}
        |   KEYWORD_this                                                {}
        |   Name DELIM_period KEYWORD_this                                                {}
        |   DELIM_lpar Expression DELIM_rpar                                                {}
        |   ClassInstanceCreationExpression                                                {}
        |   FieldAccess                                                {}
        |   ArrayAccess                                                {}
        |   MethodInvocation                                                {}
        |   MethodReference                                                 {}
        ;
    Literal: LITERAL_integer | LITERAL_floatingpoint | LITERAL_boolean | LITERAL_char | LITERAL_string | LITERAL_textblock | LITERAL_null                                                 {};
    ClassLiteral:
            Name DELIM_period KEYWORD_class                                                {}
        |   Name Dims qDims DELIM_period KEYWORD_class                                                {}
        |   NumericType qDims DELIM_period KEYWORD_class                                                {}
        |   KEYWORD_boolean qDims DELIM_period KEYWORD_class                                                {}
        |   KEYWORD_void DELIM_period KEYWORD_class                                                {}
        ; 
    ClassInstanceCreationExpression:
            UnqualifiedClassInstanceCreationExpression                                                {}
        |   Name DELIM_period UnqualifiedClassInstanceCreationExpression                                                {}
        |   Primary DELIM_period UnqualifiedClassInstanceCreationExpression                                                {}
        ;
    UnqualifiedClassInstanceCreationExpression:
        KEYWORD_new Name BracketArgumentList qClassBody                                                {}
        ;
        
    // ! sAnnotation
    // ClassOrInterfaceTypeToInstantiate: Name ;
    //     Identifier sDotIdentifier;
    // sDotIdentifier: | sDotIdentifier DELIM_period Identifier;
    qArgumentList:                                                {} 
                    | ArgumentList                                                {}
                    ;
    ArgumentList: Expression sCommaExpression                                                 {} ;
    sCommaExpression: | DELIM_comma Expression sCommaExpression                                                 {} ;
    FieldAccess:
        Primary DELIM_period Identifier                                                {}
        |   KEYWORD_super DELIM_period Identifier                                                {}
        |   Name DELIM_period KEYWORD_super DELIM_period Identifier                                                {}
        ;
    ArrayAccess:
        Name DELIM_lsq Expression DELIM_rsq                                                {}
        |   PrimaryNoNewArray DELIM_lsq Expression DELIM_rsq                                                {}
        ;
    MethodInvocation:
        Name BracketArgumentList                                                {}
        |   Primary DELIM_period Identifier BracketArgumentList                                                {}
        |   KEYWORD_super DELIM_period  Identifier BracketArgumentList                                                {}
        |   Name DELIM_period KEYWORD_super DELIM_period  Identifier BracketArgumentList                                                {}
        ; 
    MethodReference:
        Name DELIM_proportion  Identifier                                                {}
        |   Primary DELIM_proportion  Identifier                                                {}
        |   ArrayType DELIM_proportion  Identifier                                                {}
        |   KEYWORD_super DELIM_proportion  Identifier                                                {}
        |   Name DELIM_period KEYWORD_super DELIM_proportion Identifier                                                {}
        |   Name DELIM_proportion  KEYWORD_new                                                {}
        |   ArrayType DELIM_proportion KEYWORD_new                                                {}
        ;
    ArrayCreationExpression:
        KEYWORD_new PrimitiveType DimExprs qDims                                                {}
        |   KEYWORD_new Name DimExprs qDims                                                {}
        |   KEYWORD_new PrimitiveType Dims ArrayInitializer                                                {}
        |   KEYWORD_new Name Dims ArrayInitializer                                                {}
        ; // ClassOrInterfaceType is same as ClassType
    DimExprs: DimExpr                                                 {} // DimExprs is equivalent to pDimExpr
        | DimExprs DimExpr                                                 {}
        ;
    // ! sAnnotation
    DimExpr: DELIM_lsq Expression DELIM_rsq                                                {} ;
    PostIncrementExpression: Name OPERATOR_increment                                                 {} 
                            | PostfixExpression OPERATOR_increment                                                {} ;
    PostDecrementExpression: Name OPERATOR_decrement                         
                           | PostfixExpression OPERATOR_decrement               {  }
                           ; 
    CastExpression:     // Partial implementation of casting. Cannot cast classes
        DELIM_lpar PrimitiveType DELIM_rpar UnaryExpression         {  }
        |   DELIM_lpar ArrayType DELIM_rpar UnaryExpressionNotPlusMinus         {  }
        |   DELIM_lpar ArrayType pAdditionalBound DELIM_rpar UnaryExpressionNotPlusMinus        {  }
        // |   DELIM_lpar Name pAdditionalBound DELIM_rpar UnaryExpressionNotPlusMinus
        // |   DELIM_lpar Name DELIM_rpar UnaryExpressionNotPlusMinus
        ;
    // will have to define SwitchExpression: for bonus
    InstanceofExpression:
        RelationalExpression KEYWORD_instanceof ArrayType           {  }
        |   RelationalExpression KEYWORD_instanceof Name            {  }
        |   RelationalExpression KEYWORD_instanceof Pattern         {  }
        ;        
    Assignment:
        LeftHandSide OPERATOR_assignment Expression                 {  }
        | LeftHandSide OPERATOR_equal Expression                    {  }
        ;
    LeftHandSide:
        Name                                                        {  }
        |   FieldAccess                                             {  }
        |   ArrayAccess                                             {  }
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
}