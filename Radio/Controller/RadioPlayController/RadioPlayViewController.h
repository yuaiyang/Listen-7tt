//
//  RadioPlayViewController.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/27.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveModel;

@interface RadioPlayViewController : UIViewController

//创建单例列类，当点击同一个直播的时候继续播放
+ (RadioPlayViewController *)shareInstance;
@property (nonatomic ,assign)NSInteger indexPath;
@property (nonatomic ,strong)LiveModel * model;//用于接收上一级传过来的programId
@property (nonatomic ,assign)NSInteger tags;

@property (nonatomic ,assign)NSInteger tagsController;


@end
