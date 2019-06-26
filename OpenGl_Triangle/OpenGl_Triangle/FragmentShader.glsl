#version 300 es
precision mediump float;

struct Light{
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
};
uniform Light u_Light;

/*
struct Material{
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
}
uniform Material u_Material;
*/

uniform highp float u_SpecularIntensity;
uniform highp float u_Shininess;

uniform sampler2D u_texture;

in vec3 fcolor;
in vec3 fnormal;
in vec3 fposition;
in vec2 ftexCoord;

out vec4 out_color;

void main(){
    lowp vec3 LightDirection = u_Light.Direction;
    //LightDirection = fposition;
    //Ambient
    lowp vec4 AmbientColor = vec4(u_Light.Color, 1.0) * u_Light.AmbientIntensity;
    //Diffuse
    lowp vec3 Normal = normalize(fnormal);
    lowp float DiffuseFactor = max(-dot(Normal, LightDirection), 0.0);
    lowp vec4 DiffuseColor = vec4(u_Light.Color, 1.0) * u_Light.DiffuseIntensity * DiffuseFactor;
    //Specular
    lowp vec3 Eye = normalize(fposition);
    lowp vec3 Reflection = reflect(LightDirection, Normal);
    lowp float SpecularFactor = pow(max(0.0, -dot(Reflection,Eye)),u_Shininess);
    lowp vec4 SpecularColor = vec4(u_Light.Color * u_SpecularIntensity * SpecularFactor, 1.0);
    
    out_color = vec4(fcolor, 1.0) * (AmbientColor + DiffuseColor + SpecularColor);
}
