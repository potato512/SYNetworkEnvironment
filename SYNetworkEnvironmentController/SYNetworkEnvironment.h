//
//  SYNetworkEnvironment.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/8/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  网络环境配置组件github：https://github.com/potato512/SYNetworkEnvironment
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/************************************************************************/

#define NetworkEnvironment ([SYNetworkEnvironment shareEnvironment])
#define NetworkHost        ([[SYNetworkEnvironment shareEnvironment] getDefaultNetworkHost])

/************************************************************************/


@interface SYNetworkEnvironment : NSObject

/// 网络环境（0为测试环境；1为线上环境）
@property (nonatomic, assign) BOOL environment;
/// 测试环境地址（默认地址）
@property (nonatomic, strong) NSString *environmentHostDebug;
/// 线上环境地址（线上地址）
@property (nonatomic, strong) NSString *environmentHostRelease;
/// 测试环境地址集合（默认地址）
@property (nonatomic, strong) NSDictionary *environmentHostDebugDict;


+ (SYNetworkEnvironment *)shareEnvironment;

/// 初始化网络环境（注意：发布时环境状态为1）
- (void)initializeEnvironment;

/// 获取开发网络环境地址
- (NSString *)getDefaultNetworkHost;

/**
 *  设置APP环境按钮（注：显示在设置视图控制器的导航栏右按钮；若在发布环境，则不显示标题，连续点击5次弹出设置视图）
 *  @param targer          添加设置控制网络环境按钮的视图控制器（即设置成该视图控制器的导航栏右按钮）
 *  @param isExit          是否退出当前APP
 *  @param complete        设置完成的后回调处理（如：退出登录，或退出APP，或回到根视图控制器并重新刷新网络）
 *  @return 无返回值
 */
- (void)environmentWithTarget:(UIViewController *)targer exitApp:(BOOL)isExit complete:(void (^)(void))complete;

/**
 *  设置APP环境按钮（注：显示在指定视图的指定位置）
 *
 *  @param targer   添加设置网络环境按钮的视图
 *  @param rect     在视图中的显示位置
 *  @param isExit   是否退出当前APP
 *  @param complete 设置完成后的回调
 */
- (void)environmentWithTarget:(UIViewController *)targer frame:(CGRect)rect exitApp:(BOOL)isExit complete:(void (^)(void))complete;

@end


/*
 使用说明
 1、导入 SYNetworkEnvironment 相关类文件
 
 2、导入头文件，如：
 #import "SYNetworkEnvironment.h"
 
 3、初始化网络环境，即在方法"- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{}"中进行初始化。如：
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
     // Override point for customization after application launch.
     
    
     // 环境设置
     NetworkEnvironment.environment = 0;
     NetworkEnvironment.environmentHostDebug = @"http://www.hao123.com";
     NetworkEnvironment.environmentHostRelease = @"http://www.baidu.com";
     NetworkEnvironment.environmentHostDebugDict = @{@"天猫":@"http://www.tiaomiao.com",@"淘宝":@"http://www.taobao.com",@"京东":@"http://www.jindong.com"};
     // 初始化
     [NetworkEnvironment initializeEnvironment];
 
 
     return YES;
 }
 
 4、使用
 （1）添加到视图控制器，便于显示交互视图
 // 退出，或不退出APP
 [NetworkEnvironment environmentWithTarget:self exitApp:YES complete:^{
 
 }];
 （2）添加到指定视图位置，便于显示交互视图
 // 退出，或不退出APP
 [NetworkEnvironment environmentWithTarget:self frame:CGRectMake(10.0, 200.0, 100.0, 40.0) exitApp:NO complete:^{
 
 }];
 （3）获取定义的网络环境
 NSString *url = NetworkHost;
 NSLog(@"url = %@", url);
 
 */



