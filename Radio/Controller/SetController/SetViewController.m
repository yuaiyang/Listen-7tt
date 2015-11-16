//
//  SetViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/20.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "SetViewController.h"
#import "SetTableViewCell.h"
#import "ShareHandle.h"
#import "WdCleanCaches.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "TimerViewController.h"
#import "AboutUsViewController.h"
#import "WelcomeViewController.h"

@interface SetViewController () <UITableViewDataSource , UITableViewDelegate>

@property (strong , nonatomic) NSArray * listArray; //存放下面三个数组的数组
@property (strong , nonatomic) NSArray * cellListArray1;//存放第一个分区的数组名
@property (strong , nonatomic) NSArray * cellListArray2;//存放第二个分区的数组名
@property (strong , nonatomic) NSArray * cellListArray3;//存放第三个分区的数组名
@property (strong , nonatomic) NSString * cacheFile;
@property (assign , nonatomic) double cacheSize;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self readJson];
//    [self AFNetworking];
    
//    [[ShareHandle shareHandle] queryDB];
    
    
    
    self.setTableView.delegate = self;
    self.setTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.setTableView.backgroundColor = [UIColor whiteColor];
    
    [self addData];
    [self registerCell];
//    [self cleanCache];
    
//    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)addData{
    self.cellListArray1 = @[@"使用移动流量收听"];
    self.cellListArray2 = @[@"定时关闭",@"清除缓存"];
    self.cellListArray3 = @[@"进入欢迎页",@"关于我们"];
    self.listArray = [NSArray arrayWithObjects:_cellListArray1,_cellListArray2,_cellListArray3, nil];
}
//注册cell
- (void)registerCell{
    
    UINib * nib = [UINib nibWithNibName:@"SetTableViewCell" bundle:nil];
    [self.setTableView registerNib:nib forCellReuseIdentifier:@"setCell"];
    
}
#pragma mark------tableView的代理协议方法
//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
//每个分区多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray[section] count];
}
//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ShareHandle * handle = [ShareHandle shareHandle];
    
    if (indexPath.section == 0) {
        SetTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"setCell"];
        cell.setLabel.text = self.listArray[indexPath.section][indexPath.row];
        
        switch (indexPath.row) {
            case 0:
            {
                
                cell.isOn.tag = 10;
                //获取NSUserDefaults单例类的对象
                NSUserDefaults * dd = [NSUserDefaults standardUserDefaults];
                //根据key值取出dd中的 BOOL值
                BOOL isOn = [dd boolForKey:@"isUseMobelListen"];
                cell.isOn.on = isOn;
                break;
            }
            case 1:
            {
                cell.isOn.tag = 11;
                NSUserDefaults * dd = [NSUserDefaults standardUserDefaults];
                BOOL isOn = [dd boolForKey:@"isUseMobelDownLoade"];
                cell.isOn.on = isOn;

                break;
            }
            case 2:
            {
                cell.isOn.tag = 12;
                NSUserDefaults * dd = [NSUserDefaults standardUserDefaults];
                BOOL isOn = [dd boolForKey:@"isPlayWithOn"];
                cell.isOn.on = isOn;
                break;
            }
            default:
                break;
        }
        
        
        return cell;
    }else{
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            
        }
        
        if (indexPath.section == 1 && indexPath.row == 1) {
            
            
//            [WdCleanCaches CachesDirectory];
            //缓存的大小
            double size = [WdCleanCaches sizeWithFilePaht:[WdCleanCaches CachesDirectory]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM" , size];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        }
        
        if (indexPath.section == 2 && indexPath.row == 0) {
//            cell.detailTextLabel.text = @"当前版本V1.0.0";
//            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        }
        
        
        cell.textLabel.text = self.listArray[indexPath.section][indexPath.row];
        return cell;
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //是否选中某行
    [self.setTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //定时器界面
    if (indexPath.section == 1 && indexPath.row == 0) {
//        TimerViewController * timeVC1 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"timeVC"];
        TimerViewController * timeVC1 = [TimerViewController shareInstance];
        
        [self.navigationController pushViewController:timeVC1 animated:YES];
        
    }
#pragma mark   清除缓存
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self cleanCache];//清除缓存
        [self.setTableView reloadData];//刷新数据
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
//        进入关于我们页面
        AboutUsViewController * aboutVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"aboutusVC"];
        [self.navigationController pushViewController:aboutVC animated:YES];
        
        
    }
//   进入欢迎也页面
    if (indexPath.section == 2 && indexPath.row == 0) {
        WelcomeViewController * welcomeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"welcomeVC"];
        [self presentViewController:welcomeVC animated:YES completion:nil];
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.view.frame.size.width > 350) {
        return 55;
    }else{
        return 45;
    }

}


#pragma mark  清除缓存
- (void)cleanCache{
    //获取缓存文件路径
    self.cacheFile = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
 //缓存文件的大小
    self.cacheSize = [WdCleanCaches sizeWithFilePaht:self.cacheFile];
    //清除缓存
    [WdCleanCaches clearCachesWithFilePath:self.cacheFile];
    
    
//    NSLog(@"self.cacheSize = %f" , self.cacheSize);
    
}



- (void)AFNetworking{
    
    NSURL * url = [NSURL URLWithString:@"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?imei=ODY0MjA1MDIyMTE4NzU2&pageNum=0&pageSize=500&q=12008&sc=a1f3d224e3b019da9e6da5970ff55055&token=81twcUV0-MXYGCcztXFScmnk2J9RXt4kMb9vJH6cMCkUnlsqo22JjPNsriJgVtgDNX9jTjFwJcg*&type=1015"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *html = operation.responseString;
        
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
//        NSLog(@"获取到的数据为：%@",dict);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"发生错误！%@",error);
        
    }];
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
