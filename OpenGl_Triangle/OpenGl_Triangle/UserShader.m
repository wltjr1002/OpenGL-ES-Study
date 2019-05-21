//
//  UserShader.m
//  OpenGL_Texture
//
//  Created by clonekim on 21/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "UserShader.h"
#import <GLKit/GLKit.h>

@implementation UserShader
{
    GLuint programHandle;
}

- (id) init
{
    return nil;
}

- (id) initWithVertexShaderPath:(NSString *)vsPath FragmentShaderPath:(NSString *)fsPath
{
    self = [super init];
    [self prepareProgramWithVertexShader:vsPath FragmentShader:fsPath];
    return self;
}

- (void) useProgram
{
    glUseProgram(programHandle);
}

- (void)prepareProgramWithVertexShader:(NSString *)vsPath FragmentShader:(NSString *)fsPath
{
    GLuint vertexShaderHandle = [self CompileShaderPath:vsPath WithType:GL_VERTEX_SHADER];
    GLuint fragmentShaderHandle = [self CompileShaderPath:fsPath WithType:GL_FRAGMENT_SHADER];
    
    programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShaderHandle);
    glAttachShader(programHandle, fragmentShaderHandle);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE)
    {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
}

- (GLuint)CompileShaderPath:(NSString *)shaderPath WithType:(GLenum)shaderType
{
    NSString* shaderFilePath = [[NSBundle mainBundle] pathForResource:shaderPath ofType:nil];
    NSError* error;
    NSString* shaderContent = [NSString stringWithContentsOfFile:shaderFilePath encoding:NSUTF8StringEncoding error:&error];
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char * shaderContentUTF8 = [shaderContent UTF8String];
    int shaderContentLength = (int)[shaderContent length];
    glShaderSource(shaderHandle, 1, &shaderContentUTF8, &shaderContentLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}

@end
