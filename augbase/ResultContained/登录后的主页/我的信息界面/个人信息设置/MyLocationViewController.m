//
//  MyLocationViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MyLocationViewController.h"

#import "MyLocationSectionViewController.h"

@interface MyLocationViewController ()

{
    NSMutableArray *cityArray;//所有城市的数组
}

@end

@implementation MyLocationViewController

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
    if (cityArray.count>0) {
        return cityArray.count-1;
    }else{
        return 0;
    }
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
    if (cityArray.count>0) {
        cell.textLabel.text = [cityArray[indexPath.row+1] objectForKey:@"name"];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyLocationSectionViewController *msv = [[MyLocationSectionViewController alloc]init];
    msv.popViewController = _popViewController;
    msv.cityName = [cityArray[indexPath.row+1] objectForKey:@"name"];
    msv.sectionArray = [cityArray[indexPath.row+1] objectForKey:@"sub"];
    [self.navigationController pushViewController:msv animated:YES];
}

-(void)setupView{
    self.title = NSLocalizedString(@"地区", @"");
    _locationTable = [[UITableView alloc]init];
    _locationTable.delegate = self;
    _locationTable.dataSource = self;
    _locationTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_locationTable];
    [_locationTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
}

-(void)setupData{
    NSString *url = [NSString stringWithFormat:@"%@v2/wechat/addressDic",Baseurl];
    [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            cityArray = [source objectForKey:@"address"];
            [_locationTable reloadData];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
