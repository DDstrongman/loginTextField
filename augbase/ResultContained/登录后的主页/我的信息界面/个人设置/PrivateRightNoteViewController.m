//
//  PrivateRightNoteViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "PrivateRightNoteViewController.h"

@interface PrivateRightNoteViewController ()

@end

@implementation PrivateRightNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)setupView{
    self.title = NSLocalizedString(@"隐私条款", @"");
    self.view.backgroundColor = grayBackColor;
    _openUrl = [[UIWebView alloc] init];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.yizhenapp.com/privacy.html"]];
    [_openUrl loadRequest:request];
    [self.view addSubview: _openUrl];
    [_openUrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
}

-(void)setupData{
    
}

@end
