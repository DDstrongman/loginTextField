//
//  Cell1.m
//  xhzd
//
//  Created by jt4 on 15/4/13.
//  Copyright (c) 2015年 ビ ダイイ. All rights reserved.
//

#import "Cell1.h"

@implementation Cell1

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame),  CGRectGetHeight(self.frame))];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        self.descriptionText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)/16*15, CGRectGetHeight(self.frame)/4)];
        self.descriptionText.center=CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/4*3);
        self.descriptionText.adjustsFontSizeToFitWidth=YES;
        self.descriptionText.textAlignment = NSTextAlignmentLeft;
        self.descriptionText.numberOfLines=4;
        self.descriptionText.font=[UIFont fontWithName:@"HiraMinProN-W6" size:10.0f];
        self.descriptionText.textColor=[UIColor whiteColor];
        self.descriptionText.backgroundColor=[UIColor clearColor];
        [self addSubview:self.descriptionText];
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[UIColor grayColor].CGColor;
        
        self.titleText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)/8*5, CGRectGetHeight(self.frame)/8)];
        self.titleText.center=CGPointMake(CGRectGetWidth(self.frame)/8*5, CGRectGetHeight(self.frame)/16*15);
        self.titleText.adjustsFontSizeToFitWidth=YES;
        self.titleText.textAlignment = NSTextAlignmentRight;
        self.titleText.numberOfLines=1;
        self.titleText.font=[UIFont fontWithName:@"HiraKakuProN-W6" size:10.0f];
        self.titleText.textColor=[UIColor whiteColor];
        self.titleText.backgroundColor=[UIColor clearColor];
        [self addSubview:self.titleText];
    }
    return self;
}

@end
