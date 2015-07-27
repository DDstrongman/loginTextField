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
    _confirmInfoTable.delegate = self;
    _confirmInfoTable.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
            return 90;
            break;
            
        case 3:
            return 50;
            break;
            
        case 4:
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
            [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
        }
            break;
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"privatenotecell" forIndexPath:indexPath];
        }
            break;
        case 2:{
            static NSString *CellIdentifier = @"confirmaddfriendmesscell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        }
            break;
        case 3:{
            static NSString *CellIdentifier = @"addfriendreportcell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        }
            break;
        case 4:{
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
    NSLog(@"加上同意加为好友的响应函数，网络通讯,同时需要加上一个noticefacation,样例即拓代码里有，即注册通知过去通知一下刷新即可");
    //    boolAddArray[0] = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
