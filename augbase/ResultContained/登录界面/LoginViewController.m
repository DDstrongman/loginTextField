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
#import "UserItem.h"

#import "sys/sysctl.h"

#import "ForgetPasswordRootViewController.h"

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
    
    NSString * strModel  = [self doDevicePlatform];
    NSLog(@"设备型号为：%@",strModel);
}


#pragma 登录的响应函数
-(void)gotoMainView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_userNameView.contentTextField.text forKey:@"userName"];
    [defaults setObject:_passWordView.contentTextField.text forKey:@"userPassword"];
    [defaults setObject:@YES forKey:@"NotFirstTime"];
    [defaults setObject:@NO forKey:@"FriendList"];
    
    NSString *url = [NSString stringWithFormat:@"%@v2/user/login",Baseurl];
    NSLog(@"url===%@",url);
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
    [loginDic setValue:[defaults objectForKey:@"userName"] forKey:@"username"];
    [loginDic setValue:[defaults objectForKey:@"userPassword"] forKey:@"password"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager POST:url parameters:loginDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [defaults setObject:[UserItem ShareInstance].userUID forKey:@"userUID"];
            [defaults setObject:[UserItem ShareInstance].userName forKey:@"userName"];
            [defaults setObject:[UserItem ShareInstance].userNickName forKey:@"userNickName"];
            [defaults setObject:[UserItem ShareInstance].userToken forKey:@"userToken"];
            [defaults setObject:[UserItem ShareInstance].userJID forKey:@"userJID"];
            [[XMPPSupportClass ShareInstance] connect:[NSString stringWithFormat:@"%@@%@",[UserItem ShareInstance].userJID,httpServer]];
            //获取本人头像和好友头像
            NSLog(@"userJid === %@,web登录完成，开始xmpp登录",[defaults valueForKey:@"userJID"]);
            //jid获取用户信息
            NSString *jidurl = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,[defaults objectForKey:@"userJID"],[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
            NSLog(@"jidurl === %@",jidurl);
            jidurl = [jidurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer=[AFHTTPRequestSerializer serializer];
            [manager GET:jidurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[userInfo objectForKey:@"picture"]];
                NSLog(@"imageurl === %@",imageurl);
                imageurl = [imageurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                [manager GET:imageurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:myImageName Contents:responseObject];
                    if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",[defaults valueForKey:@"userJID"],httpServer]]) {
                        
                    }
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"获取图片信息失败");
                }];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"获取jid信息失败");
            }];
        }
        else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败");
    }];
}
#pragma 忘记密码的响应函数
-(void)forgetPass:(UIButton *)sender{
    NSLog(@"忘记密码的响应函数");
    ForgetPasswordRootViewController *fprv = [[ForgetPasswordRootViewController alloc]init];
    [self.navigationController pushViewController:fprv animated:YES];
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

    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:themeColor,NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.tintColor = themeColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    _userNameView.contentTextField.placeholder = NSLocalizedString(@"手机号／用户名", @"");
    _passWordView.contentTextField.placeholder = NSLocalizedString(@"密码", @"");
    _passWordView.contentTextField.secureTextEntry = YES;
    _passWordView.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    showPasswordOrNot = YES;
    _loginButton.userInteractionEnabled = NO;
    
    [XMPPSupportClass ShareInstance].connectXMPPDelegate = self;
}

-(void)ensurePhoneAndPassword{
    if (_passWordView.contentTextField.text.length>5/*&&[self isValidateMobile:_userNameView.contentTextField.text]*/) {
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


- (NSString*) doDevicePlatform{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        
        platform = @"iPhone";
        
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        
        platform = @"iPhone 3G";
        
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        
        platform = @"iPhone 3GS";
        
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        
        platform = @"iPhone 4";
        
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        
        platform = @"iPhone 4S";
        
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        
        platform = @"iPhone 5";
        
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        
        platform = @"iPhone 5C";
        
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        
        platform = @"iPhone 5S";
        
    }else if ([platform isEqualToString:@"iPod4,1"]) {
        
        platform = @"iPod touch 4";
        
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        
        platform = @"iPod touch 5";
        
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        
        platform = @"iPod touch 3";
        
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        
        platform = @"iPod touch 2";
        
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        
        platform = @"iPod touch";
        
    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {
        
        platform = @"iPad 3";
        
    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        
        platform = @"iPad 2";
        
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        
        platform = @"iPad 1";
        
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        
        platform = @"ipad mini";
        
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        
        platform = @"ipad 3";
        
    }
    
    return platform;
}

@end
