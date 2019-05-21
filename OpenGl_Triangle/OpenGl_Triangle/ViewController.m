//
//  ViewController.m
//  OpenGL_Texture
//
//  Created by clonekim on 10/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "ViewController.h"
#import "UserShader.h"
#import <OpenGLES/ES3/gl.h>


@interface ViewController ()

@end

@implementation ViewController{
    GLuint _VAO;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    UserShader* _shader;
}

typedef struct{
    GLKVector3 positionCoords;
    GLKVector3 colorCoords;
}
SceneVertex;

static const SceneVertex vertices[] =
{
    {{1.0f, 1.0f, 0}, {0,1.0f,0}},
    {{-1.0f, 1.0f, 0}, {0,0,1.0f}},
    {{0, 0, 0}, {1.0f,0,0}},
    {{-1.0f, -1.0f, 0}, {0,0,1.0f}},
    {{1.0f, -1.0f, 0}, {0,1.0f,0}},
    {{0, 0, 0}, {1.0f,0,0}}
};

static const int indices[] =
{
    0, 1, 2,
    3, 4, 5
};

- (void) setBuffer
{
    
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    // Set Vertex Buffer
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    // Set Element Buffer
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    // Set Vertex Arrtibute Array
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, positionCoords));
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, colorCoords));
    
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
}


- (void) setShader
{
    _shader = [[UserShader alloc] initWithVertexShaderPath:@"VertexShader.glsl" FragmentShaderPath:@"FragmentShader.glsl"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:view.context];
    
    [self setShader];
    [self setBuffer];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClearColor(0, 144.0/255.0, 55.0/255.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_shader useProgram];
    
    /*
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL);
    glDrawElements(GL_TRIANGLES, _indexcount, GL_UNSIGNED_BYTE, 0);
     */
    
    glBindVertexArray(_VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    glBindVertexArray(0);
}

@end
