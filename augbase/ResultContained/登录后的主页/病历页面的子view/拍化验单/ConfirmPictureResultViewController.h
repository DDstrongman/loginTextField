//
//  ConfirmPictureResultViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/27.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPictureResultViewController : UIViewController<UITabBarDelegate>

@property (nonatomic,strong) IBOutlet UIImageView *resultImageView;
@property (nonatomic,strong) IBOutlet UITabBar *bottomTabBar;

@property (nonatomic,strong)  UIImage *resultImage;


@end
