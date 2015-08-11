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

#import "LoginViewController.h"
//#import "ShowAllMessageViewController.h"

@interface AppDelegate ()

{
    BOOL NotFirstTimeLogin;//no为初次登录，yes则不是
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginview"];
    UIViewController *showMessViewController = [story instantiateViewControllerWithIdentifier:@"tabbarmainview"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NotFirstTimeLogin = [defaults stringForKey:@"NotFirstTime"];//no为初次登录，yes则不是
    RZTransitionsNavigationController* rootNavController;
    if (NotFirstTimeLogin) {
        //已经登录过了
        rootNavController = [[RZTransitionsNavigationController alloc] initWithRootViewController:showMessViewController];
    }else{
        rootNavController = [[RZTransitionsNavigationController alloc] initWithRootViewController:loginViewController];
        [[DBManager ShareInstance] creatDatabase:DBName];
        [[DBManager ShareInstance] closeDB];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootNavController  ;
    [self.window makeKeyAndVisible];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
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
    [[XMPPSupportClass ShareInstance] connect:[NSString stringWithFormat:@"%@@%@",testMineJID,httpServer]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[XMPPSupportClass ShareInstance] disconnect];
}

@end
