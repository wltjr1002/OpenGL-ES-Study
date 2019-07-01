//
//  Temple.m
//  OpenGl_Triangle
//
//  Created by clonekim on 01/07/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Temple.h"

@implementation Temple

-(instancetype)initWithShader:(UserShader *)shader{
    self = [super initWithShader:shader Filename:@"/Users/clonekim/Desktop/OpenGLProjects/OpenGLStudy/OpenGl_Triangle/OpenGl_Triangle/Model/temple.obj"];
    return self;
}

-(void)render
{
    _shader.modelMatrix = [self modelMatrix];
    [_shader useProgram];
    GLKVector3 ambient = GLKVector3Make(0.02f, 0.02f, 0.02f);
    GLKVector3 diffuse = GLKVector3Make(0.01f, 0.01f, 0.01f);
    GLKVector3 specular = GLKVector3Make(0.4f, 0.4f, 0.4f);
    float shininess = 0.078f;
    [_shader SetUniform3f:"u_Material.ambient" WithValueX:ambient.x Y:ambient.y Z:ambient.z];
    [_shader SetUniform3f:"u_Material.diffuse" WithValueX:diffuse.x Y:diffuse.y Z:diffuse.z];
    [_shader SetUniform3f:"u_Material.specular" WithValueX:specular.x Y:specular.y Z:specular.z];
    [_shader SetUniform1f:"u_Material.shininess" WithValue:shininess];
    [self draw];
}

@end
