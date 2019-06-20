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
typedef struct{
    GLKVector3 positionCoords;
    GLKVector3 colorCoords;
    GLKVector2 textureCoords;
    GLKVector3 normal;
}
SceneVertex;

#endif /* SceneVertex_h */
