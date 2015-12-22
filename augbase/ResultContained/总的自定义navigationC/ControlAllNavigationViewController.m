//
//  ControlAllNavigationViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/17.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "ControlAllNavigationViewController.h"

#import "OcrTextResultViewController.h"

@interface ControlAllNavigationViewController ()

@end

@implementation ControlAllNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown;
}

- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[OcrTextResultViewController class]]) { // 如果是这个 vc 则支持自动旋转
        return YES;
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
