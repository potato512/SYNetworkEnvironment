//
//  SYNetworkEnvironmentAddView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/10/24.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYNetworkEnvironmentAddView.h"

@interface SYNetworkEnvironmentAddView ()

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *valueTextField;

@end

@implementation SYNetworkEnvironmentAddView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    
}

@end
