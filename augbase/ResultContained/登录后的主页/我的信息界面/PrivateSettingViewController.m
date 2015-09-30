//
//  PrivateSettingViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/28.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "PrivateSettingViewController.h"

#import "LoginViewController.h"
#import "RZTransitionsNavigationController.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "FriendDBManager.h"

#import "MyCaseRightsViewController.h"
#import "AdviceViewController.h"
#import "PrivateRightNoteViewController.h"
#import "AboutUsViewController.h"

@interface PrivateSettingViewController ()

{
    NSMutableArray *firstTitle;//第一大组数据，以下依次
//    NSMutableArray *secondTitle;
    NSMutableArray *thirdTitle;
    NSMutableArray *forthTitle;
}

@end

@implementation PrivateSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 4) {
        return 80;
    }else{
        return 50;
    }
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"collectionCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIndentify];
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    
    UIImageView *tailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    tailImageView.image = [UIImage imageNamed:@"goin"];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = firstTitle[indexPath.row];
        UISwitch *tailSwitch = [[UISwitch alloc]init];
        cell.accessoryView = tailSwitch;
        if (indexPath.row == 0) {
            [tailSwitch addTarget:self action:@selector(voice:) forControlEvents:UIControlEventValueChanged];
        }else if(indexPath.row == 1){
            [tailSwitch addTarget:self action:@selector(shock:) forControlEvents:UIControlEventValueChanged];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if(indexPath.section == 1){
        cell.textLabel.text = thirdTitle[indexPath.row];
        cell.accessoryView = tailImageView;
    }else if(indexPath.section == 2){
        if (indexPath.row == 4) {
            UIButton *loginOutButton = [[UIButton alloc]init];
            [loginOutButton setTitle:NSLocalizedString(@"登出", @"") forState:UIControlStateNormal];
            loginOutButton.layer.borderColor = [UIColor orangeColor].CGColor;
            loginOutButton.layer.borderWidth = 0.5;
            [loginOutButton viewWithRadis:10.0];
            [loginOutButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [loginOutButton addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:loginOutButton];
            [loginOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@13);
                make.bottom.equalTo(@-12);
                make.left.equalTo(@100);
                make.right.equalTo(@-100);
            }];
        }else{
            cell.textLabel.text = forthTitle[indexPath.row];
            cell.accessoryView = tailImageView;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MyCaseRightsViewController *mcv = [[MyCaseRightsViewController alloc]init];
            [self.navigationController pushViewController:mcv animated:YES];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            PrivateRightNoteViewController *prv = [[PrivateRightNoteViewController alloc]init];
            [self.navigationController pushViewController:prv animated:YES];
        }else if (indexPath.row == 1) {
            AdviceViewController *avc = [[AdviceViewController alloc]init];
            [self.navigationController pushViewController:avc animated:YES];
        }else if (indexPath.row == 2){
            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"874910905"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }else if (indexPath.row == 3){
            AboutUsViewController *auv = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:auv animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
//    headerView.layer.borderColor = lightGrayBackColor.CGColor;
//    headerView.layer.borderWidth = 0.5;
//    return headerView;
//}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = grayBackgroundLightColor;
    headerView.layer.borderColor = lightGrayBackColor.CGColor;
    headerView.layer.borderWidth = 0.5;
    return headerView;
}


-(void)setupView{
    self.title = NSLocalizedString(@"个人设置", @"");
    _privateSettingTable = [[UITableView alloc]init];
    _privateSettingTable.dataSource = self;
    _privateSettingTable.delegate = self;
    _privateSettingTable.showsVerticalScrollIndicator = NO;
    _privateSettingTable.sectionFooterHeight = 22;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = grayBackColor;
    _privateSettingTable.tableHeaderView = headerView;
    [self.view addSubview:_privateSettingTable];
    [_privateSettingTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(@0);
    }];
}

-(void)setupData{
    firstTitle = [@[@"声音",@"震动"]mutableCopy];
    thirdTitle = [@[@"我的病历权限"]mutableCopy];
    forthTitle = [@[@"隐私条款",@"意见反馈",@"喜欢易诊",@"关于我们",@"登出"]mutableCopy];
}

-(void)loginOut:(UIButton *)sender{
    NSString *deleUrl = [NSString stringWithFormat:@"%@unm/remove?uid=%@&token=%@&clienttype=%d",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],0];
    [[HttpManager ShareInstance]AFNetGETSupport:deleUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"删除成功");
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userUID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userJID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userNickName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userImageUrl"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userAge"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userGender"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NotFirstTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FriendList"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userTele"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userSystemVersion"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userNote"];
    [[DBManager ShareInstance] closeDB];
    [[FriendDBManager ShareInstance] closeDB];
    [[XMPPSupportClass ShareInstance] disconnect];
#warning 需要加入删除数据库的操作
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginview"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.window.rootViewController = [[RZTransitionsNavigationController alloc] initWithRootViewController:loginViewController];
}

-(void)voice:(UISwitch *)sender{
    NSLog(@"开启声音与否");
     BOOL isButtonOn = [sender isOn];//是则打开，否则关闭
}

-(void)shock:(UISwitch *)sender{
    NSLog(@"开启震动与否");
    BOOL isButtonOn = [sender isOn];
}

@end
