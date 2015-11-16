//
//  PlayViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayBarView.h"
#import "Dock.h"
#import "DockItem.h"
#import "UserDetailModel.h"
#import "ShareHandle.h"
#import "StationListModel.h"
#import "MusicListModel.h"
#import "Urls.h"

#import "PlayMusicManager.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperation.h"
#import "bookPlayModel.h"
#import "MJRefreshAutoFooter.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MBProgressHUD.h"
#import "UMSocial.h"
#import "ViewController.h"
#import "ShareHandle.h"

#define kDockHight 44

@interface PlayViewController () <DockDelegate , UITableViewDataSource , UITableViewDelegate,PlayMusicManagerDelegate>

@property (strong , nonatomic) NSMutableArray * stationListArray;
@property (strong , nonatomic) NSMutableArray * musicListArray;
@property (strong , nonatomic) NSMutableArray * bookArray;
@property (strong , nonatomic) UIAlertView * alertView1;
@property (assign , nonatomic) NSInteger netNum;


@property (weak, nonatomic) IBOutlet UITableView *listTableView; // 此处存放着model  model中包含mp3和JPG


- (IBAction)lastMusic:(UIButton *)sender;//上一首

- (IBAction)nextMusic:(UIButton *)sender;//下一首

- (IBAction)playOrPause:(UIButton *)sender;//暂停或者播放


@property (weak, nonatomic) IBOutlet UILabel *currentTimeLable;//当前播放时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLable;//播放总时间
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;//进度条


- (IBAction)sliderAction:(UISlider *)sender;//拖动滑块的方法

@property (weak, nonatomic) IBOutlet UIImageView *radioImageView;//广播图片

@property (weak, nonatomic) IBOutlet UILabel *musicName;//歌曲名字（章节）

@property (weak, nonatomic) IBOutlet UILabel *radioName;//歌曲名

@property (nonatomic ,assign)NSInteger currentDetailIndex;
@property (nonatomic ,assign)NSInteger currentIndex;//标识当前播放的下标
@property (nonatomic ,assign)NSInteger currentSection;//当前的分区
@property (nonatomic,assign)NSInteger currentBookId;


- (IBAction)randomPlayRadio:(UIButton *)sender;//随机播放音乐

- (IBAction)didShowTableView:(UIButton *)sender;//是否显示tableView
@property (nonatomic,assign)BOOL isShow;

@property (nonatomic ,strong)StationListModel * model;//正在播放的Model对象

@property (strong , nonatomic) MusicListModel * musicModel; // 当前的musicModel;

//@property (strong , nonatomic) bookPlayModel * bookCollecModel; // 收藏要用

@property (strong , nonatomic) BookListModel * bookModel; // 播放页面需要的

@property (strong , nonatomic) NSObject * selfModel; // 这个地方可以的话就可以把收藏下载方法封装成类了

@property (strong , nonatomic) NSString * urlString;
@property (strong , nonatomic) NSString * musicUrlString;
@property (strong , nonatomic) NSString * bookUrlString;
// 收藏和下载时需要用到的model
@property (nonatomic ,strong)StationListModel * stationListModel;//接收电台的Model
@property (nonatomic ,strong)MusicListModel * musicListModel;//接收电台的Model
@property (nonatomic ,strong)bookPlayModel * bookListModel;//接收听书页面的Model

// 下来刷新参数
@property (assign , nonatomic) NSInteger page;

@property (assign ,nonatomic)NSInteger index;

@property (nonatomic ,strong)MBProgressHUD * HUD;//加载更多


@property (nonatomic ,strong)UIView * coverView;//蒙版


- (IBAction)VoiceSlider:(UISlider *)sender;//控制播放音量


@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;

@property (assign ,nonatomic)BOOL sliderIsShow;//控制播放音量的显隐
//@property (strong , nonatomic) UIAlertView * alertView;
@property (assign , nonatomic) BOOL isListen;
@end

@implementation PlayViewController
#pragma mark-------实现单例方法（当我们点击同一首歌时，还是继续播放）------

+ (PlayViewController *)shareInstance{
    static PlayViewController * share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate ,^{
        
        //        share = [[PlayViewController alloc] init];
        share = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"playVC"];
        
    });
    
    return share;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentDetailIndex = -1;
    self.currentBookId = -1;
    //设置listTableView
    [self setHidenListTableView];

    [self addDock];
    
    //剪切图片
    [self cutPicture];
    self.page = 1;
    [self reLoadFooter];
    
    //加barButton
    [self addBarButton];
#pragma mark   判断网络
    [self checkNetWork];
    [self setSlider];
    self.tagsController = 1001;
    
    
}


- (void)setSlider{
    UIImage * thumbImage = [UIImage imageNamed:@"volice.png"];
    [self.voiceSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self.voiceSlider setThumbImage:thumbImage forState:UIControlStateNormal];
}

#pragma mark-----设置listTableView
- (void)setHidenListTableView{
    self.listTableView.hidden = YES;
    self.isShow = YES;
    self.sliderIsShow = YES;
    
    //    设置代理
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [PlayMusicManager shareInstance].delegate = self;
    [self.view bringSubviewToFront:self.listTableView];
    //    侯
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.alpha = 0.6;
    
    //    self.listTableView.alpha = 0.7;
    self.currentIndex = -1;
    self.currentSection = -1;

}

#pragma mark-----添加导航栏左侧的button
- (void)addBarButton{
    UIBarButtonItem * leftBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    self.navigationItem.leftBarButtonItem = leftBI;
    //改变Slider的方向
    self.voiceSlider.transform = CGAffineTransformMakeRotation(M_PI * 3/ 2);
    self.voiceSlider.value = 5.0f;//初始0音量
    self.voiceSlider.minimumValue = 0.0f;//设置最小值
    self.voiceSlider.maximumValue = 10.0f;//设置最大值；

}
#pragma mark------剪切图片
- (void)cutPicture{
    //提前得到布局
    [self.radioImageView layoutIfNeeded];
    //切割图片
    
    self.radioImageView.layer.cornerRadius = self.radioImageView.frame.size.width/2;
    self.radioImageView.layer.masksToBounds = YES;
    

    
}
- (void)didClickLeft{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)click{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark-------页面即将出现的时候，播放当前Model对应的歌曲
- (void)viewWillAppear:(BOOL)animated{
      self.listTableView.hidden = YES;
    if (self.fromLastValue == 100) {
        //对话框显示时需要执行的操作
        [self requestMusicData];

    }else if (self.fromLastValue == 101){
    //对话框显示时需要执行的操作
        [self resetBookUrl];
        [self requestBookDataWithurl:self.urlString];

    }else{
        
       [self requestData]; 
    }
    self.page = 1;
    self.bookArray = [NSMutableArray array];

   
    
}
#pragma mark-------播放音乐
- (void)playMusic{
    
    if (self.fromLastValue == 100) {
        self.currentIndex = self.indexPath;
#warning mark-------------解析数据这里----------------
//       self.musicListModel = _musicListArray[self.indexPath];
        self.musicListModel = _musicListArray[0];//让每次播放的下标都从0 开始（即每次都播放的是第一首歌）
        
//        NSLog(@"# %ld  #######  %ld",self.musicID,self.currentIndex);
        
        //根据MP3Url网址信息  准备播放音乐
        [[PlayMusicManager shareInstance] preparePlayMusicWithMp3Url:self.musicListModel.mp3PlayUrl];
        
        //设置当前播放音乐的背景图片
        [self.radioImageView sd_setImageWithURL:[NSURL URLWithString:self.musicListModel.audioPic]];
        self.musicName.text = self.musicListModel.audioName;
        self.radioName.text = self.musicListModel.albumName;
        
        
    }else if (self.fromLastValue == 101){
        self.currentIndex = self.indexPath;
        self.currentBookId = self.bookID;
        self.bookListModel = _bookArray[0];
       
            
//        self.bookListModel  = _bookArray[self.index];
  
        #pragma mark------让播放图书的时候从第一章开始播放----------
        
      
        
//        NSLog(@"########  %ld",self.currentIndex);
        
        //根据MP3Url网址信息  准备播放音乐
        [[PlayMusicManager shareInstance] preparePlayMusicWithMp3Url:self.bookListModel.audio_64_url];
        
        //设置当前播放音乐的背景图片
        [self.radioImageView sd_setImageWithURL:[NSURL URLWithString:self.bookImage]];
        self.musicName.text = self.bookListModel.title;
        self.radioName.text = self.bookListModel.title;
        
        
    }else{
        
        self.currentIndex = self.indexPath;
//        self.stationListModel = _stationListArray[self.indexPath];
        self.stationListModel = _stationListArray[0];
        
        //根据属性传值。将传过来的线标，赋给重新点击后的音乐下标
        
        
//        NSLog(@"########  %ld",self.currentIndex);
        
        //根据MP3Url网址信息  准备播放音乐
        [[PlayMusicManager shareInstance] preparePlayMusicWithMp3Url:self.stationListModel.sound_url];
        
        //设置当前播放音乐的背景图片
        [self.radioImageView sd_setImageWithURL:[NSURL URLWithString:self.stationListModel.cover_url]];
        self.musicName.text = self.stationListModel.title;
        self.radioName.text = self.stationListModel.title;
      
        
    }
    
    
    
}

- (void)playMusicDetail{
    
    if (self.fromLastValue == 100) {
        self.currentDetailIndex = self.indexPath;
#warning mark-------------解析数据这里----------------
        //       self.musicListModel = _musicListArray[self.indexPath];
        self.musicListModel = _musicListArray[self.indexPath];//让每次播放的下标都从0 开始（即每次都播放的是第一首歌）
        
//        NSLog(@"# %ld  #######  %ld",self.musicID,self.currentIndex);
        
        //根据MP3Url网址信息  准备播放音乐
        [[PlayMusicManager shareInstance] preparePlayMusicWithMp3Url:self.musicListModel.mp3PlayUrl];
        
        //设置当前播放音乐的背景图片
        [self.radioImageView sd_setImageWithURL:[NSURL URLWithString:self.musicListModel.audioPic]];
        self.musicName.text = self.musicListModel.audioName;
        self.radioName.text = self.musicListModel.albumName;
        
        
    }else if (self.fromLastValue == 101){
        self.currentDetailIndex = self.indexPath;
        
        self.bookListModel = _bookArray[self.indexPath];
        
        
        //        self.bookListModel  = _bookArray[self.index];
        
#pragma mark------让播放图书的时候从第一章开始播放----------
        
        
        
//        NSLog(@"########  %ld",self.currentIndex);
        
        //根据MP3Url网址信息  准备播放音乐
        [[PlayMusicManager shareInstance] preparePlayMusicWithMp3Url:self.bookListModel.audio_64_url];
        
        //设置当前播放音乐的背景图片
        [self.radioImageView sd_setImageWithURL:[NSURL URLWithString:self.bookImage]];
        self.musicName.text = self.bookListModel.title;
        self.radioName.text = self.bookListModel.title;
        
        
    }else{
        
        self.currentDetailIndex = self.indexPath;
        //        self.stationListModel = _stationListArray[self.indexPath];
        self.stationListModel = _stationListArray[self.indexPath];
        
        //根据属性传值。将传过来的线标，赋给重新点击后的音乐下标
        
        
//        NSLog(@"########  %ld",self.currentIndex);
        
        //根据MP3Url网址信息  准备播放音乐
        [[PlayMusicManager shareInstance] preparePlayMusicWithMp3Url:self.stationListModel.sound_url];
        
        //设置当前播放音乐的背景图片
        [self.radioImageView sd_setImageWithURL:[NSURL URLWithString:self.stationListModel.cover_url]];
        self.musicName.text = self.stationListModel.title;
        self.radioName.text = self.stationListModel.title;
        
        
    }
    
    
}
#pragma mark-----存放网址---------

- (void)resetUrl{

    self.urlString = [NSString stringWithFormat:@"http://fm.duole.com/api/sound/get_user_sound_list?visitor_uid=179793&device=android&page=1&limit=20&user_id=%@" , [[self.stationModel valueForKey:@"is_vip"] valueForKey:@"uid"]];
}

- (void)resetMusicUrl{
    if (self.ID == 201) {
        self.musicUrlString = self.Url;
        
    }else{
        //第一个分区时
        if (self.section == 1) {
            self.musicUrlString = [NSString stringWithFormat:@"http://api.kaolafm.com/api/v4/audios/list?id=%ld&sorttype=1&pagesize=20&pagenum=1&installid=0000zPXT&udid=6fb609b09a9a9c0f8b5ea15a7fb30b7c&sessionid=6fb609b09a9a9c0f8b5ea15a7fb30b7c1445435232269&imsi=460006482175750&operator=1&network=1&timestamp=1445437713&playid=a8f3914bfe028b436640b18d3c1d86ab&sign=b369bb4f989164e84387694ffb5d0673&resolution=480*854&devicetype=0&channel=A-360&version=4.2.2&appid=0",self.musicID];
            
        }else{
            //其他分区时
            self.musicUrlString = [NSString stringWithFormat:@"http://api.kaolafm.com/api/v4/audios/list?sorttype=1&pagesize=20&audioid=%ld&installid=0000zPXT&udid=d2e1f169e19b0ae1ebc216cb7570f16f&sessionid=d2e1f169e19b0ae1ebc216cb7570f16f1445999210773&imsi=460021365048348&operator=1&network=1&timestamp=1446000523&playid=631e2553d67e9ebee766da770180ba81&sign=62520de917b6a7bd5898a85fc252fa23&resolution=480*854&devicetype=0&channel=A-360&version=4.2.2&appid=0",self.musicID];
        }

        
    }
    
}

- (void)resetBookUrl{
    if (self.ID==203) {
        
        self.bookUrlString = self.Url;

        
    }else{
        self.bookUrlString = [NSString stringWithFormat:@"http://api.duotin.com/album?album_id=%ld&page_size=100&device_key=864205022118756&platform=android&source=danxinben&page=1&device_token=Ajds6egt9GwSfcGuy7uCsBjkyEaFmfPvdO5agGi4MnPH&user_key=&sort_type=0&package=com.duotin.fm&channel=m360&version=2.7.12",self.bookID];
    }
#warning mark----------将ID置为其他的值，这样可以保证再次进来的时候是不同的网址----
    self.ID = 1;
}

#pragma mark 添加dock
- (void)addDock{
    // 1;添加dock
    Dock * dock = [[Dock alloc] init];
    dock.delegate = self;
    dock.frame = CGRectMake(0, self.view.frame.size.height - kDockHight, self.view.frame.size.width, kDockHight);

    [self.view addSubview:dock];
    
    // 2;往dock里添加内容
    [dock addItemWithIcon:@"collection.png" title:@"收藏"];
    [dock addItemWithIcon:@"arrow_change.png" title:@"更换背景"];
    [dock addItemWithIcon:@"share.png" title:@"分享"];
    [dock addItemWithIcon:@"Home.png" title:@"主页面"];
//    [dock addItemWithIcon:@"tabbar_more.png" title:@"更多"];
    
    // 3; 添加其他控制器
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = CGPointMake(100, 100);
    
    [self.view addSubview:btn];

}




#pragma mark  解析上个页面传过来的数据  有可能的地方出现列表
#pragma mark----蒙版
- (void)cover{
    //蒙版
    self.coverView = [[UIView alloc] initWithFrame:self.view.frame];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.8;
    [self.view addSubview:self.coverView];
    
    
}

#pragma mark  解析电台的数据
- (void)requestData{
#pragma mark------稍后------
    [self cover];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.coverView addSubview:hud];
    hud.labelText = @"最佳体验优化中...";
    //停止播放
//    [[PlayMusicManager shareInstance] pauseMusic];
    [hud show:YES];

    [self resetUrl];
    NSURL * url = [NSURL URLWithString:self.urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    __weak PlayViewController * VC = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data != nil) {
            self.coverView.hidden = YES;
            hud.hidden = YES;
            
            VC.stationListArray = [NSMutableArray array];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray * array = [dict valueForKey:@"data"];
            for (NSDictionary * dic in array) {
                StationListModel * model = [[StationListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [VC.stationListArray addObject:model];
            }
            
        }
           [self.listTableView reloadData];
        if ((self.currentIndex == self.indexPath) &&(self.currentSection == self.section)) {
            return;//如果现在点击的下标和当前正在播放的相同直接返回
        }
        //如果不同，调用方法播放音乐
        [self playMusic];
     

        
    }];
    
}
#pragma mark 音乐播放传递的参数
- (void)requestMusicData{
    [self cover];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.coverView addSubview:hud];
    hud.labelText = @"最佳体验优化中...";
    //停止播放
//    [[PlayMusicManager shareInstance] pauseMusic];
    [hud show:YES];
    [self resetMusicUrl];
    
    
//    NSLog(@"musicUrlString = %@" , self.musicUrlString);
    NSURL * url = [NSURL URLWithString:self.musicUrlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    __weak PlayViewController * VC = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data != nil) {
            self.coverView.hidden = YES;
            hud.hidden = YES;

            
            [_musicListArray removeAllObjects];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dic = [dict valueForKey:@"result"];
            NSArray * listDict = [dic valueForKey:@"dataList"];
            for (NSDictionary * value in listDict) {
                
                MusicListModel * model = [[MusicListModel alloc] init];
                [model setValuesForKeysWithDictionary:value];
                [VC.musicListArray addObject:model];
                
            }
            
        }
        
        [self.listTableView reloadData];
        if (self.section == 0) {
            for (int i = 300; i < 305; i++) {
                if (self.tags == i) {
                    [self playMusic];
                }
            }
        }
        if ((self.currentIndex == self.indexPath) &&(self.currentSection == self.section)){
            return;//如果现在点击的下标和当前正在播放的相同直接返回
        }
        //如果不同，调用方法播放音乐
        [self playMusic];
        
        
    }];
    
}

#pragma mark  解析图书数据
- (void)requestBookDataWithurl:(NSString *)urlStr{
    [self cover];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.coverView addSubview:hud];
    hud.labelText = @"最佳体验优化中...";
    //停止播放
//    [[PlayMusicManager shareInstance] pauseMusic];
    [hud show:YES];
 
   
    NSURL * url = [NSURL URLWithString:self.bookUrlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    __weak PlayViewController * VC = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        self.coverView.hidden = YES;
        hud.hidden = YES;
        
        
        NSString *html = operation.responseString;
        
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary * dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        NSDictionary * dic = [dict valueForKey:@"data"];
        
        NSDictionary * contentDic = [dic valueForKey:@"content_list"];
        
        NSArray * dataListArray = [contentDic valueForKey:@"data_list"];
        
        for (NSDictionary * value in dataListArray) {
            bookPlayModel * model = [[bookPlayModel alloc] init];
            [model setValuesForKeysWithDictionary:value];
            [VC.bookArray addObject:model];
        }
        
//        if ((self.currentIndex == self.indexPath)&&(self.currentSection == self.section)) {
//            return;//如果现在点击的下标和当前正在播放的相同直接返回
//        }
        if ((self.currentIndex == self.indexPath)&&(self.currentBookId == self.bookID)) {
            return;//如果现在点击的下标和当前正在播放的相同直接返回
        }
        //如果不同，调用方法播放音乐
        [self playMusic];
        // 刷新tableview
        [self.listTableView reloadData];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"发生错误！%@",error);
        
    }];
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}



#pragma mark   下拉刷新图书列表
#pragma mark-------下拉刷新
- (void)reLoadFooter{
    
    //设置区尾
    self.listTableView.footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (void)loadMoreData{
    self.page++;
    self.bookUrlString = [NSString stringWithFormat:@"http://api.duotin.com/album?album_id=%ld&page_size=100&device_key=864205022118756&platform=android&source=danxinben&page=%ld&device_token=Ajds6egt9GwSfcGuy7uCsBjkyEaFmfPvdO5agGi4MnPH&user_key=&sort_type=0&package=com.duotin.fm&channel=m360&version=2.7.12",self.bookID,self.page];
    
    
    //解析数据
    [self requestBookDataWithurl:self.bookUrlString];
//    [self listTableView];
    [self.listTableView reloadData];
#pragma mark------记得加停止刷新-----不然上一次的刷新不会停止，不会进入下一级
    
    [self.listTableView.footer endRefreshing];
    
    
}





#pragma mark --- 实现tableView的协议-----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.fromLastValue == 100) {
        
        return self.musicListArray.count;
        
    }else if (self.fromLastValue == 101){
        
        return self.bookArray.count;
        
    }
    else{
        
        return self.stationListArray.count;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    if (self.fromLastValue == 100) {
        
        self.musicModel = _musicListArray[indexPath.row];
        cell.textLabel.text = _musicModel.audioName;
        
        
    }else if (self.fromLastValue == 101){
        
        self.bookListModel = _bookArray[indexPath.row];
        cell.textLabel.text = _bookListModel.title;
        
        
    }
    else{
        
        
        self.model = _stationListArray[indexPath.row];
        cell.textLabel.text = _model.title;
        
    }    
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.fromLastValue == 100) {
        self.indexPath = indexPath.row;
        //当点击某行的时候，点击播放某行，就播放那个界面
        [self playMusicDetail];
        self.listTableView.hidden = YES;
        self.isShow = YES;

    }else if (self.fromLastValue == 101){
        self.indexPath = indexPath.row;
       
        //当点击某行的时候，点击播放某行，就播放那个界面
        [self playMusicDetail];
        self.listTableView.hidden = YES;
        self.isShow = YES;

    }else{
        self.indexPath = indexPath.row;
        //当点击某行的时候，点击播放某行，就播放那个界面
        [self playMusicDetail];
        self.listTableView.hidden = YES;
//        self.isShow = NO;
        self.isShow = YES;

    }
    
    // 刘玉波加
    self.model = _stationListArray[indexPath.row];
    
    
}


#pragma mark  执行点击底部的四个按钮事件--------------
- (void)dock:(Dock *)dock itemSelectedFrom:(NSInteger)from to:(NSInteger)to{
    
    ShareHandle * handle = [ShareHandle shareHandle];
    
    switch (to) {
        case 10:
        {
//            NSLog(@"收藏");
//     //是否收藏过
           

            switch (self.fromLastValue) {
                case 100:{
             
                     BOOL isfavorite= [[ShareHandle shareHandle] isFavoriateWithUrlString:self.musicUrlString valueStr:100];
//                    NSLog(@"音乐");
                    if (isfavorite == YES) {
                        [self alert];
                        return;
                    }else{
                        [handle collected:self.musicModel withTag:100 withTotalUrl:self.musicUrlString];
                        
                        [self alertViewSave];
                    }
                    
                    break;
                }
                    
                case 101:{
                    BOOL isfavorite= [[ShareHandle shareHandle] isFavoriateWithUrlString:self.bookUrlString valueStr:101];
                    if (isfavorite == YES) {
                        [self alert];
                        return;
                        
                    }
                    else{
                        [handle collected:self.bookListModel withTag:101 withTotalUrl:self.bookUrlString];
//                        NSLog(@"听书");
                        [self alertViewSave];
                    }
                    
                    break;
                }
                case 102:{
                     BOOL isfavorite= [[ShareHandle shareHandle] isFavoriateWithUrlString:self.urlString valueStr:102];
                    if (isfavorite == YES) {
                        [self alert];
                        return;
                    }
                    else{
                        [handle collected:self.stationListModel withTag:102 withTotalUrl:self.urlString];
                        [self alertViewSave];
                    }
                    
                    break;
                }
                default:
                    
//                    NSLog(@"电台");
                    
                    break;
            }
            
            
            break;
        }
        case 11:{
//            NSLog(@"切换背景");
            NSMutableArray * imageArray = [NSMutableArray array];
            
            for (int i = 1; i < 10; i++) {
                UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
                [imageArray addObject:image];
            }
            
            self.view.backgroundColor = [UIColor colorWithPatternImage:imageArray[arc4random()%8+1]];
            
//            [handle contentNetworkStatusByAFNetworking];
          
            break;
        }
        case 12:{
//            NSLog(@"分享");
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"5613b714e0f55a347a008968"
                                              shareText:@"vdsvs"
                                             shareImage:nil
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToWechatFavorite,nil]
                                               delegate:nil];
            
            break;
        }
        case 13:{
//            NSLog(@"返回主页面");
//            ViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController_Id"];
////            [self showViewController:viewController sender:nil];//如果这样写的话，当从某一个页面推出再进去某一个界面，会崩溃
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        }
        default:
            break;
    }
    
    
}

- (void)alert{
    UIAlertView * alertV1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经收藏过了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertV1 show];
}

// 懒加载区域
- (NSMutableArray *)musicListArray{
    if (!_musicListArray) {
        _musicListArray = [NSMutableArray array];
    }
    return _musicListArray;
}

- (NSMutableArray *)bookArray{
    if (!_bookArray) {
        _bookArray = [NSMutableArray array];
    }
    return _bookArray;
}



#pragma mark  ====侯晓兰====
#pragma mark------点击播放上一首
- (IBAction)lastMusic:(UIButton *)sender {
    if (self.indexPath > 0) {
        self.indexPath--;
        
    }else{
        if (self.fromLastValue == 100) {
//            self.indexPath = self.musicListArray.count - 1;
            [self alertView];
        }else if (self.fromLastValue == 101){
//            self.indexPath = self.bookArray.count - 1;
            [self alertView];
        }else{
//            self.indexPath = self.stationListArray.count - 1;//若为0，点击的话播放上一首为 最后一首
            [self alertView];
        }
        
    }
    
    [self playMusicDetail];
}

- (void)alertView{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是第一首了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

#pragma mark------点击播放下一首

- (IBAction)nextMusic:(UIButton *)sender {
    if (self.fromLastValue == 100) {
        NSInteger count = self.musicListArray.count;
        if (self.indexPath < count - 1) {
            self.indexPath ++;
            
        }else{
            self.indexPath = 0;
        }
        
        [self playMusicDetail];
    }else if (self.fromLastValue == 101){
        NSInteger count = self.bookArray.count;
        if (self.indexPath < count - 1) {
            self.indexPath ++;
            
        }else{
            self.indexPath = 0;
        }
        
        [self playMusicDetail];
    }else{
        NSInteger count = self.stationListArray.count;
        if (self.indexPath < count - 1) {
            self.indexPath ++;
            
        }else{
            self.indexPath = 0;
        }
        
        [self playMusicDetail];
    }
    
}

#pragma mark-----点击播放或者暂停
- (IBAction)playOrPause:(UIButton *)sender {
    if ((sender.selected == YES)) {
        
//        [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
        //继续播放音乐
        [[PlayMusicManager shareInstance] playMusic];
        sender.selected = NO;
        
    }else{
//        [sender setTitle:@"播放" forState:(UIControlStateNormal)];
        //停止播放音乐
        [[PlayMusicManager shareInstance] pauseMusic];
        
        //设置点击状态为YES
        sender.selected = YES;
        
    }
    
    
    
    
}
#pragma mark------滑动滑竿,播放当前时间的音乐
- (IBAction)sliderAction:(UISlider *)sender {
    [[PlayMusicManager shareInstance] bySliderValueToPlayMusic:self.progressSlider.value];
    
}
#pragma mark-------实现代理协议中的方法
- (void)playMusicManagerFetchCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime progressValue:(CGFloat)progress{
    
    self.currentTimeLable.text = currentTime;
    self.totalTimeLable.text = totalTime;
    self.progressSlider.value = progress;
    
    
    
    
}
#pragma mark----当播放结束的时候，播放下一首歌曲
- (void)playMusicMangerPlayMusicEnd{
    [self nextMusic:nil];
    
}




#pragma mark---现在改为调节音量----(以前是随机播放音乐)------
- (IBAction)randomPlayRadio:(UIButton *)sender {
//    if (self.fromLastValue == 100) {
//        self.indexPath = arc4random() % self.musicListArray.count + 1;
//        [self playMusicDetail];
//    }else if (self.fromLastValue == 101){
//        self.indexPath = arc4random() % self.bookArray.count + 1;
//        [self playMusicDetail];
//        
//    }else{
//        self.indexPath = arc4random() % self.stationListArray.count + 1;
//        [self playMusicDetail];
//    }
    if (self.sliderIsShow == YES) {
        self.voiceSlider.hidden = NO;
        self.sliderIsShow = NO;
    }else{
        self.voiceSlider.hidden = YES;
        self.sliderIsShow = YES;
        
    }

    
}
#pragma mark-----是否显示tableView-------
- (IBAction)didShowTableView:(UIButton *)sender {
    if (self.isShow == YES) {
        self.listTableView.hidden = NO;
        self.isShow = NO;
     
        
    }else{
        self.listTableView.hidden = YES;
        self.isShow = YES;
    }
    
}


- (void)alertViewSave{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alert show];
    [self performSelector:@selector(dismissAlerView:) withObject:alert afterDelay:1.f];
    
    alert.delegate = self;
}
- (void)dismissAlerView:(UIAlertView *)alertView {
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark------滑动播放音乐
- (IBAction)VoiceSlider:(UISlider *)sender {
  
    [[PlayMusicManager shareInstance] setVolume:sender.value];
    
    
}
#pragma mark------当点击空白时，tableview 和音量消失
//实现触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //当点击的时候将蒙版从视图上移除
    [self.coverView removeFromSuperview];
    //当点击空白时，tableview 和音量消失
    self.voiceSlider.hidden = YES;
    self.sliderIsShow = YES;
    
    
    self.listTableView.hidden = YES;
    self.isShow = YES;
    
}


#pragma mark   网络判断
- (void)checkNetWork{
    
    ShareHandle * handle = [ShareHandle shareHandle];
    [handle contentNetworkStatusByAFNetworking];
    [handle netType];
    
    NSUserDefaults * listen = [NSUserDefaults standardUserDefaults];
    _isListen = [listen boolForKey:@"isUseMobelListen"];
    
    switch (handle.netType) {
        case 0:
            [self alertView:@"请检查您的网络设置=="];
            break;
        case 1:
            if (_isListen) {
//                NSLog(@"使用流量收听");
                [self alertView:@"当前为数据网播放 请注意资费"];
            }else{
                [self alertView:@"数据网播放已关闭  请前往设置开启"];
            }
            break;
        case 2:
            [self alertView:@"wifi状态下请尽情收听"];
            break;
            
        default:
            break;
    }
    
}


- (void)alertView:(NSString *)mess{
    self.alertView1 = [[UIAlertView alloc] initWithTitle:@"提示" message:mess delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [_alertView1 show];
}

- (void)dismissAlerView1:(UIAlertView *)alertView {
    
    [alertView dismissWithClickedButtonIndex:1 animated:YES];
}

@end
