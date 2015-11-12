//
//  NewPasswordViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "NewPasswordViewController.h"

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface NewPasswordViewController ()

{
    UIButton *confirmButton;//下方确认按钮
}

@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)checkOldPass:(UITextField *)sender{
    if ([sender.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"]]) {
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        sender.rightViewMode = UITextFieldViewModeAlways;
        sender.rightView = rightButton;
        [sender resignFirstResponder];
        [_editPass.contentTextField becomeFirstResponder];
    }else if(sender.text.length <6){
        sender.rightViewMode = UITextFieldViewModeNever;
    }else{
        UIButton *wrongButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        [wrongButton setBackgroundImage:[UIImage imageNamed:@"wrong"] forState:UIControlStateNormal];
        sender.rightViewMode = UITextFieldViewModeAlways;
        sender.rightView = wrongButton;
    }
}

-(void)checkNewPass:(UITextField *)sender{
    if (sender.text.length>5) {
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        sender.rightViewMode = UITextFieldViewModeAlways;
        sender.rightView = rightButton;
    }else{
        sender.rightViewMode = UITextFieldViewModeNever;
    }
}

-(void)reInputNewPass:(UITextField *)sender{
    if (sender.text.length>5&&[sender.text isEqualToString:_editPass.contentTextField.text]) {
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        sender.rightViewMode = UITextFieldViewModeAlways;
        sender.rightView = rightButton;
        
        confirmButton.userInteractionEnabled = YES;
        confirmButton.backgroundColor = themeColor;
    }else if(sender.text.length<6){
        sender.rightViewMode = UITextFieldViewModeNever;
        
        confirmButton.userInteractionEnabled = NO;
        confirmButton.backgroundColor = grayBackColor;
    }else{
        UIButton *wrongButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        [wrongButton setBackgroundImage:[UIImage imageNamed:@"wrong"] forState:UIControlStateNormal];
        sender.rightViewMode = UITextFieldViewModeAlways;
        sender.rightView = wrongButton;
        
        confirmButton.userInteractionEnabled = NO;
        confirmButton.backgroundColor = grayBackColor;
    }
}

-(void)confirmNewPass:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"%@user/edit",Baseurl];
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSString *yzuid = [users objectForKey:@"userUID"];
    
    NSString *yztoken = [users objectForKey:@"userToken"];
    
    url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&password=%@",url,yzuid,yztoken,_editPass.contentTextField.text];
    [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            [users setObject:_editPass.contentTextField.text forKey:@"userPassword"];
            [self loginOut];
            NSLog(@"密码修改成功");
        }else{
            UIAlertView *showMess = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"修改失败", @"") message:NSLocalizedString(@"修改密码失败", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
            [showMess show];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *showMess = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"网络错误", @"") message:NSLocalizedString(@"请检查网络", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [showMess show];
    }];
}

-(void)setupView{
    self.title = NSLocalizedString(@"修改密码", @"");
    self.view.backgroundColor = [UIColor whiteColor];
    _oldPass = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 50, ViewWidth-120+12, 50)];
    _oldPass.contentTextField.placeholder = NSLocalizedString(@"当前密码", @"");
    _oldPass.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_oldPass.contentTextField addTarget:self action:@selector(checkOldPass:) forControlEvents:UIControlEventEditingChanged];
    
    _editPass = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(_oldPass.frame.origin.x,_oldPass.frame.origin.y+50+5,ViewWidth-120+12, 50)];
    _editPass.contentTextField.placeholder = NSLocalizedString(@"请输入新密码", @"");
    _editPass.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_editPass.contentTextField addTarget:self action:@selector(checkNewPass:) forControlEvents:UIControlEventEditingChanged];
    
    _confirmPass = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(_editPass.frame.origin.x,_editPass.frame.origin.y+50+5,ViewWidth-120+12, 50)];
    _confirmPass.contentTextField.placeholder = NSLocalizedString(@"请确认新密码", @"");
    _confirmPass.contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_confirmPass.contentTextField addTarget:self action:@selector(reInputNewPass:) forControlEvents:UIControlEventEditingChanged];
    
    confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(_confirmPass.frame.origin.x+12,_confirmPass.frame.origin.y+50+10,ViewWidth-60*2, 50)];
    [confirmButton addTarget:self action:@selector(confirmNewPass:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:NSLocalizedString(@"完成", @"") forState:UIControlStateNormal];
    confirmButton.userInteractionEnabled = NO;
    confirmButton.backgroundColor = grayBackColor;
    [confirmButton viewWithRadis:10.0];
    [_oldPass.contentTextField becomeFirstResponder];
    [self.view addSubview:_oldPass];
    [self.view addSubview:_editPass];
    [self.view addSubview:_confirmPass];
    [self.view addSubview:confirmButton];
    
    _oldPass.contentTextField.secureTextEntry = YES;
    _editPass.contentTextField.secureTextEntry = YES;
    _confirmPass.contentTextField.secureTextEntry = YES;
    _oldPass.contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _editPass.contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _confirmPass.contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

-(void)setupData{
    
}

-(void)loginOut{
    NSString *deleUrl = [NSString stringWithFormat:@"%@unm/remove?uid=%@&token=%@&clienttype=%d",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],0];
    [[HttpManager ShareInstance]AFNetGETSupport:deleUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"删除成功");
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userUID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userJID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userAddress"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userNickName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userRealName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userImageUrl"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userHttpImageUrl"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userAge"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userGender"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userBMI"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NotFirstTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FriendList"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userTele"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userSystemVersion"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userNote"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userHistoryNote"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userWeChat"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ShowGuide"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userEmail"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userYizhenID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDeviceID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userShareDoctor"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userOpenVoice"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userOpenShake"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userOpenRemind"];
    [[DBManager ShareInstance] closeDB];
    [[FriendDBManager ShareInstance] closeDB];
    [[XMPPSupportClass ShareInstance] disconnect];
#warning 需要加入删除数据库的操作
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginview"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.window.rootViewController = [[RZTransitionsNavigationController alloc] initWithRootViewController:loginViewController];
}

#pragma 滑动scrollview取消输入
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
