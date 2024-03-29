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
%}

%x comment1
%x comment2
%x textblock
%x character
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
HEXFLOAT {HEX}"."?|("0x"{HEXDIGS}?"."{HEXDIGS}|"0X"{HEXDIGS}?"."{HEXDIGS})[pP][\+\-]?{DIGITS}[fFdD]?
BOOL "true"|"false"
NULL "null"
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
    tb = "";    // we do not include the starting quotes
}
<textblock>[^\"\\]* { tb += yytext; }
<textblock>\\ { 
    cerr << "Illegal \\ inside text block found at line: " << yylineno << '\n';
    BEGIN 0;
    return 0;
}
<textblock>\"{1,2} {
    tb += (yyleng == 1 ? "\\\"" : "\\\"\\\"") ; 
}
<textblock><<EOF>> { 
    cerr << "Unfinished textblock. Aborting!" << '\n';
    BEGIN 0;
    return 0; 
}
<textblock>"\""+"\"\"" { 
    yylval.strval = strdup(tb.c_str()); // we do not include the ending quotes
    tb = "";
    BEGIN 0; 
    return (LITERAL_textblock);
}

"\'" {
    BEGIN character;
    tb = "";
}
<character>[^\'] {
    tb += yytext; 
}
<character>"\'" {
    if(tb.size() == 1) {
        yylval.strval = strdup(tb.c_str());
        BEGIN 0;
        return (LITERAL_char);
    }
    else if(tb.size() == 2) {
        if(tb[0] == '\\') {
            switch(tb[1]) {
                case 't' : yylval.strval = strdup("\t");
                break;
                case 'b' : yylval.strval = strdup("\b");
                break;
                case 'n' : yylval.strval = strdup("\n");
                break;
                case 'r' : yylval.strval = strdup("\r");
                break;
                case 'f' : yylval.strval = strdup("\f");
                break;
                case '\'' : yylval.strval = strdup("\'");
                break;
                case '\"' : yylval.strval = strdup("\"");
                break;
                case '\\' : yylval.strval = strdup("\\");
                break;
                default: cerr << "Illegal escape sequence: " << yylineno << '\n';
                return 0;
            }
            BEGIN 0;
            return (LITERAL_char);
        }
        else {
            cerr << "Illegal character definition found at: " << yylineno << '\n';
            return 0;
        }
    }
    else {
        cerr << "Illegal character definition found at: " << yylineno << '\n';
        return 0;
    }
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
"continue" { return (KEYWORD_continue); }
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
"import"  { return (KEYWORD_import); }
"implements"  { return (KEYWORD_implements); }
"instanceof"  { return (KEYWORD_instanceof); }
"int"  { return (KEYWORD_int); }
"long"  { return (KEYWORD_long); }
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

"System.out.println" { return (STMT_print); }

{ASSIGNMENTOPERATOR} { yylval.strval = strdup(yytext); return (OPERATOR_assignment); }

{DEC}                   { 
                            long long int x = stoll(yytext); 
                            string s = to_string(x); 
                            yylval.strval  = strdup(yytext); 
                            return (LITERAL_integer); 
                        }
{HEX}                   { 
                            long long int x = stoll(((string) yytext).substr(2, ((string) yytext).length()-2), 0, 16); 
                            string s = to_string(x); 
                            yylval.strval = strdup(yytext); 
                            return (LITERAL_integer); 
                        }
{OCT}                   { 
                            // long long int x = stoll(yytext, 0, 8); 
                            // string s = to_string(x); 
                            yylval.strval  = strdup(yytext); 
                            return (LITERAL_integer); 
                        }
{BIN}                   { 
                            long long int x = stoll(((string) yytext).substr(2, ((string) yytext).length()-2), 0, 2); 
                            string s = to_string(x); 
                            yylval.strval  = strdup(s.c_str()); 
                            return (LITERAL_integer); 
                        }
{DECFLOAT}   { 
                            long double x = stold(yytext); 
                            string s = to_string(x); 
                            yylval.strval  = strdup(yytext);
                            return (LITERAL_floatingpoint); 
                        }
{HEXFLOAT}              {
                            long double x = stold(yytext); 
                            string s = to_string(x); 
                            yylval.strval  = strdup(s.c_str());    // TODO DEAL WITH HEXADECIMAL FLOATS
                            return (LITERAL_floatingpoint); 
                        }   
{BOOL}                  { 
                            yylval.strval = strdup(yytext); 
                            return (LITERAL_boolean); 
                        }
{STRING}                {
                            string tmp(yytext);
                            string tmp2 = tmp.substr(1, yyleng - 2);
                            yylval.strval = strdup(tmp2.c_str());
                            return (LITERAL_string); 
                        }
{NULL}                  { 
                            yylval.strval = strdup(yytext); 
                            return (LITERAL_null); 
                        }
{ID}                    { 
                            yylval.strval = strdup(yytext); 
                            return (Identifier); 
                        }

. {
    cerr << "Unknown character " << yytext << " found at line: " << yylineno << "\n";
    return 0;
}
%%