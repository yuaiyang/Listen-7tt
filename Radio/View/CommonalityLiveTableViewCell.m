//
//  CommonalityLiveTableViewCell.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "CommonalityLiveTableViewCell.h"
#import "LiveModel.h"
#import "UIImageView+WebCache.h"

@implementation CommonalityLiveTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LiveModel *)model{
    if (_model != model) {
        _model = model;
        [self.liveImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]placeholderImage:[UIImage imageNamed:@"xiaogui.jpg"]];
        self.titleLable.text = _model.liveName;
        self.programDescLable.text = [NSString stringWithFormat:@"来自：%@",_model.liveDesc];
        self.comperesLable.text = [NSString stringWithFormat:@"主播：%@",_model.comperes];
        self.onLineNumLable.text = [NSString stringWithFormat:@"%ld人在线",_model.onLineNum];
        
    }
    
    
}




@end
