//
//  ConfirmPictureResultViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/27.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ConfirmPictureResultViewController.h"
#import "XMPPSupportClass.h"

@interface ConfirmPictureResultViewController ()

@end

@implementation ConfirmPictureResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _resultImageView.image = _resultImage;
    _bottomTabBar.backgroundColor = themeColor;
    _bottomTabBar.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

#pragma tabbarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            [self.navigationController popViewControllerAnimated:YES];
#warning 同时加入异步上传拍摄图片的网络响应
            NSLog(@"需要加入异步上传图片的功能");
        }
            break;
        case 3:
        {
            NSLog(@"画上马赛克");
        }
            break;
        case 4:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
#warning 同时加入异步上传拍摄图片的网络响应
            NSLog(@"需要加入异步上传图片的功能");
            [[XMPPSupportClass ShareInstance] uploadPicture:_resultImage];
        }
            break;
        default:
            break;
    }
}

@end
