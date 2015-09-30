//
//  LoginViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/1.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewLabelTextFieldView.h"

#import "WriteFileSupport.h"

@interface LoginViewController : UIViewController<ConnectXMPPDelegate>

@property (strong,nonatomic) ImageViewLabelTextFieldView *userNameView;
@property (strong,nonatomic) ImageViewLabelTextFieldView *passWordView;


@property (strong,nonatomic) UIButton *loginButton;
@property (strong,nonatomic) IBOutlet UIButton *thirdLoginButton;
//忘记密码
@property (nonatomic,strong) UIButton *forgetPassButton;


//@property (nonatomic,strong) XMPPSupportClass *loginXMPPSupport;


@end
