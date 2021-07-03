all: main.cpp
	g++ -g -Wall main.cpp -o main 

clean:
	rm *.exe *.dll