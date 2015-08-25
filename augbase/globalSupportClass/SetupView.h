//
//  SetupView.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/14.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetupView : NSObject

+(SetupView *) ShareInstance;

-(void)setupSearchbar:(UISearchController *)searchViewController;

-(void)setupNavigationRightButton:(UINavigationController *)navigation RightButton:(UIButton *)rightButton;

-(void)setupNavigationLeftButton:(UINavigationController *)navigation RightButton:(UIButton *)leftButton;

-(void)setupNavigationView:(UINavigationController *)navigation Image:(UIImage *)image;

-(void)showAlertView:(NSString *)message Title:(NSString *)title ViewController:(UIViewController *)controller;
@end
