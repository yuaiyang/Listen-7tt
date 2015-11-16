//
//  CollectTableViewCell.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/25.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "CollectTableViewCell.h"

#import "bookPlayModel.h"
#import "MusicListModel.h"
#import "StationListModel.h"
#import "LiveModel.h"

#import "UIImageView+WebCache.h"




@implementation CollectTableViewCell

- (void)awakeFromNib {
//    //剪切图片成圆形
//    self.posterImage.layer.cornerRadius = self.posterImage.frame.size.width/2;
//    self.posterImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
}


#pragma mark  重写model的setter方法

- (void)setData{
    
    [self.posterImage sd_setImageWithURL:[NSURL URLWithString:_musicModel.audioPic]];
    self.topTitle.text = _musicModel.albumName;
    
}

- (void)setBookData{
//    [self.posterImage sd_setImageWithURL:[NSURL URLWithString:_bookModel.image_url]];
    self.topTitle.text = _bookModel.title;
    
}

- (void)setBookModel:(bookPlayModel *)bookModel{
    if (_bookModel != bookModel) {
        _bookModel = bookModel;
        
    }
}

- (void)setStationData{
    self.topTitle.text = _stationModel.title;
    [self.posterImage sd_setImageWithURL:[NSURL URLWithString:_stationModel.cover_url]];
}

- (void)setLiveModelData{
    self.topTitle.text = _liveModel.comperes;
    [self.posterImage sd_setImageWithURL:[NSURL URLWithString:_liveModel.livePic]];
}

@end
