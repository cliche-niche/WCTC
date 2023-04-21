all: WCTC.o

WCTC.o: main.cpp node.cpp parser.y lexer.l symbol_table.cpp tac.cpp x86.cpp parser.tab.c parser.tab.h lex.yy.c
	g++ -o WCTC.o parser.tab.c lex.yy.c node.cpp symbol_table.cpp tac.cpp x86.cpp main.cpp -ll

parser.tab.h: parser.y node.cpp
	bison -d parser.y

parser.tab.c: parser.y node.cpp
	bison -d parser.y

lex.yy.c: lexer.l parser.y node.cpp
	flex lexer.l

parser.y: parser_empty.y action.o
	./action.o < parser_empty.y; rm lex.yy.c action.o

action.o:
	flex semaction.l; g++ -o action.o lex.yy.c -ll

clean:
	rm lex.yy.c parser.tab.h parser.tab.c parser.output *.gv *.o *.txt parser.y