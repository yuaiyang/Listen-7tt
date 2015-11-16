//
//  CollectedViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/25.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "CollectedViewController.h"
#import "CollectTableViewCell.h"
#import "ShareHandle.h"
#import "DownLoadController.h"
#import "PlayViewController.h"
#import "ShareHandle.h"
#import "MusicListModel.h"
#import "bookPlayModel.h"
#import "StationListModel.h"
#import "LiveModel.h"
#import "RadioPlayViewController.h"
#import "ShareHandle.h"
@interface CollectedViewController () <UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *collectedTableView;

@property (strong , nonatomic) NSArray * headerArray;

@property (nonatomic ,assign)NSInteger  tag;
@end

@implementation CollectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectedTableView.dataSource = self;
    self.collectedTableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self registerCell];
    
    self.headerArray = @[@"我的音乐",@"我的电台",@"我的小说",@"我的直播"];
    
//    ShareHandle * handle = [ShareHandle shareHandle];
  
//    [handle queryDBWithTag:100];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectedTableView reloadData];
   
        [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
        
        [[ShareHandle shareHandle] netType];
    
}


#pragma mark   实现tableView协议区

- (void)registerCell{
    
    UINib * nib = [UINib nibWithNibName:@"CollectTableViewCell" bundle:nil];
    [self.collectedTableView registerNib:nib forCellReuseIdentifier:@"collectCell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ShareHandle * handle = [ShareHandle shareHandle];
//    [handle queryDBWithTag:100];
    
    if (section == 0) {
//        [handle queryDBWithTag:100];
        [handle queryDBWithTags:100];
        
        return [handle.musicArray count];
        
    }else if(section == 1){
        [handle queryDBWithTags:1000];
        return [handle.stationArray count];
        
    }else if (section == 2){
//        [handle queryDBWithTag:101];
        [handle queryDBWithTags:101];
        return [handle.bookArray count];
    }else{
        [handle queryLiveModel];
    return handle.liveArray.count;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareHandle * handle = [ShareHandle shareHandle];

    
    CollectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"collectCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        //音乐
//        [handle queryDBWithTag:100];
        [handle queryDBWithTags:100];
        cell.musicModel = handle.musicArray[indexPath.row];
        [cell setData];
        return cell;
    }else if (indexPath.section == 1){
        
        [handle queryDBWithTags:1000];
        cell.stationModel = handle.stationArray[indexPath.row];
        [cell setStationData];
        
        return cell;
    }else if (indexPath.section == 2){
        //小说
//        [handle queryDBWithTag:101];
        [handle queryDBWithTags:101];
        cell.bookModel = handle.bookArray[indexPath.row];
        cell.posterImage.image = [UIImage imageNamed:@"bookPlaceHolder.jpg"];
        [cell setBookData];
        return cell;
    }else{
        
        [handle queryLiveModel];
        cell.liveModel = handle.liveArray[indexPath.row];
        [cell setLiveModelData];
        return cell;
    }
    
    
    return cell;
    
}


#pragma mark---------TableView代理协议中的方法-----------
//设置分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
//设置行数
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.headerArray[section];
}
//设置Cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80.0;
}
//推出下一级
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark-----音乐
if (indexPath.section == 0){
//        NSLog(@"播放音乐");
        //点击进入播放界面
        PlayViewController * playVC = [PlayViewController shareInstance];
       NSArray * array =  [[ShareHandle shareHandle] queryDBWithTags:100];
        MusicListModel * model = array[indexPath.row];
        
        playVC.fromLastValue = 100;

        playVC.indexPath = indexPath.row;
        playVC.Url = model.urlString;
        playVC.ID = 201;
        
        //推出音乐播放界面
        [self showViewController:playVC sender:nil];
   
    }else if (indexPath.section == 1){
        #pragma mark-----电台
        NSArray * array = [[ShareHandle shareHandle] queryDBWithTags:1000];
        StationListModel * stationModel = array[indexPath.row];
        
        PlayViewController * playVC = [PlayViewController shareInstance];
        playVC.indexPath = indexPath.row;
        playVC.Url = stationModel.urlString;
        playVC.ID = 202;
        [self showViewController:playVC sender:nil];
        
        
    }else if (indexPath.section == 2){
        #pragma mark-----小说
        PlayViewController * playVC = [PlayViewController shareInstance];
        //从数据库中将值去除
        NSArray * array =  [[ShareHandle shareHandle] queryDBWithTags:101];
        bookPlayModel * model = array[indexPath.row];
        
        playVC.fromLastValue = 101;
       
        playVC.indexPath = indexPath.row;
        playVC.Url = model.urlString;
        playVC.ID = 203;
        
        [self showViewController:playVC sender:nil];

    }else{
       #pragma mark-----直播
       
        RadioPlayViewController * radioPVC = [RadioPlayViewController shareInstance];
        NSArray * array = [[ShareHandle shareHandle] queryLiveModel];
        radioPVC.indexPath = indexPath.row;
        LiveModel * model = array[indexPath.row];
        radioPVC.model = model;
        
        [self showViewController:radioPVC sender:nil];
//        NSLog(@"直播中");
    }
    
}



#pragma mark   uitableview的删除操作
// 让tableView处于可编辑状态
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [_collectedTableView setEditing:editing animated:animated];
}

// 让指定分区的行是否可以被编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

// 设置指定分区是什么编辑类型
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

// 提交编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareHandle * handle = [ShareHandle shareHandle];
    switch (indexPath.section) {
        case 0:
        {
            NSArray * array =  [handle queryDBWithTags:100];
            NSString * str = [array[indexPath.row] urlString];
            [handle deleteMusicDBWithUrl:str];
            
            [self.collectedTableView reloadData];
            [handle.database close];
            break;
        }
        case 1:
        {
            NSArray * array =  [handle queryDBWithTags:102];
            NSString * str = [array[indexPath.row] urlString];
            [handle deleStationDBWithUrl:str];
            [self.collectedTableView reloadData];
            [handle.database close];
            break;
        }
        case 2:
        {
            NSArray * array =  [handle queryDBWithTags:101];
            NSString * str = [array[indexPath.row] urlString];
            [handle deleBookDBWithUrl:str];
            [self.collectedTableView reloadData];
            [handle.database close];
            break;
        }
        case 3:
        {
            NSArray * array =  [handle queryLiveModel];
            NSString * str = [array[indexPath.row] liveName];
            [handle deleLiveDBWithUrl:str];
            [self.collectedTableView reloadData];
            [handle.database close];
            break;
        }
        default:
            break;
    }
    
    
    
}



#pragma mark  懒加载区域
- (NSArray *)headerArray{
    if (!_headerArray) {
        _headerArray = [NSArray array];
    }
    return _headerArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
