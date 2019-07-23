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
#import "ObjectModel.h"
#import "Object/Temple.h"
#import "chCamera.h"
#import "Camera.h"


@interface ViewController ()

@end


@implementation ViewController
{
    UserShader * _shader;
    ObjectModel * _objModel;
    
    chCamera * _camera;
    Camera * _camera2;
    GLKMatrix4 viewMatrix;
    
    __weak IBOutlet UIButton *Button_Right;
    
    int lastPosX;
    int lastPosY;
}

- (IBAction)leftPressed:(id)sender {
    [_camera2 MovePositionFront:0 Right:-1];
}
- (IBAction)rightPressed:(id)sender {
    [_camera2 MovePositionFront:0 Right:1];
}
- (IBAction)upPressed:(id)sender {
    [_camera2 MovePositionFront:1 Right:0];
}
- (IBAction)downPressed:(id)sender {
    [_camera2 MovePositionFront:-1 Right:0];
}

- (void) setupSceneWithView:(GLKView *)view
{
    //OpenGL setting
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    //shader setting
    _shader = [[UserShader alloc] initWithVertexShaderPath:@"VertexShader.glsl" FragmentShaderPath:@"FragmentShader.glsl"];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width/self.view.bounds.size.height, 1, 300);
    
    //camera setting
    _camera2 = [[Camera alloc] initWithPosition:GLKVector3Make(0, 10, 30)];
    
    //scene setting
    _objModel = [[Temple alloc] initWithShader:_shader];
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
    
    glClearColor(220.0/255.0, 220.0/255.0, 220.0/255.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_camera GetViewMatrix: &viewMatrix];
    _shader.viewMatrix = viewMatrix;
    _shader.viewMatrix = [_camera2 ViewMatrix];
        
    [_objModel render];
}

-(void)update{
    //[_objModel updateWithDelta:self.timeSinceLastUpdate];
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
    
    //[_camera ProcessMouseMovement:false Xoffset:xoffset Yoffset:yoffset];
    [_camera2 RotateYaw:-xoffset Pitch:-yoffset];
    
}
// Input Methods
@end
