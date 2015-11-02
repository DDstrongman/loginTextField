//
//  MyNoteViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MyNoteViewController.h"

#import "SetupView.h"


@interface MyNoteViewController ()

{
    UITextView *inputText;
}

@end

@implementation MyNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)saveNote:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if (inputText.text.length>320) {
        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"不能输入超过320字", @"") Title:NSLocalizedString(@"您的签名太长", @"") ViewController:self];
    }else{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@v2/user/generalInfo?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:inputText.text forKey:@"introduction"];
        [[HttpManager ShareInstance]AFNetPOSTNobodySupport:url Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            NSLog(@"res===%d",res);
            if (res == 0) {
                [user setObject:inputText.text forKey:@"userNote"];
                [_changeDele changeNote:YES];
                NSLog(@"修改签名完成");
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

-(void)setupView{
    self.title = NSLocalizedString(@"个性签名", @"");
    self.view.backgroundColor = grayBackgroundLightColor;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ViewWidth, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = lightGrayBackColor.CGColor;
    backView.layer.borderWidth = 0.5;
    [self.view addSubview:backView];
    inputText = [[UITextView alloc]initWithFrame:CGRectMake(15, 0, ViewWidth-30, 100)];
    inputText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNote"];
    inputText.font = [UIFont systemFontOfSize:14.0];
    [backView addSubview:inputText];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [confirmButton setTitle:NSLocalizedString(@"保存", @"") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(saveNote:) forControlEvents:UIControlEventTouchUpInside];
    [[SetupView ShareInstance] setupNavigationRightButton:self RightButton:confirmButton];
}

-(void)setupData{
    
}

@end
