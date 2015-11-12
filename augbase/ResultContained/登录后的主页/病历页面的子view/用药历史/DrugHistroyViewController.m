//
//  DrugHistroyViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "DrugHistroyViewController.h"

#import "AddDrugHistoryViewController.h"
#import "ModifyDrugHistoryViewController.h"

@interface DrugHistroyViewController ()<AddDrugSucessDelegate,ModifyDrugSucess>

{
    NSMutableArray *historyDrugArray;//用药历史纪录的数组
    AddDrugHistoryViewController *advc;//传入delegate并加速之后跳转，省掉小部分内存损耗
    ModifyDrugHistoryViewController *mdhv;//同上
    
    BOOL isuse;//是否至今
    UIImageView *backImageView;
    UILabel *remindLabel;
}

@end

@implementation DrugHistroyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)AddDrugSucess:(BOOL)sucess{
    if (sucess) {
        [self setupData];
    }
}

-(void)modifyDrugResult:(BOOL)success{
    if (success) {
        [self setupData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupData];
    UIButton *addDrugButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [addDrugButton setTitle:NSLocalizedString(@"添加", @"") forState:UIControlStateNormal];
    addDrugButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [addDrugButton addTarget:self action:@selector(addDrugHistory:) forControlEvents:UIControlEventTouchUpInside];
    [[SetupView ShareInstance]setupNavigationRightButton:self RightButton:addDrugButton];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return historyDrugArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"diseasecell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentify];
    }
//    cell.textLabel.text = [historyDrugArray[indexPath.row] objectForKey:@"medicinename"];
//    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",[historyDrugArray[indexPath.row] objectForKey:@"begindate"],[historyDrugArray[indexPath.row] objectForKey:@"stopdate"]];
//    cell.detailTextLabel.textColor = grayLabelColor;
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [historyDrugArray[indexPath.row] objectForKey:@"medicinename"];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cell addSubview:titleLabel];
    UILabel *detailLabel = [[UILabel alloc]init];
    if ([[historyDrugArray[indexPath.row] objectForKey:@"isuse"] boolValue]) {
        detailLabel.text = [NSString stringWithFormat:@"%@-%@",[historyDrugArray[indexPath.row] objectForKey:@"begindate"],NSLocalizedString(@"至今", @"")];
    }else{
        detailLabel.text = [NSString stringWithFormat:@"%@-%@",[historyDrugArray[indexPath.row] objectForKey:@"begindate"],[historyDrugArray[indexPath.row] objectForKey:@"stopdate"]];
    }
    detailLabel.textColor = grayLabelColor;
    detailLabel.font = [UIFont systemFontOfSize:12.0];
    [cell addSubview:detailLabel];
    
    
    
    UILabel *tailLabel = [[UILabel alloc]init];
    tailLabel.textAlignment = NSTextAlignmentRight;
    tailLabel.textColor = grayLabelColor;
    tailLabel.font = [UIFont systemFontOfSize:15.0];
    if ([[historyDrugArray[indexPath.row] objectForKey:@"resistant"] intValue] == 0) {
        tailLabel.text = NSLocalizedString(@"不耐药", @"");
    }else{
        tailLabel.text = NSLocalizedString(@"耐药", @"");
    }
    [cell addSubview:tailLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        make.left.equalTo(@15);
        make.right.mas_equalTo(tailLabel.mas_left).with.offset(-5);
        make.height.equalTo(@19);
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(5);
        make.left.equalTo(@15);
        make.right.mas_equalTo(tailLabel.mas_left).with.offset(-5);
        make.height.equalTo(@15);
    }];
    [tailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(@-34);
    }];
    UIImageView *tailImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goin"]];
    [cell addSubview:tailImageView];
    [tailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(@-15);
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    mdhv.drugDic = historyDrugArray[indexPath.row];
    [self.navigationController pushViewController:mdhv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ---edit delete---
//  指定哪一行可以编辑 哪行不能编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//自定义cell的编辑模式，可以是删除也可以是增加 改变左侧的按钮的样式 删除是'-' 增加是'+'
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


// 判断点击按钮的样式 来去做添加 或删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_drugHistroyTable beginUpdates];
        NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
        // 删除 索引的方法 后面是动画样式
        [_drugHistroyTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        [self deleteDrugHistroy:[historyDrugArray[indexPath.row] objectForKey:@"mhid"]];
        [historyDrugArray removeObjectAtIndex:indexPath.row];
        [_drugHistroyTable endUpdates];
    }
}

-(void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"用药历史", @"");
    _drugHistroyTable = [[UITableView alloc]init];
    _drugHistroyTable.delegate = self;
    _drugHistroyTable.dataSource = self;
    _drugHistroyTable.backgroundColor = grayBackgroundLightColor;
    _drugHistroyTable.layer.borderColor = lightGrayBackColor.CGColor;
    _drugHistroyTable.layer.borderWidth = 0.5;
    _drugHistroyTable.separatorColor = lightGrayBackColor;
    _drugHistroyTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_drugHistroyTable];
    [_drugHistroyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(@0);
    }];
    
    advc = [[AddDrugHistoryViewController alloc]init];
    advc.addDrugDelegate = self;
    mdhv = [[ModifyDrugHistoryViewController alloc]init];
    mdhv.modifyDrugSuccess = self;
    
    
    backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_medication_history"]];
    backImageView.tag = 998;//删除用
    [self.view addSubview:backImageView];
    remindLabel = [[UILabel alloc]init];
    remindLabel.tag = 999;
    remindLabel.text = NSLocalizedString(@"暂无用药历史", @"");
    remindLabel.font = [UIFont systemFontOfSize:14.0];
    remindLabel.textColor = grayLabelColor;
    [self.view addSubview:remindLabel];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(-40);
    }];
    [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImageView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view);
    }];
}

-(void)setupData{
    historyDrugArray = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"%@emr/medicinemanagement/list",Baseurl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"],@"1",nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"source",nil]];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSArray *listArray = [source objectForKey:@"list"];
        if (res==0) {
            for (NSDictionary *dic in listArray) {
                [historyDrugArray addObject:dic];
            }
            if (historyDrugArray.count == 0) {
                _drugHistroyTable.hidden = YES;
                backImageView.hidden = NO;
                remindLabel.hidden = NO;
            }else{
                _drugHistroyTable.hidden = NO;
                backImageView.hidden = YES;
                remindLabel.hidden = YES;
                [_drugHistroyTable reloadData];
            }
        }else if (res == 15){
            _drugHistroyTable.hidden = YES;
            backImageView.hidden = NO;
            remindLabel.hidden = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)addDrugHistory:(UIButton *)sender{
    [self.navigationController pushViewController:advc animated:YES];
}

-(void)deleteDrugHistroy:(NSNumber *)mhid{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *yzuid=[user objectForKey:@"userUID"];
    NSString *yztoken=[user objectForKey:@"userToken"];
    NSString *url = [NSString stringWithFormat:@"%@emr/medicinemanagement/delete?uid=%@&token=%@&mhid=%@",Baseurl,yzuid,yztoken,mhid];
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yzuid,yztoken,mhid,nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"mhid",nil]];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"%@",source);
        
        if (res==0) {
            //请求完成
            NSLog(@"删除完成");
            [self setupData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SetupView ShareInstance]setupNavigationRightButton:self RightButton:nil];
}

@end
