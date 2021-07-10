all: main.cpp translate.cpp translate.h shader.hpp
	g++ -g -Wall main.cpp translate.cpp -o main 

parser:
	bison --yacc -dv parse_glsl.y
	flex parse_glsl.l

clean:
	rm *.exe *.dll