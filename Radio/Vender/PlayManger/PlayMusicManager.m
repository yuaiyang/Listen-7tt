//
//  PlayMusicManager.m
//  MusicPalyer
//
//  Created by 雨爱阳 on 15/9/22.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "PlayMusicManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayMusicManager ()

@property (nonatomic ,strong)AVPlayer * avplayer;
@property (nonatomic ,strong)NSTimer * timer;//定时器
@property (nonatomic ,strong)NSMutableArray * lyricModelArray;
@property (nonatomic ,strong)AVPlayerItem * avitem;

@end

@implementation PlayMusicManager


#pragma mark----第一步：实现单例类方法
+ (PlayMusicManager *)shareInstance{
    static PlayMusicManager * share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate ,^{
        
        share = [[PlayMusicManager alloc] init];
    });
    
    return share;
}
//初始化avplayer
- (instancetype)init{
    self = [super init];
    if (self) {
        //初始化avplayer，创建avpllayer音频播放器对象
//        self.avplayer = [[AVPlayer alloc] init];
#pragma mark---①通知（观察播放完成的属性），当播放结束的时候，播放下一首
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMusicEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    return self;
}


#pragma mark----第二步：准备播放
- (void)preparePlayMusicWithMp3Url:(NSString *)Mp3Url{
    
#warning mark------这样每次进来都要创建播放器对象。。。。。没有使用观察者观察状态的改变
    self.avplayer = [[AVPlayer alloc] init];
    //1.为空判断，若MP3Url为空的话，直接返回
    if (!Mp3Url) {
        return;
    }

   //2.根据当前的Mp3Url得到item对象
    self.avitem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:Mp3Url]];
    
    //6.移除观察者
    if (self.avplayer.currentItem) {
//        NSLog(@"%@",self.avitem);
//        item = nil;
//        NSLog(@"%@",item);

        

//        [self.avplayer.currentItem removeObserver:self forKeyPath:@"status" context:nil];
 
    }
    
    //3.添加观察者(观察status属性)
//    [self.avitem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //4.替换掉当前播放的item
//    [self.avplayer cancelPendingPrerolls];取消挂起前滚
    [self.avplayer replaceCurrentItemWithPlayerItem:self.avitem];
    [self playMusic];

    
    
    
}


//5.实现观察者方法（当观察的状态发生改变时，系统自动调用观察者方法）
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //得到属性改变的状态
    AVPlayerStatus status = [change[@"new"] integerValue];
//    if (status == 2) {
//        status =1;
//        
//
//    }
    switch (status) {
        case AVPlayerStatusFailed:
          
//            NSLog(@"播放失败%@",self.avplayer);
            break;
        case AVPlayerStatusReadyToPlay:
//            NSLog(@"准备播放");
            //调用播放方法
            [self playMusic];
            
            
            break;
        case AVPlayerStatusUnknown:
//            NSLog(@"未知错误");
            break;
            
        default:
            break;
    }
//    [self playMusic];
}



//播放
- (void)playMusic{
    [self.avplayer play];
    //创建定时器，每隔0.1s重复执行 progressAction 方法
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(progressAction) userInfo:nil repeats:YES];
    
}

//每0.1s执行一次该方法
- (void)progressAction{
    //当执行这个方法时，让代理去执行协议中的方法实现传值
    if ([self.delegate respondsToSelector:@selector(playMusicManagerFetchCurrentTime:totalTime:progressValue:)]) {
        NSInteger currentTime = [self fetchCurrentTimeValue];
        NSInteger totalTime = [self fetchTotalTimeValue];
        
        //代理执行协议中的方法
        [self.delegate playMusicManagerFetchCurrentTime:[self changeSecondsToTime:currentTime] totalTime:[self changeSecondsToTime:totalTime] progressValue:[self fetchProgressValue]];
        
    }
}

//暂停
- (void)pauseMusic{
    
    [self.avplayer pause];
    
}
#pragma mark------Slider
//1.获取当前的时间
- (NSInteger)fetchCurrentTimeValue{
    //获取当前播放的时间 time.value/time.timescale
    CMTime time = self.avplayer.currentTime;
    //获取当前播放的秒数
    if (time.timescale == 0) {//若分母为0，则返回0
        return 0;
    }
    return time.value/time.timescale;
    
}

//2.获取播放总时间
- (NSInteger)fetchTotalTimeValue{
    CMTime time = self.avplayer.currentItem.duration;
    if (time.timescale == 0) {
        return 0;
    }
    return time.value/time.timescale;
    
}

//3.获取播放速度
- (CGFloat)fetchProgressValue{
    //播放时间
    NSInteger currentTime = [self fetchCurrentTimeValue];
    NSInteger totalTime = [self fetchTotalTimeValue];
    if (totalTime == 0) {
        return 0.0;
    }
    //播放进度(当前播放的时间/总时间)
    CGFloat timePlay = (CGFloat)currentTime/(CGFloat)totalTime;
    
    return timePlay;
    
}

//4.将秒数转换成 类似时间的格式  00:00
- (NSString *)changeSecondsToTime:(NSInteger)second{
    
    NSInteger min = second/60;//分钟
    NSInteger sec = second%60;//秒
    NSString * time = [NSString stringWithFormat:@"%.2ld:%.2ld",min,sec];
    
    return time;
}


#pragma mark----根据滑竿播放音乐
- (void)bySliderValueToPlayMusic:(CGFloat)progress{
    //1.当拖动滑竿的时候停止播放音乐
    [self pauseMusic];
    //2.从拖动到的制定时间 去播放音乐(进度*总时间)
    CMTime time = CMTimeMake(progress * [self fetchTotalTimeValue], 1);
    __weak PlayMusicManager * weakSelf = self;
    [self.avplayer seekToTime:time completionHandler:^(BOOL finished) {
       
        //开始播放音乐
        [weakSelf playMusic];
        
    }];
    
}
#pragma mark-----通知②-实现观察者方法---
- (void)playMusicEnd{
    //当播放结束的时候 代理执行协议中的  播放结束方法
    if ([_delegate respondsToSelector:@selector(playMusicMangerPlayMusicEnd)]) {
        //代理执行playMusicMangerPlayMusicEnd这个方法--这个方法实现是  播放下一首歌曲
        [_delegate playMusicMangerPlayMusicEnd];
    }
    
}

/*
#pragma mark-----对传过来的歌词进行分割
- (NSMutableArray *)fetchLyricSectionWithLyricString:(NSString *)lyricString{
    
    //1.为了当每次跟新的时候都会显示点击播放的那首歌词，删除数组中所有的元素
    [self.lyricModelArray removeAllObjects];
    //1.将歌词字分割 存放到数组中 以\n作为分割符（分割成一行一行的）
    NSArray * array = [lyricString componentsSeparatedByString:@"\n"];
    //2.遍历数组
    for (NSString * contentString in array) {
        //继续分割 以“]”做分割符 将每行歌词的 歌词与时间分隔开
        NSArray * contentArray = [contentString componentsSeparatedByString:@"]"];
#warning mark---安全判断
        if ([contentArray.firstObject length] < 1) {
            break;//当contentArray.firstObject没有值时 返回  若不判断可能会崩溃
            
        }
        NSLog(@"%@",contentArray);
        //3.歌词模型
        LyricModel * model = [[LyricModel alloc] init];
        //①歌词：将数组中的最后的元素是歌词
        model.lyricString = contentArray.lastObject;
        NSLog(@"%@",contentArray.lastObject);
        
        //②时间 获取子字符串 从下标为1处开始
        NSString * tempString = [contentArray.firstObject substringFromIndex:1];
        
        NSArray * timeArray = [tempString componentsSeparatedByString:@"."];
        model.lyricTime = timeArray.firstObject;
        
        [self.lyricModelArray addObject:model];
        
    }
    
    return self.lyricModelArray;
}

//懒加载
- (NSMutableArray *)lyricModelArray{
    
    if (!_lyricModelArray) {
        _lyricModelArray = [NSMutableArray array];
    }
    return _lyricModelArray;
}

 */
//#pragma mark----根据当前播放的时间获取下标
//- (NSInteger)byCurrentTimeFetch:(NSString *)time{
//    //定义下标，给初始值-1
//    NSInteger index = -1;
//    for (int i = 0; i < self.lyricModelArray.count - 1; i++) {
//        //从数组中获取歌词的对象
//        LyricModel * model = self.lyricModelArray[i];
//        //如果歌词的时间等于当前的播放时间
//        if ([model.lyricTime isEqualToString:time]) {
//            index = i;
//        }
//        
//    }
//    
//    return index;
//    
//}

#pragma mark-------实现音量调节
/*
//- (void)setVolume:(float)volume{
//    
////
//////    AVAsset * asset = [AVAsset assetWithURL:<#(NSURL *)#>]
//    AVAsset * asset = [[AVAsset alloc] init];
//    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
////
//    NSMutableArray *allAudioParams = [NSMutableArray array];//allAudioParams所有音频的参数
//    for (AVAssetTrack *track in audioTracks) {//audioTracks音轨
//        AVMutableAudioMixInputParameters *audioInputParams = //audioInputParams音频输入参数
//        [AVMutableAudioMixInputParameters audioMixInputParameters];
//        //在特定的时间设置音频音量的值
//        [audioInputParams setVolume:volume atTime:kCMTimeZero]; //kCMTimeZero 使用这个常数来初始化一个CMTime为0。
//        //表示音轨的trackID参数应该被应用
//        [audioInputParams setTrackID:[track trackID]];
//        [allAudioParams addObject:audioInputParams];
//       
//    }
//    
//    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
//    [audioMix setInputParameters:allAudioParams];
//    
//    [self.avplayer.currentItem setAudioMix:audioMix];
//    
//}
 */
- (void)setVolume:(float)volume{
    NSMutableArray *allAudioParams = [NSMutableArray array];
    AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
    [audioInputParams setVolume:volume atTime:kCMTimeZero];
    [audioInputParams setTrackID:1];
    [allAudioParams addObject:audioInputParams];
    AVMutableAudioMix * audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    [self.avplayer.currentItem setAudioMix:audioMix]; // Mute the player item
    
    [self.avplayer setVolume:volume];
}


#pragma mark----移除观察者
//- (void)removeOberser{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//
//    
//}

@end
