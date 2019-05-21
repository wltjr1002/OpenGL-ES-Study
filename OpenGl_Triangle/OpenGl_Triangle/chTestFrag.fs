#version 300 es
precision mediump float;

in vec3 fColor;
out vec4 FragColor;

uniform vec3 pColor;

void main(void)
{
    FragColor = vec4(pColor, 1.0f);
}
