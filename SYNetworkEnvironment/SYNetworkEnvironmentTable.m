//
//  SYNetworkEnvironmentTable.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/7/9.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYNetworkEnvironmentTable.h"

@interface SYNetworkEnvironmentTable () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *previousIndex;

@end

@implementation SYNetworkEnvironmentTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.delegate = self;
        self.dataSource = self;
        
        self.tableFooterView = [UIView new];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.environmentURLs.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
        // 字体颜色
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    NSString *name = self.environmentURLs.allKeys[indexPath.row];
    cell.textLabel.text = name;
    NSString *url = [self.environmentURLs objectForKey:name];
    cell.detailTextLabel.text = url;
    // 字体颜色
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([self.environmentName isEqualToString:name]) {
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
    if (self.environmentSelected) {
        NSString *name = self.environmentURLs.allKeys[indexPath.row];
        self.environmentSelected(name);
    }
    
    // 选择操作
    if (self.previousIndex) {
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

@end
