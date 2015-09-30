//
//  ConfirmDiseaseRootViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/6.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ConfirmDiseaseRootViewController.h"

#import "CurrentDiseaseViewController.h"
#import "HistoryDiseaseViewController.h"
#import "VirusCategoryViewController.h"

@interface ConfirmDiseaseRootViewController ()<CurrentDiseaseDelegate,HistoryDiseaseDelegate,VirusCategoryDelegate>

{
    NSMutableArray *titleArray;//疾病界面的标题数组
    NSMutableArray *detailArray;//患病的显示数组
}

@end

@implementation ConfirmDiseaseRootViewController

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
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"diseasecell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentify];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    cell.detailTextLabel.text = detailArray[indexPath.row];
    UIImageView *tailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    tailImageView.image = [UIImage imageNamed:@"goin"];
    cell.accessoryView = tailImageView;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.row == 0) {
        CurrentDiseaseViewController *cdvc = [[CurrentDiseaseViewController alloc]init];
        cdvc.currentDele = self;
        [self.navigationController pushViewController:cdvc animated:YES];
    }else if (indexPath.row == 1){
        HistoryDiseaseViewController *hdvc = [[HistoryDiseaseViewController alloc]init];
        hdvc.hisDele = self;
        [self.navigationController pushViewController:hdvc animated:YES];
    }else{
        VirusCategoryViewController *vcvc = [[VirusCategoryViewController alloc]init];
        vcvc.virusDele = self;
        [self.navigationController pushViewController:vcvc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setupView{
    self.title = NSLocalizedString(@"确诊疾病", @"");
    _confirmDiseaseTable = [[UITableView alloc]init];
    _confirmDiseaseTable.delegate = self;
    _confirmDiseaseTable.dataSource = self;
    _confirmDiseaseTable.backgroundColor = grayBackgroundLightColor;
    _confirmDiseaseTable.layer.borderColor = lightGrayBackColor.CGColor;
    _confirmDiseaseTable.layer.borderWidth = 0.5;
    _confirmDiseaseTable.separatorColor = lightGrayBackColor;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    _confirmDiseaseTable.tableFooterView = [[UIView alloc]init];
    _confirmDiseaseTable.tableHeaderView = headerView;
    [self.view addSubview:_confirmDiseaseTable];
    [_confirmDiseaseTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(@0);
    }];
}

-(void)setupData{
    titleArray = [@[NSLocalizedString(@"当前疾病", @""),NSLocalizedString(@"病史", @""),NSLocalizedString(@"病毒基因型", @"")]mutableCopy];
    detailArray = [@[NSLocalizedString(@"当前疾病", @""),NSLocalizedString(@"病史", @""),NSLocalizedString(@"病毒基因型", @"")]mutableCopy];
    NSLog(@"确诊疾病的url===%@",[NSString stringWithFormat:@"%@und/list?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]]);
    [[HttpManager ShareInstance] AFNetGETSupport:[NSString stringWithFormat:@"%@und/list?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]] Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSArray *disListArray = [source objectForKey:@"disList"];
            NSArray *disHisListArray = [source objectForKey:@"disHisList"];
            NSArray *virusListArray = [source objectForKey:@"virusList"];
            if (disListArray.count == 0) {
                [detailArray replaceObjectAtIndex:0 withObject:@""];
            }else if(disListArray.count == 1){
                [detailArray replaceObjectAtIndex:0 withObject:[disListArray[0] objectForKey:@"name"]];
            }else{
                [detailArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@...",[disListArray[disListArray.count-1] objectForKey:@"name"]]];
            }
            if (disHisListArray.count == 0) {
                [detailArray replaceObjectAtIndex:1 withObject:@""];
            }else if(disHisListArray.count == 1){
                [detailArray replaceObjectAtIndex:1 withObject:[disHisListArray[0] objectForKey:@"name"]];
            }else{
                [detailArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@...",[disHisListArray[disHisListArray.count-1] objectForKey:@"name"]]];
            }
            if (virusListArray.count == 0) {
                [detailArray replaceObjectAtIndex:2 withObject:@""];
            }else if(virusListArray.count == 1){
                [detailArray replaceObjectAtIndex:2 withObject:[virusListArray[0] objectForKey:@"name"]];
            }else{
                [detailArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@...",[virusListArray[virusListArray.count-1] objectForKey:@"name"]]];
            }
        }else{
            UIAlertView *showMess = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"网络错误", @"") message:NSLocalizedString(@"请检查您的网络", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
            [showMess show];
        }
        [_confirmDiseaseTable reloadData];
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)currentDiseaseDelegate:(BOOL)result{
    if (result) {
        [self setupData];
    }
}

-(void)historyDiseaseDelegate:(BOOL)result{
    if (result) {
        [self setupData];
    }
}

-(void)virusCategoryDelegate:(BOOL)result{
    if (result) {
        [self setupData];
    }
}

@end
