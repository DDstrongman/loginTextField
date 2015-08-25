//
//  SetupView.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/14.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "SetupView.h"

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
    searchViewController.searchBar.layer.borderWidth = 0.5;
    searchViewController.searchBar.layer.borderColor = lightGrayBackColor.CGColor;
    for (UIView *sb in [[searchViewController.searchBar subviews][0] subviews]) {
        if ([sb isKindOfClass:[UITextField class]]) {
            sb.layer.borderColor = themeColor.CGColor;
            sb.layer.borderWidth = 0.5;
            [sb viewWithRadis:10.0];
        }
    }
}

-(void)setupNavigationRightButton:(UINavigationController *)navigation RightButton:(UIButton *)rightButton{
    [navigation.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightButton]];
}

-(void)setupNavigationLeftButton:(UINavigationController *)navigation RightButton:(UIButton *)leftButton{
    [navigation.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
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

@end
