//
//  RegistNumberViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/1.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewLabelTextFieldView.h"

@interface RegistNumberViewController : UIViewController

//三个注册框，具体ui见老王的登录流程图
@property (nonatomic,strong) ImageViewLabelTextFieldView *registViewOne;
@property (nonatomic,strong) ImageViewLabelTextFieldView *registViewTwo;
@property (nonatomic,strong) ImageViewLabelTextFieldView *registViewThree;
//底部输入图片验证码获取短信验证码的输入框
@property (nonatomic,strong) ImageViewLabelTextFieldView *inputNumberView;

@property (nonatomic) NSString *phoneNumber;

@property (nonatomic,strong) UIButton *finishButton;

//下方的服务条款和隐私协议
@property (nonatomic,strong) UIView *noticeView;

@property (nonatomic) BOOL isBlindWeChat;
@property (nonatomic,strong) NSString *unID;//微信授权id
@property (nonatomic,strong) NSData *headImageData;//微信返回头像数据流

@end
