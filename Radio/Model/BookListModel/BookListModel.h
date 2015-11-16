//
//  BookListModel.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookListModel : NSObject

@property (strong , nonatomic) NSString * describe;
@property (assign , nonatomic) NSInteger id;
@property (strong , nonatomic) NSString * image_url;
@property (assign , nonatomic) NSInteger play_num;
@property (strong , nonatomic) NSString * tag_image_url;
@property (strong , nonatomic) NSString * title;
@property (assign , nonatomic) NSInteger album_id;

@end
