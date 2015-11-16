//
//  bookPlayModel.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/27.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "bookPlayModel.h"

@implementation bookPlayModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _title];
}

@end
