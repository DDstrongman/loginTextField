//
//  ShowWebviewViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/13.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowWebviewViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) NSString *url;//传入的页面url

@property (nonatomic) BOOL isClassOrNot;//是科普还是百科

@end
