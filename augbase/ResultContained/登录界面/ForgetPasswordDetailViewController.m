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
    _registViewTwo = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 129, ViewWidth-120+12, 50)];
    _registViewThree = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 184, ViewWidth-120+12, 50)];
    
    _registViewOne.contentTextField.placeholder = NSLocalizedString(@"手机号码", @"");
    _registViewTwo.contentTextField.placeholder = NSLocalizedString(@"验证码（4位）", @"");
    _registViewThree.contentTextField.placeholder = NSLocalizedString(@"密码(至少6位)", @"");
    
    _registViewTwo.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    _registViewTwo.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    _registViewThree.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    _registViewThree.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_registViewTwo.contentTextField addTarget:self action:@selector(ensureMessAndPass) forControlEvents:UIControlEventEditingChanged];
    [_registViewThree.contentTextField addTarget:self action:@selector(ensureMessAndPass) forControlEvents:UIControlEventEditingChanged];
    
    
    _finishButton = [[UIButton alloc]init];
    [_finishButton addTarget:self action:@selector(finishRegist) forControlEvents:UIControlEventTouchUpInside];
    [_finishButton setTitle:NSLocalizedString(@"注册", @"") forState:UIControlStateNormal];
    [_finishButton.layer setMasksToBounds:YES];
    [_finishButton.layer setCornerRadius:10.0];
    
    UIButton *privateNoticeButton = [[UIButton alloc]init];
    [privateNoticeButton setTitle:NSLocalizedString(@"<隐私条款>", @"") forState:UIControlStateNormal];
    [privateNoticeButton setTitleColor:themeColor forState:UIControlStateNormal];
    privateNoticeButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    UILabel  *noticeLabel = [[UILabel alloc]init];
    noticeLabel.text = NSLocalizedString(@"点击注册，表示您同意", @"");
    noticeLabel.font = [UIFont systemFontOfSize:11.0];
    noticeLabel.textColor = grayLabelColor;
    
    [self.view addSubview:_registViewOne];
    [self.view addSubview:_registViewTwo];
    [self.view addSubview:_registViewThree];
    [self.view addSubview:_finishButton];
    
    //autolayout
    [_finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(_registViewThree.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];

}
#pragma 跳转注册完后的界面,但是不是直接跳入showallmessage界面，而是引导到第一次登录加好友界面
-(void)finishRegist{
#warning 加入注册网络通讯
    //    NSString *url = [NSString stringWithFormat:@"%@user/signup/telephone_pre?telephone=%@&verifycode=%@",Baseurl,_registViewOne.contentTextField.text,_registViewTwo.contentTextField.text];
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
    //            UIViewController *ftui = [story instantiateViewControllerWithIdentifier:@"firsttimeuserinfo"];
    //            [self.navigationController pushViewController:ftui animated:YES];
    //        }
    //        else{
    //
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"WEB端登录失败");
    //    }];
#warning 正式版本中使用上方代码
    
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
