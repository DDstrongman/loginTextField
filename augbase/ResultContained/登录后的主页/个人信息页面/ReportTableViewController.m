//
//  ReportTableViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/14.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ReportTableViewController.h"

@interface ReportTableViewController ()

@end

@implementation ReportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"举报", @"");
}

-(void)viewWillAppear:(BOOL)animated{
//    [[IQKeyboardManager sharedManager] setEnable:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }else{
        return 160;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"choosecell" forIndexPath:indexPath];
        cell.tag = (indexPath.row*10+10);
        switch (indexPath.row) {
            case 0:{
                ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"色情低俗", @"");
            }
                break;
            case 1:{
                ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"广告骚扰", @"");
            }
                break;
            case 2:{
                ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"政治敏感", @"");
            }
                break;
            case 3:{
                ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"欺诈骗钱", @"");
            }
                break;
            case 4:{
                ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"谣言", @"");
            }
                break;
            case 5:{
                ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"违法", @"");
            }
                break;
                
            default:
                break;
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell" forIndexPath:indexPath];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0) {
        UIView *lableView = [tableView viewWithTag:(indexPath.row*10+10)];
        if ([lableView isKindOfClass:[UITableViewCell class]]) {
            if (((UITableViewCell *)lableView).accessoryType == UITableViewCellAccessoryNone) {
                ((UITableViewCell *)lableView).accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                ((UITableViewCell *)lableView).accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 15)];
        remindLabel.font = [UIFont systemFontOfSize:13.0];
        remindLabel.text = NSLocalizedString(@"补充说明", @"");
        remindLabel.backgroundColor = grayBackColor;
        return remindLabel;
    }
    //    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    //    headerView.backgroundColor = [UIColor lightGrayColor];
    //    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

@end
