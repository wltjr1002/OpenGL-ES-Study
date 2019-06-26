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
            self.position = GLKVector3Make(0, 0, 0);
            self.rotationX = 0;
            self.rotationY = 0;
            self.rotationZ = 0;
            self.scale = 1.0;
        }
        
        glGenVertexArrays(1, &_VAO);
        glBindVertexArray(_VAO);
        
        // Set Vertex Buffer
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, _vertexCount * sizeof(SceneVertex), vertices, GL_STATIC_DRAW);
        
        // Set Element Buffer
        glGenBuffers(1, &_indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indexCount * sizeof(int), indices, GL_STATIC_DRAW);
        
        // Set Vertex Arrtibute Array
        glEnableVertexAttribArray(0);
        glEnableVertexAttribArray(1);
        glEnableVertexAttribArray(2);
        glEnableVertexAttribArray(3);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, positionCoords));
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, colorCoords));
        glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, normal));
        glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, textureCoords));
        
        // Unbinding
        glBindVertexArray(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        return self;
    }

-(instancetype)initWithName:(char *)name shader:(UserShader *)shader vertices:(SceneVertex *)vertices vertexCount:(unsigned int)vertexCount
{
    if(self = [super init])
    {
        _name = name;
        _vertexCount = vertexCount;
        _indexCount = vertexCount;
        _shader = shader;
        self.position = GLKVector3Make(0, 0, 0);
        self.rotationX = 0;
        self.rotationY = 0;
        self.rotationZ = 0;
        self.scale = 1.0;
    }
    int* indices = malloc(sizeof(int)*_indexCount);
    for(int i=0;i<_indexCount;i++){indices[i]=i;}
    
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    // Set Vertex Buffer
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, _vertexCount * sizeof(SceneVertex), vertices, GL_STATIC_DRAW);
    
    // Set Element Buffer
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indexCount * sizeof(int), indices, GL_STATIC_DRAW);
    
    // Set Vertex Arrtibute Array
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, positionCoords));
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, colorCoords));
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, normal));
    glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, textureCoords));
    
    // Unbinding
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    return self;
}
    
-(GLKMatrix4)modelMatrix
    {
        GLKMatrix4 modelMatrix = GLKMatrix4Identity;
        modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationX, 1, 0, 0);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationY, 0, 1, 0);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationZ, 0, 0, 1);
        modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale, self.scale, self.scale);
        return modelMatrix;
    }
-(void)render
    {
        _shader.modelMatrix = [self modelMatrix];
        [_shader useProgram];
        [self draw];
    }
    
-(void)renderWithParentModelMatrix:(GLKMatrix4)parentModelMatrix
    {
        GLKMatrix4 modelMatrix = GLKMatrix4Multiply(parentModelMatrix, [self modelMatrix]);
        _shader.modelMatrix = modelMatrix;
        
        [_shader useProgram];
        [self draw];
    }
    
-(void) renderWithTexture:(NSString *)filename
    {
        _shader.modelMatrix = [self modelMatrix];
        [_shader useProgramWithTexture:filename];
        [self draw];
    }
    
-(void)draw
    {
        glBindVertexArray(_VAO);
        glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_INT, 0);
        glBindVertexArray(0);
    }
-(void)updateWithDelta:(NSTimeInterval)dt
    {
        
    }
    
    
    @end

