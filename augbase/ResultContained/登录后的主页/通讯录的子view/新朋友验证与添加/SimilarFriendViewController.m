//
//  SimilarFriendViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "SimilarFriendViewController.h"

#import "ContactPersonDetailViewController.h"
#import "SendAddMessViewController.h"
#import "SetupView.h"

@interface SimilarFriendViewController ()

{
    NSMutableArray *dataArray;//搜索的数据元数组
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
}

@end

@implementation SimilarFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _similarFriendTable.delegate = self;
    _similarFriendTable.dataSource = self;
    _similarFriendTable.backgroundColor = grayBackgroundLightColor;
    _similarFriendTable.tableFooterView = [[UIView alloc]init];
    [[SetupView ShareInstance]showHUD:self Title:NSLocalizedString(@"加载中", @"")];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"相似战友", @"");
}

-(void)setupData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *similarUrl = [NSString stringWithFormat:@"%@v2/user/similarUser?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    [[HttpManager ShareInstance]AFNetGETSupport:similarUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"res====%d",res);
        if (res == 0) {
            dataArray = [source objectForKey:@"users"];
            [_similarFriendTable reloadData];
            [[SetupView ShareInstance]hideHUD];
            if (dataArray.count == 0) {
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"还差一步", @"") message:NSLocalizedString(@"尚未在「病历」完善资料，无法找到相似病友，先去「病历」拍拍化验单、选填用药和疾病信息吧！", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"返回", @"") otherButtonTitles:nil, nil];
                [alerView show];
            }
        }else{
            [[SetupView ShareInstance]hideHUD];
            if (res == 44) {
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"还差一步", @"") message:NSLocalizedString(@"尚未在「病历」完善资料，无法找到相似病友，先去「病历」拍拍化验单、选填用药和疾病信息吧！", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"返回", @"") otherButtonTitles:nil, nil];
                [alerView show];
            }else if (res == 49){
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userWeChat"] boolValue]) {
                    NSString *thirdPartyUrl = [NSString stringWithFormat:@"%@v2/user/login/thirdPartyAccount?token=%@&uuid=%@&third_party_type=%d",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userWeChatToken"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userWeChatUID"],0];
                    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:thirdPartyUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        int res=[[source objectForKey:@"res"] intValue];
                        NSLog(@"device activitation source=%@,res=====%d",source,res);
                        if (res == 0) {
                            [[NSUserDefaults standardUserDefaults] setObject:[source objectForKey:@"token"] forKey:@"userToken"];
                        }else{
                            [[SetupView ShareInstance]hideHUD];
                            [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
                        }
                    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [[SetupView ShareInstance]hideHUD];
                        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请检查您的网络和定位是否打开", @"") Title:NSLocalizedString(@"不能获取附近战友", @"") ViewController:self];
                    }];
                }else{
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *url = [NSString stringWithFormat:@"%@v2/user/login",Baseurl];
                    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
                    [loginDic setValue:[defaults objectForKey:@"userName"] forKey:@"username"];
                    [loginDic setValue:[defaults objectForKey:@"userPassword"] forKey:@"password"];
                    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                    [manager POST:url parameters:loginDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        int res=[[source objectForKey:@"res"] intValue];
                        if (res==0) {
                            [defaults setObject:[source objectForKey:@"token"] forKey:@"userToken"];
                        }else{
                            [[SetupView ShareInstance]hideHUD];
                            [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
                        }
                    }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                        [[SetupView ShareInstance]hideHUD];
                        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请检查您的网络和定位是否打开", @"") Title:NSLocalizedString(@"不能获取附近战友", @"") ViewController:self];
                    }];
                }
            }else{
                [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
            }
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[SetupView ShareInstance]hideHUD];
        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请检查您的网络", @"") Title:NSLocalizedString(@"网络出错", @"") ViewController:self];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"similarfriendcell" forIndexPath:indexPath];
    if (dataArray.count > 0) {
        NSString *sex;
        [((UIImageView *)[cell.contentView viewWithTag:1]) sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PersonImageUrl,[dataArray[indexPath.row] objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"icon.jpg"]];
        [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
        [[cell.contentView viewWithTag:7] viewWithRadis:1.0];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = [dataArray[indexPath.row] objectForKey:@"name"];
        if ([[dataArray[indexPath.row] objectForKey:@"gerder"] intValue] == 1) {
            sex = NSLocalizedString(@"女", @"");
        }else{
            sex = NSLocalizedString(@"男", @"");
        }
        ((UILabel *)[cell.contentView viewWithTag:3]).text = [NSString stringWithFormat:@"%@ / %d",sex,[[dataArray[indexPath.row] objectForKey:@"age"] intValue]];
        if ([[dataArray[indexPath.row] objectForKey:@"address"] isEqualToString:@""]) {
            [((UIButton *)[cell.contentView viewWithTag:4]) setTitle:NSLocalizedString(@"--", @"") forState:UIControlStateNormal];
        }else{
            [((UIButton *)[cell.contentView viewWithTag:4]) setTitle:[dataArray[indexPath.row] objectForKey:@"address"] forState:UIControlStateNormal];
        }
        if ([[dataArray[indexPath.row] objectForKey:@"introduction"] isEqualToString:@""]) {
            
            ((UILabel *)[cell.contentView viewWithTag:5]).text = NSLocalizedString(@"TA还在休息呢，暂无签名", @"");
        }else{
            ((UILabel *)[cell.contentView viewWithTag:5]).text = [dataArray[indexPath.row] objectForKey:@"introduction"];
        }
        ((UILabel *)[cell.contentView viewWithTag:6]).text = [[[dataArray[indexPath.row] objectForKey:@"similarity"] stringValue] stringByAppendingString:@"%"];
        [((UIButton *)[cell.contentView viewWithTag:7]) addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        cell.tag = indexPath.row;
    }
    return cell;
}

#pragma 添加加为好友的函数,获取对应的cell可以通过sender.superview来获取
-(void)addFriend:(UIButton *)sender{
    NSLog(@"加上加为好友的响应函数，网络通讯");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SendAddMessViewController *smc = [main instantiateViewControllerWithIdentifier:@"sendaddmessage"];
    smc.addFriendJID = [dataArray[sender.superview.superview.tag] objectForKey:@"jid"];
    [self.navigationController pushViewController:smc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactPersonDetailViewController *cpdv = [main instantiateViewControllerWithIdentifier:@"contactpersondetail"];
    cpdv.isJIDOrYizhenID = NO;
    cpdv.friendJID = [dataArray[indexPath.row] objectForKey:@"jid"];
    [self.navigationController pushViewController:cpdv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
