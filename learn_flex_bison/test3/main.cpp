#include <iostream>
#include <stdio.h>
#include "parse.h"

using namespace std;

const char* prog = \
"layout(location=0)in vec3 aPos;\n"
"layout(location=1)in vec3 aNormal;\n"
"layout(location=2)in vec2 aTexCoord;\n"
;

int main(){
    printf("testing parsing a file\n");
    parse_file("code.glsl");
    printf("testing parsing a string");
    parse_string(prog);
    return 0;
}