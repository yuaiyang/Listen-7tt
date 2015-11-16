//
//  DockItem.m
//  新浪微博
//
//  Created by 雨爱阳 on 15/10/17.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

// 代表一个选项卡

#import "DockItem.h"

#define kTitleRation 0.3
#define kImageRation 0.7

@implementation DockItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1;文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 2;文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        
        // 3;内部图片设置
        self.imageView.contentMode = UIViewContentModeCenter;
        
        // 4;设置选中状态的背景
        
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_slider.png"] forState:UIControlStateSelected];
        
    }
    return self;
}

#pragma mark  调整内部imageView的fram
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * kImageRation;
    CGFloat titleY = 0;
    CGFloat titleWidth = contentRect.size.width;
    
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

// 调整内部的UILabel的fram
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * kTitleRation;
    CGFloat titleY = contentRect.size.height - titleHeight - 3;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

#pragma mark  覆盖父类的方法
- (void)setHighlighted:(BOOL)highlighted{
    // 如果调用super相当于没有写
    
}


@end
