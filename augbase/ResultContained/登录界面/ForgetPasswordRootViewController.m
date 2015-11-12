//
//  ForgetPasswordRootViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/12.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ForgetPasswordRootViewController.h"

#import "ForgetPasswordDetailViewController.h"

@interface ForgetPasswordRootViewController ()

{
    NSTimer *delayTimer;
    float countTime;
    
    UIButton *confirmButton;//获取图片验证码的按钮
    UIView *visualEffectView;//阴影view
    UIView *confirmImageView;//底部显示图片验证码的view
    NSString *sessionID;//获取图片验证码的时候获取一次sessionid，每次都刷新以保证是最新的
    
    UIButton *sendImageNumber;//显示图片验证码的按钮
}

@end

@implementation ForgetPasswordRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"忘记密码", @"");
    _sendMessButton.backgroundColor = grayBackColor;
    [_phoneNumberView.contentTextField becomeFirstResponder];
    if ([self isValidateMobile:_phoneNumberView.contentTextField.text]&&_confirmNumberView.contentTextField.text.length == 6) {
        _sendMessButton.userInteractionEnabled = YES;
        _sendMessButton.backgroundColor = themeColor;
    }else{
        _sendMessButton.userInteractionEnabled = NO;
        _sendMessButton.backgroundColor = grayBackColor;
    }
    confirmButton.userInteractionEnabled = NO;
}

-(void)loginView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 显示底部图片验证码的view
-(void)showConfirmImage:(UIButton *)sender{
    [self popSpringAnimationOut:confirmImageView];
    [self.view endEditing:YES];
}

-(void)confirmPhonenumber:(UITextField *)sender{
    if ([self isValidateMobile:_phoneNumberView.contentTextField.text]) {
        NSLog(@"手机号码通过验证");
        confirmButton.userInteractionEnabled = YES;
        confirmButton.backgroundColor = themeColor;
    }else{
        NSLog(@"手机号码未通过验证");
        confirmButton.userInteractionEnabled = NO;
        confirmButton.backgroundColor = grayBackColor;
    }
}

-(void)checkConfirmNumber:(UITextField *)sender{
    if ([self isValidateMobile:_phoneNumberView.contentTextField.text]&&_confirmNumberView.contentTextField.text.length == 6) {
        NSLog(@"手机号码通过验证");
        _sendMessButton.userInteractionEnabled = YES;
        _sendMessButton.backgroundColor = themeColor;
    }else{
        NSLog(@"手机号码未通过验证");
        _sendMessButton.userInteractionEnabled = NO;
        _sendMessButton.backgroundColor = grayBackColor;
    }
}

#pragma 输入手机号后获取验证码，需要加入判断手机号是否注册的网络交互事件,第一个为图片验证码，第二个为手机验证码
-(void)RegistNumberView{
    NSString *url = [NSString stringWithFormat:@"%@v2/captcha/sendSMS",Baseurl];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_inputNumberView.contentTextField.text forKey:@"verifycode"];
    [dic setObject:_phoneNumberView.contentTextField.text forKey:@"telephone"];
    [dic setObject:sessionID forKey:@"sessionId"];
    [dic setObject:@YES forKey:@"isResetPwd"];
    
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:url Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"res===%d",res);
        if (res == 0) {
#warning 加入倒计时，以后再说
            [self sendMessAgain];
        }else{
            [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)finishAll{
    NSString *url = [NSString stringWithFormat:@"%@v2/captcha/sms/check?tel=%@&smscode=%@",Baseurl,_phoneNumberView.contentTextField.text,_confirmNumberView.contentTextField.text];
    [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"res===%d",res);
        if (res == 0) {
            ForgetPasswordDetailViewController *fdv = [[ForgetPasswordDetailViewController alloc]init];
            fdv.phoneNumber = _phoneNumberView.contentTextField.text;
            fdv.confirmNumber = _confirmNumberView.contentTextField.text;
            [self.navigationController pushViewController:fdv animated:YES];
        }else{
            [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    //去登陆界面
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 120, 30)];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [loginButton setTitle:NSLocalizedString(@"已有账号登陆", @"") forState:UIControlStateNormal];
    [loginButton setTitleColor:themeColor forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:loginButton]];
#warning 调整向上距离用的参数
    int spaceRoom = 40;
    
    _phoneNumberView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 134-spaceRoom, ViewWidth-120+12, 50)];
    _phoneNumberView.contentTextField.placeholder = NSLocalizedString(@"请输入手机号码（11位）", @"");
    _phoneNumberView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    //    _phoneNumberView.contentTextField.textAlignment = NSTextAlignmentCenter;
    [_phoneNumberView.contentTextField addTarget:self action:@selector(confirmPhonenumber:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phoneNumberView];
    
    confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [confirmButton setImage:[UIImage imageNamed:@"goin_w"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(showConfirmImage:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.backgroundColor = grayBackColor;
    [confirmButton.layer setMasksToBounds:YES];
    [confirmButton.layer setCornerRadius:10.0];
    _confirmNumberView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 134-spaceRoom+50+5, ViewWidth-120+12, 50)];
    _confirmNumberView.contentTextField.placeholder = NSLocalizedString(@"短信验证码（6位）", @"");
    _confirmNumberView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    _confirmNumberView.contentTextField.rightView = confirmButton;
    _confirmNumberView.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    [_confirmNumberView.contentTextField addTarget:self action:@selector(checkConfirmNumber:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_confirmNumberView];
    
    _sendMessButton = [[UIButton alloc]init];
    [_sendMessButton addTarget:self action:@selector(finishAll) forControlEvents:UIControlEventTouchUpInside];
    [_sendMessButton setTitle:NSLocalizedString(@"确定", @"") forState:UIControlStateNormal];
    [_sendMessButton.layer setMasksToBounds:YES];
    [_sendMessButton.layer setCornerRadius:10.0];
    [self.view addSubview:_sendMessButton];
    
    [_sendMessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(_confirmNumberView.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];
    
    confirmImageView = [[UIView alloc]initWithFrame:CGRectMake(20, ViewHeight, ViewWidth-40, 150)];
    [self setupNumberView];
}

-(void)setupNumberView{
    confirmImageView = [[UIView alloc]initWithFrame:CGRectMake(20, ViewHeight, ViewWidth-40, 150)];
    [confirmImageView viewWithRadis:10.0];
    confirmImageView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    titleLabel.center = CGPointMake(confirmImageView.bounds.size.width/2, 20);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = NSLocalizedString(@"请输入图片中的验证码", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmImageView addSubview:titleLabel];
    _inputNumberView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(0, 0, confirmImageView.bounds.size.width-50, 50)];
    _inputNumberView.center = CGPointMake(confirmImageView.bounds.size.width/2, 60);
    _inputNumberView.contentTextField.placeholder = NSLocalizedString(@"请输入图片中的验证码", @"");
    _inputNumberView.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _inputNumberView.contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    sendImageNumber = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 30)];
    [sendImageNumber addTarget:self action:@selector(changeConfirmNumber:) forControlEvents:UIControlEventTouchUpInside];
    sendImageNumber.backgroundColor = themeColor;
    NSString *url = [NSString stringWithFormat:@"%@v2/captcha/png",Baseurl];
    [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            sessionID = [source objectForKey:@"sessionid"];
            NSString *strURL = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/captcha/%@",[source objectForKey:@"imgurl"]];
            NSURLRequest *re=[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
            NSOperationQueue *op=[[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:re queue:op completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                dispatch_async(dispatch_get_main_queue(),^{
                    UIImage *img=[UIImage imageWithData:data];
                    [sendImageNumber setBackgroundImage:img forState:UIControlStateNormal];
                });
            }];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [sendImageNumber viewWithRadis:10.0];
    _inputNumberView.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    _inputNumberView.contentTextField.rightView = sendImageNumber;
    [confirmImageView addSubview:_inputNumberView];
    UIButton *enSureButton = [[UIButton alloc]init];
    UIButton *cancelButton = [[UIButton alloc]init];
    [enSureButton setTitle:NSLocalizedString(@"确认", @"") forState:UIControlStateNormal];
    [enSureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [enSureButton addTarget:self action:@selector(enSureInput) forControlEvents:UIControlEventTouchUpInside];
    enSureButton.layer.borderWidth = 0.5;
    enSureButton.layer.borderColor = lightGrayBackColor.CGColor;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = lightGrayBackColor.CGColor;
    [confirmImageView addSubview:enSureButton];
    [confirmImageView addSubview:cancelButton];
    [enSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@45);
        make.width.mas_equalTo(cancelButton.mas_width);
        make.right.mas_equalTo(cancelButton.mas_left);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@45);
        make.width.mas_equalTo(enSureButton.mas_width);
        make.left.mas_equalTo(enSureButton.mas_right);
    }];
    
    [self.view addSubview:confirmImageView];
}

-(void)changeConfirmNumber:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"%@v2/captcha/png",Baseurl];
    [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            sessionID = [source objectForKey:@"sessionid"];
            NSString *strURL = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/captcha/%@",[source objectForKey:@"imgurl"]];
            NSURLRequest *re=[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
            NSOperationQueue *op=[[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:re queue:op completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                dispatch_async(dispatch_get_main_queue(),^{
                    UIImage *img=[UIImage imageWithData:data];
                    [sender setBackgroundImage:img forState:UIControlStateNormal];
                });
            }];
            NSLog(@"sessionID===%@",sessionID);
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)enSureInput{
    [self popSpringAnimationHidden:confirmImageView];
    [self RegistNumberView];
}

-(void)cancelInput{
    [self popSpringAnimationHidden:confirmImageView];
}


#pragma 底部view出现和隐藏
-(void)popSpringAnimationOut:(UIView *)targetView{
    visualEffectView = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view insertSubview:visualEffectView belowSubview:confirmImageView];
    
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(20,60,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
    
    NSString *url = [NSString stringWithFormat:@"%@v2/captcha/png",Baseurl];
    [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            sessionID = [source objectForKey:@"sessionid"];
            NSString *strURL = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/captcha/%@",[source objectForKey:@"imgurl"]];
            NSURLRequest *re=[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
            NSOperationQueue *op=[[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:re queue:op completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                dispatch_async(dispatch_get_main_queue(),^{
                    UIImage *img=[UIImage imageWithData:data];
                    [sendImageNumber setBackgroundImage:img forState:UIControlStateNormal];
                });
            }];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)tapvisualEffectView:(UIView *)sender{
    [self popSpringAnimationHidden:confirmImageView];
}

-(void)popSpringAnimationHidden:(UIView *)targetView{
    if (visualEffectView != nil) {
        [visualEffectView removeFromSuperview];
    }
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(20,ViewHeight,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
    
}

#pragma 再次发送验证码到手机
-(void)sendMessAgain{
    NSLog(@"需要再次调用发送验证码的函数");
    //倒计时
    countTime = countAgainNumber;
    [confirmButton setImage:nil forState:UIControlStateNormal];
    confirmButton.userInteractionEnabled = NO;
    confirmButton.backgroundColor = grayBackColor;
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumber) userInfo:nil repeats:YES];
}

-(void)countNumber{
    countTime--;
    //    _countTimeLabel.text = [NSString stringWithFormat:@"%@%d",@"重发倒计时:",(int)countTime];
    [confirmButton setTitle:[NSString stringWithFormat:@"%d",(int)countTime] forState:UIControlStateNormal];
    if (countTime == 0) {
        [delayTimer invalidate];
        delayTimer = nil;
        confirmButton.userInteractionEnabled = YES;
        confirmButton.backgroundColor = themeColor;
        [confirmButton setTitle:NSLocalizedString(@"", @"") forState:UIControlStateNormal];
        [confirmButton setImage:[UIImage imageNamed:@"goin_w"] forState:UIControlStateNormal];
    }
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (delayTimer != nil) {
        [delayTimer invalidate];
        delayTimer = nil;
    }
}

@end
