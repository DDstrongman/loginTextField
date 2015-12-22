//
//  NewFriendNoticeViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "NewFriendNoticeViewController.h"

#import "FriendDBManager.h"
#import "ContactPersonDetailViewController.h"
#import "AddFriendConfirmViewController.h"

@interface NewFriendNoticeViewController ()

{
    NSMutableArray *picArray;//获取发送信息的人name
    NSMutableArray *userArray;//获取发送信息的人name
    NSMutableArray *dataOfSimilarArray;//获取的各个人相似数的数组
    NSMutableArray *strangerAgeArray;
    NSMutableArray *strangerGenderArray;
    NSMutableArray *strangerDescribeArray;
    NSMutableArray *strangerJIDArray;
    
    UIImageView *backGroudImageView;
    UILabel *remindLabel;
}

@end

@implementation NewFriendNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
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
    _addFriendNotictTable.tableFooterView = [[UIView alloc]init];
    backGroudImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth/2-60,(ViewHeight)/2-30-44-22-44-44, 120, 120)];
    backGroudImageView.image = [UIImage imageNamed:@"no_doc"];
    [_addFriendNotictTable addSubview:backGroudImageView];
    remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth/2-90,(ViewHeight)/2-30+120+10-44-22-44-44, 180, 50)];
    remindLabel.font = [UIFont systemFontOfSize:15.0];
    remindLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
    remindLabel.numberOfLines = 2;
    remindLabel.text = NSLocalizedString(@"没有需要验证的好友", @"");
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [_addFriendNotictTable addSubview:remindLabel];
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
        if ([strangerNote isEqualToString:@""]||strangerNote == [NSNull class]) {
            [dataOfSimilarArray addObject:@"83%"];
        }else{
            [dataOfSimilarArray addObject:strangerNote];
        }
    }
    if (userArray.count == 0) {
        backGroudImageView.hidden = NO;
        remindLabel.hidden = NO;
    }else{
        backGroudImageView.hidden = YES;
        remindLabel.hidden = YES;
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
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 50, 30)];
    numberLabel.font = [UIFont systemFontOfSize:17.0];
    numberLabel.textColor = [UIColor blackColor];
//    numberLabel.text = dataOfSimilarArray[indexPath.row];
    UIButton *addFriendButton = [[UIButton alloc]initWithFrame:CGRectMake(52,10, 50, 30)];
    [addFriendButton addTarget:self action:@selector(addFriendYes:) forControlEvents:UIControlEventTouchUpInside];
    addFriendButton.tag = indexPath.row;
    addFriendButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    addFriendButton.backgroundColor = themeColor;
    [addFriendButton viewWithRadis:3.0];
    [addFriendButton setTitle:NSLocalizedString(@"添加", @"") forState:UIControlStateNormal];
    addFriendButton.userInteractionEnabled = YES;
    [addLabelAndButtonView addSubview:numberLabel];
    [addLabelAndButtonView addSubview:addFriendButton];
    
    cell.accessoryView = addLabelAndButtonView;
    return cell;
}

-(void)addFriendYes:(UIButton *)sender{
    [[XMPPSupportClass ShareInstance] confirmAddFriend:strangerJIDArray[sender.tag]];
    NSLog(@"sender====%d,strangerJID====%@",sender.tag,strangerJIDArray[sender.tag]);
    [self setupData];
    [_addFriendNotictTable reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactPersonDetailViewController *cpdv = [main instantiateViewControllerWithIdentifier:@"contactpersondetail"];
    cpdv.isJIDOrYizhenID = NO;
    cpdv.isConfirm = YES;
    cpdv.friendJID = strangerJIDArray[indexPath.row];
    [self.navigationController pushViewController:cpdv animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//自定义cell的编辑模式，可以是删除也可以是增加 改变左侧的按钮的样式 删除是'-' 增加是'+'
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.row == 1) {
    //        return UITableViewCellEditingStyleInsert;
    //    } else {
    return UITableViewCellEditingStyleDelete;
    //    }
}


// 判断点击按钮的样式 来去做添加 或删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [userArray removeObjectAtIndex:indexPath.row];
#warning 此处加入删除消息的数据库操作
        [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
        [[FriendDBManager ShareInstance] deleteFriendObjTablename:StrangerTBName andinterobj:strangerJIDArray[indexPath.row]];
        [_addFriendNotictTable reloadData];
    }
}

@end
