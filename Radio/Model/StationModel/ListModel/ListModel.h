//
//  ListModel.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (assign , nonatomic) NSInteger category_id;
@property (strong , nonatomic) NSString * category_name;
@property (strong , nonatomic) NSDictionary * user_list;

@end
