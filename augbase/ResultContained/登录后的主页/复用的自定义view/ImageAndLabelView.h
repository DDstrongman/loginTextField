//
//  ImageAndLabelView.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/17.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 初始化此view的时候的frame需要同时考虑imageview的宽度和高度,view的高要比宽大，以计算下方label的高度。一般情况下imageview的宽度即为view的宽度，高度和宽相等。label高度为view的高减去宽
 */
@interface ImageAndLabelView : UIView

@property (nonatomic,strong)UIImageView *titleImageView;//显示图片的imageview；
@property (nonatomic,strong)UILabel *titleLabel;//显示标题的label

@end
