//
//  NewFriendNoticeViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "NewFriendNoticeViewController.h"

@interface NewFriendNoticeViewController ()

{
    NSInteger noticeNumber;//获取的通知数目，网络获取
    NSArray *dataArray;//获取的各个人相似数的数组
    NSArray *userArray;//获取发送信息的人name
    NSArray *boolAddArray;//每个通知添加与否的数组
}

@end

@implementation NewFriendNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addFriendNotictTable.delegate = self;
    _addFriendNotictTable.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"需要加入获取的通知数目，网络获取，测试用均取数组第一个");
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"新的朋友", @"");
    dataArray = [NSArray arrayWithObjects:@"83%",@"63%",@"43%",nil];
    userArray = [NSArray arrayWithObjects:@"小月打飞机",@"小月打飞机",@"小月打飞机",nil];
    boolAddArray = [NSArray arrayWithObjects:@NO,@NO,@NO,nil];
    noticeNumber = dataArray.count;
//    if (_confirmAddMessOrNot) {
//        [_addFriendNotictTable reloadData];
//        _confirmAddMessOrNot = NO;
//    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return noticeNumber;//获取的通知数目，网络获取
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"imageandlabelcell" forIndexPath:indexPath];
    ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
    [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
    ((UILabel *)[cell.contentView viewWithTag:2]).text = userArray[0];

//    static NSString *CellIdentifier = @"addfriendnoticecell";
//    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    cell.textLabel.text = userArray[0];
//    cell.imageView.image = [UIImage imageNamed:@"icon.jpg"];
    UIView *addLabelAndButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 40, 30)];
    numberLabel.text = dataArray[0];
    numberLabel.font = [UIFont systemFontOfSize:17.0];
    numberLabel.textColor = [UIColor blackColor];
    UIButton *addFriendButton = [[UIButton alloc]initWithFrame:CGRectMake(45,10, 50, 30)];
    [addFriendButton addTarget:self action:@selector(addFriendYes) forControlEvents:UIControlEventTouchUpInside];
//    NSLog(@"bool===%@",boolAddArray[0]);
    if (boolAddArray[0] == 0) {
        addFriendButton.backgroundColor = grayLabelColor;
        [addFriendButton setTitle:NSLocalizedString(@"已添加", @"") forState:UIControlStateNormal];
        addFriendButton.userInteractionEnabled = NO;
    }else{
        addFriendButton.backgroundColor = themeColor;
        [addFriendButton setTitle:NSLocalizedString(@"添加", @"") forState:UIControlStateNormal];
        addFriendButton.userInteractionEnabled = YES;
    }
    [addLabelAndButtonView addSubview:numberLabel];
    [addLabelAndButtonView addSubview:addFriendButton];
    
    cell.accessoryView = addLabelAndButtonView;
    return cell;
}

-(void)addFriendYes{
    NSLog(@"加上同意加为好友的响应函数，网络通讯");
//    boolAddArray[0] = YES;
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddFriendConfirmViewController *afcv = [main instantiateViewControllerWithIdentifier:@"addfriendconfirmdetail"];
    [self.navigationController pushViewController:afcv animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
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
