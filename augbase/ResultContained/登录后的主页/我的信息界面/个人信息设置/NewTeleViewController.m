//
//  NewTeleViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "NewTeleViewController.h"

#import "ImageViewLabelTextFieldView.h"

@interface NewTeleViewController ()

{
    ImageViewLabelTextFieldView *newTele;
    ImageViewLabelTextFieldView *confirmNumber;
    ImageViewLabelTextFieldView *inputNumberView;
    UIButton *getPicButton;//获取图片验证码
    UIButton *finishButton;//完成修改密码
    
    UIView *getNumberView;//底部输入验证码的view
    UIView *visualEffectView;//模糊的view
}

@end

@implementation NewTeleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)finishChangeTele:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"%@user/edit",Baseurl];
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSString *yzuid = [users objectForKey:@"userUID"];
    
    NSString *yztoken = [users objectForKey:@"userToken"];
    
    url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&tel=%@&verificationCode=%@",url,yzuid,yztoken,newTele.contentTextField.text,confirmNumber.contentTextField.text];
    [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            [_editTeleResultDele editTeleResult:YES];
        }else{
            [_editTeleResultDele editTeleResult:NO];
            [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_editTeleResultDele editTeleResult:NO];
    }];
}

-(void)confirmIsTele:(UITextField *)sender{
    if ([self isValidateMobile:newTele.contentTextField.text]&&![sender.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userTele"]]) {
        getPicButton.backgroundColor = themeColor;
        getPicButton.userInteractionEnabled = YES;
    }else{
        getPicButton.backgroundColor = grayBackColor;
        getPicButton.userInteractionEnabled = NO;
    }
}

-(void)confirmAllMess:(UITextField *)sender{
    if ([self isValidateMobile:newTele.contentTextField.text]&&sender.text.length>5) {
        finishButton.backgroundColor = themeColor;
        finishButton.userInteractionEnabled = YES;
    }else{
        finishButton.backgroundColor = grayBackColor;
        finishButton.userInteractionEnabled = NO;
    }
}

-(void)getConfirmNumber:(UIButton *)sender{
    [self popSpringAnimationOut:getNumberView];
}

-(void)setupView{
    self.title = NSLocalizedString(@"更换手机号", @"");
    self.view.backgroundColor = grayBackgroundLightColor;
    newTele = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 50, ViewWidth-120, 50)];
    newTele.contentTextField.placeholder = NSLocalizedString(@"新手机号", @"");
    newTele.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    [newTele.contentTextField addTarget:self action:@selector(confirmIsTele:) forControlEvents:UIControlEventEditingChanged];
    
    confirmNumber = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 50+50+5, ViewWidth-120, 50)];
    confirmNumber.contentTextField.placeholder = NSLocalizedString(@"手机验证码", @"");
    getPicButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30, 30)];
    getPicButton.userInteractionEnabled = NO;
    [getPicButton addTarget:self action:@selector(getConfirmNumber:) forControlEvents:UIControlEventTouchUpInside];
    getPicButton.backgroundColor = grayBackColor;
    [getPicButton viewWithRadis:10.0];
    [getPicButton setImage:[UIImage imageNamed:@"goin_w"] forState:UIControlStateNormal];
    confirmNumber.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    confirmNumber.contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    confirmNumber.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    confirmNumber.contentTextField.rightView = getPicButton;
    [confirmNumber.contentTextField addTarget:self action:@selector(confirmAllMess:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:newTele];
    [self.view addSubview:confirmNumber];
    
    finishButton = [[UIButton alloc]init];
    finishButton.backgroundColor = grayBackColor;
    [finishButton setTitle:NSLocalizedString(@"完成", @"") forState:UIControlStateNormal];
    [finishButton viewWithRadis:10.0];
    [finishButton addTarget:self action:@selector(finishChangeTele:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    //autolayout
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(confirmNumber.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];
    
    [self setupNumberView];
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
    inputNumberView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(0, 0, getNumberView.bounds.size.width-50, 50)];
    inputNumberView.center = CGPointMake(getNumberView.bounds.size.width/2, 60);
    inputNumberView.contentTextField.placeholder = NSLocalizedString(@"请输入图片中的验证码", @"");
    inputNumberView.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    inputNumberView.contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
    inputNumberView.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    inputNumberView.contentTextField.rightView = sendImageNumber;
    [getNumberView addSubview:inputNumberView];
    UIButton *enSureButton = [[UIButton alloc]init];
    UIButton *cancelButton = [[UIButton alloc]init];
    [enSureButton setTitle:NSLocalizedString(@"确认", @"") forState:UIControlStateNormal];
    [enSureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [enSureButton addTarget:self action:@selector(confirmInput:) forControlEvents:UIControlEventTouchUpInside];
    enSureButton.layer.borderWidth = 0.5;
    enSureButton.layer.borderColor = lightGrayBackColor.CGColor;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelInput:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)setupData{
    
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

-(void)confirmInput:(UIButton *)sender{
    [self popSpringAnimationHidden:getNumberView];
    [self RegistNumberView];
}

-(void)cancelInput:(UIButton *)sender{
    [self popSpringAnimationHidden:getNumberView];
}

#pragma 输入手机号后获取验证码，需要加入判断手机号是否注册的网络交互事件
-(void)RegistNumberView{
#warning 加入获取验证码的手机交互
    NSString *url = [NSString stringWithFormat:@"%@user/signup/telephone_pre?telephone=%@&verifycode=%@",Baseurl,newTele.contentTextField.text,inputNumberView.contentTextField.text];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"reponson===%@",source);
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"res===%d",res);
        if (res == 0) {
            
        }else{
            [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败");
    }];
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

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateMobile:(NSString *)mobile
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
