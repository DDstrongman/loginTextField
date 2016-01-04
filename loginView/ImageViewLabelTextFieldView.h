//
//  ImageViewLabelTextFieldView.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/8.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewLabelTextFieldView : UIView<UITextFieldDelegate>


//主体view
@property (nonatomic,weak) UIView *contentView;
//显示箭头的imageview
@property (nonatomic,strong) UIImageView *arrowImageView;
//显示提示的label
@property (nonatomic,strong) UILabel *titleLabel;
//输入文字的textfield
@property (nonatomic,strong) UITextField *contentTextField;

//field右边的button
@property (nonatomic,strong) UIButton *fieldRightButton;
//判断箭头运动的bool
@property (nonatomic) BOOL animatedOrNot;


@end
