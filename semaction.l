%{
    using namespace std;
    #include <bits/stdc++.h>

    ofstream output("parser.y");
    vector<string> rhs_terms;
    unordered_map<string, string> token_to_name;
    unordered_map<string, string> token_to_type;
    set<string> lexical_value_needed;

    string lhs;
    
    void initialize_maps();
    void write_func(bool l, string name, bool isT, string token);
    void write_tree_code();
%}

SPACE [ \t\f]
LINES .*"\n"    
TERMS [a-zA-Z_]*
E .|"\n"

%x nonrules
%x rules
%x comment1
%x comment2
%x rhs
%x precedence
%x action
%option yylineno

%%
"%{" {
    initialize_maps();
    output << "%{\n"; 
    BEGIN nonrules;
}
<nonrules>{LINES} {
    output << yytext;
    if(yytext[0] == '%' && yytext[1] == '%') {
        BEGIN rules;
    }
}

<rules>{TERMS} {
    lhs = yytext;
    output << yytext; 
}
<rules>":" {
    output << ":\n\t\t";
    BEGIN rhs;
}
<rules>"\|" {
    output << "| ";
    BEGIN rhs;
}
<rules>"%%" {
    output << "%%\n";
    BEGIN nonrules;
}
<rules>"//" { 
    output << "//";
    BEGIN comment1;
}
<rules>"/*" {
    output << "/*";
    BEGIN comment2;
}
<rules>{E} { output << yytext; }

<comment1>[^\n\r\r\n]* { output << yytext; }
<comment1>\n { output << yytext; BEGIN rules; }

<comment2>[^*\n]* { output << yytext; }
<comment2>"*"+[^*/\n]* { output << yytext; }
<comment2>\n { output << yytext; }
<comment2>"*"+"/" { output << yytext; BEGIN rules; }

<rhs>{TERMS} {
    rhs_terms.push_back(yytext);
    output << yytext << " ";
}
<rhs>"%" {
    output << yytext;
    BEGIN precedence;
}
<rhs>"{" {
    BEGIN action;
    write_tree_code();
}
<rhs>{E} { }

<precedence>"{" {
    BEGIN action;
    write_tree_code();
}
<precedence>{E} { output << yytext; }

<action>"}" {
    output << "}";
    rhs_terms.clear();
    BEGIN rules;
    //"}\n"|"}"({SPACE}|"\n")*";"
}
<action>{E} { 
    output << yytext;
}

{E} { }

%%

void initialize_maps() {
    /********************************* KEYWORDS *********************************/
    string keywords = "KEYWORD_class KEYWORD_extends KEYWORD_super KEYWORD_package KEYWORD_public KEYWORD_private KEYWORD_abstract KEYWORD_static KEYWORD_final KEYWORD_sealed KEYWORD_nonsealed KEYWORD_strictfp KEYWORD_implements KEYWORD_import KEYWORD_permits KEYWORD_transient KEYWORD_volatile KEYWORD_synchronized KEYWORD_native KEYWORD_void KEYWORD_this KEYWORD_enum KEYWORD_if KEYWORD_else KEYWORD_assert KEYWORD_while KEYWORD_for KEYWORD_break KEYWORD_yield KEYWORD_continue KEYWORD_return KEYWORD_throw KEYWORD_try KEYWORD_catch KEYWORD_finally KEYWORD_boolean KEYWORD_new KEYWORD_var KEYWORD_byte KEYWORD_short KEYWORD_int KEYWORD_long KEYWORD_char KEYWORD_float KEYWORD_double KEYWORD_protected KEYWORD_throws KEYWORD_instanceof";
    stringstream strm(keywords);
    string word;
    
    while(strm >> word) {
        int split = word.find('_');
        token_to_type[word] = word.substr(0, split);
        token_to_name[word] = word.substr(split+1, word.size());
    }


    /********************************* DELIMITERS *********************************/
    token_to_name["DELIM_semicolon"] = ";";
    token_to_type["DELIM_semicolon"] = "DELIMITER";

    token_to_name["DELIM_period"] = ".";
    token_to_type["DELIM_period"] = "DELIMITER";
    
    token_to_name["DELIM_lpar"] = "(";
    token_to_type["DELIM_lpar"] = "DELIMITER";
    
    token_to_name["DELIM_rpar"] = ")";
    token_to_type["DELIM_rpar"] = "DELIMITER";
    
    token_to_name["DELIM_lsq"] = "[";
    token_to_type["DELIM_lsq"] = "DELIMITER";
    
    token_to_name["DELIM_rsq"] = "]";
    token_to_type["DELIM_rsq"] = "DELIMITER";
    
    token_to_name["DELIM_lcurl"] = "{";
    token_to_type["DELIM_lcurl"] = "DELIMITER";
    
    token_to_name["DELIM_rcurl"] = "}";
    token_to_type["DELIM_rcurl"] = "DELIMITER";
    
    token_to_name["DELIM_comma"] = ",";
    token_to_type["DELIM_comma"] = "DELIMITER";
    
    token_to_name["DELIM_ellipsis"] = "...";
    token_to_type["DELIM_ellipsis"] = "DELIMITER";
    
    token_to_name["DELIM_proportion"] = "::";
    token_to_type["DELIM_proportion"] = "DELIMITER";
    
    token_to_name["DELIM_attherate"] = "@";
    token_to_type["DELIM_attherate"] = "DELIMITER";

    /********************************* OPERATORS *********************************/
    token_to_name["OPERATOR_equal"] = "=";
    token_to_type["OPERATOR_equal"] = "OPERATOR";
    
    token_to_name["OPERATOR_ternarycolon"] = ":";
    token_to_type["OPERATOR_ternarycolon"] = "OPERATOR";
    token_to_name["OPERATOR_ternaryquestion"] = "?";
    token_to_type["OPERATOR_ternaryquestion"] = "OPERATOR";
    token_to_name["OPERATOR_logicalor"] = "||";
    token_to_type["OPERATOR_logicalor"] = "OPERATOR";
    token_to_name["OPERATOR_logicaland"] = "&&";
    token_to_type["OPERATOR_logicaland"] = "OPERATOR";
    token_to_name["OPERATOR_bitwiseor"] = "|";
    token_to_type["OPERATOR_bitwiseor"] = "OPERATOR";
    token_to_name["OPERATOR_xor"] = "^";
    token_to_type["OPERATOR_xor"] = "OPERATOR";
    token_to_name["OPERATOR_bitwiseand"] = "&";
    token_to_type["OPERATOR_bitwiseand"] = "OPERATOR";
    token_to_name["OPERATOR_logicalequal"] = "==";
    token_to_type["OPERATOR_logicalequal"] = "OPERATOR";
    token_to_name["OPERATOR_neq"] = "!=";
    token_to_type["OPERATOR_neq"] = "OPERATOR";
    token_to_name["OPERATOR_lt"] = "<";
    token_to_type["OPERATOR_lt"] = "OPERATOR";
    token_to_name["OPERATOR_gt"] = ">";
    token_to_type["OPERATOR_gt"] = "OPERATOR";
    token_to_name["OPERATOR_leq"] = "<=";
    token_to_type["OPERATOR_leq"] = "OPERATOR";
    token_to_name["OPERATOR_geq"] = ">=";
    token_to_type["OPERATOR_geq"] = "OPERATOR";
    token_to_name["OPERATOR_leftshift"] = "<<";
    token_to_type["OPERATOR_leftshift"] = "OPERATOR";
    token_to_name["OPERATOR_rightshift"] = ">>";
    token_to_type["OPERATOR_rightshift"] = "OPERATOR";
    token_to_name["OPERATOR_unsignedrightshift"] = ">>>";
    token_to_type["OPERATOR_unsignedrightshift"] = "OPERATOR";
    token_to_name["OPERATOR_plus"] = "+";
    token_to_type["OPERATOR_plus"] = "OPERATOR";
    token_to_name["OPERATOR_minus"] = "-";
    token_to_type["OPERATOR_minus"] = "OPERATOR";
    token_to_name["OPERATOR_multiply"] = "*";
    token_to_type["OPERATOR_multiply"] = "OPERATOR";
    token_to_name["OPERATOR_divide"] = "/";
    token_to_type["OPERATOR_divide"] = "OPERATOR";
    token_to_name["OPERATOR_mod"] = "%";
    token_to_type["OPERATOR_mod"] = "OPERATOR";
    token_to_name["OPERATOR_not"] = "!";
    token_to_type["OPERATOR_not"] = "OPERATOR";
    token_to_name["OPERATOR_bitwisecomp"] = "~";
    token_to_type["OPERATOR_bitwisecomp"] = "OPERATOR";
    token_to_name["OPERATOR_increment"] = "++";
    token_to_type["OPERATOR_increment"] = "OPERATOR";
    token_to_name["OPERATOR_decrement"] = "--";
    token_to_type["OPERATOR_decrement"] = "OPERATOR";

    lexical_value_needed.insert("OPERATOR_assignment");
    token_to_type["OPERATOR_assignment"] = "OPERATOR";

    lexical_value_needed.insert("Identifier");
    token_to_type["Identifier"] = "ID";
    lexical_value_needed.insert("LITERAL_integer");
    token_to_type["LITERAL_integer"] = "LITERAL";
    lexical_value_needed.insert("LITERAL_floatingpoint");
    token_to_type["LITERAL_floatingpoint"] = "LITERAL";
    lexical_value_needed.insert("LITERAL_boolean");
    token_to_type["LITERAL_boolean"] = "LITERAL";
    lexical_value_needed.insert("LITERAL_char");
    token_to_type["LITERAL_char"] = "LITERAL";
    lexical_value_needed.insert("LITERAL_string");
    token_to_type["LITERAL_string"] = "LITERAL";
    lexical_value_needed.insert("LITERAL_textblock");
    token_to_type["LITERAL_textblock"] = "LITERAL";

    token_to_name["LITERAL_null"] = "NULL";
    token_to_type["LITERAL_null"] = "LITERAL";
}

void write_tree_code() {
    output << "{\n";
    output << "\t\t\t";
    if(rhs_terms.empty()) {
        output << "$$ = NULL;\n";
        return;
    }

    output << "node *temp_node;\n";
    if(rhs_terms.size() == 1) {
        if(lexical_value_needed.find(rhs_terms[0]) != lexical_value_needed.end()) {
            output << "\t\t\t";
            output << "string s($1);\n";
            write_func(false, "s", true, token_to_type[rhs_terms[0]]);
        }
        else if(token_to_name.find(rhs_terms[0]) != token_to_name.end()) {
            write_func(false, '\"' + token_to_name[rhs_terms[0]] + '\"', true, token_to_type[rhs_terms[0]]);
        }
        else {
            write_func(false, '\"' + lhs + '\"', false, "");
            output << "\t\t\t";
            output << "$$->add_child($"<< 1 <<");\n";
        }
    }
    else {
        write_func(false, '\"' + lhs + '\"', false, "");
        for(int i = 0; i < rhs_terms.size(); i++) {
            if(lexical_value_needed.find(rhs_terms[i]) != lexical_value_needed.end()) {
                output << "\t\t\t";
                output << "string s($" << (i+1) << ");\n";
                write_func(true, "s", true, token_to_type[rhs_terms[i]]);
            }
            else if(token_to_name.find(rhs_terms[i]) != token_to_name.end()) {
                write_func(true, '\"' + token_to_name[rhs_terms[i]] + '\"', true, token_to_type[rhs_terms[i]]);
            }
            else {
                output << "\t\t\t";
                output << "$$->add_child($"<< (i+1) <<");\n";
            }
        }
    }
}

void write_func(bool l, string name, bool isT, string token) {
    output << "\t\t\t";
    if(l) {
        output << "temp_node = ";
    }
    else {
        output << "$$ = ";
    }
    output << "new node(" << name;
    if(isT) {
        output << ",true,";
        output << "\"" << token << "\"";
    }
    output << ");\n";
    if(l) {
        output << "\t\t\t";
        output << "$$->add_child(temp_node);\n";
    }
}

int main() {


    FILE* parser = fopen("parset.y", "r");
    yyin = parser;

    yylex();

    return 0;
}
