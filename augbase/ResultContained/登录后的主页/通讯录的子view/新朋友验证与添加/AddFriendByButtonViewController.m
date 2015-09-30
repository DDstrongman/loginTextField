//
//  AddFriendByButtonViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "AddFriendByButtonViewController.h"

#import "ContactPersonDetailViewController.h"
#import "SetupView.h"

@interface AddFriendByButtonViewController ()

{
    NSMutableArray *titleArray;//添加好友方式的数组
    NSMutableArray *imageArray;//存对应的方式的icon的数组
}

@end

@implementation AddFriendByButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"添加好友", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchcell" forIndexPath:indexPath];
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:imageArray[indexPath.row]];
        ((UITextField *)[cell viewWithTag:2]).placeholder = titleArray[indexPath.row];
        ((UITextField *)[cell viewWithTag:2]).returnKeyType = UIReturnKeySearch;
        ((UITextField *)[cell viewWithTag:2]).delegate = self;
    }else if (indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"myinfocell" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:1]).text = [NSString stringWithFormat:@"%@%@",titleArray[indexPath.row],[[NSUserDefaults standardUserDefaults] objectForKey:@"userJID"]];
        ((UILabel *)[cell viewWithTag:1]).font = [UIFont systemFontOfSize:14.0];
        cell.backgroundColor = grayBackColor;
        cell.layer.borderColor = lightGrayBackColor.CGColor;
        cell.layer.borderWidth = 0.5;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"imageandlabelcell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:imageArray[indexPath.row]];
        //    [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = titleArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.row == 2) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SimilarFriendViewController *sfv = [main instantiateViewControllerWithIdentifier:@"similarfriend"];
        [self.navigationController pushViewController:sfv animated:YES];
    }else if(indexPath.row == 3){
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NearByFriendViewController *nfv = [main instantiateViewControllerWithIdentifier:@"nearbyfriend"];
        [self.navigationController pushViewController:nfv animated:YES];
    }else if (indexPath.row == 4){
        
    }else if(indexPath.row == 5){
        
    }else{
        
    }
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
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

#pragma viewdidload等中初始化的方法写在这里
-(void)setupView{
    self.view.backgroundColor = grayBackColor;
    _addWaysTable.backgroundColor = grayBackColor;
    _addWaysTable.dataSource = self;
    _addWaysTable.delegate = self;
    _addWaysTable.tableFooterView = [[UIView alloc]init];
}

-(void)setupData{
    titleArray = [@[NSLocalizedString(@"易诊号", @""),NSLocalizedString(@"我的易诊号:", @""),NSLocalizedString(@"相似好友", @""),NSLocalizedString(@"附近好友", @""),NSLocalizedString(@"邀请QQ好友", @""),NSLocalizedString(@"邀请微信好友", @"")]mutableCopy];
    imageArray = [@[@"similar",@"",@"similar",@"neighborhood",@"qq",@"wechat2"]mutableCopy];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if ([textField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userJID"]]) {
        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"不能搜索自己", @"") Title:NSLocalizedString(@"您搜索了自己", @"") ViewController:self];
    }else{
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactPersonDetailViewController *cpdv = [main instantiateViewControllerWithIdentifier:@"contactpersondetail"];
        cpdv.friendJID = textField.text;
        [self.navigationController pushViewController:cpdv animated:YES];
    }
    return YES;
}


#pragma 取消键盘输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
