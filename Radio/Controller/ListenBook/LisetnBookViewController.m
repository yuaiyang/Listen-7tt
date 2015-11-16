//
//  LisetnBookViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "LisetnBookViewController.h"
#import "ListenBookListModel.h"
#import "BookListModel.h"
#import "BookListModel.h"
#import "BookListTableViewCell.h"
#import "PlayViewController.h"
#import "MJRefreshAutoNormalFooter.h"
#import "Urls.h"
#import "MBProgressHUD.h"
#import "ShareHandle.h"
@interface LisetnBookViewController () <UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *listCollectionView;
@property (strong , nonatomic) NSMutableArray * listArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightUsed;
@property (assign , nonatomic) BOOL isUp;

@property (assign , nonatomic) CGRect testRect;
@property (assign , nonatomic) CGRect testRect1;

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (strong , nonatomic) NSMutableArray * bookListArray;

@property (assign , nonatomic) NSInteger index;

@property (assign , nonatomic) NSInteger page;

@property (strong , nonatomic) NSString * passID;

@property (assign , nonatomic) NSInteger nextPage;
@property (nonatomic ,strong)MBProgressHUD * HUD;

@end

@implementation LisetnBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
    [self registerCell];
    
    [self requestMusicDataWithuRL:kListenBookAll];
    
    self.nextPage = 101;
    
    self.detailTableView.dataSource = self;
    self.detailTableView.delegate = self;
    
    self.listCollectionView.dataSource = self;
    self.listCollectionView.delegate = self;
    
//    self.index = 10;
//    self.page = 1;
    

    self.page = 1;
    self.passID = @"-1";
    [self reLoadFooter];
    
}


//注册Cell
- (void)registerCell{
    
    UINib * nib = [UINib nibWithNibName:@"BookListTableViewCell" bundle:[NSBundle mainBundle]];
    [self.detailTableView registerNib:nib forCellReuseIdentifier:@"BookListCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
    
    [[ShareHandle shareHandle] netType];
}

#pragma mark-------collectionView代理协议方法----

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


//多少个Cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _listArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ListenBookListModel * model = _listArray[indexPath.row];
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    lable.font = [UIFont systemFontOfSize:14.0];
    lable.text = model.title;
    lable.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor whiteColor];
//    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    UIView * view1 = [[UIView alloc] initWithFrame:cell.frame];
    view1.backgroundColor = [UIColor lightGrayColor];
    
    cell.selectedBackgroundView = view1;
    

    [cell addSubview:lable];
    
    return cell;
    
}

#pragma mark  ---点击刷新事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.page = 1;
    self.passID = @"-1";
    
    ListenBookListModel * model = _listArray[indexPath.row];
 
    switch (self.index) {
    
           
            
        case 0:
        {
            self.bookListArray = [NSMutableArray array];

            NSString * urlStr = [NSString stringWithFormat:@"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=1&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=%@&sort_type=2&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12",model.id];
            
            
            [self requestMusicDataWithuRL:urlStr];
            
            break;
        }
            
        case 1:
        {
            self.bookListArray = [NSMutableArray array];

            NSString * urlStr = [NSString stringWithFormat:@"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=1&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=%@&sort_type=1&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12",model.id];
            
            [self requestMusicDataWithuRL:urlStr];
            
            break;
        }
            
        case 2:
        {
            self.bookListArray = [NSMutableArray array];

            NSString * urlStr = [NSString stringWithFormat:@"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=1&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=%@&sort_type=0&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12",model.id];
            
            [self requestMusicDataWithuRL:urlStr];
            
            break;
        }
            
        default:
            break;
    }

    
    
    
    
    
}


//设置item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(60, 30);
    return size;
}


#pragma mark ---- 点击segment刷新 ----
- (IBAction)update:(UISegmentedControl *)sender {
    
    self.page = 1;
    self.passID = @"-1";
    
//    NSLog(@"%ld" , sender.selectedSegmentIndex);
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.bookListArray = [NSMutableArray array];
            self.index = sender.selectedSegmentIndex;
            [self requestMusicDataWithuRL:@"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=1&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=-1&sort_type=2&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12"];
            
            break;
            
        case 1:
            self.bookListArray = [NSMutableArray array];
            self.index = sender.selectedSegmentIndex;
            [self requestMusicDataWithuRL:@"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=1&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=-1&sort_type=1&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12"];
            
            break;
            
        case 2:
            self.bookListArray = [NSMutableArray array];
            self.index = sender.selectedSegmentIndex;
            [self requestMusicDataWithuRL:@"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=1&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=-1&sort_type=0&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12"];
            
            break;
            
        default:
            break;
    }
    
    
}






- (void)requestData{
    
    NSURL * url = [NSURL URLWithString:kListenBookList];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    __weak LisetnBookViewController * VC = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data != nil) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * array = [dict valueForKey:@"data"];
            
            for (NSDictionary * dic in array) {
                ListenBookListModel * model = [[ListenBookListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [VC.listArray addObject:model];
            }
            
        }
        [self.listCollectionView reloadData];
    }];
    
}




#pragma mark ---- 分类点击 ----
- (IBAction)showDetail:(UIButton *)sender {
    
    if (_isUp == NO) {
        
        self.listCollectionView.hidden = YES;

        
        self.detailTableView.transform = CGAffineTransformTranslate(self.detailTableView.transform, 0, -CGRectGetHeight(self.listCollectionView.frame) + 64 - 59);
        

        _isUp = YES;
    }else if(_isUp == YES){
        
        self.listCollectionView.hidden = NO;

        self.detailTableView.transform = CGAffineTransformTranslate(self.detailTableView.transform, 0, CGRectGetHeight(self.listCollectionView.frame) - 64 + 59);
    
        _isUp = NO;
    }
    
}


- (void)requestMusicDataWithuRL:(NSString *)urlStr{
    
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    __weak LisetnBookViewController * VC = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data != nil) {
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dic = [dict valueForKey:@"data"];
            NSArray * array = [dic valueForKey:@"data_list"];
            for (NSDictionary * value in array) {
                
                BookListModel * model = [[BookListModel alloc] init];
                [model setValuesForKeysWithDictionary:value];
                [VC.bookListArray addObject:model];
            }
        }
        [self.detailTableView reloadData];
    }];
    
}

#pragma mark tableview的协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bookListArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BookListCell"];
    
    if (_bookListArray.count == 0) {
        return cell;
    }
    
    BookListModel * model = _bookListArray[indexPath.row];
    cell.model = model;

    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    BookListModel * model = _bookListArray[indexPath.row];
    
 
    PlayViewController * playVC = [PlayViewController shareInstance];
    playVC.fromLastValue = self.nextPage;
    playVC.bookID = model.id;//这个用于判断
    playVC.bookImage = model.image_url;
    playVC.indexPath = indexPath.row;
    

//    [self.navigationController pushViewController:playVC animated:YES];
    [self showViewController:playVC sender:nil];
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark---------下拉刷新区域-------------

#pragma mark-------下拉刷新
- (void)reLoadFooter{
    
    //设置区尾
    self.detailTableView.footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}


- (void)loadMoreData{
    self.page++;
    
    switch (self.index) {
            
        case 0:
        {
            
            
            NSString * urlStr = [NSString stringWithFormat:@"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=%ld&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=%@&sort_type=2&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12",self.page,self.passID];
            
            
            [self requestMusicDataWithuRL:urlStr];
            
            break;
        }
            
        case 1:
        {
            
            NSString * urlStr = [NSString stringWithFormat:@"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=%ld&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=%@&sort_type=1&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12",self.page,self.passID];
            
            [self requestMusicDataWithuRL:urlStr];
            
            break;
        }
            
        case 2:
        {
            
            
            NSString * urlStr = [NSString stringWithFormat:@"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=%ld&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=%@&sort_type=0&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12",self.page,self.passID];
            
            [self requestMusicDataWithuRL:urlStr];
            
            break;
        }
            
        default:
            break;
    }
    
    
#pragma mark------记得加停止刷新-----不然上一次的刷新不会停止，不会进入下一级
    [self.detailTableView.footer endRefreshing];
    
    
}




#pragma mark  ---- 懒加载区域 ----
- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)bookListArray{
    if (!_bookListArray) {
        _bookListArray = [NSMutableArray array];
    }
    return _bookListArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
