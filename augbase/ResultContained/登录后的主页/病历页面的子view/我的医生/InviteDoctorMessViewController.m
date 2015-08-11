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
    
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"邀请医生", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
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
        }else{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"hospitalcell" forIndexPath:indexPath];
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
}

#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma cell滑入的动画效果
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    cell.frame = CGRectMake(-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    //    [UIView animateWithDuration:0.7 animations:^{
    //        cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    //    } completion:^(BOOL finished) {
    //        ;
    //    }];
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

@end
