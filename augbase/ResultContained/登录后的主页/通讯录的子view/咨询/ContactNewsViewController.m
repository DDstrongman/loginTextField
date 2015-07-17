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
    UISearchController *searchController;//显示搜索结果的tableview，系统自带，但是需要实现
}

@end

@implementation ContactNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _newsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    _newsTable.dataSource = self;
    _newsTable.delegate = self;
//    [self.view addSubview:_newsTable];
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索列表"];
    
    searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchController.active = NO;
//    searchController.sear = self;
//    searchController.searchResultsUpdater = self;
    
    _newsTable.tableHeaderView = mySearchBar;
    dataArray = [@[@"咨询",@"群组",@"等待验证好友",@"苹果",@"小月",@"小月打飞机",@"小月达飞机",@"小月你好帅！",@"and",@"苹果IOS",@"谷歌android",@"微软",@"微软WP",@"table",@"table",@"table",@"六六",@"六六",@"六六",@"table",@"table",@"table"]mutableCopy];
    
    
    _followOrNot = NO;//测试用
    _contactNumber = 3;
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
    return _contactNumber;
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
    ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"小易助手", @"");
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

@end
