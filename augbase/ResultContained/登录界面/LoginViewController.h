//
//  LoginViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/1.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewLabelTextFieldView.h"

@interface LoginViewController : UIViewController

@property (strong,nonatomic) ImageViewLabelTextFieldView *userNameView;
@property (strong,nonatomic) ImageViewLabelTextFieldView *passWordView;


@property (strong,nonatomic) UIButton *loginButton;
@property (strong,nonatomic) IBOutlet UIButton *thirdLoginButton;


@end
