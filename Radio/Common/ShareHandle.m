//
//  ShareHandle.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/20.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "ShareHandle.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#import "bookPlayModel.h"
#import "MusicListModel.h"
#import "StationListModel.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "LiveModel.h"

typedef enum{
    NotNet = 0,     //无网络连接
    WifiNet,           //wifi网络
    OtherNet,       //gprs/3g网络
}NetType;

@interface ShareHandle () <UIAlertViewDelegate>

@property (strong , nonatomic) bookPlayModel * bookModel;
@property (strong , nonatomic) MusicListModel * musicModel;
@property (strong , nonatomic) StationListModel * stationModel;
@property (strong , nonatomic) LiveModel * liveModel;
@property (strong , nonatomic) UIAlertView * alertView;
@property (nonatomic,assign)NSInteger tagValue;


@end

@implementation ShareHandle

static ShareHandle *handle = nil;

+ (ShareHandle *)shareHandle{
    
    static dispatch_once_t predicated;
    dispatch_once(&predicated, ^{
        handle = [[ShareHandle alloc] init];
//        [handle contentNetworkStatusByAFNetworking];
    });
    return handle;
    
}



- (void)isUseMobelDownLoade:(BOOL)state{
    //获取NSUserDefaults单例对象
    NSUserDefaults * userState = [NSUserDefaults standardUserDefaults];
    //数据持久化，将文件写入
    [userState setBool:state forKey:@"isUseMobelDownLoade"];
    [userState synchronize];//立即同步到文件中
}

- (void)isUseMobelListen:(BOOL)state{
    
    NSUserDefaults * userState = [NSUserDefaults standardUserDefaults];
    [userState setBool:state forKey:@"isUseMobelListen"];
    [userState synchronize];
    
}

- (void)isPlayWithOn:(BOOL)state{
    
    NSUserDefaults * userState = [NSUserDefaults standardUserDefaults];
    [userState setBool:state forKey:@"isPlayWithOn"];
    [userState synchronize];
    
}



#pragma mark  建立收藏的三个表
- (void)creatDB{
    // 数据库创建地址
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * filePath = [documentPath stringByAppendingPathComponent:@"Collected.db"];
    // 创建数据库
    self.database = [FMDatabase databaseWithPath:filePath];
    
    if ([self.database open]) {
//        NSLog(@"创建成功");
    }
//    NSLog(@"数据库地址=%@",filePath);
    // 创建表
    [self.database executeUpdate:@"create table IF NOT EXISTS Music (urlString text PRIMARY KEY, albumName text, audioDes text, audioPic text, mp3PlayUrl text, audioName text)"];
    
    [self.database executeUpdate:@"create table IF NOT EXISTS Book (urlString text PRIMARY KEY, audio_64_url text, album_id text, audio_32_size text, duration text, title text)"];
    
    [self.database executeUpdate:@"create table IF NOT EXISTS Station (urlString text PRIMARY KEY,cover_path text, cover_url text, sound_url text,title text)"];
    
    [self.database executeUpdate:@"create table IF NOT EXISTS Live (comperes text,liveName text PRIMARY KEY,liveDesc text,avatar text,livePic text,liveUrl text,showStartTime text,onLineNum integer,nextPage interage)"];
    
    
}




#pragma mark   收藏

- (void)collected:(NSObject *)model withTag:(NSInteger)tag withTotalUrl:(NSString *)urlString{
  
    switch (tag) {
        case 100:
//            NSLog(@"音乐");
            self.musicModel = (MusicListModel *)model;
//            NSLog(@"self.musicModel = %@" , self.musicModel);
            [self creatDB];
            
            [self.database executeUpdateWithFormat:@"insert into Music (urlString,albumName,audioDes,audioPic,mp3PlayUrl,audioName) values (%@,%@,%@,%@,%@,%@)",urlString,_musicModel.albumName,_musicModel.audioDes,_musicModel.audioPic,_musicModel.mp3PlayUrl,_musicModel.audioName];
            
            
            break;
            
        case 101:
//            NSLog(@"听书");
            self.bookModel = (bookPlayModel *)model;
//            NSLog(@"self.bookModel = %@" , self.bookModel);
            [self creatDB];
            [self.database executeUpdateWithFormat:@"insert into Book (urlString,audio_64_url,album_id,audio_32_size,duration,title) values (%@,%@,%@,%@,%@,%@)",urlString,_bookModel.audio_64_url,_bookModel.album_id,_bookModel.audio_32_size,_bookModel.duration,_bookModel.title];
            
            break;
        case 102:
            self.stationModel = (StationListModel *)model;
//            NSLog(@"self.stationModel = %@" , self.stationModel);
//            NSLog(@"电台");
            [self creatDB];
            
            [self.database executeUpdateWithFormat:@"insert into Station (urlString,cover_path,cover_url,sound_url,title) values (%@,%@,%@,%@,%@)",urlString,_stationModel.cover_path,_stationModel.cover_url,_stationModel.sound_url,_stationModel.title];
//            NSLog(@"==");
        default:
            break;
    }
}
#pragma mark 收藏直播节目
- (void)collectedLiveWithModel:(NSObject *)model{
    self.liveModel = (LiveModel *)model;
    [self creatDB];
    [self.database executeUpdateWithFormat:@"insert into Live (comperes , liveName , liveDesc , avatar , livePic , liveUrl , showStartTime , onLineNum , nextPage) values (%@,%@,%@,%@,%@,%@,%@,%ld,%ld)" , _liveModel.comperes , _liveModel.liveName,_liveModel.liveDesc,_liveModel.avatar,_liveModel.livePic,_liveModel.liveUrl,_liveModel.showStartTime,_liveModel.onLineNum,_liveModel.nextPage];
    
    [self.database close];
}
#pragma mark 查询直播节目
- (NSMutableArray *)queryLiveModel{
    
    [self creatDB];
    self.liveArray = [NSMutableArray array];
    if ([self.database open]) {
        FMResultSet * resultSet = [self.database executeQuery:@"select * from Live"];
        while ([resultSet next]) {
            self.liveModel = [[LiveModel alloc] init];
            self.liveModel.comperes = [resultSet stringForColumn:@"comperes"];
            self.liveModel.liveName = [resultSet stringForColumn:@"liveName"];
            self.liveModel.liveDesc = [resultSet stringForColumn:@"liveDesc"];
            self.liveModel.avatar = [resultSet stringForColumn:@"avatar"];
            self.liveModel.livePic = [resultSet stringForColumn:@"livePic"];
            self.liveModel.liveUrl = [resultSet stringForColumn:@"liveUrl"];
            self.liveModel.showStartTime = [resultSet stringForColumn:@"showStartTime"];
            self.liveModel.onLineNum = [resultSet intForColumn:@"onLineNum"];
            self.liveModel.nextPage = [resultSet intForColumn:@"nextPage"];
            [self.liveArray addObject:self.liveModel];
        }
    }
    [self.database close];
    return self.liveArray;
}
#pragma mark  查询数据库

- (NSArray *)queryDBWithTags:(NSInteger)tag{
    [self creatDB];
    self.musicArray = [NSMutableArray array];
    self.bookArray = [NSMutableArray array];
    self.stationArray = [NSMutableArray array];
    switch (tag) {
        case 100:
            if ([self.database open]) {
                // 查询整个表
                FMResultSet * resultSet = [self.database executeQuery:@"select * from Music"];
                while ([resultSet next]) {
                    
                    self.musicModel = [[MusicListModel alloc] init];
                    self.musicModel.urlString = [resultSet stringForColumn:@"urlString"];
                    self.musicModel.albumName = [resultSet stringForColumn:@"albumName"];
                    self.musicModel.audioDes = [resultSet stringForColumn:@"audioDes"];
                    self.musicModel.audioPic = [resultSet stringForColumn:@"audioPic"];
                    self.musicModel.mp3PlayUrl = [resultSet stringForColumn:@"mp3PlayUrl"];
                  
                    [self.musicArray addObject:self.musicModel];
                    
                }
            }
            [self.database close];
            return self.musicArray;
            
            break;
        case 101:
            if ([self.database open]) {
                //查询整个表
                FMResultSet * resultSet = [self.database executeQuery:@"select * from Book"];
                while ([resultSet next]) {
                    
                    self.bookModel = [[bookPlayModel alloc] init];
                    
                    self.bookModel.title =[resultSet stringForColumn:@"title"];
                    self.bookModel.album_id = [resultSet stringForColumn:@"album_id"];
                    
                    self.bookModel.audio_64_url = [resultSet stringForColumn:@"audio_64_url"];
                    self.bookModel.audio_32_size =[resultSet stringForColumn:@"audio_32_size"];
                    self.bookModel.duration = [resultSet stringForColumn:@"duration"];
                    self.bookModel.urlString = [resultSet stringForColumn:@"urlString"];
                    [self.bookArray addObject:self.bookModel];
                    
                }
                
            }
            [self.database close];
            return self.bookArray;
            break;
            
        default:
            self.stationArray = [NSMutableArray array];
            if ([self.database open]) {
                
                FMResultSet * resultSet = [self.database executeQuery:@"select * from Station"];
                while ([resultSet next]) {
                    self.stationModel = [[StationListModel alloc] init];
                    self.stationModel.cover_path = [resultSet stringForColumn:@"cover_path"];
                    self.stationModel.cover_url = [resultSet stringForColumn:@"cover_url"];
                    self.stationModel.sound_url = [resultSet stringForColumn:@"sound_url"];
//                    self.stationModel.sound_path = [resultSet stringForColumn:@"sound_path"];
                    self.stationModel.urlString = [resultSet stringForColumn:@"urlString"];
                    [self.stationArray addObject:self.stationModel];
                }
                
            }
            [self.database close];
            return self.stationArray;
            break;
    }
    
    return nil;
    
}
#pragma mark  判断网络

//- (void)contentNetworkStatusByAFNetworking {
//    
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable: {
//                
//                [self showAlertViewWithTitleString:@"请检查网络连接状态"];
//                self.netType = AFNetworkReachabilityStatusNotReachable;
//                NSLog(@"netType = %ld" , self.netType);
//                break;
//            }
//            case AFNetworkReachabilityStatusReachableViaWWAN: {
//                
//                [self showAlertViewWithTitleString:@"3G/4G会消耗流量  您确定么?"];
//                self.netType = AFNetworkReachabilityStatusReachableViaWWAN;
//                NSLog(@"netType = %ld" , self.netType);
//                break;
//            }
//            case AFNetworkReachabilityStatusReachableViaWiFi: {
//                
//                [self showAlertViewWithTitleString:@"WIFI状态下我们为您自动下载"];
//                self.netType = AFNetworkReachabilityStatusReachableViaWiFi;
//                [self dismissAlerView:self.alertView];
//                NSLog(@"netType = %ld" , self.netType);
//                break;
//            }
//            default:
//                break;
//        }
//    }];
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//}

- (void)contentNetworkStatusByAFNetworking {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                
                
                self.netType = AFNetworkReachabilityStatusNotReachable;
//                NSLog(@"netType = %ld" , self.netType);
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                
                
                self.netType = AFNetworkReachabilityStatusReachableViaWWAN;
//                NSLog(@"netType = %ld" , self.netType);
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                
                
                self.netType = AFNetworkReachabilityStatusReachableViaWiFi;
                [self dismissAlerView:self.alertView];
                
                break;
            }
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
- (void)showAlertViewWithTitleString:(NSString *)titleString {
    
    self.alertView = [[UIAlertView alloc] initWithTitle:titleString message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [_alertView show];
//    [self performSelector:@selector(dismissAlerView:) withObject:_alertView afterDelay:2.f];
    
    _alertView.delegate = self;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
//        NSLog(@"确定");
        switch (self.netType) {
            case 0:
//                NSLog(@"请检查你的网络设置");
                break;
            case 1:
//                NSLog(@"当前网络连接状态:3G/4G");
                break;
            case 2:
//                NSLog(@"当前网络连接状态:WIFI");
                break;
            default:
                break;
        }
        
        
        
    }else{
//        NSLog(@"取消");
    }
    
}


- (void)dismissAlerView:(UIAlertView *)alertView {
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}



#pragma mark   下载区域
- (void)downLoadWithModel:(NSObject *)model byTag:(NSInteger)tag{
    
    switch (tag) {
        case 100:
            
            self.musicModel = (MusicListModel *)model;
            
            break;
            
        case 101:
            
            self.bookModel = (bookPlayModel *)model;
            
            break;
            
        default:
            
            self.stationModel = (StationListModel *)model;
            
            break;
    }
    
}


#pragma mark  删除数据库
- (void)deleteMusicDBWithUrl:(NSString *)url{ // 删除音乐
    if ([self.database open]) {
        [self.database executeUpdateWithFormat:@"delete from Music where urlString = %@",url];
        [self.database close];
    }
}

- (void)deleBookDBWithUrl:(NSString *)url{ // 删除图书
    
    if ([self.database open]) {
        [self.database executeUpdateWithFormat:@"delete from Book where urlString = %@",url];
        [self.database close];
    }
}

- (void)deleStationDBWithUrl:(NSString *)url{ // 删除电台
    if ([self.database open]) {
        [self.database executeUpdateWithFormat:@"delete from Station where urlString = %@",url];
        [self.database close];
    }
}

- (void)deleLiveDBWithUrl:(NSString *)url{
    if ([self.database open]) {
        [self.database executeUpdateWithFormat:@"delete from Live where liveName = %@",url];
        [self.database close];
    }
}


#pragma mark  懒加载区域
//- (NSMutableArray *)bookArray{
//    if (!_bookArray) {
//        _bookArray = [NSMutableArray array];
//    }
//    return _bookArray;
//}
//
//
//
//- (NSMutableArray *)stationArray{
//    if (!_stationArray) {
//        _stationArray = [NSMutableArray array];
//    }
//    return _stationArray;
//}
- (NSInteger)tag{
    return self.tag;
    
}
#pragma mark------是否收藏过--------
//- (BOOL)isFavoriateWithUrlString:(NSString *)urlStr{
//
//    
//    NSArray * array = [self queryDBWithTags:100];
//            for (MusicListModel * model in array) {
//                if ([model.urlString isEqualToString:urlStr]) {
//    
//                    return YES;
//                }
//    
//    
//            }
//
//    return NO;
//}

- (BOOL)isFavoriateWithUrlString:(NSString *)urlStr valueStr:(NSInteger)tag{
    NSArray * array = [self queryDBWithTags:tag];
    if (tag == 100) {
        for (MusicListModel * model in array) {
            if ([model.urlString isEqualToString:urlStr]) {
                
                return YES;
            }
            
            
        }

    }else if (tag == 101){
        for (bookPlayModel * model in array) {
            if ([model.urlString isEqualToString:urlStr]) {
                
                return YES;
            }
            
            
        }

    }else if (tag == 102){
        for (StationListModel * model in array) {
            if ([model.urlString isEqualToString:urlStr]) {
                
                return YES;
            }
            
            
        }

   }
    
    return NO;
}
@end
