//
//  UserDetailModel.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetailModel : NSObject

@property (assign , nonatomic) BOOL is_follow;
@property (assign , nonatomic) NSInteger lastest_sound;
@property (strong , nonatomic) NSString * user_avatar;
@property (strong , nonatomic) NSString * user_nick;
@property (assign , nonatomic) NSInteger user_id;
@property (assign , nonatomic) NSInteger user_fans;
@property (assign , nonatomic) NSInteger user_sounds;
@property (assign , nonatomic) NSInteger vip_show;
@property (strong , nonatomic) NSDictionary * is_vip;




@end
