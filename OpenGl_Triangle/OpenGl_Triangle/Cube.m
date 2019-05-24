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
    //front
    {{-1.0f, 1.0f, 1.0f}, {1.0f, 0, 0}, {0, 0, 1.0f}},
    {{1.0f, 1.0f, 1.0f}, {1.0f, 0, 0}, {0, 0, 1.0f}},
    {{-1.0f, -1.0f, 1.0f}, {1.0f, 0, 0}, {0, 0, 1.0f}},
    {{1.0f, -1.0f, 1.0f}, {1.0f, 0, 0}, {0, 0, 1.0f}},
    //back
    {{1.0f, 1.0f, -1.0f}, {0, 1.0f, 1.0f}, {0, 0, -1.0f}},
    {{-1.0f, 1.0f, -1.0f}, {0, 1.0f, 1.0f}, {0, 0, -1.0f}},
    {{1.0f, -1.0f, -1.0f}, {0, 1.0f, 1.0f}, {0, 0, -1.0f}},
    {{-1.0f, -1.0f, -1.0f}, {0, 1.0f, 1.0f}, {0, 0, -1.0f}},
    //top
    {{-1.0f, 1.0f, -1.0f}, {0, 1.0f, 0}, {0, 1.0f, 0}},
    {{1.0f, 1.0f, -1.0f}, {0, 1.0f, 0}, {0, 1.0f, 0}},
    {{-1.0f, 1.0f, 1.0f}, {0, 1.0f, 0}, {0, 1.0f, 0}},
    {{1.0f, 1.0f, 1.0f}, {0, 1.0f, 0}, {0, 1.0f, 0}},
    //bottom
    {{-1.0f, -1.0f, 1.0f}, {1.0f, 0, 1.0f}, {0, -1.0f, 0}},
    {{1.0f, -1.0f, 1.0f}, {1.0f, 0, 1.0f}, {0, -1.0f, 0}},
    {{-1.0f, -1.0f, -1.0f}, {1.0f, 0, 1.0f}, {0, -1.0f, 0}},
    {{1.0f, -1.0f, -1.0f}, {1.0f, 0, 1.0f}, {0, -1.0f, 0}},
    //left
    {{-1.0f, 1.0f, -1.0f}, {0, 0, 1.0f}, {-1.0f, 0, 0}},
    {{-1.0f, 1.0f, 1.0f}, {0, 0, 1.0f}, {-1.0f, 0, 0}},
    {{-1.0f, -1.0f, -1.0f}, {0, 0, 1.0f}, {-1.0f, 0, 0}},
    {{-1.0f, -1.0f, 1.0f}, {0, 0, 1.0f}, {-1.0f, 0, 0}},
    //right
    {{1.0f, 1.0f, 1.0f}, {1.0f, 1.0f, 0}, {1.0f, 0, 0}},
    {{1.0f, 1.0f, -1.0f}, {1.0f, 1.0f, 0}, {1.0f, 0, 0}},
    {{1.0f, -1.0f, 1.0f}, {1.0f, 1.0f, 0}, {1.0f, 0, 0}},
    {{1.0f, -1.0f, -1.0f}, {1.0f, 1.0f, 0}, {1.0f, 0, 0}}
};

static int indices[] =
{
    //front
    0, 2, 1,
    1, 2, 3,
    //back
    4, 6, 5,
    5, 6, 7,
    //top
    8, 10, 9,
    9, 10, 11,
    //bot
    12, 14, 13,
    13, 14, 15,
    //left
    16, 18, 17,
    17, 18, 19,
    //right
    20, 22, 21,
    21, 22, 23
};


@implementation Cube

-(instancetype)initWithShader:(UserShader *)shader{
    if(self = [super initWithName:"cube" shader:shader vertices:vertices vertexCount:sizeof(vertices)/sizeof(vertices[0]) indices:indices indexCount:sizeof(indices)/sizeof(indices[0])])
    {
        
    }
    return self;
}

-(void)updateWithDelta:(NSTimeInterval)dt{
    self.rotationZ += M_PI * dt * 0.1;
    self.rotationY += M_PI * dt * 0.1;
    self.rotationX += M_PI * dt * 0.01f;
}
@end
