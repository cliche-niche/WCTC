#include <iostream>
#include "parser.tab.h"
#include "../include/global_vars.hpp"

using namespace std;

extern int yydebug;
extern FILE *yyin;
extern FILE *yyout;

FILE *program;  // the input to the compiler
string input_file = "test.java";
string output_file = "tree.gv"; 
string st_file = "symbol_table.csv";

void print_help_page();

int main(int argc, char* argv[]) {
    bool verbose = false;

    for(int i = 1; i < argc; i++){        
        if(std::string(argv[i]) == "--help" || std::string(argv[i]) == "-h") {
            print_help_page();
            return -1;
        }
        else if(std::string(argv[i]) == "--input" || std::string(argv[i]) == "-i") {
            if((i + 1) < argc) input_file = argv[i+1];
            else cout << "Error: No input filename given";
            i++;
        }
        else if(std::string(argv[i]) == "--output" || std::string(argv[i]) == "-o") {
            if((i + 1) < argc) output_file = argv[i+1];
            else cout << "Error: No output filename given";
            i++;
        }
        else if(std::string(argv[i]) == "--verbose" || std::string(argv[i]) == "-v") {
            verbose = true;
        }
        else {
            cout << "Error: Invalid parameter\n";
            print_help_page();
            return -1;
        }
    }
    
    yyout = stderr;

    program = fopen(input_file.c_str(), "r");
    if(!program) {
        cout << "Error: Program file could not be opened" << endl;
        return -1;
    }

    yyin = program;

    // yydebug = 1;
    yyparse();
    if(verbose){
        root->print_tree(0);
    }

    root->clean_tree();
    root->make_dot(output_file);

    root->create_scope_hierarchy();             // walk 1

    root->populate_default_constructors();      // walk 2
    root->populate_class_sizes();
    root->populate_and_check();

    root->modifier_check();

    root->chill_traversal();                    // walk 3

    main_table->add_SysOutPln();
    // for(auto cls : main_table)
    // main_table->make_csv_wrapper(st_file);    

    root->generate_tac();
    root->print_tac("tac_original.txt");
    root->optimize_tac();
    root->print_tac("tac.txt");
    
    fclose(program);
}

void print_help_page() {
    cout << "Usage: ./WCTC.o [options]     \n\n";
    cout << "Commands:\n-h, --help \t\t\t\t\t Show help page\n";
    cout << "-i, --input <input_file_name> \t\t\t Give input file\n";
    cout << "-o, --output <output_file_name>\t\t\t Redirect dot file to output file\n";
    cout << "-v, --verbose \t\t\t\t\t Outputs the entire derivation in command line\n";
    return;
}