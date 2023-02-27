bison -d -t -v parser.y
flex lexer.l
g++ parser.tab.c lex.yy.c node.cpp -ll
./a.out < test.java
rm lex.yy.c parser.tab.h parser.tab.c

# typename and package name are just Name