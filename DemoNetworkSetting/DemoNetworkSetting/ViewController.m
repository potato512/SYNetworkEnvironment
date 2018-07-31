//
//  ViewController.m
//  DemoNetworkSetting
//
//  Created by zhangshaoyu on 16/8/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#import "SYNetworkEnvironment.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"网络环境设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加到视图控制器，退出APP
//    [NetworkEnvironment environmentWithTarget:self exitApp:YES complete:^{
<<<<<<< HEAD
//
=======
//        
>>>>>>> atHome
//    }];
    
    // 添加到视图控制器，不退出APP
    [NetworkEnvironment environmentWithTarget:self exitApp:NO complete:^{
<<<<<<< HEAD
        
=======
     
>>>>>>> atHome
        AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
        [appDelegate initRootViewController];
        
    }];
    
    // 添加到视图指定位置
    [NetworkEnvironment environmentWithTarget:self frame:CGRectMake(10.0, 200.0, 100.0, 40.0) exitApp:NO complete:^{
        
    }];
    
    // 获取当前网络环境
    NSString *url = NetworkHost;
    NSLog(@"当前网络环境 url = %@", url);
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
