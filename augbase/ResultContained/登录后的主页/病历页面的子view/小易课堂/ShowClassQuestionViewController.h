//
//  ShowClassQuestionViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/21.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowClassQuestionViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) NSString *url;//传入的页面url

@end
