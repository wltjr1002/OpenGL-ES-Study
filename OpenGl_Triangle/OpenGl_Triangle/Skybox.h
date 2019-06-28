//
//  Skybox.h
//  OpenGl_Triangle
//
//  Created by clonekim on 27/06/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>
#import "UserShader.h"

NS_ASSUME_NONNULL_BEGIN

@interface Skybox : NSObject

@property (nonatomic, assign) GLKVector3 position;

-(instancetype)initWithShader:(UserShader *) shader;

-(void)render;

@end

NS_ASSUME_NONNULL_END
