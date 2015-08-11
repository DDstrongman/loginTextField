//
//  RootPrivateInfoViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "RootPrivateInfoViewController.h"
#import "XMPPSupportClass.h"

@interface RootPrivateInfoViewController ()

@end

@implementation RootPrivateInfoViewController

{
    BOOL showDetail;//显示病情用药与否
}

#pragma 初始化各种信息。需要网络交互
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"详细资料", @"");
    _showInfoTable.dataSource = self;
    _showInfoTable.delegate = self;
    _showInfoTable.backgroundColor = [UIColor whiteColor];
    
//    _deleteButton = [[UIButton alloc]init];
//    [_deleteButton setTitle:NSLocalizedString(@"删除", @"") forState:UIControlStateNormal];
//    [_deleteButton addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
//    _deleteButton.backgroundColor = [UIColor redColor];
//    [_deleteButton.layer setMasksToBounds:YES];
//    [_deleteButton.layer setCornerRadius:10.0];
//    [self.view addSubview:_deleteButton];
//    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_showInfoTable.mas_bottom).with.offset(3);
//        make.left.equalTo(@20);
//        make.right.equalTo(@-20);
//        make.height.equalTo(@45);
//    }];
    
    NSLog(@"显示用药病情与否的bool showdetail并没有赋值,此处初始化各种数据，需要网络交互");
    _personName = @"小月";
    _personDescribe = @"男／25+";
    _personLocation = @"上海";
    _personRelative = @"83%";
    showDetail = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    UIButton *personSettingButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [personSettingButton setBackgroundImage:[UIImage imageNamed:@"friends_set"] forState:UIControlStateNormal];
    [personSettingButton addTarget:self action:@selector(gotoPersonSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:personSettingButton]];
}

#pragma 删除好友
-(void)deleteFriend{
    NSLog(@"数据库交互，删除好友");
    [[XMPPSupportClass ShareInstance] removeFriend:_personJID];
}

#pragma 跳转gotoPrivateDetail
-(void)gotoPersonSetting{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonSettingViewController *psv = [story instantiateViewControllerWithIdentifier:@"personsetting"];
    [self.navigationController pushViewController:psv animated:YES];
//    RootPrivateInfoViewController *rpiv = [story instantiateViewControllerWithIdentifier:@"rootprivate"];
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
            return 2;
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
            if (indexPath.row == 0) {
                return 40;
            }else{
                return 95;
            }
        }
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 70;
            }else{
                return 60;
            }
        }else{
            if (indexPath.row == 0) {
                return 40;
            }else{
                return 95;
            }
        }
    }
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0&&indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"showinfocell" forIndexPath:indexPath];
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = _personImage;
        ((UILabel *)[cell.contentView viewWithTag:2]).text = _personName;
        ((UILabel *)[cell.contentView viewWithTag:3]).text = _personRelative;
        ((UILabel *)[cell.contentView viewWithTag:4]).text = _personDescribe;
        [((UIButton *)[cell.contentView viewWithTag:5]) setTitle:_personLocation forState:UIControlStateNormal];
    }else if(indexPath.section == 0&&indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"privatenote" forIndexPath:indexPath];
    }else{
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"reportcell" forIndexPath:indexPath];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"deletecell" forIndexPath:indexPath];
            [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
            
            [((UIButton *)[cell.contentView viewWithTag:1]).layer setMasksToBounds:YES];
            [((UIButton *)[cell.contentView viewWithTag:1]).layer setCornerRadius:10.0];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if ((indexPath.section == 1&&indexPath.row == 0&&!showDetail)|(showDetail&&indexPath.section == 2&&indexPath.row ==0)) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *rpdv = [story instantiateViewControllerWithIdentifier:@"reportdisturb"];
        [self.navigationController pushViewController:rpdv animated:YES];
    }
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
