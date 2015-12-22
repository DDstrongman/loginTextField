//
//  ShootCaseViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MyInfoViewController.h"

#import "MineSettingInfoViewController.h"
#import "PrivateSettingViewController.h"
#import "CollectionListViewController.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myInfoTable.backgroundColor = grayBackgroundLightColor;
    _myInfoTable.delegate = self;
    _myInfoTable.dataSource = self;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    footerView.backgroundColor = [UIColor clearColor];
    _myInfoTable.tableFooterView = footerView;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.title = NSLocalizedString(@"我的", @"");
    
    UIImage* imageNormal = [UIImage imageNamed:@"mine_off"];
    UIImage* imageSelected = [UIImage imageNamed:@"mine_on"];
    self.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(void)viewDidAppear:(BOOL)animated{
    [_myInfoTable reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&indexPath.row == 0) {
        return 80;
    }else if(indexPath.section == 0 &&indexPath.row == 1){
        return 50;
    }else{
        return 45;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 &&indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myinfo" forIndexPath:indexPath];
        [[cell.contentView viewWithTag:1] imageWithRound:NO];
        NSData *tempData = [[WriteFileSupport ShareInstance]readData:yizhenImageFile FileName:[[[NSUserDefaults standardUserDefaults]objectForKey:@"userJID"] stringByAppendingString:@".png"]];
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageWithData:tempData];
        if ([((NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"userNickName"]) isEqualToString:@""]) {
            ((UILabel *)[cell.contentView viewWithTag:2]).text = defaultUserName;
        }else{
            ((UILabel *)[cell.contentView viewWithTag:2]).text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNickName"];
        }
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userJID"] != nil) {
            ((UILabel *)[cell.contentView viewWithTag:4]).text = [NSLocalizedString(@"易诊号: ", @"") stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userYizhenID"]];
        }
        cell.layer.borderColor = lightGrayBackColor.CGColor;
        cell.layer.borderWidth = 0.5;
        return cell;
    }else if (indexPath.section == 0 &&indexPath.row == 1){
        static NSString *myCellIdentifier = @"myCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
        }
        cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNote"];
        cell.textLabel.textColor = grayLabelColor;
        cell.layer.borderColor = lightGrayBackColor.CGColor;
        cell.layer.borderWidth = 0.5;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageandlabelcell" forIndexPath:indexPath];
        if (indexPath.section == 1) {
            ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"collect"];
            ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"我收藏的咨讯", @"");
            ((UILabel *)[cell.contentView viewWithTag:3]).text = NSLocalizedString(@"", @"");
        }else{
            ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"set_up"];
            ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"设置", @"");
        }
        cell.layer.borderColor = lightGrayBackColor.CGColor;
        cell.layer.borderWidth = 0.5;
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0&&indexPath.row == 0) {
        MineSettingInfoViewController *msiv = [[MineSettingInfoViewController alloc]init];
        [self.navigationController pushViewController:msiv animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CollectionListViewController *cvl = [main instantiateViewControllerWithIdentifier:@"mycollection"];
        [self.navigationController pushViewController:cvl animated:YES];
    }else if(indexPath.section == 2 && indexPath.row == 0){
        PrivateSettingViewController *psv = [[PrivateSettingViewController alloc]init];
        [self.navigationController pushViewController:psv animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
