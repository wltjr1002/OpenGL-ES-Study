#version 300 es
precision mediump float;

struct Light{
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
};
uniform Light u_Light;

in vec3 fcolor;
in vec3 fnormal;

out vec4 out_color;

void main(){
    
    //Ambient
    lowp vec4 AmbientColor = vec4(u_Light.Color, 1.0) * u_Light.AmbientIntensity;
    //Diffuse
    lowp vec3 Normal = normalize(fnormal);
    lowp float DiffuseFactor = max(-dot(Normal, u_Light.Direction), 0.0);
    lowp vec4 DiffuseColor = vec4(u_Light.Color, 1.0) * u_Light.DiffuseIntensity * DiffuseFactor;
    
    out_color = vec4(fcolor, 1.0f) * (AmbientColor + DiffuseColor);
}
