//
//  SYNetworkEnvironmentView.m
//  SYNetworkEnvironmentView
//
//  Created by zhangshaoyu on 16/8/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYNetworkEnvironmentView.h"

static CGFloat const originX = 20.0;
static CGFloat const originY = 10.0;
static CGFloat const heightlabel = 44.0;

#define widthButton (self.buttonView.width / 2)

@interface SYNetworkEnvironmentView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) void (^(selectedClick))(NSString *name);

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *tableBgView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSDictionary *urlDict;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSString *networkName;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;

@end

@implementation SYNetworkEnvironmentView

- (instancetype)initWithNetwork:(NSDictionary *)networkDict selectedName:(NSString *)name clickComplete:(void (^)(NSString *networkName))complete
{
    self = [super init];
    if (self)
    {
        UIView *view = [[UIApplication sharedApplication].delegate window];
        self.frame = view.bounds;
        [view addSubview:self];
        
        self.urlDict = networkDict;
        self.nameArray = networkDict.allKeys;
        
        self.networkName = name;
        
        if (complete)
        {
            self.selectedClick = [complete copy];
        }
        
        [self setUI];
    }
    
    return self;
}

#pragma mark - 创建视图

- (void)setUI
{
    [self setBackView];
    [self setAlertView];
}

// 黑色背景视图
- (void)setBackView
{
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [self addSubview:self.bgView];
}

// 弹窗视图
- (void)setAlertView
{
    CGFloat heightTable = (self.nameArray.count * heightlabel + originY + heightlabel);
    CGFloat originYAll = (CGRectGetHeight(self.bgView.bounds) - heightTable) / 2;
    
    BOOL isScrollEnabled = NO;
    if (heightTable >= CGRectGetHeight(self.bgView.bounds))
    {
        isScrollEnabled = YES;
        originYAll = originY * 2;
    }
    
    self.tableBgView = [[UIView alloc] initWithFrame:CGRectMake(originX, originYAll, (CGRectGetWidth(self.bgView.bounds) - originX * 2), (CGRectGetHeight(self.bgView.bounds) - originYAll * 2))];
    self.tableBgView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.tableBgView];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableBgView.bounds), (CGRectGetHeight(self.tableBgView.bounds) - originY - heightlabel)) style:UITableViewStylePlain];
    self.mainTableView.scrollEnabled = isScrollEnabled;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableBgView addSubview:self.mainTableView];
    
    UIView *currentView = self.mainTableView;
    
    CGFloat widhtButton = self.tableBgView.frame.size.width / 2;
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height + originY), widhtButton, heightlabel);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.cancelButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [self.cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableBgView addSubview:self.cancelButton];
    
    currentView = self.cancelButton;
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.frame = CGRectMake((currentView.frame.origin.x + currentView.frame.size.width), currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.confirmButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [self.confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableBgView addSubview:self.confirmButton];
}

#pragma mark - 响应事件

- (void)cancelClick:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)confirmClick:(UIButton *)button
{
    if (self.previousIndexPath)
    {
        NSString *name = self.nameArray[self.previousIndexPath.row];
        
        if (self.selectedClick)
        {
            self.selectedClick(name);
        }
    }
    
    [self removeFromSuperview];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCell];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *nameString = self.nameArray[indexPath.row];
    cell.textLabel.text = nameString;
    NSString *urlString = [self.urlDict objectForKey:nameString];
    cell.detailTextLabel.text = urlString;
    
    NSString *networkString = self.networkName;
    if ([networkString isEqualToString:nameString])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.previousIndexPath = indexPath;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.previousIndexPath)
    {
        UITableViewCell *cellPrevious = [tableView cellForRowAtIndexPath:self.previousIndexPath];
        cellPrevious.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    cellSelected.accessoryType = UITableViewCellAccessoryCheckmark;
    self.previousIndexPath = indexPath;
}

@end
