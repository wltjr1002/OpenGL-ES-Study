//
//  Square.m
//  OpenGl_Triangle
//
//  Created by clonekim on 21/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Square.h"

static SceneVertex vertices[] =
{
    {{-1.0f, 1.0f, 0}, {0,0,1.0f}},
    {{1.0f, 1.0f, 0}, {1.0f,1.0f,0}},
    {{-1.0f, -1.0f, 0}, {1.0f,0,0}},
    {{1.0f, -1.0f, 0}, {0,1.0f,0}}
};

static int indices[] =
{
    0, 2, 1,
    1, 2, 3
};

@implementation Square

-(instancetype)initWithShader:(UserShader *)shader
{
    if(self = [super initWithName:"Square" shader:shader vertices:vertices vertexCount:sizeof(vertices)/sizeof(SceneVertex) indices:indices indexCount:sizeof(indices)/sizeof(int)])
    {
        
    }
    return self;
}

@end
