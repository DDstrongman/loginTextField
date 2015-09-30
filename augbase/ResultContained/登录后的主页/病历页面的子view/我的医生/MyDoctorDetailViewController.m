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
    _nameLabel.text = [_doctorDic objectForKey:@"nickname"];
    _hospitalLabel.text = [_doctorDic objectForKey:@"hosname"];
    _doctorDetalLabel.text = [_doctorDic objectForKey:@"detail"];
    NSString *url = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/doctor/%@",[_doctorDic objectForKey:@"avatar"]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_titleImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"test"]];
    [_titleImageView imageWithRound:NO];
    [_addDoctorButton addTarget:self action:@selector(addDoctor:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addDoctor:(UIButton *)sender{
    NSLog(@"跳转添加医生页面");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SendAddDoctorMessViewController *samv = [main instantiateViewControllerWithIdentifier:@"sendadddoctormess"];
    samv.doctorDic = _doctorDic;
    [self.navigationController pushViewController:samv animated:YES];
}

@end
