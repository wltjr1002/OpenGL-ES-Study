//
//  UserShader.m
//  OpenGL_Texture
//
//  Created by clonekim on 21/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "UserShader.h"

@implementation UserShader
{
    GLuint programHandle;
    GLuint modelMatrix_u;
    GLuint viewMatrix_u;
    GLuint projectionMatrix_u;
    GLuint lightColor_u;
    GLuint lightAmbientIntensity_u;
    GLuint lightDiffuseIntensity_u;
    GLuint lightSpecularIntensity_u;
    GLuint Shininess_u;
    GLuint lightDirection_u;
    GLuint texture_u;
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
    glUniformMatrix4fv(modelMatrix_u, 1, 0, self.modelMatrix.m);
    glUniformMatrix4fv(viewMatrix_u, 1, 0, self.viewMatrix.m);
    glUniformMatrix4fv(projectionMatrix_u, 1, 0, self.projectionMatrix.m);
    
    glUniform3f(lightColor_u, 1, 1, 1);
    glUniform1f(lightAmbientIntensity_u, 0.5);
    glUniform1f(lightDiffuseIntensity_u, 0.5);
    glUniform1f(lightSpecularIntensity_u, 3.0);
    glUniform1f(Shininess_u, 128.0);
    GLKVector3 lightDirection = GLKVector3Normalize(GLKVector3Make(1, -2, -1));
    glUniform3f(lightDirection_u, lightDirection.x, lightDirection.y, lightDirection.z);
}

- (void) useProgramWithTexture:(NSString *)textureName
{
    // Other Settings
    [self useProgram];
    
    //Texture Settings
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_MIRRORED_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    GLuint _texture = [self setupTexture:textureName];
    texture_u = glGetUniformLocation(programHandle, "u_texture");
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(texture_u, 0);
}

- (GLuint)setupTexture:(NSString *)fileName {
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    GLsizei width = (GLsizei)CGImageGetWidth(spriteImage);
    GLsizei height = (GLsizei)CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    
    free(spriteData);
    return texName;
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
    
    self.modelMatrix = GLKMatrix4Identity;
    modelMatrix_u = glGetUniformLocation(programHandle, "u_ModelMatrix");
    viewMatrix_u = glGetUniformLocation(programHandle, "u_ViewMatrix");
    projectionMatrix_u = glGetUniformLocation(programHandle, "u_ProjectionMatrix");
    lightColor_u = glGetUniformLocation(programHandle, "u_Light.Color");
    lightAmbientIntensity_u = glGetUniformLocation(programHandle, "u_Light.AmbientIntensity");
    lightDiffuseIntensity_u = glGetUniformLocation(programHandle, "u_Light.DiffuseIntensity");
    lightSpecularIntensity_u = glGetUniformLocation(programHandle, "u_SpecularIntensity");
    Shininess_u = glGetUniformLocation(programHandle, "u_Shininess");
    lightDirection_u = glGetUniformLocation(programHandle, "u_Light.Direction");
    
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
