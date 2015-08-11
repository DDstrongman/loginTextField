//
//  ContactGroupDetailViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ContactGroupDetailViewController.h"

@interface ContactGroupDetailViewController ()

@end

@implementation ContactGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contactGroupDetailTable.delegate = self;
    _contactGroupDetailTable.dataSource = self;
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"群信息", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 95;
            break;
            
        case 1:
            return 185;
            break;
            
        case 2:
            return 100;
            break;
            
        case 3:
            return 90;
            break;
            
        default:
            return 45;
            break;
    }

}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"titlecell" forIndexPath:indexPath];
        [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
    }else if (indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"groupmembercell" forIndexPath:indexPath];
        ((UILabel *)[cell.contentView viewWithTag:10]).text = NSLocalizedString(@"群成员", @"");
        [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
        [((UIImageView *)[cell.contentView viewWithTag:2]) imageWithRound];
        [((UIImageView *)[cell.contentView viewWithTag:3]) imageWithRound];
        [((UIImageView *)[cell.contentView viewWithTag:4]) imageWithRound];
        [((UIImageView *)[cell.contentView viewWithTag:5]) imageWithRound];
        [((UIImageView *)[cell.contentView viewWithTag:6]) imageWithRound];
        [((UIImageView *)[cell.contentView viewWithTag:7]) imageWithRound];
        [((UIImageView *)[cell.contentView viewWithTag:8]) imageWithRound];
        NSInteger space =(NSInteger)(ViewWidth - 30*2-50*4 - 20)/3;
        NSLog(@"space === %ld",(long)space);
        [[cell.contentView viewWithTag:2] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([cell.contentView viewWithTag:1].mas_right).with.offset(space);
        }];
        [[cell.contentView viewWithTag:3] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([cell.contentView viewWithTag:2].mas_right).with.offset(space);
        }];
        [[cell.contentView viewWithTag:4] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([cell.contentView viewWithTag:3].mas_right).with.offset(space);
        }];
        [[cell.contentView viewWithTag:6] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([cell.contentView viewWithTag:5].mas_right).with.offset(space);
        }];
        [[cell.contentView viewWithTag:7] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([cell.contentView viewWithTag:6].mas_right).with.offset(space);
        }];
        [[cell.contentView viewWithTag:8] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([cell.contentView viewWithTag:7].mas_right).with.offset(space);
        }];
        UIImageView *tailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
        tailImageView.image = [UIImage imageNamed:@"goin"];
        cell.accessoryView = tailImageView;

    }else if (indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"describcell" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"jiongroupcell" forIndexPath:indexPath];
    }
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:@"icon.jpg"];
//    ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"上海大三阳战友群", @"");
    //    [((UIButton *)[cell.contentView viewWithTag:6]) addTarget:self action:@selector(jionGroup:) forControlEvents:UIControlEventTouchUpInside];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return cell;
}

#pragma 添加加为好友的函数,获取对应的cell可以通过sender.superview来获取
-(void)jionGroup:(UIButton *)sender{
    //    NSLog(@"加上加为好友的响应函数，网络通讯");
    //    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    StrangerViewController *svc = [main instantiateViewControllerWithIdentifier:@"stranger"];
    //    [self.navigationController pushViewController:svc animated:YES];
}

-(void)addFriendYes{
    NSLog(@"加上同意加为好友的响应函数，网络通讯");
    //    boolAddArray[0] = YES;
    //    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    AddFriendConfirmViewController *afcv = [main instantiateViewControllerWithIdentifier:@"addfriendconfirmdetail"];
    //    [self.navigationController pushViewController:afcv animated:YES];
}

#pragma 需要加上cell的群消息判断，cell可根据［uitableview cellforindex］获取
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.row == 1) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactGroupMemberDetailViewController *cgmv = [main instantiateViewControllerWithIdentifier:@"contactgroupmemberdetail"];
        [self.navigationController pushViewController:cgmv animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
////    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
////    headerView.backgroundColor = [UIColor lightGrayColor];
////    return headerView;
//}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

@end
