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

@interface SYNetworkEnvironmentController () <UIAlertViewDelegate>

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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField *nameField = [alertView textFieldAtIndex:0];
        nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        nameField.placeholder = @"网络名称";
        UITextField *valueTextField = [alertView textFieldAtIndex:1];
        valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        valueTextField.secureTextEntry = NO;
        valueTextField.placeholder = @"https:// 或 http:// 开头的网络地址";
        [alertView show];
    } else if (1 == index) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除地址" message:@"确定删除手动添加地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1001;
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"确定"]) {
        if (1000 == alertView.tag) {
            // 第一个输入框
            UITextField *nameField = [alertView textFieldAtIndex:0];
            NSString *name = nameField.text;
            NSLog(@"name = %@",name);
            
            // 第二个输入框
            UITextField *valueTextField = [alertView textFieldAtIndex:1];
            NSString *value = valueTextField.text;
            NSLog(@"value = %@",value);
            
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
        } else if (1001 == alertView.tag) {
            //
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
        }
    }
}

@end
