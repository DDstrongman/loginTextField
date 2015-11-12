//
//  SendAddMessViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "SendAddMessViewController.h"

@interface SendAddMessViewController ()

{
    UITextView *inputText;
}

@end

@implementation SendAddMessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"添加好友", @"");
    UIButton *sendMessButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    [sendMessButton setTitle:NSLocalizedString(@"发送", @"") forState:UIControlStateNormal];
    [sendMessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendMessButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sendMessButton addTarget:self action:@selector(sendAddFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendMessButton]];
}

#pragma 添加好友
-(void)sendAddFriend{
    NSLog(@"发送加好友信息");
#warning 此处添加好友需要加入jid判定
    [[XMPPSupportClass ShareInstance] addfriend:_addFriendJID];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)setupView{
    self.view.backgroundColor = grayBackgroundLightColor;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 22, ViewWidth, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = lightGrayBackColor.CGColor;
    backView.layer.borderWidth = 0.5;
    [self.view addSubview:backView];
    inputText = [[UITextView alloc]initWithFrame:CGRectMake(15, 0, ViewWidth-30, 100)];
    inputText.text = [NSString stringWithFormat:@"我是%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userNickName"]];
    inputText.font = [UIFont systemFontOfSize:14.0];
    [backView addSubview:inputText];
}

-(void)setupData{
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationItem setRightBarButtonItem:nil];
}

@end
