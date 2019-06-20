#version 300 es
uniform highp mat4 u_ModelMatrix;
uniform highp mat4 u_ViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 vcolor;
layout (location = 2) in vec3 normal;
layout (location = 3) in vec2 texCoord;

out vec3 fcolor;
out vec3 fnormal;
out vec3 fposition;
out vec2 ftexCoord;

void main(){
    highp mat4 ModelViewMatrix = inverse(u_ViewMatrix) * u_ModelMatrix;
    gl_Position = u_ProjectionMatrix * ModelViewMatrix * vec4(position, 1.0f);
    fcolor = vcolor;
    ftexCoord = texCoord;
    fnormal = (ModelViewMatrix * vec4(normal, 0.0f)).xyz;
    fposition = (ModelViewMatrix * vec4(position, 1.0f)).xyz;
}
