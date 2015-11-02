//
//  OrderTextListViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "OrderTextListViewController.h"

#import "SetupView.h"

@interface OrderTextListViewController ()

{
    NSMutableArray *sourceData;//需要再定义一次可变数组才能移动，坑爹ios,猜测是传递过来的时候可变数组传递成了不可变的。具体原因自己深究
}

@end

@implementation OrderTextListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)setupView{
    self.title = NSLocalizedString(@"指标排序", @"");
    _listTable = [[UITableView alloc]init];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    [_listTable setEditing:YES];
    _listTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_listTable];
    [_listTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(@0);
    }];
}

-(void)setupData{
    sourceData = [NSMutableArray arrayWithArray:_listArray];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *order;
    for (int i = 0;i<sourceData.count;i++){
        if (i == 0) {
            order = sourceData[i];
        }else{
            order = [NSString stringWithFormat:@"%@,%@",order,sourceData[i]];
        }
    }
    NSString *url = [NSString stringWithFormat:@"%@v2/userIndicator/customizedIdsOrder?uid=%@&token=%@&order=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],order];
    [[HttpManager ShareInstance]AFNetPUTSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[userInfo objectForKey:@"res"] intValue];
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma delegate在最下方
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sourceData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"listCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIndentify];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    cell.textLabel.text = [[_listName objectForKey:sourceData[indexPath.row]] objectForKey:@"showname"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [sourceData insertObject:sourceData[sourceIndexPath.row] atIndex:destinationIndexPath.row];
    [sourceData removeObjectAtIndex:sourceIndexPath.row+1];
}

@end
