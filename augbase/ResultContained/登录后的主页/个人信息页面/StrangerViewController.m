//
//  StrangerViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "StrangerViewController.h"

@interface StrangerViewController ()

@end

@implementation StrangerViewController

#pragma 初始化各种信息。需要网络交互
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"详细资料", @"");
    _showStrangerTable.dataSource = self;
    _showStrangerTable.delegate = self;
    _showStrangerTable.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"显示用药病情与否的bool showdetail并没有赋值,此处初始化各种数据，需要网络交互");
    _strangerName = @"小月";
    _strangerDescribe = @"男／25+";
    _strangerLocation = @"上海";
    _strangerRelative = @"83%";
    showDetail = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"查看资料", @"");
}

#pragma 删除好友
-(void)addFriend{
    NSLog(@"数据库交互，删除好友");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SendAddMessViewController *smv = [main instantiateViewControllerWithIdentifier:@"sendaddmessage"];
    [self.navigationController pushViewController:smv animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (showDetail == YES) {
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (showDetail == YES) {
        if(section ==0) {
            return 2;
        }else if (section == 1){
            return 2;
        }else{
            return 2;
        }
    }else{
        if (section == 0) {
            return 2;
        }else{
            return 1;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (showDetail == YES) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 70;
            }else{
                return 60;
            }
        }else if(indexPath.section == 1){
            return 90;
        }else{
            return 95;
        }
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 70;
            }else{
                return 60;
            }
        }else{
            return 95;
        }
    }
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0&&indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"showinfocell" forIndexPath:indexPath];
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = _strangerImage;
        [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = _strangerName;
        ((UILabel *)[cell.contentView viewWithTag:3]).text = _strangerRelative;
        ((UILabel *)[cell.contentView viewWithTag:4]).text = _strangerDescribe;
        [((UIButton *)[cell.contentView viewWithTag:5]) setTitle:_strangerLocation forState:UIControlStateNormal];
    }else if(indexPath.section == 0&&indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"privatenote" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"addcell" forIndexPath:indexPath];
        [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        
        [((UIButton *)[cell.contentView viewWithTag:1]).layer setMasksToBounds:YES];
        [((UIButton *)[cell.contentView viewWithTag:1]).layer setCornerRadius:10.0];
    }
    return cell;
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
