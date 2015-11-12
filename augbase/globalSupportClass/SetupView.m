//
//  SetupView.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/14.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "SetupView.h"
#import "sys/sysctl.h"


@implementation SetupView

+(SetupView *) ShareInstance{
    static SetupView *sharedSetupViewInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSetupViewInstance = [[self alloc] init];
    });
    return sharedSetupViewInstance;
}

-(void)setupSearchbar:(UISearchController *)searchViewController{
    searchViewController.searchBar.backgroundColor = [UIColor whiteColor];
    searchViewController.searchBar.backgroundImage = [UIImage imageNamed:@"white"];
//    searchViewController.searchBar.layer.borderWidth = 0.5;
//    searchViewController.searchBar.layer.borderColor = lightGrayBackColor.CGColor;
    [searchViewController.searchBar makeInsetShadowWithRadius:0.5 Color:lightGrayBackColor Directions:[NSArray arrayWithObjects:@"bottom", nil]];
    for (UIView *sb in [[searchViewController.searchBar subviews][0] subviews]) {
        if ([sb isKindOfClass:[UITextField class]]) {
            sb.layer.borderColor = themeColor.CGColor;
            sb.layer.borderWidth = 0.5;
            [sb viewWithRadis:10.0];
        }
    }
}

-(void)setupNavigationRightButton:(UIViewController *)viewController RightButton:(UIButton *)rightButton{
    [viewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightButton]];
}

-(void)setupNavigationLeftButton:(UIViewController *)viewController RightButton:(UIButton *)leftButton{
    [viewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
}

-(void)setupNavigationView:(UINavigationController *)navigation Image:(UIImage *)image{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    navigation.navigationBarHidden = NO;
#warning 去掉navigationbar下划线
    UINavigationBar *navigationBar = navigation.navigationBar;
    [navigationBar setBackgroundImage:image
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    navigation.navigationBar.barStyle = UIBaselineAdjustmentNone;
    
    [navigation.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:themeColor,NSForegroundColorAttributeName,nil]];
    navigation.navigationBar.tintColor = themeColor;
    [navigation.navigationBar setBackgroundImage:image forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
}

-(void)showAlertView:(NSString *)message Title:(NSString *)title ViewController:(UIViewController *)controller{
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:title message:message delegate:controller cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:NSLocalizedString(@"取消", @""), nil];
    [showAlert show];
}

-(void)showAlertViewOneButton:(NSString *)message Title:(NSString *)title ViewController:(UIViewController *)controller{
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:title message:message delegate:controller cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
    [showAlert show];
}

-(void)showHUdAlertView:(NSString *)message Title:(NSString *)title ViewController:(UIViewController *)controller{
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:title message:message delegate:controller cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
    [showAlert show];
}


-(void)showAlertView:(int)res Hud:(MBProgressHUD *)HUD ViewController:(UIViewController *)controller{
    [_HUD hide:YES];
    if (res == 1){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"输入数据出错", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 2){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"小易在开小差，稍等一会儿", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 3){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"小易在开小差，稍等一会儿", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 4){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"用户不存在，先花30秒注册下吧!", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 5){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"您的医生账户正在审核中…", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 6){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"用户名太抢手，换一个", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 7){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"该邮箱已被注册", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 8){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"用户名或密码不正确", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 9){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"超时", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 10){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"小易在开小差，稍等一会儿", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 11){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"小易在开小差，稍等一会儿", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 12){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"小易在开小差，稍等一会儿", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 13){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"小易在开小差，稍等一会儿", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 14){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"小易在开小差，稍等一会儿", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 15){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"暂无数据", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 16){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"推送还在路上", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 17){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"验证码出错", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 18){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"该手机号已被注册", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 19){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"验证码不正确", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 20){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"用户验证失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 21){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"数据迁移失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 22){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"用户编号和预留邮箱不一致", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 23){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"用户编号和预留电话号码不一致", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 24){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"二维码不属于战友23  ？", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 25){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"二维码已用", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 26){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"TA已经是你的好友啦", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 27){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"小易在开小差，稍等一会儿", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 28){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"小易在开小差，稍等一会儿", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 29){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"验证码已用完，请关注“易诊”微信订阅号索取新验证码", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 30){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"验证码填错啦，再试一遍吧=)", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 31){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"生成Access Code失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 32){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"生成signature失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 33){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"get User失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 34){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"账户出错，请尽快联系“易诊”微信订阅号", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 35){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"获取消息失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 36){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"无法发送消息", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 37){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"获取指标信息失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 38){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"排序失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 39){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"搜索医生失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 40){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"邀请失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 41){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"获取疾病信息失败", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 42){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"未知错误", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 43){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"TA已经是你的好友啦", @"") ViewController:controller];
        [HUD hide:YES];
    }else if (res == 44){
        [self showHUdAlertView:NSLocalizedString(@"", @"") Title:NSLocalizedString(@"资料未完善", @"") ViewController:controller];
        [HUD hide:YES];
    }
}

-(void)showHUD:(UIViewController *)viewController Title:(NSString *)title{
    _HUD = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    
    //常用的设置
    //小矩形的背景色
    _HUD.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];//背景色
    //显示的文字
    _HUD.labelText = title;
    //是否有庶罩
    _HUD.dimBackground = NO;
}

-(void)hideHUD{
    [_HUD hide:YES];
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
