//
//  ShowClassQuestionViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/21.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "ShowClassQuestionViewController.h"

@interface ShowClassQuestionViewController ()

@end

@implementation ShowClassQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = grayBackgroundLightColor;
    _webView = [[UIWebView alloc] init];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
    [self.view addSubview: _webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"课堂科普", @"");
}

@end
