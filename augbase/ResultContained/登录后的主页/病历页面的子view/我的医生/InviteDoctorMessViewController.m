//
//  InviteDoctorMessViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "InviteDoctorMessViewController.h"

@interface InviteDoctorMessViewController ()

@end

@implementation InviteDoctorMessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inviteDoctorTable.delegate = self;
    _inviteDoctorTable.dataSource = self;
    _inviteDoctorTable.tableFooterView = [[UIView alloc]init];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"邀请医生", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }else{
        if (indexPath.row == 0) {
            return 100;
        }else{
            return 60;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"namecell" forIndexPath:indexPath];
            [[cell.contentView viewWithTag:999] becomeFirstResponder];
        }else if(indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"hospitalcell" forIndexPath:indexPath];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"telecell" forIndexPath:indexPath];
        }
    }else{
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"messcontentcell" forIndexPath:indexPath];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"sendmesscell" forIndexPath:indexPath];
            [((UIButton *)[cell viewWithTag:1]) addTarget:self action:@selector(sendMess:) forControlEvents:UIControlEventTouchUpInside];
            [[cell viewWithTag:1] viewWithRadis:10.0];
        }
    }
    return cell;
}

-(void)sendMess:(UIButton *)sender{
    NSLog(@"发送邀请医生信息");
    NSString *docName = ((UITextField *)[_inviteDoctorTable viewWithTag:999]).text;
    NSString *hosName =((UITextField *)[_inviteDoctorTable viewWithTag:998]).text;
    NSString *docTele =((UITextField *)[_inviteDoctorTable viewWithTag:997]).text;
    NSString *userMes =((UITextView *)[_inviteDoctorTable viewWithTag:996]).text;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/toinvite?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (docName != nil) {
        [dic setObject:docName forKey:@"docname"];
    }
    if (hosName != nil) {
        [dic setObject:hosName forKey:@"hospitalname"];
    }
    if (docTele != nil) {
        [dic setObject:docTele forKey:@"tel"];
    }
    if (userMes != nil) {
        [dic setObject:userMes forKey:@"comment"];
    }
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:url Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"邀请成功");
            [self.navigationController popToRootViewControllerAnimated:YES];
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
        sectionTitleText.text = NSLocalizedString(@"医生信息", @"");
    }else{
        sectionTitleText.text = NSLocalizedString(@"填写邀请信息，让医生知道你是谁", @"");
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
