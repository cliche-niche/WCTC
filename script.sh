bison -d -t parser.y
flex lexer.l
g++ -o output parser.tab.c lex.yy.c -ll
rm parser.tab.* lex.yy.c 
./output