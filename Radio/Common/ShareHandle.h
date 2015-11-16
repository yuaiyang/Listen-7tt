//
//  ShareHandle.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/20.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@interface ShareHandle : NSObject

@property (assign , nonatomic) BOOL isUseMobelListen;
@property (assign , nonatomic) BOOL isUseMobelDownLoade;
@property (assign , nonatomic) BOOL isPlayWithOn;
@property (assign , nonatomic) NSInteger switchValue;
@property (assign , nonatomic) NSInteger timeSet;
@property (strong , nonatomic) NSMutableArray * stationArray;  // 测试
@property (strong , nonatomic) NSMutableArray * bookArray;
@property (strong , nonatomic) NSMutableArray * musicArray;
@property (strong , nonatomic) NSMutableArray * liveArray;;

// 判断网络
@property (assign , nonatomic) NSInteger netType;
//- (void)registNetWorkChangeNot;
//- (void)removeNetWorkChangeNot;
//- (void)checkNetworkStatus:(NSNotification *)not;
- (void)contentNetworkStatusByAFNetworking;

@property (strong , nonatomic) FMDatabase * database;
+ (ShareHandle *)shareHandle;


#pragma mark   通过单例获取状态
- (void)isUseMobelDownLoade:(BOOL)state;
- (void)isUseMobelListen:(BOOL)state;
- (void)isPlayWithOn:(BOOL)state;


// 收藏
- (void)creatDB;//创建数据库
- (void)collected:(NSObject *)model withTag:(NSInteger)tag withTotalUrl:(NSString *)urlString;
//- (void)queryDBWithTag:(NSInteger)tag;
- (NSArray *)queryDBWithTags:(NSInteger)tag;
- (void)collectedLiveWithModel:(NSObject *)model;
- (NSMutableArray *)queryLiveModel;
- (void)deleteMusicDBWithUrl:(NSString *)url;
- (void)deleBookDBWithUrl:(NSString *)ur;
- (void)deleStationDBWithUrl:(NSString *)url;
- (void)deleLiveDBWithUrl:(NSString *)url;
//是否收藏过
//- (BOOL)isFavoriateWithUrlString:(NSString *)urlStr;
- (BOOL)isFavoriateWithUrlString:(NSString *)urlStr valueStr:(NSInteger)tag;

@end
