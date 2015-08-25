//
//  ForgetPasswordDetailViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/12.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewLabelTextFieldView.h"

@interface ForgetPasswordDetailViewController : UIViewController

//三个注册框，具体ui见老王的登录流程图
@property (nonatomic,strong) ImageViewLabelTextFieldView *registViewOne;
@property (nonatomic,strong) ImageViewLabelTextFieldView *registViewTwo;
@property (nonatomic,strong) ImageViewLabelTextFieldView *registViewThree;

@property (nonatomic) NSString *phoneNumber;

@property (nonatomic,strong) UIButton *finishButton;

@end
