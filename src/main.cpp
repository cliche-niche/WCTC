#include <iostream>
#include "parser.tab.h"
#include "../include/global_vars.hpp"

using namespace std;

extern int yydebug;
extern FILE *yyin;
extern FILE *yyout;

FILE *program;  // the input to the compiler
string input_file = "../tests/test.java";
string output_file = "tree.gv"; 
string st_file = "symbol_table.csv";
string tac_file = "tac.txt";

codegen* gen = new codegen();

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
        else if(std::string(argv[i]) == "--taco" || std::string(argv[i]) == "-t") {
            if((i + 1) < argc) tac_file = argv[i+1];
            else cout << "Error: No 3AC filename given";
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

    root->generate_tac();
    root->convert_to_decimal();

    // root->print_tac("taco.txt");             // unoptimized tac
    bool optimizing = false;
    do{
        optimizing = false;
        optimizing = (root->optimize_tac_RED_TEMPS() || optimizing);
        optimizing = (root->optimize_tac_CONST_and_STR_RED() || optimizing);
        // optimizing = (optimizing || root->optimize_tac_COPY_PROP());
        // optimizing = (optimizing || root->optimize_tac_DC_ELIM());
        root->rename_temporaries();
    }while(optimizing);
    root->print_tac(tac_file);

    gen->gen_global();
    gen->gen_text();
    gen->print_code();
    
    fclose(program);
}

void print_help_page() {
    cout << "Usage: ./WCTC.o [options]     \n\n";
    cout << "Commands:\n-h, --help \t\t\t\t\t Show help page\n";
    cout << "-i, --input <input_file_name> \t\t\t Give input file\n";
    cout << "-o, --output <output_file_name>\t\t\t Redirect dot file to output file\n";
    cout << "-t, --taco <tac_file_name>\t\t\t Redirect 3AC file to tac output file\n";
    cout << "-v, --verbose \t\t\t\t\t Outputs the entire derivation in command line\n";
    return;
}