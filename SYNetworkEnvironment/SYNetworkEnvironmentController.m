//
//  SYNetworkEnvironmentController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/7/9.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYNetworkEnvironmentController.h"
#import "SYNetworkEnvironmentTable.h"
#import "SYNetworkEnvironment.h"

@interface SYNetworkEnvironmentController ()

@property (nonatomic, strong) SYNetworkEnvironmentTable *environmentTable;
@property (nonatomic, strong) NSString *selectedName;

@property (nonatomic, assign) BOOL isDeleteAdd;

@end

@implementation SYNetworkEnvironmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"网络环境配置";
    
    // 导航栏按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(buttonCancle)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(buttonConfirm)];
    
    // 列表视图
    self.environmentTable = [[SYNetworkEnvironmentTable alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, (self.view.frame.size.height - 80.0)) style:UITableViewStylePlain];
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
    
    UIView *currentView = self.environmentTable;
    
    // 拖动配置按钮
    UISegmentedControl *segmentButton = [[UISegmentedControl alloc] initWithItems:@[@"添加地址", @"删除地址"]];
    [self.view addSubview:segmentButton];
    segmentButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    segmentButton.frame = CGRectMake(20.0, (currentView.frame.origin.y + currentView.frame.size.height + 20.0), (self.view.frame.size.width - 40.0), 40.0);
    segmentButton.backgroundColor = [UIColor clearColor];
    segmentButton.tintColor = [UIColor blueColor];
    segmentButton.layer.cornerRadius = 5.0;
    segmentButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    segmentButton.layer.borderWidth = 1.0;
    segmentButton.layer.masksToBounds = YES;
    segmentButton.clipsToBounds = YES;
    segmentButton.momentary = YES;
    [segmentButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)dealloc
{
    NSLog(@"%@ dealloc...", [self class]);
}

#pragma mark - 响应

- (void)buttonCancle
{
    if (self.isDeleteAdd) {
        self.isDeleteAdd = NO;
        if (self.environmentSelected && self.selectedName) {
            self.environmentSelected(self.selectedName);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.environmentDismiss) {
            self.environmentDismiss();
        }
    }];
}

- (void)buttonConfirm
{
    // 保存
    if (self.environmentSelected && self.selectedName) {
        self.environmentSelected(self.selectedName);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.environmentDismiss) {
            self.environmentDismiss();
        }
    }];
}

- (void)addAddress:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    if (0 == index) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
        // 添加文本框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"网络名称";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"https:// 或 http:// 开头的网络地址";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        // 添加按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *urlName = alertController.textFields.firstObject;
            UITextField *urlValue = alertController.textFields.lastObject;
            NSString *name = urlName.text;
            NSString *value = urlValue.text;
            BOOL isValidName = (name && 0 < name.length);
            BOOL isValidValue = ((value && 0 < value.length && ([value hasPrefix:@"http://"] || [value hasPrefix:@"https://"])));
            if (isValidName && isValidValue) {
                //
                NSDictionary *dictTmp = [NetworkUserDefault objectForKey:kAddNetworkAddress];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictTmp];
                if (dict == nil) {
                    dict = [[NSMutableDictionary alloc] init];
                }
                [dict setValue:value forKey:name];
                [NetworkUserDefault setObject:dict forKey:kAddNetworkAddress];
                [NetworkUserDefault synchronize];
                
                // 属性设置
                for (NSString *key in self.environmentURLs.allKeys) {
                    NSString *value = [self.environmentURLs objectForKey:key];
                    [dict setValue:value forKey:key];
                }
                self.environmentURLs = dict;
                
                [NetworkEnvironment initializeEnvironment];
                
                self.environmentTable.environmentURLs = self.environmentURLs;
                [self.environmentTable reloadData];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:NULL];
    } else if (1 == index) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除地址" message:@"确定删除手动添加地址？" preferredStyle:UIAlertControllerStyleAlert];
        // 添加按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *dictTmp = [NetworkUserDefault objectForKey:kAddNetworkAddress];
            if (dictTmp) {
                if ([dictTmp.allKeys containsObject:self.environmentName]) {
                    self.environmentName = kNameDelelop;
                    self.selectedName = kNameDelelop;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.environmentURLs];
                for (NSString *key in dictTmp.allKeys) {
                    [dict removeObjectForKey:key];
                }
                self.environmentURLs = dict;
                
                [NetworkUserDefault removeObjectForKey:kAddNetworkAddress];
                [NetworkUserDefault synchronize];
                
                [NetworkEnvironment initializeEnvironment];
                
                self.environmentTable.environmentName = self.environmentName;
                self.environmentTable.environmentURLs = self.environmentURLs;
                [self.environmentTable reloadData];
                
                self.isDeleteAdd = YES;
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
}

@end
