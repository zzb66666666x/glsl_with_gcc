#define GLM_FORCE_AVX2
#define GLM_FORCE_INLINE 
#include <glm/glm.hpp>
#include <stdio.h>
using namespace glm;

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) int glsl_main();

int glsl_main(){
    vec3 v1(1,2,3);
    vec3 v2(4,5,6);
    vec3 out = v1+v2;
    printf("%f, %f, %f\n", out.x, out.y, out.z);
    return 0;
}

#ifdef __cplusplus
}
#endif