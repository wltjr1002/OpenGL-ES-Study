#version 300 es
uniform highp mat4 u_ModelViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 vcolor;
layout (location = 2) in vec3 normal;

out vec3 fcolor;
out vec3 fnormal;

void main(){
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(position, 1.0f);
    fcolor = vcolor;
    fnormal = (u_ModelViewMatrix * vec4(normal, 0.0f)).xyz;
}
