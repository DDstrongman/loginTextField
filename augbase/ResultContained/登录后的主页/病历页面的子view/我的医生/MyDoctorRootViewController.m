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
#import "ScanQRCodeViewController.h"
#import "PopoverView.h"
#import "RootViewController.h"

@interface MyDoctorRootViewController ()

{
    NSMutableArray *doctorArray;//医生数组
}

@end

@implementation MyDoctorRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的医生", @"");
    
    _showDoctorMessTable = [[UITableView alloc]init];
    _showDoctorMessTable.delegate = self;
    _showDoctorMessTable.dataSource = self;
    _showDoctorMessTable.tableFooterView = [[UIView alloc]init];;
    [self.view addSubview:_showDoctorMessTable];
    [_showDoctorMessTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(@0);
    }];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    _rightPlusButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    [_rightPlusButton setTitle:NSLocalizedString(@"添加", @"") forState:UIControlStateNormal];
    _rightPlusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightPlusButton addTarget:self action:@selector(addDoctor:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightPlusButton]];
}

-(void)setupData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/myDoctor/all?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            doctorArray = [source objectForKey:@"doctorsList"];
            [_showDoctorMessTable reloadData];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)addDoctor:(UIButton *)sender{
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, 66);
    NSArray *titles = @[@"搜索医生", @"扫二维码"];
    NSArray *images = @[@"search3", @"qr_cord2"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:images];
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%d", index);
        if (index == 0) {
            AddDoctorListViewController *adlv = [[AddDoctorListViewController alloc]init];
            [self.navigationController pushViewController:adlv animated:YES];
        }else{
            ScanQRCodeViewController *sqv = [[ScanQRCodeViewController alloc]init];
            [self.navigationController pushViewController:sqv animated:YES];
        }
    };
    [pop show];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return doctorArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    NSString *url = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/doctor/%@",[doctorArray[indexPath.row] objectForKey:@"img"]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"test"]];
    cell.iconImageView.backgroundColor = themeColor;
    cell.titleText.text = [doctorArray[indexPath.row] objectForKey:@"name"];
    cell.descriptionText.text = [doctorArray[indexPath.row] objectForKey:@"lastMsg"];//测试用，以后改为传来的讯息,以下同
    cell.timeText.text = [[doctorArray[indexPath.row] objectForKey:@"latestDate"] stringValue];
    return cell;
}

#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    RootViewController *rvc = [[RootViewController alloc]init];
    rvc.personJID = [doctorArray[indexPath.row] objectForKey:@"jid"];
    [self.navigationController pushViewController:rvc animated:YES];
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

#pragma 取消键盘输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
