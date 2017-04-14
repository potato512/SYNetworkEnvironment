//
//  SYNetworkEnvironment.m
//  SYNetworkEnvironment
//
//  Created by zhangshaoyu on 16/8/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYNetworkEnvironment.h"
#import "SYNetworkEnvironmentView.h"

/************************************************************************/

typedef void (^SettingComplete)(void);

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

@property (nonatomic, copy) SettingComplete settingComplete;
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

@end

@implementation SYNetworkEnvironment

/************************************************************************/

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _titleColorNormal = [UIColor blackColor];
        _titleColorHlight = [UIColor lightGrayColor];
        _titleFont = [UIFont systemFontOfSize:14.0];
        
        self.bgColor = [UIColor clearColor];
    }
    
    return self;
}

+ (SYNetworkEnvironment *)shareNetworkEnvironment
{
    static SYNetworkEnvironment *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[SYNetworkEnvironment alloc] init];
        assert(sharedManager != nil);
    });
    
    return sharedManager;
}

- (void)initializeNetworkEnvironment;
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
    NSArray *nameArray = self.environmentDict.allKeys;
    
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
- (void)networkButtonWithNavigation:(UIViewController *)controller exitApp:(BOOL)isExit complete:(void (^)(void))complete
{
    self.isExitApp = isExit;
    
    if (complete)
    {
        self.settingComplete = [complete copy];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 80.0, 44.0);
    [button setTitleEdgeInsets:UIEdgeInsetsZero];
    [button setTitleColor:_titleColorNormal forState:UIControlStateNormal];
    [button setTitleColor:_titleColorHlight forState:UIControlStateHighlighted];
    button.titleLabel.font = _titleFont;
    
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
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)networkButtonWithView:(UIView *)view frame:(CGRect)rect exitApp:(BOOL)isExit complete:(void (^)(void))complete
{
    self.isExitApp = isExit;
    
    if (complete)
    {
        self.settingComplete = [complete copy];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 80.0, 44.0);
    [button setTitleEdgeInsets:UIEdgeInsetsZero];
    [button setTitleColor:_titleColorNormal forState:UIControlStateNormal];
    [button setTitleColor:_titleColorHlight forState:UIControlStateHighlighted];
    button.titleLabel.font = _titleFont;
    
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
    
    if (view)
    {
        [view addSubview:button];
        button.frame = rect;
    }
}

#pragma mark 响应方法

- (void)networkClick:(id)sender
{
    NSLog(@"设置前：(%@)%@", [NetworkRequestEnvironment getDefaultNetworkName], NetworkRequestHost);
    
    __weak typeof(self) weakNetwork = self;
    
    NSString *name = [self getDefaultNetworkName];
    SYNetworkEnvironmentView *networkView = [[SYNetworkEnvironmentView alloc] initWithNetwork:self.networkDict selectedName:name clickComplete:^(NSString *networkName) {
        
        // 保存选择环境
        [weakNetwork setDefaultNetwork:networkName];
        // 退出重启，或重新连接
        [weakNetwork exitApplication];
        
        if ([sender isKindOfClass:[UIButton class]])
        {
            [sender setTitle:networkName forState:UIControlStateNormal];
        }
        
        NSLog(@"设置后：(%@)%@", [NetworkRequestEnvironment getDefaultNetworkName], NetworkRequestHost);
    }];
    
    networkView.backgroundColor = _bgColor;
}

- (void)exitApplication
{
    if (self.settingComplete)
    {
        self.settingComplete();
    }
    
    if (self.isExitApp)
    {
        // 退出APP
        exit(0);
    }
}

/************************************************************************/

#pragma mark - setter

- (void)setNetworkEnviroment:(BOOL)networkEnviroment
{
    NSNumber *number = @(networkEnviroment);
    [self.environmentDict setObject:number forKey:keyNetworkEnvironment];
}

- (void)setNetworkServiceDebug:(NSString *)networkServiceDebug
{
    [self.environmentDict setObject:networkServiceDebug forKey:keyNetworkEnvironmentDevelop];
}

- (void)setNetworkServiceRelease:(NSString *)networkServiceRelease
{
    [self.environmentDict setObject:networkServiceRelease forKey:keyNetworkEnvironmentPublic];
}

- (void)setNetworkServiceDebugDict:(NSDictionary *)networkServiceDebugDict
{
    [self.environmentDict setObject:networkServiceDebugDict forKey:keyNetworkEnvironmentOhter];
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
