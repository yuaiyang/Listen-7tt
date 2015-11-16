//
//  LiveContainerViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "LiveContainerViewController.h"
#import "CommonalityTableViewController.h"
#import "PrivateCollectionViewController.h"
@interface LiveContainerViewController ()
@property (nonatomic ,strong)CommonalityTableViewController * commonalityTVC;

@property (nonatomic ,strong)PrivateCollectionViewController * privateCVC ;
@end

@implementation LiveContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加公共电台页面到控制器
     self.commonalityTVC= [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"commonality_Id"];
    [self addChildViewController:self.commonalityTVC];
    [self.view addSubview:self.commonalityTVC.view];
    
    //添加私人直播到控制器
    self.privateCVC= [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"private_Id"];
    [self addChildViewController:self.privateCVC];
    
    
   
}

#pragma mark--------当点击segementControll的时候实现控制器的切换
- (IBAction)changeControllers:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:{
            if (self.commonalityTVC.view.superview == nil) {
                [self.privateCVC.view removeFromSuperview];
                [self.view addSubview:self.commonalityTVC.view];
            }
            break;
        }
        case 1:{
            if (self.privateCVC.view.superview == nil) {
                [self.commonalityTVC.view removeFromSuperview];
                [self.view addSubview:self.privateCVC.view];
                
            }
            break;
        }
            
        default:
            break;
    }
    
    
    
    
}






@end
