//
//  Dock.h
//  新浪微博
//
//  Created by 雨爱阳 on 15/10/17.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Dock;
@protocol DockDelegate <NSObject>

@optional
- (void)dock:(Dock *)dock itemSelectedFrom:(NSInteger)from to:(NSInteger)to;

@end



@interface Dock : UIView

// 动态添加底部按钮

- (void)addItemWithIcon:(NSString *)icon title:(NSString *)title;

@property (weak , nonatomic) id<DockDelegate> delegate;

@end
