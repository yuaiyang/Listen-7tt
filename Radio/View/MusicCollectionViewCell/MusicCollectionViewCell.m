//
//  MusicCollectionViewCell.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "MusicCollectionViewCell.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"


@implementation MusicCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(MusicModel *)model{
    
    if (_model != model) {
        _model = model;
        self.albumNameLable.text = _model.albumName;
        self.rnameLable.text = _model.rname;
        [self.musicPicture sd_setImageWithURL:[NSURL URLWithString:_model.pic]placeholderImage:[UIImage imageNamed:@"xiaogui.jpg"]];
        
    }
}



@end
