//
//  MusicCollectionViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "FeaturedCollectionViewController.h"
#import "FeaturedCollectionViewCell.h"
#import "MusicCollectionViewCell.h"
#import "HeaderCollectionViewCell.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"
#import "PlayViewController.h"
#import "Urls.h"
#import "ShareHandle.h"


@interface FeaturedCollectionViewController ()<UICollectionViewDelegateFlowLayout,HeaderCollectionViewCellDelegate>
@property (nonatomic ,strong)UICollectionViewFlowLayout * layout;//布局
@property (nonatomic,strong)NSMutableArray * sectionsArray;//存储有几个分区
@property (nonatomic ,strong)NSMutableArray * headerModelsArray;//存储头部轮播的数据
@property (nonatomic,strong)NSMutableArray * arrays;//存放数组的数组
@property (nonatomic , assign) NSInteger sendToNext;

@property (nonatomic , assign) NSInteger countNum;

@property (nonatomic ,assign)NSIndexPath * headerIndex;//获取头部轮播图的indexPath
@end

@implementation FeaturedCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countNum = 1;
    
    //1. 注册Cell
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"musicCollection_cell"];

    [self.collectionView registerNib:[UINib nibWithNibName:@"MusicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"musicCollection_cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeaturedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"featureCollention_cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"header_cell"];
    
    
    
    
    //注册区头
    [self.collectionView registerClass:[UICollectionReusableView class ] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
 
    
    //2.创建布局方式的对象
    self.layout = [[UICollectionViewFlowLayout alloc] init];
   
    //设置最小行间距
    self.layout.minimumLineSpacing = 30;
    //设置最小列间距
    self.layout.minimumInteritemSpacing = 30;
    //3.解析数据
    [self parseData];
//    HeaderCollectionViewCell * cell = nil;
//    cell.delegate = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
    
    [[ShareHandle shareHandle] netType];
}

#pragma mark-----解析数据----------
- (void)parseData{
    //让子线程去解析数据（子线程只有这一个吗）
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL * urlString = [NSURL URLWithString:kFeatureUrls];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlString];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data!= nil) {
                //获取最外面的字典
                NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
                NSDictionary * dict = dic[@"result"];
                NSArray * array = dict[@"dataList"];
                self.sectionsArray = [NSMutableArray array];
//                self.headerModelsArray = [NSMutableArray array];
                NSInteger count = 0;
                self.arrays = [NSMutableArray array];
                for (NSDictionary * dict1 in array) {
                    count++;
                    MusicModel * model = [[MusicModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dict1];
                    //决定有几个分区(这个Model里还存着name即区头名)
                    [self.sectionsArray addObject:model];
#pragma mark-------------这部分解析的是头部轮播的数据-----------
                    NSArray * array1 = dict1[@"dataList"];
                    self.headerModelsArray = [NSMutableArray array];
                    for (NSDictionary * dict2 in array1) {
                 
                        
                        MusicModel * headerModel = [[MusicModel alloc] init];
                        [headerModel setValuesForKeysWithDictionary:dict2];
                        //在最后一个分区里面，当rtype==0的时候，返回不保存 那个数据
                        if (count == 6) {
                            if (headerModel.rtype == 0) {
                                continue;
                            }
                            
                        }
                        
                      
                        [self.headerModelsArray addObject:headerModel];
                    
                        
                    }
               
                    

//                     NSLog(@"==========%@,++++%ld",self.headerModelsArray,self.headerModelsArray.count);
//                    [self.arrays addObjectsFromArray:self.headerModelsArray];//这样加的是将数组中的元素添加到另一个数组，这种方法是将数组添加到一个
                    [self.arrays addObject:self.headerModelsArray];
//                    NSLog(@"===========%@========%ld==========",self.arrays,self.arrays.count);

                    
                }
                [self.collectionView reloadData];
                
            }
        
            
        }];
        
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.arrays.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    for (int i = 1; i < self.arrays.count; i++) {
        if (section == i) {
            return [self.arrays[i] count];
        }
    }
   
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //第一个分区：头部轮播图
    if (indexPath.section == 0) {
#warning mark-----这里设置轮播图
        self.headerIndex = indexPath;
        if (_countNum > 4) {
            _countNum = 1;
        }
        
        HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"header_cell" forIndexPath:indexPath];
        
        cell.contentView.backgroundColor = [UIColor blueColor];
        for (MusicModel * model  in self.arrays[0]) {
            [cell.picsArray[_countNum - 1] sd_setImageWithURL:[NSURL URLWithString:model.pic]];
           
#warning mark------------记得自加要不然前面的值会被后面的覆盖
            _countNum++;
        }

        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 5){
        //第六个分区：新歌速递
        FeaturedCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"featureCollention_cell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        MusicModel * model = self.arrays[5][indexPath.row];
//        if (model.rtype == 0) {
//            model.rtype = 1;
//        }
        cell.model = model;
        
        return cell;
        
    }else if (indexPath.section == 1){
        MusicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"musicCollection_cell" forIndexPath:indexPath];
        MusicModel * model = self.arrays[1][indexPath.row];
        cell.model = model;
        
        
        return cell;

        
    }else if (indexPath.section == 2){
        MusicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"musicCollection_cell" forIndexPath:indexPath];
        MusicModel * model = self.arrays[2][indexPath.row];
        cell.model = model;
        
        
        return cell;

    }else if (indexPath.section == 3){
        MusicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"musicCollection_cell" forIndexPath:indexPath];
        MusicModel * model = self.arrays[3][indexPath.row];
        cell.model = model;
        
        
        return cell;

    }else{
        MusicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"musicCollection_cell" forIndexPath:indexPath];
        MusicModel * model = self.arrays[4][indexPath.row];
        cell.model = model;
        
        
        return cell;

    }


    return nil;
    
}
#pragma mark----layout布局设置item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return self.layout.itemSize = CGSizeMake(self.view.frame.size.width, 150);
        
    }else if (indexPath.section == 5){
        return self.layout.itemSize = CGSizeMake(self.view.frame.size.width, 70);
        

    }else{
        
        return self.layout.itemSize = CGSizeMake(self.view.frame.size.width / 3 - 20, 150);
 
    }
    
}
//设置区头的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(320,-20);
    }
    return CGSizeMake(320, 30);
    
}


#pragma mark------设置区头（区尾也是用这个方法）---
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    NSArray * array = @[@"1",@"2",@"3",@"4",@"5"];
//    NSMutableArray * array = self.sectionsArray;
      MusicModel * model = self.sectionsArray[indexPath.section];
    if (indexPath.section == 0) {
        return nil;
        
    }else{
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            //重用集合中去取，是否有可用的header
            UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
            headerView.backgroundColor = [UIColor whiteColor];
            
            
            //添加lable
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, headerView.frame.size.width, headerView.frame.size.height)];
            lable.backgroundColor = [UIColor whiteColor];
          
            lable.text = model.name;
            [headerView addSubview:lable];
            
            UIView * view = [[UIView alloc] init];
            view.backgroundColor = [UIColor grayColor];
            view.alpha = 0.6;
            view.frame = CGRectMake(0,CGRectGetMaxY(lable.frame) - 5, self.view.frame.size.width, 1);
            [headerView addSubview:view];
            
            
            return headerView;
        }
        
        
    }
    
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self.layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
}
#pragma mark------点击进入下一个界面------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //将ViewController创建推出下一个界面
    
    PlayViewController *playVC = [PlayViewController shareInstance];
    
    
    playVC.fromLastValue = 100;
    playVC.musicID = [_arrays[indexPath.section][indexPath.row] rid];
    playVC.indexPath = indexPath.row;
    
    
    playVC.section = indexPath.section;
    
//    NSLog(@"palyVC.musicID = %ld" , playVC.musicID);
    
    [self showViewController:playVC sender:nil];
    
    
    
}
- (void)pushNextViewController{
    
    PlayViewController *playVC = [PlayViewController shareInstance];
    playVC.fromLastValue = 100;
   
    playVC.section = 0;
    playVC.indexPath = 0;
    playVC.musicID = 1000001979380;
    [self showViewController:playVC sender:nil];

    
}

- (void)pushNextViewControllerIndex:(NSInteger)currentPage{
    PlayViewController *playVC = [PlayViewController shareInstance];
    playVC.fromLastValue = 100;
    
    playVC.section = 0;
    playVC.indexPath = 0;
    if (currentPage == 0) {
         playVC.musicID = 1000001979380;//用于推出下一级播放页面，用于拼接网址的ID
        playVC.tags = 300;//用于标记是第几个；在这里我们也可以用currentPage来做tag值
    }else if (currentPage == 1){
         playVC.musicID = 1000001979239;
        playVC.tags = 301;
    }else if (currentPage == 2){
         playVC.musicID = 1000001953263;
        playVC.tags = 302;
    }else if (currentPage == 3){
         playVC.musicID = 1000001965890;
        playVC.tags = 303;
    }else{
         playVC.musicID = 1000001852166;
        playVC.tags = 304;
    }
   
    [self showViewController:playVC sender:nil];
}


#pragma mark----实现scrollView代理协议中的方法(让导航栏上移)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollY = scrollView.contentOffset.y - 1;
    if (scrollY > 0) {
        
        
        
    }
}



@end
