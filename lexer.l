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

    string tb;
    bool malloced_before_str_lit = false;
    bool malloced_before_id = false;

    // case, const, default, do, goto, import, interface, package, switch, underscore, exports, module, open, opens, provides, record, requires, to, transitive, uses, with
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
OPERATOR "->"
ASSIGNMENTOPERATOR "*="|"/="|"%="|"+="|"-="|"<<="|">>="|">>>="|"&="|"^="|"|="

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

";" { return (DELIM_semicolon); }
"." { return (DELIM_period); }
"(" { return (DELIM_lpar); }
")" { return (DELIM_rpar); }
"[" { return (DELIM_lsq); }
"]" { return (DELIM_rsq); }
"{" { return (DELIM_lcurl); }
"}" { return (DELIM_rcurl); }
"," { return (DELIM_comma); }
"..." { return (DELIM_ellipsis); }
"::" { return (DELIM_proportion); }
"@" { return (DELIM_attherate); }

"abstract" { return (KEYWORD_abstract); }
"assert"   { return (KEYWORD_assert); }
"boolean"  { return (KEYWORD_boolean); }
"break"  { return (KEYWORD_break); }
"byte"  { return (KEYWORD_byte); }
"catch"  { return (KEYWORD_catch); }
"char"  { return (KEYWORD_char); }
"class" { return (KEYWORD_class); }
"double"  { return (KEYWORD_double); }
"else"  { return (KEYWORD_else); }
"enum"  { return (KEYWORD_enum); }
"extends"  { return (KEYWORD_extends); }
"final"  { return (KEYWORD_final); }
"finally"  { return (KEYWORD_finally); }
"float"  { return (KEYWORD_float); }
"for"  { return (KEYWORD_for); }
"if"  { return (KEYWORD_if); }
"implements"  { return (KEYWORD_implements); }
"instanceof"  { return (KEYWORD_instanceof); }
"int"  { return (KEYWORD_int); }
"long"  { return (KEYWORD_long); }
"native"  { return (KEYWORD_native); }
"new"  { return (KEYWORD_new); }
"private"  { return (KEYWORD_private); }
"protected"  { return (KEYWORD_protected); }
"public"  { return (KEYWORD_public); }
"return"  { return (KEYWORD_return); }
"short"  { return (KEYWORD_short); }
"static"  { return (KEYWORD_static); }
"strictfp"  { return (KEYWORD_strictfp); }
"super"  { return (KEYWORD_super); }
"synchronized"  { return (KEYWORD_synchronized); }
"this"  { return (KEYWORD_this); }
"throw"  { return (KEYWORD_throw); }
"throws" { return (KEYWORD_throws); }
"transient"  { return (KEYWORD_transient); }
"try"  { return (KEYWORD_try); }
"void"  { return (KEYWORD_void); }
"volatile"  { return (KEYWORD_volatile); }
"while"  { return (KEYWORD_while); }


"non-sealed"    { return (KEYWORD_nonsealed); }
"permits"   { return (KEYWORD_permits); }
"sealed"    { return (KEYWORD_sealed); }
"var"   { return (KEYWORD_var); }
"yield" { return (KEYWORD_yield); }

"=" { return (OPERATOR_equal); }
"&" { return (OPERATOR_bitwiseand); }
"?" { return (OPERATOR_ternaryquestion); }
":" { return (OPERATOR_ternarycolon); }
"||" { return (OPERATOR_logicalor); }
"&&" { return (OPERATOR_logicaland); }
"|" { return (OPERATOR_bitwiseor); }
"^" { return (OPERATOR_xor); }
"==" { return (OPERATOR_logicalequal); }
"!=" { return (OPERATOR_neq); }
"<" { return (OPERATOR_lt); }
">" { return (OPERATOR_gt); }
"<=" { return (OPERATOR_leq); }
">=" { return (OPERATOR_geq); }
"<<" { return (OPERATOR_leftshift); }
">>" { return (OPERATOR_rightshift); }
">>>" { return (OPERATOR_unsignedrightshift); }
"+" { return (OPERATOR_plus); }
"-" { return (OPERATOR_minus); }
"*" { return (OPERATOR_multiply); } 
"/" { return (OPERATOR_divide); }
"%" { return (OPERATOR_mod); }
"++" { return (OPERATOR_increment); }
"--" { return (OPERATOR_decrement); }
"~" { return (OPERATOR_bitwisecomp); }
"!" { return (OPERATOR_not); }
{ASSIGNMENTOPERATOR} { return (OPERATOR_assignment); }

{DEC} { yylval.numval = stol(yytext); return (LITERAL_integer); }
{HEX} { yylval.numval = stol(((string) yytext).substr(2, ((string) yytext).length()-2), 0, 16); return (LITERAL_integer); }
{OCT} { yylval.numval = stol(yytext, 0, 8); return (LITERAL_integer); }
{BIN} { yylval.numval = stol(((string) yytext).substr(2, ((string) yytext).length()-2), 0, 2) ; return (LITERAL_integer); }
{DECFLOAT}|{HEXFLOAT} { yylval.realval = stold(yytext); return (LITERAL_floatingpoint); }
{BOOL} { return (LITERAL_boolean); }
{CHAR} { yylval.charval = yytext[0]; return (LITERAL_char); }
{STRING} { if (malloced_before_str_lit) {
                free(yylval.strval);
            }
            malloced_before_str_lit = true;
            yylval.strval = (char*) malloc(sizeof(char) * (yyleng + 5));
            strcpy(yylval.strval, yytext); 
            return (LITERAL_string); }
{NULL} { return (LITERAL_null); }

{ID} { if(malloced_before_id) {
        free(yylval.strval);
    }
        malloced_before_id = true;
        yylval.strval = (char *)malloc(sizeof(char) * (yyleng + 5));
        strcpy(yylval.strval, yytext);
        return (Identifier); 
    }

. {
    cerr << "Unknown character " << yytext << " found at line: " << yylineno << "\n";
    return 0;
}
%%