//
//  SendAddMessViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "SendAddMessViewController.h"

@interface SendAddMessViewController ()

{
    BOOL showOrNotBool;//判断是否显示病历等的bool全局变量
}

@end

@implementation SendAddMessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"此界面需要改变一下cell的颜色等");
    _sendMessTable = [[UITableView alloc]init];
    _sendMessTable.delegate = self;
    _sendMessTable.dataSource = self;
    _sendMessTable.backgroundColor = grayBackColor;
    _sendMessTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_sendMessTable];
    [_sendMessTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
//        make.height.equalTo(@180);
        make.bottom.equalTo(@0);
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    showOrNotBool = YES;
    self.title = NSLocalizedString(@"添加好友", @"");
    UIButton *sendMessButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    [sendMessButton setTitle:NSLocalizedString(@"发送", @"") forState:UIControlStateNormal];
    [sendMessButton setTitleColor:themeColor forState:UIControlStateNormal];
    sendMessButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sendMessButton addTarget:self action:@selector(sendAddFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendMessButton]];
}

#pragma 删除好友
-(void)sendAddFriend{
    NSLog(@"发送加好友信息");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"sendMessCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = NSLocalizedString(@"附加验证信息", @"");
        }
            break;
            
        case 1:
        {
            UITextField *inputMess = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, cell.frame.size.width-30, 30)];
            inputMess.center = cell.center;
            inputMess.placeholder = NSLocalizedString(@"请输入验证信息", @"");
            [cell.contentView addSubview:inputMess];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
         
        case 2:
        {
            cell.textLabel.text = NSLocalizedString(@"是否向对方显示你的用药与病历", @"");
        }
            break;
            
        case 3:
        {
            if (showOrNotBool) {
                cell.textLabel.text = NSLocalizedString(@"显示用药与病历信息", @"");
            }else{
                cell.textLabel.text = NSLocalizedString(@"隐藏用药与病历信息", @"");
            }
            cell.textLabel.tag = 1;
            UISwitch *showOrNot = [[UISwitch alloc]init];
            [showOrNot setOn:showOrNotBool];
            [showOrNot addTarget:self action:@selector(changeShowBool:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = showOrNot;
        }
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = grayBackColor.CGColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
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

-(void)changeShowBool:(UISwitch *)sender{
    if (!showOrNotBool) {
        ((UITableViewCell *)sender.superview).textLabel.text = NSLocalizedString(@"显示用药与病历信息", @"");
    }else{
        ((UITableViewCell *)sender.superview).textLabel.text = NSLocalizedString(@"隐藏用药与病历信息", @"");
    }
    showOrNotBool = [sender isOn];
}

@end
