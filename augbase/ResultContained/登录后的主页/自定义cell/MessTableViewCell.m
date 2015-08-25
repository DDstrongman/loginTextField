//
//  MessTableViewCell.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/13.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MessTableViewCell.h"

@implementation MessTableViewCell

@synthesize titleText;
@synthesize descriptionText;
@synthesize iconImageView;
@synthesize timeText;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50,50)];
        self.iconImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.iconImageView imageWithRound];
        [self addSubview:self.iconImageView];
        
        self.descriptionText=[[UILabel alloc] initWithFrame:CGRectMake(70, 37, ViewWidth-70-30, 15)];
//        self.descriptionText.center=CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/4*3);
        self.descriptionText.adjustsFontSizeToFitWidth=YES;
        self.descriptionText.textAlignment = NSTextAlignmentLeft;
        self.descriptionText.numberOfLines=1;
        self.descriptionText.font=[UIFont systemFontOfSize:13.0f];
        self.descriptionText.textColor =  grayLabelColor;
        self.descriptionText.backgroundColor=[UIColor clearColor];
        [self addSubview:self.descriptionText];
        
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [UIColor grayColor].CGColor;
        
        self.titleText=[[UILabel alloc] initWithFrame:CGRectMake(70, 15, ViewWidth-70-100, 20)];
//        self.titleText.center=CGPointMake(CGRectGetWidth(self.frame)/8*5, CGRectGetHeight(self.frame)/16*15);
        self.titleText.adjustsFontSizeToFitWidth=YES;
        self.titleText.textAlignment = NSTextAlignmentLeft;
        self.titleText.numberOfLines=1;
        self.titleText.font=[UIFont systemFontOfSize:15.0f];
        self.titleText.textColor=[UIColor blackColor];
        self.titleText.backgroundColor=[UIColor clearColor];
        [self addSubview:self.titleText];
        
        
        self.timeText = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth-70, 15, 60, 15)];
        self.timeText.text = @"19:00";
        self.timeText.adjustsFontSizeToFitWidth=YES;
        self.timeText.textAlignment = NSTextAlignmentRight;
        self.timeText.numberOfLines=1;
        self.timeText.font = [UIFont  systemFontOfSize:13.0];
        self.timeText.textColor = grayLabelColor;
        self.timeText.backgroundColor=[UIColor clearColor];
        [self addSubview:self.timeText];
    }
    return self;
}

@end
