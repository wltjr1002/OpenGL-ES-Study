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
    NSArray* _data;
    struct Vertex* _vertices;
    GLKVector3* _normals;
    GLKVector2* _texCoords;
    SceneVertex* _sceneVertices;
    int* _indices;
    int _vertexCount;
    int _indiceCount;
    bool _normalInfo;
    bool _textureInfo;
}

-(instancetype)initWithFilename:(NSString *)filename
{
    if(self = [super init])
    {
        _data = [self ReadDataFromFilename:filename];
        _normalInfo = false;
        _textureInfo = false;
        [self PostProcessing];
        [self ProcessLines];
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

-(NSArray *)ReadDataFromFilename:(NSString *)filename
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

-(void)PostProcessing
{
    NSArray* lines = _data;
    
    // read file Before Parsing
    // Save info : #vertices, #faces
    int numVertex = 0;
    int numNormal = 0;
    int numTexture = 0;
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
        if([[line objectAtIndex:0] isEqualToString:@"vn"])
        {
            if(!_normalInfo) _normalInfo = true;
            numNormal++;
        }
        if([[line objectAtIndex:0] isEqualToString:@"vt"])
        {
            if(!_textureInfo) _textureInfo = true;
            numTexture++;
        }
    }
    // Allocate memory for vertices and Scenevertices
    
    _vertices = malloc(numVertex*sizeof(struct Vertex));
    _sceneVertices = malloc(numFace*3*sizeof(SceneVertex));
    
    // if there is no normal/texture vector information, '_normals' array contains normal vector of each vertex
    if(_normalInfo) { _normals = malloc(numNormal*sizeof(GLKVector3));}
    else{ _normals = malloc(numVertex*sizeof(GLKVector3));}
    
    if(_textureInfo) { _texCoords = malloc(numTexture*sizeof(GLKVector2));}
    else{ _texCoords = malloc(numVertex*sizeof(GLKVector2));}
    
}

-(void)ProcessLines
{
    NSArray* lines = _data;
    
    // fill vertex, normal and textureCoordination array
    int vertexIndex = 0;
    int normalIndex = 0;
    for (int i = 0; i<lines.count; i++)
    {
        NSArray* line = [self split:lines[i]];
        if([[line objectAtIndex:0] isEqualToString:@"v"])
        {
            GLKVector3 newVertex = GLKVector3Make([[line objectAtIndex:1] floatValue], [[line objectAtIndex:2] floatValue], [[line objectAtIndex:3] floatValue]);
            _vertices[vertexIndex] = (struct Vertex){newVertex, 0};
            vertexIndex++;
        }
        if(_normalInfo && [[line objectAtIndex:0] isEqualToString:@"vn"])
        {
            GLKVector3 newVector = GLKVector3Make([[line objectAtIndex:1] floatValue], [[line objectAtIndex:2] floatValue], [[line objectAtIndex:3] floatValue]);
            _normals[normalIndex] = newVector;
            normalIndex++;
        }
    }
    
    // if there is no normal or texcoord information, calculate normal vectors;
    if(!_normalInfo)
    {
        for (int i = 0; i<lines.count; i++)
        {
            NSArray* line = [self split:lines[i]];
            
            if([[line objectAtIndex:0] isEqualToString:@"f"])
            {
                for(int j=0;j<line.count-3;j++)
                {
                    long vertexIndex1, vertexIndex2, vertexIndex3;
                    GLKVector3 newVertex1, newVertex2, newVertex3;
                    
                    vertexIndex1 = [[line objectAtIndex:1] integerValue]-1;
                    vertexIndex2 = [[line objectAtIndex:2+j] integerValue]-1;
                    vertexIndex3 = [[line objectAtIndex:3+j] integerValue]-1;
                    
                    newVertex1 = _vertices[vertexIndex1].vertexPosition;
                    newVertex2 = _vertices[vertexIndex2].vertexPosition;
                    newVertex3 = _vertices[vertexIndex3].vertexPosition;
                    
                    GLKVector3 normal = GLKVector3CrossProduct(GLKVector3Subtract(newVertex1, newVertex2), GLKVector3Subtract(newVertex2, newVertex3));
                    
                    _normals[vertexIndex1] = GLKVector3Add(_normals[vertexIndex1], normal);
                    _vertices[vertexIndex1].referenceCount++;
                    _normals[vertexIndex2] = GLKVector3Add(_normals[vertexIndex2], normal);
                    _vertices[vertexIndex2].referenceCount++;
                    _normals[vertexIndex3] = GLKVector3Add(_normals[vertexIndex3], normal);
                    _vertices[vertexIndex3].referenceCount++;
                    
                }
            }
        }
    }
    
    // scenevertexarray from face
    int sceneVertexIndex = 0;
    for (int i = 0; i<lines.count; i++)
    {
        bool smoothing = true;
        NSArray* line = [self split:lines[i]];
        if([[line objectAtIndex:0] isEqualToString:@"s"])
        {
            if([[line objectAtIndex:1] isEqualToString:@"on"]) smoothing = true;
            else smoothing = false;
        }
        if([[line objectAtIndex:0] isEqualToString:@"f"])
        {
            for(int j=0;j<line.count-3;j++)
            {
                NSArray *vertexInfo1, *vertexInfo2, *vertexInfo3;
                GLKVector3 positionVec1, positionVec2, positionVec3;
                GLKVector2 textureVec1, textureVec2, textureVec3;
                GLKVector3 normalVec1, normalVec2, normalVec3;
                
                vertexInfo1 = [[line objectAtIndex:1] componentsSeparatedByString:@"/"];
                vertexInfo2 = [[line objectAtIndex:2+j] componentsSeparatedByString:@"/"];
                vertexInfo3 = [[line objectAtIndex:3+j] componentsSeparatedByString:@"/"];
                
                positionVec1 = _vertices[[[vertexInfo1 objectAtIndex:0] integerValue]-1].vertexPosition;
                positionVec2 = _vertices[[[vertexInfo2 objectAtIndex:0] integerValue]-1].vertexPosition;
                positionVec3 = _vertices[[[vertexInfo3 objectAtIndex:0] integerValue]-1].vertexPosition;
                
                if(_textureInfo)
                {
                    textureVec1 = _texCoords[[[vertexInfo1 objectAtIndex:1] integerValue]-1];
                    textureVec2 = _texCoords[[[vertexInfo2 objectAtIndex:1] integerValue]-1];
                    textureVec3 = _texCoords[[[vertexInfo3 objectAtIndex:1] integerValue]-1];
                }
                else
                {
                    textureVec1 = GLKVector2Make(0, 0);
                    textureVec2 = GLKVector2Make(0, 0);
                    textureVec3 = GLKVector2Make(0, 0);
                }
                
                if(_normalInfo)
                {
                    if(smoothing)
                    {
                        normalVec1 = _normals[[[vertexInfo1 objectAtIndex:2] integerValue]-1];
                        normalVec2 = _normals[[[vertexInfo2 objectAtIndex:2] integerValue]-1];
                        normalVec3 = _normals[[[vertexInfo3 objectAtIndex:2] integerValue]-1];
                    }
                    else
                    {
                        GLKVector3 normal = GLKVector3CrossProduct(GLKVector3Subtract(positionVec1, positionVec2), GLKVector3Subtract(positionVec2, positionVec3));
                        normalVec1 = normal;
                        normalVec2 = normal;
                        normalVec3 = normal;
                    }
                }
                else
                {
                    normalVec1 = _normals[[[vertexInfo1 objectAtIndex:0] integerValue]-1];
                    normalVec2 = _normals[[[vertexInfo2 objectAtIndex:0] integerValue]-1];
                    normalVec3 = _normals[[[vertexInfo3 objectAtIndex:0] integerValue]-1];
                }
                
                
               
                _sceneVertices[sceneVertexIndex] =  (SceneVertex){positionVec1, {1.0f, 1.0f, 1.0f}, textureVec1, normalVec1};
                _sceneVertices[sceneVertexIndex+1] = (SceneVertex){positionVec2, {1.0f, 1.0f, 1.0f}, textureVec2, normalVec2};
                _sceneVertices[sceneVertexIndex+2] = (SceneVertex){positionVec3, {1.0f, 1.0f, 1.0f}, textureVec3, normalVec3};
                
                sceneVertexIndex += 3;
            }
        }
    }
    _vertexCount = sceneVertexIndex;
}

-(NSArray *)split:(NSString *)string
{
    return [[string stringByReplacingOccurrencesOfString:@"  " withString:@" "] componentsSeparatedByString:@" "];
}

@end
