//
//  Model.h
//  OpenGl_Triangle
//
//  Created by clonekim on 21/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneVertex.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>
#import "UserShader.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

-(instancetype) initWithName:(char *)name shader:(UserShader *)shader vertices:(SceneVertex *)vertiecs vertexCount:(unsigned int)count indices:(int *)indices indexCount:(unsigned int)indexCount;

-(void)render;

@end

NS_ASSUME_NONNULL_END
