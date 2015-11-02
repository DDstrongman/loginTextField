//
//  ServiceAndPrivateWebViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/28.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceAndPrivateWebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) NSString *url;//传入的页面url

@property (nonatomic,strong) NSString *WebTitle;//传入的页面title

@end
