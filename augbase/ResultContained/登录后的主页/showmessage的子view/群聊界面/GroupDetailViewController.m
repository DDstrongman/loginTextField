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
    _groupTable.tableFooterView = [[UIView alloc]init];
    _groupTable.backgroundColor = grayBackgroundLightColor;
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"群信息", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
        default:
            return 90;
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
        
        ((UILabel *)[cell.contentView viewWithTag:2]).text = _groupTitle;
        ((UILabel *)[cell.contentView viewWithTag:3]).text = [NSString stringWithFormat:@"群号: %@",_groupJID];
    }else if(indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"groupmembercell" forIndexPath:indexPath];
        ((UILabel *)[cell.contentView viewWithTag:10]).text = NSLocalizedString(@"最近活跃群成员", @"");
        [[cell.contentView viewWithTag:1] imageWithRound:NO];
        [[cell.contentView viewWithTag:2] imageWithRound:NO];
        [[cell.contentView viewWithTag:3] imageWithRound:NO];
        [[cell.contentView viewWithTag:4] imageWithRound:NO];
        [[cell.contentView viewWithTag:5] imageWithRound:NO];
        [[cell.contentView viewWithTag:6] imageWithRound:NO];
        [[cell.contentView viewWithTag:7] imageWithRound:NO];
        [[cell.contentView viewWithTag:8] imageWithRound:NO];
        ((UIImageView *)[cell.contentView viewWithTag:1]).image =  [UIImage imageNamed:@"persontitle1"];
        ((UIImageView *)[cell.contentView viewWithTag:2]).image =  [UIImage imageNamed:@"persontitle2"];
        ((UIImageView *)[cell.contentView viewWithTag:3]).image =  [UIImage imageNamed:@"persontitle3"];
        ((UIImageView *)[cell.contentView viewWithTag:4]).image =  [UIImage imageNamed:@"persontitle5"];
        ((UIImageView *)[cell.contentView viewWithTag:5]).image =  [UIImage imageNamed:@"persontitle6"];
        ((UIImageView *)[cell.contentView viewWithTag:6]).image =  [UIImage imageNamed:@"persontitle7"];
        ((UIImageView *)[cell.contentView viewWithTag:7]).image =  [UIImage imageNamed:@"persontitle8"];
        ((UIImageView *)[cell.contentView viewWithTag:8]).image =  [UIImage imageNamed:@"persontitle9"];
        NSInteger space =(NSInteger)(ViewWidth - 30*2-50*4 - 20)/3;
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
        ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"群描述：", @"");
        ((UILabel *)[cell.contentView viewWithTag:2]).text = _groupNote;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"quitgroupcell" forIndexPath:indexPath];
        [[cell.contentView viewWithTag:1] viewWithRadis:10.0];
        ((UIButton *)[cell.contentView viewWithTag:1]).layer.borderColor = [UIColor orangeColor].CGColor;
        ((UIButton *)[cell.contentView viewWithTag:1]).layer.borderWidth = 0.5;
        [((UIButton *)[cell.contentView viewWithTag:1]) viewWithRadis:10.0];
        [((UIButton *)[cell.contentView viewWithTag:1]) setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(quitGroup:) forControlEvents:UIControlEventTouchUpInside];
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
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

-(void)quitGroup:(UIButton *)sender{
    [[XMPPSupportClass ShareInstance] leaveChatRoom:_groupJID];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
