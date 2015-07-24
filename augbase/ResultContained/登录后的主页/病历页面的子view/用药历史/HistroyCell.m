//
//  HistroyCell.m
//  Yizhen-2.28
//
//  Created by ramy on 14-3-6.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import "HistroyCell.h"

@implementation HistroyCell
//65
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.namelab=[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 250, 18)];
        self.namelab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.namelab];
        
        
        self.starttime=[[UILabel alloc] initWithFrame:CGRectMake(10, 36, 80, 16)];
        self.starttime.font=[UIFont systemFontOfSize:14];
        
        self.endtime=[[UILabel alloc] initWithFrame:CGRectMake(66, 36, 70, 16)];
        self.endtime.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.starttime];
        [self.contentView addSubview:self.endtime];
        
        //        UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(15, 44, 290, 1)];
        //        lineview.backgroundColor=[UIColor colorWithRed:244.0/255 green:244.0/255  blue:244.0/255  alpha:1];
        //        [self.contentView addSubview:lineview];
        
        
        
        
        
        
        
        self.l2=[[UILabel alloc] initWithFrame:CGRectMake(230, 24.5, 50, 14)];
        self.l2.font=[UIFont systemFontOfSize:14];
        self.l2.text=@"耐药";
        
        
        self.rightview=[[UIImageView alloc] initWithFrame:CGRectMake(285, 21.5, 11, 20)];
        self.rightview.image=[UIImage imageNamed:@"向右222"];
        
        
        [self.contentView addSubview:self.l2];
        [self.contentView addSubview:self.rightview];
        
       
       self.rightview.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        self.namelab.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        self.starttime.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
       self.l2.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        self.endtime.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:[SplitLineView getview:0 andY:62.5 andW:SCREEN_WIDTH]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
