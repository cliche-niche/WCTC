all: WCTC.o

WCTC.o: parser.tab.h parser.tab.c node.cpp node.hpp symbol_table.hpp symbol_table.cpp lexer.l parser.y 
	g++ -o WCTC.o parser.tab.c lex.yy.c node.cpp symbol_table.cpp main.cpp -ll

parser.tab.h: parser.y node.cpp
	bison -d -t -v parser.y

parser.tab.c: parser.y node.cpp
	bison -d -t -v parser.y

lex.yy.c: lexer.l parser.y node.cpp
	flex lexer.l

clean:
	rm lex.yy.c parser.tab.h parser.tab.c parser.output *.gv *.o