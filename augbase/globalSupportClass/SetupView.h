//
//  SetupView.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/14.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface SetupView : NSObject

@property (nonatomic,strong) MBProgressHUD *HUD;

+(SetupView *) ShareInstance;

-(void)setupSearchbar:(UISearchController *)searchViewController;

-(void)setupNavigationRightButton:(UIViewController *)viewController RightButton:(UIButton *)rightButton;

-(void)setupNavigationLeftButton:(UIViewController *)viewController RightButton:(UIButton *)leftButton;

-(void)setupNavigationView:(UINavigationController *)navigation Image:(UIImage *)image;

-(void)showAlertView:(NSString *)message Title:(NSString *)title ViewController:(UIViewController *)controller;
-(void)showAlertViewOneButton:(NSString *)message Title:(NSString *)title ViewController:(UIViewController *)controller;

-(void)showAlertView:(int)res Hud:(MBProgressHUD *)HUD ViewController:(UIViewController *)controller;

-(void)showHUD:(UIViewController *)viewController Title:(NSString *)title;//

-(void)hideHUD;//

- (NSString*) doDevicePlatform;

@end
