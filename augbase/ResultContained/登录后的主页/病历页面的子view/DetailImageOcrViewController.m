//
//  DetailImageOcrViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "DetailImageOcrViewController.h"

@interface DetailImageOcrViewController ()

@end

@implementation DetailImageOcrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
    if (_ResultOrING) {
        [_rightButton setTitle:NSLocalizedString(@"删除", @"") forState:UIControlStateNormal];
    }else{
        [_rightButton setTitle:NSLocalizedString(@"放弃识别", @"") forState:UIControlStateNormal];
    }
    [_rightButton addTarget:self action:@selector(deleteResult) forControlEvents:UIControlEventTouchUpInside];
//    //暂时设为固定的原始报告，以后有需要可以设为传入的string
//    _leftTitle = NSLocalizedString(@"原始报告", @"");
//    [_leftButton setTitle:_leftTitle forState:UIControlStateNormal];
    //    [_leftButton addTarget:self action:@selector(leftPop) forControlEvents:UIControlEventTouchUpInside];
    //    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_leftButton]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightButton]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    _showImageView.image = _showImage;
}

#pragma 不同响应函数
-(void)deleteResult{
    NSLog(@"添加删除结果函数");
    UIAlertView *deleteAlert;
    if (_ResultOrING) {
        deleteAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"删除会被扣除积分", @"") message:NSLocalizedString(@"积分可以～～～～～", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"删除", @"") otherButtonTitles:NSLocalizedString(@"取消", @""), nil];
    }else{
        deleteAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"放弃识别会被扣除积分", @"") message:NSLocalizedString(@"积分可以～～～～～", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"放弃", @"") otherButtonTitles:NSLocalizedString(@"取消", @""), nil];
    }
    [deleteAlert show];
}

#pragma UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
#warning 添加确定的网络交互
        NSLog(@"确定");
    }else{
#warning 添加取消的网络交互
        NSLog(@"取消");
    }
}

-(void)viewWillAppear:(BOOL)animated{
}

@end
