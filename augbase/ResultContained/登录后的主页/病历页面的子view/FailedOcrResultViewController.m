//
//  FailedOcrResultViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "FailedOcrResultViewController.h"

@interface FailedOcrResultViewController ()

@end

@implementation FailedOcrResultViewController

#pragma 初始化各个信息，需要网络获取失败的原因种类和失败的原因详情
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    [deleteButton setTitle:NSLocalizedString(@"删除", @"") forState:UIControlStateNormal];
//    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [deleteButton setTitleColor:themeColor forState:UIControlStateNormal];
    deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [deleteButton addTarget:self action:@selector(deleteReport) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:deleteButton]];
//    self.navigationItem.
//    [[UINavigationBar appearance] setTintColor:themeColor];
    [self.navigationController.navigationBar setTintColor:themeColor];
    
    
    self.title = NSLocalizedString(@"识别失败", @"");
    
    _failResultImageView.image = _failedImage;
    NSLog(@"此处需要网络获取失败原因种类和详情");
    NSString *failedCategory = @"网络获取中";
    NSString *failedDetail = @"网络获取中";
    _failCategoryText.text = [NSString stringWithFormat:@"无法识别原因:%@",failedCategory];
    _failDetailText.text = [NSString stringWithFormat:@"建议:%@",failedDetail];
    
}

-(void)viewWillAppear:(BOOL)animated{
}

#pragma 此处要添加右侧删除按钮响应函数
-(void)deleteReport{
    NSLog(@"此处要添加右侧删除按钮响应函数");
}


@end
