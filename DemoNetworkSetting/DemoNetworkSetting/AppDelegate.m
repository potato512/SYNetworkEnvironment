//
//  AppDelegate.m
//  DemoNetworkSetting
//
//  Created by zhangshaoyu on 16/8/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "SYNetworkEnvironment.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // 标题按钮设置
    NetworkRequestEnvironment.titleFont = [UIFont systemFontOfSize:13.0];
    NetworkRequestEnvironment.titleColorNormal = [UIColor blackColor];
    NetworkRequestEnvironment.titleColorHlight = [UIColor redColor];
    // 环境设置
    NetworkRequestEnvironment.networkEnviroment = 0;
    NetworkRequestEnvironment.networkServiceDebug = @"http://www.hao123.com";
    NetworkRequestEnvironment.networkServiceRelease = @"http://www.baidu.com";
    NetworkRequestEnvironment.networkServiceDebugDict = @{@"天猫":@"http://www.tiaomiao.com",@"淘宝":@"http://www.taobao.com",@"京东":@"http://www.jindong.com"};
    // 初始化
    [NetworkRequestEnvironment initializeNetworkEnvironment];
    
    
    
    ViewController *rootVC = [[ViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = rootNav;
    [self.window makeKeyAndVisible];
    
    return YES;
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

// 初始化视图控制器
- (void)initRootViewController
{
    ViewController *rootVC = [[ViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = rootNav;
    [self.window makeKeyAndVisible];
}

@end
