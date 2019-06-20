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
#import "Cube.h"
#import "chCamera.h"


@interface ViewController ()

@end

@implementation ViewController
{
    UserShader * _shader;
    Cube * _cube;
    Cube * _cube2;
    Cube * _cube3;
    Cube * _cube4;
    Cube * _cube5;
    Cube * _cube6;
    
    chCamera * _camera;
    GLKMatrix4 viewMatrix;
    
    int lastPosX;
    int lastPosY;
}

- (void) setupSceneWithView:(GLKView *)view
{
    //shader setting
    _shader = [[UserShader alloc] initWithVertexShaderPath:@"VertexShader.glsl" FragmentShaderPath:@"FragmentShader.glsl"];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width/self.view.bounds.size.height, 1, 150);
    
    //camera setting
    _camera = [[chCamera alloc] init];
    lastPosX = view.self.frame.size.width / 2;
    lastPosY = view.self.frame.size.height / 2;
    
    
    //scene setting
    _cube = [[Cube alloc] initWithShader:_shader];
    
    _cube.position = GLKVector3Make(0, 0, 5);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [EAGLContext setCurrentContext:view.context];
    
    [self setupSceneWithView:view];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClearColor(0, 144.0/255.0, 55.0/255.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    [_camera GetViewMatrix: &viewMatrix];
    _shader.viewMatrix = viewMatrix;
    
    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(0, 0, -15);
    [_cube renderWithParentModelMatrix:modelMatrix ViewMatrix:viewMatrix];
    [_cube2 renderWithParentModelMatrix:modelMatrix ViewMatrix:viewMatrix];
    [_cube3 renderWithParentModelMatrix:modelMatrix ViewMatrix:viewMatrix];
    [_cube4 renderWithParentModelMatrix:modelMatrix ViewMatrix:viewMatrix];
    [_cube5 renderWithParentModelMatrix:modelMatrix ViewMatrix:viewMatrix];
    [_cube6 renderWithParentModelMatrix:modelMatrix ViewMatrix:viewMatrix];
    
}

-(void)update{
    [_cube updateWithDelta:self.timeSinceLastUpdate];
    [_cube2 updateWithDelta:self.timeSinceLastUpdate];
    [_cube3 updateWithDelta:self.timeSinceLastUpdate];
    [_cube4 updateWithDelta:self.timeSinceLastUpdate];
    [_cube5 updateWithDelta:self.timeSinceLastUpdate];
    [_cube6 updateWithDelta:self.timeSinceLastUpdate];
    
}
// Input Methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Only use first touch for camera rotation
    id value = [[touches objectEnumerator] nextObject];
    CGPoint p = [value locationInView:self.view];
    lastPosX = p.x;
    lastPosY = p.y;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Only use first touch for camera rotation
    id value = [[touches objectEnumerator] nextObject];
    CGPoint p = [value locationInView:self.view];
    
    float xoffset = (float)(p.x - lastPosX);
    float yoffset = (float)(lastPosY - p.y);
    lastPosX = p.x;
    lastPosY = p.y;
    
    [_camera ProcessMouseMovement:false Xoffset:xoffset Yoffset:yoffset];
    
    //NSLog(@"touch X : %f Y : %f", p.x, p.y);
}
// Input Methods
@end
