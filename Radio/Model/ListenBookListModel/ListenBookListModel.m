//
//  ListenBookListModel.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "ListenBookListModel.h"

@implementation ListenBookListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@  %@", _id,_title];
}


@end
