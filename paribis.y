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

    string title="";
    string toc="";
    string curr_sec = "";
    int chapters = 0;
    int sections = 0;
    int paragraphs = 0;
    int sentences = 0;
    int words = 0;
    int dsen = 0;
    int esen = 0;
    int isen = 0;

%}
%define parse.error verbose

%union {
    const char* heading;
    const char* separator;
    const char* letter;
}

%token EOL
%token SPACE
%token<letter> WORD
%token<letter> NUMBER
%token<heading> TITLE_HEAD
%token<heading> SECTION_HEAD
%token<heading> CHAPTER_HEAD
%token<separator> SENTENCE_SEP
%token<separator> SEP

%%
%start DISSERTATION;

DISSERTATION:
    TITLE_HEAD EOLS CHAPTERS{
        title = $1;
    }   
|   SPACE TITLE_HEAD EOLS CHAPTERS{
        title = $2;
    };

EOLS:
    EOL 
|   EOL EOLS;

CHAPTERS:
    CHAPTER CHAPTERS {
        chapters++;
    }
|   CHAPTER{
        chapters++;
    };

CHAPTER:
    CHAPTER_HEAD EOLS SECTIONS {
        string s = $1;
        toc += s + "\n" + curr_sec;
        curr_sec = "";
    }
|   CHAPTER_HEAD EOLS PARAGRAPHS {
        string s = $1;
        toc += s + "\n" + curr_sec;
        curr_sec = "";
    }
|   CHAPTER_HEAD EOLS PARAGRAPHS SECTIONS {
        string s = $1;
        toc += s + "\n" + curr_sec;
        curr_sec = "";
    };

SECTIONS:
    SECTION SECTIONS {
        sections++;
    }
|   SECTION{
        sections++;
    };

SECTION:
    SECTION_HEAD EOLS PARAGRAPHS {
        string s = $1;
        curr_sec += "\t" + s + "\n";
    };

PARAGRAPHS:
    PARAGRAPH EOL EOLS PARAGRAPHS{
        paragraphs++;
    }
|   PARAGRAPH EOLS{
        paragraphs++;
    }
|   PARAGRAPH{
        paragraphs++;
    };

PARAGRAPH:
    SENTENCES;

SENTENCES:
    SENTENCE SENTENCES {
        sentences++;
    }
|   SENTENCE SPACE{
        sentences++;
    }
|   SENTENCE{
        sentences++;
    };

SENTENCE:
    SPACE WORDS SENTENCE_SEP {
        if($3[0] == '?')
            isen++;
        else if($3[0] == '.')
            dsen++;
        else if($3[0] == '!')
            esen++;
    }
|   WORDS SENTENCE_SEP {
        if($2[0] == '?')
            isen++;
        else if($2[0] == '.')
            dsen++;
        else if($2[0] == '!')
            esen++;
    };

WORDS:
    WORD SPACE WORDS{
        words++;
    }
|   WORD WORDS{
        words++;
    }
|   SEP SPACE SEP_WORDS
|   SEP SEP_WORDS
|   NUMBER SPACE WORDS
|   NUMBER WORDS
|   SEP
|   WORD {
        words++;
    }
|   NUMBER
|   SEP SPACE
|   WORD SPACE {
        words++;
    }
|   NUMBER SPACE;

SEP_WORDS:
    WORD SPACE WORDS {
        words++;
    }
|   WORD WORDS{
        words++;
    }
|   NUMBER SPACE WORDS
|   NUMBER WORDS
|   WORD {
        words++;
    }
|   NUMBER
|   WORD SPACE
|   NUMBER SPACE;


%%

void yyerror(const char *error)
{
    printf("Line Number:%d, Error:%s\n", yylineno, error);
    exit(0);
}

int main(int argc, char* argv[]) {
    if(argc != 2) {
        cout << "Usage: ./a.out <filename>" << endl;
        exit(0);
    }

    freopen(argv[1], "r", stdin);
    yyparse();

    cout << title << endl;
    cout << "Number of Chapters " << chapters << endl;
    cout << "Number of Sections " << sections << endl;
    cout << "Number of Paragraphs " << paragraphs << endl;
    cout << "Number of Sentences " << sentences << endl;
    cout << "Number of Words " << words << endl;
    cout << "Number of Declarative Sentences " <<  dsen << endl;
    cout << "Number of Interrogative Sentences " <<  isen << endl;
    cout << "Number of Exclamatory Sentences " <<  esen << endl;
    cout << "Table of contents: " << endl;
    cout << toc;
}

