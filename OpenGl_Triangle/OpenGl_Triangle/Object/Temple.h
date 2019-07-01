//
//  Temple.h
//  OpenGl_Triangle
//
//  Created by clonekim on 01/07/2019.
//  Copyright © 2019 clonekim. All rights reserved.
//

#import "ObjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Temple : ObjectModel

-(instancetype)initWithShader:(UserShader *)shader;

-(void)render;

@end

NS_ASSUME_NONNULL_END
