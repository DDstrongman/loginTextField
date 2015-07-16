//
//  ImageViewLabelTextFieldView.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/8.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ImageViewLabelTextFieldView.h"

@implementation ImageViewLabelTextFieldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.clearsContextBeforeDrawing = YES;
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(0, 0, 200, 20);
        _titleLabel.center = CGPointMake(_titleLabel.frame.size.width/2+12, _titleLabel.frame.size.height/2);
        _titleLabel.font = [UIFont systemFontOfSize:11.0];
        _titleLabel.hidden = YES;
        [self addSubview:_titleLabel];
        
        _contentTextField = [[UITextField alloc]init];
        
//        _contentTextField.layer.borderWidth = 0.5;
//        _contentTextField.layer.borderColor = themeColor.CGColor;
        
        _contentTextField.frame = CGRectMake(0, 0, self.frame.size.width-12, 30);
        _contentTextField.center = CGPointMake((self.frame.size.width-12)/2+12, (self.frame.size.height-_contentTextField.frame.size.height)+_contentTextField.frame.size.height/2);
        _contentTextField.font = [UIFont systemFontOfSize:17.0];
        _contentTextField.delegate = self;
        _contentTextField.placeholder = NSLocalizedString(@"请输入xxx", @"");        [self addSubview:_contentTextField];
        
//        [_contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(@0);
//            make.height.equalTo(@50);
//            make.left.equalTo(@12);
//            make.right.equalTo(@0);
//        }];
        
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.frame = CGRectMake(0, 0, 7, 16);
        _arrowImageView.center = CGPointMake(_arrowImageView.frame.size.width/2, (self.frame.size.height-_contentTextField.frame.size.height)+_contentTextField.frame.size.height/2);
        _arrowImageView.image = [UIImage imageNamed:@"cursor"];
        
        [self addSubview:_arrowImageView];
        
        
        _arrowImageView.hidden = YES;
        
        _animatedOrNot = YES;
        
        /********************自动布局样例***************/
//        UIEdgeInsets padding = UIEdgeInsetsMake(10, 5, 10, 10);
        
//        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@7);
//            make.height.equalTo(@16);
//            make.left.equalTo(@0);
//            make.right.equalTo(_contentTextField.mas_left).with.offset(-5);
//            make.centerY.mas_equalTo(_contentTextField.mas_centerY);
        //        }];
        /********************自动布局样例***************/
    }
    return self;
}

#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _arrowImageView.hidden = NO;
    [self moveView:_arrowImageView];
    _titleLabel.textColor = themeColor;
    if (_contentTextField.placeholder.length >0) {
        _titleLabel.text = _contentTextField.placeholder;
        [self showTitle:_titleLabel];
        _contentTextField.placeholder = nil;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _arrowImageView.hidden = YES;
    if (_contentTextField.text.length == 0) {
        _titleLabel.hidden = YES;
        _contentTextField.placeholder = _titleLabel.text;
    }else{
        _titleLabel.textColor = grayLabelColor;
    }
}

#pragma 上方titlelabel逐渐显现效果
-(void)showTitle:(UIView *)view{
    view.hidden = NO;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    [view pop_addAnimation:anim forKey:@"fade"];
}

#pragma 箭头运动效果
-(void)moveView:(UIView *)view{
        POPSpringAnimation *anim = [POPSpringAnimation animation];
        anim.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    //    if (animated) {
    //        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 44, ViewWidth/2,ViewHeight-44)];
    //    }
    
    //    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
        if (_animatedOrNot) {
            anim.toValue = [NSValue valueWithCGRect:CGRectMake(5,35,_arrowImageView.bounds.size.width,_arrowImageView.bounds.size.height)];
        }else{
            anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,35,_arrowImageView.bounds.size.width,_arrowImageView.bounds.size.height)];
        }
    
    //    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
        _animatedOrNot = !_animatedOrNot;
        anim.velocity = [NSValue valueWithCGRect:_arrowImageView.frame];
        anim.springBounciness = 5.0;
        anim.springSpeed = 10;
    
        anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self moveView:_arrowImageView];
            }
        };
        
        [_arrowImageView pop_addAnimation:anim forKey:@"slider"];
}

@end
