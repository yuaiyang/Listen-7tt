//
//  SetTableViewCell.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/20.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *setLabel;

@property (weak, nonatomic) IBOutlet UISwitch *isOn;

@property (strong , nonatomic) NSString * personalSet;

@end
