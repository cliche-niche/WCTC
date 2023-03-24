all: WCTC.o

WCTC.o: main.cpp node.cpp parser.y lexer.l symbol_table.cpp global_vars.hpp tac.cpp
	g++ -o WCTC.o parser.tab.c lex.yy.c node.cpp symbol_table.cpp tac.cpp global_vars.hpp main.cpp -ll

parser.tab.h: parser.y node.cpp
	bison -d parser.y

parser.tab.c: parser.y node.cpp
	bison -d parser.y

lex.yy.c: lexer.l parser.y node.cpp
	flex lexer.l

clean:
	rm lex.yy.c parser.tab.h parser.tab.c parser.output *.gv *.o