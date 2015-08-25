//
//  ChooseGroupViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/13.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ChooseGroupViewController.h"

@interface ChooseGroupViewController ()

{
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *titleDataArray;//官方提供的选项的名称数组
    NSMutableArray *searchResults;//搜索结果的数组
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
}

@end

@implementation ChooseGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _groupTable = [[UITableView alloc]init];
    _groupTable.delegate = self;
    _groupTable.dataSource = self;
    [self.view addSubview:_groupTable];
    self.view.backgroundColor = grayBackColor;
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = NO;
    searchViewController.hidesNavigationBarDuringPresentation = NO;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    searchViewController.delegate = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _groupTable.tableHeaderView = searchViewController.searchBar;
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"", @"");
    searchViewController.searchBar.backgroundColor = [UIColor whiteColor];
    searchViewController.searchBar.backgroundImage = [UIImage imageNamed:@"white"];
    searchViewController.searchBar.layer.borderWidth = 0.5;
    searchViewController.searchBar.layer.borderColor = lightGrayBackColor.CGColor;
    for (UIView *sb in [[searchViewController.searchBar subviews][0] subviews]) {
        if ([sb isKindOfClass:[UITextField class]]) {
            sb.layer.borderColor = themeColor.CGColor;
            sb.layer.borderWidth = 0.5;
            [sb viewWithRadis:10.0];
        }
    }
#warning 此处的array需要网络获取
    dataArray = [@[@"小月",@"娄sir",@"老王",@"红包"]mutableCopy];
    if (!searchResults) {
        searchResults = dataArray;
    }
    _groupTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_groupTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"群助手", @"");
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //谓词检测
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@", searchController.searchBar.text];
    if ([searchController.searchBar.text isEqualToString:@""]){
        searchResults = dataArray;
        [_groupTable reloadData];
    }else{
        //将所有和搜索有关的内容存储到arr数组
        searchResults = [NSMutableArray arrayWithArray:
                         [dataArray filteredArrayUsingPredicate:predicate]];
        //重新加载数据
        [_groupTable reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;//此处的数字应为网络获取的群数目
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"showGroupCell";//此处注册cell需要自己变动
    [_groupTable registerClass:[MessTableViewCell class]forCellReuseIdentifier:cellIndentify];
    MessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld",@"persontitle",(indexPath.row+1)]];
    cell.titleText.text = dataArray[indexPath.row];
    cell.descriptionText.text = @"小月你又打飞机";
    cell.timeText.text = @"18:00";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    RootViewController *rtv = [[RootViewController alloc]init];
    rtv.privateOrNot = 1;//群聊
    [self.navigationController pushViewController:rtv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ---deit delete---
//// 让 UITableView 和 UIViewController 变成可编辑状态
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
////    [super setEditing:editing animated:animated];
//
//    [self setEditing:editing animated:animated];
//}

//  指定哪一行可以编辑 哪行不能编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
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
        [_groupTable beginUpdates];
        NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
        // 删除 索引的方法 后面是动画样式
        //        [testArrayDatasource removeObjectAtIndex:indexPath.row];
        [dataArray removeObjectAtIndex:indexPath.row];
        [_groupTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        [_groupTable  endUpdates];
    }
    
    // 添加的操作
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        NSArray *indexPaths = @[indexPath];
        [_groupTable insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationRight)];
        
    }
}

#pragma mark 只有实现这个方法，编辑模式中才允许移动Cell
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
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

#pragma searchbar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self doSearch:searchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self doSearch:searchBar];
}

- (void)doSearch:(UISearchBar *)searchBar{
    NSLog(@"搜索开始");
}

#pragma 加cell进入动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (cell.frame.origin.y>ViewHeight/2) {
    //        cell.frame = CGRectMake(-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    //        [UIView animateWithDuration:0.7 animations:^{
    //            cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    //        } completion:^(BOOL finished) {
    //            ;
    //        }];
    //    }
}

#pragma searchviewcontroller的delegate
// 搜索界面将要出现
- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"将要  开始  搜索时触发的方法");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    //    navigationBar.hidden = YES;
    //    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

// 搜索界面将要消失
-(void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"将要  取消  搜索时触发的方法");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //    navigationBar.hidden = NO;
    //    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

-(void)didDismissSearchController:(UISearchController *)searchController
{
    
}

@end
