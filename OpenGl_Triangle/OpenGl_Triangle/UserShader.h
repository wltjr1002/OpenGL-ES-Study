//
//  UserShader.h
//  OpenGL_Texture
//
//  Created by clonekim on 21/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef UserShader_h
#define UserShader_h

@interface UserShader : NSObject

- (id) init;
- (id) initWithVertexShaderPath:(NSString *)vsPath FragmentShaderPath:(NSString *)fsPath;

- (void) useProgram;

@end


#endif /* UserShader_h */

