//
//  TimerViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "TimerViewController.h"
#import "DockItem.h"
#import "ShareHandle.h"

#define kTitleRation 0.3
#define kImageRation 0.7

typedef NS_ENUM(NSInteger, kTTCounter){
    kTTCounterRunning = 0,
    kTTCounterStopped,
    kTTCounterReset,
    kTTCounterEnded
};


@interface TimerViewController ()

@end

@implementation TimerViewController

+ (TimerViewController *)shareInstance{
    static TimerViewController * share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate ,^{
        
        share = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"timeVC"];
    });
    
    return share;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetButton:self.first];
    [self addLabel:self.first withTime:@"15分钟"];
    [self resetButton:self.second];
    [self addLabel:self.second withTime:@"30分钟"];
    [self resetButton:self.third];
    [self addLabel:self.third withTime:@"45分钟"];
    [self resetButton:self.fourth];
    [self addLabel:self.fourth withTime:@"60分钟"];
    
}


- (void)resetButton:(UIButton *)button{
    UIImage * image = [UIImage imageNamed:@"clock.png"];
    UIImage * image1 = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    button.showsTouchWhenHighlighted = YES;
    CGFloat titleX = 0;
    CGFloat titleHeight = button.frame.size.height * kImageRation;
    CGFloat titleY = button.frame.size.width / 2;
    CGFloat titleWidth = button.frame.size.width;
    
    [button.layer setBorderWidth:1.0];
    
    [button imageRectForContentRect:CGRectMake(titleX, titleY, titleWidth, titleHeight)];
    [button setImage:image1 forState:UIControlStateNormal];
    
}


- (void)addLabel:(UIButton *)button withTime:(NSString *)time{
    
    CGFloat titleX = 0;
    CGFloat titleHeight = button.frame.size.height * kImageRation;
    CGFloat titleY = button.frame.size.width / 2 + 5;
    CGFloat titleWidth = button.frame.size.width;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleWidth, titleHeight)];
    
    CGPoint point = button.imageView.center;
    point.y = point.y + button.imageView.frame.size.height / 2 + 10;
    
    label.center = point;
    label.text = time;
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    
}


- (IBAction)setTime:(UIButton *)sender {
    
    UIButton * button = (UIButton *)[self.view viewWithTag:_buttonTag];
    
    [button setBackgroundColor:[UIColor whiteColor]];
    
    sender.backgroundColor = [UIColor purpleColor];
    
    _buttonTag = sender.tag;
    
    self.timeToClose.text = [NSString stringWithFormat:@"%ld" , sender.tag];
    
    [self resetTapped];
    
    if (self.timeToClose.isRunning) {
        [self.timeToClose stop];
        [self updateUIForState:kTTCounterRunning];
    }else{
        [self.timeToClose start];
        [self updateUIForState:kTTCounterRunning];
    }
    ShareHandle * handle = [ShareHandle shareHandle];
    handle.timeSet = sender.tag * 1000 * 60;
//    NSLog(@"sender.tag = %ld" , sender.tag);
//    NSLog(@"handle.timeSet = %ld" , handle.timeSet);
    
}


#pragma mark   取消定时
- (IBAction)cancleTimeSet:(UIButton *)sender {
    
    [self resetTapped];
    
}


- (void)resetTapped{
    
    [self.timeToClose reset];
    [self updateUIForState:kTTCounterReset];
    
}

- (void)updateUIForState:(NSInteger)state {

}



#warning mark  不懂
/*
- (void)resetButtonLabel{
    
    CGFloat titleX = 0;
    CGFloat titleHeight = self.second.frame.size.height * kTitleRation;
    CGFloat titleY = self.second.frame.size.height - titleHeight;
    CGFloat titleWidth = self.second.frame.size.width;
    self.second.titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    self.second.titleLabel.text = @"sjzbkojnblk";
    self.second.titleLabel.hidden = NO;
    self.second.titleLabel.backgroundColor = [UIColor redColor];
    NSLog(@"%@" , NSStringFromCGRect(self.second.titleLabel.frame));
    
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
