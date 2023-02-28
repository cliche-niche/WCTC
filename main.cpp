#include <iostream>
#include "node.cpp"
#include "parser.tab.h"

using namespace std;

extern FILE *yyout;  // the output of flex
extern node *root;   // root node of parse tree in the parser
string input_file = "test.java";
string output_file = "tree.gv"; 

void print_help_page();

int main(int argc, char* argv[]) {
    bool verbose = false;
    bool help = false;

    for(int i = 1; i < argc; i++){
        cout << argv[i] << endl;
        
        if(std::string(argv[i]) == "-help" || std::string(argv[i]) == "-h") {
            print_help_page();
            return 0;
        }
        else if(std::string(argv[i]) == "-input" || std::string(argv[i]) == "-i") {
            if((i + 1) < argc) input_file = argv[i+1];
            else cout << "Error: No input filename given";
            i++;
        }
        else if(std::string(argv[i]) == "-output" || std::string(argv[i]) == "-o") {
            if((i + 1) < argc) output_file = argv[i+1];
            else cout << "Error: No output filename given";
            i++;
        }
        else if(std::string(argv[i]) == "-verbose" || std::string(argv[i]) == "-v") {
            verbose = true;
            cout << "Hello?" << endl;
        }
        else {
            cout << "Error: Invalid parameter\n";
            print_help_page();
            return 0;
        }
    }
    
    yyout = stderr;

    string str = "./WCTC < ";
    str = str + input_file;
    const char *command = str.c_str();
    system(command);
    
    yyparse();
    if(verbose){
        root->print_tree(0);
    }

    root->clean_tree();
    root->make_dot(output_file);
}

void print_help_page() {
    cout << "Usage: <command> [options] \n\n";
    cout << "Commands:\n -h, -help \t Show help page";
    cout << "-i, -input \t Give input file";
    cout << "-o, -output \t Redirect output to output file";
    cout << "-v, -verbose \t Verbose mode";
    return;
}