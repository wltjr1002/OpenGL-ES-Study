//
//  Camera.m
//  OpenGl_Triangle
//
//  Created by clonekim on 03/07/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Camera.h"

@implementation Camera
{
    GLKVector3 _upVector;
    GLKVector3 _frontVector;
    GLKVector3 _rightVector;
    float speed;
}

-(instancetype)init
{
    if(self = [self initWithPosition:GLKVector3Make(0, 0, 0)])
    {
        
    }
    return nil;
}
-(instancetype)initWithPosition:(GLKVector3)position
{
    if(self = [super init])
    {
        Position = position;
        Yaw = 90;
        Pitch = 0;
        speed = 0.15f;
        [self CalculateVectorsFromYawPitch];
    }
    return self;
}

-(GLKMatrix4)ViewMatrix
{
    GLKMatrix4 rotate, pos, view;
    
    GLKVector4 up = GLKVector4MakeWithVector3(_upVector, 0);
    GLKVector4 right = GLKVector4MakeWithVector3(_rightVector, 0);
    GLKVector4 dir = GLKVector4MakeWithVector3(GLKVector3Negate(_frontVector), 0);
    rotate = GLKMatrix4MakeWithRows(right, up, dir, GLKVector4Make(0, 0, 0, 1.0));
    
    float positionArray[] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -Position.x, -Position.y, -Position.z, 1};
    pos = GLKMatrix4MakeWithArray(positionArray);
    
    view = GLKMatrix4Multiply(rotate, pos);
    return view;
}

-(void)MovePositionFront:(float)dx Right:(float)dy
{
    GLKVector3 deltaPosition = GLKVector3Add(GLKVector3MultiplyScalar(_frontVector, dx), GLKVector3MultiplyScalar(_rightVector, dy));
    Position = GLKVector3Add(Position, deltaPosition);
}
-(void)RotateYaw:(float)dy Pitch:(float)dp
{
    Yaw += dy * speed;
    Pitch += dp * speed;
    Pitch = MAX(-89.9, MIN(89, Pitch));
    [self CalculateVectorsFromYawPitch];
}
-(void)CalculateVectorsFromYawPitch
{
    _upVector = GLKVector3Make(0, 1.0, 0);
    float yawRadian = GLKMathDegreesToRadians(Yaw);
    float pitchRadian = GLKMathDegreesToRadians(Pitch);
    float x = cos(pitchRadian) * cos(yawRadian);
    float y = sin(pitchRadian);
    float z = cos(pitchRadian) * sin(yawRadian);
    _frontVector = GLKVector3Normalize(GLKVector3Make(x, y, z));
    _rightVector = GLKVector3Normalize(GLKVector3CrossProduct(_frontVector, _upVector));
    _upVector = GLKVector3Normalize(GLKVector3CrossProduct(_rightVector, _frontVector));
}

@end
