//
//  FirstTimeUserInfoViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewLabelTextFieldView.h"

@interface FirstTimeUserInfoViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) IBOutlet UIImageView *userImageView;
@property (nonatomic,strong) UIImageView *cameraImageView;

@property (nonatomic,strong) ImageViewLabelTextFieldView *nameView;
@property (nonatomic,strong) ImageViewLabelTextFieldView *sexView;
@property (nonatomic,strong) ImageViewLabelTextFieldView *ageView;

@property (nonatomic,strong) UIButton *finishRegistButton;

@property (nonatomic) BOOL isBlindWeChat;
@property (nonatomic,strong) NSString *unID;//微信授权id
@property (nonatomic,strong) NSData *headImageData;//微信返回头像数据流

@end
