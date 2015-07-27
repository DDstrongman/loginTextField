//
//  GroupDetailViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "GroupDetailViewController.h"

@interface GroupDetailViewController ()

@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _groupTable.delegate = self;
    _groupTable.dataSource = self;
    _groupTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _groupTable.backgroundColor = grayBackColor;
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"群信息", @"");
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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
            
        case 5:
            return 90;
            break;
            
        default:
            return 45;
            break;
    }
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"setGroupCell";
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"titlecell" forIndexPath:indexPath];
        [[cell.contentView viewWithTag:1] imageWithRound:NO];
        
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"小月达尔比", @"");
        ((UILabel *)[cell.contentView viewWithTag:3]).text = NSLocalizedString(@"小月达尔比", @"");
    }else if(indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"groupmembercell" forIndexPath:indexPath];
        ((UILabel *)[cell.contentView viewWithTag:10]).text = NSLocalizedString(@"群成员", @"");
        [[cell.contentView viewWithTag:1] imageWithRound:NO];
        [[cell.contentView viewWithTag:2] imageWithRound:NO];
        [[cell.contentView viewWithTag:3] imageWithRound:NO];
        [[cell.contentView viewWithTag:4] imageWithRound:NO];
        [[cell.contentView viewWithTag:5] imageWithRound:NO];
        [[cell.contentView viewWithTag:6] imageWithRound:NO];
        [[cell.contentView viewWithTag:7] imageWithRound:NO];
        [[cell.contentView viewWithTag:8] imageWithRound:NO];
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
    }else if(indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"describcell" forIndexPath:indexPath];
    }else if(indexPath.row == 5){
        cell = [tableView dequeueReusableCellWithIdentifier:@"quitgroupcell" forIndexPath:indexPath];
    }else{
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = grayBackColor.CGColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.row == 1) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GroupMemberViewController *gmv = [main instantiateViewControllerWithIdentifier:@"groupmemberdetail"];
        [self.navigationController pushViewController:gmv animated:YES];
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

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

@end
