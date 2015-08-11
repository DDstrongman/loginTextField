//
//  MyDoctorRootViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MyDoctorRootViewController.h"
#import "MessTableViewCell.h"

#import "AddDoctorListViewController.h"
#import "PopoverView.h"
#import "RootViewController.h"

@interface MyDoctorRootViewController ()

{
    UISearchBar *mySearchBar;
    UISearchController *searchViewController;
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *searchResults;//搜索结果的数组
    
//    UIView *popView;//没找到医生时候冒出来的view
}

@end

@implementation MyDoctorRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"我的医生", @"");
    
    dataArray = [@[NSLocalizedString(@"小易助手", @"")]mutableCopy];
    searchResults = dataArray;
    
    _showDoctorMessTable = [[UITableView alloc]init];
    _showDoctorMessTable.delegate = self;
    _showDoctorMessTable.dataSource = self;
    _showDoctorMessTable.tableFooterView = [[UIView alloc]init];;
    [self.view addSubview:_showDoctorMessTable];
    NSNumber *tableHeight = [NSNumber numberWithInteger:(70*[dataArray count]+40)];
    [_showDoctorMessTable mas_makeConstraints:^(MASConstraintMaker *make) {
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
    _showDoctorMessTable.tableHeaderView = searchViewController.searchBar;
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索列表", @"");
    
//    popView = [[UIView alloc]initWithFrame:CGRectMake(ViewWidth, 40, ViewWidth, ViewHeight-66-40)];
//    popView.backgroundColor = themeColor;
//    [self.view addSubview:popView];
}

-(void)viewWillAppear:(BOOL)animated{
    _rightPlusButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    [_rightPlusButton setTitle:NSLocalizedString(@"添加", @"") forState:UIControlStateNormal];
//    [_rightPlusButton setTitleColor:themeColor forState:UIControlStateNormal];
    _rightPlusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightPlusButton addTarget:self action:@selector(addDoctor:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightPlusButton]];
}

-(void)addDoctor:(UIButton *)sender{
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, 66);
    NSArray *titles = @[@"搜索医生", @"扫二维码"];
    NSArray *images = @[@"test", @"test"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:images];
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%d", index);
        if (index == 0) {
            AddDoctorListViewController *adlv = [[AddDoctorListViewController alloc]init];
            [self.navigationController pushViewController:adlv animated:YES];
        }
    };
    [pop show];
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //谓词检测
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@", searchController.searchBar.text];
    if ([searchController.searchBar.text isEqualToString:@""]){
        searchResults = dataArray;
        [_showDoctorMessTable reloadData];
        
    }else{
        //将所有和搜索有关的内容存储到arr数组
        searchResults = [NSMutableArray arrayWithArray:
                         [dataArray filteredArrayUsingPredicate:predicate]];
        //重新加载数据
        [_showDoctorMessTable reloadData];
    }
#warning 弹出没有找到医生的view的代码
//    if ([searchResults count] == 0) {
//        POPSpringAnimation *anim = [POPSpringAnimation animation];
//        anim.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
//        
//        anim.toValue = [NSValue valueWithCGRect:CGRectMake(ViewWidth/2,popView.frame.origin.y+popView.frame.size.height/2,ViewWidth,ViewHeight-66-40)];
//        anim.springBounciness = 5.0;
//        anim.springSpeed = 10;
//        
//        anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//            if (finished) {
//                
//            }
//        };
//        
//        [popView pop_addAnimation:anim forKey:@"slider"];
//    }else{
//        POPSpringAnimation *anim = [POPSpringAnimation animation];
//        anim.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
//        
//        anim.toValue = [NSValue valueWithCGRect:CGRectMake(ViewWidth/2*3,popView.frame.origin.y+popView.frame.size.height/2,ViewWidth,ViewHeight-66-40)];
//        anim.springBounciness = 5.0;
//        anim.springSpeed = 10;
//        
//        anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//            if (finished) {
//                
//            }
//        };
//        
//        [popView pop_addAnimation:anim forKey:@"slider"];
//    }
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
    [_showDoctorMessTable registerClass:[MessTableViewCell class]forCellReuseIdentifier:cellIndentify];
    MessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    NSLog(@"加入网络获取小易收到的信息，并刷新到界面中");
#warning 此处的信息需要网络获取并同步
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
    if (indexPath.row == 0) {
        RootViewController *rvc = [[RootViewController alloc]init];
        [self.navigationController pushViewController:rvc animated:YES];
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

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

#pragma 取消键盘输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
