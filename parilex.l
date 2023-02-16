%{
    #include <iostream>
    #include <stdio.h>
    #include "parinay.tab.h"
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
%option noyywrap
%option yylineno

SENTENCE_SEPARATOR       "."|"?"|"!"
SEPARATORS               [,;]
WORD                     [a-zA-Z]+ 
NUM                      [0-9]+
WHITESPACE               [ \t]+
NEWLINE                  "\n"{WHITESPACE}*
FLOAT_NUM                {NUM}"."{NUM}
NUMBER                   {NUM}|{FLOAT_NUM}                  
SENTENCE                 {WHITESPACE}*(({WORD}|{NUMBER}){WHITESPACE}*{SEPARATORS}?{WHITESPACE}*)*
TITLE_KEY                Title
CHAPTER_KEY              Chapter
SECTION_KEY              Section    
D_SENTENCE               {SENTENCE}"."                      
I_SENTENCE               {SENTENCE}"?"
E_SENTENCE               {SENTENCE}"!"
TITLE                    {TITLE_KEY}{WHITESPACE}*":"
CHAPTER                  {CHAPTER_KEY}({WHITESPACE}*{WORD}?{NUMBER}?)*":"
SECTION                  {SECTION_KEY}({WHITESPACE}*{WORD}?{NUMBER}?)*":"                

%%
{TITLE}{SENTENCE}  {   
    yylval.heading = strdup(yytext); 
    err(yylval.heading);
    return TITLE_HEAD;
}

{SECTION}{SENTENCE}  {   
    yylval.heading = strdup(yytext); 
    err(yylval.heading);
    return SECTION_HEAD;
}

{CHAPTER}{SENTENCE}  {   
    yylval.heading = strdup(yytext); 
    err(yylval.heading);
    return CHAPTER_HEAD;
}

{SENTENCE_SEPARATOR}   {   
    yylval.separator = strdup(yytext);
    err(yylval.separator);
    return SENTENCE_SEP;
}

{SEPARATORS}   {   
    yylval.separator = strdup(yytext);
    err(yylval.separator);
    return SEP;
} 

{NUMBER}   {
    yylval.letter = strdup(yytext);
    err(yylval.letter);
    return NUMBER;
}

{WORD}     {
    yylval.letter = strdup(yytext);
    err(yylval.letter);
    return WORD;
}

{WHITESPACE}   {
    return SPACE;
}

{NEWLINE}       {
    return EOL;
}

.   {
    printf("Illegal Character on Line Number:%d\n", yylineno);
    exit(-1);
}


%%
