//
//  RegistNumberViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/1.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "RegistNumberViewController.h"

#import "FirstTimeUserInfoViewController.h"

@interface RegistNumberViewController ()

{
    NSTimer *delayTimer;
    float countTime;
    UIButton *twoRightButton; //第二个textfield的右边按钮，倒计时按钮
    UIButton *threeRightButton;//第三个textfield的右边按钮，密码显示与否的按钮
    BOOL showPasswordOrNot;//判断是否显示明文密码
    
    UIView *getNumberView;//获取验证码的view
    UIView *visualEffectView;//底部模糊的view
}

@end

@implementation RegistNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _registViewOne = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 74, ViewWidth-120+12, 50)];
    _registViewTwo = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 129, ViewWidth-120+12, 50)];
    _registViewThree = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 184, ViewWidth-120+12, 50)];
    
    _registViewOne.contentTextField.placeholder = NSLocalizedString(@"手机号码/邮箱账号", @"");
    _registViewTwo.contentTextField.placeholder = NSLocalizedString(@"验证码（6位）", @"");
    _registViewThree.contentTextField.placeholder = NSLocalizedString(@"密码(至少6位)", @"");
    
    twoRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    twoRightButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [twoRightButton addTarget:self action:@selector(showImageView) forControlEvents:UIControlEventTouchUpInside];
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
    _registViewThree.contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [_registViewTwo.contentTextField addTarget:self action:@selector(ensureMessAndPass) forControlEvents:UIControlEventEditingChanged];
    [_registViewThree.contentTextField addTarget:self action:@selector(ensureMessAndPass) forControlEvents:UIControlEventEditingChanged];
    
    
    _finishButton = [[UIButton alloc]init];
    [_finishButton addTarget:self action:@selector(finishRegist) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self.view addSubview:_registViewOne];
    [self.view addSubview:_registViewTwo];
    [self.view addSubview:_registViewThree];
    [self.view addSubview:_finishButton];
    [self.view addSubview:_noticeView];
    
    //autolayout
    [_finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(_registViewThree.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
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
    self.title = NSLocalizedString(@"注册", @"");
    //去登陆界面
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 120, 30)];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [loginButton setTitle:NSLocalizedString(@"已有账号登陆", @"") forState:UIControlStateNormal];
    [loginButton setTitleColor:themeColor forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:loginButton]];
    
    [self setupNumberView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = themeColor;
    //倒计时
    countTime = countAgainNumber;
    [twoRightButton setImage:[UIImage imageNamed:@"goin_w"] forState:UIControlStateNormal];
//    delayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumber) userInfo:nil repeats:YES];
    
    twoRightButton.userInteractionEnabled = NO;
    twoRightButton.backgroundColor = grayBackColor;
    
    showPasswordOrNot = YES;
    _registViewOne.titleLabel.hidden = NO;
    _registViewOne.titleLabel.text = NSLocalizedString(@"您的手机号码是:", @"");
    _registViewOne.titleLabel.textColor = grayLabelColor;
    _registViewOne.contentTextField.userInteractionEnabled = YES;
    _registViewOne.contentTextField.text = _phoneNumber;
    [_registViewOne.contentTextField addTarget:self action:@selector(ensurePhoneCount:) forControlEvents:UIControlEventEditingChanged];
    [_registViewOne.contentTextField becomeFirstResponder];
    _registViewThree.contentTextField.secureTextEntry = YES;
    
    NSLog(@"仍需要加入验证码的判断，网络通讯的方式");
    if (_registViewTwo.contentTextField.text.length == ensureMass&&_registViewThree.contentTextField.text.length>5) {
        _finishButton.userInteractionEnabled = YES;
        _finishButton.backgroundColor = themeColor;
    }else{
        _finishButton.userInteractionEnabled = NO;
        _finishButton.backgroundColor = grayBackColor;
    }
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

#pragma 跳转注册完后的界面,但是不是直接跳入showallmessage界面，而是引导到第一次登录加好友界面
-(void)finishRegist{
#warning 加入注册网络通讯
    NSString *url = [NSString stringWithFormat:@"%@user/signup/tel?username=%@&password=%@&tel=%@&verificationCode=%@&role=%d&clienttype=%d",Baseurl,_registViewOne.contentTextField.text,_registViewThree.contentTextField.text,_registViewOne.contentTextField.text,_registViewTwo.contentTextField.text,0,0];
    NSLog(@"注册url === %@",url);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:_registViewOne.contentTextField.text forKey:@"userName"];
    [user setObject:_registViewThree.contentTextField.text forKey:@"userPassword"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"reponson===%@",source);
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"res===%d",res);
        if (res == 0) {
            //请求完成
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *ftui = [story instantiateViewControllerWithIdentifier:@"firsttimeuserinfo"];
            [self.navigationController pushViewController:ftui animated:YES];
        }
        else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败");
    }];
}
#pragma 显示底部图片验证码的view
-(void)showImageView{
    [self popSpringAnimationOut:getNumberView];
    [self.view endEditing:YES];
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

-(void)setupNumberView{
    getNumberView = [[UIView alloc]initWithFrame:CGRectMake(20, ViewHeight, ViewWidth-40, 150)];
    [getNumberView viewWithRadis:10.0];
    getNumberView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    titleLabel.center = CGPointMake(getNumberView.bounds.size.width/2, 20);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = NSLocalizedString(@"请输入图片中的验证码", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [getNumberView addSubview:titleLabel];
    _inputNumberView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(0, 0, getNumberView.bounds.size.width-50, 50)];
    _inputNumberView.center = CGPointMake(getNumberView.bounds.size.width/2, 60);
    _inputNumberView.contentTextField.placeholder = NSLocalizedString(@"请输入图片中的验证码", @"");
    _inputNumberView.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _inputNumberView.contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIButton *sendImageNumber = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 30)];
    [sendImageNumber addTarget:self action:@selector(changeConfirmNumber:) forControlEvents:UIControlEventTouchUpInside];
    sendImageNumber.backgroundColor = themeColor;
    NSString *strURL = [NSString stringWithFormat:@"%@jcaptcha",Baseurl];
    NSURLRequest *re=[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    NSOperationQueue *op=[[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:re queue:op completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(),^{
            UIImage *img=[UIImage imageWithData:data];
            [sendImageNumber setBackgroundImage:img forState:UIControlStateNormal];
        });
    }];
    [sendImageNumber viewWithRadis:10.0];
    _inputNumberView.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    _inputNumberView.contentTextField.rightView = sendImageNumber;
    [getNumberView addSubview:_inputNumberView];
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
    [getNumberView addSubview:enSureButton];
    [getNumberView addSubview:cancelButton];
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
    
    [self.view addSubview:getNumberView];
}

-(void)enSureInput{
    [self popSpringAnimationHidden:getNumberView];
    [self RegistNumberView];
}

-(void)cancelInput{
    [self popSpringAnimationHidden:getNumberView];
}

-(void)ensurePhoneCount:(UITextField *)sender{
    if ([self isValidateMobile:sender.text]) {
        twoRightButton.backgroundColor = themeColor;
        twoRightButton.userInteractionEnabled = YES;
    }else{
        twoRightButton.backgroundColor = grayBackColor;
        twoRightButton.userInteractionEnabled = NO;
    }
}

#pragma 底部view出现和隐藏
-(void)popSpringAnimationOut:(UIView *)targetView{
    visualEffectView = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view insertSubview:visualEffectView belowSubview:getNumberView];
    
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
    
}

-(void)tapvisualEffectView:(UIView *)sender{
    [self popSpringAnimationHidden:getNumberView];
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

/*邮箱验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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

-(void)loginView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeConfirmNumber:(UIButton *)sender{
    NSString *strURL = [NSString stringWithFormat:@"%@jcaptcha",Baseurl];
    NSURLRequest *re=[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    NSOperationQueue *op=[[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:re queue:op completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(),^{
            UIImage *img=[UIImage imageWithData:data];
            [sender setBackgroundImage:img forState:UIControlStateNormal];
        });
    }];
}

#pragma 输入手机号后获取验证码，需要加入判断手机号是否注册的网络交互事件
-(void)RegistNumberView{
    NSString *url = [NSString stringWithFormat:@"%@user/signup/telephone_pre?telephone=%@&verifycode=%@",Baseurl,_registViewOne.contentTextField.text,_inputNumberView.contentTextField.text];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"reponson===%@",source);
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"res===%d",res);
        if (res == 0) {
            //请求完成
            
        }else if(res == 17){
            [[SetupView ShareInstance] showAlertView:NSLocalizedString(@"该手机号已注册", @"") Title:NSLocalizedString(@"手机号已注册", @"") ViewController:self];
        }else if (res == 29){
            [[SetupView ShareInstance] showAlertView:NSLocalizedString(@"验证码输入错误", @"") Title:NSLocalizedString(@"验证码错误", @"") ViewController:self];
        }
        else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败");
    }];
}

@end
