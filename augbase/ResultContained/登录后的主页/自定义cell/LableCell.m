//
//  LableCell.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/6.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "LableCell.h"

@implementation LableCell

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[UIColor grayColor].CGColor;
        
        self.titleText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        self.titleText.center=CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
//        self.titleText.adjustsFontSizeToFitWidth=YES;
        self.titleText.textAlignment = NSTextAlignmentCenter;
        self.titleText.numberOfLines=1;
        self.titleText.font=[UIFont systemFontOfSize:14.0];
        self.titleText.textColor=[UIColor blackColor];
        self.titleText.backgroundColor=[UIColor clearColor];
        [self addSubview:self.titleText];
    }
    return self;
}

@end
