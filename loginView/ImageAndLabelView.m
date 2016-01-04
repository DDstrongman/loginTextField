//
//  ImageAndLabelView.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/17.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "ImageAndLabelView.h"

@implementation ImageAndLabelView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.width, self.bounds.size.width, self.bounds.size.height-self.bounds.size.width)];
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleImageView];
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
