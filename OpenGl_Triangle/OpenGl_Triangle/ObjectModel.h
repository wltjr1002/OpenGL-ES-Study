//
//  ObjectModel.h
//  OpenGl_Triangle
//
//  Created by clonekim on 25/06/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Model.h"
#import "ObjParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjectModel : Model

-(instancetype)initWithShader:(UserShader *)shader Filename:(NSString *)filename;

@end

NS_ASSUME_NONNULL_END
