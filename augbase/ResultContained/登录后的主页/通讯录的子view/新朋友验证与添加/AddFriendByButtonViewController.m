//
//  AddFriendByButtonViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "AddFriendByButtonViewController.h"

@interface AddFriendByButtonViewController ()

@end

@implementation AddFriendByButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addWaysTable.dataSource = self;
    _addWaysTable.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"添加好友", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"imageandlabelcell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
        ((UIImageView *)[cell.contentView viewWithTag:1]).clipsToBounds = YES;
        ((UIImageView *)[cell.contentView viewWithTag:1]).layer.cornerRadius = ((UIImageView *)[cell.contentView viewWithTag:1]).frame.size.width/2;
        ((UIImageView *)[cell.contentView viewWithTag:1]).layer.borderWidth = 1;
        ((UIImageView *)[cell.contentView viewWithTag:1]).layer.borderColor = [UIColor whiteColor].CGColor;
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"相似好友", @"");
    }else if(indexPath.row == 1){
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
        ((UIImageView *)[cell.contentView viewWithTag:1]).clipsToBounds = YES;
        ((UIImageView *)[cell.contentView viewWithTag:1]).layer.cornerRadius = ((UIImageView *)[cell.contentView viewWithTag:1]).frame.size.width/2;
        ((UIImageView *)[cell.contentView viewWithTag:1]).layer.borderWidth = 1;
        ((UIImageView *)[cell.contentView viewWithTag:1]).layer.borderColor = [UIColor whiteColor].CGColor;
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"附近好友", @"");
    }else if (indexPath.row == 2){
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
        [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"邀请QQ好友", @"");
    }else{
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
        ((UIImageView *)[cell.contentView viewWithTag:1]).clipsToBounds = YES;
        ((UIImageView *)[cell.contentView viewWithTag:1]).layer.cornerRadius = ((UIImageView *)[cell.contentView viewWithTag:1]).frame.size.width/2;
        ((UIImageView *)[cell.contentView viewWithTag:1]).layer.borderWidth = 1;
        ((UIImageView *)[cell.contentView viewWithTag:1]).layer.borderColor = [UIColor whiteColor].CGColor;
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"邀请微信好友", @"");
    }
    return cell;
}

-(void)addFriendYes{
    NSLog(@"加上同意加为好友的响应函数，网络通讯");
    //    boolAddArray[0] = YES;
//    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AddFriendConfirmViewController *afcv = [main instantiateViewControllerWithIdentifier:@"addfriendconfirmdetail"];
//    [self.navigationController pushViewController:afcv animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.row == 0) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SimilarFriendViewController *sfv = [main instantiateViewControllerWithIdentifier:@"similarfriend"];
        [self.navigationController pushViewController:sfv animated:YES];
    }else if(indexPath.row == 1){
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NearByFriendViewController *nfv = [main instantiateViewControllerWithIdentifier:@"nearbyfriend"];
        [self.navigationController pushViewController:nfv animated:YES];
    }else if (indexPath.row == 2){
        
    }else{
        
    }
        
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
