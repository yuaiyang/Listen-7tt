//
//  MusicCollectionViewCell.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;

@interface MusicCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *musicPicture;//音乐图片

@property (weak, nonatomic) IBOutlet UILabel *albumNameLable;//唱片名

@property (weak, nonatomic) IBOutlet UILabel *rnameLable;//唱片的简介名


@property (nonatomic ,strong)MusicModel * model;





@end
