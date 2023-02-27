bison -d -t -v parser.y
flex lexer.l
g++ parser.tab.c lex.yy.c -ll