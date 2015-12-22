//
//  RootGuideViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/9/30.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "RootGuideViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface RootGuideViewController ()

{
    UIPageControl *myPageControl;
}

@end

@implementation RootGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)skipGuide:(UIButton *)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginview"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = [[ControlAllNavigationViewController alloc] initWithRootViewController:loginViewController];
}

-(void)setupView{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    _guideScroller = [[UIScrollView alloc]init];
    _guideScroller.delegate = self;
    _guideScroller.contentSize = CGSizeMake(ViewWidth*3, 5);
    _guideScroller.pagingEnabled = YES;
    _guideScroller.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_guideScroller];
    NSMutableArray *remindArray = [@[NSLocalizedString(@"完美整理病情历史", @""),NSLocalizedString(@"根据病历找相似好友", @""),NSLocalizedString(@"和医生岁时保持沟通", @"")]mutableCopy];
    for (int i = 0; i< 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 1.设置frame
        imageView.frame = CGRectMake(i * ViewWidth, 0, ViewWidth, ViewWidth);
        // 2.设置图片
        NSString *imgName = [NSString stringWithFormat:@"hydy%d", i + 1];
        imageView.image = [UIImage imageNamed:imgName];
        [_guideScroller addSubview:imageView];
        UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*ViewWidth, ViewWidth+20, ViewWidth, 20)];
        remindLabel.text = remindArray[i];
        remindLabel.font = [UIFont systemFontOfSize:20.0];
        remindLabel.textAlignment = NSTextAlignmentCenter;
        [_guideScroller addSubview:remindLabel];
    }
    NSNumber *height = [NSNumber numberWithFloat:(ViewWidth+60)];
    myPageControl = [[UIPageControl alloc]init];
    myPageControl.numberOfPages = 3;
    myPageControl.currentPage = 0;
    myPageControl.enabled = NO;
    myPageControl.pageIndicatorTintColor = lightGrayBackColor;
    myPageControl.currentPageIndicatorTintColor = grayLabelColor;
    [self.view addSubview:myPageControl];
    UIButton *skipButton = [[UIButton alloc]init];
    [skipButton setTitle:NSLocalizedString(@"登录/注册",@"") forState:UIControlStateNormal];
    [skipButton setTitleColor:themeColor forState:UIControlStateNormal];
    [skipButton viewWithRadis:10.0];
    [skipButton addTarget:self action:@selector(skipGuide:) forControlEvents:UIControlEventTouchUpInside];
    skipButton.layer.borderColor = themeColor.CGColor;
    skipButton.layer.borderWidth = 0.5;
    [self.view addSubview:skipButton];
    [skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.right.equalTo(@-60);
        make.top.mas_equalTo(myPageControl.mas_bottom).with.offset(10);
        make.height.equalTo(@50);
        make.bottom.equalTo(@-20);
    }];
    [myPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.right.equalTo(@-60);
        make.height.equalTo(@12);
        make.bottom.mas_equalTo(skipButton.mas_top).with.offset(-10);
    }];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"userPhone"] isEqualToString:@"iPhone 6 Plus"]) {
        [_guideScroller mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.mas_equalTo(myPageControl.mas_bottom).with.offset(-120);
            make.height.equalTo(height);
        }];
    }else if ([[user objectForKey:@"userPhone"] isEqualToString:@"iPhone 5"]||[[user objectForKey:@"userPhone"] isEqualToString:@"iPhone 5C"]||[[user objectForKey:@"userPhone"] isEqualToString:@"iPhone 5S"]){
        [_guideScroller mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.mas_equalTo(myPageControl.mas_bottom).with.offset(-35);
            make.height.equalTo(height);
        }];
    }else if ([[user objectForKey:@"userPhone"] isEqualToString:@"iPhone 6"]){
        [_guideScroller mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.mas_equalTo(myPageControl.mas_bottom).with.offset(-50);
            make.height.equalTo(height);
        }];
    }else{
        _guideScroller.frame = CGRectMake(0, 0, ViewWidth, ViewWidth+60);
    }
}

-(void)setupData{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int PageNumber = (int)scrollView.contentOffset.x/ViewWidth;
    myPageControl.currentPage = PageNumber;
    if (scrollView.contentOffset.x>ViewWidth*2+20) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"loginview"];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

@end
