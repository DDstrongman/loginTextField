//
//  ShowAllMessageViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ShowAllMessageViewController.h"

@interface ShowAllMessageViewController ()

{
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *titleDataArray;//官方提供的选项的名称数组
    NSMutableArray *searchResults;//搜索结果的数组
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
}

@end

@implementation ShowAllMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageTableview.delegate = self;
    _messageTableview.dataSource = self;
//    _messageTableview.frame = CGRectMake(0, 0, ViewWidth, ViewHeight-44-44);
    
//    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40)];
//    mySearchBar.delegate = self;
//    [mySearchBar setPlaceholder:@"搜索列表"];
    
//    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
//    searchDisplayController.active = NO;
//    searchDisplayController.searchResultsDataSource = self;
//    searchDisplayController.searchResultsDelegate = self;
    
//    _messageTableview.tableHeaderView = mySearchBar;
    
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = NO;
    searchViewController.hidesNavigationBarDuringPresentation = NO;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _messageTableview.tableHeaderView = searchViewController.searchBar;
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索列表", @"");
    titleDataArray = [@[NSLocalizedString(@"群助手", @""),NSLocalizedString(@"咨讯", @""),NSLocalizedString(@"我的医生", @"")]mutableCopy];
    dataArray = [@[@"百度",@"六六",@"谷歌",@"苹果"]mutableCopy];
    if (!searchResults) {
        searchResults = dataArray;
    }
    
}

//#pragma 去掉statebar
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
//    self.navigationItem.title = @"test";
    [self initNavigationBar];
}

#pragma 因为加入了tabbarcontroller，改变系统的navigationbar出现问题，所以自己写一个navigationbar
-(void)initNavigationBar{
    UIView *navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 22, ViewWidth, 44)];
//    navigationBar.layer.borderWidth = 0.5;
//    navigationBar.layer.borderColor = themeColor.CGColor;
    navigationBar.backgroundColor = themeColor;
    
//    //左侧头像按钮，点击打开用户相关选项
//    UIButton *userButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 30, 30)];
//    userButton.center = CGPointMake(20, 22);
//    
//    userButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
//    [userButton setImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
//    
//    [userButton addTarget:self action:@selector(openUser) forControlEvents:UIControlEventTouchUpInside];
//    
//    [navigationBar addSubview:userButton];
    
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22);
    titleLabel.text = NSLocalizedString(@"消息", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    
//    //去登陆界面
//    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 30, 30)];
//    cameraButton.center = CGPointMake(ViewWidth-20, 22);
//    
//    cameraButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
//    [cameraButton setImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
//    
//    [cameraButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
//    //    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
//    [navigationBar addSubview:cameraButton];
    
    [self.view addSubview:navigationBar];
}

#pragma 打开用户相关界面，左侧抽屉显示，view暂时未做
-(void)openUser{
    NSLog(@"打开用户界面");
//    if(!showUserView){
//        POPSpringAnimation *popOutAnimation = [POPSpringAnimation animation];
//        popOutAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
//        if (YES) {
//            popOutAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 44, ViewWidth/2,ViewHeight-44)];
//        }
//
//        popOutAnimation.velocity = [NSValue valueWithCGRect:userView.frame];
//        popOutAnimation.springBounciness = 5.0;
//        popOutAnimation.springSpeed = 8.0;
//
//        [userView pop_addAnimation:popOutAnimation forKey:@"slide"];
//        showUserView = YES;
//    }else{
//        POPSpringAnimation *popOutAnimation = [POPSpringAnimation animation];
//        popOutAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
//        if (YES) {
//            popOutAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(-ViewWidth/2, 44, ViewWidth/2,ViewHeight-44)];
//        }
//        
//        popOutAnimation.velocity = [NSValue valueWithCGRect:userView.frame];
//        popOutAnimation.springBounciness = 5.0;
//        popOutAnimation.springSpeed = 8.0;
//        
//        [userView pop_addAnimation:popOutAnimation forKey:@"slide"];
//        showUserView = NO;
//    }
}

#pragma 打开cameraview拍摄化验单等,cameraview已写好
-(void)openCamera{
    NSLog(@"打开拍照界面");
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //谓词检测
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@", searchController.searchBar.text];
    if ([searchController.searchBar.text isEqualToString:@""]){
        searchResults = dataArray;
        [_messageTableview reloadData];
    }else{
        //将所有和搜索有关的内容存储到arr数组
        searchResults = [NSMutableArray arrayWithArray:
                         [dataArray filteredArrayUsingPredicate:predicate]];
        //重新加载数据
        [_messageTableview reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSLog(@"此处隐藏了我的医生一栏，以后需要加入,即将2变为3");
#warning 此处隐藏了我的医生一栏，以后需要加入,即将2变为3
        return titleDataArray.count-1;//隐藏了我的医生一栏，以后需要加入
    }else{
        return searchResults.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"showMessCell";
    [_messageTableview registerClass:[MessTableViewCell class]forCellReuseIdentifier:cellIndentify];
    MessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                cell.iconImageView.image = [UIImage imageNamed:@"groups"];
                cell.iconImageView.backgroundColor = themeColor;
                cell.titleText.text = titleDataArray[indexPath.row];
                cell.descriptionText.text = NSLocalizedString(@"小月你又打飞机", @"");//测试用，以后改为传来的讯息,以下同
                cell.timeText.text = @"18:00";
            }
                break;
            case 1:{
                cell.iconImageView.image = [UIImage imageNamed:@"news"];
                cell.iconImageView.backgroundColor = [UIColor yellowColor];
                cell.titleText.text = NSLocalizedString(@"咨讯", @"");
                cell.descriptionText.text = @"小月你又打飞机";
                cell.timeText.text = @"18:00";
            }
            default:
                break;
        }
    }else{
        cell.iconImageView.image = [UIImage imageNamed:@"test"];
        cell.titleText.text = searchResults[indexPath.row];
        cell.descriptionText.text = @"小月你又打飞机";
        cell.timeText.text = @"18:00";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0&&indexPath.row == 0) {
        ChooseGroupViewController *cgv = [[ChooseGroupViewController alloc]init];
        [self.navigationController pushViewController:cgv animated:YES];
    }else if(indexPath.section == 0&&indexPath.row == 1){
        HACollectionViewSmallLayout *smallLayout = [[HACollectionViewSmallLayout alloc] init];
        HASmallCollectionViewController *collectionViewController = [[HASmallCollectionViewController alloc] initWithCollectionViewLayout:smallLayout];
        
        self.transitionController = [[HATransitionController alloc] initWithCollectionView:collectionViewController.collectionView];
        self.transitionController.delegate = self;
        [self.navigationController pushViewController:collectionViewController animated:YES];
        
    }else if(indexPath.section == 0&&indexPath.row == 2){
        
    }else{
        RootViewController *rtv = [[RootViewController alloc]init];
        rtv.privateOrNot = 0;//私聊
        
        [self.navigationController pushViewController:rtv animated:YES];
    }
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
        [_messageTableview beginUpdates];
        NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
        // 删除 索引的方法 后面是动画样式
//        [testArrayDatasource removeObjectAtIndex:indexPath.row];
        [_messageTableview deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        [_messageTableview  endUpdates];
    }
    
    // 添加的操作
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        NSArray *indexPaths = @[indexPath];
        [_messageTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationRight)];
        
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

- (void)interactionBeganAtPoint:(CGPoint)point
{
    // Very basic communication between the transition controller and the top view controller
    // It would be easy to add more control, support pop, push or no-op
    HASmallCollectionViewController *presentingVC = (HASmallCollectionViewController *)[self.navigationController topViewController];
    HASmallCollectionViewController *presentedVC = (HASmallCollectionViewController *)[presentingVC nextViewControllerAtPoint:point];
    if (presentedVC!=nil)
    {
        [self.navigationController pushViewController:presentedVC animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (animationController==self.transitionController) {
        return self.transitionController;
    }
    return nil;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (![fromVC isKindOfClass:[UICollectionViewController class]] || ![toVC isKindOfClass:[UICollectionViewController class]])
    {
        return nil;
    }
    if (!self.transitionController.hasActiveInteraction)
    {
        return nil;
    }
    
    self.transitionController.navigationOperation = operation;
    return self.transitionController;
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
