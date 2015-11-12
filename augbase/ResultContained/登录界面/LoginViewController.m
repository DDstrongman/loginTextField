//
//  LoginViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/1.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"
#import "UserItem.h"


#import "ForgetPasswordRootViewController.h"
#import "RegistNumberViewController.h"

#import "MBProgressHUD.h"

#import "WXApi.h"

#import "FirstTimeUserInfoViewController.h"

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
    
    //微信第三方
    NSString *code;
    NSDictionary *dic;
    NSString *access_token;
    NSString *openID;
    NSString *unID;
    NSString *nickName;
    UIImage *headImage;
    NSData *headImageData;
    
    MBProgressHUD *HUD;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[WriteFileSupport ShareInstance] removeAllDirDocuments];
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
    [_thirdLoginButton addTarget:self action:@selector(testWeixin:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeChatLoginCode:) name:@"WeChatLoginCode" object:nil];
}

- (void)getWeChatLoginCode:(NSNotification *)notification {
    NSString *weChatCode = [[notification userInfo] objectForKey:@"code"];
    /*
     使用获取的code换取access_token，并执行登录的操作
     */
    code = weChatCode;
    [self getAccess_token];
}

-(void)testWeixin:(UIButton *)sender{
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FirstTimeUserInfoViewController *ftui = [story instantiateViewControllerWithIdentifier:@"firsttimeuserinfo"];
//    [self.navigationController pushViewController:ftui animated:YES];
    [self sendAuthRequest];
}

-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ]init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendReq:req];
}

-(void)getAccess_token
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //常用的设置
    //小矩形的背景色
    HUD.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];//背景色
    //显示的文字
    HUD.labelText = NSLocalizedString(@"登录中...", @"");
    //细节文字
    //    HUD.detailsLabelText = @"Test detail";
    //是否有庶罩
    HUD.dimBackground = NO;
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",weixinID,weixinSecret,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
                access_token = [dicTemp objectForKey:@"access_token"];
                openID = [dicTemp objectForKey:@"openid"];
                unID = [dicTemp objectForKey:@"unionid"];
            
                [self getUserInfo];
            }
        });
    });
}

-(void)getUserInfo
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openID];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
                nickName = [dicTemp objectForKey:@"nickname"];
                headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dicTemp objectForKey:@"headimgurl"]]]];
                headImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dicTemp objectForKey:@"headimgurl"]]];
                [[NSUserDefaults standardUserDefaults]setObject:nickName forKey:@"userNickName"];
                NSString *thirdPartyUrl = [NSString stringWithFormat:@"%@v2/user/login/thirdPartyAccount?token=%@&uuid=%@&third_party_type=%d",Baseurl,access_token,unID,0];
                [[HttpManager ShareInstance]AFNetPOSTNobodySupport:thirdPartyUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    NSLog(@"device activitation source=%@,res=====%d",source,res);
                    if (res == 0) {
                        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        int res=[[source objectForKey:@"res"] intValue];
                        NSLog(@"device activitation source=%@",source);
                        if (res==0) {
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            //请求完成
                            [UserItem ShareInstance].userUID = [source objectForKey:@"uid"];
                            [UserItem ShareInstance].userName = [source objectForKey:@"username"];
                            [UserItem ShareInstance].userNickName = [source objectForKey:@"username"];
                            [UserItem ShareInstance].userRealName = [source objectForKey:@"nickname"];
                            [UserItem ShareInstance].userToken = [source objectForKey:@"token"];
                            [UserItem ShareInstance].userJID = [source objectForKey:@"ji"];
                            [UserItem ShareInstance].userTele = [source objectForKey:@"tel"];
                            [defaults setObject:[UserItem ShareInstance].userUID forKey:@"userUID"];
                            [defaults setObject:[UserItem ShareInstance].userName forKey:@"userName"];
                            [defaults setObject:[UserItem ShareInstance].userNickName forKey:@"userNickName"];
                            [defaults setObject:[UserItem ShareInstance].userRealName forKey:@"userRealName"];
                            [defaults setObject:[UserItem ShareInstance].userToken forKey:@"userToken"];
                            [defaults setObject:[UserItem ShareInstance].userJID forKey:@"userJID"];
                            [defaults setObject:[UserItem ShareInstance].userTele forKey:@"userTele"];
                            //jid获取用户信息
                            NSString *jidurl = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,[defaults objectForKey:@"userJID"],[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
                            jidurl = [jidurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                            manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                            [manager GET:jidurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                [defaults setObject:[[userInfo objectForKey:@"age"] stringValue] forKey:@"userAge"];
                                [defaults setObject:[[userInfo objectForKey:@"gender"] stringValue] forKey:@"userGender"];
                                [defaults setObject:[userInfo objectForKey:@"introduction"] forKey:@"userNote"];
                                [defaults setObject:[userInfo objectForKey:@"address"] forKey:@"userAddress"];
                                [defaults setObject:[userInfo objectForKey:@"hasBindWechat"] forKey:@"userWeChat"];
                                [defaults setObject:[userInfo objectForKey:@"yizhenId"] forKey:@"userYizhenID"];
                                NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[userInfo objectForKey:@"picture"]];
                                imageurl = [imageurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                                manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                                [manager GET:imageurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:myImageName Contents:responseObject];
                                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@/%@/%@.png",[[WriteFileSupport ShareInstance] dirDoc],yizhenImageFile,myImageName] forKey:@"userImageUrl"];
                                    if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",[defaults valueForKey:@"userJID"],httpServer]]) {
                                        NSString *creatUrl = [NSString stringWithFormat:@"%@unm/create",Baseurl];
                                        NSMutableDictionary *createDic = [NSMutableDictionary dictionary];
                                        [createDic setObject:@0 forKey:@"clienttype"];
                                        if ([defaults objectForKey:@"userDeviceID"]!= nil) {
                                            [createDic setObject:[defaults objectForKey:@"userDeviceID"] forKey:@"machineid"];
                                        }
                                        [createDic setObject:[defaults objectForKey:@"userUID"] forKey:@"uid"];
                                        [createDic setObject:[defaults objectForKey:@"userToken"] forKey:@"token"];
                                        [[HttpManager ShareInstance]AFNetPOSTNobodySupport:creatUrl Parameters:createDic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            NSDictionary *createRes = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                            if ([[createRes objectForKey:@"res"] intValue] == 0) {
                                                NSLog(@"更新设备号成功");
                                            }
                                        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                        }];
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
                    }else if(res == 2){
                        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请重新授权", @"") Title:NSLocalizedString(@"授权出错", @"") ViewController:self];
                    }else if (res == 45){
                        [self registViewWeChat];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        });
        
    });
}

#pragma 登录的响应函数
-(void)gotoMainView{
    [self.view endEditing:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //常用的设置
    //小矩形的背景色
    HUD.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];//背景色
    //显示的文字
    HUD.labelText = NSLocalizedString(@"登录中...", @"");
    //细节文字
//    HUD.detailsLabelText = @"Test detail";
    //是否有庶罩
    HUD.dimBackground = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_userNameView.contentTextField.text forKey:@"userName"];
    [defaults setObject:_passWordView.contentTextField.text forKey:@"userPassword"];
    [defaults setObject:@NO forKey:@"FriendList"];
    
    NSString *url = [NSString stringWithFormat:@"%@v2/user/login",Baseurl];
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
        NSLog(@"登陆的返回res====%d",res);
        if (res==0) {
            //请求完成
            [UserItem ShareInstance].userUID = [source objectForKey:@"uid"];
            [UserItem ShareInstance].userName = [source objectForKey:@"username"];
            [UserItem ShareInstance].userNickName = [source objectForKey:@"username"];
            [UserItem ShareInstance].userRealName = [source objectForKey:@"nickname"];
            [UserItem ShareInstance].userToken = [source objectForKey:@"token"];
            [UserItem ShareInstance].userJID = [source objectForKey:@"ji"];
            [UserItem ShareInstance].userTele = [source objectForKey:@"tel"];
            [defaults setObject:[UserItem ShareInstance].userUID forKey:@"userUID"];
            [defaults setObject:[UserItem ShareInstance].userName forKey:@"userName"];
            [defaults setObject:[UserItem ShareInstance].userNickName forKey:@"userNickName"];
            [defaults setObject:[UserItem ShareInstance].userRealName forKey:@"userRealName"];
            [defaults setObject:[UserItem ShareInstance].userToken forKey:@"userToken"];
            [defaults setObject:[UserItem ShareInstance].userJID forKey:@"userJID"];
            [defaults setObject:[UserItem ShareInstance].userTele forKey:@"userTele"];
            NSString *jidurl = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,[defaults objectForKey:@"userJID"],[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
            jidurl = [jidurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSLog(@"jidurl === %@",jidurl);
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer=[AFHTTPRequestSerializer serializer];
            [manager GET:jidurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                [defaults setObject:[[userInfo objectForKey:@"age"] stringValue] forKey:@"userAge"];
                [defaults setObject:[[userInfo objectForKey:@"gender"] stringValue] forKey:@"userGender"];
                [defaults setObject:[userInfo objectForKey:@"introduction"] forKey:@"userNote"];
                [defaults setObject:[userInfo objectForKey:@"address"] forKey:@"userAddress"];
                [defaults setObject:[userInfo objectForKey:@"hasBindWechat"] forKey:@"userWeChat"];
                [defaults setObject:[userInfo objectForKey:@"yizhenId"] forKey:@"userYizhenID"];
                NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[userInfo objectForKey:@"picture"]];
                imageurl = [imageurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                [defaults setObject:imageurl forKey:@"userHttpImageUrl"];
                [manager GET:imageurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:myImageName Contents:responseObject];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@/%@/%@.png",[[WriteFileSupport ShareInstance] dirDoc],yizhenImageFile,myImageName] forKey:@"userImageUrl"];
                    if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",[defaults valueForKey:@"userJID"],httpServer]]) {
                        NSString *creatUrl = [NSString stringWithFormat:@"%@unm/create",Baseurl];
                        NSMutableDictionary *createDic = [NSMutableDictionary dictionary];
                        [createDic setObject:@0 forKey:@"clienttype"];
                        if ([defaults objectForKey:@"userDeviceID"]!= nil) {
                            [createDic setObject:[defaults objectForKey:@"userDeviceID"] forKey:@"machineid"];
                        }
                        [createDic setObject:[defaults objectForKey:@"userUID"] forKey:@"uid"];
                        [createDic setObject:[defaults objectForKey:@"userToken"] forKey:@"token"];
                        [[HttpManager ShareInstance]AFNetPOSTNobodySupport:creatUrl Parameters:createDic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSDictionary *createRes = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                            if ([[createRes objectForKey:@"res"] intValue] == 0) {
                                NSLog(@"更新设备号成功");
                            }
                        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                        }];
                    }
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"获取图片信息失败");
                }];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"获取jid信息失败");
            }];
        }else{
            [[SetupView ShareInstance]showAlertView:res Hud:HUD ViewController:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败");
        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请检查您的网络", @"") Title:NSLocalizedString(@"网路出错", @"") ViewController:self];
        [HUD hide:YES];
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
        [HUD hide:YES];
        [[XMPPSupportClass ShareInstance] getMyQueryRoster];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"NotFirstTime"];
        
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
//    UIApplication *application = [UIApplication sharedApplication];
//    application.networkActivityIndicatorVisible = YES;
//    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    testActivityIndicator.center = CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
//    testActivityIndicator.frame = CGRectMake(0, 0, 100, 100);//不建议这样设置，因为UIActivityIndicatorView是不能改变大小只能改变位置，这样设置得到的结果是控件的中心在（100，100）上，而不是和其他控件的frame一样左上角在（100， 100）长为100，宽为100.
//    [self.view addSubview:testActivityIndicator];
//    testActivityIndicator.color = [UIColor redColor]; // 改变圈圈的颜色为红色； iOS5引入
//    [testActivityIndicator startAnimating]; // 开始旋转
////    [testActivityIndicator stopAnimating]; // 结束旋转
//    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    if ([WXApi isWXAppInstalled]&& [WXApi isWXAppSupportApi]) {
        _thirdLoginButton.hidden = NO;
    }else{
        _thirdLoginButton.hidden = YES;
    }
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
    _passWordView.contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    showPasswordOrNot = YES;
    _loginButton.userInteractionEnabled = NO;
//    [_userNameView.contentTextField becomeFirstResponder];
    [XMPPSupportClass ShareInstance].connectXMPPDelegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"ShowGuide"]) {
        
    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginview"];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [[RZTransitionsNavigationController alloc] initWithRootViewController:loginViewController];
        [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"ShowGuide"];
    }
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

-(void)registView{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistNumberViewController *rnv = [story instantiateViewControllerWithIdentifier:@"registnumber"];
    rnv.isBlindWeChat = NO;
    rnv.unID = unID;
    rnv.headImageData = headImageData;
    [self.navigationController pushViewController:rnv animated:YES];
}

-(void)registViewWeChat{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistNumberViewController *rnv = [story instantiateViewControllerWithIdentifier:@"registnumber"];
    rnv.isBlindWeChat = YES;
    rnv.unID = unID;
    rnv.headImageData = headImageData;
    [self.navigationController pushViewController:rnv animated:YES];
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

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [HUD hide:YES];
}

@end
