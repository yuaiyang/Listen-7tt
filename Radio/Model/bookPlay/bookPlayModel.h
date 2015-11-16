//
//  bookPlayModel.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/27.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bookPlayModel : NSObject

@property (strong , nonatomic) NSString * audio_64_url; // mp3url
@property (strong , nonatomic) NSString * album_id;
@property (strong , nonatomic) NSString * audio_32_size; // 文件大小
@property (strong , nonatomic) NSString * duration; // 时长
@property (strong , nonatomic) NSString * title; // 章节标题
@property (assign , nonatomic) NSInteger play_num; // 播放此处

@property (nonatomic ,strong)NSString * urlString;

@end
