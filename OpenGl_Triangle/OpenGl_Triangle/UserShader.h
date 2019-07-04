//
//  UserShader.h
//  OpenGL_Texture
//
//  Created by clonekim on 21/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#ifndef UserShader_h
#define UserShader_h

@interface UserShader : NSObject

@property (nonatomic, assign) GLKMatrix4 modelMatrix;
@property (nonatomic, assign) GLKMatrix4 viewMatrix;
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;

- (id) init;
- (id) initWithVertexShaderPath:(NSString *)vsPath FragmentShaderPath:(NSString *)fsPath;

- (void) useProgram;
- (void) useMaterialAmbient:(GLKVector3)ambient Diffuse:(GLKVector3)diffuse Specular:(GLKVector3)specular Shininess:(float)shininess;
- (void) useTexture:(GLubyte *)texture Width:(GLsizei)width Height:(GLsizei)height;
- (void) useNormalMap:(GLubyte *)normalMap Width:(GLsizei)width Height:(GLsizei)height;
- (void) useAO:(GLubyte *)ao Width:(GLsizei)width Height:(GLsizei)height;

-(void)SetUniform1f:(const GLchar *)name WithValue:(float)value;
-(void)SetUniform2f:(const GLchar *)name WithValueX:(float)value Y:(float)value2;
-(void)SetUniform3f:(const GLchar *)name WithValueX:(float)value Y:(float)value2 Z:(float)value3;
-(void)SetUniform1i:(const GLchar *)name WithValue:(int)value;
-(void)SetUniform2i:(const GLchar *)name WithValueX:(int)value Y:(int)value2;
-(void)SetUniform3i:(const GLchar *)name WithValueX:(int)value Y:(int)value2 Z:(int)value3;
-(void)SetUniformMat2:(const GLchar *)name WithMatrix:(GLKMatrix2)value;
-(void)SetUniformMat3:(const GLchar *)name WithMatrix:(GLKMatrix3)value;
-(void)SetUniformMat4:(const GLchar *)name WithMatrix:(GLKMatrix4)value;

@end


#endif /* UserShader_h */

