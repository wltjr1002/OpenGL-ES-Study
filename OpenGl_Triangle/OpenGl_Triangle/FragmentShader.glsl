#version 300 es
precision mediump float;

struct Light{
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
};
uniform Light u_Light;
uniform highp float u_SpecularIntensity;
uniform highp float u_Shininess;

in vec3 fcolor;
in vec3 fnormal;
in vec3 fposition;

out vec4 out_color;

void main(){
    
    //Ambient
    lowp vec4 AmbientColor = vec4(u_Light.Color, 1.0) * u_Light.AmbientIntensity;
    //Diffuse
    lowp vec3 Normal = normalize(fnormal);
    lowp float DiffuseFactor = max(-dot(Normal, u_Light.Direction), 0.0);
    lowp vec4 DiffuseColor = vec4(u_Light.Color, 1.0) * u_Light.DiffuseIntensity * DiffuseFactor;
    //Specular
    lowp vec3 Eye = normalize(fposition);
    lowp vec3 Reflection = reflect(u_Light.Direction, Normal);
    lowp float SpecularFactor = pow(max(0.0, -dot(Reflection,Eye)),u_Shininess);
    lowp vec4 SpecularColor = vec4(u_Light.Color * u_SpecularIntensity * SpecularFactor, 1.0);
    
    out_color = vec4(fcolor, 1.0f) * (AmbientColor + DiffuseColor + SpecularColor);
}
