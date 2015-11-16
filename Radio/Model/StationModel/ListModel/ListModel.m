//
//  ListModel.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld  %@  %@", _category_id,_category_name,_user_list];
}

@end
