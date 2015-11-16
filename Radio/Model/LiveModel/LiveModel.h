//
//  LiveModel.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveModel : NSObject
#pragma mark------公共页面
@property (nonatomic ,strong)NSString * comperes;//主播
@property (nonatomic ,strong)NSString * liveName;//直播台的名字
@property (nonatomic ,strong)NSString * liveDesc;//直播台的详情
@property (nonatomic ,strong)NSString * avatar;//直播图片
@property (nonatomic ,strong)NSString * livePic;//详情页面的图片
@property (nonatomic ,strong)NSString * liveUrl;//直播网址
@property (nonatomic ,strong)NSString * showStartTime;//直播中
//@property (nonatomic ,assign)NSInteger * startTime;//开始时间
@property (nonatomic,assign)NSInteger onLineNum;//在线人数

@property (nonatomic,assign)NSInteger nextPage;//加载数据时下一页的数据，用于拼接网址

#pragma mark-------私人直播
//@property (nonatomic ,strong)NSString * avatar;//直播图片

//@property (nonatomic,strong)NSString * liveName;//私人的。。。。的直播

//@property (nonatomic,strong)NSString * comperes;//主播
//@property (nonatomic,assign)NSInteger onLineNum;//在线人数

@end
