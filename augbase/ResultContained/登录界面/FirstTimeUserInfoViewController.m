//
//  FirstTimeUserInfoViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "FirstTimeUserInfoViewController.h"

#import "XMPPSupportClass.h"
#import "UserItem.h"
#import "AppDelegate.h"

@interface FirstTimeUserInfoViewController ()<ConnectXMPPDelegate>
{
    BOOL _animatedOrNot;
}

@end

@implementation FirstTimeUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"个人信息", @"");
    [_userImageView setImage:[UIImage imageNamed:@"default_avatar"]];
    [XMPPSupportClass ShareInstance].connectXMPPDelegate = self;
    
    _nameView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 250, ViewWidth-120+12, 50)];
    _nameView.contentTextField.placeholder = NSLocalizedString(@"昵称", @"");
    _sexAndAgeView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 300+5, ViewWidth-120+12, 50)];
    _sexAndAgeView.contentTextField.placeholder = NSLocalizedString(@"性别／年龄", @"");
//    [_sexAndAgeView.contentTextField addTarget:self action:@selector(selectSexAndAge) forControlEvents:UIControlEventEditingDidBegin];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSexAndAge)];
     [singleTap setNumberOfTapsRequired:1];
    [_sexAndAgeView addGestureRecognizer:singleTap];
    
    _userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImageOrCamera)];
    [_userImageView addGestureRecognizer:singleTapImage];
    
    [self.view addSubview:_nameView];
    [self.view addSubview:_sexAndAgeView];
    
    _finishRegistButton = [[UIButton alloc]init];
    [_finishRegistButton setTitle:NSLocalizedString(@"完成", @"") forState:UIControlStateNormal];
    [_finishRegistButton addTarget:self action:@selector(finishRegist) forControlEvents:UIControlEventTouchUpInside];
    [_finishRegistButton.layer setMasksToBounds:YES];
    [_finishRegistButton.layer setCornerRadius:10.0];
    [self.view addSubview:_finishRegistButton];
    
    _cameraImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _cameraImageView.center = CGPointMake(56.25, 56.25);
    _cameraImageView.image = [UIImage imageNamed:@"take"];
    [_cameraImageView imageWithRound];
    [_userImageView addSubview:_cameraImageView];
    
    [_finishRegistButton mas_makeConstraints:^(MASConstraintMaker *make) {        make.height.equalTo(@50);
        make.top.equalTo(_sexAndAgeView.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    _finishRegistButton.backgroundColor = grayBackColor;
    _sexAndAgeView.contentTextField.userInteractionEnabled = NO;
    _animatedOrNot = YES;
    
    //可能需要加入每次加载界面的判断，是否满足激活按钮的条件，需要详细考虑
    _finishRegistButton.userInteractionEnabled = NO;
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)selectSexAndAge{
    [_pickview remove];
    _sexAndAgeView.titleLabel.hidden = NO;
    _sexAndAgeView.titleLabel.text = _sexAndAgeView.contentTextField.placeholder;
    _sexAndAgeView.titleLabel.textColor = grayLabelColor;
    
    [self.view endEditing:YES];
    _pickview = [[ZHPickView alloc] initPickviewWithPlistName:@"sexAndAge" isHaveNavControler:NO];
    _pickview.delegate = self;
    [_pickview show];
}

-(void)selectImageOrCamera{
    NSLog(@"加入打开相册和照相机的代码，即跳转原项目中已有的view");
}

-(void)finishRegist{
    NSLog(@"注册完成，添加响应函数");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_userName forKey:@"userName"];
    [defaults setObject:_userPass forKey:@"userPassword"];
    [defaults setObject:@YES forKey:@"NotFirstTime"];
    [defaults setObject:_nameView.contentTextField.text forKey:@"userNickName"];
    NSString *sexAndAge = _sexAndAgeView.contentTextField.text;
    NSArray *array = [sexAndAge componentsSeparatedByString:@"／"];
    NSLog(@"分割后的字符为：%@",array);
    [defaults setObject:array[0] forKey:@"userGender"];
    [defaults setObject:array[1] forKey:@"userAge"];
    //    NSString *url = [NSString stringWithFormat:@"%@user/login?username=%@&password=%@",Baseurl,[defaults objectForKey:@"UserName"],[defaults objectForKey:@"Password"]];
#warning 正式版本中使用上方的代码
    NSString *url = [NSString stringWithFormat:@"%@user/login?username=%@&password=%@",Baseurl,@"azaz",@"123123"];
    NSLog(@"url === %@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败");
    }];
#warning 此处是测试时候用的代码，正式上线需要将一部分代码转移到上面去
    if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",testMineJID,httpServer]]) {
        
    }
}

#pragma xmpp登录结果的delegate
-(void)ConnectXMPPResult:(BOOL)result{
    NSLog(@"xmpp登录结果");
    if (result) {
        
//        [[XMPPSupportClass ShareInstance] getMyQueryRoster];
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *tabbarController = [story instantiateViewControllerWithIdentifier:@"tabbarmainview"];
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        appDelegate.window.rootViewController = [[RZTransitionsNavigationController alloc] initWithRootViewController:tabbarController];
    }else{
        NSLog(@"XMPP服务器登陆失败");
        UIAlertView *xmppFailedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"聊天服务器登陆失败", @"") message:NSLocalizedString(@"聊天服务器登陆失败,请联系管理员", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [xmppFailedAlert show];
    }
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    _sexAndAgeView.contentTextField.text = resultString;
    _finishRegistButton.userInteractionEnabled = YES;
    _finishRegistButton.backgroundColor = themeColor;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

#pragma 取消键盘输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
