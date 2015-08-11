//
//  LoginAndRegistViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/6/30.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistNumberViewController.h"
#import "ImageViewLabelTextFieldView.h"

@interface LoginAndRegistViewController : UIViewController


//键盘输入
@property (nonatomic,strong) ImageViewLabelTextFieldView *phoneNumberView;
//验证码输入框
@property (nonatomic,strong) ImageViewLabelTextFieldView *confirmNumberView;
//验证码显示按钮，点击则刷新验证码
@property (nonatomic,strong) UIButton *numberButton;

//发送验证码按钮
@property (nonatomic,strong) UIButton *sendMessButton;
@end
