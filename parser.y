%{
    #include <cstdio> 
    #include <cstring>
    #include <iostream>
    #include <vector>
    #include <stdio.h>

    using namespace std;

    extern "C" int yylex();
    extern "C" int yylineno;
    void yyerror(const char* s);
%}
%define parse.error verbose

%union{
    long numval;
    long double realval;
    int boolval;
    char charval;
    char* strval;
}

/* STACK ONLY DA
ExceptionType
ExceptionTypeList
*/

%token<numval> LITERAL_integer
%token<realval> LITERAL_floatingpoint
%token<boolval> LITERAL_boolean
%token<charval> LITERAL_char
%token<strval> LITERAL_string
%token<strval> LITERAL_textblock
%token LITERAL_null 

%token KEYWORD_class KEYWORD_extends KEYWORD_super KEYWORD_public KEYWORD_private KEYWORD_abstract KEYWORD_static KEYWORD_final KEYWORD_sealed KEYWORD_nonsealed KEYWORD_strictfp KEYWORD_implements KEYWORD_permits KEYWORD_transient KEYWORD_volatile KEYWORD_synchronized KEYWORD_native KEYWORD_void KEYWORD_this KEYWORD_enum KEYWORD_if KEYWORD_else KEYWORD_assert KEYWORD_while KEYWORD_for KEYWORD_break KEYWORD_yield KEYWORD_continue KEYWORD_return KEYWORD_throw KEYWORD_try KEYWORD_catch KEYWORD_finally KEYWORD_boolean KEYWORD_new KEYWORD_instanceof KEYWORD_var KEYWORD_byte KEYWORD_short KEYWORD_int KEYWORD_long KEYWORD_char KEYWORD_float KEYWORD_double
%token<strval> Identifier
%token DELIM_semicolon
%token OPERATOR_assignment

%start CompilationUnit

%%
    /***************************** TOKEN SECTION ******************************/
    //idhar add kardo jo tokens add karne hain, baad multiset ka set bana lenge
    /***************************** TOKEN SECTION ******************************/
    // prog: NUM {
    //     cout << $1 << endl;
    //     cout << "TERI MA KI CHUT" << endl;
    // } 
    // | prog NUM {
    //     cout << $2 << endl;
    //     cout << "Teri MA ki chut" << endl;
    // }
    // | REAL {
    //     cout << $1 << endl;
    //     cout << "FLOATING POINT NUMBERS MFKER" << endl;
    // }

    /****************** TYPES, VALUES AND VARIABLES  ******************/
    IntegralType : KEYWORD_byte | KEYWORD_short | KEYWORD_int | KEYWORD_long | KEYWORD_char ;
    FloatingPointType : KEYWORD_float | KEYWORD_double ;
    // ! sAnnotation and Annotation removed 
    // sAnnotation: | sAnnotation Annotation ;
    // ! sAnnotation removed
    PrimitiveType: NumericType | KEYWORD_boolean ;
    NumericType: IntegralType | FloatingPointType ;
    ReferenceType: Name | Identifier | ArrayType ; // ClassOrInterfaceType is same as ClassType
    // ClassOrInterfaceType: ClassType | InterfaceType
    //! sAnnotation removed
    // ClassType: Identifier | Name "." Identifier | ClassType "." Identifier // We ignore TypeArguments and replace ClassType with Name everywhere
    // InterfaceType: ClassType
    // TypeIdentifier: Identifier // Replaced by Identifier
    // ! sAnnotation
    // TypeVariable: TypeIdentifier ; // TypeIdentifier is same as Identifier, therefore TypeVariable just replaced by Identifier
    ArrayType: PrimitiveType Dims | Name Dims ;

    // ! sAnnotation
    Dims: "[]" | Dims "[]" ;
    qDims: | Dims ;
    
    // TypeParameter: sAnnotation TypeIdentifier qTypeBound ;
    // TypeParameterModifier: Annotation //TypeParameterModifier is same as Annotation
    // TypeBound: KEYWORD_extends TypeVariable | KEYWORD_extends ClassType sAdditionalBound ; // useless symbol
    // qTypeBound: | TypeBound ; // useless symbol
    AdditionalBound: "&" Name ;
    sAdditionalBound: | sAdditionalBound AdditionalBound ;
    // TypeArgumentList: TypeArgument sCommaTypeArgument ; // useless symbol
    // sCommaTypeArgument: | sCommaTypeArgument "," TypeArgument ; // useless symbol
    // TypeArgument: ReferenceType | Wildcard ; // useless symbol
    // ! sAnnotation
    // Wildcard: "?" qWildcardBounds ; // useless symbol
    // WildcardBounds: KEYWORD_extends ReferenceType | KEYWORD_super ReferenceType ; // useless symbol
    // qWildcardBounds: | WildcardBounds; // useless symbol

    /****************** NAMES  ******************/

    Name: Name "." Identifier | Identifier ;
    sCommaName: | sCommaName "," Name ;
    NameList: Name sCommaName ;

    /****************** PACKAGES and MODULES  ******************/
    CompilationUnit: OrdinaryCompilationUnit; // used to be OrdinaryCompilationUnit | ModularCompilationUnit;
    OrdinaryCompilationUnit: sTopLevelClassOrInterfaceDeclaration;
    sTopLevelClassOrInterfaceDeclaration: | sTopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclaration;
    TopLevelClassOrInterfaceDeclaration: NormalClassDeclaration | DELIM_semicolon ; // ClassDeclaration is the same as NormalClassDeclaration
   
    // ModularCompilationUnit: ModuleDeclaration;
    // ModuleDeclaration: sAnnotation qopen KEYWORD_module Identifier sDotIdentifier "{" sModuleDirective "}" ;
    // qopen: KEYWORD_open | ;
    // sDotIdentifier: | sDotIdentifier "." Identifier;
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
    NormalClassDeclaration: sClassModifier KEYWORD_class Identifier qClassExtends qClassImplements qClassPermits ClassBody;

    ClassModifier: KEYWORD_public | KEYWORD_private | KEYWORD_abstract | KEYWORD_static | KEYWORD_final | KEYWORD_sealed | KEYWORD_nonsealed | KEYWORD_strictfp ;
    sClassModifier: | sClassModifier ClassModifier ;

    ClassExtends: KEYWORD_extends Name ;
    qClassExtends: | ClassExtends ;

    ClassImplements: KEYWORD_implements NameList ;
    qClassImplements: | ClassImplements ;
    // InterfaceTypeList: Name sCommaName ; // replaced by NameList

    ClassPermits: KEYWORD_permits Name sCommaName ;
    qClassPermits: | ClassPermits ;
    
    ClassBody: "{" sClassBodyDeclaration "}" ;
    qClassBody: | ClassBody ;
    ClassBodyDeclaration: 
    ClassMemberDeclaration | InstanceInitializer | StaticInitializer | ConstructorDeclaration ;
    sClassBodyDeclaration: | sClassBodyDeclaration ClassBodyDeclaration ;
    
    ClassMemberDeclaration: FieldDeclaration | MethodDeclaration | NormalClassDeclaration | DELIM_semicolon ; // ClassDeclaration is the same as NormalClassDeclaration, removed InterfaceDeclaration

    FieldDeclaration: sFieldModifier UnannType VariableDeclaratorList DELIM_semicolon ;     
    // ! Annotation removed
    FieldModifier: KEYWORD_public | KEYWORD_private | KEYWORD_static | KEYWORD_final | KEYWORD_transient | KEYWORD_volatile ; 
    sFieldModifier: | sFieldModifier FieldModifier ;
    
    VariableDeclaratorList: VariableDeclarator sCommaVariableDeclarator ;
    sCommaVariableDeclarator : | sCommaVariableDeclarator "," VariableDeclarator ;
    VariableDeclarator: VariableDeclaratorId qEqualVariableInitializer ;
    VariableDeclaratorId: Identifier qDims ;
    qEqualVariableInitializer: | "=" VariableInitializer ;
    VariableInitializer: Expression | ArrayInitializer ;

    UnannType: UnannPrimitiveType | UnannReferenceType ;
    UnannPrimitiveType: NumericType | KEYWORD_boolean ; // ? literal
    UnannReferenceType: Name | UnannArrayType ; //UnannInterfaceType is same as UnannClassType
    // UnannClassOrInterfaceType: UnannClassType | UnannInterfaceType ;
    
    // ! sAnnotation
    // UnannClassType: Identifier | Name "." Identifier | UnannClassType "." Identifier ; // Replaced by Name
    // UnannInterfaceType: UnannClassType
    // UnannTypeVariable: Identifier // ? Do we remove this? ################## // Replaced by Identifier everywhere
    UnannArrayType: UnannPrimitiveType Dims | Name Dims

    MethodDeclaration: sMethodModifier MethodHeader MethodBody ;

    // ! Annotation removed
    MethodModifier: KEYWORD_public | KEYWORD_private | KEYWORD_abstract | KEYWORD_static | KEYWORD_final | KEYWORD_synchronized | KEYWORD_native | KEYWORD_strictfp ;
    sMethodModifier: | sMethodModifier MethodModifier ;

    //  ! Removing this rule: | TypeParameters sAnnotation Result MethodDeclarator qThrows
    MethodHeader: Result MethodDeclarator qThrows

    Result: UnannType | KEYWORD_void;

    MethodDeclarator: Identifier "(" qReceiverParameterComma qFormalParameterList ")" qDims ;

    ReceiverParameterComma: ReceiverParameter "," ;
    // ! sAnnotation
    ReceiverParameter: UnannType qIdentifierDot KEYWORD_this ;
    qReceiverParameterComma: | ReceiverParameterComma ;
    IdentifierDot: Identifier "." ;
    qIdentifierDot: | IdentifierDot ;

    FormalParameterList: FormalParameter sCommaFormalParameter ;
    qFormalParameterList: | FormalParameterList ;
    FormalParameter: sVariableModifier UnannType VariableDeclaratorId | VariableArityParameter ;
    sCommaFormalParameter: | sCommaFormalParameter "," FormalParameter ;
    
    // ! sAnnotation and Annotation removed
    VariableArityParameter: sVariableModifier UnannType "..." Identifier ;
    VariableModifier: KEYWORD_final ;
    sVariableModifier: | sVariableModifier VariableModifier ;
 
    Throws: "throws" NameList ;
    qThrows: |  Throws;
    // ExceptionTypeList: Name sCommaName ; // Replaced by NameList
    
    MethodBody: Block | DELIM_semicolon ;

    InstanceInitializer: Block ;

    StaticInitializer: KEYWORD_static Block ;

    ConstructorDeclaration: sConstructorModifier ConstructorDeclarator qThrows ConstructorBody ;
    // ! Annotation removed
    ConstructorModifier: KEYWORD_public | KEYWORD_private ;
    sConstructorModifier: | sConstructorModifier ConstructorModifier ;

    ConstructorDeclarator: Name "(" qReceiverParameterComma qFormalParameterList ")" ;

    ConstructorBody: "{" qExplicitConstructorInvocation qBlockStatements "}" ;
    ExplicitConstructorInvocation: KEYWORD_this BracketArgumentList DELIM_semicolon 
                                 | KEYWORD_super BracketArgumentList DELIM_semicolon 
                                 | Name "." KEYWORD_super BracketArgumentList DELIM_semicolon
                                 | Primary "." KEYWORD_super BracketArgumentList DELIM_semicolon ;
    qExplicitConstructorInvocation: | ExplicitConstructorInvocation ;
    BracketArgumentList: "(" qArgumentList ")" ;
    // qBracketArgumentList: | BracketArgumentList ; // useless symbol

    // EnumDeclaration: sClassModifier KEYWORD_enum TypeIdentifier qClassImplements EnumBody ; // useless symbol
    // EnumBody: "{" qEnumConstantList qComma qEnumBodyDeclarations "}" ; // useless symbol

    // EnumConstantList: EnumConstant sCommaEnumConstant ; // useless symbol
    // qEnumConstantList: | EnumConstantList ; // useless symbol

    // EnumConstant: Identifier qBracketArgumentList qClassBody ; // useless symbol
    // CommaEnumConstant: "," EnumConstant ; // useless symbol
    // sCommaEnumConstant: | sCommaEnumConstant CommaEnumConstant ; // useless symbol


    // EnumBodyDeclarations: DELIM_semicolon sClassBodyDeclaration ; // useless symbol
    // qEnumBodyDeclarations: | EnumBodyDeclarations ; // useless symbol

    //CompactConstructorDeclaration: sConstructorModifier SimpleTypeName ConstructorBody ;  @TODO

    /************** ARRAYS  ******************/
    ArrayInitializer: sArray;
    sArray: | sArray Array;
    Array: qVariableInitializerList qComma;
    qComma: | ",";
    sCommaVariableInitializer: | sCommaVariableInitializer "," VariableInitializer;
    VariableInitializerList: VariableInitializer sCommaVariableInitializer;
    qVariableInitializerList: | VariableInitializerList;




    /****************** BLOCKS, STATEMENTS ******************/
    Block:
        "{" qBlockStatements "}"
        ;
    qBlockStatements:
        |   BlockStatements
        ;
    BlockStatements:
        BlockStatement sBlockStatement
        ;
    sBlockStatement:
        |   sBlockStatement BlockStatement
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
        sVariableModifier LocalVariableType VariableDeclaratorList
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
        Identifier ":" Statement
        ;
    LabeledStatementNoShortIf:
        Identifier ":" StatementNoShortIf
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
        KEYWORD_if "(" Expression ")" Statement
        ;
    IfThenElseStatement:
        KEYWORD_if "(" Expression ")" StatementNoShortIf KEYWORD_else Statement
        ;
    IfThenElseStatementNoShortIf:
        KEYWORD_if "(" Expression ")" StatementNoShortIf KEYWORD_else StatementNoShortIf
        ;
    AssertStatement:
            KEYWORD_assert Expression DELIM_semicolon
        |   KEYWORD_assert Expression ":" Expression DELIM_semicolon
        ;
    // CaseConstant: ConditionalExpression ; // useless symbol
    WhileStatement:
        KEYWORD_while "(" Expression ")" Statement
        ;
    WhileStatementNoShortIf:
        KEYWORD_while "(" Expression ")" StatementNoShortIf
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
        KEYWORD_for "(" qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate ")" Statement
        ;
    BasicForStatementNoShortIf:
        KEYWORD_for "(" qForInit DELIM_semicolon qExpression DELIM_semicolon qForUpdate ")" StatementNoShortIf
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
        |   sCommaStatementExpression "," StatementExpression
        ;
    EnhancedForStatement:
        KEYWORD_for "(" LocalVariableDeclaration ":" Expression ")" Statement
        ;
    EnhancedForStatementNoShortIf:
        KEYWORD_for "(" LocalVariableDeclaration ":" Expression ")" StatementNoShortIf
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
        KEYWORD_synchronized "(" Expression ")" Block
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
        KEYWORD_catch "(" CatchFormalParameter ")" Block
        ;
    CatchFormalParameter:
        sVariableModifier CatchType VariableDeclaratorId
        ;
    CatchType:
        Name sOrName ;
        ;
    // sorClasstype:
    //     |   sorClasstype "|" Name
    //     ;
    sOrName:    | sOrName "|" Name ;
    Finally:
        KEYWORD_finally Block
        ;
    TryWithResourcesStatement:
        KEYWORD_try ResourceSpecification Block qCatches qFinally
        ;
    qFinally:
        |   Finally
        ;
    ResourceSpecification:
        "(" ResourceList qsemicolon ")"
    qsemicolon:
        |   DELIM_semicolon
        ;
    ResourceList:
        Resource ssemicolonResource
        ;
    ssemicolonResource:
        |   ssemicolonResource DELIM_semicolon Resource
        ;
    Resource:
        LocalVariableDeclaration
        |   VariableAccess
        ;
    VariableAccess:
        Name
        | FieldAccess
        ;
    Pattern:
        TypePattern
        ;
    TypePattern:
        LocalVariableDeclaration
        ;


    /****************** EXPRESSIONS (ASSIGNMENT) ******************/
    Expression:
        AssignmentExpression
        ;
    AssignmentExpression:
        ConditionalExpression
        |   Assignment
        ;
    ConditionalExpression:
        ConditionalOrExpression
        |   ConditionalOrExpression "?" Expression ":" ConditionalExpression
        ;
    ConditionalOrExpression:
        ConditionalAndExpression
        |   ConditionalOrExpression "||" ConditionalAndExpression
        ;
    ConditionalAndExpression:
        InclusiveOrExpression
        |   ConditionalAndExpression "&&" InclusiveOrExpression
        ;
    InclusiveOrExpression:
            ExclusiveOrExpression
        |   InclusiveOrExpression "|" ExclusiveOrExpression
        ;
    ExclusiveOrExpression:
            AndExpression
        |   ExclusiveOrExpression "^" AndExpression
        ;
    AndExpression:
            EqualityExpression
        |   AndExpression "&" EqualityExpression
        ;
    EqualityExpression: 
            RelationalExpression
        |   EqualityExpression "==" RelationalExpression
        |   EqualityExpression "!=" RelationalExpression
        ;
    RelationalExpression: 
            ShiftExpression
        |   RelationalExpression "<" ShiftExpression
        |   RelationalExpression ">" ShiftExpression
        |   RelationalExpression "<=" ShiftExpression
        |   RelationalExpression ">=" ShiftExpression
        |   InstanceofExpression
        ;
    ShiftExpression:
            AdditiveExpression
        |   ShiftExpression "<<" AdditiveExpression
        |   ShiftExpression ">>" AdditiveExpression
        |   ShiftExpression ">>>" AdditiveExpression
        ;
    AdditiveExpression:
            MultiplicativeExpression
        |   AdditiveExpression "+" MultiplicativeExpression
        |   AdditiveExpression "-" MultiplicativeExpression
        ;
    MultiplicativeExpression:
            UnaryExpression
        |   MultiplicativeExpression "*" UnaryExpression
        |   MultiplicativeExpression "/" UnaryExpression
        |   MultiplicativeExpression "%" UnaryExpression
        ;
    UnaryExpression:
            PreIncrementExpression
        |   PreDecrementExpression
        |   "+" UnaryExpression
        |   "-" UnaryExpression
        |   UnaryExpressionNotPlusMinus
        ;
    PreIncrementExpression:
        "++" UnaryExpression
        ;
    PreDecrementExpression:
        "--" UnaryExpression
        ;
    UnaryExpressionNotPlusMinus:
            PostfixExpression
        |   "~" UnaryExpression
        |   "!" UnaryExpression
        |   CastExpression
        ;   // can also include SwitchExpression
    PostfixExpression:
            Primary
        |   Name
        |   PostIncrementExpression
        |   PostDecrementExpression 
        ;
    Primary:
            PrimaryNoNewArray
        |   ArrayCreationExpression
        ;
    PrimaryNoNewArray:
            Literal
        |   ClassLiteral
        |   KEYWORD_this
        |   Name "." KEYWORD_this
        |   "(" Expression ")"
        |   ClassInstanceCreationExpression
        |   FieldAccess
        |   ArrayAccess
        |   MethodInvocation
        |   MethodReference 
        ;
    Literal: LITERAL_integer | LITERAL_floatingpoint | LITERAL_boolean | LITERAL_char | LITERAL_string | LITERAL_textblock | LITERAL_null ;
    ClassLiteral:
            Name ssquarebrackets "." "class"
        |   NumericType ssquarebrackets "." "class"
        |   KEYWORD_boolean ssquarebrackets "." "class"
        |   KEYWORD_void "." "class"
        ; 
    ssquarebrackets:
        |   ssquarebrackets "[" "]"
        ;
    ClassInstanceCreationExpression:
            UnqualifiedClassInstanceCreationExpression
        |   Name "." UnqualifiedClassInstanceCreationExpression
        |   Primary "." UnqualifiedClassInstanceCreationExpression
        ;
    UnqualifiedClassInstanceCreationExpression:
        KEYWORD_new  ClassOrInterfaceTypeToInstantiate BracketArgumentList qClassBody
        ;
        
    // ! sAnnotation
    ClassOrInterfaceTypeToInstantiate:
        Identifier sDotsAnnotationIdentifier;
    sDotsAnnotationIdentifier: | sDotsAnnotationIdentifier "." Identifier;
    qArgumentList: | ArgumentList;
    ArgumentList: Expression sCommaExpression;
    sCommaExpression: | sCommaExpression "," Expression;
    FieldAccess:
        Primary "." Identifier
        |   KEYWORD_super "." Identifier
        |   Name "." KEYWORD_super "." Identifier
        ;
    ArrayAccess:
        Name qExpression
        |   PrimaryNoNewArray qExpression
        ;
    MethodInvocation:
        Name BracketArgumentList
        |   Name "."  Identifier BracketArgumentList
        |   Name "."  Identifier BracketArgumentList
        |   Primary "."  Identifier BracketArgumentList
        |   KEYWORD_super "."  Identifier BracketArgumentList
        |   Name "." KEYWORD_super "."  Identifier BracketArgumentList
        ; 
    MethodReference:
        Name "::"  Identifier
        |   Primary "::"  Identifier
        |   ReferenceType "::"  Identifier
        |   KEYWORD_super "::"  Identifier
        |   Name "." KEYWORD_super "::"  Identifier
        |   Name "::"  KEYWORD_new
        |   ArrayType "::" KEYWORD_new
        ;
    ArrayCreationExpression:
        KEYWORD_new PrimitiveType DimExprs qDims
        |   KEYWORD_new Name DimExprs qDims
        |   KEYWORD_new PrimitiveType Dims ArrayInitializer
        |   KEYWORD_new Name Dims ArrayInitializer
        ; // ClassOrInterfaceType is same as ClassType
    DimExprs: DimExpr sDimExpr;
    sDimExpr: | sDimExpr DimExpr;
    // ! sAnnotation
    DimExpr: qExpression;
    PostIncrementExpression: PostfixExpression "++";
    PostDecrementExpression: PostfixExpression "--"; 
    CastExpression:
        "(" PrimitiveType ")" UnaryExpression
        |   "(" ReferenceType sAdditionalBound ")" UnaryExpressionNotPlusMinus
        ;
    // will have to define SwitchExpression: for bonus
    InstanceofExpression:
        RelationalExpression KEYWORD_instanceof ReferenceType
        |   RelationalExpression KEYWORD_instanceof Pattern;
    Assignment:
        LeftHandSide OPERATOR_assignment Expression;
    LeftHandSide:
        Name
        |   FieldAccess
        |   ArrayAccess
        ;   
%%

void yyerror(const char *error)
{
    printf("Line Number:%d, Error:%s\n", yylineno, error);
    exit(0);
}

int main(int argc, char* argv[]) {
    // if(argc != 2) {
    //     cout << "Usage: ./a.out <filename>" << endl;
    //     exit(0);
    // }

    // freopen(argv[1], "r", stdin);
    yyparse();
}