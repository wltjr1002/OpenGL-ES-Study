//
//  Temple.m
//  OpenGl_Triangle
//
//  Created by clonekim on 01/07/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Temple.h"

@implementation Temple
{
    bool _isTextureLoaded;
    struct Sprite _texture;
    struct Sprite _normalMap;
}

-(instancetype)initWithShader:(UserShader *)shader{
    self = [super initWithShader:shader Filename:@"/Users/clonekim/Desktop/OpenGLProjects/OpenGLStudy/OpenGl_Triangle/OpenGl_Triangle/Model/temple.obj"];
    _isTextureLoaded = false;
    return self;
}

-(void)render
{
    _shader.modelMatrix = [self modelMatrix];
    if(!_isTextureLoaded)
    {
        [self SaveSpriteData:@"/Users/clonekim/Desktop/OpenGLProjects/OpenGLStudy/OpenGl_Triangle/OpenGl_Triangle/Texture/Japanese_Temple_Paint2_Japanese_Shrine_Mat_AlbedoTransparency.png" Sprite:&_texture];
        [self SaveSpriteData:@"/Users/clonekim/Desktop/OpenGLProjects/OpenGLStudy/OpenGl_Triangle/OpenGl_Triangle/Texture/Japanese_Temple_Paint2_Japanese_Shrine_Mat_AO.png" Sprite:&_normalMap];
        _isTextureLoaded = true;
    }
    [_shader useProgram];
    [_shader useTexture:_texture.data Width:_texture.width Height:_texture.height];
    [_shader useNormalMap:_normalMap.data Width:_normalMap.width Height:_normalMap.height];
    [_shader useMaterialAmbient:GLKVector3Make(1.0f, 1.0f, 1.0f) Diffuse:GLKVector3Make(0.64f, 0.64f, 0.64f) Specular:GLKVector3Make(0.5f, 0.5f, 0.5f) Shininess:0.75f];
    [self draw];
}

- (void)SaveSpriteData:(NSString *)fileName Sprite:(struct Sprite*)sprite{
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
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // Copy image data into the context
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    sprite->width = width;
    sprite->height = height;
    sprite->data = spriteData;
}

@end
