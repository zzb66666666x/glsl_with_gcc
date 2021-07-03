#include <stdio.h>
#include <string.h>

#include "shader.hpp"

const char* prog = "#include <stdio.h>\nint main(void) {puts(\"foo\"); return 0;}";

#define VERSION 2

int main() {
#if(VERSION == 1)
    FILE *proc = popen("gcc -x c -", "w");
    if(!proc) {
        perror("popen gcc");
    }
    fwrite(prog, sizeof(char), strlen(prog), proc);
    if(ferror(proc)) {
        perror("writing prog");
    }
    if(pclose(proc) == -1) {
        perror("pclose gcc");
    }
#endif
#if(VERSION == 2)
    Shader myshader("test.glsl");
    myshader.load_shader();
#endif

    return 0;
}