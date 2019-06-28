//
//  ObjParser.m
//  OpenGl_Triangle
//
//  Created by clonekim on 24/06/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "ObjParser.h"

@implementation ObjParser
{
    NSString* _filename;
    GLKVector3* _vertices;
    int* _indices;
    SceneVertex* _sceneVertices;
    int _vertexCount;
    int _indiceCount;
}

-(instancetype)initWithFilename:(NSString *)filename
{
    if(self = [super init])
    {
        [self processLines:[self stringFromFilename:filename]];
    }
    return self;
}

-(SceneVertex *)sceneVertices
{
    return _sceneVertices;
}
-(int *)getIndices
{
    return _indices;
}
-(int)vertexCount
{
    return _vertexCount;
}
-(int)indiceCount
{
    return _indiceCount;
}

-(NSArray *)stringFromFilename:(NSString *)filename
{
    _filename = filename;
    NSError* error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath = [[fm currentDirectoryPath] stringByAppendingPathComponent:filename];
    //NSString *filePath = @"dodecahedron.txt";
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"ERROR while loading from file: %@", error);
    }
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return lines;
}

-(void)processLines:(NSArray *)lines
{
    int numVertex = 0;
    int numFace = 0;
    for (int i = 0; i<lines.count; i++) {
        //NSLog([[lines objectAtIndex:i] stringValue]);
        if([[lines objectAtIndex:i] isEqualToString:@""]){continue;}
        NSArray *line = [self split:lines[i]];
        if([[line objectAtIndex:0] isEqualToString:@"v"])
        {
            numVertex++;
        }
        if([[line objectAtIndex:0] isEqualToString:@"f"])
        {
            numFace += line.count-3;
        }
    }
    _vertices = malloc(numVertex*sizeof(GLKVector3));
    _sceneVertices = malloc(numFace*3*sizeof(SceneVertex));
    
    int vertexCount = 0;
    int sceneVertexCount = 0;
    for (int i = 0; i<lines.count; i++)
    {
        NSArray* line = [self split:lines[i]];
        if([[line objectAtIndex:0] isEqualToString:@"v"])
        {
            GLKVector3 newVertex = GLKVector3Make([[line objectAtIndex:1] floatValue], [[line objectAtIndex:2] floatValue], [[line objectAtIndex:3] floatValue]);
            _vertices[vertexCount] = newVertex;
            vertexCount++;
        }
    }
    for (int i = 0; i<lines.count; i++)
    {
        NSArray* line = [self split:lines[i]];
        if([[line objectAtIndex:0] isEqualToString:@"f"])
        {
            for(int j=0;j<line.count-3;j++)
            {
                GLKVector3 newVertex1, newVertex2, newVertex3;
                newVertex1 = _vertices[[[line objectAtIndex:1] integerValue]-1];
                newVertex2 = _vertices[[[line objectAtIndex:2+j] integerValue]-1];
                newVertex3 = _vertices[[[line objectAtIndex:3+j] integerValue]-1];
                
                GLKVector3 normal = GLKVector3CrossProduct(GLKVector3Subtract(newVertex1, newVertex2), GLKVector3Subtract(newVertex2, newVertex3));
                normal = GLKVector3Normalize(normal);
                
                SceneVertex sceneVertex1 = (SceneVertex){newVertex1, {1.0f,1.0f,1.0f}, {0,0}, normal};
                SceneVertex sceneVertex2 = (SceneVertex){newVertex2, {1.0f,1.0f,1.0f}, {0,0}, normal};
                SceneVertex sceneVertex3 = (SceneVertex){newVertex3, {1.0f,1.0f,1.0f}, {0,0}, normal};
                
                _sceneVertices[sceneVertexCount] = sceneVertex1;
                _sceneVertices[sceneVertexCount+1] = sceneVertex2;
                _sceneVertices[sceneVertexCount+2] = sceneVertex3;
                
                sceneVertexCount += 3;
            }
        }
    }
    _vertexCount = sceneVertexCount;
}

-(NSArray *)split:(NSString *)string
{
    return [[string stringByReplacingOccurrencesOfString:@"  " withString:@" "] componentsSeparatedByString:@" "];
}

@end
