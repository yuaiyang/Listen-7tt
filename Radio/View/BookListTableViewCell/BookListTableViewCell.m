//
//  BookListTableViewCell.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "BookListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation BookListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(BookListModel *)model{
    if (_model != model) {
        _model = model;
        [self.posterImage sd_setImageWithURL:[NSURL URLWithString:_model.image_url]placeholderImage:[UIImage imageNamed:@"xiaogui.jpg"]];
        self.bookName.text = _model.title;
        self.playTimes.text = [NSString stringWithFormat:@"播放次数:%ld" , _model.play_num];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
