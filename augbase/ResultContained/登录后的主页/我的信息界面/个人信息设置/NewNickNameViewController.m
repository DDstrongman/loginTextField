//
//  NewNickNameViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "NewNickNameViewController.h"

@interface NewNickNameViewController ()

@end

@implementation NewNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)editNickName:(UIButton *)sender{
    if (_editNickName.contentTextField.text.length >0) {
        NSString *url = [NSString stringWithFormat:@"%@/user/updatenickname",Baseurl];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&nickname=%@",url,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],_editNickName.contentTextField.text];
        [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resource = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res = [[resource objectForKey:@"res"] intValue];
            if (res == 0) {
                [user setObject:_editNickName.contentTextField.text forKey:@"userNickName"];
                [_editResultDele editNickNameResult:YES];
            }else{
                [_editResultDele editNickNameResult:NO];
                UIAlertView *showNotice = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"网络错误", @"") message:NSLocalizedString(@"网络错误", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
                [showNotice show];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_editResultDele editNickNameResult:NO];
            UIAlertView *showNotice = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"网络错误", @"") message:NSLocalizedString(@"网络错误", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
            [showNotice show];
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *showNotice = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"请输入新昵称", @"") message:NSLocalizedString(@"新昵称不能为空", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [showNotice show];
    }
}

-(void)setupView{
    self.title = NSLocalizedString(@"修改昵称", @"");
    self.view.backgroundColor = grayBackgroundLightColor;
    _editNickName = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(10, 25, ViewWidth-20, 50)];
    _editNickName.backgroundColor = [UIColor whiteColor];
    _editNickName.contentTextField.placeholder = NSLocalizedString(@"请输入新的昵称", @"");
    [_editNickName.contentTextField becomeFirstResponder];
    [self.view addSubview:_editNickName];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [confirmButton setTitle:NSLocalizedString(@"保存", @"") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(editNickName:) forControlEvents:UIControlEventTouchUpInside];
    [[SetupView ShareInstance]setupNavigationRightButton:self RightButton:confirmButton];
}

-(void)setupData{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SetupView ShareInstance]setupNavigationRightButton:self RightButton:nil];
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
