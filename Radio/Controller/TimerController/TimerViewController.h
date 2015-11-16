//
//  TimerViewController.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTCounterLabel.h"
@interface TimerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *first;
@property (weak, nonatomic) IBOutlet UIButton *second;
@property (weak, nonatomic) IBOutlet UIButton *third;
@property (weak, nonatomic) IBOutlet UIButton *fourth;
@property (assign , nonatomic) NSInteger buttonTag;
@property (strong , nonatomic) IBOutlet TTCounterLabel * timeToClose;

+ (TimerViewController *)shareInstance;


@end
