//
//  ContactGroupMemberDetailViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/21.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ContactGroupMemberDetailViewController.h"

@interface ContactGroupMemberDetailViewController ()

{
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *searchResults;//搜索结果的数组
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
}

@end

@implementation ContactGroupMemberDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contactGroupMemberDetailTable.delegate = self;
    _contactGroupMemberDetailTable.dataSource = self;
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = NO;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _contactGroupMemberDetailTable.tableHeaderView = searchViewController.searchBar;
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索列表", @"");
    dataArray = [@[@"小月大土豪",@"小月大土豪",@"小月大土豪"]mutableCopy];
    if (!searchResults) {
        searchResults = dataArray;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"群成员", @"");
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //谓词检测
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@", searchController.searchBar.text];
    //将所有和搜索有关的内容存储到arr数组
    searchResults = [NSMutableArray arrayWithArray:
                     [dataArray filteredArrayUsingPredicate:predicate]];
    //重新加载数据
    [_contactGroupMemberDetailTable reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchResults.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"contactgroupmembercell" forIndexPath:indexPath];
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
    [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
    ((UILabel *)[cell.contentView viewWithTag:2]).text = searchResults[indexPath.row];
//    [((UIButton *)[cell.contentView viewWithTag:6]) addTarget:self action:@selector(jionGroup:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma 添加加为好友的函数,获取对应的cell可以通过sender.superview来获取
-(void)jionGroup:(UIButton *)sender{
    NSLog(@"加上关注群信息的响应函数，网络通讯");
    //    NSLog(@"加上加为好友的响应函数，网络通讯");
    //    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    StrangerViewController *svc = [main instantiateViewControllerWithIdentifier:@"stranger"];
    //    [self.navigationController pushViewController:svc animated:YES];
}

-(void)addFriendYes{
    NSLog(@"加上同意加为好友的响应函数，网络通讯");
    //    boolAddArray[0] = YES;
    //    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    AddFriendConfirmViewController *afcv = [main instantiateViewControllerWithIdentifier:@"addfriendconfirmdetail"];
    //    [self.navigationController pushViewController:afcv animated:YES];
}

#pragma 需要加上cell的群消息判断，cell可根据［uitableview cellforindex］获取
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    UITableViewCell *targetCell = [_contactGroupMemberDetailTable cellForRowAtIndexPath:indexPath];
    NSLog(@"targetcell.text == %@",((UILabel *)[targetCell.contentView viewWithTag:2]).text);
//    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ContactGroupDetailViewController *cgdv = [main instantiateViewControllerWithIdentifier:@"contactgroupdetail"];
//    [self.navigationController pushViewController:cgdv animated:YES];
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
