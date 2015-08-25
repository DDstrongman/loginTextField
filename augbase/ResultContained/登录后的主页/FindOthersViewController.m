//
//  FindOthersViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "FindOthersViewController.h"


#import "ChineseInclude.h"
#import "PinYinForObjc.h"

#import "DBManager.h"
#import "FriendDBManager.h"

@interface FindOthersViewController ()

{
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *dataDescribe;//好友签名
    NSMutableArray *dataJID;//好友JID
    NSMutableArray *titleDataArray;//官方提供的选项的名称数组
    NSMutableArray *titleImageNameArray;//官方提供的选项的头像名称数组
    NSMutableArray *searchResults;//搜索结果的数组
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
}

@end

@implementation FindOthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contactsTableview.delegate = self;
    _contactsTableview.dataSource = self;
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = YES;
    searchViewController.hidesNavigationBarDuringPresentation = YES;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _contactsTableview.tableHeaderView = searchViewController.searchBar;
    
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
//    @"咨询",@"群组",@"等待验证好友",
    titleDataArray = [@[NSLocalizedString(@"群组", @""),NSLocalizedString(@"等待验证好友", @"")]mutableCopy];
    titleImageNameArray = [@[@"groups",@"verify_friend"]mutableCopy];
    
    _contactsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _contactsTableview.separatorColor = lightGrayBackColor;
    _contactsTableview.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    _contactsTableview.backgroundColor = grayBackgroundLightColor;
    self.view.backgroundColor = grayBackgroundLightColor;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    self.tabBarController.title = NSLocalizedString(@"联系人", @"");
    UIButton *sendMessButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    [sendMessButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    sendMessButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sendMessButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendMessButton]];
    
    UIImage* imageNormal = [UIImage imageNamed:@"contacts_off"];
    UIImage* imageSelected = [UIImage imageNamed:@"contacts_on"];
    self.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(void)viewDidAppear:(BOOL)animated{
    [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
    
    NSMutableArray *tableFrindName = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tableFrindDescribe = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tableFrindJID = [NSMutableArray arrayWithCapacity:0];
    [[FriendDBManager ShareInstance] isFriendTableExist:YizhenFriendName];
    FMResultSet *friendList = [[FriendDBManager ShareInstance] SearchAllFriend:YizhenFriendName];
    
#warning 此处需要加入通过jid判断用户name的网络需求
    while ([friendList next]) {
        [tableFrindDescribe addObject:[friendList stringForColumn:@"friendDescribe"]];
        if ([[friendList stringForColumn:@"friendName"] isEqualToString:@""]) {
            [tableFrindName addObject:defaultUserName];
        }else{
            [tableFrindName addObject:[friendList stringForColumn:@"friendName"]];
        }
        [tableFrindJID addObject:[friendList stringForColumn:@"friendJID"]];
    }
    
    dataArray = [[NSMutableArray alloc]initWithArray:tableFrindName];
    dataDescribe = [[NSMutableArray alloc]initWithArray:tableFrindDescribe];
    dataJID = [[NSMutableArray alloc]initWithArray:tableFrindJID];
    searchResults = dataArray;
    [_contactsTableview reloadData];
}

#pragma 添加朋友的功能需要实现
-(void)addFriend{
    NSLog(@"添加朋友的功能需要实现");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddFriendByButtonViewController *afbbv = [main instantiateViewControllerWithIdentifier:@"addfriendbybutton"];
    [self.navigationController pushViewController:afbbv animated:YES];
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //谓词检测
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@", searchController.searchBar.text];
    if ([searchController.searchBar.text isEqualToString:@""]){
        searchResults = dataArray;
        [_contactsTableview reloadData];
    }else{
        //将所有和搜索有关的内容存储到arr数组
        searchResults = [NSMutableArray arrayWithArray:
                         [dataArray filteredArrayUsingPredicate:predicate]];
        //重新加载数据
        [_contactsTableview reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    if (section == 0) {
        return titleDataArray.count;
    }else{
        return searchResults.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"contactcell" forIndexPath:indexPath];
    //    [cellContact setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section == 0) {
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:titleImageNameArray[indexPath.row]];
        [cell.contentView viewWithTag:1].backgroundColor = themeColor;
    }
    [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
    if (indexPath.section == 0) {
        ((UILabel *)[cell.contentView viewWithTag:2]).text = titleDataArray[indexPath.row];
    }else{
        FMResultSet *messPicPath = [[FriendDBManager ShareInstance] SearchOneFriend:YizhenFriendName FriendJID:dataJID[indexPath.row]];
        while ([messPicPath next]) {
            NSString *picPath = [messPicPath stringForColumn:@"friendImageUrl"];
            ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageWithContentsOfFile:picPath];
        }
        ((UILabel *)[cell.contentView viewWithTag:2]).text = searchResults[indexPath.row];
        ((UILabel *)[cell.contentView viewWithTag:4]).text = dataDescribe[indexPath.row];
    }
    return cell;
}
#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ContactGroupViewController *cgv = [main instantiateViewControllerWithIdentifier:@"contantgroup"];
            [self.navigationController pushViewController:cgv animated:YES];
        }else{
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NewFriendNoticeViewController *nfnv = [main instantiateViewControllerWithIdentifier:@"addfriendnotice"];
            [self.navigationController pushViewController:nfnv animated:YES];
        }
    }else{
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactPersonDetailViewController *cpdv = [main instantiateViewControllerWithIdentifier:@"contactpersondetail"];
        cpdv.personJID = dataJID[indexPath.row];
        [self.navigationController pushViewController:cpdv animated:YES];
    }
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = grayBackgroundLightColor;
    headerView.layer.borderColor = lightGrayBackColor.CGColor;
    headerView.layer.borderWidth = 0.5;
    return headerView;
}

#pragma 滑动scrollview取消输入
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
}

@end
