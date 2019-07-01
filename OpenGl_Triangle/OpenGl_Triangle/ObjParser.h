//
//  ObjParser.h
//  OpenGl_Triangle
//
//  Created by clonekim on 24/06/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneVertex.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjParser : NSObject


struct Vertex{
    GLKVector3 vertexPosition;
    int referenceCount;
};

struct Material
{
    GLKVector3 ambient;
    GLKVector3 diffuse;
    GLKVector3 specular;
    float shininess;
};

-(instancetype)initWithFilename:(NSString *)filename;

-(SceneVertex *)sceneVertices;
-(int)vertexCount;

@end

NS_ASSUME_NONNULL_END
