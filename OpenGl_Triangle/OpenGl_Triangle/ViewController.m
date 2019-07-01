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


@interface ViewController ()

@end


@implementation ViewController
{
    UserShader * _shader;
    UserShader * _skyboxShader;
    ObjectModel * _objModel;
    
    chCamera * _camera;
    GLKMatrix4 viewMatrix;
    
    __weak IBOutlet UIButton *Button_Right;
    
    int lastPosX;
    int lastPosY;
}

- (IBAction)leftPressed:(id)sender {
    [_camera ProcessKeyboard:LEFT deltaTime:0.016f];
}
- (IBAction)rightPressed:(id)sender {
    [_camera ProcessKeyboard:RIGHT deltaTime:0.016f];
}
- (IBAction)upPressed:(id)sender {
    [_camera ProcessKeyboard:FORWARD deltaTime:0.01f];
}
- (IBAction)downPressed:(id)sender {
    [_camera ProcessKeyboard:BACKWARD deltaTime:0.01f];
}

- (void) setupSceneWithView:(GLKView *)view
{
    //shader setting
    _shader = [[UserShader alloc] initWithVertexShaderPath:@"VertexShader.glsl" FragmentShaderPath:@"FragmentShader.glsl"];
    GLKMatrix4 projectionMat = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width/self.view.bounds.size.height, 1, 300);
    _shader.projectionMatrix = projectionMat;
    
    //camera setting
    _camera = [[chCamera alloc] init];
    lastPosX = view.self.frame.size.width / 2;
    lastPosY = view.self.frame.size.height / 2;
    
    
    //scene setting
    _objModel = [[Temple alloc] initWithShader:_shader];
    
    _objModel.position = GLKVector3Make(0, -10, -50);
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
    
    glClearColor(200.0/255.0, 200.0/255.0, 200.0/255.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    [_camera GetViewMatrix: &viewMatrix];
    _shader.viewMatrix = viewMatrix;
        
    [_objModel render];
    
}

-(void)update{
    [_objModel updateWithDelta:self.timeSinceLastUpdate];
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
