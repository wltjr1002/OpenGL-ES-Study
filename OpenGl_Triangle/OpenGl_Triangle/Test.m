//
//  Test.m
//  OpenGl_Triangle
//
//  Created by clonekim on 25/06/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Test.h"

@implementation Test

-(instancetype)initWithShader:(UserShader *)shader{
    if(self = [super initWithName:"cube" shader:shader vertices:vertices vertexCount:sizeof(vertices)/sizeof(vertices[0]) indices:indices indexCount:sizeof(indices)/sizeof(indices[0])])
    {
    }
    return self;
}
    
-(SceneVertex *)sceneVertexArrayWithVertex:(GLKVector3 *)vertices Texture:(GLKVector2 *)textures Normal:(GLKVector3 *)normals Indice:(int **)indices
    {
        int numVertex = sizeof(indices)/sizeof(indices[0])*3;
        SceneVertex* sceneVertexArray = malloc(numVertex*sizeof(SceneVertex));
        for (int i=0; i<numVertex; i++) {
            for (int j=0; j<3; j++){
                sceneVertexArray[i+j] = (SceneVertex){vertices[indices[i][j*3+0]], {0, 0, 0}, textures[indices[i][j*3+1]], normals[indices[i][j*3+2]]};
            }
        }
        return NULL;
    }
    
-(void)updateWithDelta:(NSTimeInterval)dt
    {
        self.rotationZ += M_PI * dt * 0.1;
        self.rotationY += M_PI * dt * 0.1;
        self.rotationX += M_PI * dt * 0.01f;
    }
    
@end
