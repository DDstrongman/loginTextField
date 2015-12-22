//
//  RemindCameraViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/19.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "RemindCameraViewController.h"

@interface RemindCameraViewController ()

@end

@implementation RemindCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _guideCameraScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    _guideCameraScroller.delegate = self;
    _guideCameraScroller.contentSize = CGSizeMake(10, ViewHeight*2);
    _guideCameraScroller.pagingEnabled = YES;
    _guideCameraScroller.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_guideCameraScroller];
    for (int i = 0; i< 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 1.设置frame
        imageView.frame = CGRectMake(0, 0, 240, 240);
        imageView.center = CGPointMake(ViewWidth/2, ViewHeight/2+i*ViewHeight);
        // 2.设置图片
        NSString *imgName = [NSString stringWithFormat:@"prompt_%d", i + 1];
        imageView.image = [UIImage imageNamed:imgName];
        [_guideCameraScroller addSubview:imageView];
    }
    [self.view addSubview:_guideCameraScroller];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@YES forKey:@"userRemindCamera"];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>ViewHeight+20) {
        [self.navigationController popViewControllerAnimated:YES];
        [_remindCameraDele RemindCameraResult:YES];
    }else{
        [_remindCameraDele RemindCameraResult:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}

@end
