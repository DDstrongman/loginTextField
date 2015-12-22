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
    NSMutableArray *similarResults;//相似度的数组
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
    
    BOOL isStranger;//
}

@end

@implementation FindOthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contactsTableview.delegate = self;
    _contactsTableview.dataSource = self;
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = NO;
    searchViewController.hidesNavigationBarDuringPresentation = YES;
    searchViewController.delegate = self;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _contactsTableview.tableHeaderView = searchViewController.searchBar;
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索战友姓名", @"");
    searchViewController.searchBar.backgroundColor = [UIColor whiteColor];
    searchViewController.searchBar.backgroundImage = [UIImage imageNamed:@"white"];
    for (UIView *sb in [[searchViewController.searchBar subviews][0] subviews]) {
        if ([sb isKindOfClass:[UITextField class]]) {
            sb.layer.borderColor = themeColor.CGColor;
            sb.layer.borderWidth = 0.5;
            [sb viewWithRadis:10.0];
        }
    }
//    @"咨询",@"群组",@"等待验证好友",
    titleDataArray = [@[/*NSLocalizedString(@"群组", @""),*/NSLocalizedString(@"等待验证战友", @"")]mutableCopy];
    titleImageNameArray = [@[/*@"groups",*/@"verify_friend"]mutableCopy];
    
    _contactsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _contactsTableview.separatorColor = lightGrayBackColor;
    _contactsTableview.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    _contactsTableview.backgroundColor = grayBackgroundLightColor;
    self.view.backgroundColor = grayBackgroundLightColor;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    self.tabBarController.title = NSLocalizedString(@"战友", @"");
    UIButton *sendMessButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    [sendMessButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    sendMessButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sendMessButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendMessButton]];
    
    UIImage* imageNormal = [UIImage imageNamed:@"contacts_off"];
    UIImage* imageSelected = [UIImage imageNamed:@"contacts_on"];
    self.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[XMPPSupportClass ShareInstance]getMyQueryRoster];
    isStranger = NO;
    FMResultSet *addStrangerList = [[FriendDBManager ShareInstance] SearchAllFriend:StrangerTBName];
    while ([addStrangerList next]) {
        isStranger = YES;
    }
    
    [[XMPPSupportClass ShareInstance]searchGroup:@""];
}

-(void)viewDidAppear:(BOOL)animated{
    [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
    
    NSMutableArray *tableFrindName = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tableFrindDescribe = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tableFrindJID = [NSMutableArray arrayWithCapacity:0];
    similarResults = [NSMutableArray array];
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
        if ([friendList stringForColumn:@"friendSimilarity"]!=[NSNull class]) {
            [similarResults addObject:[NSString stringWithFormat:@"%@ %@",[friendList stringForColumn:@"friendSimilarity"],@"%"]];
        }else{
            [similarResults addObject:[NSString stringWithFormat:@"%@ %@",@"0",@"%"]];
        }
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
    if (searchResults.count == 0) {
        return 1;
    }else{
        return 2;
    }
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"contactcell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (isStranger) {
            ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:titleImageNameArray[indexPath.row]];
        }else{
            ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"verify_friend_no"];
        }
//        [cell.contentView viewWithTag:1].backgroundColor = themeColor;
        ((UILabel *)[cell.contentView viewWithTag:2]).text = titleDataArray[indexPath.row];
        cell.layer.borderColor = lightGrayBackColor.CGColor;
        cell.layer.borderWidth = 0.5;
        [cell.contentView viewWithTag:3].hidden = YES;
    }else{
        int tempI;//搜索的时候的标序
        for (int i=0;i<dataArray.count;i++) {
            if ([dataArray[i] isEqualToString:searchResults[indexPath.row]]) {
                tempI = i;
                break;
            }
        }
        FMResultSet *messPicPath = [[FriendDBManager ShareInstance] SearchOneFriend:YizhenFriendName FriendJID:dataJID[tempI]];
        while ([messPicPath next]) {
            NSString *picPath = [messPicPath stringForColumn:@"friendImageUrl"];
            ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageWithContentsOfFile:picPath];
        }
        NSData *tempData = [[WriteFileSupport ShareInstance]readData:yizhenImageFile FileName:[dataJID[tempI] stringByAppendingString:@".png"]];
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageWithData:tempData];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = searchResults[indexPath.row];
        ((UILabel *)[cell.contentView viewWithTag:3]).text = similarResults[tempI];
        ((UILabel *)[cell.contentView viewWithTag:4]).text = dataDescribe[tempI];
        [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
    }
    return cell;
}
#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0) {
//        if (indexPath.row == 0){
//            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            ContactGroupViewController *cgv = [main instantiateViewControllerWithIdentifier:@"contantgroup"];
//            [self.navigationController pushViewController:cgv animated:YES];
//        }else{
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NewFriendNoticeViewController *nfnv = [main instantiateViewControllerWithIdentifier:@"addfriendnotice"];
            [self.navigationController pushViewController:nfnv animated:YES];
//        }
    }else{
        int tempI;//搜索的时候的标序
        for (int i=0;i<dataArray.count;i++) {
            if ([dataArray[i] isEqualToString:searchResults[indexPath.row]]) {
                tempI = i;
                break;
            }
        }
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactPersonDetailViewController *cpdv = [main instantiateViewControllerWithIdentifier:@"contactpersondetail"];
        cpdv.isJIDOrYizhenID = NO;
        cpdv.friendJID = dataJID[tempI];
        [self.navigationController pushViewController:cpdv animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (searchResults.count == 0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
        footerView.backgroundColor = grayBackgroundLightColor;
        [footerView makeInsetShadowWithRadius:0.5 Color:lightGrayBackColor Directions:[NSArray arrayWithObjects:@"top", nil]];
        return footerView;
    }else{
        if (section == 0) {
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
            footerView.backgroundColor = grayBackgroundLightColor;
            footerView.layer.borderColor = lightGrayBackColor.CGColor;
            footerView.layer.borderWidth = 0.5;
            return footerView;
        }else{
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
            footerView.backgroundColor = grayBackgroundLightColor;
            [footerView makeInsetShadowWithRadius:0.5 Color:lightGrayBackColor Directions:[NSArray arrayWithObjects:@"top", nil]];
            return footerView;
        }
    }
    
    
//    if (searchResults.count == 0&&section == 1) {
//        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
//        headerView.backgroundColor = grayBackgroundLightColor;
//        return headerView;
//    }else{
//        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
//        headerView.backgroundColor = grayBackgroundLightColor;
//        headerView.layer.borderColor = lightGrayBackColor.CGColor;
//        headerView.layer.borderWidth = 0.5;
//        return headerView;
//    }
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
}

-(void)didDismissSearchController:(UISearchController *)searchController{
    
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
    [searchViewController setActive:NO];
    [self.view endEditing:YES];
}

@end
