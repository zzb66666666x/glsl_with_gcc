# Compile GLSL At Runtime After Simple Parser
If you are familiar with the GLSL and OpenGL, you will know that shader is compiled at run time, which is pretty hard to do if you are wishing to implement it. Now, let's suppose you want realize the similar function (the execution of code will be on CPU of course), and you don't feel like creating your compiler (which is soooo hard!), maybe you can consider first translate the GLSL code to C++, then adopt the method in this project to compile it. 

## What I did

To compile and link at runtime, you should use operating system API `popen` to open another process (not thread!) to execute some bash script. Thanks god, GCC supports taking input from `stdin`, so you can literally pass some string to the gcc to compile, converting the source code (in the form of string) to dll. Then, if you want to use the dll, you can use Windows API to load it and get the address of a function you wanna execute.

Of cource the similar toolchain can be transferred to Linux, in which the `dlopen` API can be used.

## Support GLSL
GLSL is pretty much the same with C++, by `using namespace glm`, you get direct access to the types like `vec3`, `mat4`. All you have to do is to extract enough information (eg. the layout keyword for vertex shader) from the glsl code, add some extra string like `#include <glm/glm.hpp>` to it, then gcc can accept it and compile it!

## Some Thoughts About GLSL I/O 
GLSL also supports the so called in/out keyword to pass variables. Well you can define a nice a parser to keep track of them, keep down the variable names and variable type and then erase them from source code (so that GCC can compile).

Then you can add extra string to the source code which defines some important functions called `input_port(vec3 pos, vec3 texcoord)` and `output_port(vec3 shading_pos)`, then you can define variables inside the GLSL.

```
// in glsl, these varaibles will be treated as file scope global varaibles
in vec3 pos;
in vec texcoord;

// parser strip the in/out keyword to make it c++
vec3 pos;
vec2 texcoord;

// parser detects
input{
	"pos": "vec3",
	"texcoord": "vec2",
}

params_map{
	"pos": "var_1",
	"texcoord": "var_2",
}

// generate code pasted to glsl source to make it c++
void input_port(vec3 var_1, vec2 var_2){
	pos = var_1; // according to params_map
	texcoord = var_2; 
}
```

As for the `uniform` feature, this can also be done by adding auxiliary functions to define it and fetch its value. The type information necessary for function definition would be relying on the parser (whether it's vec3 or vec2).

Note that you can even write the parser by python! So you use c++ code to call the python code to generate  c++ and some important information (eg. how many layouts are in there) in ` .json` format. Then the C++ code would be much easier. 