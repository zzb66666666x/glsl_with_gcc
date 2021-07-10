test: main.cpp lex.yy.o y.tab.o parse.h
	g++ -c main.cpp -o main.o
	g++ main.o lex.yy.o y.tab.o -o test

lex.yy.o: lex.yy.c
	gcc -o lex.yy.o -c lex.yy.c

y.tab.o: y.tab.c y.tab.h
	gcc -o y.tab.o -c y.tab.c

parser: test.y test.l
	bison --yacc -dv test.y
	flex test.l

clean:
	rm *.tab.c
	rm *.tab.h
	rm *.yy.c
	rm *.o