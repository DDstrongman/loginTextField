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
#import "InviteDoctorMessViewController.h"
#import "SetupView.h"

@interface AddDoctorListViewController ()

{
    UISearchController *searchViewController;
    NSMutableArray *dataArray;//初始化搜索的数据元数组
    NSMutableArray *searchResults;//搜索结果的数组
}

@end

@implementation AddDoctorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"搜索医生", @"");
#warning 加入网络获取人名的
    dataArray = [@[]mutableCopy];
    searchResults = dataArray;
    
    _addDoctorListTable = [[UITableView alloc]init];
    _addDoctorListTable.delegate = self;
    _addDoctorListTable.dataSource = self;
    _addDoctorListTable.tableFooterView = [[UIView alloc]init];;
    [self.view addSubview:_addDoctorListTable];
    [_addDoctorListTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(@0);
    }];
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = NO;
    searchViewController.hidesNavigationBarDuringPresentation = NO;
    [searchViewController.searchBar sizeToFit];
    [[SetupView ShareInstance] setupSearchbar:searchViewController];
    
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _addDoctorListTable.tableHeaderView = searchViewController.searchBar;
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索列表", @"");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/keywords/%@?uid=%@&token=%@",Baseurl,searchController.searchBar.text,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            searchResults = [source objectForKey:@"matchedDoctors"];
            if (searchResults.count == 0) {
                [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"邀请医生加入易诊", @"") Title:NSLocalizedString(@"您搜索的医生不存在", @"") ViewController:self];
            }
            [_addDoctorListTable reloadData];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma alertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InviteDoctorMessViewController *idmv = [main instantiateViewControllerWithIdentifier:@"invitedoctorview"];
        [self.navigationController pushViewController:idmv animated:YES];
    }else{
        
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchResults.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"searchDoctorCell";
    [_addDoctorListTable registerClass:[MessTableViewCell class]forCellReuseIdentifier:cellIndentify];
    MessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    NSString *url = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/doctor/%@",[searchResults[indexPath.row] objectForKey:@"avatar"]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"test"]];
    cell.iconImageView.backgroundColor = themeColor;
    cell.titleText.text = [searchResults[indexPath.row] objectForKey:@"nickname"];
    if ([searchResults[indexPath.row] objectForKey:@"hosname"] == [NSNull null]) {
        cell.descriptionText.text = @"";
    }else{
        cell.descriptionText.text = [searchResults[indexPath.row] objectForKey:@"hosname"];
    }
    cell.timeText.text = @"18:00";
    
    return cell;
}

#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    MyDoctorDetailViewController *mddv = [[MyDoctorDetailViewController alloc]init];
    mddv.doctorDic = searchResults[indexPath.row];
    [self.navigationController pushViewController:mddv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(void)viewWillDisappear:(BOOL)animated{
    [searchViewController setActive:NO];
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
