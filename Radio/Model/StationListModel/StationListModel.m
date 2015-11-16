//
//  StationListModel.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/26.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "StationListModel.h"

@implementation StationListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@", _title,_sound_url,_cover_url];
}

@end
