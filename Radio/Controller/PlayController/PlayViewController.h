//
//  PlayViewController.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserDetailModel;
@class BookListModel;
@interface PlayViewController : UIViewController

@property (strong , nonatomic) UserDetailModel * stationModel;
@property (assign , nonatomic) NSInteger stationID;
@property (assign, nonatomic) NSInteger fromLastValue; // 接收上一个页面传值判断式那个模块
@property (assign , nonatomic) NSInteger musicID; // 拼接音乐网址
@property (assign , nonatomic) NSInteger bookID; // 拼接图书网址
@property (strong , nonatomic) NSString * bookImage; // 这个页面没有值  接收上个页面传过来的值




//3
+ (PlayViewController *)shareInstance;
@property (nonatomic ,assign)NSInteger indexPath;
@property (nonatomic ,assign)NSInteger section;
@property (nonatomic ,strong)NSString * Url;//从收藏界面传过来的网址

@property (nonatomic ,assign)NSInteger ID;//接收从收藏界面传过来的ID
@property (nonatomic,assign)NSInteger tags;//接收从精选页面传过来的tag值



@property (nonatomic ,assign)NSInteger tagsController;

@end
