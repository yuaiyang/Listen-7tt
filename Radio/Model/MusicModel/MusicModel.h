//
//  MusicModel.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

#pragma mark-----精选页面
@property (nonatomic ,strong)NSString * albumName;
@property (nonatomic ,strong)NSString * pic;
@property (nonatomic ,strong)NSString * rname;//头部轮播 点击播放页面的：期名//如果是下面音乐Cell上的rnameLable上的值
@property (nonatomic ,assign)NSInteger rid;
@property (nonatomic ,strong)NSString * des;

@property (nonatomic ,strong)NSString * name;//区头名


#pragma mark-----全部页面----
@property (nonatomic,assign)NSInteger categoryId;//各个页面之间的ID用于拼接网址
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong)NSString * categoryName;//顶部的文字

//@property (nonatomic ,strong)NSString * pic;

//@property (nonatomic ,strong)NSString * albumName;

//@property (nonatomic ,strong)NSString * name;
@property (nonatomic ,strong)NSString * comeFrom;

@property (nonatomic ,strong)NSString * desc;//详情
@property (nonatomic,assign)NSInteger listenNum;
@property (nonatomic,assign)NSInteger followedNum;

@property (nonatomic ,assign)NSInteger rtype;


@end
