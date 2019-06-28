//
//  ObjectModel.m
//  OpenGl_Triangle
//
//  Created by clonekim on 25/06/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "ObjectModel.h"

@implementation ObjectModel
{
    ObjParser* _parser;
}


-(instancetype)initWithShader:(UserShader *)shader Filename:(nonnull NSString *)filename{
    
    _parser = [[ObjParser alloc] initWithFilename:filename];
    SceneVertex* vertices = [_parser sceneVertices];
    int vertexcount = [_parser vertexCount];
    self = [super initWithName:"cube" shader:shader vertices:vertices vertexCount:vertexcount];
    return self;
}

-(void)updateWithDelta:(NSTimeInterval)dt
{
    //self.rotationY += M_PI * dt * 0.1;
}


@end
