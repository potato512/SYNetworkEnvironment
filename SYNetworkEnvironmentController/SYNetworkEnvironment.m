//
//  SYNetworkEnvironment.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/8/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYNetworkEnvironment.h"
#import "SYNetworkEnvironmentController.h"

/************************************************************************/

static NSString *const keyNetwork = @"SYNetworkSettingHost";
#define NetworkUserDefault [NSUserDefaults standardUserDefaults]

/************************************************************************/

static NSString *const keyNetworkEnvironment        = @"keyNetworkEnvironment";
static NSString *const keyNetworkEnvironmentPublic  = @"keyNetworkEnvironmentPublic";
static NSString *const keyNetworkEnvironmentDevelop = @"keyNetworkEnvironmentDevelop";
static NSString *const keyNetworkEnvironmentOhter   = @"keyNetworkEnvironmentOhter";

/************************************************************************/

@interface SYNetworkEnvironment ()

@property (nonatomic, copy) void (^completeBlock)(void);
@property (nonatomic, assign) BOOL isExitApp;

@property (nonatomic, assign) NSInteger isPublicNetworkEnvironment;
///// 网络环境设置（名称，url地址；注：名称为键、url地址为值）
@property (nonatomic, strong) NSDictionary *networkDict;
@property (nonatomic, strong) NSString *publicName;
@property (nonatomic, strong) NSString *publicUrl;
@property (nonatomic, strong) NSString *developName;
@property (nonatomic, strong) NSString *developUrl;
// 环境配置变量
@property (nonatomic, strong) NSMutableDictionary *environmentDict;

@property (nonatomic, weak) UIViewController *controller;

@end

@implementation SYNetworkEnvironment

/************************************************************************/

- (instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    
    return self;
}

+ (SYNetworkEnvironment *)shareEnvironment
{
    static SYNetworkEnvironment *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[SYNetworkEnvironment alloc] init];
        assert(sharedManager != nil);
    });
    
    return sharedManager;
}

- (void)initializeEnvironment;
{
    [self readConfigNetwork];
    
    [self setDefaultNetwork];
}

/************************************************************************/

- (void)readConfigNetwork
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSString *key in self.environmentDict.allKeys)
    {
        if ([key isEqualToString:keyNetworkEnvironment])
        {
            // 网络环境
            NSString *value = [self.environmentDict objectForKey:key];
            self.isPublicNetworkEnvironment = value.integerValue;
        }
        else if ([key isEqualToString:keyNetworkEnvironmentDevelop])
        {
            self.developName = @"默认开发测试环境";
            self.developUrl = [self.environmentDict objectForKey:key];
        }
        else if ([key isEqualToString:keyNetworkEnvironmentPublic])
        {
            self.publicName = @"默认发布环境";
            self.publicUrl = [self.environmentDict objectForKey:key];
        }
        else
        {
            NSDictionary *dictTmp = [self.environmentDict objectForKey:key];
            if (dictTmp && 0 != dictTmp.count)
            {
                [dict setDictionary:dictTmp];
            }
        }
    }
    [dict setValue:self.publicUrl forKey:self.publicName];
    [dict setValue:self.developUrl forKey:self.developName];
    self.networkDict = [NSDictionary dictionaryWithDictionary:dict];
    
    NSAssert(self.publicName != nil, @"self.publicName must be not nil");
    NSAssert(self.publicUrl != nil, @"self.publicUrl must be not nil");
    NSAssert(self.developName != nil, @"self.developName must be not nil");
    NSAssert(self.developUrl != nil, @"self.developUrl must be not nil");
    NSAssert(self.environmentDict != nil, @"self.networkDict must be not nil");
}

/************************************************************************/

// 设置初始化网络环境
- (void)setDefaultNetwork
{
    NSString *networkName = [self getDefaultNetworkName];
    // bug-网络名称设置异常 修复 modify zhangshaoyu 20170422
//    NSArray *nameArray = self.environmentDict.allKeys;
    NSArray *nameArray = self.networkDict.allKeys;
    
    for (NSString *name in nameArray)
    {
        if ([name isEqualToString:networkName])
        {
            [self setDefaultNetwork:name];
            
            break;
        }
    }
}

// 获取网络环境名称
- (NSString *)getDefaultNetworkName
{
    // 默认开发测试环境
    NSString *networkName = [NetworkUserDefault objectForKey:keyNetwork];
    
    if (1 == self.isPublicNetworkEnvironment)
    {
        // 发布环境
        if (networkName && 0 != networkName.length)
        {
            // 如果是发布环境，且设置了网络环境，则使用设置的网络环境
        }
        else
        {
            // 如果没有重新设置网络环境，则默认使用发布环境
            networkName = self.publicName;
        }
    }
    else
    {
        // 非发布环境
        if (!networkName || 0 == networkName.length)
        {
            // 如果没有初始化值，默认开发环境
            networkName = self.developName;
        }
    }
    
    return networkName;
}

/************************************************************************/

// 设置网络环境名称
- (void)setDefaultNetwork:(NSString *)name
{
    if (name && 0 != name.length)
    {
        [NetworkUserDefault setObject:name forKey:keyNetwork];
        [NetworkUserDefault synchronize];
    }
}

// 获取开发网络环境地址
- (NSString *)getDefaultNetworkHost
{
    NSString *networkUrl = nil;
    
    NSString *networkName = [NetworkUserDefault objectForKey:keyNetwork];
    NSArray *nameArray = self.networkDict.allKeys;
    
    for (NSString *name in nameArray)
    {
        if ([name isEqualToString:networkName])
        {
            networkUrl = [self.networkDict objectForKey:name];
            
            break;
        }
    }
    
    return networkUrl;
}

/************************************************************************/

#pragma mark 设置方法

// 设置APP环境按钮
- (void)environmentWithTarget:(UIViewController *)target exitApp:(BOOL)isExit complete:(void (^)(void))complete
{
    self.isExitApp = isExit;
    
    if (complete)
    {
        self.completeBlock = [complete copy];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 80.0, 44.0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    if (1 == self.isPublicNetworkEnvironment)
    {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(networkClick:)];
        tapRecognizer.numberOfTapsRequired = 5;
        [button addGestureRecognizer:tapRecognizer];
    }
    else
    {
        NSString *name = [self getDefaultNetworkName];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitle:name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(networkClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (target)
    {
        self.controller = target;
        target.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)environmentWithTarget:(UIViewController *)targer frame:(CGRect)rect exitApp:(BOOL)isExit complete:(void (^)(void))complete
{
    self.isExitApp = isExit;
    
    if (complete)
    {
        self.completeBlock = [complete copy];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 80.0, 44.0);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    if (1 == self.isPublicNetworkEnvironment)
    {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(networkClick:)];
        tapRecognizer.numberOfTapsRequired = 5;
        [button addGestureRecognizer:tapRecognizer];
    }
    else
    {
        NSString *name = [self getDefaultNetworkName];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitle:name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(networkClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (targer)
    {
        self.controller = targer;
        
        [targer.view addSubview:button];
        button.frame = rect;
    }
}

#pragma mark 响应方法

- (void)networkClick:(id)sender
{
    NSLog(@"设置前：(%@)%@", [NetworkEnvironment getDefaultNetworkName], NetworkHost);
    
    typeof(self) __weak weakSelf = self;
    
    NSString *name = [self getDefaultNetworkName];
    
    SYNetworkEnvironmentController *environmentVC = [[SYNetworkEnvironmentController alloc] init];
    environmentVC.environmentURLs = self.networkDict;
    environmentVC.environmentName = name;
    environmentVC.environmentSelected = ^(NSString *name){
        // 保存选择环境
        [weakSelf setDefaultNetwork:name];
        
        if ([sender isKindOfClass:[UIButton class]])
        {
            [sender setTitle:name forState:UIControlStateNormal];
        }
        
        NSLog(@"设置后：(%@)%@", [NetworkEnvironment getDefaultNetworkName], NetworkHost);
    };
    environmentVC.environmentDismiss = ^(){
        // 退出重启，或重新连接
        [weakSelf exitApplication];
    };
    UINavigationController *environmentNav = [[UINavigationController alloc] initWithRootViewController:environmentVC];
    [self.controller presentViewController:environmentNav animated:YES completion:NULL];
}

- (void)exitApplication
{
    if (self.completeBlock)
    {
        self.completeBlock();
    }
    
    if (self.isExitApp)
    {
        // 退出APP
        exit(0);
    }
}

/************************************************************************/

#pragma mark - setter

- (void)setEnviroment:(BOOL)enviroment
{
    NSNumber *number = @(enviroment);
    [self.environmentDict setObject:number forKey:keyNetworkEnvironment];
}

- (void)setEnvironmentHostDebug:(NSString *)environmentHostDebug
{
    [self.environmentDict setObject:environmentHostDebug forKey:keyNetworkEnvironmentDevelop];
}

- (void)setEnvironmentHostRelease:(NSString *)environmentHostRelease
{
    [self.environmentDict setObject:environmentHostRelease forKey:keyNetworkEnvironmentPublic];
}

- (void)setEnvironmentHostDebugDict:(NSDictionary *)environmentHostDebugDict
{
    [self.environmentDict setObject:environmentHostDebugDict forKey:keyNetworkEnvironmentOhter];
}

- (NSMutableDictionary *)environmentDict
{
    if (_environmentDict == nil)
    {
        _environmentDict = [NSMutableDictionary dictionary];
    }
    return _environmentDict;
}

@end
