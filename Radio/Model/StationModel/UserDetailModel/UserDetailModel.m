//
//  UserDetailModel.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "UserDetailModel.h"

@implementation UserDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %ld %@", _user_nick,_user_id,_is_vip];
}

@end
