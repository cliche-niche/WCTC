clear
flex semaction.l
g++ -o action.o lex.yy.c -ll
./action.o < parser_empty.y
rm lex.yy.c action.o
bison -d -t -v parser.y
flex lexer.l
g++ -o WCTC.o parser.tab.c lex.yy.c node.cpp symbol_table.cpp tac.cpp x86.cpp main.cpp -ll
./WCTC.o -i ../tests/test.java -t tacooo.txt
dot -Tpng tree.gv -o AST.png
rm tree.gv WCTC.o parser.output parser.tab.* lex.yy.c *.csv parser.y