//
//  Cube.m
//  OpenGl_Triangle
//
//  Created by clonekim on 23/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Cube.h"

static SceneVertex vertices[] =
{
    {{-1.0f, 1.0f, 1.0f}, {0,0,1.0f}},
    {{1.0f, 1.0f, 1.0f}, {1.0f,1.0f,0}},
    {{-1.0f, -1.0f, 1.0f}, {1.0f,0,0}},
    {{1.0f, -1.0f, 1.0f}, {0,1.0f,0}},
    {{-1.0f, 1.0f, -1.0f}, {0,0,1.0f}},
    {{1.0f, 1.0f, -1.0f}, {1.0f,1.0f,0}},
    {{-1.0f, -1.0f, -1.0f}, {1.0f,0,0}},
    {{1.0f, -1.0f, -1.0f}, {0,1.0f,0}}
};

static int indices[] =
{
    //front
    0, 2, 1,
    1, 2, 3,
    //back
    5, 6, 4,
    7, 6, 5,
    //top
    0, 1, 4,
    4, 1, 5,
    //bot
    3, 2, 6,
    6, 7, 3,
    //left
    2, 0, 4,
    4, 6, 2,
    //right
    1, 3, 5,
    5, 3, 7
};


@implementation Cube

-(instancetype)initWithShader:(UserShader *)shader{
    if(self = [super initWithName:"cube" shader:shader vertices:vertices vertexCount:sizeof(vertices)/sizeof(vertices[0]) indices:indices indexCount:sizeof(indices)/sizeof(indices[0])])
    {
        
    }
    return self;
}

-(void)updateWithDelta:(NSTimeInterval)dt{
    self.rotationZ += M_PI * dt;
    self.rotationY += M_PI * dt;
    self.rotationX += M_PI * dt * 0.1f;
}
@end
