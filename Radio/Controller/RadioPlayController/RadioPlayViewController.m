//
//  RadioPlayViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/27.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "RadioPlayViewController.h"
#import "PlayMusicManager.h"
#import "UIImageView+WebCache.h"
#import "Urls.h"
#import "AFHTTPRequestOperation.h"
#import "LiveModel.h"
#import "ShareHandle.h"
@interface RadioPlayViewController ()

@property (weak, nonatomic) IBOutlet UILabel *onlineNumber;//在线人数

@property (weak, nonatomic) IBOutlet UILabel *showStartTimeLable;//是否直播中

@property (weak, nonatomic) IBOutlet UIImageView *radioImageView;//直播图片

@property (weak, nonatomic) IBOutlet UILabel *liveNameLable;//直播名字

@property (weak, nonatomic) IBOutlet UILabel *comperesLable;//主播

- (IBAction)playOrPause:(UIButton *)sender;//暂停或者播放

@property (nonatomic ,assign)NSInteger currentIndex;//公共直播的下标
@property (nonatomic ,assign)NSInteger currentIndexPrivate;//私人直播的index
@property (nonatomic ,strong)LiveModel * liveModel;//用于接收传过来的Model

- (IBAction)SaveButton:(UIBarButtonItem *)sender;//保存





@end

@implementation RadioPlayViewController

+ (RadioPlayViewController *)shareInstance{
    static RadioPlayViewController * share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate ,^{
        
        share = [[UIStoryboard storyboardWithName:@"Four" bundle:nil] instantiateViewControllerWithIdentifier:@"RadioPlay_Id"];
        
    });
    
    return share;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //解析数据
//    [self readLoadData];
    
//    [PlayMusicManager shareInstance].delegate = self;
    self.currentIndex = -1;
    self.currentIndexPrivate = -1;
    self.tagsController = 1000;
}

#pragma mark-------页面即将出现的时候，播放当前Model对应的歌曲
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tags == 101) {
        if (self.currentIndex == self.indexPath) {
            if (self.tags != 102) {
                [self playMusic];
            }
            return;//如果现在点击的下标和当前正在播放的相同直接返回
        }
        [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
        
        [[ShareHandle shareHandle] netType];
        //如果不同，调用方法播放音乐
        [self playMusic];
    }else if (self.tags == 102){
        if (self.currentIndexPrivate == self.indexPath) {
            if (self.tags != 101) {
                [self playMusic];
            }
            return;//如果现在点击的下标和当前正在播放的相同直接返回
        }
        [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
        
        [[ShareHandle shareHandle] netType];
        //如果不同，调用方法播放音乐
        [self playMusic];
    }

    
}



//    [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
//    
//    [[ShareHandle shareHandle] netType];
//

#pragma mark-------播放音乐
- (void)playMusic{
 //根据属性传值。将传过来的线标，赋给重新点击后的音乐下标
   
    if (self.tags == 101) {
        self.currentIndex = self.indexPath;
        //
    }else if (self.tags == 102){
        self.currentIndexPrivate = self.indexPath;
        //
    }

 //根据MP3Url网址信息  准备播放音乐
    [[PlayMusicManager shareInstance] preparePlayMusicWithMp3Url:self.model.liveUrl];
 //设置当前播放音乐的背景图片
    [self.radioImageView sd_setImageWithURL:[NSURL URLWithString:self.model.livePic]];

    self.showStartTimeLable.text = self.model.showStartTime;
    self.onlineNumber.text = [NSString stringWithFormat:@"%ld",(long)self.model.onLineNum];
    self.comperesLable.text = self.model.comperes;
    self.liveNameLable.text = self.model.liveName;
}
/*
//#pragma mark----解析数据-----
//- (void)readLoadData{
//    
//    NSURL * url = [NSURL URLWithString:kLiveDetailUrls(self.model.programId)];
//    NSLog(@"#############  %@",kLiveDetailUrls(self.model.programId));
//    
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString * html = operation.responseString;
//        NSData * data = [html dataUsingEncoding:NSUTF8StringEncoding];
//        id dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSMutableDictionary * dict = dic[@"result"];
//        LiveModel * model = [[LiveModel alloc] init];
//        [model setValuesForKeysWithDictionary:dict];
//        
//        self.liveModel = model;
//        
//        
//    
//        NSLog(@"====%@",model);
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       
//        NSLog(@"====%@",error);
//    }];
//    
//    
//    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:operation];
//
//    
//    
//}

*/
#pragma mark------暂停或者播放------
- (IBAction)playOrPause:(UIButton *)sender {
    if (sender.selected == YES) {
        
        [sender setTitle:@"" forState:(UIControlStateNormal)];
        [[PlayMusicManager shareInstance]playMusic];
        sender.selected = NO;
        
    }else{
        [sender setTitle:@"" forState:(UIControlStateNormal)];
        [[PlayMusicManager shareInstance] pauseMusic];
        sender.selected = YES;
        
    }
    
    
}

#pragma mark-------收藏------------------
- (IBAction)SaveButton:(UIBarButtonItem *)sender {
//    NSLog(@"首先轩昂");
    
    ShareHandle * handle = [ShareHandle shareHandle];
    [handle creatDB];
    [handle collectedLiveWithModel:self.model];
    [self showAlertView];
}

- (void)showAlertView{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    [self dismissAlerView:alertView];
}

- (void)dismissAlerView:(UIAlertView *)alertView {
    
    [alertView dismissWithClickedButtonIndex:1 animated:YES];
}

@end
