//
//  CommonalityTableViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "CommonalityTableViewController.h"
#import "Urls.h"
#import "AFHTTPRequestOperation.h"
#import "LiveModel.h"
#import "CommonalityLiveTableViewCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "PlayViewController.h"
#import "RadioPlayViewController.h"
#import "ShareHandle.h"
@interface CommonalityTableViewController ()

@property (nonatomic ,strong)NSMutableArray * liveModelsArray;
@property (nonatomic ,strong)LiveModel* model;
@property (nonatomic,strong)NSString * urlString;//存放拼接后的网址
@property (nonatomic,assign)NSInteger pageNumer;


@end

@implementation CommonalityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNumer = 1;
    //解析数据
    [self AFHTTPReadData];
    self.liveModelsArray = [NSMutableArray array];
    //注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CommonalityLiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"commonlity_cell"];
    //下拉刷新
    [self reLoadFooter];
#pragma maark-------创建Model，初始化Model
    self.model = [[LiveModel alloc] init];

}
- (void)viewWillAppear:(BOOL)animated{
    [[ShareHandle shareHandle] contentNetworkStatusByAFNetworking];
    
    [[ShareHandle shareHandle] netType];
}

#pragma mark-----解析数据
- (void)AFHTTPReadData{
    NSURL * url = [NSURL URLWithString:kLiveCommonalityUrls(self.pageNumer)];
//    NSLog(@"%@============%@",kLiveCommonalityUrls(self.model.nextPage),self.pageNumer);
//    NSLog(@"%@",kLiveCommonalityUrls(self.pageNumer));
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSString * html = operation.responseString;
        NSData * data = [html dataUsingEncoding:NSUTF8StringEncoding];
        id dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //解析数据
        NSMutableDictionary * dict = dic[@"result"];

#warning mark----------记得初始化Model：会出现的错误，等号两边一边有值，一边没有值；会给等号左边赋不上值----------------
#pragma mark-----解析数据，得到nextPage，用于拼接网址
        NSString * next_num = dict[@"nextPage"];
//        NSLog(@"%@",next_num);
        self.model.nextPage = [next_num integerValue];
        
        NSArray * array = dict[@"dataList"];
        
        for (NSDictionary * dict1 in array) {
            LiveModel * model = [[LiveModel alloc] init];
            self.model = model;
            [model setValuesForKeysWithDictionary:dict1];
            [self.liveModelsArray addObject:model];
        }
        [self.tableView reloadData];
//        NSLog(@"=======%@,=====%ld",self.liveModelsArray,self.liveModelsArray.count);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
//        NSLog(@"发生的错误：%@",error);
        
    }];
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    
}

#pragma mark-------下拉刷新
- (void)reLoadFooter{
    
    //设置区尾
    self.tableView.footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (void)loadMoreData{
    self.pageNumer++;
    self.urlString = [NSString stringWithFormat:@"http://api.kaolafm.com/api/v4/liveprogram/list?pagenum=%ld&pagesize=20&type=0&installid=0000zPzE&udid=13b192fb86b461ef2b8395f19a4077db&sessionid=13b192fb86b461ef2b8395f19a4077db1445301302106&imsi=460019091504654&operator=2&network=1&timestamp=1445301904&playid=41056ec3c9160036e36f4d677364608f&sign=b236e0daf60f2ddd9bc34ac0ffc80686&resolution=720*1280&devicetype=0&channel=A-360&version=4.2.2&appid=0",self.pageNumer];
   

   //解析数据
    [self AFHTTPReadData];
#pragma mark------记得加停止刷新-----不然上一次的刷新不会停止，不会进入下一级
    [self.tableView.footer endRefreshing];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"+++++%ld",self.liveModelsArray.count);
    return self.liveModelsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonalityLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commonlity_cell" forIndexPath:indexPath];
    LiveModel * model = self.liveModelsArray[indexPath.row];
    cell.model = model;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RadioPlayViewController *radioPVC = [RadioPlayViewController shareInstance];
    LiveModel * model = self.liveModelsArray[indexPath.row];
    radioPVC.model = model;
    radioPVC.tags = 101;
    radioPVC.indexPath = indexPath.row;
    [self showViewController:radioPVC sender:nil];
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
