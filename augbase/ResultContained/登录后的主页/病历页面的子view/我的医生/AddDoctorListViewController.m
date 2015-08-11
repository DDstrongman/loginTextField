//
//  AddDoctorListViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "AddDoctorListViewController.h"

#import "MessTableViewCell.h"

#import "MyDoctorDetailViewController.h"

@interface AddDoctorListViewController ()

{
    UISearchBar *mySearchBar;
    UISearchController *searchViewController;
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *searchResults;//搜索结果的数组
}

@end

@implementation AddDoctorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"我的医生", @"");
#warning 加入网络获取人名的
    dataArray = [@[NSLocalizedString(@"小易助手", @""),NSLocalizedString(@"张村桥", @""),NSLocalizedString(@"老王", @""),NSLocalizedString(@"小猪猪", @""),NSLocalizedString(@"楼桑", @""),NSLocalizedString(@"永超", @"")]mutableCopy];
    searchResults = dataArray;
    
    _addDoctorListTable = [[UITableView alloc]init];
    _addDoctorListTable.delegate = self;
    _addDoctorListTable.dataSource = self;
    _addDoctorListTable.tableFooterView = [[UIView alloc]init];;
    [self.view addSubview:_addDoctorListTable];
    [_addDoctorListTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(@0);
        //        make.height.equalTo(tableHeight);
    }];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索列表"];
    
    //    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    //    searchDisplayController.active = NO;
    //    searchDisplayController.searchResultsDataSource = self;
    //    searchDisplayController.searchResultsDelegate = self;
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = NO;
    searchViewController.hidesNavigationBarDuringPresentation = NO;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _addDoctorListTable.tableHeaderView = searchViewController.searchBar;
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索列表", @"");
    //    @"咨询",@"群组",@"等待验证好友",
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //谓词检测
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@", searchController.searchBar.text];
    if ([searchController.searchBar.text isEqualToString:@""]){
        searchResults = dataArray;
        [_addDoctorListTable reloadData];
    }else{
        //将所有和搜索有关的内容存储到arr数组
        searchResults = [NSMutableArray arrayWithArray:
                         [dataArray filteredArrayUsingPredicate:predicate]];
        //重新加载数据
        [_addDoctorListTable reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return searchResults.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"showDoctorCell";
    [_addDoctorListTable registerClass:[MessTableViewCell class]forCellReuseIdentifier:cellIndentify];
    MessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    cell.iconImageView.image = [UIImage imageNamed:@"groups"];
    cell.iconImageView.backgroundColor = themeColor;
    cell.titleText.text = searchResults[indexPath.row];
    cell.descriptionText.text = NSLocalizedString(@"有问题咨询小易", @"");//测试用，以后改为传来的讯息,以下同
    cell.timeText.text = @"18:00";
    
    return cell;
}

#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    MyDoctorDetailViewController *mddv = [[MyDoctorDetailViewController alloc]init];
    
    [self.navigationController pushViewController:mddv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma cell滑入的动画效果
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    cell.frame = CGRectMake(-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    //    [UIView animateWithDuration:0.7 animations:^{
    //        cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    //    } completion:^(BOOL finished) {
    //        ;
    //    }];
}

#pragma 添加头和尾
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
////    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
////    headerView.backgroundColor = [UIColor lightGrayColor];
////    return headerView;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

@end
