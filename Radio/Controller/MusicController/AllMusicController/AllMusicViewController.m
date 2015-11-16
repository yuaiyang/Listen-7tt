//
//  AllMusicViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "AllMusicViewController.h"
#import "Urls.h"
#import "MusicModel.h"
#import "AllMusicTableViewCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "PlayViewController.h"
#import "ShareHandle.h"
@interface AllMusicViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray * musicsAllModelsArray;
@property (assign , nonatomic) NSInteger pagenum;
@property (nonatomic,strong)NSString * urlString;//存放拼接后的网址
@property (assign , nonatomic) NSInteger tagToNext; // 判断传到下一个页面的是那个模块
@end

@implementation AllMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tagToNext = 100;
    
    //设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //1.解析数据
    self.pagenum = 1;//给一个初始值
    [self reloadMusicData];
    [self.tableView registerNib:[UINib nibWithNibName:@"AllMusicTableViewCell" bundle:nil] forCellReuseIdentifier:@"allMUsicAll_Cell"];
    [self reLoadFooter];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
    
    [[ShareHandle shareHandle] netType];
}

#pragma mark-----解析数据---------
- (void)reloadMusicData{
    //让子线程去解析数据（子线程只有这一个吗）
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSURL * urlString = [NSURL URLWithString:kMusicAllUrls(self.model.categoryId)];
        
        NSURL * urlString = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.kaolafm.com/api/v4/resource/search?words=&cid=%ld&sorttype=HOT_RANK_DESC&pagesize=10&pagenum=%ld&rtype=20000&installid=0000zPXT&udid=6fb609b09a9a9c0f8b5ea15a7fb30b7c&sessionid=6fb609b09a9a9c0f8b5ea15a7fb30b7c1445340608996&imsi=460006482175750&operator=1&network=1&timestamp=1445340821&sign=b369bb4f989164e84387694ffb5d0673&resolution=480*854&devicetype=0&channel=A-360&version=4.2.2&appid=0",self.model.categoryId,self.pagenum]];
//        NSURL * urlString = [NSURL URLWithString:self.urlString];
        
        
        NSURLRequest * request = [NSURLRequest requestWithURL:urlString];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data!= nil) {
//                [_musicsAllModelsArray removeAllObjects];
//                获取最外面的字典
                NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
                
                NSMutableDictionary * dict = dic[@"result"];
                NSArray * array = dict[@"dataList"];
//                self.musicsAllModelsArray = [NSMutableArray array];
                for (NSDictionary * dic1 in array) {
                    MusicModel * model = [[MusicModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [self.musicsAllModelsArray addObject:model];
                    
                    
                }

            }
            [self.tableView reloadData];
            
      
         
         
        }];
        
    });
    
}



#pragma mark-------下拉刷新
- (void)reLoadFooter{
    
    //设置区尾
    self.tableView.footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (void)loadMoreData{
    self.pagenum++;
    self.urlString = [NSString stringWithFormat:@"http://api.kaolafm.com/api/v4/liveprogram/list?pagenum=%ld&pagesize=20&type=0&installid=0000zPzE&udid=13b192fb86b461ef2b8395f19a4077db&sessionid=13b192fb86b461ef2b8395f19a4077db1445301302106&imsi=460019091504654&operator=2&network=1&timestamp=1445301904&playid=41056ec3c9160036e36f4d677364608f&sign=b236e0daf60f2ddd9bc34ac0ffc80686&resolution=720*1280&devicetype=0&channel=A-360&version=4.2.2&appid=0",self.pagenum];
    
    
    //解析数据
    [self reloadMusicData];
#pragma mark------记得加停止刷新-----不然上一次的刷新不会停止，不会进入下一级
    [self.tableView.footer endRefreshing];
    
    
}






#pragma mark-----实现代理协议中的方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicsAllModelsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllMusicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"allMUsicAll_Cell" forIndexPath:indexPath];
    MusicModel * model = self.musicsAllModelsArray[indexPath.row];
    
    cell.model = model;

    return cell;
    
}

#pragma mark  点击触发事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayViewController *playVC = [PlayViewController shareInstance];
    MusicModel * model = self.musicsAllModelsArray[indexPath.row];
//    NSLog(@"%ld" , model.id);
    playVC.musicID = model.id;
    playVC.indexPath = indexPath.row;
    playVC.fromLastValue = self.tagToNext;
#warning mark--------这样的话可以让他走playVC播放音乐的第一个分区的网址---------
    playVC.section = 1;
    
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:playVC];
  
    
    [self showViewController:NC sender:nil];
    
}




- (NSMutableArray *)musicsAllModelsArray{
    if (!_musicsAllModelsArray) {
        _musicsAllModelsArray = [NSMutableArray array];
    }
    return _musicsAllModelsArray;
}


@end
