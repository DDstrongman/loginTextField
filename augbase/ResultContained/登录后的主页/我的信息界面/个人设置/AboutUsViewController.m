//
//  AboutUsViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "AboutUsViewController.h"

#import "SetupView.h"
#import "WXApi.h"

//#import <TencentOpenAPI/QQApiInterface.h>       //QQ互联 SDK
//#import <TencentOpenAPI/TencentOAuth.h>

@interface AboutUsViewController ()

{
    UIView *shareView;//底部分享view
    UIView *visualEffectView;//阴影view
    
    NSString *shareUrl;
    
    BOOL showShareView;//是否显示了分享界面
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)setupView{
    self.title = NSLocalizedString(@"关于我们", @"");
    self.view.backgroundColor = grayBackColor;
    _openUrl = [[UIWebView alloc] init];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.yizhenapp.com/dashengguilai/dist/whatIsYizhen_patient.html"]];
    [_openUrl loadRequest:request];
    [self.view addSubview: _openUrl];
    [_openUrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    UIButton *shareRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [shareRightButton setImage:[UIImage imageNamed:@"friends_set"] forState:UIControlStateNormal];
    shareRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [shareRightButton addTarget:self action:@selector(shareUs:) forControlEvents:UIControlEventTouchUpInside];
    [[SetupView ShareInstance]setupNavigationRightButton:self RightButton:shareRightButton];
    [self setupShareView];
}

-(void)setupShareView{
    shareView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 175)];
    shareView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *shareScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, shareView.bounds.size.width, 95)];
    shareScroller.contentSize = CGSizeMake(shareView.bounds.size.width+50, 95);
    [shareView addSubview:shareScroller];
    
    if ([WXApi isWXAppInstalled]&& [WXApi isWXAppSupportApi]) {
        UIButton *shareWeChatButton = [[UIButton alloc]init];
        [shareWeChatButton setBackgroundImage:[UIImage imageNamed:@"wechat_friend"] forState:UIControlStateNormal];
        [shareWeChatButton setTitle:NSLocalizedString(@"微信好友", @"") forState:UIControlStateNormal];
        [shareWeChatButton addTarget:self action:@selector(shareWechatFriend:) forControlEvents:UIControlEventTouchUpInside];
        shareWeChatButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareWeChatButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        shareWeChatButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        shareWeChatButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        [shareWeChatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        [shareWeChatButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
        shareWeChatButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        UIButton *shareWeChatGroupButton = [[UIButton alloc]init];
        [shareWeChatGroupButton setBackgroundImage:[UIImage imageNamed:@"friend_quan"] forState:UIControlStateNormal];
        [shareWeChatGroupButton addTarget:self action:@selector(shareWechatGroup:) forControlEvents:UIControlEventTouchUpInside];
        [shareWeChatGroupButton setTitle:NSLocalizedString(@"朋友圈", @"") forState:UIControlStateNormal];
        shareWeChatGroupButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareWeChatGroupButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        shareWeChatGroupButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        shareWeChatGroupButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        [shareWeChatGroupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        [shareWeChatGroupButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
        shareWeChatGroupButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        UIButton *cancelButton = [[UIButton alloc]init];
        [cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
        cancelButton.layer.borderWidth = 0.5;
        cancelButton.layer.borderColor = [UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0].CGColor;
        [cancelButton viewWithRadis:10.0];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelShare:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:cancelButton];
        [shareScroller addSubview:shareWeChatButton];
        [shareScroller addSubview:shareWeChatGroupButton];
        [self.view addSubview:shareView];
        [shareWeChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.equalTo(@10);
            make.width.equalTo(@57);
            make.height.equalTo(@75);
        }];
        [shareWeChatGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(shareWeChatButton.mas_right).with.offset(20);
            make.top.equalTo(@10);
            make.width.equalTo(@57);
            make.height.equalTo(@75);
        }];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.mas_equalTo(shareScroller.mas_bottom).with.offset(10);
            make.right.equalTo(@-20);
            make.height.equalTo(@50);
        }];
    }else{
        [[SetupView ShareInstance]showAlertViewOneButton:NSLocalizedString(@"您不能使用分享功能", @"") Title:NSLocalizedString(@"您没有安装微信", @"") ViewController:self];
    }
}

-(void)setupData{
    shareUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"874910905"];
    showShareView = NO;
}

-(void)cancelShare:(UIButton *)sender{
    [self popSpringAnimationHidden:shareView];
}

-(void)shareUs:(UIButton *)sender{
    if (!showShareView) {
        [self popOutShareView:shareView];
        showShareView = YES;
    }
}

-(void)shareWechatFriend:(UIButton *)sender{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"战友app";
    message.description = @"";
    [message setThumbImage:[UIImage imageNamed:@"weixinIcon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://www.yizhenapp.com/about.html";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;//WXSceneTimeline
    
    [WXApi sendReq:req];
    [self popSpringAnimationHidden:shareView];
}

-(void)shareWechatGroup:(UIButton *)sender{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"战友app";
    message.description = @"";
    [message setThumbImage:[UIImage imageNamed:@"weixinIcon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://www.yizhenapp.com/about.html";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;//
    
    [WXApi sendReq:req];
    [self popSpringAnimationHidden:shareView];
}

-(void)shareQQFriend:(UIButton *)sender{
//    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"text"];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
//    //将内容分享到qq
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
}

-(void)shareQQZone:(UIButton *)sender{
    
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma 底部view出现和隐藏
-(void)popOutShareView:(UIView *)targetView{
    visualEffectView = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view insertSubview:visualEffectView belowSubview:shareView];
    
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-targetView.bounds.size.height-22-44,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

-(void)tapvisualEffectView:(UIView *)sender{
    [self popSpringAnimationHidden:shareView];
}

-(void)popSpringAnimationHidden:(UIView *)targetView{
    showShareView = NO;
    if (visualEffectView != nil) {
        [visualEffectView removeFromSuperview];
    }
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SetupView ShareInstance]setupNavigationRightButton:self RightButton:nil];
}

@end
