//
//  ForgetPasswordRootViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/12.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageViewLabelTextFieldView.h"

@interface ForgetPasswordRootViewController : UIViewController

//键盘输入
@property (nonatomic,strong) ImageViewLabelTextFieldView *phoneNumberView;

//发送验证码按钮
@property (nonatomic,strong) UIButton *sendMessButton;

@end
