//
//  HeaderCollectionViewCell.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;
//@class HeaderCollectionViewCell;

@protocol HeaderCollectionViewCellDelegate <NSObject>

- (void)pushNextViewController;
//- (void)HeaderCollectionViewCellPushNextViewController:(HeaderCollectionViewCell*)header indexPath:(NSIndexPath *)index;
- (void)pushNextViewControllerIndex:(NSInteger)currentPage;
@end


@interface HeaderCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;



@property (nonatomic ,strong)UIImageView * imgViewPicture;

- (void)count:(NSInteger)count arrays:(NSArray *)array;

@property (nonatomic,strong)MusicModel * model;
@property (nonatomic ,strong)NSMutableArray * picsArray;
@property (nonatomic ,weak)id<HeaderCollectionViewCellDelegate>delegate;


@end
