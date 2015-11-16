//
//  CollectionViewCell.m
//  TestDemo
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "FeaturedCollectionViewCell.h"
#import "FeaturedCollectionViewCell.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"
@implementation FeaturedCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(MusicModel *)model{
    
    if (_model != model) {
        _model = model;
        self.singerName.text = _model.rname;
        self.musicName.text = _model.des;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:[UIImage imageNamed:@"xiaogui.jpg"]];
        
    }
}

@end
