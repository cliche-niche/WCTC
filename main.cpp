#include <iostream>
#include "node.cpp"
#include "parser.tab.h"

using namespace std;

extern FILE *yyout;  // the output of flex
extern node *root;   // root node of parse tree in the parser
string input_file = ;
string output_file = ""; 

int main(int argc, char* argv[]) {
    bool verbose = false;
    bool help = false;

    for(int i = 1; i < argc; i++){
        if(argv[i] == "-help") {
            print_help_page();
        }
        else if(argv[i] == "-input") {

        }
        else if(argv[i] == "-output") {

        }
        else if(argv[i] == "-verbose") {
            verbose |= (argv[i] == "-verbose");
        }
        else {
            cout << "Error: Invalid parameter\n"
            print_help_page();
        }
    }

    yyout = stderr;

    yyparse();
    if(verbose){
        cout<<"The derivation of the program is: ";
        root->print_tree(0);
    }

    root->clean_tree();
    root->make_dot();
}

void print_help_page() {

}