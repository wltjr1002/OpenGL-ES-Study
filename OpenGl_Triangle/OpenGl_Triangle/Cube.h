//
//  Cube.h
//  OpenGl_Triangle
//
//  Created by clonekim on 23/05/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cube : Model

-(instancetype)initWithShader:(UserShader *)shader;

@end

NS_ASSUME_NONNULL_END
