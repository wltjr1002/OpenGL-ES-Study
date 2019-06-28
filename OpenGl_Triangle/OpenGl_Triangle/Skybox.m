//
//  Skybox.m
//  OpenGl_Triangle
//
//  Created by clonekim on 27/06/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Skybox.h"

static float skyboxVertices[] = {
    // positions
    -1.0f,  1.0f, -1.0f,
    -1.0f, -1.0f, -1.0f,
    1.0f, -1.0f, -1.0f,
    1.0f, -1.0f, -1.0f,
    1.0f,  1.0f, -1.0f,
    -1.0f,  1.0f, -1.0f,
    
    -1.0f, -1.0f,  1.0f,
    -1.0f, -1.0f, -1.0f,
    -1.0f,  1.0f, -1.0f,
    -1.0f,  1.0f, -1.0f,
    -1.0f,  1.0f,  1.0f,
    -1.0f, -1.0f,  1.0f,
    
    1.0f, -1.0f, -1.0f,
    1.0f, -1.0f,  1.0f,
    1.0f,  1.0f,  1.0f,
    1.0f,  1.0f,  1.0f,
    1.0f,  1.0f, -1.0f,
    1.0f, -1.0f, -1.0f,
    
    -1.0f, -1.0f,  1.0f,
    -1.0f,  1.0f,  1.0f,
    1.0f,  1.0f,  1.0f,
    1.0f,  1.0f,  1.0f,
    1.0f, -1.0f,  1.0f,
    -1.0f, -1.0f,  1.0f,
    
    -1.0f,  1.0f, -1.0f,
    1.0f,  1.0f, -1.0f,
    1.0f,  1.0f,  1.0f,
    1.0f,  1.0f,  1.0f,
    -1.0f,  1.0f,  1.0f,
    -1.0f,  1.0f, -1.0f,
    
    -1.0f, -1.0f, -1.0f,
    -1.0f, -1.0f,  1.0f,
    1.0f, -1.0f, -1.0f,
    1.0f, -1.0f, -1.0f,
    -1.0f, -1.0f,  1.0f,
    1.0f, -1.0f,  1.0f
};

NSString * filenames[] = {@"lake1_rt.JPG", @"lake1_lf.JPG", @"lake1_up.JPG", @"lake1_dn.JPG", @"lake1_bk.JPG", @"lake1_ft.JPG"};


@implementation Skybox{
    GLuint _VAO;
    GLuint _VBO;
    UserShader * _shader;
}

-(instancetype)initWithShader:(UserShader *)shader
{
    if(self = [super init])
    {
        _shader = shader;
    }
    
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    // Set Vertex Buffer
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(skyboxVertices), &skyboxVertices, GL_STATIC_DRAW);
    
    // Set Vertex Arrtibute Array
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), (void *)0);
    
    // Unbinding
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    return self;
}

-(GLuint)SetSkybox
{
    GLuint skyboxTexture;
    glGenTextures(1, &skyboxTexture);
    glBindBuffer(GL_TEXTURE_CUBE_MAP, skyboxTexture);
    
    for(int i = 0; i<6; i++){
        [self SetSkyboxTexture:filenames[i] At:i];
    }
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE);
    
    return skyboxTexture;
}

-(void)render
{
    _shader.modelMatrix = GLKMatrix4Identity;
    [_shader useProgram];
    GLuint skyboxTexture = [self SetSkybox];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_CUBE_MAP, skyboxTexture);
    //[_shader SetUniform1i:"skybox" WithValue:0];
    [self draw];
}

-(void)draw
{
    glBindVertexArray(_VAO);
    glDrawArrays(GL_TRIANGLES, 0, 36);
    glBindVertexArray(0);
}

- (void)SetSkyboxTexture:(NSString *)fileName At:(int)position{
    // Load image
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage)
    {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // Set image context to copy data
    GLsizei width = (GLsizei)CGImageGetWidth(spriteImage);
    GLsizei height = (GLsizei)CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // Copy image data into the context
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + position, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
}
@end
