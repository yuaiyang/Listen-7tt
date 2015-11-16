//
//  StationCollectionViewCell.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "StationCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation StationCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(UserDetailModel *)model{
    if (_model != model) {
        _model = model;
        [_posterImage sd_setImageWithURL:[NSURL URLWithString:_model.user_avatar]placeholderImage:[UIImage imageNamed:@"xiaogui.jpg"]];
        _userName.text = _model.user_nick;
    }
}

@end
