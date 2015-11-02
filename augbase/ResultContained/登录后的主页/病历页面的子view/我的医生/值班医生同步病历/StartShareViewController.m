//
//  StartShareViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/8.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "StartShareViewController.h"

#import "ShareINGViewController.h"

@interface StartShareViewController ()

@end

@implementation StartShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)shareDoctor:(UIButton *)sender{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShareINGViewController *siv = [main instantiateViewControllerWithIdentifier:@"shareprogressview"];
    siv.doctorJID = _doctorJID;
    siv.doctorDic = _doctorDic;
    siv.rootDoctorViewController = _rootDoctorViewController;
    [self.navigationController pushViewController:siv animated:YES];
}

-(void)setupView{
    self.title = NSLocalizedString(@"值班医生", @"");
    self.view.backgroundColor = [UIColor whiteColor];
    _yizhenDoctorTablel.delegate = self;
    _yizhenDoctorTablel.dataSource = self;
    _yizhenDoctorTablel.backgroundColor = grayBackgroundLightColor;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 12)];
    headerView.backgroundColor = grayBackgroundLightColor;
    _yizhenDoctorTablel.tableFooterView = [[UIView alloc]init];
    _yizhenDoctorTablel.tableHeaderView = headerView;
}

-(void)setupData{
    
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
        [shareButton viewWithRadis:10.0];
        shareButton.backgroundColor = themeColor;
        [shareButton setTitle:NSLocalizedString(@"同步病历", @"") forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareDoctor:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾

@end
