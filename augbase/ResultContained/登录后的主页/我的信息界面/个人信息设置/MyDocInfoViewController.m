//
//  MyDocInfoViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MyDocInfoViewController.h"

@interface MyDocInfoViewController ()

{
    NSMutableArray *titleArray;//标题数组
}

@end

@implementation MyDocInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"mineSettingCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellIndentify];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    if (indexPath.row == 0) {
        UIImageView *tailImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goin"]];
        UITextField *inputName = [[UITextField alloc]initWithFrame:CGRectMake(ViewWidth-100-40, 10, 100, 30)];
        inputName.placeholder = NSLocalizedString(@"请输入姓名", @"");
        inputName.textAlignment = NSTextAlignmentRight;
        [cell addSubview:inputName];
        cell.accessoryView = tailImageView;
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
//    headerView.layer.borderColor = lightGrayBackColor.CGColor;
//    headerView.layer.borderWidth = 0.5;
//    return headerView;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
//    headerView.backgroundColor = grayBackgroundLightColor;
//    headerView.layer.borderColor = lightGrayBackColor.CGColor;
//    headerView.layer.borderWidth = 0.5;
//    return headerView;
//}

-(void)setupView{
    self.title = NSLocalizedString(@"医生端信息", @"");
    _setDocInfoTable = [[UITableView alloc]init];
    _setDocInfoTable.allowsSelection = NO;
    _setDocInfoTable.backgroundColor = grayBackgroundLightColor;
    _setDocInfoTable.delegate = self;
    _setDocInfoTable.dataSource = self;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    _setDocInfoTable.tableHeaderView = headerView;
    _setDocInfoTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_setDocInfoTable];
    [_setDocInfoTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
}

-(void)setupData{
    titleArray = [@[NSLocalizedString(@"姓名", @"")]mutableCopy];
}

-(void)viewWillDisappear:(BOOL)animated{
    
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
