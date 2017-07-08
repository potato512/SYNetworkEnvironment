//
//  SYNetworkEnvironmentTable.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/7/9.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYNetworkEnvironmentTable.h"

@interface SYNetworkEnvironmentTable () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *environmentNames;
@property (nonatomic, strong) NSIndexPath *previousIndex;

@end

@implementation SYNetworkEnvironmentTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.tableFooterView = [UIView new];
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.environmentNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCell];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
        // 字体颜色
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    NSString *name = self.environmentNames[indexPath.row];
    cell.textLabel.text = name;
    NSString *url = [self.environmentURLs objectForKey:name];
    cell.detailTextLabel.text = url;
    // 字体颜色
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    if ([self.environmentName isEqualToString:name])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // 字体高亮颜色
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.textColor = [UIColor blueColor];
        
        self.previousIndex = indexPath;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 当前选择回调
    if (self.environmentSelected)
    {
        NSString *name = self.environmentNames[indexPath.row];
        self.environmentSelected(name);
    }
    
    // 选择操作
    if (self.previousIndex)
    {
        UITableViewCell *cellPrevious = [tableView cellForRowAtIndexPath:self.previousIndex];
        cellPrevious.accessoryType = UITableViewCellAccessoryNone;
        
        // 字体颜色
        cellPrevious.textLabel.textColor = [UIColor blackColor];
        cellPrevious.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    cellSelected.accessoryType = UITableViewCellAccessoryCheckmark;
    // 字体高亮颜色
    cellSelected.textLabel.textColor = [UIColor blueColor];
    cellSelected.detailTextLabel.textColor = [UIColor blueColor];
    
    self.previousIndex = indexPath;
}

- (NSArray *)environmentNames
{
    if (_environmentNames == nil)
    {
        _environmentNames = self.environmentURLs.allKeys;
    }
    return _environmentNames;
}

@end
