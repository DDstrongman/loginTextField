//
//  MyGenderViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/19.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "MyGenderViewController.h"

@interface MyGenderViewController ()

@end

@implementation MyGenderViewController

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
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"mineSettingCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIndentify];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"男", @"");
    }else{
        cell.textLabel.text = NSLocalizedString(@"女", @"");
    }
    UIImageView *tailImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goin"]];
    cell.accessoryView = tailImageView;
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/generalInfo?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:NSLocalizedString(@"男", @"")]) {
        [dic setValue:@0 forKey:@"gender"];
    }else{
        [dic setValue:@1 forKey:@"gender"];
    }
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:url Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"修改性别成功");
            [[NSUserDefaults standardUserDefaults] setValue:[dic objectForKey:@"gender"] forKey:@"userGender"];
            [_changeGenderDele changeGender:YES];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)setupView{
    self.title = NSLocalizedString(@"地区", @"");
    _setUserGenderTable = [[UITableView alloc]init];
    _setUserGenderTable.delegate = self;
    _setUserGenderTable.dataSource = self;
    _setUserGenderTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_setUserGenderTable];
    [_setUserGenderTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
}

-(void)setupData{
    
}

@end
