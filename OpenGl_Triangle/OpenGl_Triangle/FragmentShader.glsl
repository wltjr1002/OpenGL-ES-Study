#version 300 es
precision mediump float;

struct Light{
    lowp vec3 Color;
    lowp vec3 Direction;
};
uniform Light u_Light;

struct Material{
    highp vec3 ambient;
    highp vec3 diffuse;
    highp vec3 specular;
    highp float shininess;
};
uniform Material u_Material;


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
    lowp vec4 AmbientColor = vec4(u_Material.ambient, 1.0) * vec4(u_Light.Color, 1.0);
    //Diffuse
    lowp vec3 Normal = normalize(fnormal);
    lowp float DiffuseFactor = max(-dot(Normal, LightDirection), 0.0);
    lowp vec4 DiffuseColor = vec4(u_Material.diffuse, 1.0) * vec4(u_Light.Color, 1.0) * DiffuseFactor;
    //Specular
    lowp vec3 Eye = normalize(fposition);
    lowp vec3 Reflection = reflect(LightDirection, Normal);
    lowp float SpecularFactor = pow(max(0.0, -dot(Reflection,Eye)),u_Material.shininess*128.0);
    lowp vec4 SpecularColor = vec4(u_Material.specular, 1.0) * vec4(u_Light.Color * SpecularFactor, 1.0);
    
    out_color = vec4(fcolor, 1.0) * (AmbientColor + DiffuseColor + SpecularColor);
}
