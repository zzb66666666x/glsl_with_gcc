layout (location = 0) in vec3 aPos;     
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoord;  
   
out vec2 TexCoord;
out vec3 Normal;
out vec3 FragPos;

uniform mat4 projection;    
uniform mat4 view;   
uniform mat4 model;     
