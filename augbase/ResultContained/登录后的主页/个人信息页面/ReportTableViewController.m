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
    _reportTable.delegate = self;
    _reportTable.dataSource = self;
    [_reportTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    self.navigationController.navigationBarHidden = NO;
    UIButton *sendReportButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 22)];
    [sendReportButton setTitle:NSLocalizedString(@"发送", @"") forState:UIControlStateNormal];
    [sendReportButton setTitleColor:themeColor forState:UIControlStateNormal];
    sendReportButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [sendReportButton addTarget:self action:@selector(sendReport) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendReportButton]];
    [self.navigationController.navigationBar setTintColor:themeColor];
}

#pragma 发送举报到后端，需要网络交互
-(void)sendReport{
    NSLog(@"发送举报给后端，alertview提示发送成功");
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 15)];
        headerView.backgroundColor = grayBackColor;
        UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ViewWidth-10, 15)];
        remindLabel.font = [UIFont systemFontOfSize:13.0];
        remindLabel.text = NSLocalizedString(@"补充说明", @"");
        remindLabel.backgroundColor = grayBackColor;
        [headerView addSubview:remindLabel];
        return headerView;
    }
    //    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    //    headerView.backgroundColor = [UIColor lightGrayColor];
    //    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

@end
