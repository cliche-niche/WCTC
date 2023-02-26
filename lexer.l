%{
    #include <iostream>
    #include <stdio.h>
    #include "parser.tab.h"
    using namespace std;

    #define YY_DECL extern "C" int yylex()
    void err (const char* s)
    {
        if(s == NULL) {
            printf("Error in memory allocation");
            exit(0);
        }
    }
%}

%x comment1
%x comment2
%x textblock
%option noyywrap
%option yylineno

SPACE [ \t\f]
LT \n|\r|\r\n
JLETTER [a-zA-Z$_]
NZDIGIT [1-9]
DIGIT [0-9]
HEXDIG [0-9a-fA-F]
OCTDIG [0-7]
BINDIG [0-1]
DIGITS {DIGIT}|{DIGIT}({DIGIT}|"_")*{DIGIT}
DEC ("0"|{NZDIGIT}{DIGITS}?|{NZDIGIT}"_"*{DIGITS})[lL]?
HEXDIGS {HEXDIG}|{HEXDIG}({HEXDIG}|"_")*{HEXDIG}
HEX ("0X"|"0x"){HEXDIGS}[lL]?
OCT "0""_"*({OCTDIG}|{OCTDIG}({OCTDIG}|"_")*{OCTDIG})[lL]?
BIN ("0b"|"0B")({BINDIG}|{BINDIG}({BINDIG}|"_")*{BINDIG})[lL]?
EXP [eE][\+\-]?{DIGITS}
DECFLOAT {DIGITS}"."{DIGITS}?{EXP}?[fFdD]?|"."{DIGITS}{EXP}?[fFdD]?|{DIGITS}{EXP}[fFdD]?|{DIGITS}{EXP}?[fFdD]
HEXFLOAT {HEX}"."?|"0x"{HEXDIGS}?"."{HEXDIGS}|"0X"{HEXDIGS}?"."{HEXDIGS}[pP][\+\-]?{DIGITS}[fFdD]?
BOOL "true"|"false"
NULL "null"
CHAR \'.\'
STRING "\""[^\"\n\r]*"\""
LITERAL {DEC}|{HEX}|{OCT}|{BIN}|{DECFLOAT}|{HEXFLOAT}|{BOOL}|{CHAR}|{STRING}|{NULL}
ID {JLETTER}({JLETTER}|{DIGIT})*
RKEYWORD "abstract"|"assert"|"boolean"|"break"|"byte"|"case"|"catch"|"char"|"class"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extends"|"final"|"finally"|"float"|"for"|"if"|"goto"|"implements"|"import"|"instanceof"|"int"|"interface"|"long"|"native"|"new"|"package"|"private"|"protected"|"public"|"return"|"short"|"static"|"strictfp"|"super"|"switch"|"synchronized"|"this"|"throw"|"throws"|"transient"|"try"|"void"|"volatile"|"while"|"_"
CKEYWORD "exports"|"module"|"non-sealed"|"open"|"opens"|"permits"|"provides"|"record"|"requires"|"sealed"|"to"|"transitive"|"uses"|"var"|"with"|"yield"
OPERATOR ">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"
DELIMITER ","|"::"|"("|")"|"["|"]"|"{"|"}"|"."|"..."|"@"
ASSIGNMENTOPERATOR "="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|">>>="|"&="|"^="|"|="


%%
{LT}
{SPACE}

"/*"  { BEGIN comment1; }
<comment1>[^*\n]*
<comment1>"*"+[^*/\n]*
<comment1>\n
<comment1>"*"+"/"    { BEGIN 0; }

"//"  { BEGIN comment2; }
<comment2>[^\n\r\r\n]*
<comment2>\n { BEGIN 0; }

"\"\"\""{SPACE}*{LT} { 
    BEGIN textblock; 
    tb = yytext;
}
<textblock>[^\"\\]* { tb += yytext; }
<textblock>\\ { 
    cerr << "Illegal \\ inside text block found at line: " << yylineno << '\n';
    BEGIN 0;
    return 0;
}
<textblock>\"{1,2} { tb += yytext; }
<textblock><<EOF>> { 
    cerr << "Unfinished textblock. Aborting!" << '\n';
    BEGIN 0;
    return 0; 
}
<textblock>"\""+"\"\"" { 
    tb += yytext; 
    tb = "";

    return (LITERAL_textblock);
    BEGIN 0; 
}

{INTTYPE} { return (IntegralType); }
{FLOATTYPE} { return (FloatingPointType); }

";" { return (DELIM_semicolon); }
"abstract" { return (KEYWORD_abstract); }
"assert"   { return (KEYWORD_assert); }
"boolean"  { return (KEYWORD_boolean); }
"break"  { return (KEYWORD_break); }
"byte"  { return (KEYWORD_byte); }
"case"  { return (KEYWORD_case); }
"catch"  { return (KEYWORD_catch); }
"char"  { return (KEYWORD_char); }
"const"  { return (KEYWORD_const); }
"default"  { return (KEYWORD_default); }
"do"  { return (KEYWORD_do); }
"double"  { return (KEYWORD_double); }
"else"  { return (KEYWORD_else); }
"enum"  { return (KEYWORD_enum); }
"extends"  { return (KEYWORD_extends); }
"final"  { return (KEYWORD_final); }
"finally"  { return (KEYWORD_finally); }
"float"  { return (KEYWORD_float); }
"for"  { return (KEYWORD_for); }
"if"  { return (KEYWORD_if); }
"goto"  { return (KEYWORD_goto); }
"implements"  { return (KEYWORD_implements); }
"import"  { return (KEYWORD_import); }
"instanceof"  { return (KEYWORD_instanceof); }
"int"  { return (KEYWORD_int); }
"interface"  { return (KEYWORD_interface); }
"long"  { return (KEYWORD_long); }
"implements"  { return (KEYWORD_implements); }
"native"  { return (KEYWORD_native); }
"new"  { return (KEYWORD_new); }
"package"  { return (KEYWORD_package); }
"private"  { return (KEYWORD_private); }
"protected"  { return (KEYWORD_protected); }
"public"  { return (KEYWORD_public); }
"return"  { return (KEYWORD_return); }
"short"  { return (KEYWORD_short); }
"static"  { return (KEYWORD_static); }
"strictfp"  { return (KEYWORD_strictfp); }
"super"  { return (KEYWORD_super); }
"switch"  { return (KEYWORD_switch); }
"synchronized"  { return (KEYWORD_synchronized); }
"this"  { return (KEYWORD_this); }
"throw"  { return (KEYWORD_throw); }
"transient"  { return (KEYWORD_transient); }
"try"  { return (KEYWORD_try); }
"void"  { return (KEYWORD_void); }
"volatile"  { return (KEYWORD_volatile); }
"while"  { return (KEYWORD_while); }
"_"  { return (KEYWORD_underscore); }

"exports"   { return (KEYWORD_exports); }
"module"    { return (KEYWORD_module); }
"non-sealed"    { return (KEYWORD_nonsealed); }
"open"  { return (KEYWORD_open); }
"opens" { return (KEYWORD_opens); }
"permits"   { return (KEYWORD_permits); }
"provides"  { return (KEYWORD_provides); }
"record"    { return (KEYWORD_record); }
"requires"  { return (KEYWORD_requires); }
"sealed"    { return (KEYWORD_sealed); }
"to"    { return (KEYWORD_to); }
"transitive"    { return (KEYWORD_transitive); }
"uses"  { return (KEYWORD_uses); }
"var"   { return (KEYWORD_var); }
"with"  { return (KEYWORD_with); }
"yield" { return (KEYWORD_yield); }

{ASSIGNMENTOPERATOR} { return (OPERATOR_assignment); }

{OPERATOR} {  }

{DEC} { yylval.num = stol(yytext); return (LITERAL_integer); }
{HEX} { yylval.num = stol(((string) yytext).substr(2, ((string) yytext).length()-2), 0, 16); return (LITERAL_integer); }
{OCT} { yylval.num = stol(yytext, 0, 8); return (LITERAL_integer); }
{BIN} { yylval.num = stol(((string) yytext).substr(2, ((string) yytext).length()-2), 0, 2) ; return (LITERAL_integer); }
{DECFLOAT}|{HEXFLOAT} { yylval.real = stold(yytext); return (LITERAL_floatingpoint); }
{BOOL} { return (LITERAL_boolean); }
{CHAR} { return (LITERAL_char); }
{STRING} { return (LITERAL_string); }
{NULL} { return (LITERAL_null); }

{DELIMITER} {  }

{ID} { return (Identifier); }

. {
    cerr << "Unknown character " << yytext << " found at line: " << yylineno << "\n";
    return 0;
}
%%