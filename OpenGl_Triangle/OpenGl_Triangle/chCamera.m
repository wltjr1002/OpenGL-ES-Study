//
//  chCamera.m
//  chOpenGLES
//
//  Created by chLEE on 16/05/2019.
//  Copyright © 2019 chLEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "chCamera.h"

// class extension for writing readonly variables
@interface chCamera()
@property (readwrite) GLKVector3 Position;
@property (readwrite) GLKQuaternion Orientation;
@property (readwrite) GLKVector3 Front;
@property (readwrite) GLKVector3 Right;
@property (readwrite) float Zoom;
@end

@implementation chCamera
{
    float RightAngle;
    float UpAngle;
    
    float MovementSpeed;
    float MouseSensitivity;
}

-(id) init
{
    return [self initWithPosition:GLKVector3Make(0, 0, 0)];
}

-(id) initWithPosition:(GLKVector3)pos
{
    self = [super init];
    
    if(self)
    {
        self.Position = pos;
        self.Orientation = GLKQuaternionMake(0, 0, -1, 0);
        self.Front = GLKVector3Make(0, 0, -1);
        self.Right = GLKVector3Make(1, 0, 0);
        self.Zoom = 45.0f;
        
        RightAngle = 0.f;
        UpAngle = 0.f;
        
        MovementSpeed = 10.0f;
        MouseSensitivity = 0.1f;
        [self updateCameraVectors];
    }
    
    return self;
}

-(void) ProcessKeyboard:(enum Camera_Movement)direction deltaTime:(float)dt
{
    float velocity = MovementSpeed * dt;
    
    if (direction == FORWARD)
        self.Position = GLKVector3Add(self.Position, GLKVector3MultiplyScalar(self.Front, velocity));
    
    if (direction == BACKWARD)
        self.Position = GLKVector3Add(self.Position, GLKVector3MultiplyScalar(self.Front, velocity));
    
    if (direction == LEFT)
        self.Position = GLKVector3Subtract(self.Position, GLKVector3MultiplyScalar(self.Right, velocity));
    
    if (direction == RIGHT)
        self.Position = GLKVector3Add(self.Position, GLKVector3MultiplyScalar(self.Right, velocity));
}

-(void) ProcessMouseMovement:(bool)preventPitch Xoffset:(float)xo Yoffset:(float)yo
{
    xo *= MouseSensitivity;
    yo *= MouseSensitivity;
    
    RightAngle += xo;
    UpAngle += yo;
    
    [self updateCameraVectors];
}

-(void) ProcessMouseScroll:(float)yOffset
{
    if(self.Zoom >= 1.f && self.Zoom <= 45.f)
        self.Zoom -= yOffset;
    
    if(self.Zoom <= 1.f) self.Zoom = 1.f;
    if(self.Zoom >= 45.f) self.Zoom = 45.f;
}

-(void) GetViewMatrix:(GLKMatrix4 *)v
{
    *v = GLKMatrix4MakeWithQuaternion(GLKQuaternionConjugate(self.Orientation));
    (*v).m30 = -((*v).m00 * self.Position.x + (*v).m10 * self.Position.y + (*v).m20 * self.Position.z);
    (*v).m31 = -((*v).m01 * self.Position.x + (*v).m11 * self.Position.y + (*v).m21 * self.Position.z);
    (*v).m32 = -((*v).m02 * self.Position.x + (*v).m12 * self.Position.y + (*v).m22 * self.Position.z);
    
}

-(void) updateCameraVectors
{
    // Yaw
    GLKQuaternion aroundY = GLKQuaternionMakeWithAngleAndAxis(GLKMathDegreesToRadians(-RightAngle), 0, 1, 0);
    
    // Pitch
    GLKQuaternion aroundX = GLKQuaternionMakeWithAngleAndAxis(GLKMathDegreesToRadians(UpAngle), 1, 0, 0);
    
    // Construct Quaternion Orientation
    self.Orientation = GLKQuaternionMultiply(aroundY, aroundX);
    
    // Prepare Front and Right Vector of eye space
    GLKQuaternion qF = GLKQuaternionMultiply(GLKQuaternionMultiply(self.Orientation, GLKQuaternionMake(0, 0, -1, 0)), GLKQuaternionConjugate(self.Orientation));
    self.Front = GLKVector3Make(qF.x, qF.y, qF.z);
    self.Right = GLKVector3CrossProduct(self.Front, GLKVector3Make(0, 1, 0));
}

@end
