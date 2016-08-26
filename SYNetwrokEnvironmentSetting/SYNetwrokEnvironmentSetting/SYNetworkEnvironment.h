//
//  SYNetworkEnvironment.h
//  SYNetworkEnvironment
//
//  Created by zhangshaoyu on 16/8/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  网络环境切换
//
// 使用说明
// 1、导入 SYNetworkEnvironment.framework 文件
// 2、导入 SYNetworkEnvironment.plist 文件，并设置参数，如：
// 参数1、键：keyNetworkEnvironment，值：开发测试环境0，或发布环境1
// 参数2、键：keyNetworkEnvironmentPublic，值：发布环境服务器地址
// 参数3、键：keyNetworkEnvironmentDevelop，值：开发测试环境服务器地址
// 参数4、键：keyNetworkEnvironmentOhter，值：其他开发测试环境字典（键值对，其中键为名称，值为服务器地址）
// 3、导入头文件，如：
// #import "SYNetwrokEnvironment.framework/Headers/SYNetworkEnvironment.h"
// 4、初始化网络环境，即在方法"- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{}"中进行初始化。如：
// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
// {
//    // Override point for customization after application launch.
//    [NetworkEnvironment initializeNetworkEnvironment];
//    return YES;
// }
// 5、使用
//（1）添加到视图控制器，便于显示交互视图
// // 退出，或不退出APP
// [NetworkEnvironment networkButtonWithNavigation:self exitApp:NO settingComplete:^{
//    //        UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    //        window.rootViewController = [UIApplication sharedApplication].delegate
//    
//    AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
//    [appDelegate initRootViewController];
// }];
//（2）获取定义的网络环境，如：
// NSLog(@"当前网络环境地址：%@", networkHost);

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/************************************************************************/

#define NetworkEnvironment ([SYNetworkEnvironment shareNetworkEnvironment])
#define networkHost        ([[SYNetworkEnvironment shareNetworkEnvironment] getDefaultNetworkHost])

/************************************************************************/

/// plist默认键名称，plist文件名称"SYNetworkEnvironment.plist"
static NSString *const keyNetworkEnvironment;
static NSString *const keyNetworkEnvironmentPublic;
static NSString *const keyNetworkEnvironmentDevelop;
static NSString *const keyNetworkEnvironmentOhter;

/************************************************************************/


@interface SYNetworkEnvironment : NSObject

/// 按钮标题常规颜色（默认黑色）
@property (nonatomic, strong) UIColor *colorTitleNormal;
/// 按钮标题高亮颜色（默认灰黑色）
@property (nonatomic, strong) UIColor *colorTitleHighlighted;
/// 按钮标题字体大小（默认14.0）
@property (nonatomic, strong) UIFont *fountTitle;

+ (SYNetworkEnvironment *)shareNetworkEnvironment;

/// 初始化网络环境（注意：发布时环境状态为1）
- (void)initializeNetworkEnvironment;

/// 获取开发网络环境地址
- (NSString *)getDefaultNetworkHost;

/**
 *  设置APP环境按钮（注：显示在设置视图控制器的导航栏右按钮；若在发布环境，则不显示标题，连续点击5次弹出设置视图）
 *  @param controller      添加设置控制网络环境按钮的视图控制器
 *  @param isExit          设置是否退出当前APP
 *  @param complete        设置完成的后回调处理（如：退出登录，或退出APP，或回到根视图控制器并重新刷新网络）
 *  @return 无返回值
 */
- (void)networkButtonWithNavigation:(UIViewController *)controller exitApp:(BOOL)isExit settingComplete:(void (^)(void))complete;


@end

