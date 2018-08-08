//
//  SYNetworkEnvironmentTable.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/7/9.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYNetworkEnvironmentTable.h"

static NSInteger const tagCellTitle = 1000;
static NSInteger const tagCellSubTitle = 2000;

@interface SYNetworkEnvironmentTable () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *previousIndex;

@end

@implementation SYNetworkEnvironmentTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGRect rect = self.frame;
        rect.size.width = [UIApplication sharedApplication].delegate.window.frame.size.width;
        self.frame = rect;
        
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
    
        CGRect rect = cell.frame;
        rect.size.width = self.frame.size.width;
        cell.frame = rect;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, (cell.frame.size.width - 40.0), cell.frame.size.height / 2)];
        [cell.contentView addSubview:label];
        label.tag = tagCellTitle;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor blackColor];
        //
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, (cell.frame.size.height / 2), (cell.frame.size.width - 40.0), cell.frame.size.height / 2)];
        [cell.contentView addSubview:subLabel];
        subLabel.tag = tagCellSubTitle;
        subLabel.font = [UIFont systemFontOfSize:10.0f];
        subLabel.textColor = [UIColor lightGrayColor];
        //
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, (cell.frame.size.height - 0.5), cell.frame.size.width, 0.5)];
        [cell.contentView addSubview:lineView];
        lineView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    }
    
    NSString *name = self.environmentURLs.allKeys[indexPath.row];
    NSString *url = [self.environmentURLs objectForKey:name];
    //
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tagCellTitle];
    UILabel *subLabel = (UILabel *)[cell.contentView viewWithTag:tagCellSubTitle];
    //
    label.text = name;
    subLabel.text = url;
    // 字体颜色
    label.textColor = [UIColor blackColor];
    subLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    //
    if ([self.environmentName isEqualToString:name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // 字体高亮颜色
        label.textColor = [UIColor blueColor];
        subLabel.textColor = [UIColor blueColor];
        
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
        //
        UILabel *label = (UILabel *)[cellPrevious.contentView viewWithTag:tagCellTitle];
        UILabel *subLabel = (UILabel *)[cellPrevious.contentView viewWithTag:tagCellSubTitle];
        // 字体颜色
        label.textColor = [UIColor blackColor];
        subLabel.textColor = [UIColor lightGrayColor];
    }
    
    UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    cellSelected.accessoryType = UITableViewCellAccessoryCheckmark;
    //
    UILabel *label = (UILabel *)[cellSelected.contentView viewWithTag:tagCellTitle];
    UILabel *subLabel = (UILabel *)[cellSelected.contentView viewWithTag:tagCellSubTitle];
    // 字体高亮颜色
    label.textColor = [UIColor blueColor];
    subLabel.textColor = [UIColor blueColor];
    
    self.previousIndex = indexPath;
}

@end
