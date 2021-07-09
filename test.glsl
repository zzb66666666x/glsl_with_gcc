in vec3 v1;
in vec3 v2;

int glsl_main(){
    // vec3 v1(1,2,3);
    // vec3 v2(4,5,6);
    vec3 v3 = v1+v2;
    printf("%f, %f, %f\n", v3.x, v3.y, v3.z);
    return 0;
}