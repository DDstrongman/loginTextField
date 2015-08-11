//
//  ContactPersonDetailViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ContactPersonDetailViewController.h"

#import "RootViewController.h"

@interface ContactPersonDetailViewController ()

{
    BOOL topChat;//置顶聊天与否
    BOOL disturb;//消息免打扰与否
    BOOL showDetail;//显示用药与病例否
    BOOL darkMenu;//加入黑名单否
}

@end

@implementation ContactPersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contactPersonTable.delegate = self;
    _contactPersonTable.dataSource = self;
    
    NSLog(@"此处需要加入网络获取必要参数");
    topChat = NO;
    disturb = NO;
    showDetail = NO;
    darkMenu = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"联系人详情", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 4;
    }else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70;
        }else{
            return 60;
        }
    }else if(indexPath.section == 1){
        return 45;
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else{
            return 81;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"showinfocell" forIndexPath:indexPath];
            [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"privatenotecell" forIndexPath:indexPath];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if(indexPath.section == 1){
        static NSString *CellIdentifier = @"contactinfosettingcell";
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"置顶聊天", @"");
            UISwitch *tailSwitch = [[UISwitch alloc]init];
            [tailSwitch setOn:topChat];//此处需要加入网络获取的参数
            [tailSwitch addTarget:self action:@selector(topChatBool:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tailSwitch;
        }else if (indexPath.row == 1){
            cell.textLabel.text = NSLocalizedString(@"消息免打扰", @"");
            UISwitch *tailSwitch = [[UISwitch alloc]init];
            [tailSwitch setOn:disturb];//此处需要加入网络获取的参数
            [tailSwitch addTarget:self action:@selector(chatBool:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tailSwitch;
        }else if (indexPath.row == 2){
            cell.textLabel.text = NSLocalizedString(@"病情和用药历史对其可见", @"");
            UISwitch *tailSwitch = [[UISwitch alloc]init];
            [tailSwitch setOn:showDetail];//此处需要加入网络获取的参数
            [tailSwitch addTarget:self action:@selector(medicalAndDiseaseBool:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tailSwitch;
        }else{
            cell.textLabel.text = NSLocalizedString(@"加入黑名单", @"");
            UISwitch *tailSwitch = [[UISwitch alloc]init];
            [tailSwitch setOn:darkMenu];//此处需要加入网络获取的参数
            [tailSwitch addTarget:self action:@selector(darkMenuBool:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tailSwitch;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else{
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"contactreportcell";
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text = NSLocalizedString(@"举报", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            if (indexPath.row == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"sendmesscell" forIndexPath:indexPath];
                [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(sendMess) forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"deletecell" forIndexPath:indexPath];
                [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = grayBackColor.CGColor;
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

#pragma 发送消息和删除好友的响应函数
-(void)sendMess{
    NSLog(@"发送消息");
    RootViewController *rvc = [[RootViewController alloc]init];
    rvc.personJID = _personJID;
    [self.navigationController pushViewController:rvc animated:YES];
}

-(void)deleteFriend{
    NSLog(@"删除好友");
    [[XMPPSupportClass ShareInstance] removeFriend:_personJID];
    [[XMPPSupportClass ShareInstance] getMyQueryRoster];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 2&&indexPath.row == 0) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReportTableViewController *cpdv = [main instantiateViewControllerWithIdentifier:@"reportdisturb"];
        [self.navigationController pushViewController:cpdv animated:YES];
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
