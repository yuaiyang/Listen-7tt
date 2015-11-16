//
//  AppDelegate.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/20.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "WelcomeViewController.h"
#import "UMSocial.h"
#import "PlayMusicManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //友盟
    [UMSocialData setAppKey:@"5613b714e0f55a347a008968"];
    //版本新特性
    [self welcomeVC];

    return YES;
    
}

- (void)welcomeVC{
    //存在沙盒里的key值
    NSString * key = @"CFBundleVersion";
    //上一次的使用版本（存储在沙盒中的版本号）如果版本升级，info.plist中的BundleVersion版本号也要修改
    NSString * lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    //当前软件的版本号（从Info.plist中获得）
#warning mark-----想读取当前版本号只能用这种方法----
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        //若这次打开和上次打开的版本号相同
        
        ViewController * VC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController_Id"];
        UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:VC];
        self.window.rootViewController = NC;
        
    }else{
        //这次打开的版本和上一次的不一样，显示新特性
        
        
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"welcomeVC"];;
        //将当前版本存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];//将当前版本号马上同步到沙盒当中去
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
