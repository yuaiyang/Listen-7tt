//
//  PrivateCollectionViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "PrivateCollectionViewController.h"
#import "PrivateCollectionViewCell.h"
#import "LiveModel.h"
#import "Urls.h"
#import "AFHTTPRequestOperationManager.h"
#import "RadioPlayViewController.h"
#import "ShareHandle.h"

@interface PrivateCollectionViewController ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSMutableArray * privateModelsArray;
@end

@implementation PrivateCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
   //注册Cell
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"coll_cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PrivateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"privatecoll_cell"];
    //解析数据
    [self requestData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
    
    [[ShareHandle shareHandle] netType];
}

//解析数据  responseObject为要解析的数据
- (void)requestData{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kPrivateUrls parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
//        NSMutableDictionary * dic = responseObject[@"detail"];
//        NSLog(@"%@",dic);
//        NSMutableDictionary * dict = dic[@"result"];
//        NSArray * array = dict[@"dataList"];
//        self.privateModelsArray = [NSMutableArray array];
//        for (NSMutableDictionary * dict1 in array) {
//            LiveModel * model = [[LiveModel alloc] init];
//            [model setValuesForKeysWithDictionary:dict1];
//            [self.privateModelsArray addObject:model];
//            
//        }
//        
//        [self.collectionView reloadData];
        */
        NSMutableDictionary * dic = responseObject;//这个是解析数据的最外层
        NSMutableDictionary * dict = dic[@"result"];
        NSArray * array = dict[@"dataList"];
        self.privateModelsArray = [NSMutableArray array];
        for (NSMutableDictionary * dict1 in array) {
            LiveModel * model = [[LiveModel alloc] init];
            [model setValuesForKeysWithDictionary:dict1];
            [self.privateModelsArray addObject:model];
                    
        }

//        NSLog(@"%@ ===== %ld",self.privateModelsArray,self.privateModelsArray.count);
//        NSLog(@"%@",responseObject);
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
//        NSLog(@"Error:%@",error);
    }];
    
    
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return self.privateModelsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PrivateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"privatecoll_cell" forIndexPath:indexPath];
    

//    cell.contentView.backgroundColor = [UIColor redColor];
    LiveModel * model = self.privateModelsArray[indexPath.row];
    cell.model = model;
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width / 2- 40, 180);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(40, 30, 10, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RadioPlayViewController * radioPVC = [RadioPlayViewController shareInstance];
    LiveModel * model = self.privateModelsArray[indexPath.row];
    radioPVC.model = model;
    radioPVC.indexPath = indexPath.row;
    radioPVC.tags = 102;
    [self showViewController:radioPVC sender:nil];
    
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
