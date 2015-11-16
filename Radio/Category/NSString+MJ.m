//
//  NSString+MJ.m
//  新浪微博
//
//  Created by 雨爱阳 on 15/10/17.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "NSString+MJ.h"
@implementation NSString (MJ)

- (NSString *)fileAppend:(NSString *)append{
    // 1.1.获得文件拓展名
    NSString *ext = [self pathExtension];
    
    // 1.2.删除最后面的扩展名
    NSString * imgName = [self stringByDeletingPathExtension];
    
    // 1.3.拼接-568h@2x
    imgName = [imgName stringByAppendingString:@"_selected"];
    
    // 1.4.拼接扩展名
    imgName = [imgName stringByAppendingPathExtension:ext];

    return imgName;
    
}

@end
