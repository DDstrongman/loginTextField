//
//  ForgetPasswordDetailViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/12.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ForgetPasswordDetailViewController.h"

@interface ForgetPasswordDetailViewController ()

@end

@implementation ForgetPasswordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _registViewOne = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 74, ViewWidth-120+12, 50)];
    
    _registViewOne.contentTextField.placeholder = NSLocalizedString(@"新密码", @"");
    _registViewOne.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_registViewOne.contentTextField addTarget:self action:@selector(ensureMessAndPass:) forControlEvents:UIControlEventEditingChanged];
    
    
    _finishButton = [[UIButton alloc]init];
    [_finishButton addTarget:self action:@selector(finishEdit) forControlEvents:UIControlEventTouchUpInside];
    _finishButton.backgroundColor = grayBackColor;
    _finishButton.userInteractionEnabled = NO;
    [_finishButton setTitle:NSLocalizedString(@"修改", @"") forState:UIControlStateNormal];
    [_finishButton.layer setMasksToBounds:YES];
    [_finishButton.layer setCornerRadius:10.0];
    
    [self.view addSubview:_registViewOne];
    [self.view addSubview:_finishButton];
    
    //autolayout
    [_finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(_registViewOne.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];

}

-(void)ensureMessAndPass:(UITextField *)sender{
    if (sender.text.length>5) {
        _finishButton.userInteractionEnabled = YES;
        _finishButton.backgroundColor = themeColor;
    }else{
        _finishButton.userInteractionEnabled = NO;
        _finishButton.backgroundColor = grayBackColor;
    }
}

#pragma 完成修改密码
-(void)finishEdit{
#warning 加入注册网络通讯
    NSString *url = [NSString stringWithFormat:@"%@v2/user/resetPassword",Baseurl];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_phoneNumber forKey:@"tel"];
    [dic setObject:_confirmNumber forKey:@"smscode"];
    [dic setObject:_registViewOne.contentTextField.text forKey:@"password"];
    [[SetupView ShareInstance]showHUD:self Title:NSLocalizedString(@"修改中...", @"")];
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:url Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"res===%d",res);
        if (res == 0) {
            //请求完成
            [[SetupView ShareInstance]hideHUD];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [[SetupView ShareInstance]hideHUD];
            [[SetupView ShareInstance]showAlertViewOneButton:NSLocalizedString(@"请重新操作", @"") Title:NSLocalizedString(@"修改失败", @"") ViewController:self];

        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
