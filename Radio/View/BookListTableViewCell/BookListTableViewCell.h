//
//  BookListTableViewCell.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookListModel.h"
@interface BookListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *bookName;

@property (weak, nonatomic) IBOutlet UILabel *playTimes;

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;

@property (strong , nonatomic) BookListModel * model;

@end
