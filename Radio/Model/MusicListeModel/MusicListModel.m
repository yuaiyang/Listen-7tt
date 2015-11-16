//
//  MusicListModel.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/26.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "MusicListModel.h"

@implementation MusicListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@  %@   %@", _albumName,_audioPic,_mp3PlayUrl];
}

@end
