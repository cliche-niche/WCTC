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
OPERATOR "="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>="|">>>="
DELIMITER ","|";"|"::"|"("|")"|"["|"]"|"{"|"}"|"."|"..."|"@"

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
}
<textblock>[^\"\\]* { }
<textblock>\\ { 
    cerr << "Illegal \\ inside text block found at line: " << yylineno << '\n';
    BEGIN 0;
    return 0;
}
<textblock>\"{1,2} {  }
<textblock><<EOF>> { 
    cerr << "Unfinished textblock. Aborting!" << '\n';
    BEGIN 0;
    return 0; 
}
<textblock>"\""+"\"\"" { 
    BEGIN 0; 
}

{DEC} { yylval.num = stol(yytext); return (NUM); }
{HEX} { yylval.num = stol(((string) yytext).substr(2, ((string) yytext).length()-2), 0, 16); return (NUM); }
{OCT} { yylval.num = stol(yytext, 0, 8); return (NUM); }
{BIN} { yylval.num = stol(((string) yytext).substr(2, ((string) yytext).length()-2), 0, 2) ; return (NUM); }
{DECFLOAT}|{HEXFLOAT} { yylval.real = stold(yytext); return (REAL); }

{RKEYWORD} {  }
{CKEYWORD} {  }
{LITERAL} {  }
{ID} {  }
{OPERATOR} {  }
{DELIMITER} {  }

. {
    cerr << "Unknown character " << yytext << " found at line: " << yylineno << "\n";
    return 0;
}
%%