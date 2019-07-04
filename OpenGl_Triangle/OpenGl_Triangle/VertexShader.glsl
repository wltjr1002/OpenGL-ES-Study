#version 300 es
uniform highp mat4 u_ModelMatrix;
uniform highp mat4 u_ViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 vcolor;
layout (location = 2) in vec2 texCoord;
layout (location = 3) in vec3 normal;
layout (location = 4) in vec3 tangent;
layout (location = 5) in vec3 bitangent;

out vec3 fposition;
out vec3 fcolor;
out vec2 ftexCoord;
out mat3 ftbn;

void main(){
    highp mat4 ModelViewMatrix = u_ViewMatrix * u_ModelMatrix;
    gl_Position = u_ProjectionMatrix * ModelViewMatrix * vec4(position, 1.0f);
    
    fposition = (ModelViewMatrix * vec4(position, 1.0f)).xyz;
    fcolor = vcolor;
    ftexCoord = texCoord;
    vec3 fnormal = (ModelViewMatrix * vec4(normal, 0.0f)).xyz;
    vec3 ftangent = (ModelViewMatrix * vec4(tangent, 0.0f)).xyz;
    vec3 fbitangent = (ModelViewMatrix * vec4(bitangent, 0.0f)).xyz;
    ftbn = mat3(ftangent, fbitangent, fnormal);
}
