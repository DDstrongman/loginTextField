//
//  FriendsSetViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/4.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "FriendsSetViewController.h"

@interface FriendsSetViewController ()

@end

@implementation FriendsSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)deleteOldFriend{
    NSLog(@"删除好友");
    [[XMPPSupportClass ShareInstance] removeFriend:_friendJID];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"setFriend"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setFriend"];
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 20)];
    titleLabel.center = CGPointMake(ViewWidth/2, cell.bounds.size.height/2+2);
    titleLabel.text = NSLocalizedString(@"删除", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor orangeColor];
    [cell addSubview:titleLabel];
    cell.layer.borderColor = lightGrayBackColor.CGColor;
    cell.layer.borderWidth = 0.5;
    cell.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self deleteOldFriend];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

-(void)setupView{
    self.title = NSLocalizedString(@"好友权限设置", @"");
    _setFriendTable = [[UITableView alloc]init];
    _setFriendTable.delegate = self;
    _setFriendTable.dataSource = self;
    _setFriendTable.backgroundColor = grayBackgroundLightColor;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    _setFriendTable.tableHeaderView = headerView;
    _setFriendTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_setFriendTable];
    [_setFriendTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(@0);
    }];
}

-(void)setupData{
    
}

@end
