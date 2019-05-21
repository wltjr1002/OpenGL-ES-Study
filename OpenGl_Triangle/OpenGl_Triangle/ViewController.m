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
#import "Square.h"


@interface ViewController ()

@end

@implementation ViewController
{
    UserShader * _shader;
    Square * _square;
}

- (void) setupScene
{
    _shader = [[UserShader alloc] initWithVertexShaderPath:@"VertexShader.glsl" FragmentShaderPath:@"FragmentShader.glsl"];
    _square = [[Square alloc] initWithShader:_shader];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:view.context];
    
    [self setupScene];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClearColor(0, 144.0/255.0, 55.0/255.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_square render];
}

@end
