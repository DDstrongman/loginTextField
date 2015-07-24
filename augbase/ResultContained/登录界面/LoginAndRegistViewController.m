//
//  LoginAndRegistViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/6/30.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "LoginAndRegistViewController.h"

@interface LoginAndRegistViewController ()


@end

@implementation LoginAndRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //去登陆界面
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 120, 30)];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [loginButton setTitle:NSLocalizedString(@"已有账号登陆", @"") forState:UIControlStateNormal];
    [loginButton setTitleColor:themeColor forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:loginButton]];
    
    _phoneNumberView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 134, ViewWidth-120+12, 50)];
    _phoneNumberView.contentTextField.placeholder = NSLocalizedString(@"请输入手机号码（11位）", @"");
    _phoneNumberView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
//    _phoneNumberView.contentTextField.textAlignment = NSTextAlignmentCenter;
    [_phoneNumberView.contentTextField addTarget:self action:@selector(confirmPhonenumber) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phoneNumberView];
    
    
    _sendMessButton = [[UIButton alloc]init];
    [_sendMessButton addTarget:self action:@selector(RegistNumberView) forControlEvents:UIControlEventTouchUpInside];
    [_sendMessButton setTitle:NSLocalizedString(@"发送验证码", @"") forState:UIControlStateNormal];
    [_sendMessButton.layer setMasksToBounds:YES];
    [_sendMessButton.layer setCornerRadius:10.0];
    [self.view addSubview:_sendMessButton];
    
    //autolayout
    [_sendMessButton mas_makeConstraints:^(MASConstraintMaker *make) {        make.height.equalTo(@50);
        make.top.equalTo(_phoneNumberView.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    _sendMessButton.backgroundColor = grayBackColor;
    [_phoneNumberView.contentTextField becomeFirstResponder];
    if ([self isValidateMobile:_phoneNumberView.contentTextField.text]) {
        _sendMessButton.userInteractionEnabled = YES;
        _sendMessButton.backgroundColor = themeColor;
    }else{
        _sendMessButton.userInteractionEnabled = NO;
        _sendMessButton.backgroundColor = grayBackColor;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)loginView
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)confirmPhonenumber{
    if ([self isValidateMobile:_phoneNumberView.contentTextField.text]) {
        NSLog(@"手机号码通过验证");
        _sendMessButton.userInteractionEnabled = YES;
        _sendMessButton.backgroundColor = themeColor;
    }else{
        NSLog(@"手机号码未通过验证");
        _sendMessButton.userInteractionEnabled = NO;
        _sendMessButton.backgroundColor = grayBackColor;
        
    }
}

#pragma 输入手机号后获取验证码，需要加入判断手机号是否注册的网络交互事件
-(void)RegistNumberView{
    NSLog(@"获取验证码，手机号需要网络验证");
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistNumberViewController *rgv = [story instantiateViewControllerWithIdentifier:@"registnumber"];
    rgv.phoneNumber = _phoneNumberView.contentTextField.text;
    [self.navigationController pushViewController:rgv animated:YES];
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

/*车牌号验证 MODIFIED BY HELENSONG*/
BOOL validateCarNo(NSString* carNo)
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma 内存警告，无卵用
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
