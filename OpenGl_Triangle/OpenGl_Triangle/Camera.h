//
//  Camera.h
//  OpenGl_Triangle
//
//  Created by clonekim on 03/07/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Camera : NSObject
{
    GLKVector3 Position;
    float Yaw;
    float Pitch;
}

-(instancetype)init;
-(instancetype)initWithPosition:(GLKVector3)position;

-(GLKMatrix4)ViewMatrix;

-(void)MovePositionFront:(float)dx Right:(float)dy;
-(void)RotateYaw:(float)dy Pitch:(float)dp;

@end

NS_ASSUME_NONNULL_END
