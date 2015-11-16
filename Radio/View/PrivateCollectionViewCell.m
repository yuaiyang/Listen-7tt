//
//  PrivateCollectionViewCell.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "PrivateCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "LiveModel.h"
@implementation PrivateCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(LiveModel *)model{
    
    if (_model != model) {
        _model = model;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]placeholderImage:[UIImage imageNamed:@"xiaogui.jpg"]];
        self.listenNumber.text = [NSString stringWithFormat:@"%ld人收听", _model.onLineNum];
        self.nameLable.text = _model.liveName;
        self.ownerLable.text = [NSString stringWithFormat:@"主播：%@",_model.comperes];
        
        
    }
}


@end
