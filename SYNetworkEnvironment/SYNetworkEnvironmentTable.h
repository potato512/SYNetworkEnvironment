//
//  SYNetworkEnvironmentTable.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/7/9.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYNetworkEnvironmentTable : UITableView

/// 数据源-地址字典
@property (nonatomic, strong) NSDictionary *environmentURLs;
/// 数据源-名称
@property (nonatomic, strong) NSString *environmentName;

/// 响应回调
@property (nonatomic, copy) void (^environmentSelected)(NSString *name);

@end
