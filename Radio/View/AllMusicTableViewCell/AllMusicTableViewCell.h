//
//  AllMusicTableViewCell.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;

@interface AllMusicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *allMusicImageView;//全部页面的音乐图片

@property (weak, nonatomic) IBOutlet UILabel *titleLable;//标题名

@property (weak, nonatomic) IBOutlet UILabel *desLable;//详情简介
@property (weak, nonatomic) IBOutlet UILabel *listenNumLable;//收听人数

@property (weak, nonatomic) IBOutlet UILabel *followedNumLable;//订阅人数

@property (nonatomic,strong)MusicModel * model;



@end
