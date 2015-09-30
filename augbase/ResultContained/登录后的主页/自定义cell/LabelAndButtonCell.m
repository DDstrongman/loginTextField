//
//  LabelAndButtonCell.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/9/23.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "LabelAndButtonCell.h"

@implementation LabelAndButtonCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50,50)];
        self.iconImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.iconImageView imageWithRound];
        [self addSubview:self.iconImageView];
        
        self.titleText = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, ViewWidth-70-100, 20)];
        self.titleText.textAlignment = NSTextAlignmentLeft;
        self.titleText.numberOfLines = 1;
        self.titleText.font = [UIFont systemFontOfSize:15.0f];
        self.titleText.textColor = [UIColor blackColor];
        self.titleText.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleText];
    }
    return self;
}

@end
