//
//  ShootCaseViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myInfoTable.delegate = self;
    _myInfoTable.dataSource = self;
    
}

//#pragma 去掉statebar
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self initNavigationBar];
    
    UIImage* imageNormal = [UIImage imageNamed:@"mine_off"];
    UIImage* imageSelected = [UIImage imageNamed:@"mine_on"];
    self.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma 因为加入了tabbarcontroller，改变系统的navigationbar出现问题，所以自己写一个navigationbar
-(void)initNavigationBar{
    UIView *navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 66)];
    navigationBar.backgroundColor = themeColor;
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22+22);
    titleLabel.text = NSLocalizedString(@"我", @"");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    
    [self.view addSubview:navigationBar];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
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
        [cell.contentView viewWithTag:3].hidden = YES;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 0 &&indexPath.row == 1){
        static NSString *myCellIdentifier = @"myCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
        }
        cell.textLabel.text = NSLocalizedString(@"这只是个测试", @"");
        cell.textLabel.textColor = grayLabelColor;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageandlabelcell" forIndexPath:indexPath];
        if (indexPath.section == 1) {
            ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"collect"];
//            [[cell.contentView viewWithTag:1] imageWithRound:NO];
            ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"我的收藏", @"");
            ((UILabel *)[cell.contentView viewWithTag:3]).text = NSLocalizedString(@"23", @"");
        }else{
            [cell.contentView viewWithTag:1].backgroundColor = [UIColor greenColor];
            ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"设置", @"");
        }
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
