//
//  AllMusicTableViewCell.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "AllMusicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MusicModel.h"
@implementation AllMusicTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//重写Setter方法
- (void)setModel:(MusicModel *)model{
    if (_model != model) {
        _model = model;
        [self.allMusicImageView sd_setImageWithURL:[NSURL URLWithString:_model.pic]placeholderImage:[UIImage imageNamed:@"xiaogui.jpg"]];
        self.titleLable.text = _model.albumName;
        self.desLable.text = _model.desc;
        self.listenNumLable.text = [NSString stringWithFormat:@"%.f万次收听",_model.listenNum /10000.0];
        self.followedNumLable.text = [NSString stringWithFormat:@"%.f万次订阅",_model.followedNum/10000.0];
        
        
        
        
    }
}




@end
