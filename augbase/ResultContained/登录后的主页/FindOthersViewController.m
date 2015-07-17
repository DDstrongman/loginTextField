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

@interface FindOthersViewController ()

{
    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
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
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
     _contactsTableview.tableHeaderView = mySearchBar;
    dataArray = [@[@"咨询",@"群组",@"等待验证好友",@"苹果",@"小月",@"小月打飞机",@"小月达飞机",@"小月你好帅！",@"and",@"苹果IOS",@"谷歌android",@"微软",@"微软WP",@"table",@"table",@"table",@"六六",@"六六",@"六六",@"table",@"table",@"table"]mutableCopy];
    [self initNavigationBar];
    [_contactsTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBar.mas_bottom).with.offset(0);
//        make.top.equalTo(@66);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
}

//#pragma 去掉statebar
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

#pragma 因为加入了tabbarcontroller，改变系统的navigationbar出现问题，所以自己写一个navigationbar
-(void)initNavigationBar{
    _navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 22, ViewWidth, 44)];
    _navigationBar.backgroundColor = [UIColor whiteColor];
    //test
    _navigationBar.backgroundColor = themeColor;
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22);
    titleLabel.text = NSLocalizedString(@"发现", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navigationBar addSubview:titleLabel];
    
    //去登陆界面
    UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 30, 30)];
    addFriendButton.center = CGPointMake(ViewWidth-20, 22);
    
    addFriendButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [addFriendButton setImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
    
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    else {
        if (section == 0) {
            return 3;
        }else{
            return dataArray.count-3;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell;
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [UIImage imageNamed:@"icon.jpg"];
        cell.textLabel.text = searchResults[indexPath.row];
        return cell;
    }
    else {
        UITableViewCell *cellContact;
        cellContact = [tableView dequeueReusableCellWithIdentifier:@"contactcell" forIndexPath:indexPath];
        //    [cellContact setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        ((UIImageView *)[cellContact.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
        [((UIImageView *)[cellContact.contentView viewWithTag:1]) imageWithRound];
        ((UILabel *)[cellContact.contentView viewWithTag:2]).text = dataArray[indexPath.row];
        return cellContact;
    }
    
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
        [self.navigationController pushViewController:cpdv animated:YES];
    }
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
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_contactsTableview beginUpdates];
        NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
        // 删除 索引的方法 后面是动画样式
        //        [testArrayDatasource removeObjectAtIndex:indexPath.row];
        [_contactsTableview deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        [_contactsTableview  endUpdates];
    }
    
    // 添加的操作
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        NSArray *indexPaths = @[indexPath];
        [_contactsTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationRight)];
        
    }
    
}

#pragma mark 只有实现这个方法，编辑模式中才允许移动Cell
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 更换数据的顺序
    //    [testArrayDatasource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
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
