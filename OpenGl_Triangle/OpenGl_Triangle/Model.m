//
//  Model.m
//  OpenGl_Triangle
//
//  Created by clonekim on 21/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Model.h"


@implementation Model
    
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

-(void)renderWithMaterialKa:(GLKVector3)ambient Kd:(GLKVector3)diffuse Ks:(GLKVector3)specular Shininess:(float)shininess
{
    _shader.modelMatrix = [self modelMatrix];
    [_shader useProgram];
    [_shader SetUniform3f:"u_Material.ambient" WithValueX:ambient.x Y:ambient.y Z:ambient.z];
    [_shader SetUniform3f:"u_Material.diffuse" WithValueX:diffuse.x Y:diffuse.y Z:diffuse.z];
    [_shader SetUniform3f:"u_Material.specular" WithValueX:specular.x Y:specular.y Z:specular.z];
    [_shader SetUniform1f:"u_Material.shininess" WithValue:shininess];
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

