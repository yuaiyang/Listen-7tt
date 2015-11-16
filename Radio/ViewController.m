//
//  ViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/20.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "ViewController.h"
#import "MsicuViewController.h"
#import "LiveContainerViewController.h"
#import "SetViewController.h"
#import "StationViewController.h"
#import "LisetnBookViewController.h"
#import "CollectedViewController.h"
#import "PlayMusicManager.h"
#import "PlayViewController.h"
#import "RadioPlayViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *listenBook;//听书

@property (weak, nonatomic) IBOutlet UIButton *liveButton;//直播

@property (weak, nonatomic) IBOutlet UIButton *saveButton;//收藏
@property (weak, nonatomic) IBOutlet UIButton *setButton;//设置
@property (weak, nonatomic) IBOutlet UIButton *radioButton;//电台
@property (weak, nonatomic) IBOutlet UIButton *musicButton;//音乐

@property (weak, nonatomic) IBOutlet UIView *buttonView;//放button的背景图片

@property (weak, nonatomic) IBOutlet UIButton *ownerButton;


@property (nonatomic ,assign)BOOL isShow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShow = YES;
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]]];
    UIImageView * backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image = [UIImage imageNamed:@"back.png"];
    [self.view addSubview:backView];
    backView.userInteractionEnabled = YES;
    
    self.buttonView.layer.cornerRadius = self.buttonView.frame.size.width/2;
    self.buttonView.layer.masksToBounds = YES;
//    [self.view bringSubviewToFront:_buttonView];
    [self.view bringSubviewToFront:self.buttonView];
    //听书
    self.listenBook.layer.cornerRadius = self.listenBook.frame.size.width/2;
    self.listenBook.layer.masksToBounds = YES;
    //直播
    self.liveButton.layer.cornerRadius = self.liveButton.frame.size.width/2;
    self.liveButton.layer.masksToBounds = YES;
    //收藏
    self.saveButton.layer.cornerRadius = self.saveButton.frame.size.width/2;
    self.saveButton.layer.masksToBounds = YES;
    //设置
    self.setButton.layer.cornerRadius = self.setButton.frame.size.width/2;
    self.setButton.layer.masksToBounds = YES;
    //电台
    self.radioButton.layer.cornerRadius = self.radioButton.frame.size.width/2;
    self.radioButton.layer.masksToBounds = YES;
    //音乐
    self.musicButton.layer.cornerRadius = self.musicButton.frame.size.width/2;
    self.musicButton.layer.masksToBounds = YES;
    [self.musicButton layoutIfNeeded];
    //控制按钮
    
    self.ownerButton.layer.cornerRadius = self.ownerButton.frame.size.width/2;
    self.ownerButton.layer.masksToBounds = YES;
    [self.view bringSubviewToFront:_ownerButton];
    [self.ownerButton layoutIfNeeded];
    //定时器
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(circleAction) userInfo:nil repeats:YES];
#pragma mark-----隐藏导航栏------
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(click)];
    self.navigationItem.rightBarButtonItem = item;
    UIImage *image = [UIImage imageNamed:@"noBack.jpg"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    
 
    
}

#pragma mark----实现定时器的方法----
- (void)circleAction{
    
    //每1s旋转一个
    self.buttonView.transform = CGAffineTransformRotate(self.buttonView.transform, M_PI/360);
    
    
}



#pragma mark----点击听书按钮
- (IBAction)clickListenButton:(UIButton *)sender {
    self.tagsCon = 1000;
//       [[PlayMusicManager shareInstance] removeOberser];
    LisetnBookViewController * listenVC = [[UIStoryboard storyboardWithName:@"Two" bundle:nil] instantiateViewControllerWithIdentifier:@"listenVC"];
    [self.navigationController pushViewController:listenVC animated:YES];
    
    
}

#pragma mark----点击直播按钮（侯晓兰）
- (IBAction)clickLiveButton:(UIButton *)sender {
//    [[PlayMusicManager shareInstance] removeOberser];
    self.tagsCon = 1001;
    LiveContainerViewController * liveCVC = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"liveViewController_Id"];
    [self showViewController:liveCVC sender:nil];
    
    
    
}
#pragma mark---点击收藏按钮
- (IBAction)clickSaveButton:(UIButton *)sender {
    
    CollectedViewController * collectVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"collecteVC"];
    [self.navigationController pushViewController:collectVC animated:YES];
    
    
}
#pragma mark----点击设置按钮
- (IBAction)clickSettingButton:(UIButton *)sender {
    
    SetViewController * liveCVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"setVC"];
    [self.navigationController pushViewController:liveCVC animated:YES];
    
}
#pragma mark----点击电台按钮
- (IBAction)clickRadioButton:(UIButton *)sender {
    self.tagsCon = 1000;
    
    StationViewController * stationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"stationVC"];
    [self.navigationController pushViewController:stationVC animated:YES];
    
}
#pragma mark---点击音乐按钮（侯晓兰）
- (IBAction)clickMusicButton:(UIButton *)sender {
    self.tagsCon = 1000;
    
    MsicuViewController * containerVC = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"music_Id"];
    [self showViewController:containerVC sender:nil];
    
    
}

#pragma mark-----点击中间按钮
- (IBAction)clickOwnerButton:(UIButton *)sender {
    
    if (self.isShow == NO) {
        
        self.buttonView.hidden = NO;
        self.isShow = YES;
        
    }else{
   
//        [[PlayMusicManager shareInstance] playMusic];
        if (self.tagsCon == 1000) {
            PlayViewController * playVC = [PlayViewController shareInstance];
            playVC.tagsController = self.tagsCon;
            [self.navigationController pushViewController:playVC animated:YES];
        }else if (self.tagsCon == 1001){
            RadioPlayViewController * radioVC = [RadioPlayViewController shareInstance];
            radioVC.tagsController = self.tagsCon;
            [self.navigationController pushViewController:radioVC animated:YES];
        }
//
        
        
        
        self.isShow = YES;
//        self.buttonView.hidden = YES;
//        self.isShow = NO;
    }
    
    
    
    
}






@end
