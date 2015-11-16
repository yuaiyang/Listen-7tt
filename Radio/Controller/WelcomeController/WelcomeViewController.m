//
//  WelcomeViewController.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/22.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ViewController.h"
@interface WelcomeViewController () <UIScrollViewDelegate>

@property (strong , nonatomic) UIScrollView * scrollView;
@property (strong , nonatomic) UIPageControl * pageController;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addImageView];
    [self addPageControll];
    self.scrollView.delegate = self;
    
}

- (void)addImageView{
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.view.frame;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < 3; i++) {
        CGFloat viewX = self.view.frame.origin.x + self.view.frame.size.width * i;
        CGFloat viewW = self.view.frame.size.width;
        CGFloat viewH = self.view.frame.size.height;
        
        NSString * imageName = [NSString stringWithFormat:@"welcome%d.png" , i + 1];
        UIImage * image = [UIImage imageNamed:imageName];
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(viewX, 0, viewW, viewH)];
        imgView.image = image;
        [self.scrollView addSubview:imgView];
        
        if (i == 2) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(self.view.frame.size.width * 0.4, self.view.frame.size.height * 0.8, 80, 30);
            [button setBackgroundColor:[UIColor redColor]];
            imgView.userInteractionEnabled = YES;
            [button setTitle:@"开始体验" forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:button];
            
        }
        
    }
    [self.view addSubview:self.scrollView];
}


- (void)click:(UIButton *)button{
    
//    [self dismissViewControllerAnimated:YES completion:nil];
        
        ViewController * VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController_Id"];
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        //这里如果不写NC的话，就会出现push出来了
        UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:VC];
        window.rootViewController = NC;
        
    
    
}


- (void)addPageControll{
    
    self.pageController = [[UIPageControl alloc] init];
    self.pageController.numberOfPages = 3;
    self.pageController.frame = CGRectMake(self.view.frame.size.width * 0.4, self.view.frame.size.height * 0.9, 50, 30);
    
    [self.view addSubview:self.pageController];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _pageController.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end
