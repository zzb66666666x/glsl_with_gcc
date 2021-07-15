#include "translate.h"

using namespace std;

static string prefix = \
"#include \"vec_math.h\" \n"
"#include <stdio.h> \n"
"using namespace glm; \n"
"__declspec(dllexport) int glsl_main(); \n"
"__declspec(dllexport) void input_port(std::map<std::string, data_t>& indata); \n"
"__declspec(dllexport) void output_port(std::map<std::string, data_t>& outdata); \n"
"__declspec(dllexport) void input_uniform_dispatch(int idx, data_t data); \n"
"__declspec(dllexport) data_t output_uniform_dispatch(int idx); \n"
;


void cpp_code_generate(string& src, string& dest){
    dest = prefix + src;
}