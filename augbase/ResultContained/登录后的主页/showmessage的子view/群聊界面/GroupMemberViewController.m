//
//  GroupMemberViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "GroupMemberViewController.h"

@interface GroupMemberViewController ()

@end

@implementation GroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _memberTable.delegate = self;
    _memberTable.dataSource = self;
    _memberTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _memberTable.backgroundColor = grayBackColor;
}
-(void)viewWillAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"成员信息", @"");
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma 返回cell，重复利用一个
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"setGroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupmembercell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [((UIButton *)[cell.contentView viewWithTag:7]) addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"persontitle2"];
    [[cell.contentView viewWithTag:1] imageWithRound:NO];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = grayBackColor.CGColor;
    return cell;
}

#pragma 此处的跳转需要加入传递过去的必要信息,上方的加为好友button也是一个道理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StrangerViewController *svc = [main instantiateViewControllerWithIdentifier:@"stranger"];
    [self.navigationController pushViewController:svc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
////    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
////    headerView.backgroundColor = [UIColor lightGrayColor];
////    return headerView;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

#pragma 添加好友按钮响应函数
-(void)addFriend{
    NSLog(@"此处需要加入跳转时传输过去必要的参数");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SendAddMessViewController *smc = [main instantiateViewControllerWithIdentifier:@"sendaddmessage"];
    [self.navigationController pushViewController:smc animated:YES];
}

@end
