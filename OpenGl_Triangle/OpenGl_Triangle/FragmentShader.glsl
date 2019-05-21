#version 300 es
precision mediump float;

in vec3 fcolor;

out vec4 out_color;

void main(){
    out_color = vec4(fcolor, 1.0f);
}
