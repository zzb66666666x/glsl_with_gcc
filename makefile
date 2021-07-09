all: main.cpp translate.cpp translate.h shader.hpp
	g++ -g -Wall main.cpp translate.cpp -o main 

clean:
	rm *.exe *.dll