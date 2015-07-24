//
//  CurrentileCell.m
//  Yizhen-2.28
//
//  Created by ramy on 14-3-8.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import "CurrentileCell.h"

@implementation CurrentileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.mylabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 14.5, 200, 16)];
        self.mylabel.backgroundColor=[UIColor clearColor];
        self.mylabel.textColor=colorRGBA4;
        [self.mylabel setFont:[UIFont systemFontOfSize:16]];
        
        [self.contentView addSubview:self.mylabel];
        
        //top, left, bottom, right
        
        self.mybtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.mybtn.frame=CGRectMake(286, 7.5, 30, 30);
        self.mybtn.imageEdgeInsets=UIEdgeInsetsMake(8, 8, 8, 8);
        
        [self.mybtn setImage:[UIImage imageNamed:@"深灰色加号"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.mybtn];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
