#include <string>
#include <fstream>
#include <sstream>
#include <iostream>
#include <iostream>
#include <assert.h>
// windows API
#include<wtypes.h>   
#include <winbase.h>   
// parser
#include "translate.h"

__declspec(dllimport) int glsl_main();

typedef int (*shader_func)(void);

class Shader{
    public:
    Shader(const char* glsl_path){
        std::ifstream glsl_file;
        glsl_file.open(glsl_path);
        std::stringstream glsl_string_stream;
        // read file's buffer contents into streams
        glsl_string_stream << glsl_file.rdbuf();		
        // close file handlers
        glsl_file.close();
        // convert stream into string
        glsl_code = glsl_string_stream.str();
        int ret = translate_to_cpp(glsl_code, cpp_code);
        assert(ret == TRANSLATE_SUCCESS);
        // std::cout<<cpp_code<<std::endl;
    }

    ~Shader(){
        FreeLibrary(hDLL);
    }

    inline void load_shader(){   
        hDLL = LoadLibrary(TEXT("test.dll")); 
        if(hDLL == NULL)
            std::cout<<"Error!!!\n";  
        glsl_main = (shader_func)GetProcAddress(hDLL,"glsl_main"); 
    }
    
    shader_func glsl_main;

    inline void compile(){
        FILE *proc = popen("g++ -fPIC -shared -o test.dll -x c++ -", "w");
        if(!proc) {
            perror("popen g++");
        }
        fwrite(cpp_code.c_str(), sizeof(char), strlen(cpp_code.c_str()), proc);
        if(ferror(proc)) {
            perror("writing prog");
        }
        if(pclose(proc) == -1) {
            perror("pclose g++");
        }
    }

    private:
        std::string glsl_code;
        std::string cpp_code;
        // windows dll object
        HINSTANCE hDLL;
};