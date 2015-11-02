//
//  WebContactDoctorViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/27.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebContactDoctorViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) NSString *url;//传入的页面url

@property (nonatomic,strong) NSString *WebTitle;

@property (nonatomic,strong) UIViewController *popViewController;//

@end
