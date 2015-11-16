//
//  Dock.m
//  新浪微博
//
//  Created by 雨爱阳 on 15/10/17.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

// 底部选项条
#import "Dock.h"
#import "DockItem.h"
#import "NSString+MJ.h"

@interface Dock ()
{
    DockItem * _selectedItem;
}
@end

@implementation Dock

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]]; // 样板背景图片
    return self;
}

- (void)addItemWithIcon:(NSString *)icon title:(NSString *)title{
    
    // 1;创建item
    DockItem * item = [[DockItem alloc] init];
    
    [item setTitle:title forState:UIControlStateNormal];
    // 设置内部imageView图片只有用下面方法   不要用setback那个
    [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
    [item setImage:[UIImage imageNamed:[icon fileAppend:@"_selected"]] forState:UIControlStateSelected];
   
    // 给item设置监听事件
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    
    // 2;添加item
    [self addSubview:item];
    // 3;调整item的fram
    [UIView beginAnimations:nil context:nil];
    NSInteger count = self.subviews.count;

    CGFloat height = self.frame.size.height; // 高度
    CGFloat width = self.frame.size.width / count; // 宽度
    for (int i = 0; i<count; i++) {
        DockItem *dockItem = self.subviews[i];
        dockItem.tag = i + 10; // 绑定标记
        dockItem.frame = CGRectMake(width * i, 0, width, height);
        

        
    }
    
    [UIView commitAnimations];
//    NSLog(@"+++++");
}


#pragma mark item 监听事件
- (void)itemClick:(DockItem *)item{
    
    if ([_delegate respondsToSelector:@selector(dock:itemSelectedFrom:to:)]) {
        [_delegate dock:self itemSelectedFrom:_selectedItem.tag to:item.tag];
    }

}


@end
