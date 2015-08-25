//
//  OcrDetailResultLabelTableViewCell.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/12.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "OcrDetailResultLabelTableViewCell.h"

@implementation OcrDetailResultLabelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 60,19)];
        _timeLabel.center = CGPointMake(self.frame.size.width/2-10, self.center.y);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_timeLabel];
    }
    return self;
}

@end
