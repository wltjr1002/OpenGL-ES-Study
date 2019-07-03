//
//  chCamera.h
//  chOpenGLES
//
//  Created by chLEE on 16/05/2019.
//  Copyright © 2019 chLEE. All rights reserved.
//

#ifndef chCamera_h
#define chCamera_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKMath.h>


@interface chCamera : NSObject

-(id) init;
-(id) initWithPosition:(GLKVector3)pos;

enum Camera_Movement
{
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT
};

@property (readwrite) GLKVector3 Position;
@property (readwrite) GLKQuaternion Orientation;
@property (readonly) GLKVector3 Front;
@property (readonly) GLKVector3 Right;
@property (readonly) float Zoom;

- (void) ProcessKeyboard:(enum Camera_Movement)direction deltaTime:(float)dt;
- (void) ProcessMouseMovement:(bool)preventPitch Xoffset:(float)xo Yoffset:(float)yo;
- (void) ProcessMouseScroll:(float)yOffset;
- (void) RotateAroundYaxis:(float)degree;
- (void) GetViewMatrix:(GLKMatrix4*) View;


@end



#endif /* chCamera_h */
