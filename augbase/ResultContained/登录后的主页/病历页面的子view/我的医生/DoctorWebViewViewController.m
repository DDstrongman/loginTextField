//
//  DoctorWebViewViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "DoctorWebViewViewController.h"

@interface DoctorWebViewViewController ()

@end

@implementation DoctorWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)setupView{
    self.view.backgroundColor = grayBackgroundLightColor;
    self.title = NSLocalizedString(@"医生资料", @"");
    _webView = [[UIWebView alloc] init];
    _url = [NSString stringWithFormat:@"%@&uid=%@&token=%@",_url,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
    [self.view addSubview: _webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    NSLog(@"url====%@",_url);
}

-(void)setupData{
    
}

@end
