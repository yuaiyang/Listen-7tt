//
//  StationListModel.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/26.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationListModel : NSObject

@property (strong , nonatomic) NSString * cover_path;//
@property (strong , nonatomic) NSString * cover_url;//图片
@property (strong , nonatomic) NSString * sound_url;//听的网址
@property (strong , nonatomic) NSString * sound_path;
@property (strong , nonatomic) NSString * title;//唱片名
@property (nonatomic ,strong)NSString * urlString;

//@property (nonatomic ,strong)NSString * 


@end
