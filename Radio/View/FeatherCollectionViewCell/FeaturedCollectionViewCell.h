//
//  CollectionViewCell.h
//  TestDemo
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;
@interface FeaturedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;//音乐图片
@property (weak, nonatomic) IBOutlet UILabel *singerName;//歌手名

@property (weak, nonatomic) IBOutlet UILabel *musicName;//音乐名
@property (nonatomic ,strong)MusicModel * model;
@end
