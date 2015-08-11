//
//  LoginViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/1.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "LoginViewController.h"

#import "XMPPSupportClass.h"
#import "AppDelegate.h"
#import "HttpSupportClass.h"

#import "UserItem.h"

@interface LoginViewController ()

{
    BOOL isRegisted;//判断是否注册过，注册过则自动填充手机号为账号（仅限为从注册界面跳过来）
    BOOL showPasswordOrNot;//判断是否显示明文密码
    UIButton *sectureButton;//密码框右边显示密码or not的按钮
    BOOL NotFirstTimeLogin;//no为初次登录，yes则不是
    NSString *userName;//用户名称
    NSString *userID;//用户ID
    NSString *pass;//密码
    NSString *server;//服务器
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //去登陆界面
    UIButton *registButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 120, 30)];
    [XMPPSupportClass ShareInstance].connectXMPPDelegate = self;
    
    registButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    registButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registButton setTitle:NSLocalizedString(@"注册新用户", @"") forState:UIControlStateNormal];
    [registButton setTitleColor:themeColor forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(registView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:registButton]];
#warning 调整向上距离用的参数
    int spaceRoom = 0;
    
    _userNameView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 94-spaceRoom, ViewWidth-120+12, 50)];
    _passWordView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 149-spaceRoom, ViewWidth-120+12, 50)];
    [_userNameView.contentTextField addTarget:self action:@selector(ensurePhoneAndPassword) forControlEvents:UIControlEventEditingChanged];
    [_passWordView.contentTextField addTarget:self action:@selector(ensurePhoneAndPassword) forControlEvents:UIControlEventEditingChanged];
    
    sectureButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 14)];
    [sectureButton addTarget:self action:@selector(changeSecture) forControlEvents:UIControlEventTouchUpInside];
    [sectureButton setBackgroundImage:[UIImage imageNamed:@"not_visible"] forState:UIControlStateNormal];
    
    _passWordView.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    _passWordView.contentTextField.rightView = sectureButton;
    
    [self.view addSubview:_userNameView];
    [self.view addSubview:_passWordView];
    
    _loginButton = [[UIButton alloc]init];
    _loginButton.backgroundColor = grayBackColor;
    [_loginButton setTitle:NSLocalizedString(@"登录", @"") forState:UIControlStateNormal];
    [_loginButton viewWithRadis:10.0];
    [_loginButton addTarget:self action:@selector(gotoMainView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _forgetPassButton = [[UIButton alloc]init];
    [_forgetPassButton addTarget:self action:@selector(forgetPass:) forControlEvents:UIControlEventTouchUpInside];
    _forgetPassButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_forgetPassButton setTitle:NSLocalizedString(@"忘记密码", @"") forState:UIControlStateNormal];
    [_forgetPassButton setTitleColor:themeColor forState:UIControlStateNormal];
    _forgetPassButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_forgetPassButton];
    
    //autolayout
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(_passWordView.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];
    [_forgetPassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.top.equalTo(_loginButton.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.width.equalTo(@80);
    }];
    
    _thirdLoginButton.layer.borderWidth = 1.0;
    _thirdLoginButton.layer.borderColor = themeColor.CGColor;
    [_thirdLoginButton setTintColor:themeColor];
    [_thirdLoginButton viewWithRadis:10.0];
}

#pragma 登录的响应函数
-(void)gotoMainView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_userNameView.contentTextField.text forKey:@"userName"];
    [defaults setObject:_passWordView.contentTextField.text forKey:@"userPassword"];
    [defaults setObject:@YES forKey:@"NotFirstTime"];
//    NSString *url = [NSString stringWithFormat:@"%@user/login?username=%@&password=%@",Baseurl,[defaults objectForKey:@"UserName"],[defaults objectForKey:@"Password"]];
#warning 正式版本中使用上方的代码
    NSString *url = [NSString stringWithFormat:@"%@user/login?username=%@&password=%@",Baseurl,@"闪电侠",@"039877"];
    NSLog(@"url === %@",url);
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject=%@",responseObject);
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"device activitation res=%d",res);
        if (res==0) {
            //请求完成
            [UserItem ShareInstance].userUID = [source objectForKey:@"uid"];
            [UserItem ShareInstance].userName = [source objectForKey:@"username"];
            [UserItem ShareInstance].userNickName = [source objectForKey:@"nickname"];
            [UserItem ShareInstance].userToken = [source objectForKey:@"token"];
            [UserItem ShareInstance].userJID = [source objectForKey:@"ji"];
            NSLog(@"返回的登录系数：%@",source);
            //            [defaults synchronize];
            [defaults setObject:[UserItem ShareInstance].userUID forKey:@"UserUID"];
            [defaults setObject:[UserItem ShareInstance].userName forKey:@"UserName"];
            [defaults setObject:[UserItem ShareInstance].userNickName forKey:@"NickName"];
            [defaults setObject:[UserItem ShareInstance].userToken forKey:@"UserToken"];
            [defaults setObject:[UserItem ShareInstance].userJID forKey:@"UserJID"];
            [[XMPPSupportClass ShareInstance] connect:[NSString stringWithFormat:@"%@@%@",[UserItem ShareInstance].userJID,httpServer]];
        }
        else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败");
    }];
#warning 此处是测试时候用的代码，正式上线需要将一部分代码转移到上面去
    if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",testMineJID,httpServer]]) {
        
    }
}
#pragma 忘记密码的响应函数
-(void)forgetPass:(UIButton *)sender{
    NSLog(@"忘记密码的响应函数");
}


#pragma xmpp登录结果的delegate
-(void)ConnectXMPPResult:(BOOL)result{
    NSLog(@"xmpp登录结果");
    if (result) {
        [[XMPPSupportClass ShareInstance] getMyQueryRoster];
        
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

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBarHidden = NO;
#warning 去掉navigationbar下划线
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"white"]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
//    [navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:themeColor,NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.tintColor = themeColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
//    [self.navigationController.navigationBar setTintColor:themeColor];
    //初始化
    //    [_userNameText becomeFirstResponder];
    _userNameView.contentTextField.placeholder = NSLocalizedString(@"手机号／用户名", @"");
    _userNameView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passWordView.contentTextField.placeholder = NSLocalizedString(@"密码", @"");
    _passWordView.contentTextField.secureTextEntry = YES;
    _passWordView.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    showPasswordOrNot = YES;
    _loginButton.userInteractionEnabled = NO;
}

-(void)ensurePhoneAndPassword{
    if (_passWordView.contentTextField.text.length>5&&[self isValidateMobile:_userNameView.contentTextField.text]) {
        _loginButton.userInteractionEnabled = YES;
        _loginButton.backgroundColor = themeColor;
    }else{
        _loginButton.userInteractionEnabled = NO;
        _loginButton.backgroundColor = grayBackColor;
    }
}

-(void)changeSecture{
    if (showPasswordOrNot) {
        _passWordView.contentTextField.secureTextEntry = NO;
        showPasswordOrNot = NO;
        [sectureButton setBackgroundImage:[UIImage imageNamed:@"visible"] forState:UIControlStateNormal];
    }else{
        _passWordView.contentTextField.secureTextEntry = YES;
        showPasswordOrNot = YES;
        [sectureButton setBackgroundImage:[UIImage imageNamed:@"not_visible"] forState:UIControlStateNormal];
    }
}

-(void)registView
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lgv = [story instantiateViewControllerWithIdentifier:@"loginAndRegist"];
    [self.navigationController pushViewController:lgv animated:YES];
}

-(IBAction)forgotPasswor:(id)sender{
    //加入点击忘记密码的事件
    NSLog(@"忘记密码");
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
