//
//  AppDelegate.m
//  ResultContained
//
//  Created by 李胜书 on 15/6/26.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
/***************************************************************************************/
//                               _oo0oo_
//                              088888880
//                              88" . "88
//                              (| -_- |)
//                               0\ = /0
//                            ___/'---'\___
//                         .' \\\\|     |// '.
//                        / \\\\||| :  |||// \\
//                       / _|||||  -:- |||||_  \
//                      | | |  \\\  -  /// |    |
//                      | \_|   ''\---/''  |_/  |
//                       \  .-\__   '-'   __/-. /
//                      ___'. .'   /--.--\  '. .'___
//                  ."" '<   '.___\_<|>_/___.' >'  "".
//                  | | : ' -  \'.;'\ _ /';.'/ - ' : | |
//                  \  \ ' _.   \_ __\ /__ _/   .-' /  /
//              ====='-._____'.___ \_____/___.-'_____.-'=====
//                                 '=---='
//
//             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                    佛祖保佑      永无BUG       永不修改
/***************************************************************************************/

#import "AppDelegate.h"

#import "OcrTextResultViewController.h"

#import "RootGuideViewController.h"
#import "LoginViewController.h"
#import "sys/sysctl.h"
//#import "ShowAllMessageViewController.h"

@interface AppDelegate ()

{
    BOOL NotFirstTimeLogin;//no为初次登录，yes则不是
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:weixinID];
    
    // Override point for customization after application launch.    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginview"];
    UIViewController *showMessViewController = [story instantiateViewControllerWithIdentifier:@"tabbarmainview"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL showGuide = [[defaults objectForKey:@"ShowGuide"] boolValue];//是否进入引导页
    NotFirstTimeLogin = [[defaults objectForKey:@"NotFirstTime"] boolValue];//no为初次登录，yes则不是
    RZTransitionsNavigationController* rootNavController;
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    if (!showGuide&&!NotFirstTimeLogin) {
        RootGuideViewController *rgv = [[RootGuideViewController alloc]init];
        rootNavController = [[RZTransitionsNavigationController alloc] initWithRootViewController:rgv];
    }else{
        if (NotFirstTimeLogin) {
            //已经登录过了
            rootNavController = [[RZTransitionsNavigationController alloc] initWithRootViewController:showMessViewController];
            
            NSString *recordString = [NSString stringWithFormat:@"%@user/record",Baseurl];
            NSMutableDictionary *recordDic = [NSMutableDictionary dictionary];
            [recordDic setObject:[defaults objectForKey:@"userUID"] forKey:@"uid"];
            [recordDic setObject:[defaults objectForKey:@"userToken"] forKey:@"token"];
            [[HttpManager ShareInstance]AFNetPOSTNobodySupport:recordString Parameters:recordDic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                int res=[[source objectForKey:@"res"] intValue];
                if (res == 0) {
                    NSLog(@"记录成功");
                }
            } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }else{
            
            rootNavController = [[RZTransitionsNavigationController alloc] initWithRootViewController:loginViewController];
            [[DBManager ShareInstance] creatDatabase:DBName];
            [[DBManager ShareInstance] closeDB];
        }
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootNavController  ;
    [self.window makeKeyAndVisible];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    NSLog(@"当前系统版本为===%f",[[[UIDevice currentDevice] systemVersion] floatValue]);
    NSString * strModel  = [self doDevicePlatform];
    NSLog(@"设备型号为：%@",strModel);
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        [application registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
    [defaults setObject:[[UIDevice currentDevice] systemVersion] forKey:@"userSystemVersion"];
    [defaults setObject:strModel forKey:@"userPhone"];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *ss = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:ss forKey:@"userDeviceID"];
    NSLog(@"ss===%@",ss);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"%s",__FUNCTION__);
    [self application:application didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[XMPPSupportClass ShareInstance] disconnect];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//    localNotification.alertAction = @"Ok";
//    localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n%@",@"新消息:",@"123"];//弹窗信息
    localNotification.applicationIconBadgeNumber = 2;//边角图标
//    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"NotFirstTime"]) {
        [[XMPPSupportClass ShareInstance] connect:[NSString stringWithFormat:@"%@@%@",[defaults objectForKey:@"userJID"],httpServer]];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[XMPPSupportClass ShareInstance] disconnect];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@NO forKey:@"FriendList"];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    return  isSuc;
}

-(void) onReq:(BaseReq*)req{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


//授权后回调 WXApiDelegate
-(void)onResp:(BaseReq *)resp{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"易诊分享结果"];
        SendAuthResp *aresp = (SendAuthResp *)resp;
        NSString *strMsg;
        if (aresp.errCode == 0) {
            strMsg = NSLocalizedString(@"分享成功！", @"");
        }else{
            strMsg = NSLocalizedString(@"分享失败！", @"");
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [alert show];
    }else{
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{@"code":code};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatLoginCode" object:self userInfo:dic];
        }
    }
}


- (NSString*) doDevicePlatform{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    else if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    else if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    else if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    else if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    else if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    else if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    else if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    else if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    else if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    else if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    else if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    else if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    else if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    else if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    else if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    else if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    else if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    else if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    else if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    else if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    else if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    else if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    else if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    else if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    else if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    else if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    else if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    else if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}


@end
