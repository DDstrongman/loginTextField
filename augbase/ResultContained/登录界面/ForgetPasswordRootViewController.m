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

@end

@implementation ForgetPasswordRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [_phoneNumberView.contentTextField addTarget:self action:@selector(confirmPhonenumber) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phoneNumberView];
    
    NSString *strURL = [NSString stringWithFormat:@"%@jcaptcha",Baseurl];
    NSURLRequest *re=[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    NSOperationQueue *op=[[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:re queue:op completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(),^{
            UIImage *img=[UIImage imageWithData:data];
        });
    }];
    
    
    _sendMessButton = [[UIButton alloc]init];
    [_sendMessButton addTarget:self action:@selector(RegistNumberView) forControlEvents:UIControlEventTouchUpInside];
    [_sendMessButton setTitle:NSLocalizedString(@"发送验证码", @"") forState:UIControlStateNormal];
    [_sendMessButton.layer setMasksToBounds:YES];
    [_sendMessButton.layer setCornerRadius:10.0];
    [self.view addSubview:_sendMessButton];
    
    
    //autolayout
    [_sendMessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(_phoneNumberView.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"忘记密码", @"");
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
#warning 加入获取验证码的手机交互
    //    NSString *url = [NSString stringWithFormat:@"%@user/signup/telephone_pre?telephone=%@&verifycode=%@",Baseurl,_phoneNumberView.contentTextField.text,_confirmNumberView.contentTextField.text];
    //    NSLog(@"url===%@",url);
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    //    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    //        NSLog(@"reponson===%@",source);
    //        int res=[[source objectForKey:@"res"] intValue];
    //        NSLog(@"res===%d",res);
    //        if (res == 0) {
    //            //请求完成
    //            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //            RegistNumberViewController *rgv = [story instantiateViewControllerWithIdentifier:@"registnumber"];
    //            rgv.phoneNumber = _phoneNumberView.contentTextField.text;
    //            [self.navigationController pushViewController:rgv animated:YES];
    //        }
    //        else{
    //
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"WEB端登录失败");
    //    }];
#warning  正式版本中使用上方的代码
    ForgetPasswordDetailViewController *fpwdv = [[ForgetPasswordDetailViewController alloc]init];
    [self.navigationController pushViewController:fpwdv animated:YES];
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
