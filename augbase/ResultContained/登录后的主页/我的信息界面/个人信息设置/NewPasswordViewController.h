//
//  NewPasswordViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageViewLabelTextFieldView.h"

@interface NewPasswordViewController : UIViewController

@property (nonatomic,strong) ImageViewLabelTextFieldView *oldPass;
@property (nonatomic,strong) ImageViewLabelTextFieldView *editPass;
@property (nonatomic,strong) ImageViewLabelTextFieldView *confirmPass;

@end
