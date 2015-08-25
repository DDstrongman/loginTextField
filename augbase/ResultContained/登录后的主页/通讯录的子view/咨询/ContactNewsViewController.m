//
//  ContactNewsViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ContactNewsViewController.h"

@interface ContactNewsViewController ()

{
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *searchResults;//搜索结果的数组
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
}

@end

@implementation ContactNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _newsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    _newsTable.dataSource = self;
    _newsTable.delegate = self;

    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.dimsBackgroundDuringPresentation = NO;
    searchViewController.hidesNavigationBarDuringPresentation = NO;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _newsTable.tableHeaderView = searchViewController.searchBar;
    searchViewController.searchBar.placeholder = NSLocalizedString(@"", @"");
    searchViewController.delegate = self;
    
    dataArray = [@[@"小月",@"小易",@"小易"]mutableCopy];
    if (!searchResults) {
        searchResults = dataArray;
    }
    
    _followOrNot = NO;//测试用
    _contactNumber = 3;
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //谓词检测
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@", searchController.searchBar.text];
    if ([searchController.searchBar.text isEqualToString:@""]){
        searchResults = dataArray;
        [_newsTable reloadData];
    }else{
        //将所有和搜索有关的内容存储到arr数组
        searchResults = [NSMutableArray arrayWithArray:
                         [dataArray filteredArrayUsingPredicate:predicate]];
        //重新加载数据
        [_newsTable reloadData];
    }
}

#pragma 此处需要网络获取关注与否,与公众号数目
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"咨询", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma 这里需要网络获取公众号数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchResults.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"imageandtwolabelcell" forIndexPath:indexPath];
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
    [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
    ((UILabel *)[cell.contentView viewWithTag:2]).text = searchResults[indexPath.row];
    ((UILabel *)[cell.contentView viewWithTag:3]).text = NSLocalizedString(@"小月喜欢打飞机", @"");
    //    [((UIButton *)[cell.contentView viewWithTag:7]) addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [confirmButton addTarget:self action:@selector(followSomeOne:) forControlEvents:UIControlEventTouchUpInside];
    if (!_followOrNot) {
        [confirmButton setTitle:NSLocalizedString(@"关注", @"") forState:UIControlStateNormal];
        confirmButton.backgroundColor = themeColor;
    }else{
        [confirmButton setTitle:NSLocalizedString(@"取消关注", @"") forState:UIControlStateNormal];
        confirmButton.backgroundColor = grayLabelColor;
    }
    cell.accessoryView = confirmButton;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma 关注
-(void)followSomeOne:(UIButton *)sender{
    NSLog(@"加入关注后的网络交互");
    if (!_followOrNot) {
        NSLog(@"关注的网络交互");
        [sender setTitle:NSLocalizedString(@"取消关注", @"") forState:UIControlStateNormal];
        sender.backgroundColor = grayLabelColor;
    }else{
        NSLog(@"取消关注");
        [sender setTitle:NSLocalizedString(@"关注", @"") forState:UIControlStateNormal];
        sender.backgroundColor = themeColor;
    }
    _followOrNot = !_followOrNot;
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

#pragma searchviewcontroller的delegate
// 搜索界面将要出现
- (void)willPresentSearchController:(UISearchController *)searchController{
    NSLog(@"将要  开始  搜索时触发的方法");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

// 搜索界面将要消失
-(void)willDismissSearchController:(UISearchController *)searchController{
    NSLog(@"将要  取消  搜索时触发的方法");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //    navigationBar.hidden = NO;
    //    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

-(void)didDismissSearchController:(UISearchController *)searchController{
    
}

@end
