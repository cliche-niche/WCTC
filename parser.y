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
    long num;
    long double real;
}

%token<num> NUM
%token<real> REAL

%start prog

%%
    prog: NUM {
        cout << $1 << endl;
        cout << "TERI MA KI CHUT" << endl;
    } 
    | prog NUM {
        cout << $2 << endl;
        cout << "Teri MA ki chut" << endl;
    }
    | REAL {
        cout << $1 << endl;
        cout << "FLOATING POINT NUMBERS MFKER" << endl;
    }
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