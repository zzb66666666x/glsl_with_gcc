#include <iostream>
#include "parse.h"

using namespace std;

const char* prog = \
"layout(location=0)in vec3 aPos;\n"
"layout(location=1)in vec3 aNormal;\n"
"layout(location=2)in vec2 aTexCoord;\n"
;

int main(){
    parse_file("code.glsl");
    return 0;
}