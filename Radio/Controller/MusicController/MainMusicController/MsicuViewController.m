//
//  ContainerViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "MsicuViewController.h"
#import "FeaturedCollectionViewController.h"
#import "HostViewController.h"
@interface MsicuViewController ()

@property (nonatomic,strong)FeaturedCollectionViewController * featureCVC ;
@property (nonatomic ,strong)HostViewController * allMusicVC;

@end

@implementation MsicuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建音乐界面
    self.featureCVC = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"featured_Id"];
    //将精选页面添加到音乐
    [self addChildViewController:self.featureCVC];
    [self.view addSubview:self.featureCVC.view];
    
    //创建全部页面
    
    self.allMusicVC =[[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"allMusic_Id"];
    //将全部页面添加到音乐上
    [self addChildViewController:self.allMusicVC];
#warning mark----如果将两个页面都添加的话会出现第一个页面出不来
//    [self.view addSubview:self.allMusicVC.view];
    
    //将某一个页面设置为默认的页面
#warning mark----如果写这一句，就会先出现容器视图控制器的View（当点击回来的时候才会出现呢第一个页面）
//    [self.view bringSubviewToFront:self.featureCVC.view];
}

#pragma mark-------当点击的的时候切换页面
- (IBAction)changeController:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            if (self.featureCVC.view.superview == nil) {
                [self.allMusicVC.view removeFromSuperview];
                [self.view addSubview:self.featureCVC.view];
            }
            break;
        }
        case 1:{
            if (self.allMusicVC.view.superview == nil) {
                [self.featureCVC.view removeFromSuperview];
                [self.view addSubview:self.allMusicVC.view];
                
            }
            break;
        }
            
        default:
            break;
    }
    
    
    
    
}


@end
