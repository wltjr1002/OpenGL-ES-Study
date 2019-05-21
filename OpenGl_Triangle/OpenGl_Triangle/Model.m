//
//  Model.m
//  OpenGl_Triangle
//
//  Created by clonekim on 21/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Model.h"

@implementation Model
{
    char * _name;
    GLuint _VAO;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    unsigned int _vertexCount;
    unsigned int _indexCount;
    UserShader * _shader;
}

-(instancetype)initWithName:(char *)name shader:(UserShader *)shader vertices:(SceneVertex *)vertices vertexCount:(unsigned int)vertexCount indices:(int *)indices indexCount:(unsigned int)indexCount
{
    if(self = [super init])
    {
        _name = name;
        _vertexCount = vertexCount;
        _indexCount = indexCount;
        _shader = shader;
    }
    
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    // Set Vertex Buffer
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(SceneVertex), vertices, GL_STATIC_DRAW);
    
    // Set Element Buffer
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(int), indices, GL_STATIC_DRAW);
    
    // Set Vertex Arrtibute Array
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, positionCoords));
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, colorCoords));
    
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    return self;
}

-(void)render
{
    [_shader useProgram];
    
    glBindVertexArray(_VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    glBindVertexArray(0);
}


@end
