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
    GLuint _vertexBuffer;
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

- (void) setBuffer
{
    // Set Vertex Buffer
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
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
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, positionCoords));
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (const GLvoid *)offsetof(SceneVertex, colorCoords));
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
