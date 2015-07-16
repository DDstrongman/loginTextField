//
//  ShowWebviewViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/13.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ShowWebviewViewController.h"

@interface ShowWebviewViewController ()

@end

@implementation ShowWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = grayBackColor;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

@end
