//
//  MusicModel.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@  %ld", _name,_rid];
}


@end
