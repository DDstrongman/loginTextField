//
//  MyDoctorDetailViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MyDoctorDetailViewController.h"

#import "SendAddDoctorMessViewController.h"

@interface MyDoctorDetailViewController ()

@end

@implementation MyDoctorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"医生资料", @"");
    _nameLabel.text = _doctorName;
    _hospitalLabel.text = _doctorHospital;
    _doctorDetalLabel.text = _doctorDetail;
    
    [_addDoctorButton addTarget:self action:@selector(addDoctor:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addDoctor:(UIButton *)sender{
    NSLog(@"跳转添加医生页面");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SendAddDoctorMessViewController *samv = [main instantiateViewControllerWithIdentifier:@"sendadddoctormess"];
    [self.navigationController pushViewController:samv animated:YES];
}

@end
