//
//  NewFriendNoticeViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "NewFriendNoticeViewController.h"

#import "FriendDBManager.h"

@interface NewFriendNoticeViewController ()

{
    NSMutableArray *picArray;//获取发送信息的人name
    NSMutableArray *userArray;//获取发送信息的人name
    NSMutableArray *dataOfSimilarArray;//获取的各个人相似数的数组
    NSMutableArray *strangerAgeArray;
    NSMutableArray *strangerGenderArray;
    NSMutableArray *strangerDescribeArray;
    NSMutableArray *strangerJIDArray;
}

@end

@implementation NewFriendNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)setupView{
    self.title = NSLocalizedString(@"新的朋友", @"");
    _addFriendNotictTable.delegate = self;
    _addFriendNotictTable.dataSource = self;
    _addFriendNotictTable.backgroundColor = grayBackgroundLightColor;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    _addFriendNotictTable.tableHeaderView = headerView;
}

-(void)setupData{
    picArray = [NSMutableArray array];
    userArray = [NSMutableArray array];
    dataOfSimilarArray = [NSMutableArray array];
    strangerAgeArray = [NSMutableArray array];
    strangerGenderArray = [NSMutableArray array];
    strangerDescribeArray = [NSMutableArray array];
    strangerJIDArray = [NSMutableArray array];
    FMResultSet *addStrangerList = [[FriendDBManager ShareInstance] SearchAllFriend:StrangerTBName];
    while ([addStrangerList next]) {
        NSString *picPath = [addStrangerList stringForColumn:@"friendImageUrl"];
        NSString *strangerName = [addStrangerList stringForColumn:@"friendName"];
        NSString *strangerAge = [addStrangerList stringForColumn:@"friendAge"];
        NSString *strangerGender = [addStrangerList stringForColumn:@"friendGender"];
        NSString *strangerNote = [addStrangerList stringForColumn:@"friendDescribe"];
        NSString *strangerJID = [addStrangerList stringForColumn:@"friendJID"];
        [picArray addObject:picPath];
        [userArray addObject:strangerName];
        [strangerAgeArray addObject:strangerAge];
        [strangerGenderArray addObject:strangerGender];
        [strangerDescribeArray addObject:strangerNote];
        [strangerJIDArray addObject:strangerJID];
        if ([strangerNote isEqualToString:@""]) {
            [dataOfSimilarArray addObject:@"83%"];
        }else{
            [dataOfSimilarArray addObject:strangerNote];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return userArray.count;//获取的通知数目，网络获取
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"imageandlabelcell" forIndexPath:indexPath];
    ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageWithContentsOfFile:picArray[indexPath.row]];
    [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
    ((UILabel *)[cell.contentView viewWithTag:2]).text = userArray[indexPath.row];
    UIView *addLabelAndButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 40, 30)];
    numberLabel.font = [UIFont systemFontOfSize:17.0];
    numberLabel.textColor = [UIColor blackColor];
    UIButton *addFriendButton = [[UIButton alloc]initWithFrame:CGRectMake(45,10, 50, 30)];
    [addFriendButton addTarget:self action:@selector(addFriendYes:) forControlEvents:UIControlEventTouchUpInside];
    addFriendButton.tag = indexPath.row;
    addFriendButton.backgroundColor = themeColor;
    [addFriendButton setTitle:NSLocalizedString(@"添加", @"") forState:UIControlStateNormal];
    addFriendButton.userInteractionEnabled = YES;
    [addLabelAndButtonView addSubview:numberLabel];
    [addLabelAndButtonView addSubview:addFriendButton];
    
    cell.accessoryView = addLabelAndButtonView;
    return cell;
}

-(void)addFriendYes:(UIButton *)sender{
    [[XMPPSupportClass ShareInstance] confirmAddFriend:strangerJIDArray[sender.tag]];
    [self setupData];
    [_addFriendNotictTable reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    NSMutableDictionary *strangerDic = [NSMutableDictionary dictionary];
    [strangerDic setObject:strangerJIDArray[indexPath.row] forKey:@"strangerJID"];
    [strangerDic setObject:picArray[indexPath.row] forKey:@"strangerPic"];
    [strangerDic setObject:userArray[indexPath.row] forKey:@"strangerName"];
    [strangerDic setObject:strangerAgeArray[indexPath.row] forKey:@"strangerAge"];
    if([strangerGenderArray[indexPath.row] intValue] == 0){
        [strangerDic setObject:NSLocalizedString(@"男", @"") forKey:@"strangerGender"];
    }else{
        [strangerDic setObject:NSLocalizedString(@"女", @"") forKey:@"strangerGender"];
    }
    
#warning 此处的location以后要换为网络获取的地址
    [strangerDic setObject:@"上海" forKey:@"strangerLocation"];
    [strangerDic setObject:strangerDescribeArray[indexPath.row] forKey:@"strangerNote"];
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddFriendConfirmViewController *afcv = [main instantiateViewControllerWithIdentifier:@"addfriendconfirmdetail"];
    afcv.strangerDic = strangerDic;
    [self.navigationController pushViewController:afcv animated:YES];
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
