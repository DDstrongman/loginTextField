//
//  SendAddDoctorMessViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "SendAddDoctorMessViewController.h"


@interface SendAddDoctorMessViewController ()

{
    NSString *message;//发送给医生的信息
    NSString *realName;//填写的真实名称
}

@end

@implementation SendAddDoctorMessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sendAddMessTable.delegate = self;
    _sendAddMessTable.dataSource = self;
    
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"验证", @"");
}

-(void)viewWillAppear:(BOOL)animated{
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else{
        if (indexPath.row !=3) {
            return 45;
        }else{
            return 150;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"doctorconfirmcell" forIndexPath:indexPath];
    }else{
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"namecell" forIndexPath:indexPath];
        }else if(indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"sexcell" forIndexPath:indexPath];
        }else if(indexPath.row == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"agecell" forIndexPath:indexPath];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"sendmesscell" forIndexPath:indexPath];
            [((UIButton *)[cell viewWithTag:3]) addTarget:self action:@selector(sendMess:) forControlEvents:UIControlEventTouchUpInside];
            [[cell viewWithTag:3] viewWithRadis:10.0];
        }
    }
    return cell;
}

-(void)sendMess:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"%@v2/user/myDoctor/%@",Baseurl,[_doctorDic objectForKey:@"id"]];
//    uid=1686&token=19a3c2c73bcf94ce3d40ca807c020c5a&nickName=闪电侠&gender=0&age=88&msg=加我咯2
    message = ((UITextView *)[_sendAddMessTable viewWithTag:999]).text;
    realName = ((UITextView *)[_sendAddMessTable viewWithTag:998]).text;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [dic setObject:[user objectForKey:@"userUID"] forKey:@"uid"];
    [dic setObject:[user objectForKey:@"userToken"] forKey:@"token"];
    [dic setObject:realName forKey:@"nickName"];
    [dic setObject:[user objectForKey:@"userGender"] forKey:@"gender"];
    [dic setObject:[user objectForKey:@"userAge"] forKey:@"age"];
    [dic setObject:message forKey:@"msg"];
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:url Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"添加成功");
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 30)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *sectionTitleText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewWidth-10, 22)];
    sectionTitleText.center = CGPointMake(ViewWidth/2, headerView.frame.size.height/2);
    sectionTitleText.font = [UIFont systemFontOfSize:11.0];
    sectionTitleText.textColor = [UIColor blackColor];
    [headerView addSubview:sectionTitleText];
    if (section == 0) {
        sectionTitleText.text = NSLocalizedString(@"验证信息", @"");
    }else{
        sectionTitleText.text = NSLocalizedString(@"填写真实信息，让医生记住你", @"");
    }
    return headerView;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
