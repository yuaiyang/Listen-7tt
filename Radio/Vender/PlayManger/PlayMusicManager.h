//
//  PlayMusicManager.h
//  MusicPalyer
//
//  Created by 雨爱阳 on 15/9/22.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PlayMusicManager;

@protocol PlayMusicManagerDelegate<NSObject>
//协议中的方法
//获取当前播放的时间，持续时间，播放进度，代理传值
- (void)playMusicManagerFetchCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime progressValue:(CGFloat)progress;
//音乐播放结束
- (void)playMusicMangerPlayMusicEnd;

@end

@interface PlayMusicManager : NSObject<PlayMusicManagerDelegate>
@property (nonatomic ,assign)id<PlayMusicManagerDelegate>delegate;

//1.创建单例对象，播放音乐
+ (PlayMusicManager *)shareInstance;
//2.准备播放
- (void)preparePlayMusicWithMp3Url:(NSString *)Mp3Url;
//3.播放
- (void)playMusic;
//4.暂停
- (void)pauseMusic;
//5.当拖动滑竿时从滑竿位置时间处播放音乐
- (void)bySliderValueToPlayMusic:(CGFloat)progress;
//6.对歌词进行分割
- (NSMutableArray *)fetchLyricSectionWithLyricString:(NSString *)lyricString;
//7.根据当前播放的时间获取下标
- (NSInteger)byCurrentTimeFetch:(NSString *)time;

//8.控制音量的调整
- (void)setVolume:(float)volume;

//9.移除观察者
- (void)removeOberser;



@end
