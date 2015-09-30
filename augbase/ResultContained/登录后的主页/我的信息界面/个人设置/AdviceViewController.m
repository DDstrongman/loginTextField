//
//  AdviceViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "AdviceViewController.h"

@interface AdviceViewController ()

@end

@implementation AdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)sendAdvice:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupView{
    self.title = NSLocalizedString(@"意见反馈", @"");
    self.view.backgroundColor = grayBackgroundLightColor;
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 44)];
    firstLabel.backgroundColor = grayBackgroundLightColor;
    firstLabel.font = [UIFont systemFontOfSize:14.0];
    firstLabel.text = NSLocalizedString(@"您的意见对我们非常的重要", @"");
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth/2-150/2, 144+20, 150, 40)];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.numberOfLines = 2;
    secondLabel.backgroundColor = grayBackgroundLightColor;
    secondLabel.font = [UIFont systemFontOfSize:14.0];
    secondLabel.text = NSLocalizedString(@"也可以把您的意见和建议发到我们的小易邮箱", @"");
    UILabel *thirdLable = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth/2-150/2, 144+20+40+12, 150, 22)];
    thirdLable.backgroundColor = grayBackgroundLightColor;
    thirdLable.textColor = themeColor;
    thirdLable.text = YizhenEmail;
    thirdLable.textAlignment = NSTextAlignmentCenter;
    thirdLable.font = [UIFont systemFontOfSize:12.0];
    UITextView *inputText = [[UITextView alloc]initWithFrame:CGRectMake(0, 44, ViewWidth, 100)];
    inputText.font = [UIFont systemFontOfSize:14.0];
    
    [self.view addSubview:firstLabel];
    [self.view addSubview:secondLabel];
    [self.view addSubview:thirdLable];
    [self.view addSubview:inputText];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [confirmButton setTitle:NSLocalizedString(@"发送", @"") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(sendAdvice:) forControlEvents:UIControlEventTouchUpInside];
    [[SetupView ShareInstance] setupNavigationRightButton:self RightButton:confirmButton];
}

-(void)setupData{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SetupView ShareInstance] setupNavigationRightButton:self RightButton:nil];
}

@end
