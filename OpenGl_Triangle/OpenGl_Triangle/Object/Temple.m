//
//  Temple.m
//  OpenGl_Triangle
//
//  Created by clonekim on 01/07/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Temple.h"

@implementation Temple
{
    bool _isTextureLoaded;
}

-(instancetype)initWithShader:(UserShader *)shader{
    self = [super initWithShader:shader Filename:@"/Users/clonekim/Desktop/OpenGLProjects/OpenGLStudy/OpenGl_Triangle/OpenGl_Triangle/Model/temple.obj"];
    _isTextureLoaded = false;
    return self;
}

-(void)render
{
    _shader.modelMatrix = [self modelMatrix];
    if(_isTextureLoaded)
    {
        [_shader useProgram];
    }
    else
    {
        [_shader useProgramWithTexture:@"/Users/clonekim/Desktop/OpenGLProjects/OpenGLStudy/OpenGl_Triangle/OpenGl_Triangle/Texture/Japanese_Temple_Paint2_Japanese_Shrine_Mat_AlbedoTransparency.png"];
        _isTextureLoaded = true;
    }
    GLKVector3 ambient = GLKVector3Make(1.0f, 1.0f, 1.0f);
    GLKVector3 diffuse = GLKVector3Make(0.64f, 0.64f, 0.64f);
    GLKVector3 specular = GLKVector3Make(0.5f, 0.5f, 0.5f);
    float shininess = 0.75f;
    [_shader SetUniform3f:"u_Material.ambient" WithValueX:ambient.x Y:ambient.y Z:ambient.z];
    [_shader SetUniform3f:"u_Material.diffuse" WithValueX:diffuse.x Y:diffuse.y Z:diffuse.z];
    [_shader SetUniform3f:"u_Material.specular" WithValueX:specular.x Y:specular.y Z:specular.z];
    [_shader SetUniform1f:"u_Material.shininess" WithValue:shininess];
    [self draw];
}



@end
