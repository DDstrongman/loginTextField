//
//  GroupMemberViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "ContactPersonDetailViewController.h"

@interface GroupMemberViewController ()

{
    NSMutableArray *memberJIDArray;//存储群成员的数组
    NSMutableArray *memberDataArray;//存网络获取的成员信息
}

@end

@implementation GroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}
-(void)viewWillAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"成员信息", @"");
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+memberDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 97;
}

#pragma 返回cell，重复利用一个
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"setGroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupmembercell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [((UIButton *)[cell.contentView viewWithTag:7]) addTarget:self action:@selector(addFriendByMember:) forControlEvents:UIControlEventTouchUpInside];
    cell.tag = indexPath.row;
    [[cell.contentView viewWithTag:1] imageWithRound:NO];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [[cell.contentView viewWithTag:7] viewWithRadis:1.0];
    if (indexPath.row == 0) {
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageWithContentsOfFile:[user objectForKey:@"userImageUrl"]];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = [user objectForKey:@"userNickName"];
        if ([user objectForKey:@"userNickName"] != nil) {
            CGSize titleSize = [self getWidth:[user objectForKey:@"userNickName"]];
            NSNumber *titleWidth = [NSNumber numberWithDouble:titleSize.width];
            [[cell.contentView viewWithTag:2] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(titleWidth);
            }];
        }
        if ([[user objectForKey:@"userGender"] intValue] == 0) {
            ((UILabel *)[cell.contentView viewWithTag:3]).text = [NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"男", @""),[user objectForKey:@"userAge"]];
        }else{
            ((UILabel *)[cell.contentView viewWithTag:3]).text = [NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"女", @""),[user objectForKey:@"userAge"]];
        }
        [cell.contentView viewWithTag:7].hidden = YES;
        [((UIButton *)[cell.contentView viewWithTag:4]) setTitle:[user objectForKey:@"userAddress"] forState:UIControlStateNormal];
        ((UILabel *)[cell.contentView viewWithTag:5]).text = [user objectForKey:@"userNote"];
        ((UILabel *)[cell.contentView viewWithTag:6]).text = NSLocalizedString(@"100%", @"");
    }else{
        [cell.contentView viewWithTag:7].hidden = NO;
        NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[memberDataArray[indexPath.row-1] objectForKey:@"picture"]];
        [((UIImageView *)[cell.contentView viewWithTag:1]) sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"test"]];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = [memberDataArray[indexPath.row-1] objectForKey:@"nickname"];
        if ([memberDataArray[indexPath.row-1] objectForKey:@"nickname"] != nil) {
            CGSize titleSize = [self getWidth:[memberDataArray[indexPath.row-1] objectForKey:@"nickname"]];
            NSNumber *titleWidth = [NSNumber numberWithDouble:titleSize.width];
            [[cell.contentView viewWithTag:2] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(titleWidth);
            }];
        }
        
        
        if ([[memberDataArray[indexPath.row-1] objectForKey:@"gender"] intValue] == 0) {
            ((UILabel *)[cell.contentView viewWithTag:3]).text = [NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"男", @""),[[memberDataArray[indexPath.row-1] objectForKey:@"age"] stringValue]];
        }else{
            ((UILabel *)[cell.contentView viewWithTag:3]).text = [NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"女", @""),[[memberDataArray[indexPath.row-1] objectForKey:@"age"] stringValue]];
        }
        if ([memberDataArray[indexPath.row-1] objectForKey:@"address"] != [NSNull class]) {
            [((UIButton *)[cell.contentView viewWithTag:4]) setTitle:[memberDataArray[indexPath.row-1] objectForKey:@"address"] forState:UIControlStateNormal];
        }
        if ([memberDataArray[indexPath.row-1] objectForKey:@"introduction"] != [NSNull class]) {
            if ([[memberDataArray[indexPath.row-1] objectForKey:@"introduction"] isEqualToString:@""]) {
                ((UILabel *)[cell.contentView viewWithTag:5]).text = NSLocalizedString(@"TA还在休息呢，暂无签名", @"");
            }else{
                ((UILabel *)[cell.contentView viewWithTag:5]).text = [memberDataArray[indexPath.row-1] objectForKey:@"introduction"];
            }
        }
        if ([memberDataArray[indexPath.row-1] objectForKey:@"similarity"] != [NSNull class]) {
            [memberDataArray[indexPath.row-1] objectForKey:@"similarity"];
        }
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

#pragma 此处的跳转需要加入传递过去的必要信息,上方的加为好友button也是一个道理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if(indexPath.row == 0){
        
    }else{
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactPersonDetailViewController *cpdv = [main instantiateViewControllerWithIdentifier:@"contactpersondetail"];
        cpdv.isJIDOrYizhenID = YES;
        cpdv.friendJID = [memberDataArray[indexPath.row-1] objectForKey:@"jid"];
        [self.navigationController pushViewController:cpdv animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加好友按钮响应函数
-(void)addFriendByMember:(UIButton *)sender{
    NSLog(@"此处需要加入跳转时传输过去必要的参数");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SendAddMessViewController *smc = [main instantiateViewControllerWithIdentifier:@"sendaddmessage"];
    smc.addFriendJID = [memberDataArray[sender.superview.superview.tag-1] objectForKey:@"jid"];
    NSLog(@"jid====%@",[memberDataArray[sender.superview.superview.tag-1] objectForKey:@"jid"]);
    [self.navigationController pushViewController:smc animated:YES];
}

-(void)setupView{
    _memberTable.delegate = self;
    _memberTable.dataSource = self;
    _memberTable.tableFooterView = [[UIView alloc]init];
    _memberTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _memberTable.backgroundColor = grayBackColor;
}

-(void)setupData{
    memberDataArray = [NSMutableArray array];
    memberJIDArray = [@[@"p3028",
                        @"p2961",
                        @"p3080",
                        @"p3222",
                        @"p2956",
                        @"p2162",
                        @"p3058",
                        @"p2509",
                        @"p2163",
                        @"p3188",
                        @"p3059",
                        @"p2296",
                        @"p2167",
                        @"p3053",
                        @"p2829",
                        @"p2939"] mutableCopy];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    for (NSString *memJID in memberJIDArray) {
        NSString *jidurl = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,memJID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
        NSLog(@"jidurl===%@",jidurl);
        [[HttpManager ShareInstance] AFNetGETSupport:jidurl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            [memberDataArray addObject:userInfo];
            [_memberTable reloadData];
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

-(CGSize)getWidth:(NSString *)title{
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSAttributedString *newatt=[[NSAttributedString alloc] initWithString:title attributes:attrs];
    CGRect rect=[newatt boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    CGSize titleSize=rect.size;
    return titleSize;
}

@end
