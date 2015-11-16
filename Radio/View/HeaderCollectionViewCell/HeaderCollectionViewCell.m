//
//  HeaderCollectionViewCell.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//
#define kCount 5
#import "HeaderCollectionViewCell.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"
#import "FeaturedCollectionViewController.h"

@implementation HeaderCollectionViewCell
-(void)setModel:(MusicModel *)model{
    if (_model != model) {
        _model = model;
//       UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
//        self.scrollView = scrollView;
      
  
    }
   
}


- (void)awakeFromNib {
    CGFloat imgW = self.scrollView.frame.size.width;//宽
    CGFloat imgH = self.scrollView.frame.size.height;//高
    CGFloat imgY = 0;//Y
    
    [self setModel:_model];
    self.picsArray = [NSMutableArray array];
    for (int i = 0; i < kCount; i++) {
       
        
        self.imgViewPicture = [[UIImageView alloc] init];
        CGFloat imgX = i * imgW;//X
        self.imgViewPicture.frame = CGRectMake(imgX, imgY, imgW, imgH);
                [self.imgViewPicture sd_setImageWithURL:[NSURL URLWithString:self.model.pic]placeholderImage:[UIImage imageNamed:@"xiaogui.jpg"]];
        
        self.imgViewPicture.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
        [self.picsArray addObject:self.imgViewPicture];
        [self.scrollView addSubview:self.imgViewPicture];
        
    }
    //添加手势
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.scrollView addGestureRecognizer:tapGR];
//
    self.imgViewPicture.userInteractionEnabled = YES;//打开交互
    //隐藏水平滚动指示器
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    //设置代理
    self.scrollView.delegate = self;
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(kCount* self.scrollView.frame.size.width, 0);
    
#pragma mark----UIPageControll
    
    self.pageControll.currentPage = 0;
    self.pageControll.numberOfPages = kCount ;
    //
#pragma mark-----创建一个计时器空间NSTimer---
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    

    
}

- (void)tap:(UITapGestureRecognizer *)GR{
//    NSLog(@"推出详情");
    //代理执行协议中的方法

    if ([self.delegate respondsToSelector:@selector(pushNextViewControllerIndex:)]) {
        [self.delegate pushNextViewControllerIndex:self.pageControll.currentPage];
        
    }
    
}
//每隔1s执行一次这个方法：自动滚动图片
- (void)scrollImage{
    
    NSInteger page = self.pageControll.currentPage;
    if (page == self.pageControll.numberOfPages - 1) {
        
        //表示已经到达最后一页
        page = 0;
        
    }else{
        page++;
    }
    
    CGFloat offSetX = page * self.scrollView.frame.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:NO];

    
}

#pragma mark-----实现代理协议中的方法----
#pragma mark---------实现UIScrollView的滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
 
    
    
    NSInteger number = self.scrollView.contentOffset.x/CGRectGetWidth(self.scrollView.frame);
    self.pageControll.currentPage = number;
    
    //设置新闻的标题==================
//    self.adsModel = [[DataHandle shareInstance] adsArray][number];
//    self.scrollViewTitleLable.text = self.adsModel.title;
    
}


@end
