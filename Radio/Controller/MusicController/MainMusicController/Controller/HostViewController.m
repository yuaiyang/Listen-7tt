//
//  HostViewController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "HostViewController.h"

#import "AllMusicViewController.h"
#import "Urls.h"
#import "MusicModel.h"

@interface HostViewController () <ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic ,strong)NSMutableArray * modelsArray;
@end

@implementation HostViewController

- (void)viewDidLoad {
#pragma mark-------解析数据（放在这里就可以）
    //解析数据
    [self readData];
    self.dataSource = self;
    self.delegate = self;
    
    self.title = @"View Pager";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];
    
    
    
}

- (void)readData{
    NSURL * urlString = [NSURL URLWithString:kHeaderAllUrls];
    NSURLRequest * request = [NSURLRequest requestWithURL:urlString];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data != nil) {
        NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.modelsArray = [NSMutableArray array];
        NSMutableDictionary * dict = dic[@"result"];
        NSArray * array = dict[@"dataList"];
        for (NSDictionary * dict1 in array) {
            MusicModel * model = [[MusicModel alloc] init];
            [model setValuesForKeysWithDictionary:dict1];
            [self.modelsArray addObject:model];
                        
        }

//        NSLog(@"++++++++++++++===============%@ ,%ld",self.modelsArray,self.modelsArray.count);
        
    }
    /*
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//       
//        if (data != nil) {
//            NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
//            self.modelsArray = [NSMutableArray array];
//            NSMutableDictionary * dict = dic[@"result"];
//            NSArray * array = dict[@"dataList"];
//            for (NSDictionary * dict1 in array) {
//                musicAllModel * model = [[musicAllModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict1];
//                [self.modelsArray addObject:model];
//                
//            }
//            NSLog(@"++++++++++++++===============%@ ,%ld",self.modelsArray,self.modelsArray.count);
//        }
//        NSLog(@"++++++++++++++===============%@ ,%ld",self.modelsArray,self.modelsArray.count);
//
//    }];
////
//    NSLog(@"++++++++++++++===============%@ ,%ld",self.modelsArray,self.modelsArray.count);

     */
     
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {

//    NSLog(@"%ld",self.modelsArray.count);
    return self.modelsArray.count;//上面有10个View
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
//    
    UILabel *label = [UILabel new];

    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
#pragma mark-----将 标题添加到label上
    MusicModel * model = self.modelsArray[index];
    label.text = model.categoryName;

    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;

    
    
    
}
#pragma mark--------将AllMusicViewController作为视图控制器解析数据用的工具
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
 
    AllMusicViewController * cvc = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"allMusicView_Id"];
    
    MusicModel  * model = self.modelsArray[index];
    cvc.model = model;
    
//    cvc.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    return cvc;
}
//
//#pragma mark - ViewPagerDelegate
//- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
//    
//    switch (option) {
//        case ViewPagerOptionStartFromSecondTab:
//            return 1.0;
//            break;
//        case ViewPagerOptionCenterCurrentTab:
//            return 0.0;
//            break;
//        case ViewPagerOptionTabLocation:
//            return 1.0;
//            break;
//        default:
//            break;
//    }
//    
//    return value;
//}
//- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
//    
//    switch (component) {
//        case ViewPagerIndicator:
//            return [[UIColor redColor] colorWithAlphaComponent:0.64];
//            break;
//        default:
//            break;
//    }
//    
//    return color;
//}
//
@end
