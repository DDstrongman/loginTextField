//
//  FirstTimeUserInfoViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHPickView.h"
#import "ImageViewLabelTextFieldView.h"

@interface FirstTimeUserInfoViewController : UIViewController<ZHPickViewDelegate>

//@property (nonatomic,strong) IBOutlet UIButton *sexAndAgeButton;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) ZHPickView *pickview;
@property (nonatomic,strong) IBOutlet UIImageView *userImageView;
@property (nonatomic,strong) UIImageView *cameraImageView;

@property (nonatomic,strong) ImageViewLabelTextFieldView *nameView;
@property (nonatomic,strong) ImageViewLabelTextFieldView *sexAndAgeView;

@property (nonatomic,strong) UIButton *finishRegistButton;

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userPass;



@end
