//
//  CollectTableViewCell.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/25.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicListModel;
@class bookPlayModel;
@class StationListModel;
@class LiveModel;


@interface CollectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;

@property (weak, nonatomic) IBOutlet UILabel *topTitle;

@property (strong , nonatomic) NSString * mp3Url;

@property (strong , nonatomic) NSString * imageUrl;

@property (strong , nonatomic) bookPlayModel * bookModel;
@property (strong , nonatomic) LiveModel * liveModel;
@property (strong , nonatomic) MusicListModel * musicModel;
@property (strong , nonatomic) StationListModel * stationModel;

- (void)setData;
- (void)setBookData;
- (void)setStationData;
- (void)setLiveModelData;
@end
