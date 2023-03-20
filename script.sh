flex semaction.l
g++ -o action.o lex.yy.c -ll
./action.o < parser_empty.y
# rm lex.yy.c action.o
bison -d -t -v parser.y
flex lexer.l
g++ -o WCTC.o parser.tab.c lex.yy.c node.cpp symbol_table.cpp main.cpp -ll
./WCTC.o < test.java
# dot -Tpng tree.gv -o AST.png