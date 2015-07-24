//
//  RegistNumberViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/1.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "RegistNumberViewController.h"

@interface RegistNumberViewController ()

{
    NSTimer *delayTimer;
    float countTime;
    UIButton *twoRightButton; //第二个textfield的右边按钮，倒计时按钮
    UIButton *threeRightButton;//第三个textfield的右边按钮，密码显示与否的按钮
    BOOL showPasswordOrNot;//判断是否显示明文密码
}

@end

@implementation RegistNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _registViewOne = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 74, ViewWidth-120+12, 50)];
    _registViewTwo = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 129, ViewWidth-120+12, 50)];
    _registViewThree = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 184, ViewWidth-120+12, 50)];
    
    _registViewOne.contentTextField.placeholder = NSLocalizedString(@"手机号码", @"");
    _registViewTwo.contentTextField.placeholder = NSLocalizedString(@"验证码（4位）", @"");
    _registViewThree.contentTextField.placeholder = NSLocalizedString(@"密码", @"");
    
    twoRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    twoRightButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [twoRightButton addTarget:self action:@selector(sendMessAgain) forControlEvents:UIControlEventTouchUpInside];
    [twoRightButton.layer setMasksToBounds:YES];
    [twoRightButton.layer setCornerRadius:10.0];
    
    UIView *threeRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    threeRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 14)];
    threeRightButton.center = CGPointMake(20, 15);
    [threeRightButton addTarget:self action:@selector(changeSecture) forControlEvents:UIControlEventTouchUpInside];
    [threeRightButton setBackgroundImage:[UIImage imageNamed:@"not_visible"] forState:UIControlStateNormal];
    [threeRightView addSubview:threeRightButton];
    
    
    _registViewTwo.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    _registViewTwo.contentTextField.rightView = twoRightButton;
    _registViewTwo.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    _registViewThree.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    _registViewThree.contentTextField.rightView = threeRightView;
    _registViewThree.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_registViewTwo.contentTextField addTarget:self action:@selector(ensureMessAndPass) forControlEvents:UIControlEventEditingChanged];
    [_registViewThree.contentTextField addTarget:self action:@selector(ensureMessAndPass) forControlEvents:UIControlEventEditingChanged];
    
    
    _finishButton = [[UIButton alloc]init];
    [_finishButton addTarget:self action:@selector(gotoTemp) forControlEvents:UIControlEventTouchUpInside];
    [_finishButton setTitle:NSLocalizedString(@"注册", @"") forState:UIControlStateNormal];
    [_finishButton.layer setMasksToBounds:YES];
    [_finishButton.layer setCornerRadius:10.0];
    
    _noticeView = [[UIView alloc]init];
    UIButton *serviceNoticeButton = [[UIButton alloc]init];
    [serviceNoticeButton setTitle:NSLocalizedString(@"<服务条款>", @"") forState:UIControlStateNormal];
    [serviceNoticeButton setTitleColor:themeColor forState:UIControlStateNormal];
    serviceNoticeButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [serviceNoticeButton addTarget:self action:@selector(showService) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *privateNoticeButton = [[UIButton alloc]init];
    [privateNoticeButton setTitle:NSLocalizedString(@"<隐私条款>", @"") forState:UIControlStateNormal];
    [privateNoticeButton setTitleColor:themeColor forState:UIControlStateNormal];
    privateNoticeButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    UILabel  *noticeLabel = [[UILabel alloc]init];
    noticeLabel.text = NSLocalizedString(@"点击注册，表示您同意", @"");
    noticeLabel.font = [UIFont systemFontOfSize:11.0];
    noticeLabel.textColor = grayLabelColor;
    [_noticeView addSubview:noticeLabel];
    [_noticeView addSubview:serviceNoticeButton];
    [_noticeView addSubview:privateNoticeButton];
    
    //测试用
//    _registViewOne.backgroundColor = themeColor;
//    _registViewTwo.backgroundColor = themeColor;
//    _registViewThree.backgroundColor = themeColor;
//    _noticeView.backgroundColor = themeColor;
    
    [self.view addSubview:_registViewOne];
    [self.view addSubview:_registViewTwo];
    [self.view addSubview:_registViewThree];
    [self.view addSubview:_finishButton];
    [self.view addSubview:_noticeView];
    
    
    //autolayout
    [_finishButton mas_makeConstraints:^(MASConstraintMaker *make) {        make.height.equalTo(@50);
        make.top.equalTo(_registViewThree.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
//        make.right.equalTo(_contentTextField.mas_left).with.offset(-5);
//        make.centerY.mas_equalTo(_contentTextField.mas_centerY);
    }];
    [_noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(_finishButton.mas_bottom).with.offset(15);
        make.width.equalTo(@240);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(_noticeView.mas_top).with.offset(0);
        make.left.equalTo(_noticeView.mas_left).with.offset(0);
        make.right.equalTo(serviceNoticeButton.mas_left).with.offset(-3);
    }];
    [serviceNoticeButton mas_makeConstraints:^(MASConstraintMaker *make) {        make.height.equalTo(@20);
        make.top.equalTo(_noticeView.mas_top).with.offset(0);
        make.left.equalTo(noticeLabel.mas_right).with.offset(3);
        make.right.equalTo(privateNoticeButton.mas_left).with.offset(-3);
    }];
    [privateNoticeButton mas_makeConstraints:^(MASConstraintMaker *make) {        make.height.equalTo(@20);
        make.top.equalTo(_noticeView.mas_top).with.offset(0);
        make.right.equalTo(_noticeView.mas_right).with.offset(0);
        make.left.equalTo(serviceNoticeButton.mas_right).with.offset(3);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    //倒计时
    countTime = countAgainNumber;
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumber) userInfo:nil repeats:YES];
    
    twoRightButton.userInteractionEnabled = NO;
    twoRightButton.backgroundColor = grayBackColor;
    showPasswordOrNot = YES;
    _registViewOne.titleLabel.hidden = NO;
    _registViewOne.titleLabel.text = NSLocalizedString(@"您的手机号码是:", @"");
    _registViewOne.titleLabel.textColor = grayLabelColor;
    _registViewOne.contentTextField.userInteractionEnabled = NO;
    _registViewOne.contentTextField.text = _phoneNumber;
    [_registViewTwo.contentTextField becomeFirstResponder];
    _registViewThree.contentTextField.secureTextEntry = YES;
    
    NSLog(@"仍需要加入验证码的判断，网络通讯的方式");
    if (_registViewTwo.contentTextField.text.length == ensureMass&&_registViewThree.contentTextField.text.length>5) {
        _finishButton.userInteractionEnabled = YES;
        _finishButton.backgroundColor = themeColor;
    }else{
        _finishButton.userInteractionEnabled = NO;
        _finishButton.backgroundColor = grayBackColor;
    }
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (delayTimer != nil) {
        [delayTimer invalidate];
        delayTimer = nil;
    }
}

#pragma 判断验证码和密码长度是否通过
-(void)ensureMessAndPass{
    NSLog(@"仍需要加入验证码的判断，网络通讯的方式");
    if (_registViewTwo.contentTextField.text.length == ensureMass&&_registViewThree.contentTextField.text.length>5) {
        _finishButton.userInteractionEnabled = YES;
        _finishButton.backgroundColor = themeColor;
    }else{
        _finishButton.userInteractionEnabled = NO;
        _finishButton.backgroundColor = grayBackColor;
    }
}

#pragma 显示服务条款等
-(void)showService{
    NSLog(@"显示服务条款");
}

#pragma 显示密码与否
-(void)changeSecture{
    if (showPasswordOrNot) {
        _registViewThree.contentTextField.secureTextEntry = NO;
        showPasswordOrNot = NO;
        [threeRightButton setBackgroundImage:[UIImage imageNamed:@"visible"] forState:UIControlStateNormal];
    }else{
         _registViewThree.contentTextField.secureTextEntry = YES;
        showPasswordOrNot = YES;
        [threeRightButton setBackgroundImage:[UIImage imageNamed:@"not_visible"] forState:UIControlStateNormal];
    }
}

#pragma 跳转注册完后的界面
-(void)gotoTemp{
    NSLog(@"需要加入验证码的判断");
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *ftui = [story instantiateViewControllerWithIdentifier:@"firsttimeuserinfo"];
    [self.navigationController pushViewController:ftui animated:YES];
}

#pragma 再次发送验证码到手机
-(void)sendMessAgain{
    NSLog(@"需要再次调用发送验证码的函数");
    //倒计时
    countTime = countAgainNumber;
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumber) userInfo:nil repeats:YES];
    twoRightButton.userInteractionEnabled = NO;
    twoRightButton.backgroundColor = grayBackColor;
}

-(void)countNumber{
    countTime--;
//    _countTimeLabel.text = [NSString stringWithFormat:@"%@%d",@"重发倒计时:",(int)countTime];
    [twoRightButton setTitle:[NSString stringWithFormat:@"%d",(int)countTime] forState:UIControlStateNormal];
    if (countTime == 0) {
        [delayTimer invalidate];
        delayTimer = nil;
        twoRightButton.userInteractionEnabled = YES;
        twoRightButton.backgroundColor = themeColor;
        [twoRightButton setTitle:NSLocalizedString(@"重发", @"") forState:UIControlStateNormal];
    }
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
