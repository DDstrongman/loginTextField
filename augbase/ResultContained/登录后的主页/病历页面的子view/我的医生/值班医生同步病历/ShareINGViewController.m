//
//  ShareINGViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/8.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "ShareINGViewController.h"

#import "RootViewController.h"

#import "WebContactDoctorViewController.h"

@interface ShareINGViewController ()

{
    NSTimer *timer;
}

@end

@implementation ShareINGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)shareDoctor:(UIButton *)sender{
    
}

-(void)setupView{
    self.title = NSLocalizedString(@"同步中", @"");
    self.view.backgroundColor = [UIColor whiteColor];
    _yizhenProgressDoctorTablel.delegate = self;
    _yizhenProgressDoctorTablel.dataSource = self;
    _yizhenProgressDoctorTablel.backgroundColor = grayBackgroundLightColor;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 12)];
    headerView.backgroundColor = grayBackgroundLightColor;
    _yizhenProgressDoctorTablel.tableFooterView = [[UIView alloc]init];
    _yizhenProgressDoctorTablel.tableHeaderView = headerView;
}

-(void)setupData{
    float time = (arc4random() % 3) + 2;
    timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(pushSuccess) userInfo:nil repeats:NO];
    [timer fire];
}

-(void)pushSuccess{
//    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ShareSucessViewController *ssv = [main instantiateViewControllerWithIdentifier:@"sharesuccessview"];
//    [self.navigationController pushViewController:ssv animated:YES];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"1" forKey:@"userShareDoctor"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ImageUrl = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/doctor/%@",[_doctorDic objectForKey:@"img"]];
    ImageUrl = [ImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://www.yizhenapp.com/dashengguilai/dist/QAWithDoctor.html?roleType=patient&uid=%@&token=%@&id=%@&docName=%@&nickname=%@&src=%@&avatar=%@",[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"],[[_doctorDic objectForKey:@"id"] stringValue],[_doctorDic objectForKey:@"name"],[defaults objectForKey:@"userNickName"],ImageUrl,[defaults objectForKey:@"userHttpImageUrl"]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"聊天url====%@",url);
    WebContactDoctorViewController *wcd = [[WebContactDoctorViewController alloc]init];
    wcd.url = url;
    wcd.WebTitle = [_doctorDic objectForKey:@"name"];
    wcd.popViewController = _rootDoctorViewController;
    [self.navigationController pushViewController:wcd animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 125;
    }else{
        return 75;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yizhendoctorcell" forIndexPath:indexPath];
        [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound:NO];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = NSLocalizedString(@"值班医生", @"");
        ((UILabel *)[cell.contentView viewWithTag:3]).text = NSLocalizedString(@"值班医生只有同步了您的病历才能更好的回答你的问题，点击下方同步按钮即可完成同步", @"");
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"yizhendoctorcell"];
        UIButton *shareButton = [[UIButton alloc]init];
        [cell addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-50);
            make.left.equalTo(@50);
            make.top.equalTo(@15);
            make.bottom.equalTo(@-15);
        }];
        shareButton.backgroundColor = [UIColor clearColor];
        [shareButton setTitle:NSLocalizedString(@"同步中...", @"") forState:UIControlStateNormal];
        [shareButton setTitleColor:themeColor forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareDoctor:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
}

@end
