//
//  SYNetworkEnvironmentView.h
//  SYNetworkEnvironmentView
//
//  Created by zhangshaoyu on 16/8/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYNetworkEnvironmentView : UIView

/**
 *  网络环境控制视图
 *
 *  @param networkDict  网络环境配置字典（名称、地址）
 *  @param name         网络环境当前设置名称
 *  @param complete     网络环境选择回调
 *
 *  @return 视图
 */
- (instancetype)initWithNetwork:(NSDictionary *)networkDict selectedName:(NSString *)name clickComplete:(void (^)(NSString *networkName))complete;

@end
