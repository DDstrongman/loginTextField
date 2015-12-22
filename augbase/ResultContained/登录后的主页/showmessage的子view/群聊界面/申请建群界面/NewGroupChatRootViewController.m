//
//  AskForNewGroupChatViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/12/1.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "NewGroupChatRootViewController.h"

@interface NewGroupChatRootViewController ()

@end

@implementation NewGroupChatRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"群聊", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;//此处的数字应为网络获取的群数目
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"applyGroupCell";//此处注册cell需要自己变动
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
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

-(void)setupView{
    _applyNewGroupTable = [[UITableView alloc]init];
    _applyNewGroupTable.delegate = self;
    _applyNewGroupTable.dataSource = self;
    [self.view addSubview:_applyNewGroupTable];
    self.view.backgroundColor = grayBackColor;
    _applyNewGroupTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_applyNewGroupTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
}

-(void)setupData{
    
}

@end
