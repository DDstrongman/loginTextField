//
//  detailViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/6/29.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"详细情况", @"");
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320, 400)];
    _titleLabel.center = CGPointMake(self.view.frame.size.width/2, 300);
    _titleLabel.backgroundColor = [UIColor orangeColor];
    _titleLabel.text = _titleText;
    [self.view addSubview:_titleLabel];
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

@end
