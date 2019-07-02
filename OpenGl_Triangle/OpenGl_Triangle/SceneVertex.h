//
//  SceneVertex.h
//  OpenGl_Triangle
//
//  Created by clonekim on 21/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//
#import <GLKit/GLKit.h>

#ifndef SceneVertex_h
#define SceneVertex_h

struct Sprite{
    GLsizei width;
    GLsizei height;
    GLubyte *data;
};

struct Material
{
    GLKVector3 ambient;
    GLKVector3 diffuse;
    GLKVector3 specular;
    float shininess;
};

typedef struct{
    GLKVector3 positionCoords;
    GLKVector3 colorCoords;
    GLKVector2 textureCoords;
    GLKVector3 normal;
    GLKVector3 tangent;
    GLKVector3 bitangent;
}
SceneVertex;

#endif /* SceneVertex_h */
