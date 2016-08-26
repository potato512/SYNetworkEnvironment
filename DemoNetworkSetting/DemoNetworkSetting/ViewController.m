//
//  ViewController.m
//  DemoNetworkSetting
//
//  Created by zhangshaoyu on 16/8/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#import "SYNetwrokEnvironment.framework/Headers/SYNetworkEnvironment.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"网络环境设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 退出APP
    [NetworkEnvironment networkButtonWithNavigation:self exitApp:YES settingComplete:^{
        
    }];

    // 不退出APP
    [NetworkEnvironment networkButtonWithNavigation:self exitApp:NO settingComplete:^{
//        UIWindow *window = [[UIApplication sharedApplication].delegate window];
//        window.rootViewController = [UIApplication sharedApplication].delegate
        
        AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
        [appDelegate initRootViewController];
    }];
    
    NSLog(@"当前网络环境地址：%@", networkHost);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@视图控制器被释放了", [self class]);
}


@end
