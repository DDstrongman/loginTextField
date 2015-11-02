//
//  ShowWebviewViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/13.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ShowWebviewViewController.h"

@interface ShowWebviewViewController ()

@end

@implementation ShowWebviewViewController

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
    if (_isClassOrNot) {
        self.title = NSLocalizedString(@"百科", @"");
    }else{
        self.title = NSLocalizedString(@"资讯详情", @"");
    }
}

@end
