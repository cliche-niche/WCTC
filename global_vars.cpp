#ifndef GLOBAL_VARS_CPP
#define GLOBAL_VARS_CPP



long long int num_scopes;
vector<symbol_table_class> main_table;

map<string, int> type_to_size = {
        {"byte", 1},
        {"short", 2},
        {"int", 4},
        {"long", 8},
        {"float", 4},
        {"double", 8},
        {"boolean", 1},
        {"char", 2}
};

#endif GLOBAL_VARS_CPP