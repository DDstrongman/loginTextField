//
//  AddFriendConfirmViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "AddFriendConfirmViewController.h"

@interface AddFriendConfirmViewController ()

@end

@implementation AddFriendConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 70;
            break;
        case 1:
            return 60;
            break;
        case 2:
            return 95;
            break;
        default:
            return 50;
            break;
    }
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"showinfocell" forIndexPath:indexPath];
            [[cell.contentView viewWithTag:1] imageWithRound];
            ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageWithContentsOfFile:[_strangerDic objectForKey:@"strangerPic"]];
            ((UILabel *)[cell.contentView viewWithTag:2]).text = [_strangerDic objectForKey:@"strangerName"];
            ((UILabel *)[cell.contentView viewWithTag:3]).text = [_strangerDic objectForKey:@"strangerPic"];
            ((UILabel *)[cell.contentView viewWithTag:4]).text = [NSString stringWithFormat:@"%@ %@",[_strangerDic objectForKey:@"strangerGender"],[_strangerDic objectForKey:@"strangerAge"]] ;
            [((UIButton *)[cell.contentView viewWithTag:5]) setTitle:[_strangerDic objectForKey:@"strangerLocation"] forState:UIControlStateNormal];
            [[cell.contentView viewWithTag:5] viewWithRadis:1.0];
        }
            break;
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"privatenotecell" forIndexPath:indexPath];
            ((UILabel *)[cell.contentView viewWithTag:1]).text = [_strangerDic objectForKey:@"strangerNote"];
        }
            break;
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"confirminfocell" forIndexPath:indexPath];
            [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(addFriendYes) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma 需要与后端交互,更新数据
-(void)addFriendYes{
    [[XMPPSupportClass ShareInstance] confirmAddFriend:[_strangerDic objectForKey:@"strangerJID"]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setupView{
    _confirmInfoTable.delegate = self;
    _confirmInfoTable.dataSource = self;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    _confirmInfoTable.tableHeaderView = headerView;
    _confirmInfoTable.tableFooterView = [[UIView alloc]init];
}

-(void)setupData{
    
}

@end
