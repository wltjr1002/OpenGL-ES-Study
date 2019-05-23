#version 300 es
precision mediump float;

struct Light{
    lowp vec3 Color;
    lowp float AmbientIntensity;
};
uniform Light u_Light;

in vec3 fcolor;

out vec4 out_color;

void main(){
    
    //Ambient
    lowp vec4 AmbientColor = vec4(u_Light.Color, 1.0) * u_Light.AmbientIntensity;
    
    out_color = vec4(fcolor, 1.0f) * (AmbientColor);
}
