//
//  SYNetworkEnvironmentController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/7/9.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYNetworkEnvironmentController.h"
#import "SYNetworkEnvironmentTable.h"

@interface SYNetworkEnvironmentController ()

@property (nonatomic, strong) SYNetworkEnvironmentTable *environmentTable;
@property (nonatomic, strong) NSString *selectedName;

@end

@implementation SYNetworkEnvironmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"网络环境配置";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(buttonCancle)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(buttonConfirm)];
    
    self.environmentTable = [[SYNetworkEnvironmentTable alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.environmentTable];
    // 属性设置
    self.environmentTable.environmentURLs = self.environmentURLs;
    self.environmentTable.environmentName = self.environmentName;
    // 回调设置
    typeof(self) __weak weakSelf = self;
    self.environmentTable.environmentSelected = ^(NSString *name) {
        weakSelf.selectedName = name;
    };
    
    [self.environmentTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@ dealloc...", [self class]);
}

#pragma mark - 响应

- (void)buttonCancle
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.environmentDismiss)
        {
            self.environmentDismiss();
        }
    }];
}

- (void)buttonConfirm
{
    // 保存
    if (self.environmentSelected && self.selectedName)
    {
        self.environmentSelected(self.selectedName);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.environmentDismiss)
        {
            self.environmentDismiss();
        }
    }];
}

@end
