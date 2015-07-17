//
//  NearByFriendViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "NearByFriendViewController.h"

@interface NearByFriendViewController ()

@end

@implementation NearByFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nearbyFriendTable.delegate = self;
    _nearbyFriendTable.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"附近好友", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"nearbyfriendcell" forIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
    [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
    ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"相似好友", @"");
    [((UIButton *)[cell.contentView viewWithTag:7]) addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma 添加加为好友的函数,获取对应的cell可以通过sender.superview来获取
-(void)addFriend:(UIButton *)sender{
    NSLog(@"加上加为好友的响应函数，网络通讯");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StrangerViewController *svc = [main instantiateViewControllerWithIdentifier:@"stranger"];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)addFriendYes{
    NSLog(@"加上同意加为好友的响应函数，网络通讯");
    //    boolAddArray[0] = YES;
    //    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    AddFriendConfirmViewController *afcv = [main instantiateViewControllerWithIdentifier:@"addfriendconfirmdetail"];
    //    [self.navigationController pushViewController:afcv animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
}

#pragma 添加头和尾
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
////    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
////    headerView.backgroundColor = [UIColor lightGrayColor];
////    return headerView;
//}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

@end
