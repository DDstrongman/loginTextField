//
//  LoginViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/1.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

{
    BOOL isRegisted;//判断是否注册过，注册过则自动填充手机号为账号（仅限为从注册界面跳过来）
    BOOL showPasswordOrNot;//判断是否显示明文密码
    UIButton *sectureButton;//密码框右边显示密码or not的按钮
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //去登陆界面
    UIButton *registButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 120, 30)];
    
    registButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    registButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registButton setTitle:NSLocalizedString(@"注册新用户", @"") forState:UIControlStateNormal];
    [registButton setTitleColor:themeColor forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(registView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:registButton]];
    
    _userNameView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 94, ViewWidth-120+12, 50)];
    _passWordView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 149, ViewWidth-120+12, 50)];
    [_userNameView.contentTextField addTarget:self action:@selector(ensurePhoneAndPassword) forControlEvents:UIControlEventEditingChanged];
    [_passWordView.contentTextField addTarget:self action:@selector(ensurePhoneAndPassword) forControlEvents:UIControlEventEditingChanged];
    
    sectureButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 14)];
    [sectureButton addTarget:self action:@selector(changeSecture) forControlEvents:UIControlEventTouchUpInside];
    [sectureButton setBackgroundImage:[UIImage imageNamed:@"not_visible"] forState:UIControlStateNormal];
    
    _passWordView.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    _passWordView.contentTextField.rightView = sectureButton;
    
    [self.view addSubview:_userNameView];
    [self.view addSubview:_passWordView];
    
    _loginButton = [[UIButton alloc]init];
    _loginButton.backgroundColor = grayBackColor;
    [_loginButton setTitle:NSLocalizedString(@"登录", @"") forState:UIControlStateNormal];
    [_loginButton viewWithRadis:10.0];
    [_loginButton addTarget:self action:@selector(gotoMainView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    //autolayout
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {        make.height.equalTo(@50);
        make.top.equalTo(_passWordView.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];
    
    _thirdLoginButton.layer.borderWidth = 1.0;
    _thirdLoginButton.layer.borderColor = themeColor.CGColor;
    [_thirdLoginButton setTintColor:themeColor];
    [_thirdLoginButton viewWithRadis:10.0];
}

-(void)gotoMainView{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *tabbarController = [story instantiateViewControllerWithIdentifier:@"tabbarmainview"];
    [self.navigationController pushViewController:tabbarController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTintColor:themeColor];
    //初始化
    //    [_userNameText becomeFirstResponder];
    _userNameView.contentTextField.placeholder = NSLocalizedString(@"手机号／用户名", @"");
    _userNameView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passWordView.contentTextField.placeholder = NSLocalizedString(@"密码", @"");
    _passWordView.contentTextField.secureTextEntry = YES;
    _passWordView.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    showPasswordOrNot = YES;
    _loginButton.userInteractionEnabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)ensurePhoneAndPassword{
    if (_passWordView.contentTextField.text.length>5&&[self isValidateMobile:_userNameView.contentTextField.text]) {
        _loginButton.userInteractionEnabled = YES;
        _loginButton.backgroundColor = themeColor;
    }else{
        _loginButton.userInteractionEnabled = NO;
        _loginButton.backgroundColor = grayBackColor;
    }
}

-(void)changeSecture{
    if (showPasswordOrNot) {
        _passWordView.contentTextField.secureTextEntry = NO;
        showPasswordOrNot = NO;
        [sectureButton setBackgroundImage:[UIImage imageNamed:@"visible"] forState:UIControlStateNormal];
    }else{
        _passWordView.contentTextField.secureTextEntry = YES;
        showPasswordOrNot = YES;
        [sectureButton setBackgroundImage:[UIImage imageNamed:@"not_visible"] forState:UIControlStateNormal];
    }
}

-(void)registView
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lgv = [story instantiateViewControllerWithIdentifier:@"loginAndRegist"];
    [self.navigationController pushViewController:lgv animated:YES];
}

-(IBAction)forgotPasswor:(id)sender{
    //加入点击忘记密码的事件
    NSLog(@"忘记密码");
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

@end
