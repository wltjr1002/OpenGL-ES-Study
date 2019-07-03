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
    GLuint lightDirection_u;
    
    GLubyte* _texture;
    GLubyte* _normalMap;
    GLubyte* _AO;
}

- (id) init
{
    return nil;
}

- (id) initWithVertexShaderPath:(NSString *)vsPath FragmentShaderPath:(NSString *)fsPath
{
    if(self = [super init])
    {
        [self prepareProgramWithVertexShader:vsPath FragmentShader:fsPath];
    }
    return self;
}

- (void) useProgram
{
    glUseProgram(programHandle);
    glUniformMatrix4fv(modelMatrix_u, 1, 0, self.modelMatrix.m);
    glUniformMatrix4fv(viewMatrix_u, 1, 0, self.viewMatrix.m);
    glUniformMatrix4fv(projectionMatrix_u, 1, 0, self.projectionMatrix.m);
    
    glUniform3f(lightColor_u, 0.9f, 0.9f, 0.9f);
    GLKVector3 lightDirection = GLKVector3Normalize(GLKVector3Make(2, -1, -3));
    glUniform3f(lightDirection_u, lightDirection.x, lightDirection.y, lightDirection.z);
    
    [self SetUniform1i:"u_texture" WithValue:0];
    [self SetUniform1i:"u_normalMap" WithValue:1];
    [self SetUniform1i:"u_AO" WithValue:2];
}
- (void) useMaterialAmbient:(GLKVector3)ambient Diffuse:(GLKVector3)diffuse Specular:(GLKVector3)specular Shininess:(float)shininess
{
    [self SetUniform3f:"u_Material.ambient" WithValueX:ambient.x Y:ambient.y Z:ambient.z];
    [self SetUniform3f:"u_Material.diffuse" WithValueX:diffuse.x Y:diffuse.y Z:diffuse.z];
    [self SetUniform3f:"u_Material.specular" WithValueX:specular.x Y:specular.y Z:specular.z];
    [self SetUniform1f:"u_Material.shininess" WithValue:shininess];
}

- (void) useTexture:(GLubyte *)texture Width:(GLsizei)width Height:(GLsizei)height
{
    if(_texture == texture) return;
    else _texture = texture;
    // set active texture 0(sprite)
    glActiveTexture(GL_TEXTURE0);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    // Bind texture into GL_TEXTURE_2D
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, texture);
    glGenerateMipmap(GL_TEXTURE_2D);
    
    
}

-(void) useNormalMap:(GLubyte *)normalMap Width:(GLsizei)width Height:(GLsizei)height
{
    if(_normalMap==normalMap) return;
    else _normalMap = normalMap;
    //set active texture 1(normalMap)
    glActiveTexture(GL_TEXTURE1);
    //set texture parameters;
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    //bind and copy data
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, normalMap);
    glGenerateMipmap(GL_TEXTURE_2D);
    
}

-(void) useAO:(GLubyte *)ao Width:(GLsizei)width Height:(GLsizei)height
{
    if(_AO==ao) return;
    else _AO = ao;
    //set active texture 1(normalMap)
    glActiveTexture(GL_TEXTURE2);
    //set texture parameters;
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    //bind and copy data
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, ao);
    glGenerateMipmap(GL_TEXTURE_2D);
    
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

-(void)SetUniform1f:(const GLchar *)name WithValue:(float)value{
    GLuint uniform =  glGetUniformLocation(programHandle, name);
    glUniform1f(uniform, value);
}
-(void)SetUniform2f:(const GLchar *)name WithValueX:(float)value Y:(float)value2{
    GLuint uniform =  glGetUniformLocation(programHandle, name);
    glUniform2f(uniform, value, value2);
}
-(void)SetUniform3f:(const GLchar *)name WithValueX:(float)value Y:(float)value2 Z:(float)value3{
    GLuint uniform =  glGetUniformLocation(programHandle, name);
    glUniform3f(uniform, value, value2, value3);
}
-(void)SetUniform1i:(const GLchar *)name WithValue:(int)value{
    GLuint uniform =  glGetUniformLocation(programHandle, name);
    glUniform1i(uniform, value);
}
-(void)SetUniform2i:(const GLchar *)name WithValueX:(int)value Y:(int)value2{
    GLuint uniform =  glGetUniformLocation(programHandle, name);
    glUniform2i(uniform, value, value2);
}
-(void)SetUniform3i:(const GLchar *)name WithValueX:(int)value Y:(int)value2 Z:(int)value3{
    GLuint uniform =  glGetUniformLocation(programHandle, name);
    glUniform3i(uniform, value, value2, value3);
}
-(void)SetUniformMat2:(const GLchar *)name WithMatrix:(const GLfloat *)value{
    GLuint uniform =  glGetUniformLocation(programHandle, name);
    glUniformMatrix2fv(uniform, 1, 0, value);
}
-(void)SetUniformMat3:(const GLchar *)name WithMatrix:(const GLfloat *)value{
    GLuint uniform =  glGetUniformLocation(programHandle, name);
    glUniformMatrix3fv(uniform, 1, 0, value);
}
-(void)SetUniformMat4:(const GLchar *)name WithMatrix:(const GLfloat *)value{
    GLuint uniform =  glGetUniformLocation(programHandle, name);
    glUniformMatrix4fv(uniform, 1, 0, value);
}

@end
