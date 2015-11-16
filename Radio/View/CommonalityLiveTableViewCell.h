//
//  CommonalityLiveTableViewCell.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveModel;
@interface CommonalityLiveTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;//直播图片

@property (weak, nonatomic) IBOutlet UILabel *titleLable;//直播台的名字
@property (weak, nonatomic) IBOutlet UILabel *programDescLable;//来自


@property (weak, nonatomic) IBOutlet UILabel *comperesLable;//主播


@property (weak, nonatomic) IBOutlet UILabel *onLineNumLable;//在线人数

@property (nonatomic,strong)LiveModel * model;


@end
