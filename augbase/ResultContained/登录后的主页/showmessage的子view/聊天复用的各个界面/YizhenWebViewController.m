//
//  YizhenWebViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/19.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "YizhenWebViewController.h"

@interface YizhenWebViewController ()

@end

@implementation YizhenWebViewController

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
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@"xxxx"//占位即可
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = [NSString stringWithFormat:@"%@的识别结果",_personName];
}

@end
