//
//  PrivateCollectionViewCell.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveModel;
@interface PrivateCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *listenNumber;//收听人数

@property (weak, nonatomic) IBOutlet UILabel *nameLable;//谁的主播


@property (weak, nonatomic) IBOutlet UILabel *ownerLable;//主播

@property (nonatomic,strong)LiveModel * model;


@end
