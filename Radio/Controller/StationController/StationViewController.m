//
//  StationViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "StationViewController.h"
#import "StationCollectionViewCell.h"
#import "Urls.h"
#import "AFHTTPRequestOperation.h"
#import "ListModel.h"
#import "UserDetailModel.h"
#import "PlayViewController.h"
#import "ShareHandle.h"
@interface StationViewController () <UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *stationCollectionView;

@property (strong , nonatomic) UICollectionViewFlowLayout * layout;
@property (strong , nonatomic) NSMutableArray * headerKey; // 保存区头
@property (strong , nonatomic) NSMutableArray * listArray; // 保存外层数据
@property (strong , nonatomic) NSMutableArray * userDetailArray; // 内层user详解
@property (assign , nonatomic) NSInteger tagCount;
@property (assign , nonatomic) NSInteger nextValur;




@end

@implementation StationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stationCollectionView.dataSource = self;
    self.stationCollectionView.delegate = self;
    self.stationCollectionView.minimumZoomScale = 10;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.nextValur = 102;
    self.title = @"个人电台";
    self.tagCount = 100;
    
    [self AFNetworking];
    
    [self registerCell];
    
    [self registerHeader];
    
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 10;
    self.layout.minimumLineSpacing  = 10;
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
    
    [[ShareHandle shareHandle] netType];
}

// 注册区头
- (void)registerHeader{
    [self.stationCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

- (void)registerCell{
    
    UINib * nib = [UINib nibWithNibName:@"StationCollectionViewCell" bundle:nil];
    [self.stationCollectionView registerNib:nib forCellWithReuseIdentifier:@"stationCell"];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_userDetailArray.firstObject count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stationCell" forIndexPath:indexPath];
    
    cell.model = _userDetailArray[indexPath.section][indexPath.row];
    
    return cell;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _listArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat imgW = self.view.frame.size.width / 3 - 8;
    CGSize size = CGSizeMake(imgW, imgW * 10/9);
    return size;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)AFNetworking{
    
    NSURL * url = [NSURL URLWithString:kPersonalStation];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    __weak StationViewController * VC = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *html = operation.responseString;
        
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary * dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSArray * array = [dict valueForKey:@"data"];
        
        for (NSDictionary * dic in array) {
            
            [VC.headerKey addObject:[dic valueForKey:@"category_name"]];
            
            ListModel * model = [[ListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [VC.listArray addObject:model];
            NSArray * detailArray = [dic valueForKey:@"user_list"];
            // 解析出user详情  方便使用
            
            NSMutableArray * array1 = [NSMutableArray array];
            for (NSDictionary * userDetail in detailArray) {
                
                
                UserDetailModel * userModel = [[UserDetailModel alloc] init];
                [userModel setValuesForKeysWithDictionary:userDetail];
                [array1 addObject:userModel];
                
            }
            [VC.userDetailArray addObject:array1];
            
        }
        
        [self.stationCollectionView reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"发生错误！%@",error);
        
    }];
    
    
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}

#pragma mark ---- 设置区头 ----
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 重用集合中去取 是否有可用的header
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        
        // 添加label
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width * 0.6, headerView.frame.size.height - 10)];
        label.backgroundColor = [UIColor whiteColor];
//        label.text = model.user_nick;
        label.text = _headerKey[indexPath.section];
        label.font = [UIFont systemFontOfSize:14.0];
        [headerView addSubview:label];
        
        //添加那条 横线---------
        UILabel * labley = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) -8, self.view.frame.size.width, 1)];
        labley.backgroundColor = [UIColor darkGrayColor];
        [headerView addSubview:labley];

 
        return headerView;
        
    }
    return nil;
}



#pragma mark   还没有实现
- (void)click:(UIButton *)button{
//    NSLog(@"%ld" , button.tag);
    
}


#pragma mark  ---- 点击事件 ----
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayViewController *playVC = [PlayViewController shareInstance];
    playVC.indexPath = indexPath.row;
    
    
    playVC.section = indexPath.section;
    
    
    
    
    playVC.stationModel = _userDetailArray[indexPath.section][indexPath.row];
    
    playVC.stationID = (NSInteger)[[playVC.stationModel valueForKey:@"is_vip"] valueForKey:@"uid"];
    
    playVC.fromLastValue = self.nextValur;
    
    [self showViewController:playVC sender:nil];
    
}


#pragma mark ---- 设置区头的高度 ----
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(self.view.frame.size.width, 50);
    
}


#pragma mark  ----懒加载区域----
- (NSMutableArray *)headerKey{
    if (!_headerKey) {
        _headerKey = [NSMutableArray array];
    }
    return _headerKey;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)userDetailArray{
    if (!_userDetailArray) {
        _userDetailArray = [NSMutableArray array];
    }
    return _userDetailArray;
}

@end
