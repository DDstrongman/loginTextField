//
//  YizhenWebViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/19.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YizhenWebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) NSString *personName;

@property (nonatomic,strong) NSString *url;//传入的页面url

@end
