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
    _contactsTableview.tableHeaderView = searchViewController.searchBar;
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索列表", @"");
//    @"咨询",@"群组",@"等待验证好友",
    titleDataArray = [@[NSLocalizedString(@"咨询", @""),NSLocalizedString(@"群组", @""),NSLocalizedString(@"等待验证好友", @"")]mutableCopy];
    titleImageNameArray = [@[@"news",@"groups",@"add"]mutableCopy];
//    [_contactsTableview mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(_navigationBar.mas_bottom).with.offset(0);
//        make.top.equalTo(@66);
//        make.bottom.equalTo(@-44);
//        make.left.equalTo(@0);
//        make.right.equalTo(@0);
//    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self initNavigationBar];
    
    UIImage* imageNormal = [UIImage imageNamed:@"contacts_off"];
    UIImage* imageSelected = [UIImage imageNamed:@"contacts_on"];
    self.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
#warning 获取数据库中好友列表
    [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
    NSMutableArray *tableFrindName = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tableFrindDescribe = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tableFrindJID = [NSMutableArray arrayWithCapacity:0];
    [[FriendDBManager ShareInstance] isFriendTableExist:YizhenFriendName];
    FMResultSet *friendList = [[FriendDBManager ShareInstance] SearchAllFriend:YizhenFriendName];
    
#warning 此处需要加入通过jid判断用户name的网络需求
    while ([friendList next]) {
        [tableFrindDescribe addObject:[friendList stringForColumn:@"friendDescribe"]];
        [tableFrindName addObject:[friendList stringForColumn:@"friendName"]];
        [tableFrindJID addObject:[friendList stringForColumn:@"friendJID"]];
    }
    
    dataArray = [[NSMutableArray alloc]initWithArray:tableFrindName];
    dataDescribe = [[NSMutableArray alloc]initWithArray:tableFrindDescribe];
    dataJID = [[NSMutableArray alloc]initWithArray:tableFrindJID];
    searchResults = dataArray;
    [_contactsTableview reloadData];
//    [self initNavigationBar];
}

#pragma 因为加入了tabbarcontroller，改变系统的navigationbar出现问题，所以自己写一个navigationbar
-(void)initNavigationBar{
    _navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 66)];
    _navigationBar.backgroundColor = themeColor;
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22+22);
    titleLabel.text = NSLocalizedString(@"发现", @"");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navigationBar addSubview:titleLabel];
    
    //去登陆界面
    UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 30, 30)];
    addFriendButton.center = CGPointMake(ViewWidth-20, 22+22);
    
    addFriendButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [addFriendButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    [addFriendButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:addFriendButton];
    [self.view addSubview:_navigationBar];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
        if (indexPath.row == 0) {
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ContactNewsViewController *cnv = [main instantiateViewControllerWithIdentifier:@"contactnews"];
            [self.navigationController pushViewController:cnv animated:YES];
//            ContactNewsViewController *cnv = [[ContactNewsViewController alloc]init];
//            [self.navigationController pushViewController:cnv animated:YES];
        }else if (indexPath.row == 1){
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

#pragma searchbar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self doSearch:searchBar];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self doSearch:searchBar];
}

-(void)searchBartextDidChange:(UISearchBar *)searchBar{
    
}


- (void)doSearch:(UISearchBar *)searchBar{
    NSLog(@"搜索开始");
}

#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchResults = [[NSMutableArray alloc]init];
    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i<dataArray.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:dataArray[i]]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:dataArray[i]];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:dataArray[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
            }
            else {
                NSRange titleResult=[dataArray[i] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (NSString *tempStr in dataArray) {
            NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tempStr];
            }
        }
    }
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
    return nil;
}

#pragma 滑动scrollview取消输入
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
