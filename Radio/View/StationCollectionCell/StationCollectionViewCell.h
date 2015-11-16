//
//  StationCollectionViewCell.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserDetailModel.h"

@interface StationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong , nonatomic) UserDetailModel * model;

@end
