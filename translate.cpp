#include "transact.h"
#include "shader.hpp"

const char* prefix = \
"#define GLM_FORCE_AVX2 \n"
"#define GLM_FORCE_INLINE \n"
"#include <glm/glm.hpp> \n"
"#include <stdio.h> \n"
"using namespace glm; \n"
"#ifdef __cplusplus \n"
"extern \"C\" { \n"
"#endif \n"
"__declspec(dllexport) int glsl_main();"
;

const char* postfix = \
"\n#ifdef __cplusplus \n"
"} \n"
"#endif \n"
;

// static helpers


// interface
int translate_to_cpp(std::string& glsl_src, std::string& output){
    output = glsl_src;
    output.insert(0, prefix);
    output.insert(output.size(), postfix);
    return TRANSLATE_SUCCESS;
}
