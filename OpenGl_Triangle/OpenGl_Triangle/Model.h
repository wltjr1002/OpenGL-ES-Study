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
{
    char * _name;
    GLuint _VAO;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    unsigned int _vertexCount;
    unsigned int _indexCount;
    UserShader * _shader;
}



@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic) float rotationX;
@property (nonatomic) float rotationY;
@property (nonatomic) float rotationZ;
@property (nonatomic) float scale;

-(instancetype) initWithName:(char *)name shader:(UserShader *)shader vertices:(SceneVertex *)vertices vertexCount:(unsigned int)count indices:(int *)indices indexCount:(unsigned int)indexCount;
-(instancetype) initWithName:(char *)name shader:(UserShader *)shader vertices:(SceneVertex *)vertices vertexCount:(unsigned int)count;

-(GLKMatrix4)modelMatrix;

-(void)render;
-(void)renderWithParentModelMatrix:(GLKMatrix4)parentModelMatrix;
-(void)renderWithTexture:(NSString *)filename;
-(void)renderWithMaterialKa:(GLKVector3)ambient Kd:(GLKVector3)diffuse Ks:(GLKVector3)specular Shininess:(float)shininess;
-(void)updateWithDelta:(NSTimeInterval)dt;

-(void)draw;

@end

NS_ASSUME_NONNULL_END
