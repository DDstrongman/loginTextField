//
//  PersonSettingViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/14.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "PersonSettingViewController.h"

@interface PersonSettingViewController ()

{
    BOOL topChat;//置顶聊天与否
    BOOL disturb;//消息免打扰与否
    BOOL showDetail;//显示用药与病例否
    BOOL darkMenu;//加入黑名单否
}

@end

@implementation PersonSettingViewController

#pragma 需要获取网络参数以便完成必备的初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    _settingTable.backgroundColor = [UIColor whiteColor];
    NSLog(@"此处需要加入网络获取必要参数");
    topChat = NO;
    disturb = NO;
    showDetail = NO;
    darkMenu = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"权限设置", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma 需要加入网络获取的初始化设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingcell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"置顶聊天", @"");
        [((UISwitch *)[cell.contentView viewWithTag:2]) setOn:topChat];//此处需要加入网络获取的参数
        [((UISwitch *)[cell.contentView viewWithTag:2]) addTarget:self action:@selector(topChatBool:) forControlEvents:UIControlEventValueChanged];
    }else if (indexPath.row == 1){
        ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"消息免打扰", @"");
        [((UISwitch *)[cell.contentView viewWithTag:2]) setOn:disturb];//此处需要加入网络获取的参数
        [((UISwitch *)[cell.contentView viewWithTag:2]) addTarget:self action:@selector(chatBool:) forControlEvents:UIControlEventValueChanged];
    }else if (indexPath.row == 2){
        ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"病情和用药历史对其可见", @"");
        [((UISwitch *)[cell.contentView viewWithTag:2]) setOn:showDetail];//此处需要加入网络获取的参数
        [((UISwitch *)[cell.contentView viewWithTag:2]) addTarget:self action:@selector(medicalAndDiseaseBool:) forControlEvents:UIControlEventValueChanged];
    }else{
        ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"加入黑名单", @"");
        [((UISwitch *)[cell.contentView viewWithTag:2]) setOn:darkMenu];//此处需要加入网络获取的参数
        [((UISwitch *)[cell.contentView viewWithTag:2]) addTarget:self action:@selector(darkMenuBool:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

#pragma 切换置顶聊天的响应函数,下面所有四个函数均需要加入存入网络数据库的功能
-(void)topChatBool:(id)sender {
    NSLog(@"加入切换判断和响应");
    topChat = [((UISwitch*)sender) isOn];
}
#pragma 消息免打扰的响应函数
-(void)chatBool:(id)sender{
    NSLog(@"加入切换判断和响应");
    disturb = [((UISwitch*)sender) isOn];
}
#pragma 用药和病例可见否的响应函数
-(void)medicalAndDiseaseBool:(id)sender{
    NSLog(@"加入切换判断和响应");
    showDetail = [((UISwitch*)sender) isOn];
}
#pragma 黑名单的响应函数
-(void)darkMenuBool:(id)sender{
    NSLog(@"加入切换判断和响应");
    darkMenu = [((UISwitch*)sender) isOn];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
//    headerView.backgroundColor = [UIColor lightGrayColor];
//    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

@end
