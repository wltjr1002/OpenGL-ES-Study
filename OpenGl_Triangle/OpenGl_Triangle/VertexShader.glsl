#version 300 es
uniform highp mat4 u_ModelViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 vcolor;

out vec3 fcolor;

void main(){
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(position, 1.0f);
    fcolor = vcolor;
}
